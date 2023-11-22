# 微前端

- 将一个庞大的前端应用拆分成多个独立灵活的小型应用，每个应用都可以独立开发、独立运行、独立部署，再将这些小型应用融合为一个完整的应用
- 将原本运行已久、没有关联的几个应用融合为一个应用。

微前端既可以将多个项目融合为一，又可以减少项目之间的耦合，提升项目扩展性，相比一整块的前端仓库，微前端架构下的前端仓库倾向于更小更灵活。
它主要解决了两个问题：
1、随着项目迭代应用越来越庞大，难以维护。
2、跨团队或跨部门协作开发项目导致效率低下的问题。

## micro-app 与 single-spa 和 qiankun 区别

single-spa 是通过监听 url change 事件，在路由变化时匹配到渲染的子应用并进行渲染，这个思路也是目前实现微前端的主流方式。同时 single-spa 要求子应用修改渲染逻辑并暴露出三个方法：bootstrap、mount、unmount，分别对应初始化、渲染和卸载，这也导致子应用需要对入口文件进行修改。因为 qiankun 是基于 single-spa 进行封装，所以这些特点也被 qiankun 继承下来，并且需要对 webpack 配置进行一些修改。

micro-app 并没有沿袭 single-spa 的思路，而是借鉴了 WebComponent 的思想，通过 CustomElement 结合自定义的 ShadowDom，将微前端封装成一个类 WebComponent 组件，从而实现微前端的组件化渲染。并且由于自定义 ShadowDom 的隔离特性，micro-app 不需要像 single-spa 和 qiankun 一样要求子应用修改渲染逻辑并暴露出方法，也不需要修改 webpack 配置，是目前市面上接入微前端成本最低的方案。

**mirco-app 优势**

js 沙箱、样式隔离、元素隔离、预加载、数据通信、静态资源补全

# webpack

## 打包流程

1. 搭建结构，读取配置参数
2. 用配置参数对象初始化 Compiler 对象
3. 挂载配置文件中的插件
4. 执行 Compiler 对象的 run 方法开始执行编译
5. 根据配置文件中的 entry 配置项找到所有的入口
6. 从入口文件出发，调用配置的 loader 规则，对各模块进行编译
7. 找出此模块所依赖的模块，再对依赖模块进行编译
8. 等所有模块都编译完成后，根据模块之间的依赖关系，组装代码块 chunk
9. 把各个代码块 chunk 转换成一个一个文件加入到输出列表
10. 确定好输出内容之后，根据配置的输出路径和文件名，将文件内容写入到文件系统

## webpack5

- 在小型项目中，添加过多的优化配置，作用不大，反而会因为额外的 loader、plugin 增加构建时间；
- 在加快构建时间方面，作用最大的是配置 cache，可大大加快二次构建速度。
- 在减小打包体积方面，作用最大的是压缩代码、分离重复代码、Tree Shaking，可最大幅度减小打包体积。
- 在加快加载速度方面，按需加载、浏览器缓存、CDN 效果都很显著。
- 提高 Web 平台的兼容性

## HMR 流程

- style-loader 内置 Css 模块热更
- vue-loader 内置 Vue 模块热更
- react-hot-reload 内置 React 模块热更接口

1. 使用 webpack-dev-server (后面简称 WDS)托管静态资源，同时以 Runtime 方式注入 HMR 客户端代码
2. 浏览器加载页面后，与 WDS 建立 WebSocket 连接
3. Webpack 监听到文件变化后，增量构建发生变更的模块，并通过 WebSocket 发送 hash 事件
4. 浏览器接收到 hash 事件后，请求 manifest 资源文件，确认增量变更范围
5. 浏览器加载发生变更的增量模块
6. Webpack 运行时触发变更模块的 module.hot.accept 回调，执行代码变更逻辑
7. done

## Webpack 与 Vite

1. webpack 打包的时候会有两个阶段: 编译和打包，但打包之后会有一个问题，就是随着模块的增多，会造成打出的 bundle 体积过大，进而会造成热更新速度明显拖慢。

2. vite 的诞生就是为了解决这样的问题，当模块越来越多时，热更新速度并不会变慢。 当然，这仅仅只是针对 Vue 项目开发阶段的工具，其他的场景还是需要依赖强大的 Webpack 的。vite 也并不是万能的。

**webpack**

- 先打包生成 bundle，再启动开发服务器
- HMR 时需要把改动模块及相关依赖全部编译
- 内存高效利用

