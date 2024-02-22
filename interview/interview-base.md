# 事件冒泡、事件捕获、事件流

- 事件冒泡：从目标元素自下而上一直到 window（结束）这样一个过程,可使用 stopPropagation() 和 cancelBubble 阻止冒泡
- 事件捕获：从 window 自上而下一直到目标元素的这样一个过程
  一般是先执行捕获，后执行冒泡
- 事件流：当一个事件触发时候，一般会经历 3 个过程，第一个为捕获阶段，第二个为目标阶段，第三个为冒泡阶段
- 事件代理：将动作监听挂载在父元素，通过捕获阶段得到触发动作的子元素，再进行动作处理，减少浏览器内存损坏。

# EventLoop 事件循环、宏任务、微任务

- 从前到后，一行一行执行
- 如果某一行报错，则停止下面代码的执行
- 先把同步代码执行完，再执行异步
- js 是单线程，与 DOM 渲染共用一个线程

**DOM 事件和 eventloop**

- dom 事件注册动作监听已经记录了，触发时机与异步不同

- 异步（setTimeout,ajax）和都使用回调，都基于 eventloop

**eventloop 过程**

1. 同步代码，一行一行放在 call stack 执行
2. 遇到异步，先记录下，等待时机（网络请求，定时器）
3. 时机到了，将异步移到 callback queue 中
4. 如果 call stack 为空（即同步代码执行完毕），eventloop 开始工作
5. 轮询查找 callback queue，如果有则移动到 call stack 执行
6. 然后继续轮询查找（永动机）

**宏任务、微任务**
同步执行：整体 script 代码

宏任务主要包含：UI 交互事件、setTimeout、setInterval、I/O(Node.js 环境)、setImmediate(Node.js 环境)

微任务主要包含：Promise、MutationObserver、process.nextTick(Node.js 环境)

- 宏任务：setTimeout,setInterval,ajax,dom 事件
- 微任务：promise，async/await
- 微任务执行时间比宏任务要早
- 宏任务在 DOM 渲染后触发
- 微任务在 DOM 渲染前触发
- 微任务是 es6 语法规定的，宏任务是浏览器规定的

**过程：**

1. call stack 空闲（全部 script 代码执行完，可用 alert 阻断 js 执行和 dom 渲染，查看效果）
2. （执行微任务）尝试 DOM 渲染（执行宏任务）
3. 触发 Event loop

# async/await

- 异步回调地狱
- promise then catch 链式调用，但也基于回调函数
- async/await 同步语法，彻底消灭回调函数，
- 与 promise 不排斥，两者相辅相成
- 执行 async 函数，返回的是 promise 对象
- await 相当于 promise 的 then
- try catch 可捕获异常，代替 promise catch
- await 后面可看做 promise then 的 callback 内容

# 类型转换

基本类型：undefined,string,number,boolean,symbol

```js
typeof console.log; //function
typeof function () {}; //function
typeof null; //object

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

# 原型和原型链

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
//实例.__proto__==原型
s.__proto__===Student.prototype//true
Student.prototype.__proto__//People.prototype
People.prototype.__proto__//Object.prototype
Object.prototype.__proto__//null

//实例.constructor === 构造函数
s.constructor==Student//true

```

- 每个 class 都有显式原型 prototype
- 每个实例都有隐式原型`__proto__`
- 实例的`__proto__`指向对应 class 的 prototype

基于原型的执行规则

- 获取属性或方法时，先在自身属性和方法中查找
- 如果找不到，就自动去`__proto__`中查找

原型链：instanceof 通过`__proto__`找到对于 prototype 则为 true

# 作用域和闭包

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

# this 指向

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

# 检测数据类型

typeof、instanceof、constructor、Object.prototype.toString.call()

typeof 只针对基本数据类型，遇到引用数据类型是不起作用的（无法细分对象）

instanceof 用来判断对象和函数，不适合判断字符串和数字

