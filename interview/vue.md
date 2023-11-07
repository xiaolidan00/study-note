# vue 特性

- 数据驱动
- 组件化
- 指令系统

# vue2 与 vue3 数据劫持区别

vue2 使用的是 Object.defineProperty 的 get 和 set， 收集依赖， 通知更新

- configurable：数据可改变
- enumerable：可枚举
- value：属性值
- writable：可读写

vue3 基于 Proxy,有 13 中动作捕获器，监听动作更细致丰富，
对应 Reflect 的 13 种操作方法
Reflect.apply(target, thisArg, args)
Reflect.construct(target, args)
Reflect.get(target, name, receiver)
Reflect.set(target, name, value, receiver)
Reflect.defineProperty(target, name, desc)
Reflect.deleteProperty(target, name)
Reflect.has(target, name)
Reflect.ownKeys(target)
Reflect.isExtensible(target)
Reflect.preventExtensions(target)
Reflect.getOwnPropertyDescriptor(target, name)
Reflect.getPrototypeOf(target)
Reflect.setPrototypeOf(target, prototype)

# vue 与 react 对比

**相同点：**
组件化思想、虚拟 dom、数据驱动视图、支持服务器端渲染、钩子函数

**不同点：**

- 数据流向：react 单向数据流，数据不可变，vue 双向数据流绑定，数据可变
- 组件化通信：react 函数回调来通信，vue 有子组件向父组件发送事件和回调两种
- diff 算法：react 主要使用 diff 队列保存需要更新哪些 DOM，得到 patch 树，再统一操作批量更新 DOM。Vue 使用双向指针，边对比，边更新 DOM
- vue 有指令系统，computed，watch，react 只能用 jsx 语法
- vue 组件全局注册和局部注册，react 通过 import 来引用

# react 的 hooks 与 vue 的 hooks

1.react 的 hooks 有严格调用顺序，不可写在条件分支中,依靠准确的依赖数组，昂贵计算要 useMemo 来缓存。要用 useCallback 来避免子组件不必要的更新，变量闭包不好追踪
2.vue 的 hooks 无需担心变量闭包问题，组合式 API 不限制调用顺序，还能有条件调用。自动收集计算属性和侦听器的依赖，无需手动缓存回调函数来避免不必要的组件更新。

# vue3 新特性

性能的提升、组合式 API、友好支持 ts、Teleport 和 Suspense

# Vue 的生命周期

| Vue 2 中的生命周期钩子 | Vue 3 选项式 API 的生命周期选项 | Vue 3 组合 API 中生命周期钩子 | 描述                                                  |
| ---------------------- | ------------------------------- | ----------------------------- | ----------------------------------------------------- |
| beforeCreate           | beforeCreate                    | setup()                       | 创建前，此时 data 和 methods 的数据都还没有初始化     |
| created                | created                         | setup()                       | 创建后，data 中有值，尚未挂载，可以进行一些 Ajax 请求 |
| beforeMount            | beforeMount                     | onBeforeMount                 | 挂载前，会找到虚拟 DOM，编译成 Render                 |
| mounted                | mounted                         | onMounted                     | 挂载后，DOM 已创建，可用于获取访问数据和 DOM 元素     |
| beforeUpdate           | beforeUpdate                    | onBeforeUpdate                | 更新前，可用于获取更新前各种状态                      |
| updated                | updated                         | onUpdated                     | 更新后，所有状态已是最新                              |
| beforeDestroy          | beforeUnmount                   | onBeforeUnmount               | 销毁前，可用于一些定时器或订阅的取消                  |
| destroyed              | unmounted                       | onUnmounted                   | 销毁后，可用于一些定时器或订阅的取消                  |
| activated              | activated                       | onActivated                   | keep-alive 缓存的组件激活时                           |
| deactivated            | deactivated                     | onDeactivated                 | keep-alive 缓存的组件停用时                           |
| errorCaptured          | errorCaptured                   | onErrorCaptured               | 捕获一个来自子孙组件的错误时调用                      |
| —                      | renderTracked                   | onRenderTracked               | 调试钩子，响应式依赖被收集时调用                      |
| —                      | renderTriggered                 | onRenderTriggered             | 调试钩子，响应式依赖被触发时调用                      |
| —                      | serverPrefetch                  | onServerPrefetch              | 组件实例在服务器上被渲染前调用                        |

**父子组件的生命周期**

- 加载渲染阶段：父 beforeCreate -> 父 created -> 父 beforeMount -> 子 beforeCreate -> 子 created -> 子 beforeMount -> 子 mounted -> 父 mounted
- 更新阶段：父 beforeUpdate -> 子 beforeUpdate -> 子 updated -> 父 updated
- 销毁阶段：父 beforeDestroy -> 子 beforeDestroy -> 子 destroyed -> 父 destroyed

# v-if 在 vue2 和 vue3 中区别

vue2 中 v-for 优先级高于 v-if

vue3 中 v-if 比 v-for 的优先级更高，可采用 template 包裹，尽量用 filter 后结果

