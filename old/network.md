# Cookie、Session、WebStorage 的区别

- cookie：用来保存客户浏览器请求服务器页面的请求信息，大小 4KB,HttpOnly 属性可以阻止通过 javascript 访问 cookie
- session：是一种服务器端的机制，服务器使用一种类似于散列表的结构来保存信息
- WebStorage 提供了 localStorage、sessionStorage 两种 API，大小都在 5M
- cookie 数据存放在客户的浏览器上，session 数据放在服务器上
- cookie 不是很安全，别人可以分析存放在本地的 cookie
- session 会在一定时间内保存在服务器上。当访问增多，会占用服务器的性能
- cookie：可以通过 expires 设置失效时间，不设置默认关闭浏览器即失效
- localStorage：除非手动清除，否则永久保存
- sessionStorage：仅在当前会话时候生效，关闭页面即失效

|          | cookie        | Local storage | Session Storage |
| -------- | ------------- | ------------- | --------------- |
| 容量     | 4kb           | 10mb          | 5mb             |
| 作用域   | 同源          | 同源          | 当前网页        |
| 过期时间 | 手动          | 永久          | 当前网页关闭    |
| 位置     | 浏览器/服务端 | 浏览器        | 浏览器          |

# HTTP 与 HTTPS 区别

- HTTP 明文传输，数据都是未加密的，安全性较差，HTTPS（SSL+HTTP） 数据传输过程是加密的，安全性较好。
- 使用 HTTPS 协议需要到 CA（Certificate Authority，数字证书认证机构） 申请证书，一般免费证书较少，因而需要一定费用。证书颁发机构如：Symantec、Comodo、GoDaddy 和 GlobalSign 等。
- HTTP 页面响应速度比 HTTPS 快，主要是因为 HTTP 使用 TCP 三次握手建立连接，客户端和服务器需要交换 3 个包，而 HTTPS 除了 TCP 的三个包，还要加上 ssl 握手需要的 9 个包，所以一共是 12 个包。
- http 和 https 使用的是完全不同的连接方式，用的端口也不一样，前者是 80，后者是 443。
- HTTPS 其实就是建构在 SSL/TLS 之上的 HTTP 协议，所以，要比较 HTTPS 比 HTTP 要更耗费服务器资源。

# HTTPS 工作原理

1. 服务端证书
2. 客户端校验
3. 随机数，RSA 公钥加密，消息体摘要 MD5 加密=》RAS 签名
4. 服务端 RSA 私钥解密=》随机数，AES 加密作为密钥（服务端与客户端）

一、首先 HTTP 请求服务端生成证书，客户端对证书的有效期、合法性、域名是否与请求的域名一致、证书的公钥（RSA 加密）等进行校验；

二、客户端如果校验通过后，就根据证书的公钥的有效， 生成随机数，随机数使用公钥进行加密（RSA 加密）；

三、消息体产生的后，对它的摘要进行 MD5（或者 SHA1）算法加密，此时就得到了 RSA 签名；

四、发送给服务端，此时只有服务端（RSA 私钥）能解密。

五、解密得到的随机数，再用 AES 加密，作为密钥（此时的密钥只有客户端和服务端知道）

# TCP 与 UDP 的区别

| 对比     | TCP                              | UDP                            |
| -------- | -------------------------------- | ------------------------------ |
| 可靠性   | 可靠                             | 不可靠                         |
| 连接性   | 面向连接                         | 无连接                         |
| 报文     | 面向字节流                       | 面向报文                       |
| 效率     | 传输效率低                       | 传输效率高                     |
| 双工性   | 全双工                           | 一对一、一对多、多对多、多对一 |
| 流量控制 | 滑动窗口                         | 无                             |
| 拥塞控制 | 慢开始、拥塞避免、快重传、快恢复 | 无                             |
| 传输速度 | 慢                               | 快                             |
| 应用场景 | 效率低、准确性要求高、有连接     | 效率高、准确性要求低           |

1. 基于连接与无连接；
2. 对系统资源的要求（TCP 较多，UDP 少）；
3. UDP 程序结构较简单；
4. 流模式与数据报模式 ；
5. TCP 保证数据正确性，UDP 可能丢包；
6. TCP 保证数据顺序，UDP 不保证。

# TCP 握手过程

![三次握手](images/TCP3.png)

1. 建立 tcp 链接（三次握手，客户端发送 syn=j 给服务端然后处于 syn_send 状态；
2. 服务端接受到 syn，然后发送自己的 syn 包 syn=k，和 ack=j+1（确认客户端包），状态为 syn_recv；
3. 客户端收到 ack 和 syn 则发送 ack=k+1 给服务端表示确认，服务端和客户端都进入了 establish 状态）

**为什么要 3 次握手**

确认客户端的接收、发送能力正常，服务器自己的发送、接收能力也正常

三次握手之所以是三次是保证 client 和 server 均让对方知道自己的接收和发送能力没问题而保证的最小次数。

