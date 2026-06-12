---
theme: fancy
highlight: xcode
---

不用钱，免费玩AI！是时候用`Ollama`搞个简单的本地AI大模型，保护自己的钱包！ollama有客户端又有服务接口可调用，真是快乐的穷鬼AI工具！

# 1. ollama安装与使用

## 什么是ollama？

Ollama 是一个开源模型管理器与推理引擎，专为简化本地 AI 模型部署和运行设计。它允许用户通过简单的命令（如 `ollama serve`）快速启动本地大语言模型服务，无需依赖复杂的服务器环境或云端网络。主要特点包括：

1.  极简部署：只需在终端执行指令即可直接运行本地大模型。
1.  轻量级：使用 Docker 容器化技术，支持高效多用户并发服务。
1.  兼容主流格式：支持 GGUF、T5、BLOOM 等常见模型格式的本地加载与推理。
1.  隐私友好：数据不上传至云端，适合对隐私有要求的个人或企业环境。

适合用于个人 AI 助手开发、本地知识库训练等场景，尤其推荐给需要控制部署环境和提升计算效率的用户。

## 安装与使用

打开`ollama`官网，下载安装包`https://ollama.com/download`，我这里是window电脑，下载`OllamaSetup.exe`

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/aa277a8316f0455cb25df8acc3e1fe9f~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773717256&x-orig-sign=ZVQUAanuQoqdtHX6dDDBqDWD4is%3D)

安装完后，打开cmd命令窗口，输入指令查看版本，看看是否成功安装！

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/fd7cf51fc14448db8c350be1cad824f2~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773717605&x-orig-sign=UCdqIucCkiLDX3%2FyioqJD8wQeuQ%3D)

然后到`ollama`的官方查一下可下载的开源的大模型`https://ollama.com/search`

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/6d18424153034755a782c9ecd577666a~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773717769&x-orig-sign=vDErG%2F9i8S6ACQDDYYsbvN5l5hI%3D)

打开`Qwen3.5`大模型，查看一下模型版本，2b代表20亿参数，参数越多，大模型越聪明，相对需要的资源越多。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/70f83f43d454414d80a52f250b1aa648~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773717879&x-orig-sign=205O24zZ%2Bf1%2F%2Bdggzvi52taokZQ%3D)

不知道自己的电脑配置能装什么版本，可以到`unsloth.ai`看看配置要求

以下**unsloth**:`https://unsloth.ai/docs/zh/mo-xing/qwen3.5` 关于`Qwen3.5`的配置要求

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ed3edc5c89cc4f019892cf88892374f2~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773719036&x-orig-sign=wm1wx8WgwM5SD0Ar5HDNVqnTISc%3D)

我的渣渣笔记本电脑16G内存，没独立显卡，装个`qwen3.5:2b`不用卡死！

执行`ollama pull`安装模型，因为模型比较大，下载需要时间，耐心等待

```sh
ollama pull qwen3.5:2b
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/6fda176f43cc4ec69c9ce90512b94a48~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773719287&x-orig-sign=97fWjuNRjVyppFzEG4d%2B61objyI%3D)

打开ollama客户端，选择已安装的模型，测试使用一下模型

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/c42af6e2a7b046c4850cc2ebc3253450~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773719903&x-orig-sign=A1HPO3NvD529OiMG2KRMdTn28pw%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/37dcf36afe99427489402ef656786665~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773720391&x-orig-sign=cmCr2lsTlaBK%2FmazdISdHaGsKLQ%3D)

emmm，不用钱的30秒回答一个问题，还可以接受啦~

# 2. ollama的一些常用命令

**查看已安装的模型**

```sh
ollama list
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/50acd740c6f14463b77fe9ad9caf2fe6~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773728407&x-orig-sign=Hcyk%2BoUK0kPIXtnt1oBCPkqW9iI%3D)

**查看当前运行的模型**

```sh
ollama ps
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/92cf3ce5911841aca739fa3953d96712~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773728483&x-orig-sign=gimRiA%2F5lG4RRG0kQhVEmG0KwCI%3D)

**使用某个模型**

```sh
ollama run qwen3.5:2b
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/f7b130790f16461da0dbae89adf6962d~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773736230&x-orig-sign=YRw02jqeBvtBVQv4zuLTQki77pM%3D)

`run`是如果模型未安装，会先下载完再运行模型,`pull`是只下载不运行

模型开启思考过程的话，需要等待较长时间，想要直接得到答案，可以禁用思考

```sh
# 启用思考
ollama run qwen3.5:2b --think
# 禁用思考
ollama run qwen3.5:2b --think=false
```

**删除模型**

