# promise 和 async await 区别

1. async/await 是建立在 Promises 上的，不能被使用在普通回调以及节点回调
2. async/await 相对于 promise 来讲，写法更加优雅
3. async/await 和 Promises 很像，不阻塞
4. async/await 代码看起来像同步代码

# 事件循环

1. 在此次 tick 中选择最先进入队列的任务( oldest task )，如果有则执行(一次)
2. 检查是否存在 Microtasks ，如果存在则不停地执行，直至清空 Microtask Queue
3. 更新 render

宏任务主要包含：script( 整体代码)、setTimeout、setInterval、I/O、UI 交互事件、setImmediate(Node.js 环境)

微任务主要包含：Promise、MutationObserver、process.nextTick(Node.js 环境)microtask 优先于 task 执行

# 事件冒泡、事件捕获、事件流

事件冒泡：就是从目标元素自下而上一直到 window（结束）这样一个过程,可使用 stopPropagation() 和 cancelBubble 阻止冒泡

事件捕获：就是从 window 自上而下一直到目标元素的这样一个过程

一般是先执行捕获，后执行冒泡

事件流：当一个事件触发时候，一般会经历 3 个过程，第一个为捕获阶段，第二个为目标阶段，第三个为冒泡阶段这么一个过程

# 浅拷贝的方式

Object.assign()、Array.prototype.concat()、Array.prototype.slice()、扩展运算符……

# 深拷贝

JSON.parse(JSON.stringify())、

手写递归

```js
let deepClone = (obj) => {
  let newObj = Array.isArray(obj) ? [] : {};
  if (obj && typeof obj === 'object') {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (obj[key] && typeof obj[key] === 'object') {
          newObj[key] = deepClone(obj[key]);
        } else {
          // 如果不是对象直接拷贝
          newObj[key] = obj[key];
        }
      }
    }
  }
  return newObj;
};
```

jquery 的$.extend,lodash 的 cloneDeep

# 检测数据类型

typeof、instanceof、constructor、Object.prototype.toString.call()

typeof 只针对基本数据类型，遇到引用数据类型是不起作用的（无法细分对象）

instanceof 用来判断对象和函数，不适合判断字符串和数字

constructor 是 Object 其中的一个属性。默认指向实例的构造函数

通过 Object.prototype.toString 方法，判断某个对象值属于哪种内置类型

# 原型、构造函数、实例

- 原型(prototype): 一个简单的对象，用于实现对象的 属性继承。可以简单的理解成对象的爹。在 Firefox 和 Chrome 中，每个 JavaScript 对象中都包含一个**proto**(非标准)的属性指向它爹(该对象的原型)，可 obj.**proto**进行访问。
- 构造函数: 可以通过 new 来 新建一个对象的函数。
- 实例: 通过构造函数和 new 创建出来的对象，便是实例。实例通过**proto**指向原型，通过 constructor 指向构造函数。

```js
实例.__proto__ === 原型;

原型.constructor === 构造函数;

构造函数.prototype === 原型;

// 这条线其实是是基于原型进行获取的，可以理解成一条基于原型的映射线
// 例如:
// const o = new Object()
// o.constructor === Object   --> true
// o.__proto__ = null;
// o.constructor === Object   --> false
实例.constructor === 构造函数;
```

# 原型链

原型(prototype)：函数自带的属性,函数的实例化对象找不到某个属性或者方法，一定会去构造函数的原型下去找

原型链(**proto**)：实例化对象身上自带一个属性

原型关系链：函数的实例化对象找不到某个属性或方法，一定会去构造函数的原型下去找，如果还没有会去原型下的原型链查找，直到找到 Object.prototype 为止

两者关系：实例化对象的原型链 === 构造函数的原型

**Function._proto_(getPrototypeOf)是什么？**

获取一个对象的原型，在 chrome 中可以通过**proto**的形式，或者在 ES6 中可以通过 Object.getPrototypeOf 的形式。

```js
Function.__proto__ == Object.prototype; //false
Function.__proto__ == Function.prototype; //true Function的原型也是Function
```

# this 指向

1. 全局下的 this 是 window
2. 单纯的函数名+括号执行，this 是 window
3. 匿名函数自执行，this 是 window
4. 定时器中的 this 是 window
5. 事件触发，触发谁 this 就是谁
6. 对象方法中，.前面是谁 this 就指向谁
7. 构造函数中 this 是实例化对象
8. 严格模式下 this 是 undefined
9. 箭头函数中 this 指向上一级
10. 箭头函数中 this 暴露在外面就指向 window

# 改变 this 指向的方法

call、apply、bind

call 和 apply 可以自动执行，bind 需要手动调用，返回值为函数

call 和 bind 都有无数个参数，apply 只有两个参数，并且第二个为数组

```js
window.addEventListener('resize', this.onResize.bind(this));
myFun.call(this, 'a', 1);
myFun.apply(this, ['a', 1]);
```

# 箭头函数

```js
function a() {
  return () => {
    return () => {
      console.log(this);
    };
  };
}
console.log(a()()()); //window
```

箭头函数其实是没有 this 的，这个函数中的 this 只取决于他外面的第一个不是箭头函数的函数的 this。

# 严格模式与非严格模式的区别

非严格模式又被被称为懒散模式

严格模式 use strict 是一种 ECMAscript 5 添加的运行模式，这种模式使得 Js 在更严格的条件下运行，使 JS 编码更加规范化

消除 Javascript 语法的一些不合理、不严谨之处，减少一些怪异行为。

严格模式中变量必须显示声明

在严格模式下，arguments 和 eval 是关键字，不能被修改

在严格模式下，函数的形参也不可以同名

# 闭包

在 Js 中当函数套函数，子函数使用了父函数的参数或者变量，并且子函数被外界所使用（没有释放），

此时父函数的参数和变量，是不会被浏览器垃圾回收机制立马收回，这个时候父级形成了闭包环境。

```js
function fn() {
  let a = 10;
  return function () {
    console.log(a);
  };
}
let f = fn();
console.dir(f); // 控制台中的closure就代表闭包
```

**优点：**

保护—闭包会形成私有作用域，保护里面的私有变量不受外界干扰

存储—闭包可以把父函数的参数或变量存储起来

**缺点：**

相对于普通函数要消耗内存，闭包使用不当将会在 IE(IE9 之前)中造成内存泄漏

# Ajax

```js
//下载二进制文件
function getBlob(url, cb) {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'blob';
    xhr.onload = function () {
      if (xhr.status === 200) {
        resolve(xhr.response);
      }
    };
    xhr.onerror = function (err) {
      console.log(err);
      reject();
    };
    xhr.send();
  });
}

function post(url, data) {
  let xhr = new XMLHttpRequest();
  xhr.open('POST', url, true);
  xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;chartset=uft-8');
  const form = [];
  for (let k in data) {
    form.push(`${k}=${data[k]}`);
  }
  form.j;

  xhr.send(form.join('&'));
}
```
