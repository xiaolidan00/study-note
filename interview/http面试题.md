# http 面试题

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

## http headers

**Request headers**

- Accept 浏览器可接收的数据格式
- Accept-Encoding 浏览器可接收的压缩算法，如 gzip
- Accept-Language 浏览器可接收的语言，如 zh-CN
- Connection:keep-alive 一次 TCP 连接重复使用
- cookie
- host
- User-Agent(UA)浏览器信息
- Content-Type 发送数据格式，如 application/json

**自定义**

- Authorization
- token

**Response headers**

- Content-Type 返回的数据格式，如 application/json
- Content-length 返回数据的大小，多少字节
- Content-Encoding 返回数据的压缩算法，如 gzip

**缓存**

- Cache-Control Expires
- Last-Modified If-Modified-Since
- Etag If-None-Match

## http 缓存

静态资源缓存（js,css,img)
webpack 打包文件 hash

**强制缓存**

Response Headers 中
控制强制缓存逻辑

Cache-Control:max-age=31536000(单位秒)
最大的缓存时间为一年

过程：

- 初次请求->服务器->返回资源和 Cache-Control 到浏览器
- 再次请求->本地缓存（判断 Cache-Control 是否过期）->返回资源
- 缓存失效->再次请求服务器->返回资源和 Cache-Control 到浏览器

- max-age 缓存时间
- no-cache 不需强制缓存，交给服务端处理
- no-store 不需要本地和服务端的缓存

Expires 同为控制缓存过期，已被 Cache-Control 代替

**协商缓存（对比缓存）**

- 服务端缓存策略
- 服务器判断客户端资源是否与服务端一致
- 一致则返回 304（资源未被修改，读取浏览器缓存），否则返回 200 和最新资源

过程：

- 初次请求服务器=》返回资源和资源标识
- 再次请求，带着资源标识=》返回 304 或返回资源和最新资源

- Last-Modified 资源最后修改的时间
- ETag 资源的唯一标识（一个字符串，类似人类指纹）

Last-Modified 过程：

- 初次请求服务器-》返回资源和 Last-Modified
- 再次请求，Request Headers 带着 If-Modified-Since（之前的 Last-Modified 的值）=>返回 304，或最新资源和新 Last-Modified

Etag 过程：

- 初次请求服务器-》返回资源和 Etag
- 再次请求，Request Headers 带着 If-None-Math(之前的 Etag)->返回 304，或新资源和新 Etag

- 优先使用 Etag
- Last-Modified 只能精确到秒
- 如果资源被重复生成，而内容不变，则 Etag 更精确

## 三种刷新操作

- 正常操作：地址栏输入 URL，跳转链接=》强制缓存有效，协商缓存有效
- 手动刷新：F5,右键菜单栏=》强制缓存失效，协商缓存有效
- 强制刷新：ctrl+F5=》强制缓存和协商缓存失效

## https 和 http

- http 明文传输，敏感信息容易被中间劫持
- https=http+加密，劫持了也无法解密
- 现代浏览器已经开始强制 https 协议

## https 加密方式

- 对称加密：一个 key 同时负责加密和解密，成本比较低
- 非对称加密：一对 key，A 加密后，只能用 B 来解密
- https 使用了两种加密方式

**为什么用 https**

- 中间人攻击
- 使用第三方证书（慎用免费，不合规的证书）
- 浏览器校验证书

**过程**

1. 客户端请求 url 地址
2. 服务器（存有 CA 数字证书，公钥 A,私钥 B,颁发机构，公司信息，域名，有效期)
3. 响应请求，会携带数字证书（证书保护公钥 A)
4. 客户端解析证书，验证合法性(不合法提示 https 警告)，合法则去除公钥 A,并生成随机码 KEY，使用公钥 A 加密随机码 KEY（非对称加密）
5. 客户端吧加密后的随机码 KEY 发送给服务器，作为接下来的对称加密的秘钥
6. 服务器使用私钥 B 解密得到随机码 KEY,再使用随机码 KEY 对传输数据进行对称加密（对称加密）
7. 传输对称加密后的内容给客户端
8. 客户端使用之前生成的随机码 KEY 解密数据
9. 通过对称加密传输所有内容

