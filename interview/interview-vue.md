# vue2 与 vue3 对比

1. 体积更小,代码组织更清晰，编译优化
2. 数据劫持方式:Vue2 Object.defineProperty vue3 Proxy，结合 Reflect 操作数据
3. 更好地支持 ts，SSR,tree-shaking
4. 组合式 API，Suspense，Fragment，Teleport
5. 虚拟 DOM 增加静态标记 patchFlag,事件缓存，对不参与更新的元素做静态提升，只创建一次，之后不停复用
6. 生命周期变了：beforeCreate,created 变成 setup

# vue3 重大升级

1. createApp
2. emits
3. 生命周期
4. Suspense，Fragment，Teleport
5. 多事件
6. 异步组件
7. 移除 filter，sync
8. 组合式 API:setup,reactive,ref,readonly,watch,watchEffect

# v-if 在 vue2 和 vue3 中区别

vue2 中 v-for 优先级高于 v-if

vue3 中 v-if 比 v-for 的优先级更高，可采用 template 包裹，尽量用 filter 后结果

# watch 与 watchEffect 区别

- 两个都可监听 data 属性变化
- watch 需明确监听哪个属性
- watchEffect 会根据函数里面的属性，自动监听其变化
- watch immediate,watchEffect 初始化一定会执行

# Vue3 性能为什么比 vue2 好

- Proxy 响应式
- PatchFlag 静态标记
- hoistStatic 静态提升
- cacheHandler 事件缓存
- SSR 优化
- tree-shaking

## PatchFlag 静态标记

- 编译模板是，动态节点做标记
- 标记，分为不同的类型，如 TEXT,PROPS
- diff 算法时，可以区分静态节点，以及不同类型的动态节点,只比较动态节点

## hoistStatic 静态提升

- 将静态节点的定义，提升到父作用域，缓存起来
- 多个相邻的静态节点会被合并起来
- 典型的空间换时间优化策略
- 对不参与更新的元素做静态提升，只创建一次，之后不停复用

```jsx
  <a>1234</a>
  <a>{{text}}</a>


const _hoisted_1 = /*#__PURE__*/_createElementVNode("a", null, "1234", -1 /* HOISTED */)

_createElementVNode("a", null, _toDisplayString(_ctx.text), 1 /* TEXT */)

```

## cacheHandler 事件缓存

- 有事件就缓存起来，没有就创建再缓存起来

```jsx
<p class="aaa" style="color:blue" @click="onClickBtn">AAA</p>

_createElementVNode("p", { class: "aaa", style: "color":"blue"},
onClick: _cache[0] || (_cache[0] =
(...args) => (_ctx.onClickBtn && _ctx.onClickBtn(...args))) }, "AAA "),
```

## SSR 优化

- 静态节点直接输出字符串，绕过了 vdom
- 动态节点，还是需要动态渲染

```jsx
<div>
  <a>1234</a>
  <a>{{ text }}</a>
</div>;

export function ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  const _cssVars = { style: { color: _ctx.color } };
  _push(
    `<div${_ssrRenderAttrs(_mergeProps(_attrs, _cssVars))}><a>1234</a><a>${_ssrInterpolate(
      _ctx.text
    )}</a></div>`
  );
}
```

## tree-shaking

按需引入

```jsx
<div>
  <a>1234</a>
 <input v-model="msg">
 </div>

 import { createElementVNode as _createElementVNode,
 vModelText as _vModelText,
 withDirectives as _withDirectives,
 openBlock as _openBlock, createElementBlock as _createElementBlock } from "vue"

const _hoisted_1 = /*#__PURE__*/_createElementVNode("a", null, "1234", -1 /* HOISTED */)

export function render(_ctx, _cache, $props, $setup, $data, $options) {
  return (_openBlock(), _createElementBlock("div", null, [
    _hoisted_1,
    _withDirectives(_createElementVNode("input", {
      "onUpdate:modelValue": _cache[0] || (_cache[0] = $event => ((_ctx.msg) = $event))
    }, null, 512 /* NEED_PATCH */), [
      [_vModelText, _ctx.msg]
    ])
  ]))
}
```

# 组合式 API 和 React Hooks 对比

- 前者 setup 只会调用一次，后者函数会被多次调用
- 前者无须 useMemo,useCallback 缓存，因为 setup 只调用一次
- 前者无须顾虑调用顺序，后者需要保证 hooks 的顺序一致
- reactive+ref 比 useState 更难理解

