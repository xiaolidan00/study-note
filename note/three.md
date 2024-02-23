# three.js 使用注意事项

## 1.  贴图反向

```js
texture.flipY = false;
```

## 2.  贴图没有填充满模型

```js
textureMap.wrapS = textureMap.wrapT = THREE.RepeatWrapping;
```

## 3.  贴图透明度

```js
transparent: false;

//树叶
blending: THREE.MultiplyBlending;
```

## 4.  深度冲突

```js
无需深度检测的Material设置 depthTest:false
new THREE.WebGLRenderer( { logarithmicDepthBuffer: true } );
```

## 5.  渲染顺序问题

```js
WebGLRenderer设置sortObjects: false;
每个Mesh手动设置renderOrder的顺序;
```

## 6.  多层次细节

```js
const lod = new THREE.LOD();

//Create spheres with 3 levels of detail and create new LOD levels for them
for (let i = 0; i < 3; i++) {
  const geometry = new THREE.IcosahedronBufferGeometry(10, 3 - i);

  const mesh = new THREE.Mesh(geometry, material);

  lod.addLevel(mesh, i * 75);

  //addLevel ( object : Object3D, distance : Float ) : this
  //object —— 在这个层次中将要显示的Object3D。
  //distance —— 将显示这一细节层次的距离。
}

scene.add(lod);
```

## 7.  抗锯齿

```js
//antialias - 是否执行抗锯齿。默认为false.
new THREE.WebGLRenderer({ antialias: true });
```

## 8.  阴影

```js
//渲染器开启渲染阴影效果
renderer.shadowMapEnabled = true;

this.renderer.shadowMap.enable = true;
this.renderer.shadowMap.type = THREE.PCFSoftShadowMap;

//平面接收投影
plane.receiveShadow = true;

//点光源产生投影
spotLight.castShadow = true;

//物体对象产生投影
cube.castShadow = true;
```

阴影使用可能遇到的问题

●  阴影模糊，增加 shadowMapWidth 和 shadowMapHeight，或保证用于计算阴影区域紧密包围在对象周围（shadowCameraNear, shadowCameraFar, shadowCameraFov）

●  产生阴影与接收阴影设置，光源生成阴影，几何体是否接收或投射阴影 castShadow 和 receiveShadow

●  薄对象渲染阴影时可能出现奇怪的渲染失真，可通过 shadowBias 轻微偏移阴影来修复

●  调整 shadowDarkness 来改变阴影的暗度

●  阴影更柔和，可在 THREE. WebGLRenderer 设置不同 shadowMapType。默认 THREE. PCFShadowMap, 柔和：PCFSoftShadowMap

## 9.  html 标签，CSS2DRenderer

```js
const moonDiv = document.createElement('div');
moonDiv.innerHTML = 'Moon';
//保证能点击
moonDiv.style.pointerEvents = 'auto';
const moonLabel = new CSS2DObject(moonDiv);
moonLabel.position.set(0, 10, 0);
moon.add(moonLabel);

labelRenderer = new CSS2DRenderer();
labelRenderer.setSize(container.offsetWidth, container.offsetHeight);
labelRenderer.domElement.style.position = 'absolute';
labelRenderer.domElement.style.top = '0px';
//不妨碍界面上的东东
labelRenderer.domElement.style.pointerEvents = 'none';
container.appendChild(labelRenderer.domElement);

function onWindowResize() {
  labelRenderer.setSize(container.offsetWidth, container.offsetHeight);
}

function animate() {
  labelRenderer.render(scene, camera);
}
```

## 10.  颜色问题

```js
//底色透明
this.renderer.setClearColor(0x000000, 0);

//模型渲染，默认THREE.LinearEncoding
this.renderer.outputEncoding = THREE.sRGBEncoding;

THREE.LinearEncoding;
THREE.sRGBEncoding;
THREE.GammaEncoding;
THREE.RGBEEncoding;
THREE.LogLuvEncoding;
THREE.RGBM7Encoding;
THREE.RGBM16Encoding;
THREE.RGBDEncoding;
THREE.BasicDepthPacking;
THREE.RGBADepthPacking;
```