- 第一次 client => server 只能 server 判断出 client 具备发送能力
- 第二次 server => client client 就可以判断出 server 具备发送和接受能力。此时 client 还需让 server 知道自己接收能力没问题于是就有了第三次
- 第三次 client => server 双方均保证了自己的接收和发送能力没有问题其中，为了保证后续的握手是为了应答上一个握手，每次握手都会带一个标识 seq，后续的 ACK 都会对这个 seq 进行加一来进行确认。

# TCP 四次挥手

![四次挥手](images/TCP4.png)

# 一个页面从输入 URL 到页面加载显示完成过程

1. HTTP 请求准备阶段

- 构建请求--浏览器构建请求行信息，准备发起网络请求 GET /index.html HTTP1.1
- 查找缓存--如果浏览器发现请问资源在浏览器中存在副本，根据强缓存规则，如没有过期那么直接返回资源，如何查找失败进入下一个环节：
  --准备 ip 地址和端口
  --DNS（域名和 ip 的映射系统） 域名解析，拿到 ip 之后找端口，默认为 80
  --建立 tcp 链接（三次握手）
  --如果是 https 还需要建立 TLS 连接

2. HTTP 发送请求

浏览器向服务端发起 http 请求，把请求头和请求行一起发送个服务器，服务端解析请求头如发现 cache-control 和 etag（if-none-match），if-modified（if-modified-since）字段就会判断缓存是否过期，如果没有返回 304，否则返回 200

3. HTTP 响应返回

- 浏览器拿到响应数据，首先判断是否是 4XX 或者 5XX 是就报错，如果是 3XX 就重定向，2XX 就开始解析文件，如果是 gzip 就解压文件
- TCP 断开连接
- 4 次挥手
- 浏览器解析渲染
- 建立根据 html 建立 dom 树和 css 树，如果遇到 script 首选判断是否 defer 和 async 否则会阻塞渲染并编译执行 js，如果没有则组合生成 render tree，最后浏览器开启 GPU 进行绘制合成图层，将内容显示屏幕

# URL 从输入到网页显示的全过程

1. dns 域名解析，得到实际的 ip 地址，浏览器 -- 本地 hosts -- 本地域名服务器（递归查找） -- 根域名服务器（迭代查找）
2. 检查浏览器是否有缓存：

- Cache-Control 和 Expires 来检查是否命中强缓存，命中则直接取本地磁盘的 html（状态码为 200 from disk(or memory) cache，内存 or 磁盘）；
- 没有命中强缓存，则会向服务器发起请求（先进行下一步的 TCP 连接），服务器通过 Etag 和 Last-Modify 来与服务器确认返回的响应是否被更改（协商缓存），若无更改则返回状态码（304 Not Modified）,浏览器取本地缓存；

3. 建立 TCP 连接，三次握手，如果协议是 https，还需要做加密；
4. 浏览器发送请求获取页面 html；
5. 服务器响应 html；
6. 浏览器解析 html；

# 浏览器页面的渲染流程

1. 浏览器通过请求得到 HTML
2. 渲染进程解析 HTML,生成 DOM 树
3. 解析 HTML 的同时，如果遇到内联样式和样式脚本，则下载并生成 CSS 样式规则，遇到 js 则下载该脚本
4. DOM 树和 CSS 样式规则书构建完成后，渲染进程将两者合并成渲染树（Render Tree）
5. 渲染进程开始对渲染树进行布局，生成布局树(Layout Tree)
6. 渲染进程对布局树进行绘制，显示到页面中

## html 渲染过程

- 将 html 解析成一个 DOM 树（深度遍历），将 css 解析成 css 规则树，浏览器引擎会将它们合并成渲染树。生成对应布局，绘制界面。
- 过程中，遇到 css，不会阻塞 DOM 树的解析，但会阻塞 DOM 树的渲染，并会阻塞 js 执行。
- 遇到 js，会阻塞 DOM 树的解析，所以 js 要放在下面或者异步加载。defer 或 async。

# options 请求

options 请求就是预检请求，可用于检测服务器允许的 http 方法。

当发起跨域请求时，由于安全原因，触发一定条件时浏览器会在正式请求之前自动先发起 OPTIONS 请求，即 CORS 预检请求，服务器若接受该跨域请求，浏览器才继续发起正式请求；不支持的话，会在控制台显示错误

所以，当触发预检时，跨域请求便会发送 2 次请求。

# dns 加速原理

1. 当用户点击网站页面上的 url 时，经过本地 dns 系统解析，dns 系统会将域名的解析权给交 cname 指向的 cdn 专用 dns 服务器。
2. cdn 的 dns 服务器将 cdn 的全局负载均衡设备 ip 地址返回给用户。
3. 用户向 cdn 的全局负载均衡设备发起内容 url 访问请求。
4. cdn 全局负载均衡设备根据用户 ip，以及用户请求的内容 url，选择一台用户所属区域的区域负载均衡设备

# Web 攻击技术

