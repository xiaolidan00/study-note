# 实现 Event emitter 类

```js
class EventEmitter {
  constructor() {
    this.eventMap = {};
  }

  on(event, callback) {
    if (this.eventMap[event]?.length) {
      const f = this.eventMap[event].findIndex((it) => it === callback);
      if (f == -1) {
        this.eventMap[event].push(callback);
      }
    } else {
      this.eventMap[event] = [callback];
    }
  }
  off(event, callback) {
    if (this.eventMap[event]?.length) {
      this.eventMap[event] = this.eventMap[event].filter((it) => it !== callback);
    }
  }
  emit(event, data) {
    if (this.eventMap[event]?.length) {
      this.eventMap[event].forEach((fn) => {
        fn(data);
      });
    }
  }
  once(event, callback) {
    const fun = (data) => {
      callback(data);
      this.off(event, fun);
    };
    this.on(event, fun);
  }
}
```

# 节流

高频事件触发，但在 n 秒内只会执行一次，所以节流会稀释函数的执行频率

```js
//每次触发事件时都判断当前是否有等待执行的延时函数
function throttle(fn) {
  let canRun = true; // 通过闭包保存一个标记
  return function () {
    if (!canRun) return; // 在函数开头判断标记是否为true，不为true则return
    canRun = false; // 立即设置为false
    setTimeout(() => {
      // 将外部传入的函数的执行放在setTimeout中
      fn.apply(this, arguments);
      // 最后在setTimeout执行完毕后再把标记设置为true(关键)表示可以执行下一次循环了。当定时器没有执行的时候标记永远是false，在开头被return掉
      canRun = true;
    }, 500);
  };
}
```

# 防抖

触发高频事件后 n 秒内函数只会执行一次，如果 n 秒内高频事件再次被触发，则重新计算时间

```js
//每次触发事件时都取消之前的延时调用方法
function debounce(fn) {
  let timeout = null; // 创建一个标记用来存放定时器的返回值
  return function () {
    clearTimeout(timeout); // 每当用户输入的时候把前一个 setTimeout clear 掉
    timeout = setTimeout(() => {
      // 然后又创建一个新的 setTimeout, 这样就能保证输入字符后的 interval 间隔内如果还有字符输入的话，就不会执行 fn 函数
      fn.apply(this, arguments);
    }, 500);
  };
}
```

# 函数柯里化

将能够接收多个参数的函数转化为接收单一参数的函数，并且返回接收余下参数且返回结果的新函数的技术
函数柯里化的主要作用和特点就是参数复用、提前返回和延迟执行。
在一个函数中，首先填充几个参数，然后再返回一个新的函数的技术，称为函数的柯里化。通常可用于在不侵入函数的前提下，为函数 预置通用参数，供多次重复调用。

```js
const add = function add(x) {
  return function (y) {
    return x + y;
  };
};

const add1 = add(1);

add1(2) === 3;
add1(20) === 21;

const curry = (fn) => {
  return (curried = (...args) => {
    if (args.length >= fn.length) {
      return fn.apply(this.args);
    } else {
      return (...innerArgs) => {
        return curry.apply(this, [...args, ...innerArgs]);
      };
    }
  });
};
```

# 手写 Promise

```js
// 三个状态：PENDING、FULFILLED、REJECTED
const PENDING = 'PENDING';
const FULFILLED = 'FULFILLED';
const REJECTED = 'REJECTED';

class Promise {
  constructor(executor) {
    // 默认状态为 PENDING
    this.status = PENDING;
    // 存放成功状态的值，默认为 undefined
    this.value = undefined;
    // 存放失败状态的值，默认为 undefined
    this.reason = undefined;

    // 调用此方法就是成功
    let resolve = (value) => {
      // 状态为 PENDING 时才可以更新状态，防止 executor 中调用了两次 resovle/reject 方法
      if (this.status === PENDING) {
        this.status = FULFILLED;
        this.value = value;
      }
    };

    // 调用此方法就是失败
    let reject = (reason) => {
      // 状态为 PENDING 时才可以更新状态，防止 executor 中调用了两次 resovle/reject 方法
      if (this.status === PENDING) {
        this.status = REJECTED;
        this.reason = reason;
      }
    };

    try {
      // 立即执行，将 resolve 和 reject 函数传给使用者
      executor(resolve, reject);
    } catch (error) {
      // 发生异常时执行失败逻辑
      reject(error);
    }
  }

  // 包含一个 then 方法，并接收两个参数 onFulfilled、onRejected
  then(onFulfilled, onRejected) {
    if (this.status === FULFILLED) {
      onFulfilled(this.value);
    }

    if (this.status === REJECTED) {
      onRejected(this.reason);
    }
  }
}
```

