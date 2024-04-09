《React Hooks 开发实战》鬼哥
https://fanqienovel.com/page/7262612706622966818

# 什么是 React Hooks? React Hooks 有哪些优势?React Hooks 到底解决了什么问题?

Hooks 是 React 官方团队在 React 16.8 版本中正式引入的概念。通俗地讲，Hooks 只是一些函数，Hooks 可以用于在函数组件中引入状态管理和生命周期方法。如果希望让 React 函数组件拥有状态管理和生命周期方法，我们不需要再去将 React 函数组件重构成 React 类组件，而可以直接使用 React Hooks.

**hooks 优势**

- 简洁，上手简单
- 复用性更好，简化业务
- 方便数据管理
- 更友好地支持 ts

**hooks 缺点**

- 状态不同步
- useEffect 依赖问题
- 不可在条件和循环里用 hooks

**React 的 Class 与 Hooks 区别**

React Class 上手难表现为如下几点。

- 生命周期函数难以理解，很难熟练掌握。
- 与 Redux 状态管理相关的概念太多
- 高阶组件(HOC)很难理解。

和 React Class 相比，React Hooks 的出现让 React 的学习成本降低了很多。

- 基于函数式编程理念，门槛比较低，只需要掌握一些 JavaScript 基础知识。
- 与生命周期相关的知识不用学，React Hooks 使用全新的理念来管理组件的运作过程。
- 与 HOC 相关的知识不用学，React Hooks 能够完美解决 HOC 想要解决的问题，并且更可靠。
- MobX 取代了 Redux 来做状态管理

**React 使用 typescript**

```tsx
interface UserInfo {
  username: string;
  age: number;
}
class MyButton extends React.Component<UserInfo, {}> {
  state = {};
  constructor(props: UserInfo) {
    super(props);
  }
  render() {
    return (
      <div>
        {this.props.username}-{this.props.age}
      </div>
    );
  }
}

function MyButton(props: UserInfo): React.FC<UserInfo> {
  return (
    <div>
      {props.username}-{props.age}
    </div>
  );
}
```

**hooks 的生命周期**

- useState 声明变量函数
- useEffect 渲染完成后执行函数
- useLayoutEffect 渲染前执行函数

**class 与 hooks 生命周期对应**
| Class | hooks |
| ------------------------ | --------------------------- |
| constructor | useState |
| getDerivedStateFromProps | useState 里面的 update 函数 |
| render | 函数本身 |
| componentDidMount | useEffect |
| componentDidUpdate | useEffect |
| componentWillUnmount | useEffect 里返回的函数 |
| componentDidCatch | 无 |
| getDerivedStateFromError | 无 |
| getSnapshotBeforeUpdate | 无 |
| shouldComponentUpdate | 无 |

```tsx
class MyComponent extends React.Component {
  constructor(props: any) {
    super(props);
    this.state = { name: 'Hello World' };
  }
  static getDerivedStateFromProps(props, state) {
    console.log('判断数据是否需要更新', props, state);
    return null;
  }
  render() {
    console.log('渲染');
    //错误信息校验
    if (this.state.hasError) {
      //渲染降级UI
      return <div>请联系管理员</div>;
    }
    return (
      <div>
        <div>{this.state.name}</div>
        {this.props.children}
      </div>
    );
  }
  componentDidMount() {
    console.log('渲染完成');
  }
  static getSnapshotBeforeUpdate(preProps, preState) {
    console.log('返回组件更新dom');
  }
  shouldComponentUpdate(nextProps, nextState) {
    console.log('判断数据是否更新，返回true和false判断', nextProps, nextState);
    return false;
  }
  componentDidUpdate() {
    console.log('组件数据更新完毕');
  }
  componentWillUnmount() {
    console.log('已经销毁');
  }
  static getDerivedStateFromError(error) {
    console.log('更新state使下一次渲染显示降级UI', error);
    return { hasError: true };
  }
  componentDidCatch(error, info) {
    console.log('捕获错误信息', error, info);
  }
}
```

- getDerivedStateFromProps:React 16.8 版本开始提供的静态方法，通过接收父组件 props 判断是否执行更新，返回 null 表示不更新。

- shouldComponentUpdate:用于返回组件是否重新渲染，当 props 或 state 发生变化时，它会在渲染之前被调用。如果返回 true，则代表重新渲染组件;如果返回 false，则代表不重新渲染组件。使用 shouldcomponentUpdate 可以手动控制是否渲染组件，从而减少非必要染，提升组件性能。

```tsx
const MyComponent = React.memo((props: any) => {
  const [name, setName] = useState('Hello World');
  useMemo(() => {
    console.log('在组件DOM节点渲染之前调用一次');
  }, []);
  useMemo(() => {
    console.log('在组件DOM节点渲染之前根据依赖参数props调用');
  }, [props]);
  useEffect(() => {
    console.log('组件初始化时调用一次');
  }, []);
  useEffect(() => {
    console.log('组件根据依赖参数props更新调用');
  }, [props]);

  useEffect(() => {
    return () => {
      console.log('组件卸载调用');
    };
  }, []);
  const onClick = useCallback(() => {
    console.log('监听事件通过钩子的数包裹，优化性能');
    setName('hahahaaha');
    setName((preVal) => preVal + 'aaa');
  }, []);

  return <div onClick={onClick}>{name}</div>;
});
```

- useState:和 Class 的状态类似，只不过 useState 是独立管理组件变量的
- useMemo:组件 DOM 节点，会进行一些计算，包括要染的 DOM 或数据，根据依赖参数进行更新。
- useEffect:React Hooks 的组件生命周期其实就是通过钩子函数 useEffect 的不同用法实现的，传递不同的参数会导致不同的结果，
- useCallback:一个钩子函数，通过包表普通函数进行性能优化。