验证证书=》数据传输（非对称加密）=》数据传输（对称加密）

# JS Web API

## 事件绑定、事件冒泡、事件代理

```js
const clickFn = (ev) => {
  ev.preventDefault(); //阻止默认行为
  ev.stopPropagation(); //禁用事件冒泡
};
//绑定事件
dom.addEventListener('click', clickFn);
//移除事件
dom.removeEventListener('click', clickFn);
//事件代理，将监听挂载在父元素=》减少浏览器内存占用
parentDom.addEventListener('click', (ev) => {
  if (ev.target.title == 'a') {
  } else if (ev.target.title == 'b') {
  }
});
//修改event function的this指向
window.addEventListener('resize', this.onResize.bind(this));
window.addEventListener('unload', this.cleanAll.bind(this));
```

## Ajax

- XMLHttpRequest
- 状态码
- 跨域：同源策略，跨域解决方案
  `xhrReq.open(method, url, async, user, password);`
  method:GET、POST、PUT、DELETE
  async 可选：
  一个可选的布尔参数，表示是否异步执行操作，默认为 true。如果值为 false，send() 方法直到收到答复前不会返回。如果 true，已完成事务的通知可供事件监听器使用。如果 multipart 属性为 true 则这个必须为 true，否则将引发异常。

**readyState**

- 0 UNSENT 代理被创建，但尚未调用 open() 方法。
- 1 OPENED open() 方法已经被调用。
- 2 HEADERS_RECEIVED send() 方法已经被调用，并且头部和状态已经可获得。
- 3 LOADING 下载中；responseText 属性已经包含部分数据。
- 4 DONE 下载操作已完成。

```js
//get
const xhr = new XMLHttpRequest();
//xhrReq.open(method, url, async, user, password);
xhr.open('GET', '/api', false);
xhr.onreadystatechange = () => {
  if (xhr.readyState == 4 && xhr.status == 200) {
    console.log(xhr.responseText);
  }
};
xhr.send(null);

//post
const xhr = new XMLHttpRequest();
xhr.open('POST', '/api', false);
xhr.setRequestHeader('Content-Type', 'application/json');
xhr.responseType = 'json'; //返回类型 "arraybuffer"
xhr.onreadystatechange = () => {
  //status=》http状态码
  if (xhr.readyState === 4 && xhr.status === 200) {
    console.log(xhr.responseText);
  }
};
xhr.send(JSON.stringify(data));

xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
xhr.send('foo=bar&lorem=ipsum');
const formData = new FormData(document.getElementById('myForm'));
xhr.send(formData);

function updateProgress(oEvent) {
  if (oEvent.lengthComputable) {
    var percentComplete = (oEvent.loaded / oEvent.total) * 100;
    // ...
  } else {
    // 总大小未知时不能计算进程信息
  }
}
xhr.addEventListener('progress', updateProgress); //监听进度
xhr.open('GET', '/server', true); //异步请求

xhr.timeout = 2000; // 超时时间，单位是毫秒
xhr.addEventListener('timeout', handleEvent); //监听超时
//指示了是否该使用类似 cookie、Authorization 标头或者 TLS 客户端证书等凭据进行跨站点访问控制（Access-Control）请求。设置 withCredentials 对同源请求是无效的。
xhr.withCredentials = true;
```

## 同源策略

- ajax 请求时要求浏览器当前网页与 server 必须同源(安全)
- 同源：协议、域名、端口，三者必须一致

**加载图片、js、css 可无视同源策略**

- img:可用于统计埋点，第三方统计服务
- link,script 可使用 CDN,CDN 一般是外域
- script 可实现 JSONP

**跨域**

- 所有跨域，必须经过 server 端允许和配合
- 未经 server 端允许就实现跨域，说明浏览器有漏洞，危险信号

```js
function jsonp(url) {
  let fun = 'jsonp' + new Date().getTime();
  const dom = document.createElement('script');
  dom.src = url + '?callback=' + fun;
  document.body.appendChild(dom);
  dom.onload = () => {
    //调用成功后，fun回调函数会自动执行，将返回data传入
    document.body.removeChild(dom);
  };
}
```

