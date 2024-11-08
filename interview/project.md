# 工程化

## ESM 与 CJS 区别

- ES Module 输出的是值的引用，而 CommonJS 输出的是值的拷贝；
- ES Module 是编译时执行，而 CommonJS 模块是在运行时加载；
- ES6 Module 可以导出多个值，而 CommonJs 是单个值导出；
- ES6 Module 静态语法只能写在顶层，而 CommonJs 是动态语法可以写在判断里；
- ES6 Module 的 this 是 undefined，而 CommonJs 的 this 是当前模块；

## Webpack tree-shaking 原理

- Tree Shaking 都是在 ES Module 标准只上的：静态编译，确定输入输出值；
- 搜集依赖—>标记引用—>清除 DeadCode。

## Webpack 打包工作流程

1. entry 入口文件
2. 加载模块，loader 规则转译处理
3. 广播事件 plugin 处理，
4. 生成 chunk，输出列表
5. 最终结果

## Webpack HMR 工作流程

1. webpack-dev-server 与浏览器客户端建立 websocket 连接
2. Webpack 监听到文件变化后，增量构建发生变更的模块，并通过 WebSocket 发送 hash 事件
3. 浏览器接收到 hash 事件后，请求 manifest 资源文件，确认增量变更范围
4. 浏览器加载发生变更的增量模块
5. Webpack 运行时触发变更模块的 module.hot.accept 回调，执行代码变更逻辑

## webpack 的 loader 和 plugin 区别和常用插件

**官方**

- loader 用于对模块的源代码进行转换。loader 可以使你在 require() 或"加载"模块时预处理文件。
- Plugin: webpack 插件是一个具有 apply 属性的 JavaScript 对象。apply 属性会被 webpack compiler 调用，并且插件可在整个编译生命周期访问。这些包通常会以某种方式扩展编译功能。

**别人概括：**

- loader 是文件加载转换成js可以理解的模块
- plugin:拓展编译功能，在 webpack 运行的生命周期中会广播出许多事件，plugin 可以监听这些事件，在合适的时机通过 webpack 提供的 API 改变输出结果。

## webpack 中 chunk,module,bundle 区别