# bind、call、apply

```js
Function.prototype.myCall = function (context, ...args) {
  if (!context || context === null) {
    context = window;
  }

  let fn = Symbol();
  context[fn] = this;

  return context[fn](...args);
};

Function.prototype.myApply = function (context, args) {
  if (!context || context === null) {
    context = window;
  }

  let fn = Symbol();
  context[fn] = this;

  return context[fn](...args);
};

Function.prototype.myBind = function (context, ...args) {
  if (!context || context === null) {
    context = window;
  }

  let fn = Symbol();
  context[fn] = this;
  let _this = this;

  const result = function (...innerArgs) {
    if (this instanceof _this === true) {
      this[fn] = _this;
      this[fn](...[...args, ...innerArgs]);
    } else {
      context[fn](...[...args, ...innerArgs]);
    }
  };

  result.prototype = Object.create(this.prototype);
  return result;
};
```

# 实现 new

```js
function myNew(fn, ...args) {
  let obj = Object.create(fn.prototype);
  let res = fn.call(obj, ...args);
  if (res && (typeof res === 'object' || typeof res === 'function')) {
    return res;
  }
  return obj;
}
```

# compose

```js
//div2(mul3(add1(add1(0))));=>compose(div2, mul3, add1, add1)(0)
function compose(...fn) {
  if (!fn.length) return (v) => v;
  if (fn.length === 1) return fn[0];
  return fn.reduce(
    (pre, cur) =>
      (...args) =>
        pre(cur(...args))
  );
}
```

# instaceof

```js
function myInstanceof(left, right) {
  while (true) {
    if (left === null) {
      return false;
    }
    if (left.__proto__ === right.prototype) {
      return true;
    }
    left = left.__proto__;
  }
}
```

# Object.freeze

```js
const _objectFreeze = (object) => {
  for (prop in object) {
    const type = Object.prototype.toString.call(object[prop]);
    if (type === '[Object object]' || type === '[Object array]') {
      _objectFreeze(object[prop]);
    } else {
      Object.defineProperty(object, prop, {
        writable: false,
        configurable: false
      });
    }
  }
  Object.preventExtensions(object);
};
```

# 寄生式继承

```js
function Human(name) {
  this.name = name;
  this.kingdom = 'animal';
  this.color = ['yellow', 'white', 'brown', 'black'];
}
Human.prototype.getName = function () {
  return this.name;
};
function Chinese(name, age) {
  Human.call(this, name);
  this.age = age;
  this.color = 'yellow';
}
Chinese.prototype = Object.create(Human.prototype);
Chinese.prototype.constructor = Chinese;
Chinese.prototype.getAge = function () {
  return this.age;
};
```

# vue2 双向绑定

```html
<div id="app">
  <input id="input" vv-model="value" />
  <input id="input1" vv-model="value" />
</div>
<script>
  class Dep {
    constructor() {
      this.watchers = [];
    }
    addWatcher(watcher) {
      this.watchers.push(watcher);
    }
    notify() {
      this.watchers.forEach((watcher) => {
        watcher.update();
      });
    }
  }
  class Watcher {
    constructor(vm, key, callback) {
      this.callback = callback;
      this.vm = vm;
      this.key = key;
      Dep.target = this;
      this.value = this.vm[this.key];
      Dep.target = null;
    }
    update() {
      console.log(this.key, 'update');
      this.callback();
    }
  }
  class MyVue {
    constructor({ el, data }) {
      this.el = el;
      this.data = data;
      this.initData();
      this.initModel();
    }
    initData() {
      Object.entries(this.data).forEach(([key, value]) => {
        let reactiveValue = value;
        const dep = new Dep();
        Object.defineProperty(this, key, {
          configurable: true,
          enumerable: true,
          get() {
            Dep.target && dep.addWatcher(Dep.target);
            return reactiveValue;
          },
          set(newValue) {
            //如果数据发生变化才会更新数据
            if (reactiveValue !== newValue) {
              reactiveValue = newValue;
              dep.notify();
            }
          }
        });
      });
    }
    initModel() {
      const nodes = document.querySelectorAll(this.el + ' [vv-model]');
      console.log(nodes);
      for (let i = 0; i < nodes.length; i++) {
        let node = nodes[i];
        const key = node.getAttribute('vv-model');

        new Watcher(this, key, () => {
          node.value = this[key];
        });

        node.value = this[key];

        node.addEventListener(
          'input',
          (ev) => {
            this[key] = ev.target.value;
          },
          false
        );
      }
    }
  }
  const vm = new MyVue({
    el: '#app',
    data: {
      value: '123',
      name: 'abc'
    }
  });
</script>
```

