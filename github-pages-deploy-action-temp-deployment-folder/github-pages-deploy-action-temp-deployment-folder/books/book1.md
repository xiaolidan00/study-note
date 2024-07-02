《前端开发必知必会：从工程核心到前沿实战》候跃伟

https://fanqienovel.com/page/7144936438138686500

# npm

先行版本号可以加到“主版本号.次版本号.修订号”的后面，通过“\_"号连接以点分险的标识符和版本编译信息:内部版本(alpha)、公测版本(beta)和候选版本(rc，即 release candiate)

查看 npm 包的版本信息

```bash
//查看vue最新版本
npm view vue version
//查看vue所有版本
npm view vue versions
```

.npmignore npm 不提交的文件声明

```json
{
  "packageManager": "pnpm@8.10.0",
  //npm依赖安装文件列表，npm发包推送文件
  "files": ["src", "dist/*.js", "types/*.d.ts"],
  //版本要求
  "engines": {
    "node": ">=8.10.3 <12.13.0",
    "npm": ">=6.9.0"
  },
  //可以使用npm link命令吧这些文件导入全局路径中，以便在任意目录下执行
  "bin": {
    "react-script": "./bin/react-script.js",
    "vue": "bin/vue.js"
  },
  "config": {
    "port": 8088
  },
  //npm包中的所有文件都开启CDN服务，该服务由unpkg提供
  "unpkg": "dist/vue.js",
  "main": "src/index.js",
  //ts入口文件
  "typings": "types/index.ts",
  //在git暂存文件上云霄linters的工具，配置后每次修改一个文件即可给所有文件执行一次lint检查，通常配合githooks使用
  "lint-staged": {
    "*.js": ["eslint --fix", "git add"]
  },
  //定义一个钩子，在提交commit之前执行eslint检查。在执行lint命令后，会自动修复暂存区的文件。修复之后的文件并不存储在暂存区中，所以要用git add命令将修复后的文件重新加入暂存区。
  "gitHooks": {
    "pre-commit": "lint-staged"
  },
  //js代码检查和优化工具库
  "standard": {
    "parser": "babel-eslint",
    "ignore": ["**/out/", "/lib/aa/"]
  },
  "babel": {
    "presets": ["@babel/preset-env"],
    "plugins": []
  }
}
```

# babel

```js
process.env.npm_package_config_port; //8088
//使用@babel/cli编译babel
babel src --out-dir lib
```

**babel 工作过程**

- 解析(parse):将源代码转换成抽象语法树(Abstract Syntax Tree，AST)树上的每个节点都表示源代码中的一种结构。
- 转换(transform):对抽象语法树做一些特殊处理，使其符合编译器的期望，在 Babel 中主要使用转换担件实现。
- 代码生成(generate):将转换过的抽象语法树生成新的代码。

```js
const { parse } = require('@babel/parser');
const { default: generate } = require('@babel/generator');
let code = 'const sum=(a,b)=>a+b';
let ast = parse(code, { sourceType: 'module' });
let targetCode = generate(ast);
```

```js
module.exports = {
  plugins: [
    '@babel/plugin-transform-runtime',

    {
      absoluteRuntime: false,
      corejs: false,
      helpers: true,
      regenerator: true,
      version: '7.0.0-beta.0'
    }
  ],
  presets: [
    [
      '@babel/preset-env',
      {
        targets: {
          chrome: '58',
          ie: '11',
          edge: '17',
          safari: '11.1'
        }
      }
    ]
  ]
};
```

# Deno

Deno 是 Node.js 作者 Ryan Dahl 于 2017 年创立的项目，至今已经发布到 1.9.2 版本。这是一个安全的 TypeScript/JavaScript 运行时，该运行时是在 V8 引擎的基础上使用 Rust 开发的，同时内置了 TSC 引擎，用来解释 TypeScript。event-loop 由 TOkio 框架提供支持。由于 Rust 原生支持 WebAssembly，所以 Deno 能直接运行 WebAssembly.

**Deno 的主要特性如下:**

- 默认安全，外部代码没有模块、文件和网络权限，除非显式开启。
- 支持“开箱即用”的 TypeScript 环境。
- 只分发一个独立的可执行文件(deno)
- 有内建的工具箱，比如依赖信息査看器(deno info)和代码格式化工具(deno fmt)。
- 有一组经过审计的标准模块，保证能在 Deno 上工作。
- 脚本代码能被打包为一个单独的 JavaScript 文件。

Deno 和 Node.js 的作者虽然是同一个人，但它们面向的对象是不同的。众所周知，Node.js 面向的是服务端，而 Deno 面向的是浏览器生态。所以，Deno 并不是要取代 Node.js，也不是下一代 Node.js，更不是要放弃 npm 包重建 Node 生态。

