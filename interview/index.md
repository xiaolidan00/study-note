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

## 浮点数精度问题

<https://developer.baidu.com/article/details/3146447>

JavaScript 中浮点数精度问题的根源在于它们是如何存储和计算的。由于它们使用二进制表示，所以对于一些不能精确表示为十进制数的分数，它们可能会出现精度损失。例如，0.1 在二进制中是一个无限重复的小数，所以当它在 JavaScript 中被存储时，它可能会被近似为一个稍微不同的值。

1. 使用 decimal libraries：有一些库，如 decimal.js 或 bignumber.js，mathjs
2. 将小数点像右多移动 n 位，取整后再除以 (10 * n)

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

304 资源未被修改(协商缓存)

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
   - DOM 树和 CSS 样式规则树构建完成后，渲染进程将两者合并成渲染树（Render Tree）
   - 渲染进程开始对渲染树进行布局，生成布局树(Layout Tree)
   - 渲染进程对布局树进行绘制，显示到页面中

**注意：**

- 遇到 css，不会阻塞 DOM 树的解析，但会阻塞 DOM 树的渲染，并会阻塞 js 执行。
- 遇到 js，会阻塞 DOM 树的解析，所以 js 要放在下面或者异步加载。defer 或 async。

## Web图片资源的加载与渲染时机

<https://segmentfault.com/a/1190000010032501>

1. img在html解析的时候就会加载，即便是display:none也会加载，只是不会渲染出来。图片改变导致的闪现问题可以使用img此属性来解决
2. css中背景图片等图片资源属性，解析样式规则树的时候不会加载，当DOM树与样式规则树匹配构建渲染树，即渲染树此带图片资源样式的DOM不是不可见，才会加载并渲染出来。
3. 样式规则中，渲染树种遇到不可见元素，不会遍历子元素，即不会加载子元素样式中的图片资源。

## http1.0,http1.0和http2.0区别

**http1.0**

- 每次资源请求都创建连接关闭连接

**http1.1**

- 资源请求默认长连接，一次创建，多次请求，最终才关闭连接，协商缓存，请求头put,delete,options
- 多请求排队等着

**http2.0**

- 采用二进制格式而非文本格式
- 完全多路复用，而非有序并阻塞的、只需一个连接即可实现并行
- 使用报头压缩，降低开销
- 服务器推送