1. XSS（Cross-Site Scripting，跨站脚本攻击）：指通过存在安全漏洞的 Web 网站注册用户的浏览器内运行非法的 HTML 标签或者 JS 进行的一种攻击。
2. SQL 注入攻击
3. CSRF（跨站点请求伪造）：指攻击者通过设置好的陷阱，强制对已完成的认证用户进行非预期的个人信息或设定信息等某些状态更新

## 跨域脚本攻击 XSS

跨站脚本攻击(xss)：恶意攻击者通过往 web 页面中插入恶意 html 代码，当用户浏览该页面时，嵌入 web 里面的 html 代码会被执行，从而达到恶意攻击用户的特殊目的。
xss 如何进行预防：

- 输入过滤：防止 HTML 中出现注入，防止 JavaScript 执行时，执行恶意代码。
- 预防存储型和反射型 XSS 攻击：改成纯前端渲染，把代码和数据分隔开，对 HTML 做充分转义。
- 预防 DOM 型 XSS 攻击：DOM 型 XSS 攻击，实际上就是网站前端 JavaScript 代码本身不够严谨，把不可信的数据当作代码执行了。如果不可信的数据拼接到字符串中传递给这些 API，很容易产生安全隐患，请务必避免。

# 跨域

服务端设置跨域

- Access-Control-Allow-Origin
  指示请求的资源能共享给哪些域。
- Access-Control-Allow-Credentials
  指示当请求的凭证标记为 true 时，是否响应该请求。
- Access-Control-Allow-Headers
  用在对预请求的响应中，指示实际的请求中可以使用哪些 HTTP 头。
- Access-Control-Allow-Methods
  指定对预请求的响应中，哪些 HTTP 方法允许访问请求的资源。
- Access-Control-Expose-Headers
  指示哪些 HTTP 头的名称能在响应中列出。
- Access-Control-Max-Age
  指示预请求的结果能被缓存多久。
- Access-Control-Request-Headers
  用于发起一个预请求，告知服务器正式请求会使用那些 HTTP 头。
- Access-Control-Request-Method
  用于发起一个预请求，告知服务器正式请求会使用哪一种 HTTP 请求方法。
- Origin
  指示获取资源的请求是从什么域发起的

nginx 代理转发

前端设置跨域

- devServer 设置 proxy
- document.domain 修改访问域
- jsonp

# 浏览器工作原理

## 进程

- 浏览器进程 (Browser Process) ：负责浏览器的 TAB 的前进、后退、地址栏、书签栏的工作和处理浏览器的一些不可见的底层操作，比如网络请求和文件访问。
- 渲染进程 (Renderer Process) ：负责一个 Tab 内的显示相关的工作，也称渲染引擎。
- 插件进程 (Plugin Process) ：负责控制网页使用到的插件
- GPU 进程 (GPU Process) ：负责处理整个应用程序的 GPU 任务

## 进程关系

1. 当我们浏览一个网页，会在浏览器的地址栏里输入 URL，这个时候 Browser Process 会向这个 URL 发送请求，获取这个 URL 的 HTML 内容。
2. 将 HTML 交给 Renderer Process，Renderer Process 解析 HTML 内容，解析遇到需要请求网络的资源又返回来交给 Browser Process 进行加载，同时通知 Browser Process，需要 Plugin Process 加载插件资源，执行插件代码。
3. Renderer Process 计算得到图像帧，并将这些图像帧交给 GPU Process，GPU Process 将其转化为图像显示屏幕。

## 浏览器进程 (Browser Process)工作线

- UI thread：控制浏览器上的按钮及输入框；
- network thread：处理网络请求，从网上获取数据；
- storage thread： 控制文件等的访问；

### 流程

1. 处理输入
2. 开始导航
3. 读取响应
4. 查找渲染进程
5. 提交导航
6. 初始化加载完成

## 网页渲染原理

- 一个主线程（main thread）
- 多个工作线程（work thread）
- 一个合成器线程（compositor thread）
- 多个光栅化线程（raster thread）

### 流程

1. 构建 DOM
2. 子资源加载
3. JavaScript 的下载与执行
4. 样式计算 - Style calculation
5. 布局 - Layout
6. 绘制 - Paint
7. 合成 - Compositing

# 如何极致的优化动画性能

1. 使用 CSS 动画：CSS 动画借助 GPU 加速，在大多数情况下具有更好的性能。使用 transform 和 opacity 属性，避免使用 top、left 等属性进行动画操作。
2. 使用 requestAnimationFrame：requestAnimationFrame 是浏览器提供的优化动画的方法，可以更好地与浏览器的渲染机制同步。
3. 减少重绘和回流：通过合并多个 DOM 修改、使用 transform 进行动画变换，避免频繁的 DOM 重绘和回流操作，以提高性能。
4. 使用硬件加速：使用 CSS 属性 translate3d、scale3d 等可以启用 GPU 硬件加速，提高动画的性能。
5. 避免使用阻塞操作：确保动画执行期间没有长时间的 JavaScript 计算或网络请求阻塞主线程。
