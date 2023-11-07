# 浏览器和 Node 事件循环的区别？

```js
functiontest () {
   console.log('start')
    setTimeout(() => {
        console.log('children2')
        Promise.resolve().then(() => {console.log('children2-1')})
    }, 0)
    setTimeout(() => {
        console.log('children3')
        Promise.resolve().then(() => {console.log('children3-1')})
    }, 0)
    Promise.resolve().then(() => {console.log('children1')})
    console.log('end')
}

test()

// 以上代码在node11以下版本的执行结果(先执行所有的宏任务，再执行微任务)
// start
// end
// children1
// children2
// children3
// children2-1
// children3-1

// 以上代码在node11及浏览器的执行结果(顺序执行宏任务和微任务)
// start
// end
// children1
// children2
// children2-1
// children3
// children3-1


```

# node 底层

NodeJS 源码分为三层：JS、C++ 以及 C。

- JS 层提供面向用户的调用底层能力的接口，即各种 NodeJS 原生模块，如 net、http、fs、DNS 以及 path 等
- C++ 层主要通过 V8 为 JS 层提供与底层交互的能力，起到类似桥梁的作用，通过 V8 不仅实现 JS 的解释执行，还扩展的 JS 的能力边界
- C 层主要包括 Libuv 这一跨平台的异步 IO 库以及其他第三方 C 库

## 启动过程

1. 注册 C++ 模块
2. 创建 Environment 对象
3. 初始化 loader 和执行上下文
4. 初始化 Libuv
5. 执行用户 JS 代码
6. 进入 Libuv 事件循环

## Event Loop

1. 首先判断当前事件循环是否处于 alive 状态，否则退出整个事件循环。alive 状态表示是否有 active 状态的 handle 和 request，closing 状态的 handle
2. 基于系统时间更新时间戳
3. 判断由定时器组成的小顶堆中那个节点超时，超时则执行定时器回调
4. 执行 pending 回调任务，一般 I/O 回调添加的错误或写数据成功的任务都会在下一个事件循环的 pending 阶段执行
5. 执行 idle 阶段的回调任务
6. 执行 prepare 阶段的回调任务
7. 调用各平台的 I/O 读写接口，最多等待 timeout 时间（定时器最快过期时间），期间如果有数据返回，则执行 I/O 对应的回调
8. 执行 check 阶段的回调任务
9. 执行 closing 阶段的回调任务
10. 重新回到流程 1

## 任务调度

目前，主要有五种主要类型的队列被 Libuv 的事件循环所处理：

- 过期或是定期的时间队列，由 setTimeout 或 setInterval 函数所添加的任务
- Pending 队列，主要存放读写成功或是错误的回调
- I/O 事件队列，主要存放完成 I/O 事件时的回调
- Immediates 队列，采用 setImmediate 函数添加的任务，对应 libuv 的 check 阶段
- Close 任务队列，主要存放 close 事件回调

除了以上五种主要的任务列表，还有额外两种不属于 libuv 而是作为 NodeJS 一部分的任务队列：

- Next Ticks 队列，采用 process.nextTick 添加的任务
- 其他微任务队列，例如 promise callback 等

nextTicks 队列和其他微任务队列会在事件循环每一阶段穿插调用，nextTicks 优先级会比其他微任务队列更高。

## node server.js

- 注册 C++ 系列的模块和 V8 的初始化操作
- 创建 environment 对象用于存放一些全局的公共变量
- 初始化模块加载器，以便在用户 JS 代码层调用原生 JS 模块以及原生 JS 模块调用 C++ 模块能够成功加载
- 初始化执行上下文，暴露 global 在全局上下文中，并设置一些全局变量和方法在 global 或 process 对象
- 初始化 libuv，创建一个默认的 event_loop 结构体用于管理后续各个阶段产生的任务

## TCP 连接在 NodeJS 中是如何保持一直监听而进程不中断的

TCP 服务器在启动之后，就往 NodeJS 的事件循环系统插入 listen 的监听任务，该任务会一直阻塞监听（不超过 timeout）来自客户端的请求，当发生请求后，建立连接然后进行数据处理后，再会进入监听请求的阻塞状态，新一轮的事件循环发现 poll io 队列还有任务所以不会退出事件循环，从而驱动进程一直运行。

## 处理并发连接

服务端架构:单线程+事件驱动
网络 I/O NodeJS 底层: I/O 多路复用模型=>监听就绪的连接

当调用阻塞的 recvfrom 处理来自的网络的数据，此时数据已经就绪，所以数据处理起来很快，如果是大文件，则需要业务代码自行开辟线程去处理；

文件 I/O:线程池的机制

在主线程外开辟工作线程去处理本地大文件，在处理完后通过事件通知机制告诉上层 JS 代码。

# npm 模块安装机制

- 发出 npm install 命令
- 查询 node_modules 目录之中是否已经存在指定模块
- npm 向 registry 查询模块压缩包的网址
- 下载压缩包，存放在根目录下的.npm 目录里
- 解压压缩包到当前项目的 node_modules 目录

## npm 实现原理

生命周期函数 preinstall、install、postinstall

1. 执行工程自身 preinstall
2. 确定首层依赖模块
3. 获取模块
4. 模块扁平化（dedupe）
5. 安装模块
6. 执行工程自身生命周期： install、postinstall、prepublish、prepare
7. 生成或更新版本描述文件，npm install 过程完成。
