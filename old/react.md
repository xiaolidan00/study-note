https://vue3js.cn/interview/React/summary.html

# react 有什么特性

主要的特性分为：

- JSX 语法
- 单向数据绑定
- 虚拟 DOM
- 声明式编程
- Component

# 生命周期有哪些不同阶段？每个阶段对应的方法是？

**旧生命周期：**
挂载

- constructor
- componentWillMount
- render
- componentDidMount

更新

- componentWillReceiveProps
- shouldComponentUpdate
- componentWillUpdate
- render
- componentDidUpdate

卸载

- componentWillUnmount

**新生命周期**
挂载

- constructor
- getDerivedStateFromProps
- render
- componentDidMount

更新

- getDerivedStateFromProps
- shouldComponentUpdate
- render
- getSnapshotBeforeUpdate
- componentDidUpdate

卸载

- componentWillUnmount

1. React16 新的生命周期弃用了 componentWillMount、componentWillReceivePorps，componentWillUpdate
2. 新增了 getDerivedStateFromProps、getSnapshotBeforeUpdate 来代替弃用的三个钩子函数（componentWillMount、componentWillReceivePorps，componentWillUpdate）
3. React16 并没有删除这三个钩子函数，但是不能和新增的两个钩子函数（getDerivedStateFromProps、getSnapshotBeforeUpdate）混用。注意：React17 将会删除 componentWillMount、componentWillReceivePorps，componentWillUpdate
4. 新增了对错误处理的钩子函数（componentDidCatch）

# state 和 props 有什么区别？

两者相同点：

- 两者都是 JavaScript 对象
- 两者都是用于保存信息
- props 和 state 都能触发渲染更新
  区别：

- props 是外部传递给组件的，而 state 是在组件内被组件自己管理的，一般在 constructor 中初始化
- props 在组件内部是不可修改的，但 state 在组件内部可以进行修改
- state 是多变的、可以修改

# super()和 super(props)有什么区别？

在 React 中，类组件基于 ES6，所以在 constructor 中必须使用 super

在调用 super 过程，无论是否传入 props，React 内部都会将 porps 赋值给组件实例 porps 属性中

如果只调用了 super()，那么 this.props 在 super()和构造函数结束之间仍是 undefined

# setState 执行机制？

在 react 类组件的状态需要通过 setState 进行更改，在不同场景下对应不同的执行顺序：

- 在组件生命周期或 React 合成事件中，setState 是异步
- 在 setTimeout 或者原生 dom 事件中，setState 是同步
- 当我们批量更改 state 的值的时候，react 内部会将其进行覆盖，只取最后一次的执行结果
-
- 当需要下一个 state 依赖当前 state 的时候，则可以在 setState 中传递一个回调函数进行下次更新

# React 的事件机制？

React 基于浏览器的事件机制自身实现了一套事件机制，包括事件注册、事件的合成、事件冒泡、事件派发等

组件注册的事件最终会绑定在 document 这个 DOM 上，而不是 React 组件对应的 DOM，从而节省内存开销

自身实现了一套事件冒泡机制，阻止不同时间段的冒泡行为，需要对应使用不同的方法

# 事件绑定的方式有哪些？

react 常见的绑定方式有如下：

- render 方法中使用 bind
- render 方法中使用箭头函数
- constructor 中 bind
- 定义阶段使用箭头函数绑定
  前两种方式在每次组件 render 的时候都会生成新的方法实例，性能问题欠缺

# 构建组件的方式有哪些？区别？

组件的创建主要分成了三种方式：

函数式创建

- 继承 React.Component 创建
- 通过 React.createClass 方法创建

如今一般都是前两种方式，

对于一些无状态的组件创建，建议使用函数式创建的方式，

hooks 的机制下，函数式组件能做类组件对应的事情，所以建议都使用函数式的方式来创建组件

# 组件之间如何通信？

组件间通信可以通过 props、传递回调函数、context、redux 等形式进行组件之间通讯

# key 有什么作用？

使用 key 是 react 性能优化的手段，在一系列数据最前面插入元素，如果没有 key 的值，则所有的元素都需要进行更换，而有 key 的情况只需要将最新元素插入到前面，不涉及删除操作

