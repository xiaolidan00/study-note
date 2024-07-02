# setState

React 17

- 不可变值(数组不可用 splice,shift,push 等修改，对象不可 state.a 方式修改)
- 可能是异步更新
- 可能会被合并

```js
this.setState({ count: this.count + 1 }, () => {
  //$nextTick
  console.log(this.count); //回调函数，拿到最新值
});
console.log(this.count); //异步，拿不到最新值
//setTimeoout同步
setTimeout(() => {
  this.setState({ count: this.count + 1 });
  console.log(this.count); //同步，拿到最新值
});
//DOM事件同步
dom.onClick = () => {
  this.setState({ count: this.count + 1 });
  console.log(this.count); //同步，拿到最新值
};

//传入对象，会被合并，只执行一次+1
this.setState({ count: this.count + 1 });
this.setState({ count: this.count + 1 });
this.setState({ count: this.count + 1 });

//传入函数，不会合并，执行3次+3
this.setState((preState, props) => {
  return { count: preState.count + 1 };
});
this.setState((preState, props) => {
  return { count: preState.count + 1 };
});
this.setState((preState, props) => {
  return { count: preState.count + 1 };
});
```

React 18

- React 组件事件：异步更新+合并 state
- DOM 事件，setTimout:异步更新+合并 state
- 自动批处理

# 生命周期

