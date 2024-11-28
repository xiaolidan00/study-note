官网文档解读 glTF 模型格式

glTF 是用于通过网络高效传输 3D 内容

glTF 的核心是一个 JSON 文件，用于描述场景的结构和组成，包含 3D 模型。

**特点:**

1.  体积小，适合用于传输
2.  易于被渲染（render）:多边形转三角形，材质只存对应值，无需的部分全删掉

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/928e7c699c424f28af7d09e21c9184f8~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb6df5fcd50a4a14b33661acae4a1654~tplv-k3u1fbpfcp-watermark.image?)

此文件的顶级元素为:

- `scenes`, `nodes`:场景的基本结构
- `cameras`:场景的视图配置
- `meshes`:三维对象的几何图形
- `buffers`, `bufferViews`, `accessors`:数据引用和结构
- `materials`:定义如何渲染对象
- `textures`, `images`, `samplers`:物体的表面外观
- `skins`:骨骼的顶点信息
- `animations`:属性随时间变换

> 对象之间的引用是通过使用索引来查找。存储 JSON 数据作为字符串，后跟缓冲区的二进制数据或图像。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e87550b448f74602a09e736e0c20976d~tplv-k3u1fbpfcp-watermark.image?)

**参考：**`https://www.khronos.org/files/gltf20-reference-guide.pdf`