## 11.  分辨率问题

```js
this.renderer.setPixelRatio(window.devicePixelRatio);
//分辨率越高渲染压力就越大
```

## 12.  物体居中

```js
function setModelCenter(object, viewControl) {
  if (!object) {
    return;
  }
  if (object.updateMatrixWorld) {
    object.updateMatrixWorld();
  }

  // 获得包围盒得min和max
  const box = new THREE.Box3().setFromObject(object);

  let objSize = box.getSize(new THREE.Vector3());
  // 返回包围盒的中心点
  const center = box.getCenter(new THREE.Vector3());

  object.position.x += object.position.x - center.x;
  object.position.y += object.position.y - center.y;
  object.position.z += object.position.z - center.z;

  let width = objSize.x;
  let height = objSize.y;
  let depth = objSize.z;

  let centroid = new THREE.Vector3().copy(objSize);
  centroid.multiplyScalar(0.5);

  if (viewControl.autoCamera) {
    this.camera.position.x =
      centroid.x * (viewControl.centerX || 0) + width * (viewControl.width || 0);
    this.camera.position.y =
      centroid.y * (viewControl.centerY || 0) + height * (viewControl.height || 0);
    this.camera.position.z =
      centroid.z * (viewControl.centerZ || 0) + depth * (viewControl.depth || 0);
  } else {
    this.camera.position.set(
      viewControl.cameraPosX || 0,
      viewControl.cameraPosY || 0,
      viewControl.cameraPosZ || 0
    );
  }

  this.camera.lookAt(0, 0, 0);
}
```

## 13.  清空资源

```js
function cleanNext(obj, idx) {
  if (idx < obj.children.length) {
    this.cleanElmt(obj.children[idx]);
  }
  if (idx + 1 < obj.children.length) {
    this.cleanNext(obj, idx + 1);
  }
}

function cleanElmt(obj) {
  if (obj) {
    if (obj.children && obj.children.length > 0) {
      this.cleanNext(obj, 0);
      obj.remove(...obj.children);
    }
    if (obj.geometry) {
      obj.geometry.dispose && obj.geometry.dispose();
    }
    if (obj.material) {
      for (const v of Object.values(obj.material)) {
        if (v instanceof THREE.Texture) {
          v.dispose && v.dispose();
        }
      }

      obj.material.dispose && obj.material.dispose();
    }

    obj.dispose && obj.dispose();
    obj.clear && obj.clear();
  }
}
function cleanObj(obj) {
  this.cleanElmt(obj);
  obj?.parent?.remove && obj.parent.remove(obj);
}
function cleanAll() {
  window.removeEventListener('resize');
  cancelAnimationFrame(this.threeAnim);

  if (this.stats) {
    this.container.removeChild(this.stats.domElement);
    this.stats = null;
  }

  this.cleanObj(this.scene);
  this.controls && this.controls.dispose();

  this.renderer.renderLists && this.renderer.renderLists.dispose();
  this.renderer.dispose && this.renderer.dispose();
  this.renderer.forceContextLoss();
  let gl = this.renderer.domElement.getContext('webgl');
  gl && gl.getExtension('WEBGL_lose_context').loseContext();
  this.renderer.setAnimationLoop(null);
  this.renderer.domElement = null;
  this.renderer.content = null;
  console.log('清空资源', this.renderer.info);
  this.renderer = null;
  THREE.Cache.clear();
  if (this.map) {
    this.map.destroy();
  }
}
```

## 14.  模型显示面的问题

.side:Integer

定义将要渲染哪一面 - 正面，背面或两者。 默认为 THREE.FrontSide。其他选项有 THREE.BackSide 和 THREE.DoubleSide。

```js
material.side = THREE.DoubleSide;
```

## 15.  Raycaster 鼠标拾取

不要检测全局，用 actionObjs 收集需要动作的物体