# vue3 双向绑定

```js
var activeEffect = null;
function effect(fn) {
  activeEffect = fn;
  activeEffect();
  activeEffect = null;
}
var depsMap = new WeakMap();
function gather(target, key) {
  // 避免例如console.log(obj1.name)而触发gather
  if (!activeEffect) return;
  let depMap = depsMap.get(target);
  if (!depMap) {
    depsMap.set(target, (depMap = new Map()));
  }
  let dep = depMap.get(key);
  if (!dep) {
    depMap.set(key, (dep = new Set()));
  }
  dep.add(activeEffect);
}
function trigger(target, key) {
  let depMap = depsMap.get(target);
  if (depMap) {
    const dep = depMap.get(key);
    if (dep) {
      dep.forEach((effect) => effect());
    }
  }
}
function reactive(target) {
  const handle = {
    set(target, key, value, receiver) {
      Reflect.set(target, key, value, receiver);
      trigger(receiver, key); // 设置值时触发自动更新
    },
    get(target, key, receiver) {
      gather(receiver, key); // 访问时收集依赖
      return Reflect.get(target, key, receiver);
    }
  };
  return new Proxy(target, handle);
}

function ref(name) {
  return reactive({
    value: name
  });
}
```

# vue-router

```js
let Vue;

class myRouter {
  constructor(options) {
    this.$options = options;
    //

    // this.routerMap={};
    // this.$options.routes.forEach((route)=>{
    //   this.routerMap[route.path]=route
    // })
    window.addEventListener('hashchange', this.onHashchange.bind(this));

    let initial = window.location.hash.slice(1) || '/';
    this.current = initial;
    Vue.util.defineReactive(this, 'matched', []);
    //match 方法递归遍历路由表获得匹配关系的数组

    this.match();
    //不再需要current作为响应式
    // Vue.util.defineReactive(this,'current',initial)
  }
  onHashchange() {
    // console.log(`window.location`, window.location);
    // console.log(`this`,this)
    this.current = window.location.hash.slice(1);
    this.matched = [];
    this.match();
  }
  match(routes) {
    routes = routes || this.$options.routes;
    //递归遍历路由表
    for (const route of routes) {
      if (route.path === '/' && this.current === '/') {
        this.matched.push(route);
        return;
      }
      // /about/info
      if (route.path !== '/' && this.current.indexOf(route.path) !== -1) {
        this.matched.push(route);
        console.log(`this.matched`, this.matched);
        //往下递归
        if (route.children && route.children.length > 0) {
          this.match(route.children);
        }
        return;
      }
    }
  }
}

myRouter.install = function (_Vue) {
  Vue = _Vue;

  Vue.mixin({
    //这一步关键
    beforeCreate() {
      if (this.$options.router) {
        Vue.prototype.$router = this.$options.router;
      }
    }
  });
  Vue.component('router-link', {
    props: {
      to: {
        type: String,
        required: true
      }
    },
    render(h) {
      return h(
        'a',
        {
          attrs: {
            href: '#' + this.to
          }
        },
        [this.$slots.default]
      );
    }
  });

  Vue.component('router-view', {
    render(h) {
      //标记当前 router-view 的深度
      this.$vnode.data.routerView = true;
      let depth = 0;
      let parent = this.$parent;
      while (parent) {
        const vnodeData = parent.$vnode && parent.$vnode.data;
        if (vnodeData) {
          if (vnodeData.routerView) {
            //说明祖代也是一个 router-view
            depth++;
          }
        }
        parent = parent.$parent;
      }
      console.log(depth);

      // const {routerMap,current}=this.$router;
      // console.log(`routerMap`,routerMap);
      // const component = routerMap[current]?routerMap[current].component:null
      //  return h(component);

      //路由匹配时获取 代表深度层级的 matched数组

      let component = null;
      const route = this.$router.matched[depth];
      if (route) {
        component = route.component;
      }
      return h(component);
    }
  });
};

export default myRouter;
```

# vuex

