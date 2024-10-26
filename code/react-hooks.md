# React Hooks

## useState

```js
function SomeComponent() {
  const [state, toggleState] = useToggle(false);
  return <div>
    {state ? 'true' : 'false'}
    <button onClick={toggleState}></button>
  </div>
}

// 请实现 useToggle
function useToggle(initialValue) {
    const [value, setValue] = useState(initialValue);
    const toggle = () => {setValue(!value)};
    return [value, toggle];
}
```

```js
function App() {
  const [user,setUser] = useState({name:'Varian', age: 18})
  const onClick = ()=>{
    setUser({
      name: 'Janye'
    })
  }
  return (
    <div className="App">
      <h1>{user.name}</h1>
      <h2>{user.age}</h2>
      <button onClick={onClick}>Click</button>
    </div>
  );
}
```

```js
const [pageInfo, setPageInfo] = useState({ page: 0, pageSize: 10 });

const [saveModalVisible, setSaveModalVisible] = useState(false);
const [modalInitData, setModalInitData] = useState(null);
=>
const [saveModalInfo, setSaveModalInfo] = useState({
    visible: false,
    data: null,
});
```

## useEffect

```js
const BlinkyRender = () => {
  const [value, setValue] = useState(0);

  useEffect(() => {
    document.querySelector('#x').innerText = `value: 1000`
  }, [value]);

  return (
    <div id="x" onClick={() => setValue(0)}>value: {value}</div>
  );
};

ReactDOM.render(
  <BlinkyRender />,
  document.querySelector("#root")
);
```

```js
import React, { useState, useEffect } from 'react';

interface Props {
  value: number,
  onChange: (num: number) => any
}

export default function Counter({ value, onChange }: Props) {
  const [count, setCount] = useState<number>(0);

  useEffect(() => {
    value && setCount(value);
  }, [value]);

  return [
    <div key="a">{count}</div>,
    <button key="b" onClick={() => onChange(count + 1)}>
      点击+1
    </button>
  ]
}
```

## useCallback

```js
const useValues = () => {
  const [values, setValues] = useState({
    data: {},
    count: 0
  });

  const updateData = useCallback((nextData) => {
        setValues({
          data: nextData,
          count: values.count + 1 
       }); // 因为 callback 内部依赖了外部的 values 变量，所以必须在依赖数组中指定它
      },
      [values], 
  );

  return [values, updateData];
};
```

优化后

```js
const useValues = () => {
  const [values, setValues] = useState({});

  const updateData = useCallback((nextData) => {
    setValues((prevValues) => ({
      data: nextData,
      count: prevValues.count + 1,    
     })); // 通过 setState 回调函数获取最新的 values 状态，这时 callback 不再依赖于外部的 values 变量了，因此依赖数组中不需要指定任何值
  }, []); // 这个 callback 永远不会重新创建

  return [values, updateData];
};
```

利用ref保存变量

```js
const useValues = () => {
  const [values, setValues] = useState({});
  const latestValues = useRef(values);

  useEffect(() => {
    latestValues.current = values;
  });

  const [updateData] = useCallback((nextData) => {
    setValues({
      data: nextData,
      count: latestValues.current.count + 1,
    });
  }, []);

  return [values, updateData];
};
```

## useMemo

```js
const dataA = useMemo(() => {
  return getDataA();
}, [A, B]);

const dataB = useMemo(() => {
  return getDataB();
}, [A, B]);

// 应该合并为
const [dataA, dataB] = useMemo(() => {
 return [getDataA(), getDataB()]
}, [A, B]);
```

```js
export const useCount = () => {
  const [count, setCount] = useState(0);

  const [increase, decrease] = useMemo(() => {
    const increase = () => {
      setCount((latestCount) => latestCount + 1);
    };

    const decrease = () => {
      setCount((latestCount) => latestCount - 1);
    };
    return [increase, decrease];
  }, []); // 保持依赖数组为空，这样 increase 和 decrease 方法都只会被创建一次
  return [count, increase, decrease];
};
```

```js
export const useCount = () => {
  const [count, setCount] = useState(0);
  const countRef = useRef(count);

  useEffect(() => {
    countRef.current = count;
  });

  const [increase, decrease] = useMemo(() => {
    const increase = () => {
      setCount(countRef.current + 1);
    };

    const decrease = () => {
      setCount(countRef.current - 1);
    };
    return [increase, decrease];
  }, []); // 保持依赖数组为空，这样 increase 和 decrease 方法都只会被创建一次
  return [count, increase, decrease];
};
```

