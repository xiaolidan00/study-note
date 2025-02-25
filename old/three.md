# WebGL 渲染流程

![image](images/webgl.png)

1. 基本处理（顶点缓冲对象）
2. 顶点着色器
3. 图元装配
4. 光栅化
5. 片元着色器
6. 剪裁测试
7. 深度测试、模板测试
8. 颜色缓冲混合
9. 抖动
10. 帧缓冲

# three.js 中的 WebGLRenderer 渲染过程

1. 清空当前帧缓冲区，更新 MVP 矩阵；
2. 将物体分为透明和不透明两类，按照离摄像机从近到远排序（也可在 Object3D 单独设置 renderOrder）；
3. 根据灯光信息，阴影计算，如果有开启平面裁剪就对进行剪裁；
4. 开始逐个渲染物体，按以下顺序，背景、不透明物体、透明物体；
5. 渲染前后还有两个类似于生命周期的回调函数，scene.onBeforeRender 和 scene.onAfterRender；
6. 最后将深度、模版测试、多边形偏移恢复默认。

# 深度冲突问题

renderOrder 设置单个 Object3D

depthTest 取消深度检测

WebGLRenderer logarithmicDepthBuffer

# PBR 材质

PBR 材质基于物理渲染的材质，Physically Based Rendering 光照，物体表面

- MeshStandardMaterial:metalness 金属度，roughness 粗糙程度

- MeshPhysicalMaterial:与 MeshStandardMaterial 参数相同，增加 clearcoat 涂抹的清漆光亮层的程度，clearCoatRoughness 光泽层的粗糙程度

# 渲染快慢

MeshBasicMaterial ➡ MeshLambertMaterial ➡ MeshPhongMaterial ➡ MeshStandardMaterial ➡ MeshPhysicalMaterial。

# 后期处理

首先，场景被渲染到一个渲染目标上，渲染目标表示的是一块在显存中的缓冲区。 接下来，在图像最终被渲染到屏幕之前，一个或多个后期处理过程将滤镜和效果应用到图像缓冲区。

# 性能优化

<https://juejin.cn/post/7220354212736450616>

<https://blog.csdn.net/u014361280/article/details/124285654>

1. InstancedMesh 复用网格
2. Merge 合并形状
3. 复用材质和形状和 clone
4. LOD
5. 及时清理释放内存
6. 低模用高细节的贴图代替
7. Instance、Merge 性能对比
8. 显示才渲染和可操作
9. 分时分区加载，大场景模型也根据分区拆分和加载
10. 降低帧率,60->30
11. controls 发生 change 才 render
12. material 降级

# 空间

- 模型空间
- 世界空间
- 摄像机空间
- 裁剪空间 Clipping Space：视椎体范围内
- 屏幕空间 Screen Space：2D 呈现的影像

# MVP 矩阵

- 模型矩阵 Model matrix ：进行物体坐标系到世界坐标系的转换，控制了物体的平移、旋转、缩放，模型的坐标
- 观察矩阵 View matrix：将世界坐标系变换到观察者坐标系，模拟一个摄像机
- 投影矩阵 Projection matrix：将观察者坐标系转换到裁剪坐标系。将 3D 坐标投影到 2D 屏幕上

# 片段和像素的区别？

- 片段是渲染一个像素需要的全部信息，所有片段经过测试与混合后渲染成像素。
- 片段是三维定点光栅化后的数据集合， 还没经过深度测试，而像素是片段经过深度测试、模板测试、alpha 混合之后的结果。
- 片段的个数远远多于像素， 因为有的片段会在测试和混合阶段被丢弃， 无法被渲染成像素。

# 反走样原理是什么？如何实现的

1. 增加分辨率
2. 先模糊后 采样：增加采样数（一个像素点内）

# 绘制半透明物体

- transparent:true
- depthTest 用于深度测试状态控制 开启
- depthWrite 用于深度写的状态控制 关闭

非透明排序函数可以看出，排序优先级 groupOrder>renderOrder>program.id>material.id>z 深度

透明排序函数可以看出，排序优先级 groupOrder>renderOrder>z 深度

1. 开启深度测试和 Blend 功能
2. 绘制所有不透明的物体队列
3. 关闭深度写入功能
4. 绘制所有半透明的物体
5. 释放深度缓冲区，使之可读可写

# 3D 数学

## 向量的大小（模）

各分量平方和的平方根

```
dist=Math.sqrt(x*x+y*y+z*z)
```

## 单位向量

大小为 1 的向量

```
V/|V|
```

归一化向量，标准化向量:获取向量的方向，即获取向量的单位向量
normalize

## 加减乘除

```
[x1,y1,z1]+[x2,y2,z2]=[x1+x2,y1+y2,z1+z2]
[x1,y1,z1]-[x2,y2,z2]=[x1-x2,y1-y2,z1-z2]
k[x,y,z]=[kx,ky,kz]
[x,y,z]/k=[x/k,y/k,z/k]
```

## 点积(内积、点乘)

各分向量的乘积

```
[x1,y1,z1].[x2,y2,z2]=x1*x2+y1*y2+z1*z2

dot(A,B)=|A||B|cosa


p分解成各个方向向量

p=dot(p,x)x+dot(p,y)y+dot(p,z)z

```

两个向量的模乘以夹角 cos
两个向量都是单位向量时，点乘等于夹角 cos

在标准化向量中，点积等于两向量夹角的余弦值

- 方向相同，点积为 1-
- 方向相反，点积为-1
- 相互垂直，点积为 0

## 叉乘（叉积、外积）

```
[x1,y1,z1]x[x2,y2,z2]=[y1*z2-z1*y2,z1*x2-x1*z2,x1*y2-y1*x2]
|cross(A,B)|=|A||B|sinb
```

两个向量面所组成面的垂直向量

模长=两个向量的模乘积再乘夹角正弦值

判断 B 向量在 A 向量的顺时针还是逆时针旋转方向（左侧右侧），AxB 得到的向量 z 为正，则 B 在 A 的左侧，否则右侧

判断点 P 是否在三角形 ABC 内，ABxAP 在左侧/右侧，同理 BCxBP,CAxCP 也在同一侧

## 两个向量距离

```js
a=[x1,y1,z1]
b=[x2,y2,z2]
(a,b)=|b-a|=Math.sqrt( (x2-x1)^2+ (y2-y1)^2+(z2-z1)^2)
```

## 转置

```
a b c
d e f
g h i

=>转置后

a d g
b e h
c f i
```

## 矩阵乘法

rxn 矩阵 A \* nxc 矩阵 B = rxc 矩阵 C

Cij 的结果等于 A 的第 i 行向量与 B 的第 j 列向量点乘的结果

## 向量与矩阵的乘法

(MxN)(NxP)=(MxP)
N 必须相同

新矩阵的第几行第几列的元素值，等于原矩阵第几行第几列的点乘值

```
           a b c
 [x,y,z] *[d e f] =[x*a+y*b+z*g,x*b+y*e+z*h,x*c+y*f+z*i]
           g h i

 a b c     x   a*x+b*y+c*z
[d e f] * [y]=[d*x+e*y+f*z]
 g h i     z   g*x+h*y+i*z


           a b c
[1,0,0] * [d e f]=[a,b,c]
           g h i

           a b c
[0,1,0] * [d e f]=[d,e,f]
           g h i


           a b c
[0,0,1] * [d e f]=[g,h,i]
           g h i
```