# vue3 script setup

语法糖衣
版本>=3.2

- 顶级变量，可直接用于模板，如 ref,reactive

```vue
<script setup>
  import { reactive, toRefs, ref, useSlots, useAttrs } from 'vue';

  const inputRef = ref(null);
  const state = reactive({
    name: '1234'
  });
  const { name } = toRefs(state);
  //定义属性
  const props = defineProps({
    msg: String
  });
  function handleChange(ev) {
    emit('change', ev);
  }
  //定义事件
  defineEmits(['change']);
  //暴露信息
  defineExpose({
    state,
    inputRef: inputRef.value
  });
  //获取slot
  const slots = useSlots();
  const MySlot = createSlot(slots);
  const slotRef = ref(null);

  //获取属性
  const attrs = useAttrs();
  //定义选项
  defineOptions({ name: 'MyButton' });
</script>
<template>
  <input ref="inputRef" />
  <button @click="handleChange">{{ name }}{{ props.msg }}</button>
  <MySlot ref="slotRef" />
</template>
```

# vue3 用 jsx 定义 组件

```jsx
const MyButton=defineComponent({
    props:['msg'];
  setup(props, context) {
    const count = ref(0);
    return () => <button>{props.msg}{count}</button>;
  }
});
defineComponent((props, context) => {
  const count = ref(0);
  return () => <p>{count}<MyButton msg={count}>Hello</MyButton></p>;
});
```

## jsx 与 template 区别

- jsx 本质是 js 代码，可以使用 js 的任何能力
- template 只能潜入简单的 js 表达式，其他需要指令，如 v-if 完成
- jsx 已经成为 es 规范，template 只是 vue 的规范
- 两者本质相同，都会编译成 js（render 函数转化成虚拟 DOM）

## slot

```js
<tabs>
  <tab-item></tab-item>
  <tab-item></tab-item>
</tabs>;
//读取slot
setup(props, context) {
const children=context.slots.default();

}
```

## 作用域插槽

```jsx
const dataValue=ref(100)
<div>
    <slot data="dataValue"></slot>
</div>

<Container>
    <template v-slot:default="slotProps">
        <p >{{slotProps.data}}</p>
        </template>
</Container>

<Container>
<Child render={(data)=><p>{ data}</p>}></Child>
</Container>

<div>
    {props.render(dataValue.value)}
</div>
```

# vuex

```txt
//属性
state
getters
action
mutation
//方法
dispatch
commit
mapState
mapGetters
mapActions
mapMutations

vue->触发actions（异步操作）->提交mutations（原子操作）->修改state->更新vue
```

# vue-router

- 路由模式：hash（hashchange） history(pushState,replaceState,popstate)
- 路由配置：动态路由（路由 params 参数），懒加载(import)

# vue2 defineProperty

问题

- 不可深度监听数组和对象，需要递归到底，一次性计算量大
- 无法监听新增和删除属性（Vue.set,Vue.delete）
- 无法监听原生数组，需要特殊处理

```js
function defineReactive(data, key) {
  //深度监听
  observer(data[key]);
  Object.defineProperty(data, key, {
    value: data[key], //属性值
    writable: true, //可读写
    configurable: true, //数据可改变
    enumerable: true, //可枚举
    get() {
      trackDep(); //收集依赖
      return this.value;
    },
    set(value) {
      if (value !== this.value) {
        //深度监听
        observer(value);
        this.value = value;
        notifyUpate(); //通知更新
      }
    }
  });
}
function observer(target) {
  if (typeof target !== 'object' || target === null) {
    return target;
  }
  if (Array.isArray(target)) {
    target.__proto__ = newArrayPrototype;
  }
  for (let key in target) {
    defineReactive(target, key);
  }
}
const oldArrayPrototype = Array.prototype;
const newArrayPrototype = Object.create(oldArrayPrototype)[
  ('push', 'pop', 'splice', 'shift', 'unshift')
].forEach((m) => {
  newArrayPrototype[m] = function () {
    //更新视图
    updateView();
    //执行方法
    oldArrayPrototype[m].call(this, ...arguments);
  };
});
```

# 虚拟 DOM

数据驱动视图 MVVM

- vdom 用 js 模拟 dom 结构，计算出最小的变更，再操作 DOM 更新