```js
/* my-vuex/index.js */

// 保存一个全局的 Vue 之后会用到
let _Vue = null

// Store 类
class Store {
  // 先完成构造方法,构造方法接收一个对象
  (options) {
    // 赋初值
    const state = options.state || {}
    const mutations = options.mutations || {}
    const actions = options.actions || {}
    const getters = options.getters || {}
    // 1.实现state 把 state 中的数据转为 响应式,直接用 Vue 中的 observable
    this.state = _Vue.observable(state)

    // 2.实现 getters 这里为什么不知直接 把this.getters 赋值 {} 而是 Object.create(null)
    // 好处是不用考虑会和原型链上的属性重名问题
    this.getters = Object.create(null)
    // 我们要为 getters 添加一个 get 方法，这里就要使用 数据劫持
    // 先拿到 getters 中每一个 方法
    Object.keys(getters).forEach((key) => {
      // 第一个参数是给谁添加 ，第二个是添加的属性名，第三个对象里面可以设置很多参数
      // 比如 可枚举，可配置，get，set
      Object.defineProperty(this.getters, key, {
        // 为 this.getters 每一项都添加 一个 get 方法
        get: () => {
          // 还记得吧，getters 中的方法 默认把 state传入进去,改变this指向
          return getters[key].call(this, this.state)
        },
      })
    })

    // 3.实现 mutations
    // 先遍历 mutaions 中的对象进行改变 this指向
    this.mutations = {}
    Object.keys(mutations).forEach((key) => {
      this.mutations[key] = (params) => {
        // 改变this指向 ，默认是要传入 state
        mutations[key].call(this, this.state, params)
      }
    })

    // 4.实现 actions
    // 和 mutations 一样我们需要重新改变 this 指向
    this.actions = {}
    Object.keys(actions).forEach((key) => {
      this.actions[key] = (params) => {
        // 改变this指向 ，默认是要传入 store也就是 this
        actions[key].call(this, this, params)
      }
    })
  }

  // 5.实现commit 方法
  // 用于 触发mutations中的方法
  // 第一个参数是事件名 ，第二个是参数
  commit = (eventName, params) => {
    this.mutations[eventName](params)
  }

  // 6.实现 dispatch 方法
  // 用于 触发actions中的异步方法
  // 第一个参数是事件名 ，第二个是参数
  dispatch = (eventName, params) => {
    this.actions[eventName](params)
  }
}

// 因为Vuex 需要 Vue.use() 安装，所以我们必须要有个 install 方法 传入 Vue
// 第二个参数是一个可选对象
function install(Vue) {
  // 保存到全局 _Vue
  _Vue = Vue
  // 全局注册混入 这样在所有的组件都能使用 $store
  _Vue.mixin({
    // beforeCreate vue初始化阶段
    // 在 beforeCreate 这个时候把 $store 挂载到 Vue 上
    beforeCreate() {
      // 判断 Vue 传递的对象是否有 store 需要挂载
      // this.$options  是new Vue() 传递的对象
      if (this.$options.store) {
        // 把 store 挂载到 Vue 原型上
        _Vue.prototype.$store = this.$options.store
      }
    },
  })
}

// mapState
const mapState = (params) => {
  // 这里我只写个数组的 起别名的就没弄哈
  if (!Array.isArray(params))
    throw new Error('抱歉，当前是丐版的Vuex，只支持数组参数')
  // 第一步就是要初始 obj ,不然[item] 会报错
  let obj = {}
  // 实现逻辑很简单，就是接收传递的的参数
  // 去this.$store寻找
  params.forEach((item) => {
    obj[item] = function() {
      return this.$store.state[item]
    }
  })
  return obj
}

// mapMutations
const mapMutations = (params) => {
  // 这里我只写个数组的 起别名的就没弄哈
  if (!Array.isArray(params))
    throw new Error('抱歉，当前是丐版的Vuex，只支持数组参数')
  // 第一步就是要初始 obj ,不然[item] 会报错
  let obj = {}
  // 实现逻辑很简单，就是接收传递的的参数
  // 去this.$store寻找
  params.forEach((item) => {
    obj[item] = function(params) {
      return this.$store.commit(item, params)
    }
  })
  return obj
}

// mapActions
const mapActions = (params) => {
  // 这里我只写个数组的 起别名的就没弄哈
  if (!Array.isArray(params))
    throw new Error('抱歉，当前是丐版的Vuex，只支持数组参数')
  // 第一步就是要初始 obj ,不然[item] 会报错
  let obj = {}
  // 实现逻辑很简单，就是接收传递的的参数
  // 去this.$store寻找
  params.forEach((item) => {
    obj[item] = function(params) {
      return this.$store.dispatch(item, params)
    }
  })
  return obj
}

// mapGetters
const mapGetters = (params) => {
  // 这里我只写个数组的 起别名的就没弄哈
  if (!Array.isArray(params))
    throw new Error('抱歉，当前是丐版的Vuex，只支持数组参数')
  // 第一步就是要初始 obj ,不然[item] 会报错
  let obj = {}
  // 实现逻辑很简单，就是接收传递的的参数
  // 去this.$store寻找
  params.forEach((item) => {
    obj[item] = function() {
      return this.$store.getters[item]
    }
  })
  return obj
}
// 导出
export { mapState, mapMutations, mapActions, mapGetters }

// 导出 install 和 store
export default {
  install,
  Store,
}


```