```sh
ollama rm 模型名称
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/db701babf5764501ba766ede868deeed~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773728792&x-orig-sign=aJVgRGZu11AtoGHogsBxjFV4LkQ%3D)

**运行服务**

```sh
ollama serve
```

默认启动的访问路径是`127.0.0.1:11434`，但是可以通过配置系统环境变量可以修改IP地址和端口，让别人可以通过IP访问ollama服务

```sh
OLLAMA_HOST=10.1.x.x:11434//改成自己本地的IP地址和端口
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/a1fea552d80f42f99dfc7604ce248d26~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773734717&x-orig-sign=p2q206XZbsZ331zHlzulo2ZFHZQ%3D)

可以执行帮助命令查看服务可配置的`环境变量`

```sh
ollama serve --help
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4381f945da0d4615888a7a84e7982010~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773734419&x-orig-sign=Sikb%2FiS%2BsCvizP9Q4Evb0F8BQsc%3D)

更多的ollama命令请看官方文档`https://docs.ollama.com/cli`

# 3.调用ollama服务与大模型聊天

## 直接API请求

通过axios、fetch等请求访问ollama服务，详细`Ollama API`使用请看https://docs.ollama.com/api/introduction

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/20c88fd603234ea3b44eef4692cd6d8b~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773729830&x-orig-sign=iL0rY8mKBYZ4XR9Sxuw35es2RUo%3D)

```js
import axios from 'axios';
axios({
  method: 'GET',
  //查看可用模型
  url: 'http://10.1.x.x:11434/api/tags' //替换成自己的IP地址和端口
}).then(({data: res}) => {
  console.log('🚀 ~ index.js ~ res:', res);
});
```

发起聊天

```js
const question = '请简单回答，为什么天空是蓝色的？';
console.log('question', question);
const start = Date.now();
axios({
  method: 'POST',
  url: 'http://10.1.x.x:11434/api/chat', //替换成自己的IP地址和端口
  data: {
    model: 'qwen3.5:2b',
    //是否启用思考过程，false禁用
    think: false,
    //流式输出，false禁用
    stream: false,
    messages: [
      {
        role: 'user',
        content: question
      }
    ]
  }
}).then(({data: res}) => {
  console.log('answer:', res);
  console.log('time:', (Date.now() - start) / 1000, 's');
});
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/5badf259a06b4d3c9c7fd4135ff0799e~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773736825&x-orig-sign=Z54DHjgi0Jo26BZ4OZpXoQfdgeY%3D)

## 通过ollama js库

可以通过官方`ollama` js库来访问ollama服务

```sh
pnpm add ollama
```

配置ollama的服务地址，查看可用模型

```ts
import {Ollama} from 'ollama';
async function main() {
  //连接ollama服务
  const ollama = new Ollama({
    host: 'http://10.1.x.x:11434', //替换成自己的IP地址和端口
    // 如果配置了API KEY，需填写，用于权限校验
    headers: {Authorization: 'Bearer ' + process.env.OLLAMA_API_KEY}
  });
  //查看可用模型
  const list = await ollama.list();
  if (list) {
    console.log('available models:', list);
  }
}
main().catch(console.error);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4e238a340ce141279f6926cd7af16999~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773732364&x-orig-sign=qH%2Bovih4TnZZBLQUh4PeLxW4Zcc%3D)

请求ollama服务，使用模型发起聊天，等待输出的结果

```ts
const question = '请简单回答，为什么天空是蓝色的？';
console.log('question', question);
const start = Date.now();
const response = await ollama.chat({
  //使用模型
  model: 'qwen3.5:2b',
  //聊天消息
  messages: [{role: 'user', content: question}],
  //是否流式输出
  stream: false,
  //是否启用思考过程
  think: false
});

console.log('answer:', response);

//中断请求
// response.abort();
console.log('time:', (Date.now() - start) / 1000, 's');
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/9dbe3ceac50e4cbf896bf54157ecc72c~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773737396&x-orig-sign=W0pmCcRqQAkxPvRYMxusrY4gtjM%3D)

不论通过命令行、axios、客户端、js库等方式调用ollama的大模型服务，期间都会打印相关接口的访问日志

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/be32a214e689429daa119927209dcc44~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=e9ecf3d6&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1773735944&x-orig-sign=kI6jya0z4GB2w2D%2BXxFr5dFajJs%3D)

# 4.总结

本文仅仅简单介绍了ollama工具的使用，有很多复杂的配置和功能可以自行到官网探讨，官方文档都讲得很详细的。

另外，推荐结合`langChain`使用`Ollama`的大模型服务，特别好用！

**参考**

- Ollama:`https://ollama.com/`
- Qwen千问AI:`https://www.qianwen.com/`
- unsloth:`https://unsloth.ai/`