constructor 是 Object 其中的一个属性。默认指向实例的构造函数

通过 Object.prototype.toString 方法，判断某个对象值属于哪种内置类型

# 柯里化

在一个函数中，首先填充几个参数，然后再返回一个新的函数。

通常可用于在不侵入函数的前提下，为函数预置通用参数，供多次重复调用。

**特点：**

- 参数复用
- 提前返回
- 延迟执行

# 节流和防抖

- 节流（n 秒内只触发一次，再触发拦截返回）
- 防抖（n 秒内只触发一次，再触发重新计算）

# es5 和 es6 继承的方式有哪些

## ES5 继承方式：

1. **原型链继承**：

   - 使用 `Object.create()` 方法创建一个新对象，其原型指向父对象。

   ```javascript
   function Parent() {
     this.name = 'Parent';
   }
   Parent.prototype.sayName = function () {
     console.log(this.name);
   };

   var parent = new Parent();
   var child = Object.create(parent);
   child.name = 'Child';
   child.sayName(); // 输出: Child
   ```

2. **构造函数继承**：

   - 使用 `call` 或 `apply` 方法调用父构造函数，并传递 `this` 到子构造函数。

   ```javascript
   function Parent(name) {
     this.name = name;
   }

   function Child(name, age) {
     Parent.call(this, name);
     this.age = age;
   }

   var child = new Child('Child', 5);
   console.log(child.name); // 输出: Child
   console.log(child.age); // 输出: 5
   ```

3. **组合继承**：

   - 结合原型链继承和构造函数继承，先通过原型链继承父对象的方法，然后通过构造函数继承父对象的属性。

   ```javascript
   function Parent(name) {
     this.name = name;
   }
   Parent.prototype.sayName = function () {
     console.log(this.name);
   };

   function Child(name, age) {
     Parent.call(this, name);
     this.age = age;
   }
   Child.prototype = Object.create(Parent.prototype);
   Child.prototype.constructor = Child;

   var child = new Child('Child', 5);
   child.sayName(); // 输出: Child
   console.log(child.age); // 输出: 5
   ```

4. **原型式继承**：

   - 使用对象字面量作为父对象的副本。

   ```javascript
   var parent = {
     name: 'Parent',
     sayName: function () {
       console.log(this.name);
     }
   };

   var child = Object.create(parent);
   child.name = 'Child';
   child.sayName(); // 输出: Child
   ```

5. **寄生式继承**：

   - 在原型式继承的基础上，添加方法来增强对象。

   ```javascript
   function object(o) {
     var clone = Object.create(o);
     clone.sayName = function () {
       console.log(this.name);
     };
     return clone;
   }

   var parent = {
     name: 'Parent'
   };
   var child = object(parent);
   child.name = 'Child';
   child.sayName(); // 输出: Child
   ```

## ES6 继承方式：

1. **类（Class）继承**：

   - 使用 `class` 关键字定义类，并通过 `extends` 关键字实现继承。

   ```javascript
   class Parent {
     constructor(name) {
       this.name = name;
     }
     sayName() {
       console.log(this.name);
     }
   }

   class Child extends Parent {
     constructor(name, age) {
       super(name);
       this.age = age;
     }
   }

   var child = new Child('Child', 5);
   child.sayName(); // 输出: Child
   console.log(child.age); // 输出: 5
   ```

ES6 的类继承简化了 ES5 中的继承模式，使得代码更加清晰和易于理解。类继承在 ES6 中是通过原型链实现的，但是提供了更接近传统面向对象编程的语法。

# cookie、localstorage、session

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

# defer 和 async 区别

- 两个都是异步加载 JS 脚本，不阻塞 html 解析
- defer 是先加载，等到 dom 解析完，在 DOMContentLoaded 事件之前按顺序执行脚本
  执行时间不同
- async 是加载完立即执行,顺序不定
- type="module"的效果等同于 defer
