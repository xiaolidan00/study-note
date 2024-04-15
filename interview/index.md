# 基础

## 事件冒泡、事件捕获、事件流、事件代理

- 事件冒泡：从目标元素自下而上一直到 window（结束）这样一个过程,可使用 stopPropagation() 和 cancelBubble 阻止冒泡
- 事件捕获：从 window 自上而下一直到目标元素的这样一个过程
  一般是先执行捕获，后执行冒泡
- 事件流：当一个事件触发时候，一般会经历 3 个过程，第一个为捕获阶段，第二个为目标阶段，第三个为冒泡阶段
- 事件代理：将动作监听挂载在父元素，通过捕获阶段得到触发动作的子元素，再进行动作处理，减少浏览器内存损坏。

## EventLoop 事件循环、宏任务、微任务

eventloop 过程

1. 同步代码，一行一行放在 call stack 执行
2. 遇到异步，先记录下，等待时机（网络请求，定时器）
3. 时机到了，将异步移到 callback queue 中
4. 如果 call stack 为空（即同步代码执行完毕），eventloop 开始工作
5. 轮询查找 callback queue，如果有则移动到 call stack 执行
6. 然后继续轮询查找（永动机）

宏任务主要包含：UI 交互事件、setTimeout、setInterval、I/O(Node.js 环境)、setImmediate(Node.js 环境)

微任务主要包含：Promise、MutationObserver、process.nextTick(Node.js 环境)

1. call stack 空闲（全部 script 代码执行完，可用 alert 阻断 js 执行和 dom 渲染，查看效果）
2. （执行微任务）尝试 DOM 渲染（执行宏任务）
3. 触发 Event loop

## async/await 与 promise 区别

- 异步回调地狱
- promise then catch 链式调用，但也基于回调函数
- async/await 同步语法，彻底消灭回调函数，
- 与 promise 不排斥，两者相辅相成
- 执行 async 函数，返回的是 promise 对象
- await 相当于 promise 的 then
- try catch 可捕获异常，代替 promise catch
- await 后面可看做 promise then 的 callback 内容

## 原型和原型链/原型、构造函数、实例三者关系

```js
//实例.constructor === 构造函数
s.constructor==Student

//实例.__proto__==原型
s.__proto__===Student.prototype

原型链：instanceof 通过`__proto__`找到对于 prototype 则为 true
```

## 作用域和闭包

- 一个变量在当前作用域没有定义，但被使用了
- 向上级作用域一层一层地寻找，直到找到为止
- 如果到全局作用域仍没有找到，则报错 xx is not defined
- 所有自由变量的查找在函数定义的地方，向上级作用域查找，而不是在执行的地方

## this 指向，改变 this 指向的方法

- 作为普通函数
- 使用 call,apply,bind 改变 this 指向
- 作为对象方法调用
- 在 class 方法中调用
- 箭头函数
- this 的指向是在函数执行的时候确认，不是在函数定义

this 指向

- this 是 window:全局,单纯的函数名+括号执行,匿名函数自执行,定时器中,箭头函数中 this 暴露在外面
- this 是当前对象：事件触发，触发谁 this 就是谁，对象方法中，.前面是谁 this 就指向谁，构造函数中 this 是实例化对象
- 严格模式下 this 是 undefined
- 箭头函数中 this 指向上一级

## 检测数据类型

typeof、instanceof、constructor、Object.prototype.toString.call()

## cookie、localstorage、session 区别

cookie

- 本身用于浏览器和 server 通讯
- 被借用到本地存储来
- 存储大小最大为 4K
- http 请求时需发送到服务端，增加请求数据量

localStorage,sessionStorage

- H5 专门为存储设计，最大可存 5M
- API 简单易用，setItem,getItem，removeItem
- 不会随着 http 请求被发送出去，只存在浏览器
- localStorage 永久存储，除非代码或手动删除
- sessionStorage 只存在当前会话，浏览器关闭则清空

## es5 和 es6 继承的方式有哪些

原型链继承
构造函数继承
组合继承
原型式继承
寄生式继承
类（Class）继承