```js
//CORS服务器设置http header
//允许跨域的设置
Access-Control-Allow-Origin:http://localhost:8080
Access-Controll-Allow-Headers:X-Requested-With
Access-Controll-Allow-Methods:"PUT,POST,GET,DELETE,OPTIONS"

//接收跨域cookie
Access-Controll-Allow-Credentials:true
```

## cookie、localstorage、session

cookie

- 本身用于浏览器和 server 通讯
- 被借用到本地存储来
- 存储大小最大为 4K
- http 请求时需发送到服务端，增加请求数据量

```js
document.cookie = 'a=1;b=2';
document.cookie = 'c=3'; //'a=1;b=2;c=3'

//没有就追加，有就覆盖
```

localStorage,sessionStorage

- H5 专门为存储设计，最大可存 5M
- API 简单易用，setItem,getItem，removeItem
- 不会随着 http 请求被发送出去，只存在浏览器
- localStorage 永久存储，除非代码或手动删除
- sessionStorage 只存在当前会话，浏览器关闭则清空

# JS 基础面试题

## typeof

- 能判断所有基本类型

undefined,string,number,boolean,symbol

- 能判断函数类型

```js
typeof console.log; //function
typeof function () {}; //function
```

- 能识别引用类型，不能继续识别

```js
typeof null; //object
typeof [1, 2]; //object
typeof { x: '1' }; //object
```

## 深度拷贝 deepClone

```js
function deepClone(obj) {
  if (typeof object !== 'object' || obj == null) {
    return obj;
  }
  let res;
  if (obj instanceof Array) {
    res = [];
  } else {
    res = {};
  }
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      res[key] = deepClone(obj[key]);
    }
  }
  return res;
}
```

## 类型转换

```js
100 + '10'; //'10010'
true + '10'; //'true10'

100 == '100'; //true
0 == ''; //true
0 == false; //true
false == ''; //true
null == undefined; //true
null == 0; //false
undefined == 0; //false

const obj = { x: 100 };
if (obj.a == null) {
}
//if(obj.a===null||obj.a===undefined){}

!!a === true; //truly变量
!!a === false; //falsely变量
//falsely变量
0;
NaN;
('');
null;
undefined;
false;

if (a) {
  //判断truly变量
}

10 && 0; //0
'' || 'abc'; //'abc'
!undefined; //true
```

## 原型和原型链

**class**

- constructor
- 属性和方法
- extends 继承：super，扩展或重写

**instanceof 类型判断**

```js
[] instanceof Array//true
[] instanceof Object//true
{} instanceof Object//true
class People{
  constructor(name){
    this.name=name
  }
}
class Student extends People{
  constructor(name,age){
    super(name)
    this.age=age
  }
}
const p=new People('小明')
const s=new Student('小红',16)
typeof People//function class实际上是函数，可见是语法糖
s instanceof Student//true
s instanceof People//true
p instanceof People//true
p instanceof Object//true

//隐式原型和显式原型
p.__proto__//People.prototype
s.__proto__//Student.prototype
Student.prototype

s.__proto__===Student.prototype//true
Student.prototype.__proto__//People.prototype
People.prototype.__proto__//Object.prototype
Object.prototype.__proto__//null
```

- 每个 class 都有显式原型 prototype
- 每个实例都有隐式原型`__proto__`
- 实例的`__proto__`指向对应 class 的 prototype

基于原型的执行规则

- 获取属性或方法时，先在自身属性和方法中查找
- 如果找不到，就自动去`__proto__`中查找

原型链：instanceof 通过`__proto__`找到对于 prototype 则为 true

## 作用域和闭包

```js
let a = 1;
function f1() {
  let a1 = 100;
  function f2() {
    let a2 = 200;
    function f3() {
      let a3 = 300;
      return a + a1 + a2 + a3; //601
    }
    f3();
  }
  f2();
}
f1();
```

作用域

- 全局作用域
- 函数作用域
- 块级作用域

自由变量

