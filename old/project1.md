# 什么是 AST

在语言转换的过程中，实质上就是对其 AST 的操作，核心步骤就是 AST 三步走

Code -> AST (Parse)
AST -> AST (Transform)另外一种语言的 AST
AST -> Code (Generate)生成另一种语言的源码

AST 解析阶段: 词法分析(Lexical Analysis)和语法分析(Syntactic Analysis)

词法分析应用：

- 代码检查，如 eslint 判断是否以分号结尾，判断是否含有分号的 token
- 语法高亮，如 highlight/prism 使之代码高亮
- 模板语法，如 ejs 等模板也离不开

<https://github.com/jamiebuilds/the-super-tiny-compiler>

# webpack 的 runtime 做了什么事情

1. `webpack_modules`: 维护一个所有模块的数组。将入口模块解析为 AST，根据 AST 深度优先搜索所有的模块，并构建出这个模块数组。每个模块都由一个包裹函数 (module, module.exports, `webpack_require`) 对模块进行包裹构成。
2. `webpack_require`(moduleId): 手动实现加载一个模块。对已加载过的模块进行缓存，对未加载过的模块，执行 id 定位到 `webpack_modules` 中的包裹函数，执行并返回 module.exports，并缓存
3. `webpack_require`(0): 运行第一个模块，即运行入口模块

# webpack 中的 code spliting 是如何动态加载 chunk 的？

1. `__webpack_modules__`: 维护一个所有模块的数组。将入口模块解析为 AST，根据 AST 深度优先搜索所有的模块，并构建出这个模块数组。每个模块都由一个包裹函数 (module, module.exports, `__webpack_require__`) 对模块进行包裹构成。
2. `__webpack_require__`(moduleId): 手动实现加载一个模块。对已加载过的模块进行缓存，对未加载过的模块，根据 id 定位到 `__webpack_modules__` 中的包裹函数，执行并返回 module.exports，并缓存。

```js
__webpack_require__
  .e(/* import() | sum */ 644)
  .then(__webpack_require__.bind(__webpack_require__, 709))
  .then((m) => {
    m.default(3, 4);
  });
```

1. `__webpack_require__.e`: 加载 chunk。该函数将使用 document.createElement('script') 异步加载 chunk 并封装为 Promise。
2. `self["webpackChunk"].push`: JSONP cllaback，收集 modules 至 `__webpack_modules__`，并将 `__webpack_require__.e` 的 Promise 进行 resolve。

# 打包器(webpack/rollup) 如何加载 json、image 等非 Javascript 资源

json-loader
image-loader

# 打包器(webpack/rollup) 如何加载 style 样式资源

css-loader 的原理就是 postcss，借用 postcss-value-parser 解析 CSS 为 AST，并将 CSS 中的 url() 与 @import 解析为模块。

style-loader 用以将 CSS 注入到 DOM 中，原理为使用 DOM API 手动构建 style 标签，并将 CSS 内容注入到 style 中。

```js
module.exports = function (source) {
  return `
function injectCss(css) {
  const style = document.createElement('style')
  style.appendChild(document.createTextNode(css))
  document.head.appendChild(style)
}
 
injectCss(\`${source}\`)
  `;
};
```

mini-css-extract-plugin 单独抽离 css

# 打包器(webpack/rollup) 如何将打包后的 js 资源注入 html 中

1. main.js 即我们最终生成的文件带有 hash 值，如 main.8a9b3c.js。
2. 由于长期缓存优化的需要，入口文件不仅只有一个，还包括由第三方模块打包而成的 verdor.js，同样带有 hash。
3. 脚本地址同时需要注入 publicPath，而在生产环境与测试环境的 publicPath 并不一致

在 webpack 的世界里，它是 html-webpak-plugin，在 rollup 的世界里，它是 @rollup/plugin-html。

而注入的原理为当打包器已生成 entryPoint 文件资源后，获得其文件名及 publicPath，并将其注入到 html 中

# webpack 中什么是 HMR，原理是什么

热模块替换的原理，即通过 chunk 的方式加载最新的 modules，找到 `__webpack__modules__` 中对应的模块逐一替换，并删除其上下缓存。

1. webpack-dev-server 将打包输出 bundle 使用内存型文件系统控制，而非真实的文件系统。此时使用的是 memfs 模拟 node.js fs API
2. 每当文件发生变更时，webpack 将会重新编译，webpack-dev-server 将会监控到此时文件变更事件，并找到其对应的 module。此时使用的是 chokidar 监控文件变更
3. webpack-dev-server 将会把变更模块通知到浏览器端，此时使用 websocket 与浏览器进行交流。此时使用的是 ws
4. 浏览器根据 websocket 接收到 hash，并通过 hash 以 JSONP 的方式请求更新模块的 chunk
5. 浏览器加载 chunk，并使用新的模块对旧模块进行热替换，并删除其缓存

# 如何提升 webpack 构建资源的速度

- 更快的 loader: swc

1. SWC 是一个基于 Rust 的可拓展性的平台，用于下一代快速开发工具。它被 Next.js、Parcel 和 Deno 等工具使用，Vercel、字节跳动、腾讯、Shopify 等公司也在使用 SWC。

2. SWC 可以用于编译和打包。对于编译，SWC 将处理使用现代 JavaScript 特性的 JavaScript / TypeScript 文件并将其输出为支持所有主流浏览器的代码。

3. SWC 在单线程情况下比 Babel 块 20 倍，四核下要快 70 倍。

- 持久化缓存: cache

```js
module.exports = {
  cache: {
    type: 'filesystem',
    allowCollectingMemory: true
  }
};
```

- acorn: 用以依赖分析，解析为 acorn 的 AST
- eslint-parser: 用以 lint，解析为 espree 的 AST
- typescript: 用以 ts，解析为 typescript 的 AST
- babel: 用以转化为低版本，解析为 @babel/parser 的 AST
- terser: 用以压缩混淆，解析为 acorn 的 AST

得益于持久化缓存，二次编译甚至可得到与 Unbundle 的 vite 等相近的开发体验

- 多进程: thread-loader

thread-loader 为官方推荐的开启多进程的 loader，可对 babel 解析 AST 时开启多线程处理，提升编译的性能。

# 如何分析前端打包体积

可以使用 webpack-bundle-analyzer 分析打包后体积分析
<https://webpack.js.org/api/stats/>

```js
npx webpack --profile --json=compilation-stats.json