**函数式渲染具有以下显著特点:**

- 当给定相同输入(函数的参数)的时候，总是有相同的输出(返回值)。
- 没有副作用。
- 不依赖于函数外部状态。
- 告别繁杂的 this 和难以记忆的生命周期。
- 支持包装自己的 Hooks(自定义 Hooks)，是纯命令式的 API。
- 可更好地完成状态之间的共享，解决了原来 Class 组件内部封装的问题，以及高阶组件和函数组件嵌套过的问题。每个组件都有一个自己的状态，这个状态在该组件内可以共用。

```tsx
const MyButton = (props) => {
  const [user, setUser] = useState({ username: 'aaa', year: 1995 });
  const numRef = useRef(10);
  const inputRef = useRef(null);
  const age = useMemo(() => {
    return new Date().getFullYear() - user.year;
  }, [user.year]);
  const onClick = () => {
    numRef.current++;
  };
  const changeValue = () => {
    setUser({ ...user, year: inputRef.current.value });
  };
  return (
    <div>
      {age}
      <input ref={props.myRef} />
      <button onClick={onClick}>aaa</button>
      <input ref={inputRef} value={user.year} onChange={changeValue} />
    </div>
  );
};
const myRef=useRef(null)
<MyButton myRef={myRef}></MyButton>

const MyInput=forwardRef((props,ref)=>{
return <div ref={ref}>1231232</div>
})
```

**Hooks 的 HOC 高阶组件**

```tsx
const Content = (props) => {
  return <input ref={props.forwardRef} />;
};
const Wrapper = forward((props, ref) => {
  const WrapperContent = memo(Content);
  return <WrapperContent {...props} forwardRef={ref}></WrapperContent>;
});
```

**useImperativeHandle**

```tsx
const MyInput = forwardRef(function MyInput(props, ref) {
  const onChange = (event) => {
    props.onChange(event.currentTarget.value);
  };
  useImperativeHandle(
    ref,
    () => ({
      focus: () => {
        (ref.current as HTMLInputElement).focus();
      }
    }),
    [props.value]
  );
  return <input onChange={onChange} value={props.value} ref={ref} />;
});
```

**useEffect**

```tsx
function MyInput() {
  const onWinResize = () => {
    console.log('resize');
  };
  useEffect(() => {
    const timer = setInterval(() => {
      console.log();
    }, 1000);
    window.addEventListener('resize', onWinResize);
    return () => {
      clearInterval(timer);
      window.removeEventListener('resize', onWinResize);
    };
  }, []);
  return <div>aaaa</div>;
}
```

**useLayoutEffect**

- useEffect 是异步执行的，而 useLayoutEffect 是同步执行的。
- useEffect 的执行时机是浏览器完成渲染之后，而 useLayoutEffect 的执行时机是浏览器将内容渲染到界面之前。

- 当 useEffect 中的操作需要处理 DOM，并且处理 DOM 的过程中会改变页面的样式时就需要用 useLayoutEffect 了，否则可能会出现闪屏问题。useLayoutEffect 里的 callback 函数会在 DOM 更新完成后立即执行，并且会在浏览器进行任何绘制之前运行完成，否则就会阻塞浏览器的绘制。
- 一般情况下都使用 useEffect，因为 useEffect 是异步的，不会阻塞页面绘制，但是当涉及在渲染/更新的回调中操作 DOM 时，为避免出现页面抖动，会考虑使用 useLayoutEffect

**useCallback 和 useMemo**

- useCallback 和 useMemo 的参数相同，第一个参数是函数，第二个参数是依赖项的数组。
- useMemo、useCallback 都是使用的参数(函数)，且都不会因为其他不相关的参数变化而重新渲染。
- 与 useMemo 中的 useEffect 类似，[]内可以放入改变数值就重新渲染参数(函数)的对象。如果[]为空就只渲染一次，之后都不会染。

两者的主要区别:React.useMemo 会调用 fn 函数并返回其结果，而 React.useCallback 仅返回 fn 函数而不调用它。

- 注意事项二:useCallback 需要配合 React.memo 使用，
  这是因为 React.memo 这个方法会对 props 做一个浅层比较，如果 props 没有发生改变，则不会重新渲染此组件。

# Redux

Redux 的功能很简单，主要是 3 个功能:

- 获取当前状态;
- 更新状态;
- 监听状态变化。

**Redux 的主要使用场景**

- 在应用的大量地方存在大量的状态，
- 应用状态会随着时间的推移而频繁更新，
- 更新状态的逻辑可能很复杂。
- 中型和大型应用，很多人协同开发

**使用 Redux 的原则**

- 单一数据源的所有应用的状态被统一管理在唯一的 store 对象数据中。
- 状态是只读的，状态的变化只能通过触发 action 改变。
- 使用纯函数来执行修改，使用纯函数来描述 action，这里的纯函数被称为 reducer

redux-presist

constate

ahooks

react-hook-form

use-denounce

@rehooks/local-storage useLocalStorage writeStorage

react-useportal usePortal

react-use-hover useHover

use-http

react-use

https://www.tslang.cn/docs/handbook/tsconfig-json.html

eslintrc

customize-cra

react-app-rewired

env-cmd

style-resources-loader

babel-plugin-import

svg-sprite-loader

antd-dayjs-webpack-plugin

https://github.com/yangyunhai/my-react-hooks-ts