- 一个变量在当前作用域没有定义，但被使用了
- 向上级作用域一层一层地寻找，直到找到为止
- 如果到全局作用域仍没有找到，则报错 xx is not defined
- 所有自由变量的查找在函数定义的地方，向上级作用域查找，而不是在执行的地方
  **闭包**
  作用域特殊情况

- 函数作为参数被传递
- 函数作为返回值被返回

```js
function create() {
  let a = 100;
  return function () {
    console.log(a);
  };
}
let f = create();
let a = 200;
f(); //100

function print(fn) {
  let a = 200;
  fn();
}
let a = 100;
function fn() {
  console.log(a);
}
print(fn); //100
```

## this

- 作为普通函数
- 使用 call,apply,bind 改变 this 指向
- 作为对象方法调用
- 在 class 方法中调用
- 箭头函数
- this 的指向是在函数执行的时候确认，不是在函数定义

```js
function f1(a) {
  console.log(this, a);
}

f1(1); //window,1

f1.call({ x: 100 }, 2); //{ x: 100 } 2
f1.apply({ x: 100 }, [2]); //{ x: 100 } 2
const f2 = f1.bind({ y: 200 });
f2(3); //{ y: 200 } 3

const a = {
  name: 'aa',
  hello() {
    console.log(this); //当前对象
  },
  wait() {
    setTimeout(function () {
      console.log(this); //window，匿名函数
    });
  },
  wait1() {
    setTimeout(() => {
      console.log(this); //当前对象，箭头函数指向上级
    });
  }
};
class People {
  constructor(name) {
    this.name = name;
  }
  getName() {
    console.log(this); //当前对象
  }
}
const p = new People('aa');
```

**this 指向**

- this 是 window:全局,单纯的函数名+括号执行,匿名函数自执行,定时器中,箭头函数中 this 暴露在外面
- this 是当前对象：事件触发，触发谁 this 就是谁，对象方法中，.前面是谁 this 就指向谁，构造函数中 this 是实例化对象
- 严格模式下 this 是 undefined
- 箭头函数中 this 指向上一级

## 同步与异步

- js 是单线程语言，只能同时做一件事
- 浏览器和 node 已经支持 js 启动进程，如 web worker
- js 和 dom 渲染共用同一个线程，因此 js 可修改 dom 结构
- 遇到等待（网络请求，定时任务）不能卡住，则需要异步，采用 callbak 函数形式调用
- 异步不会阻塞代码执行，同步会阻塞代码执行

```js
//异步
console.log(1);
setTimeout(() => {
  cosole.log(2);
});
console.log(3);
//1,3,2

//同步
console.log(1);
alert(2); //卡住
console.log(3);

console.log('1');
let img = document.createElement('img');
img.onload = function () {
  console.log('2');
};
img.src = '/aaa.jpg';
console.log('3');
//1,3,2
```

## eventloop

js 执行

- 从前到后，一行一行执行
- 如果某一行报错，则停止下面代码的执行
- 先把同步代码执行完，再执行异步

**eventloop 过程**

- 同步代码，一行一行放在 call stack 执行
- 遇到异步，先记录下，等待时机（网络请求，定时器）
- 时机到了，将异步移到 callback queue 中
- 如果 call stack 为空（即同步代码执行完毕），eventloop 开始工作
- 轮询查找 callback queue，如果有则移动到 call stack 执行
- 然后继续轮询查找（永动机）

**DOM 事件和 eventloop**

- dom 事件注册动作监听已经记录了，触发时机与异步不同

- 异步（setTimeout,ajax）和都使用回调，都基于 eventloop

## promise

防止回调地狱

三种状态：pending，resolved，rejected（变化不可逆）

