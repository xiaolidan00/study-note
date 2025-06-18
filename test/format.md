---
theme: fancy
highlight: vs
---

行政区块经常用，然而要使用卫星地图时作为行政区块贴图时，通常会让建模师进行处理并结合 3D 模型使用！而且卫星贴图的行政区块一旦需要下钻，还得建模师每个行政区来一份卫星贴图和 3D 模型，建模师工作量倍增。而建模师使用的卫星贴图是手动截取的，与实际行政区块的卫星地图位置上存在一定偏差。
为了减轻建模师的工作，让数据展示更好看，接下来就跟着我学习，如何动态生成位置精确的卫星贴图，让你的行政区块炫酷起来！

![999.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/100bd341164746c6989543f88c0df878~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=1RiCndrjdefaqzAkWijV7cQ%2Bj8o%3D)

# 1. canvas 绘制行政区域的卫星贴图

## 1.1 遍历行政区的 geojson 计算出经纬度范围

```js
export function getGeojsonBound(geojson) {
  const bound = {
    minlng: Number.MAX_SAFE_INTEGER,
    minlat: Number.MAX_SAFE_INTEGER,
    maxlng: 0,
    maxlat: 0
  };
  travelGeo(geojson, (c) => {
    c.forEach((item) => {
      bound.minlng = Math.min(bound.minlng, item[0]);
      bound.minlat = Math.min(bound.minlat, item[1]);
      bound.maxlng = Math.max(bound.maxlng, item[0]);
      bound.maxlat = Math.max(bound.maxlat, item[1]);
    });
  });
  return bound;
}
```

## 1.2 利用墨卡托投影，将经纬度坐标转换成像素坐标

```js
export function getBoundOrigin(bound, z) {
  const start = SphericalMercator.lnglat2px([bound.minlng, bound.minlat], z);

  const end = SphericalMercator.lnglat2px([bound.maxlng, bound.maxlat], z);

  const origin = [Math.min(start[0], end[0]), Math.min(start[1], end[1])];

  const origin1 = [Math.max(start[0], end[0]), Math.max(start[1], end[1])];
  return {
    start: origin,
    end: origin1,
    width: Math.abs(origin1[0] - origin[0]),
    height: Math.abs(origin1[1] - origin[1])
  };
}
```

## 1.3 在 canvas 上绘制行政区的瓦片地图

计算出瓦片索引范围，遍历瓦片索引，通过 image 加载，用 canvas 绘制到对应的位置，形成一片完整的瓦片地图。

```js
const tileSize = 256;
//绘制瓦片到canvas上
async function drawTileImage(ctx, x, y, z, imageX, imageY) {
  const image = await getTileImage(x, y, z);
  ctx.drawImage(image, imageX, imageY);
}

//绘制瓦片地图
export async function drawTileLayer(z, start, end, ctx) {
  // 计算瓦片索引范围
  const bounds = [
    [Math.floor(start[0] / tileSize), Math.floor(start[1] / tileSize)],
    [Math.ceil(end[0] / tileSize), Math.ceil(end[1] / tileSize)]
  ];
  const queue = [];
  //瓦片偏移
  const offset = [bounds[0][0] * tileSize - start[0], bounds[0][1] * tileSize - start[1]];
  //收集需要绘制的瓦片索引和瓦片在canvas上的位置
  for (let x = bounds[0][0], i = 0; x < bounds[1][0]; x++, i++) {
    for (let y = bounds[0][1], j = 0; y < bounds[1][1]; y++, j++) {
      queue.push({
        x,
        y,
        imageX: i * tileSize + offset[0],
        imageY: j * tileSize + offset[1]
      });
    }
  }
  //异步加载图片绘制到canvas上
  for (let i = 0; i < queue.length; i = i + 24) {
    const list = queue.slice(i, i + 24);
    await Promise.all(list.map((a) => drawTileImage(ctx, a.x, a.y, z, a.imageX, a.imageY)));
  }
}
```

**注意**

- 高德卫星地图的瓦片是整块 256x256 的图片，通过像素坐标除以 256 取整算出可视范围内的瓦片索引范围，注意左上点向下取整`Math.floor(start / 256)`，右下点向上取整`Math.ceil(end /256)`。