# Vue2 初始化流程

1. 合并配置
2. 初始化生命周期
3. 初始化事件
4. 初始化渲染
5. 调用 `beforeCreate` 钩子函数
6. 初始化注入和 reactivity（这个阶段属性都已注入绑定，而且被 `$watch` 变成 reactivity，但是 `$el` 还是没有生成，也就是 DOM 没有生成）
7. 初始化 state 状态（初始化了 data、props、computed、watcher）
8. 调用 created 钩子函数。

在初始化的最后，检测到如果有 el 属性，则调用 vm.$mount 方法挂载 vm，挂载的目标就是把模板渲染成最终的 DOM。

# Vue3 初始化流程

createApp() => mount() => render() => patch() => processComponent() => mountComponent()

1. Vue.createApp() 实际执行的是 renderer 的 createApp()

2. renderer 是 createRenderer 这个方法创建

3. renderer 的 createApp()是 createAppAPI()返回的

4. createAppApi 接受到 render 之后，创建一个 app 实例，定义 mount 方法

5. mount 会调用 render 函数。将 vnode 转换为真实 dom

createRenderer() => renderer => renderer.createApp() <= createAppApi()

# vue 实例挂载过程

1. new Vue 的时候调用会调用\_init 方法

- 定义 `$set、$get 、$delete、$watch` 等方法
- 定义 `$on、$off、$emit、$off` 等事件
- 定义 `_update、$forceUpdate、$destroy` 生命周期

1. 调用$mount 进行页面的挂载

2. 挂载的时候主要是通过 mountComponent 方法

3. 定义 updateComponent 更新函数

4. 执行 render 生成虚拟 DOM

5. `_update` 将虚拟 DOM 生成真实 DOM 结构，并且渲染到页面中

# Vue 双向绑定的原理

Vue2 双向绑定就是：数据变化更新视图，视图变化更新数据

vue2 的数据劫持有两个缺点:无法直接监听数组和对象值变化

**数据劫持和观察者模式**

数据劫持：object.defineproperty：只能遍历对象属性进行劫持

get
属性的 getter 函数，当访问该属性时，会调用此函数。执行时不传入任何参数，但是会传入 this 对象（由于继承关系，这里的 this 并不一定是定义该属性的对象）。该函数的返回值会被用作属性的值

set
属性的 setter 函数，当属性值被修改时，会调用此函数。该方法接受一个参数（也就是被赋予的新值），会传入赋值时的 this 对象。默认为 undefined

**vue3 使用了 proxy**

直接可以劫持整个对象，并返回一个新对象

proxy 优点：

1. 直接监听对象而非属性
2. 直接监听数组的变化
3. 拦截的方式有很多种(有 13 种，set,get,has)
4. Proxy 返回一个新对象，可以操作新对象达到目的

proxy 缺点：

1. proxy 有兼容性问题，不能用 polyfill 来兼容（polyfill 主要抚平不同浏览器之间对 js 实现的差异）

# mixin

- 替换型策略有 props、methods、inject、computed，就是将新的同名参数替代旧的参数
- 合并型策略是 data, 通过 set 方法进行合并和重新赋值
- 队列型策略有生命周期函数和 watch，原理是将函数存入一个数组，然后正序遍历依次执行
- 叠加型有 component、directives、filters，通过原型链进行层层的叠加

- 当组件存在与 mixin 对象相同的选项的时候，进行递归合并的时候组件的选项会覆盖 mixin 的选项

- 但是如果相同选项为生命周期钩子的时候，会合并成一个数组，先执行 mixin 的钩子，再执行组件的钩子

# filter

- 在编译阶段通过 parseFilters 将过滤器编译成函数调用（串联过滤器则是一个嵌套的函数调用，前一个过滤器执行的结果是后一个过滤器函数的参数）
- 编译后通过调用 resolveFilter 函数找到对应过滤器并返回结果
- 执行结果作为参数传递给 toString 函数，而 toString 执行后，其结果会保存在 Vnode 的 text 属性中，渲染到视图

# diff 算法

- 比较只会在同层级进行, 不会跨层级比较
- 在 diff 比较的过程中，循环从两边向中间比较

# vue3 性能提升原因

- diff 方法优化：Vue2.x 中的虚拟 dom 是进行全量的对比。Vue3.0 中新增了静态标记（PatchFlag），hoistStatic 静态提升
- Vue2.x : 无论元素是否参与更新，每次都会重新创建。
- Vue3.0 : 对不参与更新的元素，只会被创建一次，之后会在每次渲染时候被不停的复用。cacheHandlers 事件侦听器缓存

- 代码层面性能优化主要体现在全新响应式 API，基于 Proxy 实现，初始化时间和内存占用均大幅改进；
- 编译层面做了更多编译优化处理，比如静态标记 pachFlag（diff 算法增加了一个静态标记，只对比有标记的 dom 元素）、事件增加缓存、静态提升（对不参与更新的元素，会做静态提升，只会被创建一次，之后会在每次渲染时候被不停的复用）等，可以有效跳过大量 diff 过程；
- 打包时更好的支持 tree-shaking，因此整体体积更小，加载更快
- ssr 渲染以字符串方式渲染