## script 脚本的 defer 和 async 区别

- 两个都是异步加载 JS 脚本，不阻塞 html 解析
- defer 是先加载，等到 dom 解析完，在 DOMContentLoaded 事件之前按顺序执行脚本
- async 是加载完立即执行,顺序不定
- type="module"的效果等同于 defer

## webp 图片格式为什么会变小

图像数据中存在着冗余
webp 有损压缩与无损压缩（可逆压缩）的图片文件格式，派生自影像编码格式 VP8
对比 jpg 减少 40%

## href 和 src 区别

href:超文本引用,用于在当前元素和文档之间建立链接.浏览器会识别该文档为 CSS 文档，并行下载该文档，同时不会停止对当前文档的处理

src:资源的来源。用于将指向的内容嵌入到文档中当前标签所在的位置.浏览器在解析到该元素时，会暂停浏览器的渲染，直到该资源加载完毕

## 算数符??

```js
list?.[3]?.a
false??4 =>false
0??4=>0
const a = { duration: 50 };
a.duration ??= 10;//a.duration=>50
a.speed ??= 25;//a.speed=>25
```

## jsonp 应用场景

跨域请求获取数据
webpack 模块加载

## base64 为什么使图片大小增加了

6 位转 8 位 ASCII 码，6 和 8 的最小公倍数是 24，也就是 3 个字节，每 6 位一组，也就是 4 组，每组前面补 2 个 0，凑够 8 位。所以这个时候就变成了 4 个字节，也就是增加了 33.33%

# 网络

## http 状态码

**分类：**

- 1xx 服务器收到请求
- 2xx 请求成功
- 3xx 重定向
- 4xx 客户端错误
- 5xx 服务端错误

**常见状态码：**

200 成功

301 永久重定向（配合 location，浏览器自动处理）

302 临时重定向（配合 location，浏览器自动处理）

304 资源未被修改

404 资源未找到

403 没有权限

500 服务器错误

504 网关超时

## https 工作原理

1. 服务端证书
2. 客户端校验
3. 客户端校验通过，生成随机数，RSA 公钥加密，消息体摘要 MD5 加密=》RAS 签名
4. 服务端 RSA 私钥解密=》随机数，AES 加密作为密钥（服务端与客户端）

消息体摘要 MD5:防止篡改，消息的完整性

## http 缓存

**强制缓存**
Cache-Control:max-age=31536000(单位秒)
最大的缓存时间为一年

- max-age 缓存时间
- no-cache 不需强制缓存，交给服务端处理
- no-store 不需要本地和服务端的缓存

**协商缓存**

- Last-Modified 资源最后修改的时间，If-Modified-Since
- ETag 资源的唯一标识（一个字符串，类似人类指纹），If-None-Match
- 服务器判断客户端资源是否与服务端一致
- 一致则返回 304（资源未被修改，读取浏览器缓存），否则返回 200 和最新资源

**三种刷新操作**

- 正常操作：地址栏输入 URL，跳转链接=》强制缓存有效，协商缓存有效
- 手动刷新：F5,右键菜单栏=》强制缓存失效，协商缓存有效
- 强制刷新：ctrl+F5=》强制缓存和协商缓存失效

## 跨域

**服务器端设置**

- nginx 代理转发
- CORS 服务器设置 http headers

```js
//允许跨域的设置
Access-Control-Allow-Origin:http://localhost:8080
Access-Controll-Allow-Headers:X-Requested-With
Access-Controll-Allow-Methods:"PUT,POST,GET,DELETE,OPTIONS"

//接收跨域cookie
Access-Controll-Allow-Credentials:true
```

**前端设置跨域**

- devServer 设置 proxy
- document.domain 修改访问域
- jsonp

## Web 攻击与防范手段

1. **XSS（跨站脚本攻击）**：

   - 非持久型 XSS（反射型 XSS）：通过 URL 传递恶意脚本代码。
   - 持久型 XSS（存储型 XSS）：通过表单提交等方式将恶意脚本保存到服务器，然后执行。
   - 防御措施：对用户输入进行转义处理，确保服务器端和客户端都不直接执行用户输入的脚本。

