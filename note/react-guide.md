# 入门

https://zh-hans.react.dev/reference/react/hooks

## vite创建

```bash
npm create vite@latest react-project
```





## 状态管理

```jsx
import { useState } from 'react';
const [index, setIndex] = useState(0);
//状态同步
setIndex(index+5);
setIndex(n => n + 1);
```

## 只更新局部状态
```jsx
const [position, setPosition] = useState({ x: 0, y: 0 });
onPointerMove={e => {
  setPosition({
    x: e.clientX,
    y: e.clientY
  });
}}
 setPosition({
  ...position,
    y: e.target.value
  });
import { useImmer } from 'use-immer';
const [myList, updateMyList] = useImmer(
    initialList
  );
updatePerson(position => {
     position.x = e.target.value;
    });
```
## 条件渲染
```jsx
let content;
if (isLoggedIn) {
  content = <AdminPanel />;
} else {
  content = <LoginForm />;
}
return (
  <div>
    {content}
  </div>
);

<div>
  {isLoggedIn ? (
    <AdminPanel />
  ) : (
    <LoginForm />
  )}
</div>

<div>
  {isLoggedIn && <AdminPanel />}
</div>

if(tag){return <button></button>}else{return null}
```
## 渲染列表 
```jsx
const products = [
  { title: 'Cabbage', id: 1 },
  { title: 'Garlic', id: 2 },
  { title: 'Apple', id: 3 },
];
const listItems = products.map(product =>
  <li key={product.id}>
    {product.title}
  </li>
);

return (
  <ul>{listItems}</ul>
);

  <ul>{list.map((a,idx)=><li key={idx}>{a.name}</li>)}</ul>
  
  
function Cup({ guest }) {
  return <h2>Tea cup for guest #{guest}</h2>;
}

export default function TeaGathering() {
  let cups = [];
  for (let i = 1; i <= 12; i++) {
    cups.push(<Cup key={i} guest={i} />);
  }
  return cups;
}
```
## 响应事件
```jsx
function MyButton() {
  function handleClick(ev) {
    alert('You clicked me!',ev);
  }

  return (
    <button onClick={handleClick}>
      Click me
    </button>
  );
}

```
## 获取属性
```jsx
function(props) {
return <div>{props.label}:{props.value}</div>
}

function({label,value}){
retutn <div>{label}:{value}</div>
}
```
## 子组件=slot插槽
```jsx 
function({children}){
return <div className="page-container">{children}<div>
}
```
## 数组操作
```jsx
//数组
const [artists, setArtists] = useState([]);
setArtists([//新增
          ...artists,
          { id: nextId++, name: name }
        ]);
setArtists(//删除
                artists.filter(a =>
                  a.id !== artist.id
                )
              );
```
## 避免状态矛盾
```jsx 
  async function handleSubmit(e) {
    e.preventDefault();
    setIsSending(true);
    await sendMessage(text);
    setIsSending(false);
  }
function sendMessage(text) {
  return new Promise(resolve => {
    setTimeout(resolve, 2000);
  });
}
```
## 组件状态改变
```jsx
const [hover, setHover] = useState(false);

  let className = 'counter';
  if (hover) {
    className += ' hover';
  }
  return (
    <div
      className={className}
      onPointerEnter={() => setHover(true)}
      onPointerLeave={() => setHover(false)}
    >123</div>

```
## Reducer
```jsx
 
import { useReducer } from 'react';
const [tasks, dispatch] = useReducer(tasksReducer, initialTasks);
dispatch({
      type: 'added',
      id: nextId++,
      text: text,
    });

function tasksReducer(tasks, action) {
  switch (action.type) {
    case 'added': {
      return [
        ...tasks,
        {
          id: action.id,
          text: action.text,
          done: false,
        },
      ];
    }
}

import { useImmerReducer } from 'use-immer';
  const [tasks, dispatch] = useImmerReducer(tasksReducer, initialTasks);
function tasksReducer(draft, action) {
  switch (action.type) {
    case 'added': {
      draft.push({
        id: action.id,
        text: action.text,
        done: false,
      });
      break;
    }
}
```
## Context
```jsx

import { createContext } from 'react';
export const LevelContext = createContext(1);

import { useContext } from 'react';
import { LevelContext } from './LevelContext.js';
 const level = useContext(LevelContext);

<LevelContext.Provider value={level}>
        {level+1}
      </LevelContext.Provider>
```
## context reducer
```jsx
import { createContext, useContext, useReducer } from 'react';

const TasksContext = createContext(null);

const TasksDispatchContext = createContext(null);

export function TasksProvider({ children }) {
  const [tasks, dispatch] = useReducer(
    tasksReducer,
    initialTasks
  );

  return (
    <TasksContext.Provider value={tasks}>
      <TasksDispatchContext.Provider value={dispatch}>
        {children}
      </TasksDispatchContext.Provider>
    </TasksContext.Provider>
  );
}

export function useTasks() {
  return useContext(TasksContext);
}

export function useTasksDispatch() {
  return useContext(TasksDispatchContext);
}

const tasks = useTasks();
const dispatch = useTasksDispatch();

```
## ref
```jsx
 
import { useRef } from 'react';
const ref = useRef(0); //{current:0}
ref.current = ref.current + 1; //改变不更新，还是要用state

const inputRef = useRef(null);
<input ref={inputRef} />;

inputRef.current.focus();

<MyInput ref={inputRef} />;
const MyInput = forwardRef((props, ref) => {
  return <input {...props} ref={ref} />;
});
```
## useEffect
```jsx
 
import { useEffect } from 'react';

//每次渲染后执行
useEffect(() => {
  // This runs after every render
});
//首次渲染后执行
useEffect(() => {
  // This runs only on mount (when the component appears)
}, []);
//a和b改变渲染后执行
useEffect(() => {
  // This runs on mount *and also* if either a or b have changed since the last render
}, [a, b]);

useEffect(() => {
  function handleScroll(e) {
    console.log(window.scrollX, window.scrollY);
  }
  window.addEventListener('scroll', handleScroll);
  return () => {
    //卸载时执行
    window.removeEventListener('scroll', handleScroll);
  };
}, []);
```
## useMemo
```jsx
 
import { useMemo, useState } from 'react';
const [newTodo, setNewTodo] = useState('');
const visibleTodos = useMemo(() => {
  //缓存计算
  // Does not re-run unless todos or filter change
  return getFilteredTodos(todos, filter);
}, [todos, filter]);
```
## useEffectEvent
```jsx
import { useEffect, useEffectEvent } from 'react';
const onVisit = useEffectEvent((visitedUrl) => {
  logVisit(visitedUrl, numberOfItems);
});

useEffect(() => {
  onVisit(url);
}, [url]);

const onVisit = useEffectEvent(() => {
  logVisit(url, numberOfItems);
});

useEffect(() => {
  onVisit();
}, [url]);

function useTimer(callback, delay) {
  const onTick = useEffectEvent(() => {
    callback();
  });

  useEffect(() => {
    const id = setInterval(() => {
      onTick(); // ✅ Good: Only called locally inside an Effect
    }, delay);
    return () => {
      clearInterval(id);
    };
  }, [delay]); // No need to specify "onTick" (an Effect Event) as a dependency
}
useTimer(() => {
  setCount(count + 1);
}, 1000);

const onMessage = useEffectEvent((receivedMessage) => {
  onReceiveMessage(receivedMessage);
});
const options = {
  serverUrl: serverUrl,
  roomId: roomId
};
useEffect(() => {
  const connection = createConnection(options);
  connection.connect();
  connection.on('message', (receivedMessage) => {
    onMessage(receivedMessage);
  });
  return () => connection.disconnect();
}, [options]);
```
## hook
```jsx

function useOnlineStatus() {
  //钩子函数hook
  const [isOnline, setIsOnline] = useState(true);
  useEffect(() => {
    function handleOnline() {
      setIsOnline(true);
    }
    function handleOffline() {
      setIsOnline(false);
    }
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);
  return isOnline;
}
const isOnline = useOnlineStatus();
```
## formInput
```jsx
export function useFormInput(initialValue) {
  const [value, setValue] = useState(initialValue);

  function handleChange(e) {
    setValue(e.target.value);
  }

  const inputProps = {
    value: value,
    onChange: handleChange
  };

  return inputProps;
}
const firstNameProps = useFormInput('Mary');
<input {...firstNameProps} />;
```
## useEffect监听
```jsx
useChatRoom({
  roomId: roomId,
  serverUrl: serverUrl,
  onReceiveMessage(msg) {
    showNotification('New message: ' + msg);
  }
});

export function useChatRoom({ serverUrl, roomId, onReceiveMessage }) {
  const onMessage = useEffectEvent(onReceiveMessage);

  useEffect(() => {
    const options = {
      serverUrl: serverUrl,
      roomId: roomId
    };
    const connection = createConnection(options);
    connection.connect();
    connection.on('message', (msg) => {
      onMessage(msg);
    });
    return () => connection.disconnect();
  }, [roomId, serverUrl]); // ✅ All dependencies declared
}
```
## 动画
```jsx
//动画1
export function useFadeIn(ref, duration) {
  useEffect(() => {
    const node = ref.current;

    let startTime = performance.now();
    let frameId = null;

    function onFrame(now) {
      const timePassed = now - startTime;
      const progress = Math.min(timePassed / duration, 1);
      onProgress(progress);
      if (progress < 1) {
        // We still have more frames to paint
        frameId = requestAnimationFrame(onFrame);
      }
    }

    function onProgress(progress) {
      node.style.opacity = progress;
    }

    function start() {
      onProgress(0);
      startTime = performance.now();
      frameId = requestAnimationFrame(onFrame);
    }

    function stop() {
      cancelAnimationFrame(frameId);
      startTime = null;
      frameId = null;
    }

    start();
    return () => stop();
  }, [ref, duration]);
}
useFadeIn(ref, 1000);

//动画2
import { experimental_useEffectEvent as useEffectEvent } from 'react';

export function useFadeIn(ref, duration) {
  const [isRunning, setIsRunning] = useState(true);

  useAnimationLoop(isRunning, (timePassed) => {
    const progress = Math.min(timePassed / duration, 1);
    ref.current.style.opacity = progress;
    if (progress === 1) {
      setIsRunning(false);
    }
  });
}

function useAnimationLoop(isRunning, drawFrame) {
  const onFrame = useEffectEvent(drawFrame);

  useEffect(() => {
    if (!isRunning) {
      return;
    }

    const startTime = performance.now();
    let frameId = null;

    function tick(now) {
      const timePassed = now - startTime;
      onFrame(timePassed);
      frameId = requestAnimationFrame(tick);
    }

    tick();
    return () => cancelAnimationFrame(frameId);
  }, [isRunning]);
}
//动画3

export function useFadeIn(ref, duration) {
  useEffect(() => {
    const animation = new FadeInAnimation(ref.current);
    animation.start(duration);
    return () => {
      animation.stop();
    };
  }, [ref, duration]);
}

export class FadeInAnimation {
  constructor(node) {
    this.node = node;
  }
  start(duration) {
    this.duration = duration;
    this.onProgress(0);
    this.startTime = performance.now();
    this.frameId = requestAnimationFrame(() => this.onFrame());
  }
  onFrame() {
    const timePassed = performance.now() - this.startTime;
    const progress = Math.min(timePassed / this.duration, 1);
    this.onProgress(progress);
    if (progress === 1) {
      this.stop();
    } else {
      // We still have more frames to paint
      this.frameId = requestAnimationFrame(() => this.onFrame());
    }
  }
  onProgress(progress) {
    this.node.style.opacity = progress;
  }
  stop() {
    cancelAnimationFrame(this.frameId);
    this.startTime = null;
    this.frameId = null;
    this.duration = 0;
  }
}
```