Deno 是遵从 ES module 规范的，所以可以通过 export 暴露模块，通过 import 导入模块。

Demo 默认没有模块、文件和网络权限，所以当执行时需要添加开启读文件的权限。

```bash


deno run index.js

```

```js
const text = Deno.readTextFile('./person.json');
test.then((res) => console.log(res));
// 读写权限
//deno run--allow-read readtext.ts

const res = await fetch('api/user');
const data = await res.json();
console.log(data);
// 网络权限
//deno run --allow-net index.js

Deno.env.set('APP_URL', 'api');
console.log(Deno.env.get('APP_URL'));
//设置环境变量
//deno run --allow-env index.js

//加载第三方包
import * as bcrypt from 'https://deno.land/x/bcrypt/mod.ts';

const hash = await bcrypt.hash('hello world');
console.log(hash);
//deno run --allow-net --unstable index.js

import { serve } from 'https://deno.land/std@0.95.0/http/server.ts';
const server = serve({ port: 9001 });
console.log('http://localhost:9001/');
for await (const req of server) {
  req.respond({ body: 'hello this i from deno server' });
}
```

# 脚手架实现

```json
{
  "bin": {
    "my-cli": "./bin/index.js"
  }
}
```

```js
const program = require('commander');
const create = require('../core/create');
program
  .version('0.0.1')
  .command('create <name>')
  .description('create a new project')
  .action((name) => {
    console.log(name);
  });
```

# 常用模式

## 状态模式

## 代理模式

## 观察者模式

## 装饰模式

## 适配器模式

## 策略模式

# V8 引擎

webkit 的子集

## webkit 架构

```txt
webkit嵌入式接口  webkit2嵌入式接口
webkit绑定        webkit2绑定
———————————————————————————————————————————————————————
webcore               |  jscore |     webkit ports
css svg  布局 渲染树   |         |  网络栈  视频  文字
html dom inspector    |         | 硬件加速  图片解码
———————————————————————————————————————————————————————
2D图形库 3D图形库 网络库 存储 音频库 视频库
———————————————————————————————————————————————————————
操作系统
```

WebKit 和 Chromium 中使用的 JavaScript 引擎是 V8 引擎。JavaScript 引擎就是能够处理 JavaScript 代码并给出运行结果的程序，该引擎根据 JavaScript 提供的桥接接口提供访问 DOM 的能力。
渲染引擎将页面转变成可视化的图像结果，即渲染出来。渲染引擎主要包含 HTML 解释器、CSS 解释器、布局(layout)和 JavaScript 擎

## 宏任务和微任务

js 为了实现多线程，引入了 Web Worker，但是对该技术的使用却有诸多限制:
(1)新线程都受主线程的完全控制，不能独立执行，属于主线程的子线程。
(2)子线程没有操作 I/0 的权限。

宏任务:I/O、setTimeout、setlnterval 和 requestAnimationFrame.
微任务:Promise.then、catch、finally 和 await(后)

# chrome 渲染进程

Chrome 是多进程的，两个进程之间以 IPC (nter Process Communication) 消息的方式进行通信，顶层由一个 Browser Process (浏览器进程) 来协调浏览器的其他进程

Chrome 的主要进程及职责如下:

- Browser Process(浏览器进程): 负责包括地址栏、书签栏，以及前进或后退按钮等工作:负责处理浏览器的一些不可见的底层操作，比如网络请求和文件访问等

- Renderer Process (渲染进程) : 主要负责网页清染

- Plugin Process (插件进程): 管理一个网页用到的所有插件，比如逐渐被淘汰的 Flash 插件等.

- GPU Process (GPU 进程) : 处理 GPU 相关的任务

- Utility Process (工具进程) : 负责任务初始化。

从上面各个进程的职责来看，浏览器进程主要协调 Tab 页签之外的工作，并且对这些工作进行了细粒度的划分

主要使用不同的线程进行处理:

- UI 线程: 控制浏览器上的按钮及输入项等

- network 线程: 处理网络请求，从网上获取数据

- storage 线程: 控制文件等的访问