2. **CSRF（跨站请求伪造）**：

   - 攻击者利用用户的登录状态，伪造请求执行恶意操作。
   - 防御措施：使用 CSRF 令牌，验证请求的合法性。

3. **SQL 注入**：

   - 攻击者通过构造恶意 SQL 语句，获取数据库信息或执行其他操作。
   - 防御措施：使用参数化查询，限制数据库操作权限，对输入进行验证和转义。

4. **命令行注入**：

   - 攻击者通过 HTTP 请求执行系统命令。
   - 防御措施：对用户输入进行严格的验证和转义，不直接拼接命令行。

5. **DDoS（分布式拒绝服务）攻击**：

   - 通过大量请求使服务器资源过载，导致服务不可用。
   - 防御措施：优化网络架构，使用负载均衡，限制请求频率，使用专业的 DDoS 防御设备。

6. **流量劫持**：

   - 包括 DNS 劫持和 HTTP 劫持，篡改用户请求的内容。
   - 防御措施：使用 HTTPS 加密通信，防止内容被篡改。

7. **服务器漏洞**：

   - 如越权操作、目录遍历、物理路径泄漏等。
   - 防御措施：合理设计数据库表结构，对 URL 和参数进行转义过滤，定制错误页面。

## 浏览器渲染过程

1. dns 域名解析，得到实际的 ip 地址，浏览器 -- 本地 hosts -- 本地域名服务器（递归查找） -- 根域名服务器（迭代查找）
2. 检查浏览器是否有缓存：
   - Cache-Control 和 Expires 来检查是否命中强缓存，命中则直接取本地磁盘的 html（状态码为 200 from disk(or memory) cache，内存 or 磁盘）；
   - 没有命中强缓存，则会向服务器发起请求（先进行下一步的 TCP 连接），服务器通过 Etag 和 Last-Modify 来与服务器确认返回的响应是否被更改（协商缓存），若无更改则返回状态码（304 Not Modified）,浏览器取本地缓存；
3. 建立 TCP 连接，三次握手，如果协议是 https，还需要做加密；
4. 浏览器发送请求获取页面 html；
5. 服务器响应 html；
6. 浏览器解析 html；
   - 渲染进程解析 HTML,生成 DOM 树（深度遍历）
   - 解析 HTML 的同时，如果遇到内联样式和样式脚本，则下载并生成 CSS 样式规则，遇到 js 则下载该脚本
   - DOM 树和 CSS 样式规则书构建完成后，渲染进程将两者合并成渲染树（Render Tree）
   - 渲染进程开始对渲染树进行布局，生成布局树(Layout Tree)
   - 渲染进程对布局树进行绘制，显示到页面中

**注意：**

- 遇到 css，不会阻塞 DOM 树的解析，但会阻塞 DOM 树的渲染，并会阻塞 js 执行。
- 遇到 js，会阻塞 DOM 树的解析，所以 js 要放在下面或者异步加载。defer 或 async。

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

- loader 是文件加载转换
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

## Rollup 常用插件

rollup-plugin-postcss，rollup-plugin-scss，rollup-plugin-vue，@rollup/plugin-node-resolve，@rollup/plugin-commonjs，@rollup/plugin-babel，@rollup/plugin-terser，@rollup/plugin-strip，'@rollup/plugin-json

## pnpm 解决问题

1.避免重复安装依赖 ，安装速度快 2.幽灵依赖：没有 package.json 安装的包，因为依赖关系扁平化，导致安装了许多不认识的包 3.软链接和硬链接 4.解决版本冲突和兼容问题

## pnpm 软链接和硬链接

1.硬链接:文件指向相同的数据块，共享数据块。不会占用额外的磁盘空间 2.软链接：指向实际文件夹的快捷方式

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

# Vue

## Vue3 对比 vue2 的有哪方面的提升

