---
theme: fancy
highlight: vs
---
cesium添加形状有两种方式，一种是用`viewer.entities`添加`Entity`实体，另一种是用`viewer.scene.primitives`添加`Primitive`图元

# Entity实例方式添加长方体

[官方示例Box](https://sandcastle.cesium.com/index.html?src=Box.html)

```js
const box=viewer.entities.add({
     id: 'box',
      position: Cesium.Cartesian3.fromDegrees(113.392987,23.051086, 10),
      box:{
      dimensions: new Cesium.Cartesian3(300, 400, 500),
      material: Cesium.Color.RED.withAlpha(0.5),//图形颜色，半透明红色
      outline: true,//线框开启
      outlineColor: Cesium.Color.WHITE,//线框颜色
      },
 }); 
 
 const box1=viewer.entities.add({
     id: 'box1',
      position: Cesium.Cartesian3.fromDegrees(113.40,23.051086, 10),
      box:{
      dimensions: new Cesium.Cartesian3(300, 400, 500),
      material: Cesium.Color.BLUE//图形颜色,蓝色      
      },
 });
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/69baec63a2ab48d29b35dc86bb01bac3~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1727015128&x-orig-sign=01CS9BD0SyjjjMviahcWYxUa7HI%3D)

可以看到地图上方10米有个半透明的长方体，长方体图形的属性配置[BoxGraphics](https://cesium.com/learn/cesiumjs/ref-doc/BoxGraphics.html)

- 可以使用`zoomTo`将视角范围调整到实体组，这样就可以看到对应的形状了

```js
viewer.zoomTo(viewer.entities);
```

- viewer.entities对应[EntityCollection](https://cesium.com/learn/cesiumjs/ref-doc/EntityCollection.html)，可获取指定实体进行修改，和删除实体

```js
//获取实体
const aEntity=viewer.entities.getById('box');
//修改实体颜色为绿色
aEntity.box.material=Cesium.Color.GREEN;

//删除实体
viewer.entities.remove(aEntity);
viewer.entities.removeById('box');
```

# Primitive图元方式添加长方体

```js
const instance = new Cesium.GeometryInstance({
      geometry: Cesium.BoxGeometry.fromDimensions({
        vertexFormat: Cesium.VertexFormat.POSITION_AND_NORMAL,
        //形状大小
        dimensions: new Cesium.Cartesian3(300, 400, 500)
      }),
      modelMatrix: Cesium.Matrix4.multiplyByTranslation(Cesium.Transforms.eastNorthUpToFixedFrame(
        //经纬度位置  
        Cesium.Cartesian3.fromDegrees(113.40, 23.051086)),
        //位置高度
        new Cesium.Cartesian3(0.0, 0.0, 10.0),
        new Cesium.Matrix4()),
      id: 'box'
    });
    //纯色材质
     const mat = Cesium.Material.fromType('Color', {
      //设置材质颜色为蓝色
      color: new Cesium.Color(0.0, 0.0, 1.0, 1.0)
    });
     
    viewer.scene.primitives.add(
      new Cesium.Primitive({
        //形状实例
        geometryInstances: instance,
        //样式
        appearance: new Cesium.MaterialAppearance({
          material: mat,
          //正面
          faceForward: true
        })
      })
    );
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/a3962732d71e43f7844508b6c298914f~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1727015128&x-orig-sign=fqRuySLdYmBA5mJlkCnnphDWHz0%3D)

Primitive方式下的长方形纯色材质默认是不受光照影响的，而Entity的纯色材质会受光照影响。

# 两种添加方式的层级控制