snabbdom=>vnode

```js
h('div',{
  on:{click:function}
},[h('span',{},'helloword')])
vnode(selector,data,children,text,domElemt,key)

patch(oldNode,newNode)//callbacks 生命周期  hooks
patchVNode//对比children,其中一个不同删除旧，插入新的，两个都相同就更新updateChildren
updateChildren(oldchild,newchild)//oldStartIdx,newStartIdx,oldEndIdx,newEndIdx 头尾双指针对比vnode,新node找到key对应的旧node就移动，否则增删
sameNode()//key selector比较


```

# diff 算法

树 diff 的时间复杂度 O(n^3)

- 遍历 tree1,遍历 tree2
- 排序

优化事件复杂度到 O(n)

- 只比较同一层级，不跨级比较
- tag 不相同，则直接删除掉重建，不再深度比较
- tag 和 key 两者相同，则认为是相同点，不再深度比较

# vue 模板

- vue-template complier 将模板编译成 render 函数
- 执行 render 生成 vnode

```js
//with语法
const obj = { a: 1, b: 2 };
console.log(obj.a);
console.log(obj.b);
console.log(obj.c); //undefined

with (obj) {
  console.log(a);
  console.log(b);
  console.log(c); //报错
}
```

**with 语法**

- 改变{}内自由变量的查找方式，当做 obj 属性查找
- 如果找不到匹配 obj 属性，就会报错
- with 要慎用，它打破了作用域的规则，易读性变差

```js
const compiler = require('vue-template-compiler');
const template = `<p>{{message}}</p>`;
compiler.complie(template).render;
//width(this){return _c('p',[_v(_s(message))])}
//_c createElement
//_v createTextVNode
//_s toString
//_l renderList v-for

const template = `<p>{{flag?message:'not found'}}</p>`;
//width(this){return _c('p',[_v(_s(flag?message:'not found'))])}

Vue.component('heading', {
  render(createElement) {
    return createElement('h' + this.level, [
      createElement(
        'a',
        {
          attrs: {
            name: 'headerId',
            href: '#' + this.headerId
          }
        },
        this.title
      )
    ]);
  }
});
```

# vue 渲染过程

**初次渲染**

- 解析模板为 render 函数（vue-loader）
- 触发响应式，监听 data 属性 getter,setter(视图引用才会触发 get)
- 执行 render 函数，生成 vnode,patch(elm,vnode)

**更新过程**

- 修改 data,触发 setter(在 getter 中已经收集依赖，被监听)
- 重新执行 render 函数，生成 newVNode
- patch(oldVNode,newVNode)

# 异步渲染

- $nextTick 获取 DOM 最新值
- 汇总 data 的修改，一次性更新视图
- 减少 DOM 操作次数，提高性能

# vue-router

## hash 路由

- hash 变化会触发网页跳转，即浏览器前进后退
- hash 变化不会刷新页面，SPA 必备的特点
- hash 永远不会提交到 server 端（分离前后端，纯前端控制）
- onhashchange 监听

## H5 history

- 用 url 规范的路由，但跳转是不刷新页面
- history.pushState,history.replaceState
- window.onpopstate

- 前端跳转，不刷新页面
- 需后台配置,重定向到 index.html

```js
//pushState(state, unused, url)
history.pushState({ page_id: 1, user_id: 5 }, '', 'page1');

const url = new URL(location);
url.searchParams.set('foo', 'bar');
history.pushState({}, '', url);

window.onpopstate = (ev) => {
  console.log(event.state, location.pathname);
};
```

# v-for 用 key

- 不能用 index 和 random
- diff 算法中通过 tag 和 key 来判断，是否 sameNode
- 减少渲染次数，提升性能

# vue 通讯方式

- 父子组件 props 和 this.$emit
- EventBus
- Vuex
- $parent,$children,$ref，expose
- $attrs/$listeners
- provide/inject

# beforeDestory

- 解绑 EventBus.off
- 清除定时器
- 解绑 dom 事件

# Vue 性能优化

- 合理使用 v-show 和 v-if
- 合理使用 computed
- v-for 加 key，避免与 v-if 同时使用
- 自定义事件和 dom 事件及时销毁
- 合理使用异步组件
- 合理使用 keep-alive
- data 层级不要太深
- vue-loader
- webpack
- 懒加载等前端性能优化
- SSR
