# 服务端渲染 SSR

采用 Node.js 部署前端服务器

1. 浏览器请求 URL，前端服务器接收到请求后，根据不同 url，前端服务器想后端服务器请求数据。
2. 请求完成后，前端服务器会组装一个携带了具体数据的 HTML,并返回给浏览器。
3. 浏览器得到 HTML 后开始渲染页面，同时浏览器加载并执行 js,给页面元素绑定事件，让页面变得可交互。
4. 当用户与浏览器页面进行交互（如跳到下个页面）时，浏览器会执行 js,向后端服务器请求数据，获取完数据后，再次执行 js，动态渲染页面。

- 优势：首屏的用户体验，SEO 支持。
- 劣势：运维麻烦，兼容 node 和浏览器两端，代码复杂度增加

# 微前端方案对比

## qiankun 方案

qiankun 方案是基于 single-spa 的微前端方案。

**特点**

- html entry 的方式引入子应用，相比 js entry 极大的降低了应用改造的成本；
- 完备的沙箱方案，js 沙箱做了 SnapshotSandbox、LegacySandbox、ProxySandbox 三套渐进增强方案，css 沙箱做了 strictStyleIsolation、experimentalStyleIsolation 两套适用不同场景的方案；
- 做了静态资源预加载能力；

**不足**

- 适配成本比较高，工程化、生命周期、静态资源路径、路由等都要做一系列的适配工作；
- css 沙箱采用严格隔离会有各种问题，js 沙箱在某些场景下执行性能下降严重；
- 无法同时激活多个子应用，也不支持子应用保活；
- 无法支持 vite 等 esmodule 脚本运行；

## micro-app 方案

micro-app 是基于 webcomponent + qiankun sandbox 的微前端方案。

**特点**

- 使用 webcomponet 加载子应用相比 single-spa 这种注册监听方案更加优雅；
- 复用经过大量项目验证过 qiankun 的沙箱机制也使得框架更加可靠；
- 组件式的 api 更加符合使用习惯，支持子应用保活；
- 降低子应用改造的成本，提供静态资源预加载能力；

**不足**

- 接入成本较 qiankun 有所降低，但是路由依然存在依赖；
- 多应用激活后无法保持各子应用的路由状态，刷新后全部丢失；
- css 沙箱依然无法绝对的隔离，js 沙箱做全局变量查找缓存，性能有所优化；
- 支持 vite 运行，但必须使用 plugin 改造子应用，且 js 代码没办法做沙箱隔离；
- 对于不支持 webcompnent 的浏览器没有做降级处理；

## EMP 方案

EMP 方案是基于 webpack 5 module federation 的微前端方案。

**特点**

- webpack 联邦编译可以保证所有子应用依赖解耦；
- 应用间去中心化的调用、共享模块；
- 模块远程 ts 支持；
  **不足**

- 对 webpack 强依赖，老旧项目不友好；
- 没有有效的 css 沙箱和 js 沙箱，需要靠用户自觉；
- 子应用保活、多应用激活无法实现；
- 主、子应用的路由可能发生冲突；

**结论**

- qiankun 方案对 single-spa 微前端方案做了较大的提升同时也遗留下来了不少问题长时间没有解决；
- micro-app 方案对 qiankun 方案做了较多提升但基于 qiankun 的沙箱也相应会继承其存在的问题；
- EMP 方案基于 webpack 5 联邦编译则约束了其使用范围；

# SPA 首屏加载慢的处理方案

- 减小入口文件积，按需加载
- 静态资源本地缓存
- UI 框架按需加载
- 懒加载
- 图片资源的压缩，CDN
- 组件重复打包
- 开启 GZip 压缩
- 使用 SSR

# npm 模块安装机制

生命周期函数 preinstall、install、postinstall

1. 执行工程自身 preinstall
2. 确定首层依赖模块
3. 获取模块
4. 模块扁平化（dedupe），查询 node_modules 目录之中是否已经存在指定模块
5. 安装模块
   - npm 向 registry 查询模块压缩包的网址
   - 下载压缩包，存放在根目录下的.npm 目录里
   - 解压压缩包到当前项目的 node_modules 目录