在使用 key 的时候应保证：

- key 应该是唯一的
- key 不要使用随机值（随机数在下一次 render 时，会重新生成一个数字）
- 避免使用 index 作为 key

# refs 的理解？应用场景？

Refs 允许我们访问 DOM 节点或在 render 方法中创建的 React 元素

下面的场景使用 refs 非常有用：

- 对 Dom 元素的焦点控制、内容选择、控制
- 对 Dom 元素的内容设置及媒体播放
- 对 Dom 元素的操作和对组件实例的操作
- 集成第三方 DOM 库

# Hooks 的理解？解决了什么问题？

Hook 是 React 16.8 的新增特性。它可以让你在不编写 class 的情况下使用 state 以及其他的 React 特性

解决问题如下：

难以重用和共享组件中的与状态相关的逻辑
逻辑复杂的组件难以开发与维护，当我们的组件需要处理多个互不相关的 local state 时，每个生命周期函数中可能会包含着各种互不相关的逻辑在里面
类组件中的 this 增加学习成本，类组件在基于现有工具的优化上存在些许问题
由于业务变动，函数组件不得不改为类组件等等

# 如何引入 css？

常见的 CSS 引入方式有以下：

在组件内直接使用

- 组件中引入 .css 文件
- 组件中引入 .module.css 文件
- CSS in JS
- 组件内直接使用 css 会导致大量的代码，而文件中直接引入 css 文件是全局作用域，发生层叠

- 引入.module.css 文件能够解决局部作用域问题，但是不方便动态修改样式，需要使用内联的方式进行样式的编写

- css in js 这种方法，可以满足大部分场景的应用，可以类似于预处理器一样样式嵌套、定义、修改状态等

# redux 工作原理？

redux 要求我们把数据都放在 store 公共存储空间

一个组件改变了 store 里的数据内容，其他组件就能感知到 store 的变化，再来取数据，从而间接的实现了这些数据传递的功能

工作流程图如下所示：

# redux 中间件有哪些？

市面上有很多优秀的 redux 中间件，如：

- redux-thunk：用于异步操作
- redux-logger：用于日志记录

# react-router 组件有哪些？

常见的组件有：

- BrowserRouter、HashRouter
- Route
- Link、NavLink
- switch
- redirect

# render 触发时机？

在 React 中，类组件只要执行了 setState 方法，就一定会触发 render 函数执行

函数组件 useState 会判断当前值有无发生改变确定是否执行 render 方法，一旦父组件发生渲染，子组件也会渲染

# 如何减少 render？

父组件渲染导致子组件渲染，子组件并没有发生任何改变，这时候就可以从避免无谓的渲染，具体实现的方式有如下：

shouldComponentUpdate
PureComponent
React.memo

# JSX 转化 DOM 过程？

jsx 首先会转化成 React.createElement 这种形式，React.createElement 作用是生成一个虚拟 Dom 对象，然后会通过 ReactDOM.render 进行渲染成真实 DOM

# 性能优化手段有哪些

除了减少 render 的渲染之外，还可以通过以下手段进行优化：

除此之外， 常见性能优化常见的手段有如下：

- 避免使用内联函数
- 使用 React Fragments 避免额外标记
- 使用 Immutable
- 懒加载组件
- 事件绑定方式
- 服务端渲染

# 如何做服务端渲染？

node server 接收客户端请求，得到当前的请求 url 路径，然后在已有的路由表内查找到对应的组件，拿到需要请求的数据，将数据作为 props、context 或者 store 形式传入组件

然后基于 react 内置的服务端渲染方法 renderToString()把组件渲染为 html 字符串在把最终的 html 进行输出前需要将数据注入到浏览器端

浏览器开始进行渲染和节点对比，然后执行完成组件内事件绑定和一些交互，浏览器重用了服务端输出的 html 节点，整个流程结束

1. 服务器端运行 react 代码生成 html
2. 发送 html 浏览器
3. 浏览器接收到显示内容
4. 浏览器加载 js
5. js 代码执行并接管页面操作

# react diff 原理

diff（翻译差异）：计算一棵树形结构转换成另一棵树形结构的最少操作

1）把树形结构按照层级分解，只比较同级元素