# 权限处理

```html
  <button v-permission="['admin']">权限1</button>    
<button v-permission="['admin', 'editor']">权限2</button>
```

```js
// 注册全局自定义指令，对底层原生DOM操作
Vue.directive('permission', {
  // inserted → 元素插入的时候
  inserted(el, binding) {
    // 获取到 v-permission 的值
    const { value } = binding;
    if (value) {
      // 根据配置的权限，去当前用户的角色权限中校验
      const hasPermission = checkPermission(value);
      if (!hasPermission) {
        // 没有权限，则移除DOM元素
        el.parentNode && el.parentNode.removeChild(el);
      }
    } else {
      throw new Error(`need key! Like v-permission="['admin','editor']"`);
    }
  }
});

// vue3
const myDirective = {
  // 在绑定元素的 attribute 前
  // 或事件监听器应用前调用
  created(el, binding, vnode, prevVnode) {
    // 下面会介绍各个参数的细节
  },
  // 在元素被插入到 DOM 前调用
  beforeMount(el, binding, vnode, prevVnode) {},
  // 在绑定元素的父组件
  // 及他自己的所有子节点都挂载完成后调用
  mounted(el, binding, vnode, prevVnode) {},
  // 绑定元素的父组件更新前调用
  beforeUpdate(el, binding, vnode, prevVnode) {},
  // 在绑定元素的父组件
  // 及他自己的所有子节点都更新后调用
  updated(el, binding, vnode, prevVnode) {},
  // 绑定元素的父组件卸载前调用
  beforeUnmount(el, binding, vnode, prevVnode) {},
  // 绑定元素的父组件卸载后调用
  unmounted(el, binding, vnode, prevVnode) {}
};

// vue2
Vue.directive('my-directive', {
  bind: function (el, binding) {},
  inserted: function () {},
  update: function () {},
  componentUpdated: function () {},
  unbind: function () {}
});
```

# 获取数据准确类型

```js
function getType(data) {
  const t = Object.prototype.toString.call(data);
  return t.substring(t.indexOf(' ') + 1, t.length - 1);
}
```

# 数组算法

## 扁平化数组

```js
[1, [2, [3]]].flat(Infinity);

function flatArr(arr) {
  const res = [];
  const queue = [...arr];
  while (queue.length > 0) {
    const item = queue.shift();
    if (Array.isArray(item)) {
      item.forEach((a) => {
        queue.push(a);
      });
    } else {
      res.push(item);
    }
  }
  return res;
}
```

## 判断回文

```js
function isHuiwen(str) {
  for (let i = 0, j = str.length; i < j; i++, j--) {
    if (str[i] !== str[j]) {
      return false;
    }
  }
  return true;
}
```

## 数组交集

```js
function interset(arr1, arr2) {
  let inArr = arr1.filter((item) => arr2.includes(item));
  return [...new Set(inArr)];
}
```

## 数组去重

```js
[...new Set(arr)];
```

# 树遍历

```js
//树遍历
// 下面是二叉树的构造函数，
// 三个参数分别是左树、当前节点和右树
function Tree(left, label, right) {
  this.left = left;
  this.label = label;
  this.right = right;
}

// 下面是中序（inorder）遍历函数。
// 由于返回的是一个遍历器，所以要用generator函数。
// 函数体内采用递归算法，所以左树和右树要用yield*遍历
function* inorder(t) {
  if (t) {
    yield* inorder(t.left);
    yield t.label;
    yield* inorder(t.right);
  }
}

// 下面生成二叉树
function make(array) {
  // 判断是否为叶节点
  if (array.length == 1) return new Tree(null, array[0], null);
  return new Tree(make(array[0]), array[1], make(array[2]));
}
let tree = make([[['a'], 'b', ['c']], 'd', [['e'], 'f', ['g']]]);

// 遍历二叉树
var result = [];
for (let node of inorder(tree)) {
  result.push(node);
}
```

# list2tree

