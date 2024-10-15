# React

## React 生命周期

```txt
React 16
挂载：
constructor->(getDerivedStateFromProps)->render->componentDidMount
更新：
new Props,setState,forceUpdate->(getDerivedStateFromProps)->(shouldComponentUpdate)->render->(getSnapshotBeforeUpdate)->componentDidUpdate
卸载
componentWillUnmount
```

## React合成事件与Js原生事件有什么区别？

<https://cloud.tencent.com/developer/article/2399123>
1.处理机制：JS原生事件直接绑定在DOM元素上，React合成事件通过事件委托实现。
2.事件对象：JS原生事件对象直接反映浏览器实现，React合成事件对象消除了浏览器差异。
3.事件传播：JS原生事件支持冒泡和捕获，React合成事件只支持冒泡。
4.使用方式：JS原生事件通过addEventListener绑定，React合成事件通过JSX属性绑定。
5.执行顺序：不要混用JS原生事件和React合成事件，JS原生事件会先执行。

总的来说，React合成事件提供了更好的性能和兼容性，能满足大部分开发需求。但某些场景下，如果需要更精细地控制事件行为或使用不支持的特性，可以考虑使用JS原生事件。

## 类组件和函数组件的区别

- class 面向对象 ，继承，内部状态管理，生命周期，shouldComponentUpdate 优化
- 函数：函数式编程，hooks 模拟生命周期，React.memo 缓存

## setState 是同步更新还是异步更新

setTimeout DOM 事件同步，React 18 都是异步了

## 在 React 类组件中，为什么修改状态要使用 setState 而不是用 this.state.xxx = xxx

使用setState来告知React，数据发生改变了你需要更新视图了

## 组件通讯的方式

props，回调函数，Context,redux 状态管理

## React 的渲染流程,Fiber 架构

Fiber 链表的树,对比新旧树，将指针指向新节点

## React 错误处理方案

ErrorBoundary ，UI 降级

## 如何避免重复渲染

React.memo,shouldComponentUpdate,PureComponent(SCU 默认浅比较)

## useEffect 与 useLayoutEffect 区别

- useEffect 渲染完成后执行函数，异步不阻塞渲染
- useLayoutEffect 渲染前执行函数,阻塞渲染

## redux、mobx、flux 三者区别

redux,flux 单向数据流，mobx 数据劫持

## React 的性能优化

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

## React Portal 的理解与使用

渲染到对应的 dom 里面，挂载非 root,比如对话框

## react hooks 为什么不能放在 if 和 for 里？

严格调用顺序，避免状态更新混乱

## hoc 如何管理状态？hooks 抽离公共逻辑

预置参数和操作逻辑

# React+Typescript

[React+Typescript](#/note/react-typescript.md)

# React原理

[React实现原理](#/books/react-tech.md)

# React Hooks

[React Hooks](#/books/react-hook.md)