# 钩子

## use

```jsx
//use在组件中调用 use 来读取 Promise 或 上下文 等资源的值。
const content = use(messagePromise);
const theme = use(ThemeContext);
```

## useCallback

```jsx
//useCallback 在重新渲染之间缓存一个函数，直到它的依赖发生变化。
const handleSubmit = useCallback(
  (orderDetails) => {
    post('/product/' + productId + '/buy', {
      referrer,
      orderDetails
    });
  },
  [productId, referrer]
);

//当一个组件重新渲染时，React 会递归地重新渲染它的所有子级。
//在其属性与上次渲染相同时通过将其封装在 memo： 中来跳过重新渲染
import { memo } from 'react';
const ShippingForm = memo(function ShippingForm({ onSubmit }) {
  // ...
});
```

useMemo 缓存调用你的函数的结果。
useCallback 缓存函数本身。

## useContext

```jsx

  const contextValue = useMemo(() => ({
    currentUser,
    login
  }), [currentUser, login]);

  return (
    <AuthContext.Provider value={contextValue}>

```

## useDeferredValue

```jsx
//推迟更新 UI 的一部分。
const [query, setQuery] = useState('');
const deferredQuery = useDeferredValue(query);
```

## useId

```jsx
//useId生成唯一id
const myId = useId();
```