```js
this.raycaster = new THREE.Raycaster();
this.mouse = new THREE.Vector2();
this.container.style.cursor = 'pointer';
this.container.addEventListener(
  'pointerdown',
  (event) => {
    event.preventDefault();

    this.mouse.x =
      ((event.offsetX - this.container.offsetLeft) / this.container.offsetWidth) * 2 - 1;
    this.mouse.y =
      -((event.offsetY - this.container.offsetTop) / this.container.offsetHeight) * 2 + 1;
    let vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1).unproject(this.camera);

    this.raycaster.set(this.camera.position, vector.sub(this.camera.position).normalize());
    this.raycaster.setFromCamera(this.mouse, this.camera);
    const intersects = raycaster.intersectObjects(this.actionObjs, true);
    if (intersects?.length) {
      console.log('action', intersects[0]);
      this.raycasterAction(intersects[0]);
    }
  },
  false
);
```

## 16. Canvas 贴图

生成的 canvas 大小最好是正常模型贴图大小的五倍以上，有可能因为缩放问题，导致贴图模糊

## 17.打包后线上效果与开发时效果存在差异

将 three 的相关 js 提到 html 上，从外部引入，这样能保证 three 不会因为打包而乱了,导致效果有问题
FBXLoader 外部引入，记得把 libs 里面的 inflate 也加上

## 18.THREE.js 截图

```js
new THREE.WebGLRenderer({
  preserveDrawingBuffer: true //保留缓冲区
});

import { saveAs } from 'file-saver-fixed';
function convertBase64UrlToBlob(base64) {
  let parts = base64.split(';base64,');
  let contentType = parts[0].split(':')[1];
  let raw = window.atob(parts[1]);
  let rawLength = raw.length;
  let uInt8Array = new Uint8Array(rawLength);
  for (let i = 0; i < rawLength; i++) {
    uInt8Array[i] = raw.charCodeAt(i);
  }
  return new Blob([uInt8Array], { type: contentType });
}
saveImage: () => {
  let image = threeModel.renderer.domElement.toDataURL('image/jpeg');

  let blob = convertBase64UrlToBlob(image);
  saveAs(blob, new Date().getTime() + '.jpg');
};
```

## 18.glb 压缩过的模型加载,记得加 DRACOLoader

记得将`three.js/examples/js/libs/draco/gltf`目录下的 draco 解码器全部放在 public/draco 文件夹下，否则会导致模型加载失败！

```js
let dracoLoader = new THREE.DRACOLoader();
dracoLoader.setDecoderPath('draco/');
dracoLoader.setDecoderConfig({ type: 'js' }); //或者{type: "wasm"}
dracoLoader.preload();

const loader = new THREE.GLTFLoader();
loader.setDRACOLoader(dracoLoader);

return loader;
```

## 19.大量复用模型可采用 InstancedMesh

减少绘制程序调用的次数,提升渲染效率

```js
//count 需要生成的相同模型数量
let mesh = new THREE.InstancedMesh(geometry, material, count);
//动态生成，`THREE.DynamicDrawUsage`						mesh.instanceMatrix.setUsage(THREE.DynamicDrawUsage);

//设置第index个模型的位置
mesh.setMatrixAt(index, matrix);

//位置更新
mesh.instanceMatrix.needsUpdate = true;

//设置第index个模型的颜色
mesh.setColorAt(index, new THREE.Color(1, 0, 0));

//颜色更新
mesh.instanceColor.needsUpdate = true;
```

## 20.合并模型

BufferGeometry 包含点线面等相关的缓冲区数据，使用它能降低将所有这些数据传递到 GPU 的成本

将多个形状合并成一个，减少模型数量，提升渲染效率！

```js
const geometries = [];
const geometry = new THREE.BufferGeometry().fromGeometry(new THREE.BoxGeometry(10, 10, 10));
geometry.applyMatrix4(matrix); //模型位置
geometries.push(geometry); //将模型缓冲几何形状添加到数组

//...
const mergedGeometry = BufferGeometryUtils.mergeBufferGeometries(geometries);
```

> 合并后的模型就属于一个整体，动作检测时只能检测到这个整体，不能检测子模型

**如果需要监听到 merge 后的具体模型，需要做一些处理**

1. 在每个 geometry 添加到数组时，也要设置模型顺序索引`modelIndex`和选中索引`selectIndex`，并且收集每个 geometry 的面数，如果是同一个形状的话，面数直接用同一个就好，这样计算更方便。