compiler.hooks.done.tapAsync("webpack-bundle-analyzer", (stats) => {});
```

- stat: 每个模块的原始体积
- parsed : 每个模块经 webpack 打包处理之后的体积，比如 terser 等做了压缩，便会体现在上边
- gzip: 经 gzip 压缩后的体积

# js 代码压缩 minify 的原理是什么

通过 AST 分析，根据选项配置一些策略，来生成一颗更小体积的 AST 并生成代码。

目前前端工程化中使用 terser 和 swc 进行 JS 代码压缩，他们拥有相同的 API。

- 去除多余字符: 空格，换行及注释
- 压缩变量名：变量名，函数名及属性名(但此时缩短变量的命名也需要 AST 支持，不至于在作用域中造成命名冲突。)
- 解析程序逻辑：合并声明以及布尔值简化
- 解析程序逻辑: 编译预计算

# Tree Shaking 的原理是什么

Tree Shaking 指基于 ES Module 进行静态分析，通过 AST 将用不到的函数进行移除，从而减小打包体积。

Tree Shaking 甚至可对 JSON 进行优化。原理是因为 JSON 格式简单，通过 AST 容易预测结果，不像 JS 对象有复杂的类型与副作用。

# core-js 是做什么用的？

core-js 是关于 ES 标准最出名的 polyfill，polyfill 意指当浏览器不支持某一最新 API 时，它将帮你实现，中文叫做垫片。

core-js 的伟大之处是它包含了所有 ES6+ 的 polyfill，并集成在 babel 等编译工具之中

core-js 已集成到了 babel/swc 之中，你可以使用 @babel/preset-env 或者 @babel/polyfill 进行配置

# browserslist 的意义

browserslist 用特定的语句来查询浏览器列表，如 last 2 Chrome versions

现代前端工程化不可或缺的工具，无论是处理 JS 的 babel，还是处理 CSS 的 postcss，凡是与垫片相关的，他们背后都有 browserslist 的身影。

- babel，在 @babel/preset-env 中使用 core-js 作为垫片
- postcss 使用 autoprefixer 作为垫片
- browserslist 根据正则解析查询语句，对浏览器版本数据库 caniuse-lite 进行查询，返回所得的浏览器版本列表。

手动更新数据库

```bash
npx browserslist@latest --update-db
```

# 浏览器中如何使用原生的 ESM

```js
 import data from "./data.json" assert { type: "json" };


 <script type="importmap">
  {
    "imports": {
      "lodash": "https://cdn.skypack.dev/lodash",
      "lodash/": "https://cdn.skypack.dev/lodash/"
    }
  }
</script>
<script type="module">
  import get from "lodash/get.js";
