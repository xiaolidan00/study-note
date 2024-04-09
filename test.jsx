class Factory extends React.Component {
  constructor() {
    this.state = {};
  }
  render() {
    return <div>{this.props.render(this.state)}</div>;
  }
}
function App() {
  <Factory
    render={
      /** render是一个函数组件*/
      (props) => (
        <p>
          {props.a}:{props.b}
        </p>
      )
    }
  ></Factory>;
}

class MyComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = { name: 'Hello World' };
  }
  static getDerivedStateFromProps(props, state) {
    console.log('判断数据是否需要更新', props, state);
    return null;
  }
  render() {
    console.log('渲染');
    return <div>{this.state.name}</div>;
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
  componentWillUnmount() {}
}

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
      <button onclick={onClick}>aaa</button>
      <input ref={inputRef} value={user.year} onchange={changeValue} />
    </div>
  );
};