6. 执行工程自身生命周期： install、postinstall、prepublish、prepare
7. 生成或更新版本描述文件 package.json，npm install 过程完成。

# Webpack

## 特点

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

# Vite

## 特点

- 开发环境下无需打包，Vite 将会使用 esbuild 预构建依赖，冷启动快（es6 module)，根据依赖关系动态引入，依赖模块和静态资源缓存。
- 生产环境用 rollup 打包

问题：一旦依赖模块比较多，首次加载会很慢

# monorepo

https://zhuanlan.zhihu.com/p/640021617

## 什么是 Monorepo？

它是一种源代码管理的模式，其形式就是将多个项目集中到一个仓库中管理；

与之相对的是 Polyrepo 模式，这种模式下各个项目都有独立的仓库；

简而言之，Monorepo 就是将多个不同的项目以良好地组织关系，放到单个仓库中维护；

Polyrepo:子项目分布到不同仓库中管理（npm link：node_modules 软连接到对应目录）
Monorepo：子项目组织到一个仓库统一管理

## Monorepo 如何降低多项目的维护成本

- **复用基建**，让开发人员重新专注于应用本身

- **代码共享**，能够低成本的做到代码复用

- **原子提交**，使用自动化的多项目工作流

# 优化动画性能

1. 使用 CSS 动画：CSS 动画借助 GPU 加速，在大多数情况下具有更好的性能。使用 transform 和 opacity 属性，避免使用 top、left 等属性进行动画操作。
2. 使用 requestAnimationFrame：requestAnimationFrame 是浏览器提供的优化动画的方法，可以更好地与浏览器的渲染机制同步。
3. 减少重绘和回流：通过合并多个 DOM 修改、使用 transform 进行动画变换，避免频繁的 DOM 重绘和回流操作，以提高性能。
4. 使用硬件加速：使用 CSS 属性 translate3d、scale3d 等可以启用 GPU 硬件加速，提高动画的性能。
5. 避免使用阻塞操作：确保动画执行期间没有长时间的 JavaScript 计算或网络请求阻塞主线程。

# ESM 与 CJS 区别

- ES Module 输出的是值的引用，而 CommonJS 输出的是值的拷贝；
- ES Module 是编译时执行，而 CommonJS 模块是在运行时加载；
- ES6 Module 可以导出多个值，而 CommonJs 是单个值导出；
- ES6 Module 静态语法只能写在顶层，而 CommonJs 是动态语法可以写在判断里；
- ES6 Module 的 this 是 undefined，而 CommonJs 的 this 是当前模块；

# Tree Shaking 实现原理

- Tree Shaking 都是在 ES Module 标准只上的：静态编译，确定输入输出值；

- 搜集依赖—>标记引用—>清除 DeadCode。

# webpack 中 chunk,module,bundle 区别

- bundle 由许多不同的模块生成，包含已经经过加载和编译过程的源文件的最终版本。
- chunk: 在 webpack 内部用于管理捆绑过程。输出束（bundle）由块组成，其中有几种类型（例如 entry 和 child ）。通常，块 直接与 输出束 (bundle）相对应，但是，有些配置不会产生一对一的关系。
- module 是离散功能块，相比于完整程序提供了更小的接触面。精心编写的模块提供了可靠的抽象和封装界限，使得应用程序中每个模块都具有条理清楚的设计和明确的目的。

# webpack 中 loader 与 plugin 区别

**官方**

- loader 用于对模块的源代码进行转换。loader 可以使你在 require() 或"加载"模块时预处理文件。
- Plugin: webpack 插件是一个具有 apply 属性的 JavaScript 对象。apply 属性会被 webpack compiler 调用，并且插件可在整个编译生命周期访问。这些包通常会以某种方式扩展编译功能。

**别人概括：**

- loader 是文件加载转换
- plugin:拓展编译功能，在 webpack 运行的生命周期中会广播出许多事件，plugin 可以监听这些事件，在合适的时机通过 webpack 提供的 API 改变输出结果。