# Vuex action 和 mutation 的区别

- action 中处理异步，mutation 不可以
- mutation 做原子操作
- action 可以整合多个 mutation 的集合
- mutation 是同步更新数据(内部会进行是否为异步方式更新数据的检测) $watch 严格模式下会报错
- action 异步操作，可以获取数据后调佣 mutation 提交最终数据
- 流程顺序：“相应视图—>修改 State”拆分成两部分，视图触发 Action，Action 再触发 Mutation`。
- 基于流程顺序，二者扮演不同的角色：Mutation：专注于修改 State，理论上是修改 State 的唯一途径。Action：业务代码、异步请求
- 角色不同，二者有不同的限制：Mutation：必须同步执行。Action：可以异步，但不能直接操作 State

# Vue-router

## hash 模式与 history 模式

**Hash 模式**

基于浏览器的 hashchange 事件，地址变化时，通过 window.location.hash 获取地址上的 hash 值；并通过构造 Router 类，配置 routes 对象设置 hash 值与对应的组件内容。

**History 模式**

基于 HTML5 新增的 pushState()和 replaceState()两个 api，以及浏览器的 popstate 事件，地址变化时，通过 window.location.pathname 找到对应的组件。并通过构造 Router 类，配置 routes 对象设置 pathname 值与对应的组件内容。

# Vue 路由钩子在生命周期函数的体现

**路由导航解析流程**

1. 触发进入其他路由。
2. 调用要离开路由的组件守卫 beforeRouteLeave
3. 调用局前置守卫 ∶ beforeEach
4. 在重用的组件里调用 beforeRouteUpdate
5. 调用路由独享守卫 beforeEnter。
6. 解析异步路由组件。
7. 在将要进入的路由组件中调用 beforeRouteEnter
8. 调用全局解析守卫 beforeResolve
9. 导航被确认。
10. 调用全局后置钩子的 afterEach 钩子。
11. 触发 DOM 更新（mounted）。
12. 执行 beforeRouteEnter 守卫中传给 next 的回调函数

**触发钩子**

路由导航、keep-alive、和组件生命周期钩子结合起来的，触发顺序，假设是从 a 组件离开，第一次进入 b 组件 ∶

1. beforeRouteLeave：路由组件的组件离开路由前钩子，可取消路由离开。
2. beforeEach：路由全局前置守卫，可用于登录验证、全局路由 loading 等。
3. beforeEnter：路由独享守卫
4. beforeRouteEnter：路由组件的组件进入路由前钩子。
5. beforeResolve：路由全局解析守卫
6. afterEach：路由全局后置钩子
7. beforeCreate：组件生命周期，不能访问 tAis。
8. created;组件生命周期，可以访问 tAis，不能访问 dom。
9. beforeMount：组件生命周期
10. deactivated：离开缓存组件 a，或者触发 a 的 beforeDestroy 和 destroyed 组件销毁钩子。
11. mounted：访问/操作 dom。
12. activated：进入缓存组件，进入 a 的嵌套子组件（如果有的话）。
13. 执行 beforeRouteEnter 回调函数 next。

**导航行为被触发到导航完成的整个过程**

1. 导航行为被触发，此时导航未被确认。
2. 在失活的组件里调用离开守卫 beforeRouteLeave。
3. 调用全局的 beforeEach 守卫。
4. 在重用的组件里调用 beforeRouteUpdate 守卫(2.2+)。
5. 在路由配置里调用 beforeEnter。
6. 解析异步路由组件（如果有）。
7. 在被激活的组件里调用 beforeRouteEnter。
8. 调用全局的 beforeResolve 守卫（2.5+），标示解析阶段完成。
9. 导航被确认。
10. 调用全局的 afterEach 钩子。
11. 非重用组件，开始组件实例的生命周期：beforeCreate&created、beforeMount&mounted
12. 触发 DOM 更新。
13. 用创建好的实例调用 beforeRouteEnter 守卫中传给 next 的回调函数。
14. 导航完成

# 列表组件中写 key

vue 和 react 都是采用 diff 算法来对比新旧虚拟节点，从而更新节点。map,find 把树形结构按照层级分解，只比较同级元素，给列表结构的 每个单元添加唯一的 key 值，方便比较

# 虚拟 dom

在 js 和真实 dom 中间加了一个缓存 避免没必要的 dom 操作

1. 用 JavaScript 对象结构表示 DOM 树的结构；然后用这个树构建一个真正的 DOM 树，插到文档当中
2. 当状态变更的时候，重新构造一棵新的对象树。然后用新的树和旧的树进行比较，记录两棵树差异
3. 把 2 所记录的差异应用到步骤 1 所构建的真正的 DOM 树上，视图就更新了。

# 组件通信

- props/emit
- $children
- $refs（vue3 中要 expose 暴露属性）
- $parent
- `$attrs/$listeners`
- Vuex
- EventBus
- provide / inject