**vite**

- 先启动开发服务器，利用新一代浏览器的 ESM 能力，无需打包，直接请求所需模块并实时编译
- HMR 时只需让浏览器重新请求该模块，同时利用浏览器的缓存（源码模块协商缓存，依赖模块强缓存）来优化请求

# Vite

## vite 特性

Instant Server Start —— 即时服务启动
Lightning Fast HMR —— 闪电般快速的热更新
Rich Features —— 丰富的功能
Optimized Build —— 经过优化的构建
Universal Plugin Interface —— 通用的 Plugin 接口
Fully Typed APIs —— 类型齐全的 API

## Vite 整个热更新过程可以分成四步：

1. 创建一个 websocket 服务端和 client 文件，启动服务
2. 通过 chokidar 监听文件变更
3. 当代码变更后，服务端进行判断并推送到客户端
4. 客户端根据推送的信息执行不同操作的更新

- 启动热更新：createWebSocketServer: 在 Vite dev server 启动之前，Vite 会为 HMR 做一些准备工作：比如创建 websocket 服务，利用 chokidar 创建一个监听对象 watcher 用于对文件修改进行监听等等。createWebSocketServer 这个方法主要是创建 WebSocket 服务并对错误进行一些处理，最后返回封装好的 on、off、 send 和 close 方法，用于后续服务端推送消息和关闭服务。
- 执行热更新：moduleGraph+handleHMRUpdate 模块。接收到文件改动执行的回调，这里主要两个操作：moduleGraph.onFileChange 修改文件的缓存和 handleHMRUpdate 执行热更新。moduleGraph 是 Vite 定义的用来记录整个应用的模块依赖图的类，除此之外还有 moduleNode。moduleGraph 是由一系列 map 组成，而这些 map 分别是 url、id、file 等与 ModuleNode 的映射，而 ModuleNode 是 Vite 中定义的最小模块单位。
- handleHMRUpdate: 主要是监听文件的更改，进行处理和判断通过 WebSocket 给客户端发送消息通知客户端去请求新的模块代码。

# rollup

rollup 是一款 ES Modules 打包器，相比于 Webpack，Rollup 要小巧的多，打包生成的文件更小。
1、优势

打包的产物比较干净，体积小，没有 webpack 那么多工具函数。
插件机制设计得相对更干净简洁，单个模块的 resolve / load / transform 跟打包环节完全解耦。
rollup 原生支持 tree-shaking

2、劣势

对 js 以外的模块的支持上不如 webpack，加载其他类型的资源文件或者支持导入 CommonJS 模块等，需要使用插件去完成。
rollup 不支持 HMR（热更新），使开发效率降低。
rollup 并不适合开发应用使用，因为需要使用第三方模块，而目前第三方模块大多数使用 CommonJs 方式导出成员。

# SPA 首屏加载慢

- 减小入口文件积，按需加载
- 静态资源本地缓存
- UI 框架按需加载
- 图片资源的压缩
- 组件重复打包
- 开启 GZip 压缩
- 使用 SSR

# Webpack 构建优化手段

体积优化：使用 webpack-bundle-analyzer 分析打包文件的体积和构成

- 代码压缩
- 剔除无用依赖， 如 moment
- 路由懒加载 import
- 分包
- externals 配合，cdn 引入

速度优化：使用 smp(speed-measure-webpack-plugin) 或 webpackbar 分析耗时

- 缩小构建范围：比如配置 babel-loader 不解析 node_modules
- 减少文件搜索范围：配置路径别名 等
- 并行： thread-loader，terser-webpack-plugin 开启 parallel
- 利用原生语言框架，使用 esbuild-loader，提高转译速度

缓存：

- terser-webpack-plugin 开启 cache
- babel-loader 开启 cache
- 使用 cache-loader ，耗时的 loader 之前使用
- hard-source-webpack-plugin，构建缓存二次构建时间减少 80%

vue-cli4 默认配置已经添加了很多优化，包括：

- teser-webpack-plugin 代码压缩，且开启 parallel 和 cache 选项
- thread-loader 多线程： 为 babel-loader 开启了多线程
- cache-loader 缓存： 为 babel-loader 和 vue-loader 都开启了缓存
- eslint-loader：开启 cache 选项
- url-loader：小于 4K 的图片会转 base64
- mini-css-extract-plugin，提取 css
- preload-webpack-plugin：入口加上 preload，按需加载文件加上 prefetch