渲染进程负责 Tab 页内的所有事情，其职责是把 HTML、(CSS 和 JavaScript 代码转换为可与用户交互的 Web 页面。在演染进程中主要包合以下线程:

- 主线程 (Main Thread) : 处理用户输入的大部分代码

- 工作线程 (Worker Thread) : 如果使用 Web Worker 或者 Service Worker，则该线程负责处理一部分 JavaScript 代码

-排版线程 (Compositor Thread) : 主要负责染页面

- 光栅线程 (Raster Thread) : 负责组合不同的层形成帧
  ![aaa](images/2024-4/2024-4-1.png)

## defer 和 async 的区别是:

defer 是在整个页面正常渲染结束后 (DOM 结构完全生成，其他脚本也执行完) 才会执行，而 async 是只要脚本下载完，就中断渲染，先执行这个脚本，再回到渲染流程。

需要注意的是，如果有多个 defer 脚本，则会按照它们在页面中定义的顺序进行加载;如果有多个 async 脚本则不能保证加载顺序。

-defer: 延迟加载脚本，在文档解析完成后开始执行，并且在 DOMContentLoaded 事件之前执行完成

-async: 异步加载脚本，需下载完毕后再执行，在 load 事件之前执行完成

总的来说，defer 是渲染完再执行，async 是“下载完就执行

## IntersectionObserver

IntersectionObserver APl 提供了一种异步观察目标元素与祖先元素或视窗(viewport) 的交集中的变化的方法。祖先元素与视窗被称为根 (root) 。

很多时候，我们希望某些静态资源 (比如图片) 只有在进入视图范围内时才被加载，以节省带宽，提高网页性能。
![aaa](images/2024-4/2024-4-2.png)

## Service Worker

Service Worker 是由事件驱动的具有生命周期并且独立于浏览器的主线程。它可以拦截处理页面的所有网络请求(fetch)，还可以访问缓存和 ndexDB，支持推送，并且可以让开发者自己控制、管理缓存的内容及版本，为离线弱网环境下的 Web 运行提供了可能。

Service Worker 的基本特征如下

- 无法操作 DOM。

- 只能使用 HTTPS 和 localhost.

- 拦截全站请求

- 与主线程独立，不会被际塞 (不用在应用加载时注册 Service Worker) 。

- 完全异步，无法使用 XHR 和 localStorage。

- 一旦安装，就永进存在，除非卸载或者使用开发者模式手动初除

- 独立上下文。

-响应推送

- 后台同步
  ![aaa](images/2024-4/2024-4-3.png)
  ![aaa](images/2024-4/2024-4-4.png)

Web Worker 为 JavaScript 创建了多线程环境，它运行主线程，创建多线程，可以把一些

运算分配给这些子线程处理，减轻了主线程的压力，使得主线程和子线程之间互不干扰。等子线程完成任务后，再把运算结果通知给主线程。使用 Web Worker 创建的子线程是常驻内存，不会被主线程打断，所以在使用时应格外小心。

Web Worker 有专有线程 (Dedicated Worker) 和共享线程 (Shared Worker) 两种。专有线程是给 Worker 的构造函数挥定一个探向 JavaScript 文件的 URL。专有线程在运行的过程中会在后台使用 MessagePort 对象，而 MessagePort 对象支持 HTML 5 中多线程提供的所有功能，例如，可以发送和接收结构化数据(JSON 等)、传输二进制数据，并且支持在不同端口中传输数据等。为了在主线程接收从专有线程传递过来的消息，我们需要使用工作线程的 onmessage 事件处理器，当然，也可以使用 addEventListener。

共享线程可以用两种方式实现: 一种是通过挥向 JavaScript 脚本资源的 URL 来实现，另一种是通过显式的名称来实现。当用显式的名称实现共享线程时，创建这个共享线程的第一个 URL 会被当作这个共享线程的 JavaScript 脚本资源 URL。这种方式允许同域中的多个应用程序使用同一个提供公共服务的共享线程，从而不需要所有的应用程序都与这个提供公共服务的 URL 保持联系
![aaa](images/2024-4/2024-4-5.png)

## webpack 优化

![aaa](images/2024-4/2024-4-6.png)
![aaa](images/2024-4/2024-4-7.png)
![aaa](images/2024-4/2024-4-8.png)
![aaa](images/2024-4/2024-4-9.png)
![aaa](images/2024-4/2024-4-10.png)
![aaa](images/2024-4/2024-4-11.png)

## HTTP/2

HTTP/2 可以让我们构建出更快、更简单、更健壮的 Web 应用，通过支持请求和响应的多路复用技术来减少延迟，通过压缩 HTTP 首部字段减少协议开销。

HTTP/2 没有改变 HTTP 的语义，也就是说，HTTP 方法、状态码、首部字段等核心概念一如既往。不同的是 HTTP/2 修改了格式化数据的方式，采用二进制分层进行数据交换。HTTP/2 大致分为两部分:

@ 二进制分帧层: HTTP/2 多路复用功能的核心

@ HTTP 层: 传统的 HTTP 及数据相关的部分。

1.二进制分岐

在应用层(HTTP/2)和传输层 (TCP or UDP) 之间增加了一个二进制分层，它是提高 HTTP/2 性能的关键

-流:已建立的连接上的双向字节流，是连接中的虚拟通道，承载着双向信息交换.

-HTTP/2 通信的基本单位，承载了 header 和 payload 等

-消息: 通信的一系列数据帧，由一个或者多个帧组成

.首部压缩

HTTP 1.1 不支持首部压缩，在 HTTP/2 协议中，采用了专门用作首部压缩的 HPACK 算法。

3 多路复用的优点如下

(1) 可以并行交错地发送请求和响应，这些请求和响应之间互不影响

(2) 只使用一个链接即可并行发送多个请求和响应

(3) 消除不必要的延迟，从而减少页面加载时间

(4) 不必再为绕过 HTTP 1.x 限制而多做很多工作.

请求优先级

## 5.服务器推送

在 HTTP/2 中，服务器又被称为缓存推送，它的主要思想是:当客户端请求 A 资源时，服务器知道它很可能也需要 B 资源，因此服务器在发送 A 资源之前，主动把 B 资源也推送给客户端。

PWA 主要由 web app manifest、 service worker 和 notification 组成。web app manifest 是一个简单的 JSON 文件，该文件中存放的是应用的相天信息，如应用名称、作者、icon、描述、启动文件等，

PWA 的核心是 service worker (以下简称 sw) 。sw 是在后台运行的 worker 脚本，给开发者提供了一个全局控

制网络请求的机会，为其他场景应用开辟了可能性。比如，实现一个简单的 mock server。

尽管 sw 是由 JavaScript 实现的，但是 sw 的运行方式和标准的 JavaScript 相比稍有不同，具体如下

- sw 运行在自己的全局上下文中，不会被际塞。

- sw 独立于当前网页，并且不能修改网页中的元素，但是可以通过 postMessage 通信.

- 部署 sw 服务，需要 HTTPS 支持。

- sw 是一个可编程的网络代理，允许控制某一服务下的所有请求

- sw 是完全异步的，不能使用 localStorage 之类的功能。

sw 有一套独立于 Web 页面的生命周期
![aaa](images/2024-4/2024-4-12.png)
![aaa](images/2024-4/2024-4-13.png)

sw 更新流程

(1)更新 sw 的 JavaScript 文件。当用户浏览系统时，浏览器会尝试在后台重新下载 sw 的脚本文件并进行对比只要服务器上的文件和本地文件不同，这个文件就被认为是新的。

2)更新 sw 脚本文件，启动并触发 install 事件。这时，在当前系统上生效的依然是老版本的 sw，新版本的 sw 处于“waiting”状态。