```js
const count = geometry.getAttribute('position').count;
const modelIndex = new Uint8Array(count);
const selectIndex = new Uint8Array(count);
for (let i = 0; i < count; i++) {
  modelIndex[i] = index;
  selectIndex[i] = -1;
}
geometry.setAttribute('selectIndex', new THREE.BufferAttribute(selectIndex, 1, true));
geometry.setAttribute('modelIndex', new THREE.BufferAttribute(modelIndex, 1, true));
```

2.而赋值给 merge 后形状的 Mesh 的材质也要对应修改，给顶点着色器和片元着色器添加代码，判断当前模型索引是否等于选中的索引，然后赋予需要的颜色。

```js
const material = new THREE.MeshBasicMaterial({
  vertexColors: true
});
material.onBeforeCompile = (shader) => {
  shader.vertexShader = shader.vertexShader.replace(
    `void main() {`,
    ` attribute float selectIndex;
                    attribute float modelIndex;
                    varying float vselectIndex;
                    varying float vmodelIndex;
                    void main() {
                      vmodelIndex=modelIndex;
                      vselectIndex=selectIndex;`
  );
  shader.fragmentShader = shader.fragmentShader.replace(
    `void main() {`,
    `varying float vselectIndex;
                     varying float vmodelIndex;
                        void main() {`
  );
  shader.fragmentShader = shader.fragmentShader.replace(
    `vec3 outgoingLight = reflectedLight.indirectDiffuse;`,
    `vec3 outgoingLight = vmodelIndex ==vselectIndex  ?vec3(1.0,0.0,0.0 ):  reflectedLight.indirectDiffuse ;`
  );
};
```

3. Raycaster 点击后的获得的信息中有个叫做`fanceIndex`的属性，就是这个形状中某个面的索引，然后根据面索引和面数算出具体选中的模型索引`selectIndex`
   ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b742c1eb0af64d5f86769f868e6548bf~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=441&h=188&s=21017&e=png&b=fefcfc)

```js
const intersects = this.raycaster.intersectObjects(this.actionGroup, true);

if (intersects.length > 0) {
  let activeObj = intersects[0];
  let index = parseInt(activeObj.faceIndex / 12); //正方体有12个面
  let len = this.boxmesh.geometry.getAttribute('position').count;
  const selectIndex = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    selectIndex[i] = index;
  }
  this.boxmesh.geometry.setAttribute(
    'selectIndex',
    new THREE.BufferAttribute(selectIndex, 1, true)
  );
  console.log(activeObj, this.boxmesh.geometry, index);
  this.boxmesh.geometry.getAttribute('selectIndex').needsUpdate = true; //一定要记得更新选中索引值
}
```

然后如图所见，就能选中某个形状啦！
![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/513784d3f6b34bada8c90308dcd72694~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=696&h=329&s=11075&e=png&b=000000)

github 地址：`https://github.com/xiaolidan00/my-earth/blob/main/src/mergeGeometry.html`

## 后期处理部分辉光

官网给出的是 Layer 分层的方案，感觉操作起来很烦，我推荐的是直接用 visible 控制要渲染出泛光效果的组件和不需要渲染泛光效果组件，然后将这两组渲染结果合并就是最终的画面了

```js
this.renderer.setViewport(0, 0, this.container.offsetWidth, this.container.offsetHeight);
//必须关闭autoClear,避免渲染效果被清除
this.renderer.autoClear = false;
this.renderer.clear();
//不需要发光的物体在bloom后期前隐藏
this.normalObj.visible = false;
//渲染泛光的场景
this.composer.render();
//清除深度缓存
this.renderer.clearDepth();
//不需要发光的物体在bloom后期后显示
this.normalObj.visible = true;
//合并两个渲染场景，即可部分泛光
this.renderer.render(this.scene, this.camera);
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1bbb3c4b831649b3a3f654dd2254c11b~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=505&h=549&s=71798&e=png&b=320000)

github 地址：`https://github.com/xiaolidan00/my-earth/blob/main/src/UnrealBloom.html`
