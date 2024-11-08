# Vue

## Vue3 对比 vue2 的有哪方面的提升

1. 体积更小,代码组织更清晰，编译优化
2. 数据劫持方式:Vue2 Object.defineProperty vue3 Proxy，结合 Reflect 操作数据
3. 更好地支持 ts，SSR,tree-shaking
4. 组合式 API，Suspense，Fragment，Teleport
5. 虚拟 DOM 增加静态标记 patchFlag,事件缓存，对不参与更新的元素做静态提升，只创建一次，之后不停复用
6. 生命周期变了：beforeCreate,created 变成 setup，组合式 API

## vue2 和 vue3 生命周期

beforeCreate->setup
created->setup
beforeMount->onBeforeMounted
mounted->onMounted
beforeUpdate->onBeforeUpdate
updated->onUpdated
beforeDestroy->onBeforeUnmount
destroy->onUnmounted
activated->onActivited
deactivated->onDeactivated
errorCaptured->onErrorCaptured
renderTracked->onRenderTracked
renderTriggered->onRenderTrigger

# vue的diff算法

1.删除子节点
从头部开始同步，patch相同的
遇到不同的后，再从尾部开始同步，确认改变的节点

## v-if 与 v-show 优先级

v-if>v-show

## v-if 在 vue2 和 vue3 中的不同

vue2 中 v-for 优先级高于 v-if

vue3 中 v-if 比 v-for 的优先级更高，需要一起使用时可采用 template 包裹，尽量用 data.filter 后结果

## vue2，vue3 的数据劫持有什么不同

Vue2 Object.defineProperty get 收集依赖，set 通知更新
vue3 Proxy 13 中操作拦截，结合 Reflect 操作数据

## v-for 中 key 的作用

diff 算法对比 key 和 tag 相同则该节点没有改变

## vue2 的数组和对象不更新怎么处理

Vue.$set,$delete//给新属性添加响应式

## vue2 和 vue3 diff 算法工作流程

1. Vue2 diff 算法：遍历所有结点，导致 vnode 的更新新能跟模板大小正相关，跟动态结点的数量无关。当一些组件的整个模板内只有少量动态节点是，这些遍历就是浪费性能。
2. Vue3 将 vnode 的更新性能由于模板整体大小相关提升为与动态内容的数量相关。

## vue style scoped防止样式污染原理

<https://mp.weixin.qq.com/s?__biz=MzkzMzYzNzMzMQ==&mid=2247485249&idx=1&sn=7c573086fc3e7994eac295666908d18e&scene=21#wechat_redirect>

<https://mp.weixin.qq.com/s/HXLfl0ChI4pB2S7TuxVYeA>

1. 首先在编译时会根据当前vue文件的路径进行加密算法生成一个id，这个id就是自定义属性data-v-x中的x。

2. 然后给编译后的vue组件对象增加一个属性__scopeId，属性值就是data-v-x。

3. 在运行时的renderComponentRoot函数中，这个函数接收的参数是vue实例instance对象，instance.type的值就是编译后的vue组件对象。

4. 在renderComponentRoot函数中会执行setCurrentRenderingInstance函数，将全局变量currentScopeId的值赋值为instance.type.__scopeId，也就是data-v-x。

5. 在renderComponentRoot函数中接着会执行render函数，在生成虚拟DOM的过程中会去读取全局变量currentScopeId，并且将其赋值给虚拟DOM的scopeId属性。

6. 接着就是拿到render函数生成的虚拟DOM去执行patch函数生成真实DOM，在我们这个场景中最终生成真实DOM的是mountElement函数。

7. 在mountElement函数中首先会调用document.createElement函数去生成一个div标签，然后使用textContent属性将div标签的文本节点设置为hello world。

8. 最后就是调用setAttribute方法给div标签设置自定义属性data-v-x。

## Vue 通信方式

1. 父子组件 props 和 emit
2. EventBus
3. Vuex,pinia
4. $parent,$children,$ref，expose
5. $attrs/$listeners
6. provide/inject

## Vue 与 React 的对比

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

## keep-alive 的作用和原理

包裹一层缓存函数，根据传入的组件名，没有缓存就创建新的，有缓存就将缓存组件激活，别的组件时 deactived

## vue3 的组合式 API 与 React 的 Hooks 有什么不同

1. react hooks 有严格调用顺序，不可写在条件判断中，依靠依赖数组收集响应。需要用 useMemo(缓存函数计算结果),useCallback（缓存事件调用函数） 来缓存.可能会出现变量闭包不好追踪的问题
2. vue 的组合式 API 不限制调用顺序，可有条件调用，自动收集依赖，无需手动缓存

## vue 的性能优化

<https://cn.vuejs.org/guide/best-practices/performance.html>

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

## vue 和 react 的 diff 算法有什么不同

1.react 新旧节点对比，缓存要更新的节点，再批量更新
2.vue 只对比动态节点，边对比边更新

## watch 与 watchEffect 区别

watchEffect 自动检测依赖，watch 手动设置依赖

## ref 与 reactive 区别

ref:基本类型
reactive：对象类型
ref.value 和和 reactive 最终都会执行 createReactiveObject

# Vue源码解读

[Vue技术内幕](#/books/vue3.md)
