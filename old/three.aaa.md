---
theme: fancy
highlight: vs
---

基础打得牢，干啥都ok!

# 1. Three.js是什么

 WebGL是一个只能画点、线和三角形的非常底层的系统. Three.js封装了诸如场景、灯光、阴影、材质、贴图、空间运算等一系列功能，让你不必要再从底层WebGL开始写起,即可渲染3D场景。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6b420709bab14b5fbb326aea2fe75ced~tplv-k3u1fbpfcp-watermark.image?)

- 传入一个场景(Scene)和一个摄像机(Camera)到渲染器(Renderer)中，然后它会将摄像机视椎体中的三维场景渲染成一个二维图片显示在画布上。
- 对象通过一个层级关系明确的树状结构来展示出各自的位置和方向。对象在场景中相对于他父对象的位置、朝向、和缩放。摄像机(Camera)作为其他对象的子对象，同样会继承它父对象的位置和朝向。
- 几何体(Geometry):物体的形状,顶点数据
- 材质(Material):如何绘制物体，光滑还是平整，什么颜色，什么贴图等等

## 1.1 摄像机

```js
//透视摄像机(PerspectiveCamera)

const fov = 75;

const aspect = canvas.width/canvas.height; // 相机默认值

const near = 0.1;

const far = 5;

const camera = new THREE.PerspectiveCamera(fov, aspect, near, far); 
```

- fov(field of view)是视野范围,单位弧度
- aspect指画布的宽高比。
- near和far代表近平面和远平面，它们限制了摄像机面朝方向的可绘区域。任何距离小于或超过这个范围的物体都将被裁剪掉(不绘制)。
- 视椎(frustum)是指一个像被削去顶部的金字塔形状。视椎体内部的物体将被绘制，视椎体外的东西将不会被绘制。
- 摄像机默认指向Z轴负方向，上方向朝向Y轴正方向。

## 1.2 响应式

避免画布大小改变出现拉伸问题

一个canvas的内部尺寸，它的分辨率，通常被叫做绘图缓冲区(drawingbuffer)尺寸。可以通过调用renderer.setSize来设置canvas的绘图缓冲区。

```js
renderer.setSize(width, height, false);

//设置渲染分辨率
  renderer.setPixelRatio(window.devicePixelRatio);
  
  //更新视图比例
    camera.aspect = canvas.clientWidth / canvas.clientHeight;

    camera.updateProjectionMatrix();
```

# 2. 图元

- 盒子BoxGeometry
- 平面圆CircleGeometry
- 锥形ConeGeometry
- 圆柱CylinderGeometry
- 十二面体DodecahedronGeometry
- 有厚度的2D形状（是TextGeometry的基础）Shape，ExtrudeGeometry
- 二十面体IcosahedronGeometry
- 八面体OctahedronGeometry
- 2D 平面PlaneGeometry
- 环形的 2D 圆盘RingGeometry
- 2D 的三角轮廓ShapeGeometry
- 球体SphereGeometry
- 四面体TetrahedronGeometry
- 3D 字体FontLoader，TextGeometry
- 圆环体（甜甜圈）TorusGeometry
- 环形节TorusKnotGeometry

## 2.1

- 基于 BufferGeometry 的图元是面向性能的类型。 几何体的顶点是直接生成为一个高效的类型数组形式，可以被上传到 GPU 进行渲染。这意味着它们能更快的启动，占用更少的内存。但如果想修改数据，就需要复杂的编程。

- 基于 Geometry 的图元更灵活、更易修改。它们根据 JavaScript 的类而来，像 Vector3 是 3D 的点，Face3 是三角形。它们需要更多的内存，在能够被渲染前，Three.js 会将它们转换成相应的 BufferGeometry 表现形式。

- 如果你知道你不会操作图元，或者你擅长使用数学来操作它们，那么最好使用基于 BufferGeometry 的图元。 但如果你想在渲染前修改一些东西，那么 Geometry 的图元会更好操作。

- BufferGeometry 不能轻松的添加新的顶点。 使用顶点的数量在创建时就定好了，相应的创建存储，填充顶点数据。 但用 Geometry 你就能随时添加顶点。

- BufferGeometry是面片、线或点几何体的有效表述。包括顶点位置，面片索引、法相量、颜色值、UV 坐标和自定义缓存属性值。使用 BufferGeometry 可以有效减少向 GPU 传输上述数据所需的开销。