1. 体积更小,代码组织更清晰，编译优化
2. 数据劫持方式:Vue2 Object.defineProperty vue3 Proxy，结合 Reflect 操作数据
3. 更好地支持 ts，SSR,tree-shaking
4. 组合式 API，Suspense，Fragment，Teleport
5. 虚拟 DOM 增加静态标记 patchFlag,事件缓存，对不参与更新的元素做静态提升，只创建一次，之后不停复用
6. 生命周期变了：beforeCreate,created 变成 setup，组合式 API

## vue2 和 vue3 生命周期

beforeCreate->setup
created->setup
beforeMount->onBeforeMounted
mounted->onMounted
beforeUpdate->onBeforeUpdate
updated->onUpdated
beforeDestroy->onBeforeUnmount
destroy->onUnmounted
activated->onActivited
deactivated->onDeactivated
errorCaptured->onErrorCaptured
renderTracked->onRenderTracked
renderTriggered->onRenderTrigger

## v-if 与 v-show 优先级

v-if>v-show

## v-if 在 vue2 和 vue3 中的不同

vue2 中 v-for 优先级高于 v-if

vue3 中 v-if 比 v-for 的优先级更高，可采用 template 包裹，尽量用 filter 后结果

## vue2，vue3 的数据劫持有什么不同

Vue2 Object.defineProperty get 收集依赖，set 通知更新
vue3 Proxy 13 中操作拦截，结合 Reflect 操作数据

## v-for 中 key 的作用

diff 算法对比 key 和 tag 相同则该节点没有改变

## vue2 的数组和对象不更新怎么处理

Vue.$set,$delete//给新属性添加响应式

## vue2 和 vue3 diff 算法工作流程

1. Vue2 diff 算法：遍历所有结点，导致 vnode 的更新新能跟模板大小正相关，跟动态结点的数量无关。当一些组件的整个模板内只有少量动态节点是，这些遍历就是浪费性能。
2. Vue3 将 vnode 的更新性能由于模板整体大小相关提升为与动态内容的数量相关。

## Vue 通信方式

1. 父子组件 props 和 emit
2. EventBus
3. Vuex,pinia
4. $parent,$children,$ref，expose
5. $attrs/$listeners
6. provide/inject

## Vue 与 React 的对比

**相同点：**

1. 组件化思想
2. 虚拟 dom
3. 数据驱动视图 MVVM
4. 支持服务器端渲染 SSR
5. 钩子函数 Hooks

**不同点：**

1. 数据流向：react 单向数据流，数据不可变，vue 双向数据流绑定，数据可变
2. 组件化通信：react 函数回调来通信，vue 有子组件向父组件发送事件和回调两种
3. diff 算法：react 主要使用 diff 队列保存需要更新哪些 DOM，得到 patch 树，再统一操作批量更新 DOM。Vue 使用双向指针，边对比，边更新 DOM
4. vue 有指令系统，computed，watch，react 只能用 jsx 语法
5. vue 组件全局注册和局部注册，react 通过 import 来引用

## keep-alive 的作用和原理

包裹一层缓存函数，根据传入的组件名，没有缓存就创建新的，有缓存就将缓存组件激活，别的组件时 deactived

## vue3 的组合式 API 与 React 的 Hooks 有什么不同

1. react hooks 有严格调用顺序，不可写在条件判断中，依靠依赖数组收集响应。需要用 useMemo(缓存函数计算结果),useCallback（缓存事件调用函数） 来缓存.可能会出现变量闭包不好追踪的问题
2. vue 的组合式 API 不限制调用顺序，可有条件调用，自动收集依赖，无需手动缓存

## vue 的性能优化

https://cn.vuejs.org/guide/best-practices/performance.html

1. 合理使用 v-show 和 v-if,v-once
2. 合理使用 computed
3. v-for 加 key，避免与 v-if 同时使用
4. 自定义事件和 dom 事件及时销毁
5. 合理使用异步组件,懒加载
6. 合理使用 keep-alive
7. SSR
8. 使用 tree-shaking 友好的 esmodule 第三方库
9. props 稳定性，active="activeId==item.id"
10. v-once：只渲染一次，更新跳过
11. v-memo：有条件地跳过某些大型子树或者 v-for 列表的更新
12. 虚拟滚动
13. 减少大型不可变数据的响应性开销：通过使用 shallowRef() 和 shallowReactive() 来绕开深度响应
14. 避免不必要的组件抽象，抽离出过多子组件