```js
console.log(1);
const p = new Promise((resolve) => {
  console.log(2);

  resolve();
});
p.then(() => {
  console.log(3);
});
console.log(4);
setTimeout(() => {
  console.log(5);
});
console.log(6);
//1,2,4,6,3,5

console.log(1);
const p = new Promise((resolve, reject) => {
  console.log(2);
  reject();
});
p.then(() => {
  console.log(3);
}).catch(() => {
  console.log(4);
});
console.log(5);
setTimeout(() => {
  console.log(6);
});
console.log(7);
//1,2,5,7,4,6

Promise.resolve()
  .then(() => {
    console.log(1);
  })
  .catch(() => {
    console.log(2);
  })
  .then(() => {
    console.log(3);
  });
//1,3

Promise.resolve()
  .then(() => {
    console.log(1);
    throw new Error('error');
  })
  .catch(() => {
    console.log(2);
  })
  .then(() => {
    console.log(3);
  });
//1,2,3

Promise.resolve()
  .then(() => {
    console.log(1);
    throw new Error('error');
  })
  .catch(() => {
    console.log(2);
  })
  .catch(() => {
    console.log(3);
  });
//1,2
```

then、catch 正常返回 resolved，里面报错则返回 rejected

## async/await

- 异步回调地狱
- promise then catch 链式调用，但也基于回调函数
- async/await 同步语法，彻底消灭回调函数，
- 与 promise 不排斥，两者相辅相成
- 执行 async 函数，返回的是 promise 对象
- await 相当于 promise 的 then
- try catch 可捕获异常，代替 promise catch

```js
function loadImage(url) {
  return new Promise((resolve, reject) => {
    const img = document.createELement('img');
    img.onload = () => {
      resolve(img);
    };
    img.onerror = () => {
      reject(err);
    };
    img.src = url;
  });
}
(async function () {
  const img = await loadImage('image.png');
  console.log(img.width, img.height);
})();
//-------
async function f1() {
  return 1;
}
const f = f1(); //promise对象
f.then((data) => {
  console.log(data); //1
});
//--------
async function f1() {
  return Promise.resolve(2);
}
const f = f1(); //promise对象
f.then((data) => {
  console.log(data); //2
});
(async function () {
  await f1(); //2
})();

(async function () {
  try {
    const f = await Promise.reject(2);
    console.log(f);
  } catch (error) {
    console.log(error);
  }
})();

async function f1() {
  console.log('3');
  await f2();
  //await 后面可看做callback的内容
  console.log('4');
}
async function f2() {
  console.log('5');
}
console.log('1');
f1();
console.log('2');

//1,3,5,2,4
```

## 宏任务、微任务

- 宏任务：setTimeout,setInterval,ajax,dom 事件
- 微任务：promise，async/await
- 微任务执行事件比宏任务要早
- 宏任务在 DOM 渲染后触发
- 微任务在 DOM 渲染前触发
- 微任务是 es6 语法规定的，宏任务是浏览器规定的

```js
console.log(1);
setTimeout(() => {
  console.log(2);
});
Promise.resolve().then(() => {
  console.log(3);
});
console.log(4);
//1,4,3,2

let img = document.createElement('img');
img.src = 'a.jpg';
img.id = 'aaa';
document.body.appendChild(img);
console.log(document.getElementById('aaa'));
alert('1');
Promise.resolve().then(() => {
  console.log(document.getElementById('aaa'));
  alert('2');
});
setTimeout(() => {
  console.log(document.getElementById('aaa'));
  alert('3');
});
```

- js 是单线程，与 DOM 渲染共用一个线程
- js 执行时，得留时机供 DOM 渲染

1. call stack 空闲（全部代码执行完，可用 alert 阻断 js 执行和 dom 渲染，查看效果）
2. （执行微任务）尝试 DOM 渲染（执行宏任务）
3. 触发 Event loop

## 手写 promise

- 初始化和异步回调
- then catch 链式调用
- API:resolve,reject,all,race