```js
function list2tree(list, id = 'id', parentId = 'parentId', children = 'children') {
  let map = {};
  let root = [];
  list.forEach((item) => {
    if (item[parentId]) {
      if (Array.isArray(map[item[parentId]])) {
        map[item[parentId]].push(item);
      } else {
        map[item[parentId]] = [item];
      }
    } else {
      root.push(item);
    }
  });
  function toTree(root, map) {
    for (let k in map) {
      for (let i = 0; i < root.length; i++) {
        if (root[i][id] == k) {
          root[i][children] = map[k];
          delete map[k];
          toTree(root[i][children], map);
        }
      }
    }
  }
  toTree(root, map);
  return root;
}
```

# tree2list

```js
function tree2list(root, id = 'id', parentId = 'parentId', children = 'children') {
  function getChildren(tree, parent) {
    let list = [{ ...tree, [parentId]: parent, [children]: [] }];
    if (Array.isArray(tree[children]) && tree[children].length > 0) {
      tree[children].forEach((item) => {
        list = list.concat(getChildren(item, tree[id]));
      });
    }
    return list;
  }
  if (Array.isArray(root)) {
    let result = [];
    root.forEach((item) => {
      result = result.concat(getChildren(item, ''));
    });
    return result;
  } else {
    return getChildren(root, '');
  }
}
```

# 二分查找法

```js
function binarySearch (data, dest, start, end){
		var end = end || data.length-1;
		var start = start || 0;
		var m = Math.floor((start+end)/2);
		if (dest<data[m]){
			return binarySearch(data, dest, start, m-1)
		} else {
			return binarySearch(data, dest, m+1, end)
		}}
		return false
}

```

# 排序算法

## 冒泡排序

```js
function bubbleSort(arr) {
  var len = arr.length;
  for (var i = 0; i < len - 1; i++) {
    for (var j = 0; j < len - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        // 相邻元素两两对比
        var temp = arr[j + 1]; // 元素交换
        arr[j + 1] = arr[j];
        arr[j] = temp;
      }
    }
  }
  return arr;
}
```

## 选择排序

```js
function selectionSort(arr) {
  var len = arr.length;
  var minIndex, temp;
  for (var i = 0; i < len - 1; i++) {
    minIndex = i;
    for (var j = i + 1; j < len; j++) {
      if (arr[j] < arr[minIndex]) {
        // 寻找最小的数
        minIndex = j; // 将最小数的索引保存
      }
    }
    temp = arr[i];
    arr[i] = arr[minIndex];
    arr[minIndex] = temp;
  }
  return arr;
}
```

## 插入排序

```js
function insertionSort(arr) {
  var len = arr.length;
  var preIndex, current;
  for (var i = 1; i < len; i++) {
    preIndex = i - 1;
    current = arr[i];
    while (preIndex >= 0 && arr[preIndex] > current) {
      arr[preIndex + 1] = arr[preIndex];
      preIndex--;
    }
    arr[preIndex + 1] = current;
  }
  return arr;
}
```

## 希尔排序

```js
function shellSort(arr) {
  let length = arr.length;
  let temp;
  for (let step = Math.floor(length / 2); step >= 1; step = Math.floor(step / 2)) {
    for (let i = step; i < length; i++) {
      temp = arr[i];
      let j = i - step;
      while (j >= 0 && arr[j] > temp) {
        arr[j + step] = arr[j];
        j -= step;
      }
      arr[j + step] = temp;
    }
  }
  return arr;
}
```

## 归并排序

```js
function mergeSort(arr) {
  // 采用自上而下的递归方法
  var len = arr.length;
  if (len < 2) {
    return arr;
  }
  var middle = Math.floor(len / 2),
    left = arr.slice(0, middle),
    right = arr.slice(middle);
  return merge(mergeSort(left), mergeSort(right));
}

function merge(left, right) {
  var result = [];

  while (left.length && right.length) {
    if (left[0] <= right[0]) {
      result.push(left.shift());
    } else {
      result.push(right.shift());
    }
  }

  while (left.length) result.push(left.shift());

  while (right.length) result.push(right.shift());

  return result;
}
```

## 快速排序