## vue 和 react 的 diff 算法有什么不同

1.react 新旧节点对比，缓存要更新的节点，再批量更新
2.vue 只对比动态节点，边对比边更新

## watch 与 watchEffect 区别

watchEffect 自动检测依赖，watch 手动设置依赖

## ref 与 reactive 区别

ref:基本类型
reactive：对象类型
ref.value 和和 reactive 最终都会执行 createReactiveObject

# React

## React 生命周期

```txt
React 16
挂载：
constructor->(getDerivedStateFromProps)->render->componentDidMount
更新：
new Props,setState,forceUpdate->(getDerivedStateFromProps)->(shouldComponentUpdate)->render->(getSnapshotBeforeUpdate)->componentDidUpdate
卸载
componentWillUnmount
```

## 类组件和函数组件的区别

- class 面向对象 ，继承，内部状态管理，生命周期，shouldComponentUpdate 优化
- 函数：函数式编程，hooks 模拟生命周期，React.memo 缓存

## setState 是同步更新还是异步更新

setTimeout DOM 事件同步，React 18 都是异步了

## 组件通讯的方式

props，回调函数，Context,redux 状态管理

## React 的渲染流程,Fiber 架构

Fiber 链表的树,对比新旧树，将指针指向新节点

## React 错误处理方案

ErrorBoundary ，UI 降级

## 如何避免重复渲染

React.memo,shouldComponentUpdate,PureComponent(SCU 默认浅比较)

## useEffect 与 useLayoutEffect 区别

- useEffect 渲染完成后执行函数，异步不阻塞渲染
- useLayoutEffect 渲染前执行函数,阻塞渲染

## redux、mobx、flux 三者区别

redux,flux 单向数据流，mobx 数据劫持

## React 的性能优化

1. 渲染列表时加 key
2. 自定义事件、DOM 事件及时销毁
3. 合理使用异步组件，懒加载 lazy
4. 减少函数 bind this 次数
5. 合理使用 SCU 和 memo
6. 合理使用 Immutable,useImmer
7. SSR
8. useCallback 和 useMemo 缓存
9. Fragment 减少层级嵌套
10. 虚拟列表： React-virtualized 或者是 React-window 等包。

## React Portal 的理解与使用

渲染到对应的 dom 里面，挂载非 root,比如对话框

## react hooks 为什么不能放在 if 和 for 里？

严格调用顺序，避免状态更新混乱

## hoc 如何管理状态？hooks 抽离公共逻辑

预置参数和操作逻辑

# typescript

https://typescript.p6p.net/typescript-tutorial/interface.html

## interface 与 type 的区别

1. type 能够表示非对象类型，而 interface 只能表示对象类型（包括数组、函数等）。
2. interface 可以继承其他类型，type 不支持继承。
3. 同名 interface 会自动合并，同名 type 则会报错。也就是说，TypeScript 不允许使用 type 多次定义同一个类型。
4. interface 不能包含属性映射（mapping），type 可以
5. type 可以扩展原始数据类型，interface 不行。
6. interface 无法表达某些复杂类型（比如交叉类型和联合类型），但是 type 可以。

## any,unknow,never 的区别

- unknown 跟 any 的相似之处，在于所有类型的值都可以分配给 unknown 类型。
- unknown 类型跟 any 类型的不同之处在于，它不能直接使用。
- unknown 类型的变量，不能直接赋值给其他类型的变量（除了 any 类型和 unknown 类型）。
- 不能直接调用 unknown 类型变量的方法和属性。
- unknown 类型变量能够进行的运算是有限的，只能进行比较运算（运算符==、===、!=、!==、||、&&、?）、取反运算（运算符!）、typeof 运算符和 instanceof 运算符这几种，其他运算都会报错。
- 只有经过“类型缩小”，unknown 类型变量才可以使用。所谓“类型缩小”，就是缩小 unknown 变量的类型范围，确保不会出错。
- never 空类型，抛出 error