[官方生命周期图谱](https://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/)
单个组件的生命周期

Render 阶段：纯净且不包含副作用，可能会被 React 暂停，中止或重启动

Commit 阶段：可以使用 DOM,运行副作用，安排更新

```txt
React 16
挂载：
constructor->(getDerivedStateFromProps)->render->componentDidMount
更新：
new Props,setState,forceUpdate->(getDerivedStateFromProps)->(shouldComponentUpdate)->render->(getSnapshotBeforeUpdate)->componentDidUpdate
卸载
componentWillUnmount
```

父子组件生命周期和 vue 一样

# 非受控组件

- ref
- defaultValue
- defaultChecked
- 手动操作 DOM 元素

使用场景

- 必须手动操作 DOM,setState 实现不了
- 文件上传 input type=file
- 富文本编辑器，需要传入 DOM 元素

对比受控组件

- 优先使用受控组件，附和 React 设计原则
- 必须操作 DOM 时再使用非受控组件

```jsx
function FormInput() {
  const [value, setValue] = useState('');
  const inputRef = useRef(null);
  useEffect(() => {
    inputRef.current.onchange = () => {
      setValue(inputRef.current.value);
    };
  });
  return (
    <>
      <input defaultValue={value} ref={inputRef} />
    </>
  );
}
```

# Portals 传送门

- 组件默认会按照规定层级嵌套渲染
- 将组件渲染到父组件以外（对话框）

使用场景

- 父组件 z-index 太小
- fixed 需要放到 body 第一层
- overflow:hidden

```jsx
createPortal(<div class="modal">{children}</div>, document.body);
```

# Context

https://juejin.cn/post/6924506511511126029

- 公共信息传递给每个组件（语言，主题,登录）

- React.createContext 提供的 Provider 和 Consumer

```jsx
import { createContext } from 'react';

export default createContext({ data: 1 });

//-------
import React, { createContext } from "react";
import MyContext from "./context";

import GeneralC from "./GeneralC";

export default function App() {
  return (
    //Provider组件接收一个value属性，此处传入一个带有name属性的对象
    <MyContext.Provider value={{ data: 2 }}>
      {/*这里写后面要进行包裹的子组件,此处先行导入后续需要消费context的3个组件*/}
      <GeneralC/>
    <FnC/>
  <ClassC/>
    </MyContext.Provider>
  );
}
//-------

import React, { useReducer } from "react";
import MyContext from "./context";

const GeneralC = () => {
  return (
    //
    <MyContext.Consumer>
      {(context) => {
        return (
          <div>
             {context.data//2
             }
          </div>
        );
      }}
    </MyContext.Consumer>
  );
};

export default GeneralC;

```

- 函数组件：React.createContext 提供的 Provider 和 useContext 钩子

```jsx
import React, { useContext } from 'react';
import MyContext from './context';

const FnC = () => {
  const context = useContext(MyContext);
  return (
    <div>
      {
        context.data //2
      }
    </div>
  );
};

export default FnC;
```

- Class 组件：React.createContext 提供的 Provider 和 class 的 contextType 属性

```jsx
import React, { Component } from 'react';
import context from './context';

class ClassC extends Component {
  static contextType = context;
  render() {
    return (
      <div>
        {
          this.context.data //2
        }
      </div>
    );
  }
}

// ClassC.contextType = context; //此处与写static关键字作用一致
export default ClassC;
```

- 修改 context

```jsx
import React, { useState } from "react";
//导入useState钩子
...

const context = {
  data: 1
};

export default function App() {
  const [store, setStore] = useState(context);
  //Provider的value不再传入一个简单结构的对象，而是将useState的返回值作为新对象的key/value,子组件便能调用App的setStore函数进行更新
  return (
    <MyContext.Provider value={{ store, setStore }}>
       {/* 在父组件更改Context */}
      <button
        onClick={() => {
          setStore({
            data:2
          });
        }}
      >
        App的change context
      </button>
       {/* 此处为组件引入,省略... */}
    </MyContext.Provider>
  );
}


import React, { useContext } from "react";
import MyContext from "./context";

const Component = () => {
  const context = useContext(MyContext);
  return (
    <div>
       {context.data//1
       }
      <button
        onClick={() => {
          context.setStore({
            data:2
          });
        }}
      >
        FnC子组件的change context
      </button>
    </div>
  );
};

export default Component;

```

# 异步加载组件

- import()
- React.lazy
- React.Suspense

```jsx
const Demo = React.lazy(() => import('./MyDemo'));

<React.Suspense fallback={<div>loading</div>}>
  <Demo></Demo>
</React.Suspense>;
```

# 性能优化

- shouldComponentUpdate(SCU)
- PureComponent 和 React.memo
- 不可变值 immutable.js

shouldComponentUpdate 注意

- React 默认：父组件有更新， 子组件则无条件也更新

```jsx
shouldComponentUpdate(nextProps,nextState){
  if(nextState.count!=this.state.count){
    return true//可以渲染
  }
  return false//不重复渲染
}
shouldComponentUpdate(nextProps,nextState){
  if(_isEqual(nextProps.list,this.props.list)){//深度比较比较耗费性能
    return true//可以渲染
  }
  return false//不重复渲染
}
```

PureComponent 注意

- SCU 中默认实现了浅比较
- memo:函数中的 PureComponent

```jsx
class List extends React.PureComponent {
  constructor(props) {
    super(props);
  }
  render() {
    return <div></div>;
  }
}
React.memo(
  function List(props) {
    return <div>Hello</div>;
  },
  function (preProps, nextProps) {}
);
```

immutable.js

```jsx
const map1 = Immutable.Map({ a: 1, b: 2 });
const map2 = map1.set('b', 50);
map1.get('b'); //2
map2.get('b'); //50

import { useImmer } from 'use-immer';
const [myList, updateMyList] = useImmer(initialList);
updateMyList((list) => {
  list.push(item);
});

const [user, updateUser] = useImmer({ name: 'aaa', age: 22 });
updateUser((data) => {
  data.name = 'bbb';
});
```

# HOC 高阶组件

- 一种模式
- 抽离公共逻辑

```jsx
const withMouse = (component) => {
  class HOC extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        x: 0,
        y: 0
      };
    }
    mouseHover = (ev) => {
      this.setState({
        x: ev.offsetX,
        y: ev.offsetY
      });
    };
    render() {
      return (
        <div onMouseMove={this.mouseHover}>
          {/**1.透传所有props 2.增加mouse属性 */}
          <component {...this.props} mouse={this.state}></component>
        </div>
      );
    }
  }
  return HOC;
};

withMouse(function App(props) {
  return (
    <div>
      {props.mouse.x},{props.mouse.y}
    </div>
  );
});
```

redux connect 是高阶组件

```jsx
import { connect } from 'react-redux';
const VisibleTodoList = connect(mapStateToProps, mapDispatchToProps)(TodoList);
```

# Render Props

通过一个函数，将 class 组件的 state 作为 props 传递给纯函数的组件

```jsx
class MouseFactory extends React.Component {
  constructor() {
    this.state = { x: 0, y: 0 };
  }
  mouseHover = (ev) => {
    this.setState({
      x: ev.offsetX,
      y: ev.offsetY
    });
  };
  render() {
    return <div onMouseMove={this.mouseHover}>{this.props.render(this.state)}</div>;
  }
}
function App() {
  <MouseFactory
    render={
      /** render是一个函数组件*/
      (props) => (
        <p>
          {props.x}:{props.y}
        </p>
      )
    }
  ></MouseFactory>;
}
```

# Redux

不可变值

- store state
- action
- reducer

```js
const store = createStore({
  x: 1,
  y: 1
});
function reducer(state, action) {
  switch (action.type) {
    case 'action1':
      state.x = action.x;
      state.y = action.y;
      break;
  }
  return { ...state };
}
store.subscribe(() => {
  console.log(store.getState());
});
store.dispatch({ type: 'action1', x: 10, y: 20 });
```

## 单向数据流

- dispatch(action)
- reducer->newState
- subscribe 触发通知

## react-redux

- Provider
- connect
- mapStateToProps,mapDispatchToProps

```jsx
function App() {
  return (
    <Provider store={store}>
      <MyPage></MyPage>
    </Provider>
  );
}
const mapStateToProps = (state) => {
  return {
    x: state.x,
    y: state.y
  };
};
const mapDispatchToProps = (dispatch) => {
  return {
    handleClick: (id) => {
      dispatch({ type: 'action1', id });
    }
  };
};
```

## 异步 action

- redux-thunk
- redux-promise
- redux-saga

- redux-logger

```js
import thunk from 'redux-thunk';
import createLogger from 'redux-logger';
const logger = createLogger();
const doAsyncAction = (data) => {
  return (dispacth) => {
    fetch(url).then((res) => {
      dispatch({ type: 'action1', res });
    });
  };
};
const store = createStore(reducer, applyMiddleware(thunk, logger)); //中间件会按顺序执行
```

## redux 中间件

```txt
      callback          action          state
button--------->dispatch-------->reducer----->view
              ^
              |
            middlewares

```

```js
let next = store.dispatch;
store.dispatch = function dispatchAndLog(action) {
  console.log('dispatching', action);
  next(action);
  console.log('next state', store.getState());
};
```

# react-router

- 路由模式：hash,H5 history
- 路由配置（动态路由，懒加载）

# React 原理

- 函数式编程
- vdom 和 diff
- jsx
- 合成事件
- setState batchUpdate
- 组件渲染过程

## JSX 本质

- React.createElement
- [babel jsx 转换](https://www.babeljs.cn/rep)

```jsx
const style = {
  color: 'red'
};

const template = (
  <div style={style} onClick={handleClick}>
    {list.map((item, idx) => (
      <MyButton text={item} />
    ))}
  </div>
);
/*----编译后----*/
import { jsx as _jsx } from 'react/jsx-runtime';
const style = {
  color: 'red'
};
const template = /*#__PURE__*/ _jsx('div', {
  style: style,
  onClick: handleClick,
  children: list.map((item, idx) =>
    /*#__PURE__*/ _jsx(MyButton, {
      text: item
    })
  )
});
```

## 合成事件

- event 是 SyntheticEvent，模拟出 DOM 事件所有能力
- 所有事件挂载在 document 上，React17 以后挂载在 root 组件 上（有利于多个 React 版本并存，如微前端）
- event 不是原生的，是 SyntheticEvent 合成事件对象
- 和 Vue 事件不同，和 DOM 事件也不同

```js
event.preventDefault(); //阻止默认行为
event.stopProgation(); //阻止冒泡
event.target; //当前触发元素
event.currentTarget; //当前元素，假象
event.__proto__.constructor; //SyntheticEvent，不是原生MouseEvent
event.nativeEvent; //原生事件
event.nativeEvent.target; //当前触发元素
event.nativeEvent.currentTarget; //指向document
```

- 更好的兼容性和跨平台
- 挂载到 root 组件,减少内存销毁，避免频繁解绑
- 方便事件统一管理，如事务机制

## setState batchUpdate

### setState 主流程

```txt
setState(newState)->newState存入pending队列->是否处于batch update

isBatchingUpdates:true->保存组件到dirtyComponents中->isBatchingUpdates:false

isBatchingUpdates:false(sourcemapsourcemap)->遍历所有dirtyComponents->调用updateComponent->更新pending state或props
```

### 哪些能命中 batchUpdate 机制

- 生命周期（和它调用的函数）
- React 中注册的事件（和它调用的函数）onClick,onChange
- React 可以管理的入口

### 哪些不能命中 batchUpdate 机制

- setTimeout,setInterval 等（和它调用的函数）
- 自定义 DOM 事件（和它调用的函数）
- React 不可以管理的入口

- props state->dirtyComponents(可能有子组件)
- render 生成 vnode
- patch(elmt,vnode)

### patch 拆分阶段

- reconciliation 阶段-执行 diff 算法，纯 js 计算
- commit 阶段-将 diff 结果渲染成 DOM

### 解决方案 Fiber

- 将 reconciliation 阶段进行任务拆分（commit 无法拆分）
- DOM 需要渲染时暂停，空闲是恢复
- window.requestIdleCallback

### window.requestIdleCallback()

方法插入一个函数，这个函数将在浏览器空闲时期被调用。这使开发者能够在主事件循环上执行后台和低优先级工作，而不会影响延迟关键事件，如动画和输入响应。函数一般会按先进先调用的顺序执行，然而，如果回调函数指定了执行超时时间 timeout，则有可能为了在超时前执行函数而打乱执行顺序。

你可以在空闲回调函数中调用 requestIdleCallback()，以便在下一次通过事件循环之前调度另一个回调。

强烈建议使用 timeout 选项进行必要的工作，否则可能会在触发回调之前经过几秒钟。

```js
requestIdleCallback(() => {}, {
  timeout: 1000
  //如果指定了 timeout，而回调在 timeout 毫秒过后还没有被调用，那么回调任务将放入事件循环中排队，即使这样做有可能对性能产生负面影响。
});
```

# React 性能优化

- 渲染列表时加 key
- 自定义事件、DOM 事件及时销毁
- 合理使用异步组件
- 减少函数 bind this 次数
- 合理使用 SCU 和 memo
- 合理使用 Immutable,useImmer
- SSR

- useMemo(记忆组件),useCallback(记忆函数)

```jsx
const handleClick = useCallback(
  (ev) => {
    console.log(ev);
  },
  [name]
);
<button onClick={handleClick}></button>;

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

- useMemo 缓存函数调用的结果。在这里，它缓存了调用 computeRequirements(product) 的结果。除非 product 发生改变，否则它将不会发生变化。这让你向下传递 requirements 时而无需不必要地重新渲染 ShippingForm。必要时，React 将会调用传入的函数重新计算结果。
- useCallback 缓存函数本身。不像 useMemo，它不会调用你传入的函数。相反，它缓存此函数。从而除非 productId 或 referrer 发生改变，handleSubmit 自己将不会发生改变。这让你向下传递 handleSubmit 函数而无需不必要地重新渲染 ShippingForm。直至用户提交表单，你的代码都将不会运行。

# React 和 Vue 区别

共同点

- 组件化
- 数据驱动视图
- vdom 操作 DOM

区别

- React 使用 jsx 拥抱 js，vue 使用模板拥抱 html
- React 函数式编程，vue 声明式编程
- React 灵活，Vue 规范处理好
