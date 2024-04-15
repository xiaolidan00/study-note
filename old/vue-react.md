# vue 与 react 对比

**相同点：**

1. 组件化思想
2. 虚拟 dom
3. 数据驱动视图 MVVM
4. 支持服务器端渲染 SSR
5. 钩子函数 Hooks

**不同点：**

1. 数据流向：react 单向数据流，数据不可变，vue 双向数据流绑定，数据可变
2. 组件化通信：react 函数回调来通信，vue 有子组件向父组件发送事件和回调两种
3. diff 算法：react 主要使用 diff 队列保存需要更新哪些 DOM，得到 patch 树，再统一操作批量更新 DOM。Vue 使用双向指针，边对比，边更新 DOM
4. vue 有指令系统，computed，watch，react 只能用 jsx 语法
5. vue 组件全局注册和局部注册，react 通过 import 来引用

# vue2 与 vue3 对比

1. 体积更小,代码组织更清晰，编译优化
2. 数据劫持方式:Vue2 Object.defineProperty vue3 Proxy，结合 Reflect 操作数据
3. 更好地支持 ts，SSR,tree-shaking
4. 组合式 API，Suspense，Fragment，Teleport
5. 虚拟 DOM 增加静态标记 patchFlag,事件缓存，对不参与更新的元素做静态提升，只创建一次，之后不停复用
6. 生命周期变了：beforeCreate,created 变成 setup，组合式 API

# Vue3 性能为什么比 vue2 好

1. Proxy 响应式
2. PatchFlag 静态标记
3. hoistStatic 静态提升
4. cacheHandler 事件缓存
5. SSR 优化
6. 组合式 API 更好地 tree-shaking

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

# Vue 的组合式 API 与 react 的 hooks 区别

1. react hooks 有严格调用顺序，不可写在条件判断中，依靠依赖数组收集响应。需要用 useMemo(缓存函数计算结果),useCallback（缓存事件调用函数） 来缓存.可能会出现变量闭包不好追踪的问题
2. vue 的组合式 API 不限制调用顺序，可有条件调用，自动收集依赖，无需手动缓存

# React 中 useMemo 与 useCallback 区别

```jsx
import { useMemo, useCallback } from 'react';

function ProductPage({ productId, referrer }) {
  const product = useData('/product/' + productId);

  const requirements = useMemo(() => {
    //调用函数并缓存结果
    return computeRequirements(product);
  }, [product]);

  const handleSubmit = useCallback(
    (orderDetails) => {
      // 缓存函数本身
      post('/product/' + productId + '/buy', {
        referrer,
        orderDetails
      });
    },
    [productId, referrer]
  );

  return (
    <div className={theme}>
      <ShippingForm requirements={requirements} onSubmit={handleSubmit} />
    </div>
  );
}
```

# vue 通讯方式

1. 父子组件 props 和 emit
2. EventBus
3. Vuex,pinia
4. $parent,$children,$ref，expose
5. $attrs/$listeners
6. provide/inject

# Vue 性能优化

https://cn.vuejs.org/guide/best-practices/performance.html

1. 合理使用 v-show 和 v-if,v-once
2. 合理使用 computed
3. v-for 加 key，避免与 v-if 同时使用
4. 自定义事件和 dom 事件及时销毁
5. 合理使用异步组件,懒加载
6. 合理使用 keep-alive
7. SSR
8. 使用 tree-shaking 友好的 esmodule 第三方库
9. props 稳定性，active="activeId==item.id"
10. v-once：只渲染一次，更新跳过
11. v-memo：有条件地跳过某些大型子树或者 v-for 列表的更新
12. 虚拟滚动
13. 减少大型不可变数据的响应性开销：通过使用 shallowRef() 和 shallowReactive() 来绕开深度响应
14. 避免不必要的组件抽象，抽离出过多子组件

**v-memo**

- v-memo="[valueA, valueB]":当组件重新渲染，如果 valueA 和 valueB 都保持不变，这个 `<div>` 及其子项的所有更新都将被跳过。实际上，甚至虚拟 DOM 的 vnode 创建也将被跳过，因为缓存的子树副本可以被重新使用。
- v-memo 传入空依赖数组 (v-memo="[]") 将与 v-once 效果相同。
- 当搭配 v-for 使用 v-memo，确保两者都绑定在同一个元素上。v-memo 不能用在 v-for 内部。

```vue
<template>
  <!-- props稳定性 -->
  <!-- 错误做法 -->
  <ListItem v-for="item in list" :id="item.id" :active-id="activeId" />
  <!-- 正确做法 -->
  <ListItem v-for="item in list" :id="item.id" :active="item.id === activeId" />

  <!--v-memo="[item.id == selected]"只有当该项的被选中状态改变时才需要更新-->
  <div v-for="item in list" :key="item.id" v-memo="[item.id == selected]">
    <p>ID: {{ item.id }} - selected: {{ item.id == selected }}</p>
    <p>...more child nodes</p>
  </div>
</template>
```

# React 性能优化

1. 渲染列表时加 key
2. 自定义事件、DOM 事件及时销毁
3. 合理使用异步组件，懒加载 lazy
4. 减少函数 bind this 次数
5. 合理使用 SCU 和 memo
6. 合理使用 Immutable,useImmer
7. SSR
8. useCallback 和 useMemo 缓存
9. Fragment 减少层级嵌套
10. 虚拟列表： React-virtualized 或者是 React-window 等包。
