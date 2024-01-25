# 拉钩教育 React面试题

## 1.你如何理解React
1. 讲概念，一句话描述
2. 理思路，运作流程
3. 列优缺点
4. 说用途

React是一个网页UI框架，通过组件化的方式解决视图层开发复用的问题，本质是一个组件化的框架。
核心设计思路有三点：声明式，组件化，通用性
声明式的优势在于直观和组合
组件化的优势在于视图的拆分和模块的复用，可以更容易做到高内聚低耦合
通用性在于一次学习，随处编写，如React Native,React 360,这主要依靠虚拟DOM来保证实现。
适用范围足够广泛，web,Native,VR,都可开发
缺点是没有提供完整的解决方案，大型前端应用开发时，需要想社区寻找整合方案。一定程度促进社区繁荣，也在技术选型和学习使用上提高了成本。

**承接：**
- 谈一下React的优化和对虚拟DOM的看法
- 自己主导过的React项目
- React的相关工程架构与设计模式

## 2.为什么React要用JSX？
转换：为什么不用A,B，C?对比
>技术广度
深挖知识面涉猎广度
对流行框架的模板方案是否知悉了解

>技术方案的调研能力


1. 一句话解释JSX
2. 核心概念
3. 方案 对比


1. JSX是一个js的语法扩展，或者说是一个类似XML的ES语法扩展
2. React本身不强制使用JSX,React.createElement，通过babel转化虚拟DOM树
XML在树结构的描述上天生具有可读性强的优势

关注点分离：将代码风格为不同部分的设计原则是面向对象的程序设计的核心概念
价值在于程序的开发和维护，当关注点分开时，各部分可以重复使用，以及独立开发和更新。具有特殊价值的是能够稍微改进或修改一段代码，而无须知晓其他部分细节，无须对这些部分进行相应的更改


模板：弱化关注点分离，引入概念过多
模板 字符串：结构描述复杂，语法提示差
JXSON：语法提示差


React代码更简洁，更具可读性，更贴近HTML


Babel插件如何实现JSX到JS的编译
AST->createElement


## 3.如何避免生命周期中的坑

转换：你踩过多少坑？X   为什么会有坑？

- 在不恰当的实际调用量不合适的代码
- 在需要调用时，却忘记调用


1. 基于周期的梳理：确认生命周期函数的使用方式
2. 基于职责的梳理：确认生命周期函数的适用范围


建立时机与操作的对应关系

生命周期：周期梳理（挂载，更新，卸载），职责梳理（状态变更，错误处理）
```jsx
class Counter extends React.Component{
constructor(props){
super(props);
this.state={
count:0
}
this.handleClick=this.handleClick.bind(this);
}
handleClick(){
}
render(){
return <div>hello world</div>
}
}

class Counter extends React.Component{
state={
count:0
}
handleClick=()=>{

}
render(){
return <div>hello world</div>
}
}
```
**去除constructor的原因**
- 不推荐去处理初始化以外的逻辑
- 不属于生命周期，只是class的初始化函数
- 移除后代码会变得更加简洁


getDerivedStateFromProps：使组件在props变化时更新state.发生时机：props被传入，state发生变化，forceUpdate被调用

componentWillMount：组件加载前要做的操作（弃用），一步渲染机制下，可能会被多次调用

render：返回jsx结构，描述具体渲染内容
componentDidMount:加载完成时

**更新阶段：**
props传入或state发生变化
1. componentWillReceiveProps（弃用）
2. getDerivedStateFromProps
3. shouldComponentUpdate
```js
shouldComponentUpdate(nextProps,nextState){
if(shadowEqual(nextProps,this.props)||shadowEqual(nextState,this.state)){
return true
} 
return false
 
}
```
4. componentWillUpdate(弃用)
5. Render
6. getSnapshotBeforeUpdate
7. componentDidUpdate(preProps,preState,snapshot)

**卸载阶段**
1. componentWillUnmount:清理工作，解除事件绑定，清除定时器

**什么情况下会触发重新渲染**

1. 函数组件，React.memo(function MyFC(){})
2. 不实现shouldComponentUpdate函数，有两种情况发生重新渲染，state发生变化，父级 组件props传入
3. PureComponent ，默认实现shouldComponent函数，仅在props和state进行浅比较


渲染中发生报错该如何处理
错误边界，
```jsx
componentDidCatch(error,errorInfo){

}
render(){
if(this.state.hasError){
return <h1>Error</h1>
}
return this.props.children
}
```

**React请求应该放在哪里**

异步请求放在componentDidMount中
不推荐constructor,componentWillMount