- bundle 由许多不同的模块生成，包含已经经过加载和编译过程的源文件的最终版本。
- chunk: 在 webpack 内部用于管理捆绑过程。输出束（bundle）由块组成，其中有几种类型（例如 entry 和 child ）。通常，块 直接与 输出束 (bundle）相对应，但是，有些配置不会产生一对一的关系。
- module 是离散功能块，相比于完整程序提供了更小的接触面。精心编写的模块提供了可靠的抽象和封装界限，使得应用程序中每个模块都具有条理清楚的设计和明确的目的。

## webpack 懒加载

- import()
- 异步组件：vue:defineAsyncComponent,react:lazy
- 异步加载路由：vue：import(),react:lazy

## Vite、Webpack、Rollup 三者对比

- vite: bundleless,依赖按需加载，缓存，问题一旦依赖模块比较多，首次加载会很慢
- webpack: 所有文件都是模块，可进行复杂处理，生态完善，项目大打包慢
- rollup: ES Modules 打包器，纯净小巧，支持 tree-shaking，不支持 HMR（热更新），cjs 转换有限

## webpack打包后发布到浏览器es5环境

通过babel编译，将es6转为es5，配置target
<https://www.webpackjs.com/loaders/babel-loader/>

## Rollup 常用插件

rollup-plugin-postcss，rollup-plugin-scss，rollup-plugin-vue，@rollup/plugin-node-resolve，@rollup/plugin-commonjs，@rollup/plugin-babel，@rollup/plugin-terser，@rollup/plugin-strip，'@rollup/plugin-json

## pnpm 解决问题

1. 避免重复安装依赖 ，安装速度快
2. 幽灵依赖：没有 package.json 安装的包，因为依赖关系扁平化，导致安装了许多不认识的包
3. 软链接和硬链接,复用同一数据块
4. 解决版本冲突和兼容问题

## pnpm 软链接和硬链接

1.硬链接:文件指向相同的数据块，共享数据块。不会占用额外的磁盘空间(实际的文件路径，同一磁盘下：D:\pnpm-cache\store\v3\files)

2.软链接：指向实际文件夹的快捷方式

软链接可理解为指向源文件的指针，它是单独的一个文件，仅仅只有几个字节，它拥有独立的 inode
硬链接与源文件同时指向一个物理地址，它与源文件共享存储数据，它俩拥有相同的 inode

## webpack 性能优化

### webpack 性能优化-构建速度

- 优化 babel-loader，指定范围
- ignorePlugin 避免引入无用模块
- noParse 避免重复打包
- happyPack 多进程打包
- ParallelUglifyPlugin 多进程压缩 js

**开发时**

- 自动刷新：整个网页刷新，速度慢，状态丢失，
- 热更新：新代码剩下，网页不刷新，状态不丢失
- DllPlugin 动态链接库， 体积大，稳定的库只构建一次。
- webpack-bundle-analyzer 分析

### webpack 性能优化-产出代码

- 体积更小
- 合理分包，不重复加载
- 速度快，内存使用更少
- 小图片 base64 编码
- bundle 加 hash
- 懒加载
- 提取公共代码，代码分割
- IgnorePlugin 避免引入无用模块
- 使用 CDN 加速：externals
- 使用 production：自动 tree-shaking
- Scope Hosting:合并文件，减少作用域，webpack.optimize.ModuleConcatenationPlugin

## vite 和 rollup 打包优化

- external:外部引入，不打入包里，vite-plugin-cdn-import 可添加 cdn
- rollup-plugin-visualizer 查看包体积分布、各插件占比情况
- vite-plugin-imagemin 压缩图片
- @rollup/plugin-terser 压缩代码

## webpack sourcemap 区别

对于开发环境，适合使用：

- eval：速度极快，但只能看到原始文件结构，看不到打包前的代码内容
- cheap-eval-source-map：速度比较快，可以看到打包前的代码内容，但看不到 loader 处理之前的源码
- cheap-module-eval-source-map：速度比较快，可以看到 loader 处理之前的源码，不过定位不到列级别
- eval-source-map：初次编译较慢，但定位精度最高

对于生产环境，则适合使用：

- source-map：信息最完整，但安全性最低，外部用户可轻易获取到压缩、混淆之前的源码，慎重使用
- hidden-source-map：信息较完整，安全性较低，外部用户获取到 .map 文件地址时依然可以拿到源码
- nosources-source-map：源码信息确实，但安全性较高，需要配合 Sentry 等工具实现完整的 Sourcemap 映射

## webpack 怎么加载 chunk,webpack_require 怎样实现

jsonp 模拟 import()

## 微前端存在问题

无法完全做到沙箱隔离，共享模块重复加载，子模块通信问题

# Node.js

## koa 和 express 封装后台的原理

http.createServer，req.url 内容进行路径匹配，对应处理 req 的内容，返回 res

## JWT(JSON web Token)

用于在各方之间安全传输信息的开放标准（RFC 7519）
使得信息可以作为 JSON 对象进行传递，并且这些信息是可信的，因为它们都经过了数字签名。

组成：Header，Payload，Signature

- Header：典型的由两部分组成：token 的类型（“JWT”）和算法名称（比如：HMAC SHA256 或 RSA）。
- Payload JWT 的第二部分是 payload，它包含声明（要求）。声明是关于实体(通常是用户)和其他数据的声明。声明有三种类型: registered, public 和 private。
- Signature：HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(payload), secret)

验证：headers 中的 Authorization: Bearer

## 服务端渲染 SSR

采用 Node.js 部署前端服务器

1. 浏览器请求 URL，前端服务器接收到请求后，根据不同 url，前端服务器想后端服务器请求数据。
2. 请求完成后，前端服务器会组装一个携带了具体数据的 HTML,并返回给浏览器。
3. 浏览器得到 HTML 后开始渲染页面，同时浏览器加载并执行 js,给页面元素绑定事件，让页面变得可交互。
4. 当用户与浏览器页面进行交互（如跳到下个页面）时，浏览器会执行 js,向后端服务器请求数据，获取完数据后，再次执行 js，动态渲染页面。

- 优势：首屏的用户体验，SEO 支持。
- 劣势：运维麻烦，兼容 node 和浏览器两端，代码复杂度增加

## webpack跨域代理

<https://vue3js.cn/interview/webpack/proxy.html>

 http-proxy-middleware

当本地发送请求的时候，代理服务器响应该请求，并将请求转发到目标服务器，目标服务器响应数据后再将数据返回给代理服务器，最终再由代理服务器将数据响应给本地