- 根据地图瓦片大小，可以瓦片所在还原像素坐标位置，那么在墨卡托投影像素坐标的起始位置是`256*tilePos`,落到 canvas 上的位置，则偏移一定距离，`偏移值=瓦片像素坐标-行政区像素坐标的起始点`，那么瓦片在 canvas 的坐标`[i*256+offsetX，j*256+offsetY]`

- 因为瓦片加载可能会阻塞，为了优化性能，利用 http1.1 的同一个域名下 TCP 并发连接数 4-8 个，通常 6 个，加上 4 个域名切换使用，一次性可发起`4*6=24`个请求，接下来要对瓦片索引和位置先收集，再进行异步加载图片绘制到 canvas 上。
- 图片要设置跨域`crossOrigin = '*'`，否则 three.js 绘制贴图的时候绘制失败，一片黑，并报跨域错误。

```js
const cacheTiles = {};
//域名切换
const domain = [1, 2, 3, 4];
let sIndex = 0;
function getTileImage(x, y, z) {
  return new Promise((resolve) => {
    const id = `${x}-${y}-${z}`;
    //缓存瓦片地图
    if (cacheTiles[id]) {
      resolve(cacheTiles[id]);
    } else {
      //加载卫星瓦片地图
      const s = domain[sIndex % domain.length];
      const url = `http://wprd0${s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=6&x=${x}&y=${y}&z=${z}`;
      sIndex++;
      const image = new Image();
      image.src = url;
      image.crossOrigin = '*';
      image.onload = () => {
        cacheTiles[id] = image;
        resolve(image);
      };
    }
  });
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/5d16a2a012aa467986d24d94cb114dec~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=a0LSbue2sExa4rdeg84YC4x7tE8%3D)

这是广州市缩放级别为 10 的卫星地图

## 1.4 绘制行政区轮廓瓦片地图

先绘制该行政区范围内的瓦片地图，然后截取出行政区轮廓内的卫星贴图。

```js
export async function createAreaCanvas(geojson, z, cb) {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  //行政区经纬度范围
  const bound = getGeojsonBound(geojson);
  //墨卡托投影像素坐标，canvas宽高大小
  const {start, end, width, height} = getBoundOrigin(bound, z);
  canvas.width = width;
  canvas.height = height;
  //绘制瓦片地图
  await drawTileLayer(z, start, end, ctx);
  //将经纬度坐标转为墨卡托投影像素坐标，减去行政区范围的起始坐标，即显示在canvas上的坐标
  const lnglat2Canvas = (p) => {
    const a = SphericalMercator.lnglat2px(p, z);
    return [a[0] - start[0], a[1] - start[1]];
  };
  //遍历行政区，绘制轮廓
  ctx.beginPath();
  travelGeo(geojson, (c) => {
    const s = lnglat2Canvas(c[0]);
    ctx.moveTo(s[0], s[1]);
    for (let i = 1; i < c.length; i++) {
      const item = lnglat2Canvas(c[i]);
      ctx.lineTo(item[0], item[1]);
    }
    ctx.lineTo(s[0], s[1]);
    if (cb) cb(c);
  });
  //截取中间行政区块的地图
  ctx.globalCompositeOperation = 'destination-in';
  ctx.fillStyle = 'white';
  ctx.fill();
  //绘制轮廓线条
  ctx.globalCompositeOperation = 'source-over';
  ctx.lineWidth = 3;
  ctx.strokeStyle = 'orange';
  ctx.stroke();

  return {canvas: canvas, geojson, bound};
}
```

**注意**

- 行政区轮廓经纬度要做转换，需将经纬度坐标转为墨卡托投影像素坐标，减去行政区范围的起始坐标，即显示在 canvas 上的坐标
- 通过修改 canvas 的合成操作的类型`globalCompositeOperation='destination-in'`(仅保留现有画布内容和新形状重叠的部分。其他的都是透明的)，让行政区轮廓内填充颜色，即行政区轮廓外变成透明，然后合成操作的类型恢复为默认`globalCompositeOperation = 'source-over'`（在现有画布上绘制新图形），绘制行政区轮廓线。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/001ca358df424b0984d5765818f8bd9a~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=yAXkhdydpmudT8fIKEyit9cTRTA%3D)