## 4.类组件和函数组件有什么区别
1. 对组件的两种编写模式是否了解
2. 合适场景使用合适技术栈

1. 组件使用方式和表达效果总结相同点
2. 代码实现、独有特效、具体场景等细分领域描述不同点

共同点：实际用途一样，高阶组件和异步组件都可作基础组件展示UI
不同点：
1. 本质代表两种不同设计思想和心智模式：类组件的根基是OOP，面向对象编程，根基是FP，函数式编程。函数组件相对于类组件更纯粹，简单，易测试
2. 在不使用recompose和hooks的情况下，需使用生命周期就类组件限定场景是固定的，在recompose和hooks加持下，类组件与函数组件的能力边界完全相同，都可使用类似生命周期的能力
3. 类组件可实现继承，函数组件缺少继承能力
4. 性能优化：类组件依靠shouldComponentUpdate阻断渲染，函数组件依靠React.memo(允许你的组件在 props 没有改变的情况下跳过重新渲染。)
5. 函数组件是主推方案
类组件问题：this指向模糊，业务逻辑散落在生命周期，复用性差


## 5.如何设计React组件
场景设计分类

1. 只展示、独立运行、不额外增加功能的组件，称为哑组件或无状态组件、展示组件，复用性更强。样式布局，
2. 把处理业务逻辑与数据状态的组件称为有状态组件、灵巧组件，专注于业务本身。功能服用，业务逻辑

代理组件的设计模式，可以替换组件库
样式组件，布局组件，容器组件，

- 高阶组件：复用组件，抽取公共逻辑，参数是组件，返回新组件的函数
- 装饰器
- 链式调用
- 渲染劫持：通过控制render函数修改输出内容，场景场景是显示加载元素
```
render(){
if(this.props.isLoading){
return <Loading/>
}else{
return super.render()
}

}
```
缺陷：refs不能透传（forwardRef），static静态函数不能调用（constructor赋值hoist-non-react-statics）

目录：basic,container,hoc

如何在渲染劫持中位原本的渲染结果添加新的样式

## 6.setState是同步更新还是异步更新
根据场景回答

setState变更状态，触发组件渲染，更新视图UI



```jsx
//异步：
class AAA extends React.Component{
state={
count:0}
componentDidMount(){
this.setState({count:1},()=>{
console.log(this.state.count)//1
})
console.log(this.state.count)//0
}
}

//异步：
class AAA extends React.Component{
state={
count:0}
componentDidMount(){
this.setState({count:this.state.count+1},()=>{
console.log(this.state.count)//1
})
this.setState({count:this.state.count+1},()=>{
console.log(this.state.count)//1
})
console.log(this.state.count)//0
}
}
//异步：
class AAA extends React.Component{
state={
count:0}
componentDidMount(){
this.setState(preState=>({
 count:preState.count+1
}),()=>{
console.log(this.state.count)//1
})
this.setState(preState=>({
 count:preState.count+1
}),()=>{
console.log(this.state.count)//2
})
console.log(this.state.count)//0
}
}


//同步
class AAA extends React.Component{
state={
count:0}
componentDidMount(){
this.setState({count:this.state.count+1} )
console.log(this.state.count)//0
setTimeout(()=>{
this.setState({count:this.state.count+1} )
console.log(this.state.count)//1
},0)


}

```
React的setState执行模拟一个队列，根据队列逐一执行，合并state数据完成后执行回调，根据结果更新虚拟DOM,触发渲染

setState异步：保持内部的一致性，架构升级启用并发更新

合成事件：父级代理全部子级，事件委托，事件冒泡，挂载在渲染节点

this.setState(newState)=>newState存入pending队列，是否处于batch Update?=>是保存在dirtyComponents中，否便利所有dirtyComponents，调用updateComponent更新pending state 或props

生命周期和合成事件中，可拿到isBatchingUpdates控制权，将状态放入队列，控制执行节奏

同步：原生事件，addEventListener,setTimeout,setInterval

## 7.如何面向组件跨层级通信？
一个基本多个场景

关系
- 父向子：props
- 子向父：refs的回调函数
- 兄弟：通过父组件协调周转
- 无直接关系：Context，全局变量，全局事件，状态管理框架（redux,flux)


## 8.React状态管理框架
Context存储变量难以追溯数据源以及确认变动点

view视图层，代码中的React组件
store数据层，维护数据和数据处理的逻辑
dispatcher管理数据流动的中央枢纽
action事件通知，通常用type标记



Flux:提供MVC以外的成功实践，单项数据流(解决数据流向复杂不清的问题)

action->dispatcher->store->view
view->action->dispatcher->store