2）给列表结构的每个单元添加唯一的 key 属性，方便比较

3）React 只会匹配相同 class 的 component（这里面的 class 指的是组件的名字）

4）合并操作，调用 component 的 setState 方法的时候, React 将其标记为 dirty.到每一个事件循环结束, React 检查所有标记 dirty 的 component 重新绘制

5）选择性子树渲染。开发人员可以重写 shouldComponentUpdate 提高 diff 的性能

# redux

redux 是一个应用数据流框架，主要是解决了组件间状态共享的问题，原理是集中式管理，主要有三个核心方法，action，store，reducer

## 三大原则：

1）唯一数据源(整个应用的 state 被储存在一棵 object tree 中，并且这个 object tree 只存在于唯一一个 store 中)

2）reducer 必须是纯函数（输入必须对应着唯一的输出）

3）State 是只读的, 想要更改必须经过派发 action

## redux 的工作流程：

使用通过 reducer 创建出来的 Store 发起一个 Action，reducer 会执行相应的更新 state 的方法，当 state 更新之后，view 会根据 state 做出相应的变化

1）提供 getState()获取到 state

2）通过 dispatch(action)发起 action 更新 state

3）通过 subscribe()注册监听器

## redux 数据流通的过程

1）用户操作视图

2）发起一次 dispatch。有异步：返回一个函数（使用 thunk 中间件），没有异步：return {}

3）进入 reducer,通过对应的 type 去修改 state,最后返回一个新的 state

## connect()前两个参数是什么？

mapStateToProps(state, ownProps)

允许我们将 store 中的数据作为 props 绑定到组件中，只要 store 更新了就会调用 mapStateToProps 方法，mapStateToProps 返回的结果必须是 object 对象，该对象中的值将会更新到组件中

mapDispatchToProps(dispatch, [ownProps])

允许我们将 action 作为 props 绑定到组件中，如果不传这个参数 redux 会把 dispatch 作为属性注入给组件，可以手动当做 store.dispatch 使用

mapDispatchToProps 希望你返回包含对应 action 的 object 对象

## redux 本身有什么不足？

1）向事件池中追加方法时，没有做去重处理

2）把绑定的方从在事件池中移除掉时，用的是 arr.splice(index,1)，这样可能会引起数组塌陷

3）reducer 中 state，每次返回都需要深克隆，可以在 redux 中获取状态信息时，深克隆，这样就不用在 reducer 里深克隆了

## 你怎么理解 redux 的 state 的

数据按照领域（Domain）分类，存储在不同的表中，不同的表中存储的列数据不能重复

表中每一列的数据都依赖于这张表的主键，表中除了主键以外的其他列，互相之间不能有直接依赖关系

把整个应用的状态按照领域（Domain）分成若干子 State，子 State 之间不能保存重复的数据

State 以键值对的结构存储数据，以记录的 key/ID 作为记录的索引，记录中的其他字段都依赖于索引

State 中不能保存可以通过已有数据计算而来的数据，即 State 中的字段不互相依赖

React,redux 可以运行在服务端吗?有什么优势

- 利于 SEO
- 提高首屏渲染速度
- 同构直出，使用同一份 JS 代码实现，便于开发和维护

## 列出 Redux 的组件

1）Action – 这是一个用来描述发生了什么事情的对象

2）Reducer – 这是一个确定状态将如何变化的地方

3）Store – 整个程序的状态/对象树保存在 Store 中

4）View – 只显示 Store 提供的数据

## 解释 Reducer 的作用

Reducers 是纯函数，它规定应用程序的状态怎样因响应 ACTION 而改变。Reducers 通过接受先前的状态和 action 来工作，然后它返回一个新的状态。它根据操作的类型确定需要执行哪种更新，然后返回新的值。如果不需要完成任务，它会返回原来的状态

## Store 在 Redux 中的意义是什么？

Store 是一个 JavaScript 对象，它可以保存程序的状态，并提供一些方法来访问状态、调度操作和注册侦听器。应用程序的整个状态/对象树保存在单一存储中。因此，Redux 非常简单且是可预测的。我们可以将中间件传递到 store 处理数据，并记录改变存储状态的各种操作。所有操作都通过 reducer 返回一个新状态