```js
function quickSort(arr, left, right) {
  var len = arr.length,
    partitionIndex,
    left = typeof left != 'number' ? 0 : left,
    right = typeof right != 'number' ? len - 1 : right;

  if (left < right) {
    partitionIndex = partition(arr, left, right);
    quickSort(arr, left, partitionIndex - 1);
    quickSort(arr, partitionIndex + 1, right);
  }
  return arr;
}

function partition(arr, left, right) {
  // 分区操作
  var pivot = left, // 设定基准值（pivot）
    index = pivot + 1;
  for (var i = index; i <= right; i++) {
    if (arr[i] < arr[pivot]) {
      swap(arr, i, index);
      index++;
    }
  }
  swap(arr, pivot, index - 1);
  return index - 1;
}

function swap(arr, i, j) {
  var temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}
function partition2(arr, low, high) {
  let pivot = arr[low];
  while (low < high) {
    while (low < high && arr[high] > pivot) {
      --high;
    }
    arr[low] = arr[high];
    while (low < high && arr[low] <= pivot) {
      ++low;
    }
    arr[high] = arr[low];
  }
  arr[low] = pivot;
  return low;
}

function quickSort2(arr, low, high) {
  if (low < high) {
    let pivot = partition2(arr, low, high);
    quickSort2(arr, low, pivot - 1);
    quickSort2(arr, pivot + 1, high);
  }
  return arr;
}
```

## 堆排序

```js
var len; // 因为声明的多个函数都需要数据长度，所以把len设置成为全局变量

function buildMaxHeap(arr) {
  // 建立大顶堆
  len = arr.length;
  for (var i = Math.floor(len / 2); i >= 0; i--) {
    heapify(arr, i);
  }
}

function heapify(arr, i) {
  // 堆调整
  var left = 2 * i + 1,
    right = 2 * i + 2,
    largest = i;

  if (left < len && arr[left] > arr[largest]) {
    largest = left;
  }

  if (right < len && arr[right] > arr[largest]) {
    largest = right;
  }

  if (largest != i) {
    swap(arr, i, largest);
    heapify(arr, largest);
  }
}

function swap(arr, i, j) {
  var temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

function heapSort(arr) {
  buildMaxHeap(arr);

  for (var i = arr.length - 1; i > 0; i--) {
    swap(arr, 0, i);
    len--;
    heapify(arr, 0);
  }
  return arr;
}
```

## 计数排序

```js
function countingSort(arr, maxValue) {
  var bucket = new Array(maxValue + 1),
    sortedIndex = 0;
  (arrLen = arr.length), (bucketLen = maxValue + 1);

  for (var i = 0; i < arrLen; i++) {
    if (!bucket[arr[i]]) {
      bucket[arr[i]] = 0;
    }
    bucket[arr[i]]++;
  }

  for (var j = 0; j < bucketLen; j++) {
    while (bucket[j] > 0) {
      arr[sortedIndex++] = j;
      bucket[j]--;
    }
  }

  return arr;
}
```

## 桶排序

```js
function bucketSort(arr, bucketSize) {
  if (arr.length === 0) {
    return arr;
  }

  var i;
  var minValue = arr[0];
  var maxValue = arr[0];
  for (i = 1; i < arr.length; i++) {
    if (arr[i] < minValue) {
      minValue = arr[i]; // 输入数据的最小值
    } else if (arr[i] > maxValue) {
      maxValue = arr[i]; // 输入数据的最大值
    }
  }

  //桶的初始化
  var DEFAULT_BUCKET_SIZE = 5; // 设置桶的默认数量为5
  bucketSize = bucketSize || DEFAULT_BUCKET_SIZE;
  var bucketCount = Math.floor((maxValue - minValue) / bucketSize) + 1;
  var buckets = new Array(bucketCount);
  for (i = 0; i < buckets.length; i++) {
    buckets[i] = [];
  }

  //利用映射函数将数据分配到各个桶中
  for (i = 0; i < arr.length; i++) {
    buckets[Math.floor((arr[i] - minValue) / bucketSize)].push(arr[i]);
  }

  arr.length = 0;
  for (i = 0; i < buckets.length; i++) {
    insertionSort(buckets[i]); // 对每个桶进行排序，这里使用了插入排序
    for (var j = 0; j < buckets[i].length; j++) {
      arr.push(buckets[i][j]);
    }
  }

  return arr;
}
```

## 基数排序

```js
//LSD Radix Sort
var counter = [];
function radixSort(arr, maxDigit) {
  var mod = 10;
  var dev = 1;
  for (var i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
    for (var j = 0; j < arr.length; j++) {
      var bucket = parseInt((arr[j] % mod) / dev);
      if (counter[bucket] == null) {
        counter[bucket] = [];
      }
      counter[bucket].push(arr[j]);
    }
    var pos = 0;
    for (var j = 0; j < counter.length; j++) {
      var value = null;
      if (counter[j] != null) {
        while ((value = counter[j].shift()) != null) {
          arr[pos++] = value;
        }
      }
    }
  }
  return arr;
}
```

# 斐波那契数列