Redux:
>elm:  model-render->view-message->update->model
>全局单一数据源，纯函数，静态类型

- 全局单一数据源:整个应用的state被存储在一棵object tree中，只存在唯一一个store
- 纯函数Reducer：描述action如何改变状态数，编写一个纯函数reducer
- state是只读的：唯一可改变state的方法是触发action。action用于描述已发生事件的普通对象

事件回溯

**如何解决副作用**
与外界交互称为副作用，如Ajax请求

redux受函数式编程影响，导致
1.所有事件都收拢action去触发
2.所有UI状态都交给store去管理
3.所有业务逻辑都交由reducer去处理

解决方案：
1.在dispatch时有middleware中间层拦截分发的action，添加额外行为，可添加副作用,redux-thunk(处理异步action),react-loop(分形架构)，rematch(模块更内聚，插件更丰富)，dva

2.运行reducer层直接处理副作用

Mobx:Object.defineProperty,Proxy数据劫持

## 9.虚拟DOM的工作原理

简化前端开发，防止XSS攻击，通过虚拟DOM规避风险

**讲概念**

```js
{tag:'div',
    props:{
        
    },
        children:[]
}
```

React diff函数计算状态变更前后的虚拟DOM树差异，渲染函数来渲染整个虚拟DOM树或者处理差异点



**说用途**

**理思路**

**列优缺点**:

优点

（优势边界）

- 性能优越：大量网页DOM操作，

- 规避XSS：虚拟DOM确保字符转义，留有dangerousSetInnerHTML API绕过转义

- 可跨平台：NativeScript没有虚拟DOM,通过提供兼容原生API的JS API实现跨平台开发，虚拟DOM跨平台的成本更低

缺点

- 内存占用更高
- 无法进行极致优化，高性能应用

**核心问题：为什么流行**

## 10.与其他框架相比，React的diff算法有什么不同？

先分类再讲述

diff算法，虚拟DOM发生变化后，生成DOM树更新补丁的方式



新旧DOM对比差异->差异DOM->更新真实DOM->视图更新



1.  真实的DOM映射为虚拟DOM
2.  当虚拟DOM发生变化后，根据差异计算生成patch,patch是结构化的数据，包含增删改等
3. 根据patch更新真实DOM,反馈到用户界面上

更新时机：触发更新，进行差异对比的时机

遍历算法：深度优先遍历（保证生命周期时序正确），复杂度O(n^3)，采用分而治之,降为O(n)。

树，组件，元素分开比对

1. 忽略节点跨层级操作场景，提升比对效率。

   需进行树比对，对数进行分层比较，两棵树只对同一层节点进行比较，如果发现节点不存在，则该节点及其子节点会被完全删除，不会进一步比较

2. 如果组件的class一致，则默认为相似的树结构，否则默认为不同的树结构

   如果组件是同一类型则进行树比对，如果不是则直接放入补丁中

3. 同意层级节点，可通过key的方式进行列表对比

   元素比对主要发生在同层级中，通过标记节点的 操作生成补丁，节点操作包括插入、移动、删除等

   通过标记key的方式，React可直接移动DOM节点，降低内耗

4. Fiber机制下节点与树分别采用FiberNode与FiberTree结构，双链表，轻易获取兄弟节点
   整个更新过程由current和workInProgress两株树双缓冲完成，,workInProgress跟新完，修改current指针，直接指向新节点
   

事件切片能力，可中断更新

**Preact:**
类React框架

3kb大小，在diff算法上做了裁剪
Fragment，Component，DOM Node(真实DOM直接更新)


**Vue**
Vue2，使用了snabbdom,整体思路与React相同，但在元素对比是，如果新旧元素是同一个元素，且没有设置key时，snabbdom在diff子元素中会一次性对比新旧节点及他们的守卫元素，以及验证列表是否有变化



**优化**
1. 根据diff算法的设计原色，尽量避免跨层级的节点移动
2. 通过设置唯一key进行优化，尽量减少组件层级深度（深度遍历会带来性能问题）
3. 设置shouldComponentUpdate或者purComponent减少diff次数

## 11.如何解释React的渲染流程
讲话有重点，层次有分明

主线串联

React渲染节点的挂载->React组件的生命周期->setState触发渲染更新->diff策略和patch方案

React源码中reconcilers(协调者)通过抽离公共函数与diff算法使声明式渲染、自定义组件state、生命周期方法和refs等特性实现跨平台工作



Stack Reconciler是React 15及以前的渲染方案，核心是以递归的方式逐级调度栈中子节点道父节点的渲染



Fiber Reconcilder是React 16及以后版本的渲染方案，核心是增量渲染，将渲染工作分割为多区块，将其分散到多个帧中执行（画布等高性能场景优化）