</script>
```

# 如何将 CommonJS 转化为 ESM

当 exports 转化时，既要转化为 export {}，又要转化为 export default {}

- 如何处理 `__dirname`
- 如何处理 require(dynamicString)
- 如何处理 CommonJS 中的编程逻辑

# 简述 bundless 的优势与不足

1. 项目启动快。因为不需要过多的打包，只需要处理修改后的单个文件，所以响应速度是 O(1) 级别，刷新即可即时生效，速度很快。
2. 浏览器加载块。利用浏览器自主加载的特性，跳过打包的过程。
3. 本地文件更新，重新请求单个文件。

# 什么是 semver，~1.2.3 与 ^1.2.3 的版本号范围是多少

semver，Semantic Versioning 语义化版本的缩写，文档可见 <https://semver.org/，它由> [major, minor, patch] 三部分组成，其中

- major: 当你发了一个含有 Breaking Change 的 API
- minor: 当你新增了一个向后兼容的功能时
- patch: 当你修复了一个向后兼容的 Bug 时

# package-lock 的工作流程

1. `npm i webpack`，此时下载最新 webpack 版本 5.58.2，在 package.json 中显示为 webpack: ^5.58.2，版本号范围是 `>=5.58.2 < 6.0.0`
2. 在 package-lock.json 中全局搜索 webpack，发现 webpack 的版本是被锁定的，也是说它是确定的 webpack: 5.58.2
3. 经过一个月后，webpack 最新版本为 5.100.0，但由于 webpack 版本在 package-lock.json 中锁死，每次上线时仍然下载 5.58.2 版本号
4. 经过一年后，webpack 最新版本为 6.0.0，但由于 webpack 版本在 package-lock.json 中锁死，且 package.json 中 webpack 版本号为 ^5.58.2，与 package-lock.json 中为一致的版本范围。每次上线时仍然下载 5.58.2 版本号
5. 支线剧情：经过一年后，webpack 最新版本为 6.0.0，需要进行升级，此时手动改写 package.json 中 webpack 版本号为 ^6.0.0，与 package-lock.json 中不是一致的版本范围。此时 npm i 将下载 6.0.0 最新版本号，并重写 package-lock.json 中锁定的版本号为 6.0.0

## npm i 某个 package 时会修改 package-lock.json 中的版本号吗？

当 package-lock.json 该 package 锁死的版本号符合 package.json 中的版本号范围时，将以 package-lock.json 锁死版本号为主。

当 package-lock.json 该 package 锁死的版本号不符合 package.json 中的版本号范围时，将会安装该 package 符合 package.json 版本号范围的最新版本号，并重写 package-lock.json

# package.json 中 main/module/browser/exports 字段有何区别

main 指 npm package 的入口文件，当我们对某个 package 进行导入时，实际上导入的是 main 字段所指向的文件。

main 是 CommonJS 时代的产物，也是最古老且最常用的入口文件。

```js
{
  name: 'midash',
  main: './index.js',
  exports: {
    '.': './dist/index.js',
    'get': './dist/get.js'
  }
}

// 正常工作
import get from 'midash/get'

// 无法正常工作，无法引入
import get from 'midash/dist/get'
```

# dependencies 与 devDependencies 有何区别

对于库 (Package) 开发而言，是有严格区分的

- dependencies: 在生产环境中使用
- devDependencies: 在开发环境中使用，如 webpack/babel/eslint 等

当在项目中安装一个依赖的 Package 时，该依赖的 dependencies 也会安装到项目中，即被下载到 node_modules 目录中。但是 devDependencies 不会

因此当我们开发 Package 时，需要注意到我们所引用的 dependencies 会被我们的使用者一并下载，而 devDependencies 不会。

# 如何为一个项目指定 node 版本号

```js
{
  "engines": {
    "node": ">=14.0.0"
  }
}
```

# npm script 的生命周期

当我们执行任意 npm run 脚本时，将自动触发 pre/post 的生命周期。

- prepublishOnly: 最重要的一个生命周期。
- prepack
- prepare
- postpack
- publish
- postpublish

在发包之前自动做一些事情，如测试、构建等，请在 prepulishOnly 中完成。

prepare

- npm install 之后自动执行
- npm publish 之前自动执行
  比如 husky

```js
{
  prepare: 'husky install';
}
```

**风险：**

确实有很多 npm package 被攻击后，就是通过 npm postinstall 自动执行一些事，比如挖矿等。

如果 npm 可以限制某些库的某些 hooks 执行，则可以解决这个问题。

# 如何对 npm package 进行发包

在本地(需要发包的地方)执行命令 npm login，进行交互式操作并且登录。

```js
{
  name: '@shanyue/just-demo',
  version: '1.0.0',
  main: './index.js',
}
{
  files: ["dist"]//实际发包内容
}
```

之后执行 npm publish 发包即可。

```bash
# 增加一个修复版本号: 1.0.1 -> 1.0.2 (自动更改 package.json 中的 version 字段)
$ npm version patch

# 增加一个小的版本号: 1.0.1 -> 1.1.0 (自动更改 package.json 中的 version 字段)
$ npm version minor

# 将更新后的包发布到 npm 中
$ npm publish
```

npm publish 将自动走过以下生命周期

- prepublishOnly: 如果发包之前需要构建，可以放在这里执行
- prepack
- prepare: 如果发包之前需要构建，可以放在这里执行 (该周期也会在 npm i 后自动执行)
- postpack
- publish
- postpublish

发包实际上是将本地 package 中的所有资源进行打包，并上传到 npm 的一个过程。你可以通过 npm pack 命令查看详情

# package-lock.json 有什么作用，如果项目中没有它会怎么样，举例说明

packagelock.json/yarn.lock 用以锁定版本号，保证开发环境与生产环境的一致性，避免出现不兼容 API 导致生产环境报错

当有了 lock 文件时，每一个依赖的版本号都被锁死在了 lock 文件，每次依赖安装的版本号都从 lock 文件中进行获取，避免了不可测的依赖风险。