```jsx
function Counter() {
  const [count, increase] = useCount();

  useEffect(() => {
    const handleClick = () => {
      increase(); // 执行后 count 的值永远都是 1    
    };

    document.body.addEventListener("click", handleClick);
    
    return () => {
      document.body.removeEventListener("click", handleClick);
    };
  }, []); 

  return <h1>{count}</h1>;
}
```

## useContext

```js
const C = createContext(null);

function App() {
  console.log("App 执行了");
  const [n, setN] = useState(0);
  return (
    <C.Provider value={{ n, setN }}>
      <div className="App">
        <Baba />
      </div>
    </C.Provider>
  );
}

function Baba() {
  const { n, setN } = useContext(C);
  return (
    <div>
      我是爸爸 n: {n} <Child />
    </div>
  );
}

function Child() {
  const { n, setN } = useContext(C);
  const onClick = () => {
    setN(i => i + 1);
  };
  return (
    <div>
      我是儿子 我得到的 n: {n}
      <button onClick={onClick}>+1</button>
    </div>
  );
}
```

## useReducer

```js
const initial = {
  n: 0
};

const reducer = (state, action) => {
  if (action.type === "add") {
    return { n: state.n + action.number };
  } else if (action.type === "multi") {
    return { n: state.n * 2 };
  } else {
    throw new Error("unknown type");
  }
};

function App() {
  const [state, dispatch] = useReducer(reducer, initial);
  const { n } = state;
  const onClick = () => {
    dispatch({ type: "add", number: 1 });
  };
  const onClick2 = () => {
    dispatch({ type: "add", number: 2 });
  };
  return (
    <div className="App">
      <h1>n: {n}</h1>

      <button onClick={onClick}>+1</button>
      <button onClick={onClick2}>+2</button>
    </div>
  );
}
```

## useRef

```js
export function ReactEcharts(props) {
  const {option, loading} = props
  const container = useRef(null)
  const chart = useRef(null)

  useEffect(() => {
    const width = document.documentElement.clientWidth
    const c = container.current
    console.log(c)
    c.style.width = `${width - 20}px`
    c.style.height = `${(width - 20) * 1.2}px`
    chart.current = echarts.init(c, 'dark')

  }, []) // [] - mounted on first time

  useEffect(() => {
    chart.current.setOption(option)
  }, [option]) // when option change 类似 vue 的 watch

  useEffect(() => {
    if (loading) chart.current.showLoading()
    else chart.current.hideLoading()
  }, [loading])
  return (
    <div ref={container}/>
  )
}
```

## 自定义hooks

```js
const useList = () => {
  const [list, setList] = useState(null);
  useEffect(() => {
    ajax("/list").then(list => {
      setList(list);
    });
  }, []); // [] 确保只在第一次运行
  return {
    list: list,
    setList: setList
  };
};
export default useList;
```

```jsx
function Example() {
  const data = useData();
  const [dataChanged, setDataChanged] = useState(false);

  useEffect(() => {
    setDataChanged((prevDataChanged) => !prevDataChanged); 
    // 当 data 发生变化时，调用 setState。
    // 如果 data 值相同而引用不同，就可能会产生非预期的结果。 
  }, [data]);

  console.log(dataChanged);

  return <ExpensiveComponent data={data} />;
}

const useData = () => {
  // 获取异步数据  
  const resp = getAsyncData([]);

  // 处理获取到的异步数据，这里使用了 Array.map。
  // 因此，即使 data 相同，每次调用得到的引用也是不同的。  
  const mapper = (data) => data.map((item) => ({...item, selected: false}));

  return resp ? mapper(resp) : resp;
};
```

```js
export const useToggle = (defaultVisible: boolean = false) => {
  const [visible, setVisible] = useState(defaultVisible);
  const show = () => setVisible(true);
  const hide = () => setVisible(false);

  return [visible, show, hide] as [typeof visible, typeof show, typeof hide];
};

const [isOpen, open, close] = useToggle(); // 在外部可以更方便地修改名字
const [visible, show, hide] = useToggle();
```