```js
class MyPromise {
  KEY = { pending: 'pending', fullfilled: 'fullfilled', rejected: 'rejected' };
  state = 'pending'; //pending,fullfilled,rejected
  value = undefined; //成功后的值
  reason = undefined; //失败后的原因
  resolveCallbacks = []; //pending状态下存储成功的回调
  rejectCallbacks = []; //pending状态下存储失败的回调
  constructor(fn) {
    const resolveHandler = (value) => {
      if (this.state == this.KEY.pending) {
        this.state = this.KEY.fullfilled;
        this.value = value;
        this.resolveCallbacks.forEach((fn) => fn(value));
      }
    };
    const rejectHandler = (reason) => {
      if (this.state == this.KEY.pending) {
        this.state = this.KEY.rejected;
        this.reason = reason;
        this.rejectCallbacks.forEach((fn) => fn(reason));
      }
    };
    try {
      fn(resolveHandler, rejectHandler);
    } catch (error) {
      rejectHandler(error);
    }
  }
  then(fn1, fn2) {
    //当pending状态下，fn1,fn2会存储到callbacks中
    fn1 = typeof fn1 === 'function' ? fn1 : (v) => v;
    fn2 = typeof fn2 === 'function' ? fn2 : (e) => e;

    //链式调用 return MyPromise
    if (this.state == this.KEY.pending) {
      return new MyPromise((resolve, reject) => {
        this.resolveCallbacks.push(() => {
          try {
            const v = fn1(this.value);
            resolve(v);
          } catch (error) {
            reject(error);
          }
        });
        this.rejectCallbacks.push(() => {
          try {
            const v = fn2(this.reason);
            reject(v);
          } catch (error) {
            reject(error);
          }
        });
      });
    }
    if (this.state === this.KEY.fullfilled) {
      return new MyPromise((resolve, reject) => {
        try {
          const v = fn1(this.value);
          resolve(v);
        } catch (error) {
          reject(error);
        }
      });
    }

    if (this.state === this.KEY.rejected) {
      return new MyPromise((resolve, reject) => {
        try {
          const v = fn2(this.reason);
          reject(v);
        } catch (error) {
          reject(error);
        }
      });
    }
  }
  catch(fn) {
    return this.then(null, fn);
  }
}
MyPromise.resolve = function (value) {
  return new MyPromise((resolve, reject) => resolve(value));
};
MyPromise.reject = function (reason) {
  return new MyPromise((resolve, reject) => reject(reason));
};
//传入promise数组，等待全部都fullfilled，才返回
MyPromise.all = function (promises) {
  return new MyPromise((resolve, reject) => {
    const result = []; //存储所有promise的结果
    const len = promises.length;
    let resolveCount = 0;
    promises.forEach((p) => {
      p.then((data) => {
        result.push(data);
        resolveCount++;
        if (resolveCount == len) {
          //已经完成最后一个promise
          resolve(result);
        }
      }).catch((err) => {
        reject(err);
      });
    });
  });
};
//传入promise数组，只要有一个fullfilled，就立即返回
MyPromise.race = function (promises) {
  return new MyPromise((resolve, reject) => {
    let tag = false;
    promises.forEach((p) => {
      p.then((data) => {
        if (!tag) {
          resolve(data);
          tag = true;
        }
      }).catch((err) => {
        reject(err);
      });
    });
  });
};

new MyPromise((resolve, reject) => {
  console.log(0);
  resolve(1);
})
  .then((v) => {
    console.log(v);
    return v + 1;
  })
  .then((v) => {
    console.log(v);
  });
//0,1,2

MyPromise.all([
  new MyPromise.resolve(1),
  new MyPromise.resolve(2),
  new MyPromise.resolve(3),
  new MyPromise.resolve(4)
]).then((data) => {
  console.log('all', data); //1,2,3,4
});
MyPromise.race([
  new MyPromise.resolve(1),
  new MyPromise.resolve(2),
  new MyPromise.resolve(3),
  new MyPromise.resolve(4)
]).then((data) => {
  console.log('race', data); //1
});
```

# Vue

## 组件化

**数据驱动视图（MVVM）**

View(DOM)-ViewModel(包含 DOM Listeners,Directives,即 Vue)-Model（js 数据对象）

**Vue 响应式**

组件 data 的数据一旦变化，立即触发视图更新

Vue2:Object.defineProperty
Vue3:Proxy

```js
const data = { name: 'abc' };
Object.defineProperty(data, 'name', {
  get() {
    console.log('get');
    return this.name;
  },
  set(newValue) {
    console.log('set');
    this.name = newValue;
  }
});
```