React渲染的整体策略是递归，并通过事务建立React与虚拟DOM的联系并完成调度



Fiber 协作式调度，将渲染任务拆分成多段，每次只执行一段，完成后把事件控制权交还给主线程，tag标志优先级，优先级插入

特点：基于循环遍历计算diff，协作式多任务模式

**挂载阶段**

Render阶段通过构造workInProgress树计算出diff

commit阶段处理effect列表（包含根据diff更新DOM树，回调生命周期，响应ref等）



 ```js
//requestIdleCallback会在帧结束时并且有空闲时间。或者用户不与网页交互时，执行回调。
requestIdleCallback((deadline) => {
    // deadline.timeRemaining() 返回当前空闲时间的剩余时间
    if (deadline.timeRemaining() > 0) {
        task()
    }
}, {
    timeout: 500
})

 ```



## 12.React渲染异常会造成生命后果

错误边界：渲染异常会出现白屏

**是什么（现象，原理）**

如果有js错误出现在React内部渲染层就会导致整个应用的崩溃

**通用方案：**

getDerivedStateFromError与componentDidCatch获取错误边界信息并处理



渲染层，render中返回jsx都是在进行数据拼装和转换。拼装过程出错会直接编译失败，转换过程出错不易发现



工程化方案



预防：

1. 数据是否可靠，空安全。idx在使用时需配置babel插件在引入，然后通过idx函数包裹需要使用的object，再在回调函数中取需要的值。lodash.get，可选链操作符，可通过@babel/plugin-proposal-optional-chaining。typescript

兜底：

2. 给关键的组件添加错误边界。使用高阶组件，给组件添加错误边界

```jsx
//统一的错误界面
export const errorBoundary=(WrappedComponent=>{
return class Wrap extends Component{
    state={
hasError:false,
    err:''}
    static getDerivedStateFromError(err){
        return {
            hasError:true,
            err
        }
    }
    componentDidCatch(err:Error,info:React.ErrorInfo){
        console.log(err,info);
    }
    render(){
return this.state.hasError?<ErrorDefaultUI error={this.state.err} />:<WrappedComponent {...this.props} />
    }
}
})
```

 

量化成果：埋点统计，线上报警

## 13.如何分析和调优性能瓶颈

一个完整的解决方案：说清楚标准，讲清楚缘由，理清楚过程，算清楚结果，最后用数据和收益来说明的你的工作成果





分析调优：

- 建立衡量标准（指标和采集）
- 确认优化原因
- 实施方案过程
- 计算收益结果（数据和效果）



**RAIL**

Response响应：应在50毫秒内完成时间处理并反馈给用户

Animation动画：10毫秒内生成一帧

Idle浏览器空闲时间：最大化利用浏览器空闲时间

Load加载：在5秒内完成页面资源加载且使页面可交互



根据场景制定性能标准

网页APM工具：New Relic,阿里云ARMS



采集过程：

- FCP首次回执内容的耗时
- TTI页面可交互时间
- Page Load页面完全加载时间
- FPS前端页面帧率，卡顿的情况，长列表渲染与重渲染
- 静态资源及API请求成功率





优化要根据制定目标而定

- FCP:loading图标和骨架图，SSR(next.js)
- TTI:核心内容使用同步加载，非核心内容采用异步加载的方式延迟加载，图片采用懒加载避免网络资源占用
- Page Load:异步加载，webpack打包common chunk与异步组件
- FPS:
- 静态资源及API请求成果率：直接从前端服务器拉取js与css资源还是从CDN拉取的。解析CDN与API域名存在失败情况，运营商对静态资源及API请求做了篡改=》静态资源尽量使用CDN，域名解析失败可采用静态资源域名自动切换的方案来直接寻求SRE的协助。运营商篡改使用https
- 技术服务于业务



## 14.如何避免重复渲染

长列表：虚拟滚动（react-virtualized react-window)



- 优化时机
- 定位方式：还原场景，场景复现，chrome的perfermance(查询js执行栈中耗时，确认函数卡顿点)，React Developer Tools的Profiler（分析组件渲染次数，开始时间及耗时）
- 常见坑：列表移动全部渲染（React.memo）,箭头函数可能会失效
- 处理方案 :缓存（reselect)，不可变数据(ImmutableJs,Immerjs),shouldComponentUpdate



## 15.如何提升React代码可维护性

代码修改和拓展



可分析性，可改变性，稳定性，易测试性，可维护的依从性



预防

- code review代码审查
- jsLint jsHint Eslint静态代码检查

兜底