好啦，广州市缩放级别为 10 的行政区的卫星贴图大功告成啦！更多关于用 canva 绘制瓦片地图的过程，可以参考我之前的博客[《从零开始用 Canvas 画一个 2D 地图》](https://juejin.cn/post/7492264852918599730)

## 1.5 将 canvas 卫星贴图作为平面放在高德 3D 地图上看看效果

如何在高德地图上使用 three.js 可以看[官方示例](https://lbs.amap.com/demo/javascript-api-v2/example/selflayer/glcustom-layer)，也可以看我之前的博客[《高德地图+Three.js 实现飞线、运动边界和炫酷标牌》](https://juejin.cn/post/7403946149914738751)

```js
createPlane(canvas, b) {
    //计算行政区范围的中心点
    const center = [(b.minlng + b.maxlng) * 0.5, (b.minlat + b.maxlat) * 0.5];
    //获取行政区范围对应的墨卡托投影坐标xyz
    const startp = this.customCoords.lngLatToCoord([b.minlng, b.minlat]);
    const endp = this.customCoords.lngLatToCoord([b.maxlng, b.maxlat]);
    //计算行政区范围的宽高
    const w = Math.abs(startp[0] - endp[0]);
    const h = Math.abs(startp[1] - endp[1]);
    //创建平面
    const geometry = new THREE.PlaneGeometry(w, h);
    //将行政区卫星贴图作为材质贴图，开启透明
    const tex = new THREE.CanvasTexture(canvas);
    tex.minFilter = THREE.LinearMipmapNearestFilter;
    const material = new THREE.MeshBasicMaterial({
      map: tex,
      transparent: true,
      depthWrite: false
    });
    const plane = new THREE.Mesh(geometry, material);
    //行政区中心点的墨卡托投影坐标xyz
    const p = this.customCoords.lngLatToCoord(center);
    //将平面坐标设置成行政区中心点墨卡托投影坐标
    plane.position.set(p[0], p[1], 0);
    return { plane, center, p, material };
  }

//获取geojson
const geojson = await loadGeojson(this.adcode);
//绘制卫星行政区贴图
const { canvas, bound: b } = await createAreaCanvas(geojson, this.zoom);

const { plane ,center} = this.createPlane(canvas, b);
 //将地图定位到中心点
    this.map.setCenter(center);
this.scene.add(plane);

```

**注意**

- 高德 3D 地图的 xyz 坐标与 three.js 坐标有些不同，three.js 的 y 坐标表示高度值,高德 3D 地图的 z 坐标表示高度值，即两者的 yz 坐标对换，坐标要做对应转换！
- 需要使用`map.customCoords`将经纬度转换成高德 3D 地图对应的墨卡托投影坐标 xyz（这跟 2D 的墨卡托投影不同）
- 将行政区经纬度范围和中心点转墨卡托投影坐标，计算出平面宽高和中心点位置，然后将行政区卫星贴图作为材质贴图，并开启透明，放在 three.js 的平面上，将平面位置设置成行政区范围中心点的高德 3D 地图对应的墨卡托投影坐标。

![20250420_004849.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ee18c3c69a784810b9f5c67c17466e1a~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=CMTsL2H8qxwo3dpf%2BWtafBpNcJI%3D)

可以看到贴图平面与高德的卫星地图颜色深浅有些不同，地图位置是一致的！

# 2. 绘制卫星贴图行政区块

## 2.1 光照

为了让区块有点质感，增加白色环境光和一些绿色光照，材质使用`MeshStandardMaterial`

```js
//设置光照
const light = new THREE.AmbientLight(0xffffff, 1.0);
this.scene.add(light);
//绿色平行光
const dirLight = new THREE.DirectionalLight('#00ff00', 1);
const lightH = this.size * 20;
dirLight.position.set(0, -lightH, lightH);
this.scene.add(dirLight);

//3D区块材质
const material = new THREE.MeshStandardMaterial({
  color: '#FFEFD5'
});

//行政区卫星贴图平面材质
const material = new THREE.MeshStandardMaterial({
  map: new THREE.CanvasTexture(canvas),
  transparent: true,
  depthWrite: false
});
```

## 2.2 3D 行政区块

遍历行政区块的子区块轮廓的坐标点，绘制每个 3D 子区块，然后绘制每个子行政区卫星贴图平面放在 3D 区块上。

```js
//拆分子行政区块，分别绘制
for (let i = 0; i < geojson.features.length; i++) {
  //分组
  const g = new THREE.Group();
  //形状区块轮廓形状
  const shape = new THREE.Shape();
  const f = geojson.features[i];
  //绘制行政区卫星canvas贴图,顺便绘制3D形状轮廓
  const {canvas, bound: b} = await createAreaCanvas({features: [f]}, this.zoom, (c) => {
    const pos = this.customCoords.lngLatToCoord(c[0]);
    shape.moveTo(...pos);
    for (let i = 1; i < c.length; i++) {
      const p = this.customCoords.lngLatToCoord(c[i]);
      shape.lineTo(...p);
    }
    shape.lineTo(...pos);
  });
  const mesh = new THREE.Mesh(
    new THREE.ExtrudeGeometry(shape, {
      bevelEnabled: false,
      depth: height
    }),
    material
  );
  //区块名称用于后续点击事件识别
  mesh.name = f.properties.name;
  g.add(mesh);

  //上方的行政区块卫星贴图平面
  const {plane, center, p} = this.createPlane(canvas, b);
  plane.name = f.properties.name;
  plane.position.z = this.height + 1;
  g.add(plane);
  g.name = f.properties.name;
  group.add(g);
  //收集相关位置信息，用于后续点击事件
  this.infoMap[f.properties.name] = {
    //下钻后地图观察点
    viewPos: [center[0], b.minlat + this.getOffsetLat(this.height * 20)],
    center,
    p,
    //柱体颜色
    color: this.colors[i % this.colors.length]
  };
}
```

**注意：**

- 行政区卫星贴图材质要开启透明度`transparent: true`，因为子区块相邻，卫星贴图的平面会出现重叠，造成深度冲突，可以通过要关闭材质的深度写入`depthWrite:false`来解决。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/2ce9dcc34567452db0e5bf885a624245~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=PpnupQR%2Flj9JTlbl18dMDsPbsrI%3D)

## 2.3 绘制卫星贴图地图平面

因为高德 3D 地图在下面，且不受上方 three.js 的光照影响，与卫星贴图 3D 行政区块有点颜色对比突兀，为了让行政区块更好地融合背景地图，可以加上一个卫星贴图地图平面。

```js
const geojson = await loadGeojson(this.adcode);
//行政区范围
const bound = getGeojsonBound(geojson);
const center = [(bound.minlng + bound.maxlng) * 0.5, (bound.minlat + bound.maxlat) * 0.5];
//高德地图中心设为行政区中心位置
this.map.setCenter(center);
this.viewCenter = center;
//获取2D墨卡托像素范围
const {width: w, height: h} = getBoundOrigin(bound, this.zoom);
//绘制宽高最大值两倍大小的卫星地图canvas
const {canvas, bounds} = await drawRectLayer(center, this.zoom, Math.max(w, h) * 2);
//添加卫星地图平面
const {plane: ground, material: gMat} = this.createPlane(canvas, bounds);
this.ground = ground;
this.scene.add(ground);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/dc4ff058ee7d4dbbb25e0c86b88f22e7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=c9waGFBDxX%2Fnk%2B%2FK2OeQRXH8Ljw%3D)

# 3. 添加动画

这里采用了 TWEEN 动画库，做了一点封装

```js
  addAnimate(start, end, time, update) {
    return new Promise((resolve) => {
      const tween = new TWEEN.Tween(start)
        .to(end, time)
        .onUpdate(update)
        //渐进渐出
        .easing(TWEEN.Easing.Quartic.InOut)
        .onComplete(() => {
          resolve(tween);
        })
        .start();
    });
  }
```

## 3.1 让 3D 区块从地面升起

3D 区块组初始位置整体沉到地面以下，然后再升起。

- 注意：高度`+1`是为了避免深度冲突问题，让区块优先显示在上面

```js
group.position.z = -height + 1;
//升起
await this.addAnimate({h: group.position.z}, {h: 0}, 1000, (obj) => {
  group.position.z = obj.h;
});
```

![20250420_004550.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/6df8501805a5419bb8f61533d4ce8055~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=VAeG0E5mN%2F%2B0PDoexbbRqnijcxs%3D)

## 3.2 让卫星地图平面扩散消失

修改材质 shader，顶点着色器和片元着色器都开启 uv，然后片元着色器中，随着时间变化，贴图颜色从中心扩散变透明，让高德 3D 地图黑色地图显现出来，做出一种地图切换动画的感觉。

```js
gMat.onBeforeCompile = (shader, render) => {
  this.shader = shader;
  shader.uniforms.uTime = {value: 0};
  shader.vertexShader = shader.vertexShader.replace(
    '#include <common>',
    // 开启uv
    `#define USE_UV\n#include <common>`
  );
  shader.fragmentShader = shader.fragmentShader.replace(
    '#include <common>',
    // 开启uv
    `#define USE_UV\n#include <common>\nuniform float uTime;`
  );
  shader.fragmentShader = shader.fragmentShader.replace(
    '#include <dithering_fragment>',
    // 随着时间从中心扩散变透明
    `#include <dithering_fragment>
         float d=length(vUv-vec2(0.5));
         gl_FragColor.a= mix(1.,0.,sign(clamp(uTime -d,0.,1.)));
           `
  );
};
await this.addAnimate({t: 0}, {t: 1}, 1000, (obj) => {
  //修改shader的时间值
  if (this.shader) this.shader.uniforms.uTime.value = obj.t;
});
//全透明后删除卫星地图
this.cleanObj(this.ground);
this.ground = null;
```

![20250420_004700.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/cd50220085ae40658655a244a59fdce5~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=gBCinzY0uUx3U6XiDWcVKanGw6M%3D)

## 3.3 让 3D 区块上下浮动

因为卫星贴图行政 3D 区块初始位置是一样的，需要让区块移动到浮动的起始位置，然再修改高度值，重复上下运动，以免突兀地开始浮动。

```js
async play() {
    //让每个3D区块移动到浮动起始位置
    for (let i = 0; i < this.group.children.length; i++) {
      const g = this.group.children[i];
      const s = i % 2 === 1 ? Math.sin(i * 0.1 * Math.PI) : Math.cos(i * 0.1 * Math.PI);
      this.addAnimate({ t: 0 }, { t: s * this.height }, 1500, (obj) => {
        g.position.z = obj.t;
      });
    }

    await this.sleep(1500);
    //重复上下运动
    const tw = new TWEEN.Tween({ t: 0 })
      .to({ t: 2 }, 2000)
      .repeat(Infinity)
      .onUpdate((obj) => {
        if (!this.activeItem) {
          this.group.children.forEach((item, i) => {
            const s =
              i % 2 === 1
                ? Math.sin((obj.t + i * 0.1) * Math.PI)
                : Math.cos((obj.t + i * 0.1) * Math.PI);
            item.position.z = s * this.height;
          });
        } else {
        //选中区块后停止浮动
          TWEEN.remove(tw);
        }
      })
      .start();
  }
```

![20250420_004346.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/f5d952061dc143bfa915b6357ee0a5fd~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=oJFob53cuIgiwDAoz9UqLfGH%2B%2BQ%3D)

开场动画就这样完成啦！

# 4. 下钻并添加递增柱体

## 4.1 3D 区块添加点击下钻

```js
  async onClickItem(event) {
    this.mouse.x = (event.offsetX / this.container.offsetWidth) * 2 - 1;
    this.mouse.y = -(event.offsetY / this.container.offsetHeight) * 2 + 1;
    this.raycaster.setFromCamera(this.mouse, this.camera);
    //如果没有选中3D区块则下钻
    if (!this.activeItem) {
      //检测是否点击到物体
      const intersects = this.raycaster.intersectObjects(this.group.children, true);
      if (intersects.length > 0) {
        const obj = intersects[0].object;
        if (!obj.name) return;
        this.activeItem = obj.name;
        //下钻后...
      }
    } else {
      // 如果已有选中3D区块则,返回
      //...
    }
  }
this.raycaster = new THREE.Raycaster();
this.mouse = new THREE.Vector2();
window.addEventListener('pointerdown', this.onClickItem.bind(this));

```

## 4.2 下钻后添加递增柱体

下钻后隐藏除了选中以外的 3D 区块，选中区块回归原始高度，然后获取该 3D 区块观察点位置等信息，并切换视角

```js
//隐藏除了选中外的3D区块
this.group.children.forEach((item) => {
  if (item.name == obj.name) {
    item.visible = true;
    item.position.z = 0;
  } else {
    item.visible = false;
  }
});
//获取行政区块观察点位置等信息
const {viewPos: c, p, color} = this.infoMap[obj.name];
//切换到视角
await this.addAnimate(
  this.getView(),
  {
    lng: c[0],
    lat: c[1],
    zoom: 11,
    pitch: this.pitch,
    rotate: -25
  },
  1000,
  (v) => {
    this.setView(v);
  }
);
```

**注意**

- 高德 3D 地图的视角由中心点 center，缩放等级 zoom，俯仰角 pitch，左右旋转角度 rotation 四个决定。可以通过以下方法获取并设置

```js
//设置视角
  setView(c) {
    this.map.setCenter([c.lng, c.lat]);
    this.map.setZoom(c.zoom);
    this.map.setPitch(c.pitch);
    this.map.setRotation(c.rotate);
  }
  //获取当前视角
  getView() {
    const c = this.map.getCenter();
    const v = {
      lng: c.lng,
      lat: c.lat,
      zoom: this.map.getZoom(),
      pitch: this.map.getPitch(),
      rotate: this.map.getRotation()
    };
    return v;
  }
```

柱体默认高度都是 size,放在 3D 行政中心点上方。即柱体高度位置为`当前形状区块厚度height+2+柱体高度的一半`，因为之前的行政区卫星贴图平面在`height+1`的位置，为了避免深度冲突，柱体高度位置还需`+1`

```js
//在行政区块上绘制柱体
const box = new THREE.BoxGeometry(this.height, this.height, this.size);
const boxMat = new THREE.MeshStandardMaterial({
  // color: '#FFE4B5',
  color
});
const cube = new THREE.Mesh(box, boxMat);
//柱体位置在行政区块中心点上
cube.position.set(p[0], p[1], this.height + 2 + this.size * 0.5);
this.scene.add(cube);
this.cube = cube;
//显示数据标签
const value = this.valMap[obj.name];
const dom = document.createElement('div');
dom.className = 'text-box';
const label = new CSS2DObject(dom);
label.position.set(p[0], p[1], this.height + 2 + this.size);
this.scene.add(label);
this.label = label;
```

**添加递增动画**

柱体高度通过设置 scale 的大小实现递增，而柱体的中心点位置也要跟着递增，数据标签的高度与内容也要对应更新，标签数据数值从 0 到对应值，可以给人一种翻牌器的感觉。

```js
//标签与柱体递增
this.addAnimate(
  {t: 1, value: 0},
  {
    t: 2 + 20 * ((value - this.minVal) / this.valLen),
    value: value
  },
  1000,
  (v) => {
    //柱体高度增加
    cube.scale.set(1, 1, v.t);
    //柱体位置跟着增长
    cube.position.z = this.height + 2 + v.t * this.size * 0.5;
    //数据标签跟着增长
    label.position.z = this.height + 2 + v.t * this.size;
    //数据标签内容跟着增长
    dom.innerHTML = `<div> ${v.value.toFixed(2)}亿元<br/>${obj.name} </div>`;
  }
);
```

**返回原视图**

删除柱体和数据标签，视角切换成原视角，然后选中清空，全部区块再次出现，进行上下浮动动画。

```js
this.scene.remove(this.cube);
this.scene.remove(this.label);
//视角恢复成原视图
const c = this.viewCenter;
this.addAnimate(
  this.getView(true),
  {
    lng: c[0],
    lat: c[1],
    zoom: this.zoom,
    pitch: this.pitch,
    rotate: 0
  },
  1000,
  (obj) => {
    this.setView(obj);
  }
);
//3D 区块全部出现
this.activeItem = '';
this.group.children.forEach((item) => {
  item.visible = true;
});
//上下浮动
this.play();
```

![20250420_004221.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/f94fc49ba83f4e609823eb3970fdde05~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=FmsfmywBCefE8GrEJJJElQzGCUU%3D)

数据为[《2024 年 2 广州市各区 GDP》](https://www.sohu.com/a/879892073_121119015)

# 5. Bloom 发光效果

后期处理 Bloom 发光效果依赖于背景，而高德 3D 地图存在默认地图背景，直接采用后期处理 Bloom 在高德 3D 地图的`GLCustomLayer`上绘制发光效果，就会丢失发光的部分。若直接覆盖一层`webgl canvas`在地图上，因为`Bloom`发光效果后背景色为黑色，则会遮盖下面的高德地图。

为了能在高德 3D 地图上显示发光效果，我采用了外部的`webgl canvas`+ FrameBuffer 的方法。

## 5.1 外部`webgl canvas`

创建一个新的同等大小的`webgl canvas`覆盖在高德 3D 地图上方，并将`WebGLRenderer`渲染器 context 设为该`webgl canvas`

```js
//初始化Three渲染器
const canvas = document.createElement('canvas');
canvas.style.position = 'absolute';
canvas.style.top = '0px';
canvas.style.left = '0px';
//不妨碍界面上事件行为
canvas.style.pointerEvents = 'none';
document.body.appendChild(canvas);
canvas.width = dom.offsetWidth;
canvas.height = dom.offsetHeight;
this.canvas = canvas;
const webgl = canvas.getContext('webgl');
this.renderer = new THREE.WebGLRenderer({
  context: webgl // 地图的 gl 上下文
});
```

因为使用了外部 canvas，所以`GLCustomLayer`的 `render` 方法内只需要更新同步相机参数，不需要更新渲染场景。

```js
render: () => {
  //设置坐标转换中心
  this.customCoords.setCenter(this.center);
  var {near, far, fov, up, lookAt, position} = this.customCoords.getCameraParams();

  // 这里的顺序不能颠倒，否则可能会出现绘制卡顿的效果。
  this.camera.near = near;
  this.camera.far = far;
  this.camera.fov = fov;
  this.camera.position.set(...position);
  this.camera.up.set(...up);
  this.camera.lookAt(...lookAt);
  this.camera.updateProjectionMatrix();
};
```

## 5.2 添加 Bloom 发光特效

`UnrealBloomPass` 官方介绍：`UnrealBloomPass` 的灵感来自虚幻引擎的 `BloomPass`。它创建了一个由 `Bloom` 纹理组成的 `mip` 贴图链，并用不同的半径模糊它们。由于 `MIP` 的加权组合，以及在更高的 `MIP` 上进行更大的模糊，这种效果提供了良好的质量和性能。来自[bloom in unreal engine](https://dev.epicgames.com/documentation/en-us/unreal-engine/bloom-in-unreal-engine)

```js
addBloom() {
    //发光效果相关参数
    const params = {
      threshold: 0,
      strength: 0.6,
      radius: 1
    };
    this.params = params;
    const renderScene = new RenderPass(this.scene, this.camera);
    //发光效果配置
    const bloomPass = new UnrealBloomPass(
      new THREE.Vector2(this.container.offsetWidth, this.container.offsetHeight),
      params.strength,
      params.radius,
      params.threshold
    );
    this.bloomPass = bloomPass;
    //后期效果合成
    const bloomComposer = new EffectComposer(this.renderer);
    bloomComposer.renderToScreen = false;
    bloomComposer.addPass(renderScene);
    bloomComposer.addPass(bloomPass);
    this.bloomComposer = bloomComposer;
    //发光效果合成渲染画面大小
    this.bloomComposer.setSize(this.container.offsetWidth, this.container.offsetHeight);
  }
```

## 5.3 添加帧缓冲 FrameBuffer

因为 Bloom 发光效果渲染后的背景色是黑色，如何让黑色变成透明？我们可以想到材质中透明贴图的特性，透明贴图白色不透明，黑色透明。

可以看看源码`three.js/src/renderers/shaders/ShaderChunk/alphamap_fragment.glsl.js`透明贴图在片元着色器中使用，根据透明贴图中 rgba 的 g 绿色值设置颜色透明度。

```js
export default /* glsl */ `
#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, vAlphaMapUv ).g;
#endif
`;
```

那么我们可以使用`Bloom`发光效果图作为透明度贴图，让背景透明化，让下面的高德 3D 地图显示出来。

- 更多关于如何用 three.js 渲染 frameBuffer 作为贴图覆盖在画面上，可以参考我之前的文[《用 Three.js 搞个雨雪雾》](https://juejin.cn/post/7365694439567999016)

```js
addFrameBuffer() {
    const dpr = window.devicePixelRatio;
    const width = this.container.offsetWidth;
    const height = this.container.offsetHeight;
    const sceneOrtho = new THREE.Scene();
    this.sceneOrtho = sceneOrtho;
    //创建正交投影
    const cameraOrtho = new THREE.OrthographicCamera(
      -width / 2,
      width / 2,
      height / 2,
      -height / 2,
      1,
      10
    );
    cameraOrtho.position.z = 10;
    cameraOrtho.left = -width / 2;
    cameraOrtho.right = width / 2;
    cameraOrtho.top = height / 2;
    cameraOrtho.bottom = -height / 2;
    this.cameraOrtho = cameraOrtho;
    //将发光效果渲染结果作为材质贴图和透明度贴图，让黑色背景透明化
    const mat = new THREE.MeshBasicMaterial({
      map: this.bloomComposer.renderTarget2.texture,
      alphaMap: this.bloomComposer.renderTarget2.texture,
      transparent: true
    });
    this.mat = mat;
    //添加平面
    const g = new THREE.PlaneGeometry(width * dpr, height * dpr);
    const mesh = new THREE.Mesh(g, mat);
    sceneOrtho.add(mesh);
  }
```

**设置渲染顺序**

1. 先渲染地图和同步相机参数，更新 HTML 的`CSS2DRender`渲染
2. 然后关闭`renderer`的自动清空，进行手动清空
3. 如果开启了发光效果，将给`UnrealBloomPass`赋值有效的参数，否则都赋值为 0
4. 然后隐藏不发光的物体，渲染 `Bloom` 发光效果
5. 让不发光的物体显示出来，渲染所有物体到场景中。
6. 然后将发光效果的渲染结果 FrameBuffer 即`bloomComposer.renderTarget2.texture`，已经赋值给正交投影场景平面的材质，作为贴图 `map` 和透明贴图 `alphaMap`
7. 最终渲染正交投影中场景

```js
animate() {
    if (TWEEN.getAll().length) {
      TWEEN.update();
    }
    //更新地图渲染和相机参数
    this.map.render();
    //更新HTML
    this.labelRenderer.render(this.scene, this.camera);

    //关闭自动清空
    this.renderer.autoClear = false;
    //手动清空
    this.renderer.clear();
    if (this.isBloom) {
      //开启发光
      for (const k in this.params) {
        this.bloomPass[k] = this.params[k];
      }
    } else {
      //关闭发光
      for (const k in this.params) {
        this.bloomPass[k] = 0;
      }
    }
    //卫星地图平面隐藏，不发光
    if (this.ground) this.ground.visible = false;
    //柱体隐藏，不发光
    if (this.cube) this.cube.visible = false;
    //渲染发光效果
    if (this.bloomComposer) this.bloomComposer.render();
    //清空深度
    this.renderer.clearDepth();
    //卫星地图平面显示
    if (this.ground) this.ground.visible = true;
    //柱体显示
    if (this.cube) this.cube.visible = true;
    //渲染场景全部物体
    this.renderer.render(this.scene, this.camera);
    //渲染到正交投影场景中
    this.renderer.render(this.sceneOrtho, this.cameraOrtho);
    this.threeAnim = requestAnimationFrame(this.animate.bind(this));
  }
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/c699b773269f4fe1ae6bddd03715cfc3~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=KQZLzMfYY9KqndvadEObF8UHcEI%3D)

# 7.总结

最终效果很棒！但动态卫星贴图因为远近像素拉伸，会出现像素采样模糊的问题，但不是很近地看还是看不出来的，可以限制一下缩放比例的最小值最大值！另外适当增加行政区卫星贴图的缩放级别，增加贴图像素来提高采样准确性也可，不要太大缩放等级，因为缩放级别太大，加载的卫星地图瓦片太多，会出现图片加载绘制时间过长，影响用户体验。

![999.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/a2c2fec4d3334132ba0edc64706965e3~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1745723063&x-orig-sign=xpOb5ta9dCrvgAsNa31VOU0f%2FIU%3D)

# 8.Github 地址

`https://github.com/xiaolidan00/my-earth`

**参考**

- [Bloom in UE](https://dev.epicgames.com/documentation/en-us/unreal-engine/bloom-in-unreal-engine)
- [《2024 年 2 广州市各区 GDP》](https://www.sohu.com/a/879892073_121119015)
- [高德地图-自定义图层-GLCustomLayer 结合 THREE](https://lbs.amap.com/demo/javascript-api-v2/example/selflayer/glcustom-layer)
- [Three.js webgl postprocessing unreal bloom](https://threejs.org/examples/?q=bloom#webgl_postprocessing_unreal_bloom)