```js
function fibonacci(n) {
  let sum = 0;
  let last = 1;
  for (let i = 1; i <= n; i++) {
    const tmp = sum;
    sum = last;
    last = tmp + last;
  }
  console.log(sum);
  return sum;
}
```

# getJSON

```js
const getJSON = function (url) {
  const promise = new Promise(function (resolve, reject) {
    const handler = function () {
      if (this.readyState !== 4) {
        return;
      }
      if (this.status === 200) {
        resolve(this.response);
      } else {
        reject(new Error(this.statusText));
      }
    };
    const client = new XMLHttpRequest();
    client.open('GET', url);
    client.onreadystatechange = handler;
    client.responseType = 'json';
    client.setRequestHeader('Accept', 'application/json');
    client.send();
  });
  return promise;
};
getJSON('/posts.json').then(
  function (json) {
    console.log('Contents: ' + json);
  },
  function (error) {
    console.error('出错了', error);
  }
);
```

# 设计模式

## 工厂模式

```js
function CreatePerson(name, age, sex) {
  var obj = new Object();
  obj.name = name;
  obj.age = age;
  obj.sex = sex;
  obj.sayName = function () {
    return this.name;
  };
  return obj;
}
var p1 = new CreatePerson('longen', '28', '男');
var p2 = new CreatePerson('tugenhua', '27', '女');
console.log(p1.name); // longen
console.log(p1.age); // 28
console.log(p1.sex); // 男
console.log(p1.sayName()); // longen

console.log(p2.name); // tugenhua
console.log(p2.age); // 27
console.log(p2.sex); // 女
console.log(p2.sayName()); // tugenhua
```

## 单例模式

只能被实例化(构造函数给实例添加属性与方法)一次

```js
// 单体模式
var Singleton = function (name) {
  this.name = name;
};
Singleton.prototype.getName = function () {
  return this.name;
};
// 获取实例对象
var getInstance = (function () {
  var instance = null;
  return function (name) {
    if (!instance) {
      //相当于一个一次性阀门,只能实例化一次
      instance = new Singleton(name);
    }
    return instance;
  };
})();
// 测试单体模式的实例,所以a===b
var a = getInstance('aa');
var b = getInstance('bb');
```

## 沙箱模式

将一些函数放到自执行函数里面,但要用闭包暴露接口,用变量接收暴露的接口,再调用里面的值,否则无法使用里面的值

```js
let sandboxModel=(function(){
    functionsayName(){};
    functionsayAge(){};
    return{
        sayName:sayName,
        sayAge:sayAge
    }
})()

```

## 发布者订阅模式

```js
//发布者与订阅模式
var shoeObj = {}; // 定义发布者
shoeObj.list = []; // 缓存列表 存放订阅者回调函数

// 增加订阅者
shoeObj.listen = function (fn) {
  shoeObj.list.push(fn); // 订阅消息添加到缓存列表
};

// 发布消息
shoeObj.trigger = function () {
  for (var i = 0, fn; (fn = this.list[i++]); ) {
    fn.apply(this, arguments); //第一个参数只是改变fn的this,
  }
};
// 小红订阅如下消息
shoeObj.listen(function (color, size) {
  console.log('颜色是：' + color);
  console.log('尺码是：' + size);
});

// 小花订阅如下消息
shoeObj.listen(function (color, size) {
  console.log('再次打印颜色是：' + color);
  console.log('再次打印尺码是：' + size);
});
shoeObj.trigger('红色', 40);
shoeObj.trigger('黑色', 42);
```

**观察者模式的概念**

行为型模式，一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。这个主体对象在状态变化时，会通知所有的观察者对象，使他们能够自动更新自己。

**发布订阅者模式的概念**

发布-订阅模式，消息的发送方，叫做发布者（publishers），消息不会直接发送给特定的接收者，叫做订阅者。意思就是发布者和订阅者不知道对方的存在。需要一个第三方组件，叫做信息中介，它将订阅者和发布者串联起来，它过滤和分配所有输入的消息。换句话说，发布-订阅模式用来处理不同系统组件的信息交流，即使这些组件不知道对方的存在。

在观察者模式中，观察者是知道 Subject 的，Subject 一直保持对观察者进行记录。然而，在发布订阅模式中，发布者和订阅者不知道对方的存在。它们只有通过消息代理进行通信。

在发布订阅模式中，组件是松散耦合的，正好和观察者模式相反。

观察者模式大多数时候是同步的，比如当事件触发，Subject 就会去调用观察者的方法。而发布-订阅模式大多数时候是异步的（使用消息队列）。

观察者 模式需要在单个应用程序地址空间中实现，而发布-订阅更像交叉应用模式。