- sourceMap反解析定位错误
- 单元测试：Chai，Mocha，Jest 

- js的Eslint,样式stylelint,代码提交commitlint,代码分割prettier,编辑器风格editorconfig

- 合理的架构划分，纯函数具有测试优势



## 16.Hook的使用限制有哪些

问题：

1. 组件之间难以复用状态逻辑（登录信息）
2. 复杂组件变得难以理解
3. 容易混淆类，this的问题，bind，类难以做编译优化



限制

- 会造成数组的取值错位，所以不能在React的循环、条件或嵌套函数中调用hook

- 只能在React的函数组件中调用hook



React组件采用的是链表，基于数组实现





防范：eslint引入eslint-plugin-react-hooks完成自动化检测

## 17.useEffect与useLayoutEffect区别在哪

useEffect与useLayoutEffect调用的是同一个函数,

useEffect=>mountEffect=>mountEffectImpl

useLayoutEffect=>mountLayoutEffect=>mountEffectImpl

Hooks链表在Fiber链表中依次执行：updateEffect,passiveEffect,passiveStaticEffect是Fiber标识

HookPassive和HookLayout是当前Effect的标识

标识为HookLayout的effect会在所有DOM变更之后同步调用，所以可以使用它来读取DOM布局并同步触发重渲染

**相同点**

- 使用方式：函数签名一致
- 运用效果:处理副作用，改变DOM,设置订阅，操作定时器

**不同点**

- 使用场景：大多数情况用useEffect,引起页面闪烁使用useLayoutEffect(操作DOM)
- 独有能力：effect异步处理副作用，layoutEffect同步处理副作用
- 设计原理：effect异步调用，LayoutEffect同步调用
- 未来趋势





## 18.React Hook的设计模式

```jsx
 function Counter(){
    const [count,setCount]=useState(0);
    const preCountRef=useRef();
    useEffect(()=>{
        //获取上一轮的值
        preCountRef.current=count
    })
    const preCount=preCurrentRef.current;
    return <h1>Now:{count},before:{preCount}</h1>
}

function usePrevious(value){
   const preCountRef=useRef();
    useEffect(()=>{
        //获取上一轮的值
        preCountRef.current=value
    })
    return preCurrentRef.current;
}
```



（1）开发理解成本增高

（2）hooks并不会改变组件本身的设计模式，class是生命周期，hook是事务角度



- useEffect与class组件生命周期

- React.memo与useMemo避免重复渲染
```jsx
function Banner(){
let appContext=useConntext(AppContext);
let theme=appContext.theme;
return React.useMemo(()=>{
return <Slider theme={theme} />
},[theme])

}
export default React.memo(Banner)
```

- 常量放置在函数组件外，内部变量计算使用useCallback缓存函数
- useEffect的依赖，是浅比较，尽量不用引用类型



外观模式：自定义hook抽离业务逻辑



## 19.React-Router的实现原理以及工作方式



实现原理

- 外部-基础原理：单页应用，通过js控制页面路由（hash路由实现模拟路由，history路由，H5 history pushState，replaceState修改历史记录条目，后台配置所有路由指向index.html，错误请求historyApiFallback）
- 内部-实现方案:react-router-dom基础路由是BrowserRouter。React-Router中路由通过抽象history库统一管理完成，history库支持BrowserHistory和MemoryHistory两种类型



工作方式

- 整体-设计模式：Monorepo(Lerna),Context完成数据共享
- 局部-关键模块：Context容器，分别是Router与MemoryRouter主要提供上下文消费容器。直接消费者提供路由匹配功能，分别是Route，Redirect，Switch。平台关联的功能组件，react-router-dom中的Link,navLink



##  React中常用工具库



**初始化**

create-react-app，拓展create-app-rewired，umi，dva

create-react-library，story-book大规模组建开发

**开发**

路由：react-router

样式：css模块化，import样式文件，css in Js方案（styled-component,emotion）

基础组件：antd

功能组件：react-dnd和react-draggable拖拽，video-react播放视频，react-pdf-viewer预览pdf,react-window和react-virtualized长列表虚拟滚动

状态管理：flux，redux，mobx

**构建**

webpack：大型前端项目，生态插件丰富，实践验证更完备

rollup：专注交付库而非大型工程，支持多种模块类型输出

vite,

esbuild:打包及压缩工具，性能足够钱，核心代码由go语言编写，相比传统js构建工具有10到100倍性能优势



**检查**

代码规范检查:eslint

代码测试：jest,enzyme,react-testing-library,react-hooks-testing-library

**发布**

自行手动上传静态资源文件到CDN,s3-plugin-webpack