## useRef,useImperativeHandle

```jsx
//forwardRef 向父组件公开自定义引用句柄
const MyInput = forwardRef(function MyInput(props, ref) {
  return <input {...props} ref={ref} />;
});

//useImperativeHandle让你自定义公开为 引用 的句柄  等价于expose
const inputRef = useRef(null);

useImperativeHandle(
  ref,
  () => {
    return {
      focus() {
        inputRef.current.focus();
      },
      scrollIntoView() {
        inputRef.current.scrollIntoView();
      }
    };
  },
  []
);

return <input {...props} ref={inputRef} />;
```

## useInsertionEffect

```jsx
//useInsertionEffect允许在任何布局效果触发之前将元素插入 DOM。
import { useInsertionEffect } from 'react';
let isInserted = new Set();
function useCSS(rule) {
  useInsertionEffect(() => {
    // As explained earlier, we don't recommend runtime injection of <style> tags.
    // But if you have to do it, then it's important to do in useInsertionEffect.
    if (!isInserted.has(rule)) {
      isInserted.add(rule);
      document.head.appendChild(getStyleForRule(rule));
    }
  });
  return rule;
}
```

## useLayoutEffect

```
//useLayoutEffect在浏览器重绘屏幕之前触发。
const ref = useRef(null);
const [tooltipHeight, setTooltipHeight] = useState(0); // You don't know real height yet

useLayoutEffect(() => {
  const { height } = ref.current.getBoundingClientRect();
  setTooltipHeight(height); // Re-render now that you know the real height
}, []);
```