(3) 在页面天闭之后，老版本的 sw 会被清理掉，新版本的 sw 将接管页面。一日新的 sw 生效，就会触发 activate 事件

libraryTarget 是控设置 library 的暴露方式，具体的值有 commonjs、commonjs2、umd、this 和 var 等.

-libraryTarget:"assign": 暴露一个未定义的 library 设置的变量，在 Node 环境下不支持.

- libraryTarget:"var": 暴露一个用 var 定义的 library 设置的变量，在 Node 环境下不支持.

- libraryTarget:"window”: 在 window 对象上定义一个 library 设置的变量，在 Node 环境下不支持.

- libraryTarget;"global": 在 global 对象上定义一个 library 设置的变量。受 target 属性影响，当 target 为默认值 Web 时，会在 window 对象上注册。如果想在 global 对象上注册，则必须修改 target 为 node。

- libraryTarget:"this": 在当前的 this 对象上定义一个 ibrary 设置的变量，如果 this 对象是 window 对象，就在 window 对象上定义。在 Node 环境中，如果未控定 require 赋值的变量，则不会控向 global 对象。

- libraryTarget:"commonis": 在 export 对象上定义 library 设置的变量，在 Node 环境下支持，在浏览器中

不支持。

- libraryTarget:"commonjs2": 直接用 module.export 导出 export 对象，会忽略 library 设置的变量。在 Node 环境下支持，在浏览器中不支持

- libraryTarget:"amd”。在 define 方法上定义 library 设置的变量，不能通过 script 直接引用，必须通过第三方模块引用。

-新的虚拟化实现比传统虚拟机更轻量

- 资源利用更高效。因为 Docker 直接运行在宿主机上，所以不需要进行硬件抽象。

多环境配置一致。Docker 的一个天键优势是提供统一的环境配置，把应用的环境打包成镜像的形式对外提供服务，而不用考虑各个环境的差异。

-可持续交付和部署。Docker 可以通过定制应用镜像实现持续集成、交付和部署。开发人员可以通过 Dockerfile 进行镜像构建，并结合持续集成 (CI)系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合持续部署 (CD) 进行自动部署。

- 迁移简单，该项特性得益于 Docker 的环境障离机制。

https://docs.docker.com/docker-hub/quickstart/
