class Factory extends React.Component{
  constructor(){
    this.state={

    }
  }
  render() {
    return <div>{this.props.render(this.state)}</div>
  }
}
function App(){
  <Factory render={
    /** render是一个函数组件*/
    (props)=><p>{props.a}:{props.b}</p>
  }></Factory>
}