## useMemo

```jsx
//useMemo在重新渲染之间缓存计算结果  等价于vue computed
const visibleTodos = useMemo(() => filterTodos(todos, tab), [todos, tab]);
```

## useReducer

```jsx
//useReducer管理状态
function reducer(state, action) {
  if (action.type === 'incremented_age') {
    return {
      age: state.age + 1
    };
  }
  throw Error('Unknown action.');
}
const [state, dispatch] = useReducer(reducer, { age: 42 });

dispatch({ type: 'incremented_age' });
```

## useRef

```jsx
//useRef引用渲染不需要的值
const inputRef = useRef(null);

function handleClick() {
  inputRef.current.focus();
}
<input ref={inputRef} />;
```

## useState

```jsx
//useState 状态变量 添加到组件中
const [state, setState] = useState(initialState);
```

## useSyncExternalStore

```jsx
//useSyncExternalStore订阅外部存储。
import { useSyncExternalStore } from 'react';
function getSnapshot() {
  return navigator.onLine;
}
function subscribe(callback) {
  window.addEventListener('online', callback);
  window.addEventListener('offline', callback);
  return () => {
    window.removeEventListener('online', callback);
    window.removeEventListener('offline', callback);
  };
}
const isOnline = useSyncExternalStore(subscribe, getSnapshot);
```

## useTransition

```jsx
//useTransition在不阻塞 UI 的情况下更新状态。将某些状态更新标记为转场

const [isPending, startTransition] = useTransition();
const [tab, setTab] = useState('about');

function selectTab(nextTab) {
  startTransition(() => {
    setTab(nextTab);
  });
}

//将页面导航标记为转场
export default function App() {
  return (
    <Suspense fallback={<BigSpinner />}>
      <Router />
    </Suspense>
  );
}

function Router() {
  const [page, setPage] = useState('/');
  const [isPending, startTransition] = useTransition();

  function navigate(url) {
    startTransition(() => {
      setPage(url);
    });
  }

  let content;
  if (page === '/') {
    content = <IndexPage navigate={navigate} />;
  } else if (page === '/the-beatles') {
    content = (
      <ArtistPage
        artist={{
          id: 'the-beatles',
          name: 'The Beatles'
        }}
      />
    );
  }
  return <Layout isPending={isPending}>{content}</Layout>;
}
```

# 组件

## Profiler

```jsx
 将组件树封装在 <Profiler> 中以测量其渲染性能。
<Profiler id="App" onRender={onRender}>
  <App />
</Profiler>
function onRender(id, phase, actualDuration, baseDuration, startTime, commitTime) {
  // Aggregate or log render timings...
}
```

## StrictMode

```jsx
StrictMode 为里面的组件树启用额外的开发行为和警告
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

const root = createRoot(document.getElementById('root'));
root.render(
  <StrictMode>
    <App />
  </StrictMode>
);
```

## Suspense

```jsx
<Suspense> 允许你显示回退，直到其子级完成加载。
<Suspense fallback={<Loading />}>
  <SomeComponent />
</Suspense>
```

# API

## cache

```jsx
//cache缓存数据获取或计算的结果。
const cachedFn = cache(fn);
```

## createContext

```jsx
//createContext创建组件可以提供或读取的 上下文。

import { createContext } from 'react';

const ThemeContext = createContext('light');
 <ThemeContext.Provider value={theme}>
      <Page />
    </ThemeContext.Provider>

    <ThemeContext.Consumer>
      {theme => (
        <button className={theme} />
      )}
    </ThemeContext.Consumer>
    const theme = useContext(ThemeContext);
```

## forwardRef

```jsx
//forwardRef 将 DOM 节点暴露给父组件

const MyInput = forwardRef(function MyInput(props, ref) {
  useImperativeHandle(
    ref,
    () => {
      return {
        focus() {
          inputRef.current.focus();
        },
        scrollIntoView() {
          inputRef.current.scrollIntoView();
        }
      };
    },
    []
  );
  return (
    <label>
      {props.label}
      <input ref={ref} />
    </label>
  );
});
```

## lazy

```jsx
//lazy延迟加载的 React 组件
const MarkdownPreview = lazy(() => import('./MarkdownPreview.js'));
```

## memo

```jsx
//memo在属性不变时跳过重新渲染组件。
const Greeting = memo(function Greeting({ name }) {
  return <h1>Hello, {name}!</h1>;
});

const Chart = memo(function Chart({ dataPoints }) {
  // ...
}, arePropsEqual);
//比较函数
function arePropsEqual(oldProps, newProps) {
  return (
    oldProps.dataPoints.length === newProps.dataPoints.length &&
    oldProps.dataPoints.every((oldPoint, index) => {
      const newPoint = newProps.dataPoints[index];
      return oldPoint.x === newPoint.x && oldPoint.y === newPoint.y;
    })
  );
}
```

## startTransition

```jsx
//startTransition 允许你在不阻塞 UI 的情况下更新状态。
export default function TabButton({ children, isActive, onClick }) {
  const [isPending, startTransition] = useTransition();
  if (isActive) {
    return <b>{children}</b>
  }
  if (isPending) {
    return <b className="pending">{children}</b>;
  }
  return (
    <button onClick={() => {
      startTransition(() => {
        onClick();
      });
    }}>
      {children}
    </button>
  );
}
```

## createPortal

```jsx
//createPortal将一些子级渲染到 DOM 的不同部分。
{
  createPortal(<p>This child is placed in the document body.</p>, document.body);
}
```

## flushSync

```jsx
//flushSync强制 React 同步刷新提供的回调中的任何更新

flushSync(() => {
  setIsPrinting(true);
});
```

# mobx

# Redux

# React-router

