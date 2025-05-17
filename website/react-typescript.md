# React Typescript

<https://react-typescript-cheatsheet.netlify.app/>

## 定义属性

```ts
type AppProps = {
  message: string;
  count: number;
  disabled: boolean;
  /** array of a type! */
  names: string[];
  /** string literals to specify exact string values, with a union type to join them together */
  status: 'waiting' | 'success';
  /** an object with known properties (but could have more at runtime) */
  obj: {
    id: string;
    title: string;
  };
  /** array of objects! (common) */
  objArr: {
    id: string;
    title: string;
  }[];
  /** any non-primitive value - can't access any properties (NOT COMMON but useful as placeholder) */
  obj2: object;
  /** an interface with no required properties - (NOT COMMON, except for things like `React.Component<{}, State>`) */
  obj3: {};
  /** a dict object with any number of properties of the same type */
  dict1: {
    [key: string]: MyTypeHere;
  };
  dict2: Record<string, MyTypeHere>; // equivalent to dict1
  /** function that doesn't take or return anything (VERY COMMON) */
  onClick: () => void;
  /** function with named prop (VERY COMMON) */
  onChange: (id: number) => void;
  /** function type syntax that takes an event (VERY COMMON) */
  onChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  /** alternative function type syntax that takes an event (VERY COMMON) */
  onClick(event: React.MouseEvent<HTMLButtonElement>): void;
  /** any function as long as you don't invoke it (not recommended) */
  onSomething: Function;
  /** an optional prop (VERY COMMON!) */
  optional?: OptionalType;
  /** when passing down the state setter function returned by `useState` to a child component. `number` is an example, swap out with whatever the type of your state */
  setState: React.Dispatch<React.SetStateAction<number>>;
};

/**
 * React.JSX.Element -> Return value of React.createElement
React.ReactNode -> Return value of a component
 */
export declare interface AppProps {
  children?: React.ReactNode; // best, accepts everything React can render
  childrenElement: React.JSX.Element; // A single React element
  style?: React.CSSProperties; // to pass through style props
  onChange?: React.FormEventHandler<HTMLInputElement>; // form events! the generic parameter is the type of event.target
  //  more info: https://react-typescript-cheatsheet.netlify.app/docs/advanced/patterns_by_usecase/#wrappingmirroring
  props: Props & React.ComponentPropsWithoutRef<'button'>; // to impersonate all the props of a button element and explicitly not forwarding its ref
  props2: Props & React.ComponentPropsWithRef<MyButtonWithForwardRef>; // to impersonate all the props of MyButtonForwardedRef and explicitly forwarding its ref
}
```

## 定义组件

```tsx
// Declaring type of props - see "Typing Component Props" for more examples
type AppProps = {
  message: string;
}; /* use `interface` if exporting so that consumers can extend */

// Easiest way to declare a Function Component; return type is inferred.
const App = ({message}: AppProps) => <div>{message}</div>;

// You can choose to annotate the return type so an error is raised if you accidentally return some other type
const App = ({message}: AppProps): React.JSX.Element => <div>{message}</div>;

// You can also inline the type declaration; eliminates naming the prop types, but looks repetitive
const App = ({message}: {message: string}) => <div>{message}</div>;

// Alternatively, you can use `React.FunctionComponent` (or `React.FC`), if you prefer.
// With latest React types and TypeScript 5.1. it's mostly a stylistic choice, otherwise discouraged.
const App: React.FunctionComponent<{message: string}> = ({message}) => <div>{message}</div>;
// or
const App: React.FC<AppProps> = ({message}) => <div>{message}</div>;
```

## useState

```tsx
const [state, setState] = useState(false);

const [user, setUser] = useState<User | null>(null);

// later...
setUser(newUser);

const [user, setUser] = useState<User>({} as User);

// later...
setUser(newUser);
```

## useCallback

```tsx
const memoizedCallback = useCallback(
  (param1: string, param2: number) => {
    console.log(param1, param2)
    return { ok: true }
  },
  [...],
);
//< React 18
function useCallback<T extends (...args: any[]) => any>(
  callback: T,
  deps: DependencyList
): T;
//>= React 18
function useCallback<T extends Function>(callback: T, deps: DependencyList): T;


useCallback((e) => {}, []);
// Explicit 'any' type.
useCallback((e: any) => {}, []);

```

## useReducer

```tsx
import { useReducer } from "react";

const initialState = { count: 0 };

type ACTIONTYPE =
  | { type: "increment"; payload: number }
  | { type: "decrement"; payload: string };

function reducer(state: typeof initialState, action: ACTIONTYPE) {
  switch (action.type) {
    case "increment":
      return { count: state.count + action.payload };
    case "decrement":
      return { count: state.count - Number(action.payload) };
    default:
      throw new Error();
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, initialState);
  return (
    <>
      Count: {state.count}
      <button onClick={() => dispatch({ type: "decrement", payload: "5" })}>
        -
      </button>
      <button onClick={() => dispatch({ type: "increment", payload: 5 })}>
        +
      </button>
    </>
  );
}


import { Reducer } from 'redux';

export function reducer: Reducer<AppState, Action>() {}
```

## useEffect / useLayoutEffect

```tsx
function DelayedEffect(props: {timerMs: number}) {
  const {timerMs} = props;

  useEffect(
    () =>
      setTimeout(() => {
        /* do stuff */
      }, timerMs),
    [timerMs]
  );
  // bad example! setTimeout implicitly returns a number
  // because the arrow function body isn't wrapped in curly braces
  return null;
}
```

## useRef

```tsx
function Foo() {
  // - If possible, prefer as specific as possible. For example, HTMLDivElement
  //   is better than HTMLElement and way better than Element.
  // - Technical-wise, this returns RefObject<HTMLDivElement>
  const divRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    // Note that ref.current may be null. This is expected, because you may
    // conditionally render the ref-ed element, or you may forget to assign it
    if (!divRef.current) throw Error("divRef is not assigned");

    // Now divRef.current is sure to be HTMLDivElement
    doSomethingWith(divRef.current);
  });

  // Give the ref to an element so React can manage it for you
  return <div ref={divRef}>etc</div>;
}


function Foo() {
  // Technical-wise, this returns MutableRefObject<number | null>
  const intervalRef = useRef<number | null>(null);

  // You manage the ref yourself (that's why it's called MutableRefObject!)
  useEffect(() => {
    intervalRef.current = setInterval(...);
    return () => clearInterval(intervalRef.current);
  }, []);

  // The ref is not passed to any element's "ref" prop
  return <button onClick={/* clearInterval the ref */}>Cancel timer</button>;
}
```

## useImperativeHandle

```tsx
// Countdown.tsx

// Define the handle types which will be passed to the forwardRef
export type CountdownHandle = {
  start: () => void;
};

type CountdownProps = {};

const Countdown = forwardRef<CountdownHandle, CountdownProps>((props, ref) => {
  useImperativeHandle(ref, () => ({
    // start() has type inference here
    start() {
      alert('Start');
    }
  }));

  return <div>Countdown</div>;
});

// The component uses the Countdown component

import Countdown, {CountdownHandle} from './Countdown.tsx';

function App() {
  const countdownEl = useRef<CountdownHandle>(null);

  useEffect(() => {
    if (countdownEl.current) {
      // start() has type inference here as well
      countdownEl.current.start();
    }
  }, []);

  return <Countdown ref={countdownEl} />;
}
```

## 自定义 hooks

```tsx
import {useState} from 'react';

export function useLoading() {
  const [isLoading, setState] = useState(false);
  const load = (aPromise: Promise<any>) => {
    setState(true);
    return aPromise.finally(() => setState(false));
  };
  return [isLoading, load] as const; // infers [boolean, typeof load] instead of (boolean | typeof load)[]
}

import {useState} from 'react';

export function useLoading() {
  const [isLoading, setState] = useState(false);
  const load = (aPromise: Promise<any>) => {
    setState(true);
    return aPromise.finally(() => setState(false));
  };
  return [isLoading, load] as [boolean, (aPromise: Promise<any>) => Promise<any>];
}

function tuplify<T extends any[]>(...elements: T) {
  return elements;
}

function useArray() {
  const numberValue = useRef(3).current;
  const functionValue = useRef(() => {}).current;
  return [numberValue, functionValue]; // type is (number | (() => void))[]
}

function useTuple() {
  const numberValue = useRef(3).current;
  const functionValue = useRef(() => {}).current;
  return tuplify(numberValue, functionValue); // type is [number, () => void]
}
```

## Class 组件

```tsx
type MyProps = {
  // using `interface` is also ok
  message: string;
};
type MyState = {
  count: number; // like this
};
class App extends React.Component<MyProps, MyState> {
  state: MyState = {
    // optional second annotation for better type inference
    count: 0
  };
  render() {
    return (
      <div>
        {this.props.message} {this.state.count}
      </div>
    );
  }
}

type MyProps = {
  readonly message: string;
};
type MyState = {
  readonly count: number;
};

class App extends React.Component<{message: string}, {count: number}> {
  state = {count: 0};
  render() {
    return (
      <div onClick={() => this.increment(1)}>
        {this.props.message} {this.state.count}
      </div>
    );
  }
  increment = (amt: number) => {
    // like this
    this.setState((state) => ({
      count: state.count + amt
    }));
  };
}

class App extends React.Component<{
  message: string;
}> {
  pointer: number; // like this
  componentDidMount() {
    this.pointer = 3;
  }
  render() {
    return (
      <div>
        {this.props.message} and {this.pointer}
      </div>
    );
  }
}

class Comp extends React.Component<Props, State> {
  static getDerivedStateFromProps(props: Props, state: State): Partial<State> | null {
    //
  }
}

class Comp extends React.Component<Props, ReturnType<(typeof Comp)['getDerivedStateFromProps']>> {
  static getDerivedStateFromProps(props: Props) {}
}

//缓存 state和props
type CustomValue = any;
interface Props {
  propA: CustomValue;
}
interface DefinedState {
  otherStateField: string;
}
type State = DefinedState & ReturnType<typeof transformPropsToState>;
function transformPropsToState(props: Props) {
  return {
    savedPropA: props.propA, // save for memoization
    derivedState: props.propA
  };
}
class Comp extends React.PureComponent<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      otherStateField: '123',
      ...transformPropsToState(props)
    };
  }
  static getDerivedStateFromProps(props: Props, state: State) {
    if (isEqual(props.propA, state.savedPropA)) return null;
    return transformPropsToState(props);
  }
}
```

## 默认属性

```tsx
type GreetProps = { age?: number };

const Greet = ({ age = 21 }: GreetProps) => // etc



type GreetProps = {
  age?: number;
};

class Greet extends React.Component<GreetProps> {
  render() {
    const { age = 21 } = this.props;
    /*...*/
  }
}

let el = <Greet age={3} />;



// using typeof as a shortcut; note that it hoists!
// you can also declare the type of DefaultProps if you choose
// e.g. https://github.com/typescript-cheatsheets/react/issues/415#issuecomment-841223219
type GreetProps = { age: number } & typeof defaultProps;

const defaultProps = {
  age: 21,
};

const Greet = (props: GreetProps) => {
  // etc
};
Greet.defaultProps = defaultProps;




type GreetProps = typeof Greet.defaultProps & {
  age: number;
};

class Greet extends React.Component<GreetProps> {
  static defaultProps = {
    age: 21,
  };
  /*...*/
}

// Type-checks! No type assertions needed!
let el = <Greet age={3} />;

// internal contract, should not be exported out
type GreetProps = {
  age: number;
};

class Greet extends Component<GreetProps> {
  static defaultProps = { age: 21 };
}

// external contract
export type ApparentGreetProps = React.JSX.LibraryManagedAttributes<
  typeof Greet,
  GreetProps
>;



interface IProps {
  name: string;
}
const defaultProps = {
  age: 25,
};
const GreetComponent = ({ name, age }: IProps & typeof defaultProps) => (
  <div>{`Hello, my name is ${name}, ${age}`}</div>
);
GreetComponent.defaultProps = defaultProps;

const TestComponent = (props: React.ComponentProps<typeof GreetComponent>) => {
  return <h1 />;
};

// Property 'age' is missing in type '{ name: string; }' but required in type '{ age: number; }'
const el = <TestComponent name="foo" />;



type ComponentProps<T> = T extends
  | React.ComponentType<infer P>
  | React.Component<infer P>
  ? React.JSX.LibraryManagedAttributes<T, P>
  : never;

const TestComponent = (props: ComponentProps<typeof GreetComponent>) => {
  return <h1 />;
};

// No error
const el = <TestComponent name="foo" />;


//可选属性
interface IMyComponentProps {
  firstProp?: string;
  secondProp: IPerson[];
}

export class MyComponent extends React.Component<IMyComponentProps> {
  public static defaultProps: Partial<IMyComponentProps> = {
    firstProp: "default",
  };
}
```

## Event 事件

```tsx
type State = {
  text: string;
};
class App extends React.Component<Props, State> {
  state = {
    text: ''
  };

  // typing on RIGHT hand side of =
  onChange = (e: React.FormEvent<HTMLInputElement>): void => {
    this.setState({text: e.currentTarget.value});
  };
  render() {
    return (
      <div>
        <input type="text" value={this.state.text} onChange={this.onChange} />
      </div>
    );
  }
}

// typing on LEFT hand side of =
onChange: React.ChangeEventHandler<HTMLInputElement> = (e) => {
  this.setState({text: e.currentTarget.value});
};

<form
  ref={formRef}
  onSubmit={(e: React.SyntheticEvent) => {
    e.preventDefault();
    const target = e.target as typeof e.target & {
      email: {value: string};
      password: {value: string};
    };
    const email = target.email.value; // typechecks!
    const password = target.password.value; // typechecks!
    // etc...
  }}
>
  <div>
    <label>
      Email:
      <input type="email" name="email" />
    </label>
  </div>
  <div>
    <label>
      Password:
      <input type="password" name="password" />
    </label>
  </div>
  <div>
    <input type="submit" value="Log in" />
  </div>
</form>;
```

| Event Type       | Description                                                                                                                                                                                                                                                            |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AnimationEvent   | CSS Animations.                                                                                                                                                                                                                                                        |
| ChangeEvent      | Changing the value of `<input>`, `<select>` and `<textarea>` element.                                                                                                                                                                                                  |
| ClipboardEvent   | Using copy, paste and cut events.                                                                                                                                                                                                                                      |
| CompositionEvent | Events that occur due to the user indirectly entering text (e.g. depending on Browser and PC setup, a popup window may appear with additional characters if you e.g. want to type Japanese on a US Keyboard)                                                           |
| DragEvent        | Drag and drop interaction with a pointer device (e.g. mouse).                                                                                                                                                                                                          |
| FocusEvent       | Event that occurs when elements gets or loses focus.                                                                                                                                                                                                                   |
| FormEvent        | Event that occurs whenever a form or form element gets/loses focus, a form element value is changed or the form is submitted.                                                                                                                                          |
| InvalidEvent     | Fired when validity restrictions of an input fails (e.g `<input type="number" max="10">` and someone would insert number 20).                                                                                                                                          |
| KeyboardEvent    | User interaction with the keyboard. Each event describes a single key interaction.                                                                                                                                                                                     |
| MouseEvent       | Events that occur due to the user interacting with a pointing device (e.g. mouse)                                                                                                                                                                                      |
| PointerEvent     | Events that occur due to user interaction with a variety pointing of devices such as mouse, pen/stylus, a touchscreen and which also supports multi-touch. Unless you develop for older browsers (IE10 or Safari 12), pointer events are recommended. Extends UIEvent. |
| TouchEvent       | Events that occur due to the user interacting with a touch device. Extends UIEvent.                                                                                                                                                                                    |
| TransitionEvent  | CSS Transition. Not fully browser supported. Extends UIEvent                                                                                                                                                                                                           |
| UIEvent          | Base Event for Mouse, Touch and Pointer events.                                                                                                                                                                                                                        |
| WheelEvent       | Scrolling on a mouse wheel or similar input device. (Note: `wheel` event should not be confused with the `scroll` event)                                                                                                                                               |
| SyntheticEvent   | The base event for all above events. Should be used when unsure about event type                                                                                                                                                                                       |

## Context

```tsx
import {createContext} from 'react';

type ThemeContextType = 'light' | 'dark';

const ThemeContext = createContext<ThemeContextType>('light');

import {useState} from 'react';

const App = () => {
  const [theme, setTheme] = useState<ThemeContextType>('light');

  return (
    <ThemeContext.Provider value={theme}>
      <MyComponent />
    </ThemeContext.Provider>
  );
};

import {useContext} from 'react';

const MyComponent = () => {
  const theme = useContext(ThemeContext);

  return <p>The current theme is {theme}.</p>;
};

//空值context
import {createContext} from 'react';

interface CurrentUserContextType {
  username: string;
}

const CurrentUserContext = createContext<CurrentUserContextType | null>(null);

const App = () => {
  const [currentUser, setCurrentUser] = useState<CurrentUserContextType>({
    username: 'filiptammergard'
  });

  return (
    <CurrentUserContext.Provider value={currentUser}>
      <MyComponent />
    </CurrentUserContext.Provider>
  );
};

import {useContext} from 'react';

const MyComponent = () => {
  const currentUser = useContext(CurrentUserContext);

  return <p>Name: {currentUser?.username}.</p>;
};

//hooks形式使用
import {createContext} from 'react';

interface CurrentUserContextType {
  username: string;
}

const CurrentUserContext = createContext<CurrentUserContextType | null>(null);

const useCurrentUser = () => {
  const currentUserContext = useContext(CurrentUserContext);

  if (!currentUserContext) {
    throw new Error('useCurrentUser has to be used within <CurrentUserContext.Provider>');
  }

  return currentUserContext;
};

import {useContext} from 'react';

const MyComponent = () => {
  const currentUser = useCurrentUser();

  return <p>Username: {currentUser.username}.</p>;
};

import {useContext} from 'react';

const MyComponent = () => {
  const currentUser = useContext(CurrentUserContext);

  return <p>Name: {currentUser!.username}.</p>;
};

const CurrentUserContext = createContext<CurrentUserContextType>({} as CurrentUserContextType);
const CurrentUserContext = createContext<CurrentUserContextType>(null!);
```

## forwardRef/createRef

```tsx
import {createRef, PureComponent} from 'react';

class CssThemeProvider extends PureComponent<Props> {
  private rootRef = createRef<HTMLDivElement>(); // like this
  render() {
    return <div ref={this.rootRef}>{this.props.children}</div>;
  }
}

import {forwardRef, ReactNode} from 'react';

interface Props {
  children?: ReactNode;
  type: 'submit' | 'button';
}
export type Ref = HTMLButtonElement;

export const FancyButton = forwardRef<Ref, Props>((props, ref) => (
  <button ref={ref} className="MyClassName" type={props.type}>
    {props.children}
  </button>
));

import {forwardRef, ReactNode, Ref} from 'react';

interface Props {
  children?: ReactNode;
  type: 'submit' | 'button';
}

export const FancyButton = forwardRef(
  (
    props: Props,
    ref: Ref<HTMLButtonElement> // <-- here!
  ) => (
    <button ref={ref} className="MyClassName" type={props.type}>
      {props.children}
    </button>
  )
);

type ClickableListProps<T> = {
  items: T[];
  onSelect: (item: T) => void;
  mRef?: React.Ref<HTMLUListElement> | null;
};

export function ClickableList<T>(props: ClickableListProps<T>) {
  return (
    <ul ref={props.mRef}>
      {props.items.map((item, i) => (
        <li key={i}>
          <button onClick={(el) => props.onSelect(item)}>Select</button>
          {item}
        </li>
      ))}
    </ul>
  );
}

// Redeclare forwardRef
declare module 'react' {
  function forwardRef<T, P = {}>(
    render: (props: P, ref: React.Ref<T>) => React.ReactElement | null
  ): (props: P & React.RefAttributes<T>) => React.ReactElement | null;
}

// Just write your components like you're used to!
import {forwardRef, ForwardedRef} from 'react';

interface ClickableListProps<T> {
  items: T[];
  onSelect: (item: T) => void;
}

function ClickableListInner<T>(props: ClickableListProps<T>, ref: ForwardedRef<HTMLUListElement>) {
  return (
    <ul ref={ref}>
      {props.items.map((item, i) => (
        <li key={i}>
          <button onClick={(el) => props.onSelect(item)}>Select</button>
          {item}
        </li>
      ))}
    </ul>
  );
}

export const ClickableList = forwardRef(ClickableListInner);

// Redeclare forwardRef
declare module 'react' {
  function forwardRef<T, P = {}>(
    render: (props: P, ref: React.Ref<T>) => React.ReactElement | null
  ): (props: P & React.RefAttributes<T>) => React.ReactElement | null;
}

// Just write your components like you're used to!
import {forwardRef, ForwardedRef} from 'react';

interface ClickableListProps<T> {
  items: T[];
  onSelect: (item: T) => void;
}

function ClickableListInner<T>(props: ClickableListProps<T>, ref: ForwardedRef<HTMLUListElement>) {
  return (
    <ul ref={ref}>
      {props.items.map((item, i) => (
        <li key={i}>
          <button onClick={(el) => props.onSelect(item)}>Select</button>
          {item}
        </li>
      ))}
    </ul>
  );
}

export const ClickableList = forwardRef(ClickableListInner);

// Add to `index.d.ts`
interface ForwardRefWithGenerics extends React.FC<WithForwardRefProps<Option>> {
  <T extends Option>(props: WithForwardRefProps<T>): ReturnType<React.FC<WithForwardRefProps<T>>>;
}

export const ClickableListWithForwardRef: ForwardRefWithGenerics = forwardRef(ClickableList);
```

## Portals

```ts
const modalRoot = document.getElementById('modal-root') as HTMLElement;
// assuming in your html file has a div with id 'modal-root';

export class Modal extends React.Component<{children?: React.ReactNode}> {
  el: HTMLElement = document.createElement('div');

  componentDidMount() {
    modalRoot.appendChild(this.el);
  }

  componentWillUnmount() {
    modalRoot.removeChild(this.el);
  }

  render() {
    return ReactDOM.createPortal(this.props.children, this.el);
  }
}

//hooks

import {useEffect, useRef, ReactNode} from 'react';
import {createPortal} from 'react-dom';

const modalRoot = document.querySelector('#modal-root') as HTMLElement;

type ModalProps = {
  children: ReactNode;
};

function Modal({children}: ModalProps) {
  // create div element only once using ref
  const elRef = useRef<HTMLDivElement | null>(null);
  if (!elRef.current) elRef.current = document.createElement('div');

  useEffect(() => {
    const el = elRef.current!; // non-null assertion because it will never be null
    modalRoot.appendChild(el);
    return () => {
      modalRoot.removeChild(el);
    };
  }, []);

  return createPortal(children, elRef.current);
}

//使用

import {useState} from 'react';

function App() {
  const [showModal, setShowModal] = useState(false);

  return (
    <div>
      // you can also put this in your static html file
      <div id="modal-root"></div>
      {showModal && (
        <Modal>
          <div
            style={{
              display: 'grid',
              placeItems: 'center',
              height: '100vh',
              width: '100vh',
              background: 'rgba(0,0,0,0.1)',
              zIndex: 99
            }}
          >
            I'm a modal!{' '}
            <button style={{background: 'papyawhip'}} onClick={() => setShowModal(false)}>
              close
            </button>
          </div>
        </Modal>
      )}
      <button onClick={() => setShowModal(true)}>show Modal</button>
      // rest of your app
    </div>
  );
}
```

## 错误边界

```tsx
import React, {Component, ErrorInfo, ReactNode} from 'react';

interface Props {
  children?: ReactNode;
}

interface State {
  hasError: boolean;
}

class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false
  };

  public static getDerivedStateFromError(_: Error): State {
    // Update state so the next render will show the fallback UI.
    return {hasError: true};
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return <h1>Sorry.. there was an error</h1>;
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

## 类型

```tsx
class App extends React.Component<
  {},
  {
    count: number | null; // like this
  }
> {
  state = {
    count: null,
  };
  render() {
    return <div onClick={() => this.increment(1)}>{this.state.count}</div>;
  }
  increment = (amt: number) => {
    this.setState((state) => ({
      count: (state.count || 0) + amt,
    }));
  };
}



interface Admin {
  role: string;
}
interface User {
  email: string;
}

// Method 1: use `in` keyword
function redirect(user: Admin | User) {
  if ("role" in user) {
    // use the `in` operator for typeguards since TS 2.7+
    routeToAdminPage(user.role);
  } else {
    routeToHomePage(user.email);
  }
}

// Method 2: custom type guard, does the same thing in older TS versions or where `in` isnt enough
function isAdmin(user: Admin | User): user is Admin {
  return (user as any).role !== undefined;
}



class MyComponent extends React.Component<{
  message?: string; // like this
}> {
  render() {
    const { message = "default" } = this.props;
    return <div>{message}</div>;
  }
}


export declare type Position = "left" | "right" | "top" | "bottom";

export enum ButtonSizes {
  default = "default",
  small = "small",
  large = "large",
}

// usage
export const PrimaryButton = (
  props: Props & React.HTMLProps<HTMLButtonElement>
) => <Button size={ButtonSizes.default} {...props} />;


class MyComponent extends React.Component<{
  message: string;
}> {
  render() {
    const { message } = this.props;
    return (
      <Component2 message={message as SpecialMessageType}>{message}</Component2>
    );
  }
}

element.parentNode!.removeChild(element); // ! before the period
myFunction(document.getElementById(dialog.id!)!); // ! after the property accessing
let userID!: string; // definite assignment assertion... be careful!



type OrderID = string & { readonly brand: unique symbol };
type UserID = string & { readonly brand: unique symbol };
type ID = OrderID | UserID;


function OrderID(id: string) {
  return id as OrderID;
}
function UserID(id: string) {
  return id as UserID;
}

function queryForUser(id: UserID) {
  // ...
}
queryForUser(OrderID("foobar")); // Error, Argument of type 'OrderID' is not assignable to parameter of type 'UserID'

export interface PrimaryButtonProps {
  label: string;
}
export const PrimaryButton = (
  props: PrimaryButtonProps & React.ButtonHTMLAttributes<HTMLButtonElement>
) => {
  // do custom buttony stuff
  return <button {...props}> {props.label} </button>;
};



type BaseProps = {
   className?: string,
   style?: React.CSSProperties
   name: string // used in both
}
type DogProps = {
  tailsCount: number
}
type HumanProps = {
  handsCount: number
}
export const Human = (props: BaseProps & HumanProps) => // ...
export const Dog = (props: BaseProps & DogProps) => // ...


//重载
function pickCard(x: { suit: string; card: number }[]): number;
function pickCard(x: number): { suit: string; card: number };
function pickCard(x): any {
  // implementation with combined signature
  // ...
}

type pickCard = {
  (x: { suit: string; card: number }[]): number;
  (x: number): { suit: string; card: number };
  // no need for combined signature in this form
  // you can also type static properties of functions here eg `pickCard.wasCalled`
};


const [state, setState] = useState({
  foo: 1,
  bar: 2,
}); // state's type inferred to be {foo: number, bar: number}

const someMethod = (obj: typeof state) => {
  // grabbing the type of state even though it was inferred
  // some code using obj
  setState(obj); // this works
};


const partialStateUpdate = (obj: Partial<typeof state>) =>
  setState({ ...state, ...obj });

// later on...
partialStateUpdate({ foo: 2 }); // this works



import { Button } from "library"; // but doesn't export ButtonProps! oh no!
type ButtonProps = React.ComponentProps<typeof Button>; // no problem! grab your own!
type AlertButtonProps = Omit<ButtonProps, "onClick">; // modify
const AlertButton = (props: AlertButtonProps) => (
  <Button onClick={() => alert("hello")} {...props} />
);


// inside some library - return type { baz: number } is inferred but not exported
function foo(bar: string) {
  return { baz: 1 };
}

//  inside your app, if you need { baz: number }
type FooReturn = ReturnType<typeof foo>; // { baz: number }



function foo() {
  return {
    a: 1,
    b: 2,
    subInstArr: [
      {
        c: 3,
        d: 4,
      },
    ],
  };
}

type InstType = ReturnType<typeof foo>;
type SubInstArr = InstType["subInstArr"];
type SubInstType = SubInstArr[0];

let baz: SubInstType = {
  c: 5,
  d: 6, // type checks ok!
};

//You could just write a one-liner,
//But please make sure it is forward-readable
//(you can understand it from reading once left-to-right with no jumps)
type SubInstType2 = ReturnType<typeof foo>["subInstArr"][0];
let baz2: SubInstType2 = {
  c: 5,
  d: 6, // type checks ok!
};
```

## d.ts 生成

```bash
npm install -g dts-gen
dts-gen -m <your-module>
```

```ts
// ...
const useUntypedHook = (prop) => {
  // some processing happens here
  return {
    /* ReturnProps */
  };
};
export default useUntypedHook;
```

```ts
declare module 'use-untyped-hook' {
  export interface InputProps { ... }   // type declaration for prop
  export interface ReturnProps { ... } // type declaration for return props
  export default function useUntypedHook(
    prop: InputProps
    // ...
  ): ReturnProps;
}
```

```ts
// inside src/index.js
const useDarkMode = (
  initialValue = false, // -> input props / config props to be exported
  {
    // -> input props / config props to be exported
    element,
    classNameDark,
    classNameLight,
    onChange,
    storageKey = 'darkMode',
    storageProvider,
    global
  } = {}
) => {
  // ...
  return {
    // -> return props to be exported
    value: state,
    enable: useCallback(() => setState(true), [setState]),
    disable: useCallback(() => setState(false), [setState]),
    toggle: useCallback(() => setState((current) => !current), [setState])
  };
};
export default useDarkMode;
```

```ts
declare module 'use-dark-mode' {
  /**
   * A config object allowing you to specify certain aspects of `useDarkMode`
   */
  export interface DarkModeConfig {
    classNameDark?: string; // A className to set "dark mode". Default = "dark-mode".
    classNameLight?: string; // A className to set "light mode". Default = "light-mode".
    element?: HTMLElement; // The element to apply the className. Default = `document.body`
    onChange?: (val?: boolean) => void; // Override the default className handler with a custom callback.
    storageKey?: string; // Specify the `localStorage` key. Default = "darkMode". Set to `null` to disable persistent storage.
    storageProvider?: WindowLocalStorage; // A storage provider. Default = `localStorage`.
    global?: Window; // The global object. Default = `window`.
  }
  /**
   * An object returned from a call to `useDarkMode`.
   */
  export interface DarkMode {
    readonly value: boolean;
    enable: () => void;
    disable: () => void;
    toggle: () => void;
  }
  /**
   * A custom React Hook to help you implement a "dark mode" component for your application.
   */
  export default function useDarkMode(initialState?: boolean, config?: DarkModeConfig): DarkMode;
}
```

```ts
declare module "react-router-dom" {
  import * as React from 'react';
  // ...
  type NavigateProps<T> = {
    to: string | number,
    replace?: boolean,
    state?: T
  }
  //...
  export class Navigate<T = any> extends React.Component<NavigateProps<T>>{}
  // ...
```

## global

```tsx
declare global {
  interface Window {
    MyVendorThing: MyVendorType;
  }
}

// declaration.d.ts
// anywhere in your project, NOT the same name as any of your .ts/tsx files
declare module '*.png';

// importing in a tsx file
import * as logo from './logo.png';

declare module '*.module.scss' {
  const classes: {[key: string]: string};
  export default classes;
}

import styles from './index.module.scss';
<div className={styles.container}></div>;
```

## tsconfig.json

```json
{
  "compilerOptions": {
    "incremental": true,
    "outDir": "build/lib",
    "target": "es5",
    "module": "esnext",
    "lib": ["DOM", "ESNext"],
    "sourceMap": true,
    "importHelpers": true,
    "declaration": true,
    "rootDir": "src",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "allowJs": false,
    "jsx": "react",
    "moduleResolution": "node",
    "baseUrl": "src",
    "forceConsistentCasingInFileNames": true,
    "esModuleInterop": true,
    "suppressImplicitAnyIndexErrors": true,
    "allowSyntheticDefaultImports": true,
    "experimentalDecorators": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "build", "scripts"]
}
```

```json
{
  "compilerOptions": {
    "paths": {
      "mobx-react": ["../typings/modules/mobx-react"]
    }
  }
}
```

## process.env

```ts
// ambient utility type
type ToArray<T> = T extends unknown[] ? T : T[];
// ambient variable
declare let process: {
  env: {
    NODE_ENV: 'development' | 'production';
  };
};
process = {
  env: {
    NODE_ENV: 'production'
  }
};
```

## vite-env.d.ts

```ts
/// <reference types="vite/client" />

interface ViteTypeOptions {
  // 添加这行代码，你就可以将 ImportMetaEnv 的类型设为严格模式，
  // 这样就不允许有未知的键值了。
  // strictImportMetaEnv: unknown
}

interface ImportMetaEnv {
  readonly MODE: 'development' | 'production';
  // 更多环境变量...
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
```

## eslint

```bash
pnpm add -D @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint
```

```json
{
  "scripts": {
    "lint": "eslint 'src/**/*.ts'"
  }
}
```

.eslintrc.js

```js
module.exports = {
  env: {
    es6: true,
    node: true,
    jest: true
  },
  extends: 'eslint:recommended',
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  rules: {
    indent: ['error', 2],
    'linebreak-style': ['error', 'unix'],
    quotes: ['error', 'single'],
    'no-console': 'warn',
    'no-unused-vars': 'off',
    '@typescript-eslint/no-unused-vars': [
      'error',
      {vars: 'all', args: 'after-used', ignoreRestSiblings: false}
    ],
    '@typescript-eslint/explicit-function-return-type': 'warn', // Consider using explicit annotations for object literals and function return types even when they can be inferred.
    'no-empty': 'warn'
  }
};
```

.eslintrc.json

```json
{
  "extends": [
    "airbnb",
    "prettier",
    "prettier/react",
    "plugin:prettier/recommended",
    "plugin:jest/recommended",
    "plugin:unicorn/recommended"
  ],
  "plugins": ["prettier", "jest", "unicorn"],
  "parserOptions": {
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "env": {
    "es6": true,
    "browser": true,
    "jest": true
  },
  "settings": {
    "import/resolver": {
      "node": {
        "extensions": [".js", ".jsx", ".ts", ".tsx"]
      }
    }
  },
  "overrides": [
    {
      "files": ["**/*.ts", "**/*.tsx"],
      "parser": "typescript-eslint-parser",
      "rules": {
        "no-undef": "off"
      }
    }
  ]
}
```

## HOC

```tsx
type PropsAreEqual<P> = (prevProps: Readonly<P>, nextProps: Readonly<P>) => boolean;

const withSampleHoC = <P extends {}>(
  component: {
    (props: P): Exclude<React.ReactNode, undefined>;
    displayName?: string;
  },
  propsAreEqual?: PropsAreEqual<P> | false,

  componentName = component.displayName ?? component.name
): {
  (props: P): React.JSX.Element;
  displayName: string;
} => {
  function WithSampleHoc(props: P) {
    //Do something special to justify the HoC.
    return component(props) as React.JSX.Element;
  }

  WithSampleHoc.displayName = `withSampleHoC(${componentName})`;

  let wrappedComponent =
    propsAreEqual === false ? WithSampleHoc : React.memo(WithSampleHoc, propsAreEqual);

  //copyStaticProperties(component, wrappedComponent);

  return wrappedComponent as typeof WithSampleHoc;
};
```

```tsx
interface Props extends WithThemeProps {
  children?: React.ReactNode;
}

class MyButton extends React.Component<Props> {
  public render() {
    // Render an the element using the theme and other props.
  }

  private someInternalMethod() {
    // The theme values are also available as props here.
  }
}

export default withTheme(MyButton);
```

```tsx
export function withTheme<T extends WithThemeProps = WithThemeProps>(
  WrappedComponent: React.ComponentType<T>
) {
  // Try to create a nice displayName for React Dev Tools.
  const displayName = WrappedComponent.displayName || WrappedComponent.name || 'Component';

  // Creating the inner component. The calculated Props type here is the where the magic happens.
  const ComponentWithTheme = (props: Omit<T, keyof WithThemeProps>) => {
    // Fetch the props you want to inject. This could be done with context instead.
    const themeProps = useTheme();

    // props comes afterwards so the can override the default ones.
    return <WrappedComponent {...themeProps} {...(props as T)} />;
  };

  ComponentWithTheme.displayName = `withTheme(${displayName})`;

  return ComponentWithTheme;
}
```

```tsx
// inject static values to a component so that they're always provided
export function inject<TProps, TInjectedKeys extends keyof TProps>(
  Component: React.JSXElementConstructor<TProps>,
  injector: Pick<TProps, TInjectedKeys>
) {
  return function Injected(props: Omit<TProps, TInjectedKeys>) {
    return <Component {...(props as TProps)} {...injector} />;
  };
}
```

```tsx
/** dummy child components that take anything */
const Comment = (_: any) => null;
const TextBlock = Comment;

/** dummy Data */
type CommentType = {text: string; id: number};
const comments: CommentType[] = [
  {
    text: 'comment1',
    id: 1
  },
  {
    text: 'comment2',
    id: 2
  }
];
const blog = 'blogpost';

/** mock data source */
const DataSource = {
  addChangeListener(e: Function) {
    // do something
  },
  removeChangeListener(e: Function) {
    // do something
  },
  getComments() {
    return comments;
  },
  getBlogPost(id: number) {
    return blog;
  }
};
/** type aliases just to deduplicate */
type DataType = typeof DataSource;
// type TODO_ANY = any;

/** utility types we use */
type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
// type Optionalize<T extends K, K> = Omit<T, keyof K>;

/** Rewritten Components from the React docs that just uses injected data prop */
function CommentList({data}: WithDataProps<typeof comments>) {
  return (
    <div>
      {data.map((comment: CommentType) => (
        <Comment comment={comment} key={comment.id} />
      ))}
    </div>
  );
}
interface BlogPostProps extends WithDataProps<string> {
  id: number;
}
function BlogPost({data, id}: BlogPostProps) {
  return (
    <div key={id}>
      <TextBlock text={data} />;
    </div>
  );
}
```

```tsx
// these are the props to be injected by the HOC
interface WithDataProps<T> {
  data: T; // data is generic
}
// T is the type of data
// P is the props of the wrapped component that is inferred
// C is the actual interface of the wrapped component (used to grab defaultProps from it)
export function withSubscription<T, P extends WithDataProps<T>, C>(
  // this type allows us to infer P, but grab the type of WrappedComponent separately without it interfering with the inference of P
  WrappedComponent: React.JSXElementConstructor<P> & C,
  // selectData is a functor for T
  // props is Readonly because it's readonly inside of the class
  selectData: (
    dataSource: typeof DataSource,
    props: Readonly<React.JSX.LibraryManagedAttributes<C, Omit<P, 'data'>>>
  ) => T
) {
  // the magic is here: React.JSX.LibraryManagedAttributes will take the type of WrapedComponent and resolve its default props
  // against the props of WithData, which is just the original P type with 'data' removed from its requirements
  type Props = React.JSX.LibraryManagedAttributes<C, Omit<P, 'data'>>;
  type State = {
    data: T;
  };
  return class WithData extends React.Component<Props, State> {
    constructor(props: Props) {
      super(props);
      this.handleChange = this.handleChange.bind(this);
      this.state = {
        data: selectData(DataSource, props)
      };
    }

    componentDidMount = () => DataSource.addChangeListener(this.handleChange);

    componentWillUnmount = () => DataSource.removeChangeListener(this.handleChange);

    handleChange = () =>
      this.setState({
        data: selectData(DataSource, this.props)
      });

    render() {
      // the typing for spreading this.props is... very complex. best way right now is to just type it as any
      // data will still be typechecked
      return <WrappedComponent data={this.state.data} {...(this.props as any)} />;
    }
  };
  // return WithData;
}

/** HOC usage with Components */
export const CommentListWithSubscription = withSubscription(CommentList, (DataSource: DataType) =>
  DataSource.getComments()
);

export const BlogPostWithSubscription = withSubscription(
  BlogPost,
  (DataSource: DataType, props: Omit<BlogPostProps, 'data'>) => DataSource.getBlogPost(props.id)
);
```

```tsx
function logProps<T>(WrappedComponent: React.ComponentType<T>) {
  return class extends React.Component {
    componentWillReceiveProps(nextProps: React.ComponentProps<typeof WrappedComponent>) {
      console.log('Current props: ', this.props);
      console.log('Next props: ', nextProps);
    }
    render() {
      // Wraps the input component in a container, without mutating it. Good!
      return <WrappedComponent {...(this.props as T)} />;
    }
  };
}
```

```tsx
/** utility types we use */
type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

/** dummy Data */
type CommentType = {text: string; id: number};
const comments: CommentType[] = [
  {
    text: 'comment1',
    id: 1
  },
  {
    text: 'comment2',
    id: 2
  }
];
/** dummy child components that take anything */
const Comment = (_: any) => null;
/** Rewritten Components from the React docs that just uses injected data prop */
function CommentList({data}: WithSubscriptionProps<typeof comments>) {
  return (
    <div>
      {data.map((comment: CommentType) => (
        <Comment comment={comment} key={comment.id} />
      ))}
    </div>
  );
}
```

```tsx
const commentSelector = (_: any, ownProps: any) => ({
  id: ownProps.id
});
const commentActions = () => ({
  addComment: (str: string) => comments.push({text: str, id: comments.length})
});

const ConnectedComment = connect(commentSelector, commentActions)(CommentList);

// these are the props to be injected by the HOC
interface WithSubscriptionProps<T> {
  data: T;
}
function connect(mapStateToProps: Function, mapDispatchToProps: Function) {
  return function <T, P extends WithSubscriptionProps<T>, C>(
    WrappedComponent: React.ComponentType<T>
  ) {
    type Props = React.JSX.LibraryManagedAttributes<C, Omit<P, 'data'>>;
    // Creating the inner component. The calculated Props type here is the where the magic happens.
    return class ComponentWithTheme extends React.Component<Props> {
      public render() {
        // Fetch the props you want inject. This could be done with context instead.
        const mappedStateProps = mapStateToProps(this.state, this.props);
        const mappedDispatchProps = mapDispatchToProps(this.state, this.props);
        // this.props comes afterwards so the can override the default ones.
        return <WrappedComponent {...this.props} {...mappedStateProps} {...mappedDispatchProps} />;
      }
    };
  };
}
```

```tsx
interface WithSubscriptionProps {
  data: any;
}

function withSubscription<T extends WithSubscriptionProps = WithSubscriptionProps>(
  WrappedComponent: React.ComponentType<T>
) {
  class WithSubscription extends React.Component {
    /* ... */
    public static displayName = `WithSubscription(${getDisplayName(WrappedComponent)})`;
  }
  return WithSubscription;
}

function getDisplayName<T>(WrappedComponent: React.ComponentType<T>) {
  return WrappedComponent.displayName || WrappedComponent.name || 'Component';
}
```

```tsx
type DogProps {
  name: string
  owner: string
}
function Dog({name, owner}: DogProps) {
  return <div> Woof: {name}, Owner: {owner}</div>
}

const OwnedDog = withOwner("swyx")(Dog);

typeof OwnedDog; // we want this to be equal to { name: string }

<Dog name="fido" owner="swyx" />; // this should be fine
<OwnedDog name="fido" owner="swyx" />; // this should have a typeError
<OwnedDog name="fido" />; // this should be fine

// and the HOC should be reusable for completely different prop types!

type CatProps = {
  lives: number;
  owner: string;
};
function Cat({ lives, owner }: CatProps) {
  return (
    <div>
      {" "}
      Meow: {lives}, Owner: {owner}
    </div>
  );
}

const OwnedCat = withOwner("swyx")(Cat);

<Cat lives={9} owner="swyx" />; // this should be fine
<OwnedCat lives={9} owner="swyx" />; // this should have a typeError
<OwnedCat lives={9} />; // this should be fine


function withOwner(owner: string) {
  return function <T extends { owner: string }>(
    Component: React.ComponentType<T>
  ) {
    return function (props: Omit<T, "owner">): React.JSX.Element {
      const newProps = { ...props, owner } as T;
      return <Component {...newProps} />;
    };
  };
}


function withInjectedProps<U extends Record<string, unknown>>(
  injectedProps: U
) {
  return function <T extends U>(Component: React.ComponentType<T>) {
    return function (props: Omit<T, keyof U>): React.JSX.Element {
      //A type coercion is necessary because TypeScript doesn't know that the Omit<T, keyof U> + {...injectedProps} = T
      const newProps = { ...props, ...injectedProps } as T;
      return <Component {...newProps} />;
    };
  };
}

function withOwner(owner: string) {
  return function <T extends { owner: string }>(
    Component: React.ComponentType<T>
  ): React.ComponentType<Omit<T, "owner"> & { owner?: never }> {
    return function (props) {
      const newProps = { ...props, owner };
      return <Component {...newProps} />;
    };
  };
}
```

## 高级用法

```tsx
// usage
function App() {
  // Type '"foo"' is not assignable to type '"button" | "submit" | "reset" | undefined'.(2322)
  // return <Button type="foo"> sldkj </Button>

  // no error
  return <Button type="button"> text </Button>;
}

// implementation
export interface ButtonProps extends React.ComponentPropsWithoutRef<"button"> {
  specialProp?: string;
}
export function Button(props: ButtonProps) {
  const { specialProp, ...rest } = props;
  // do something with specialProp
  return <button {...rest} />;
}

// Method 1: React.JSX.IntrinsicElements
type BtnType = React.JSX.IntrinsicElements["button"]; // cannot inline or will error
export interface ButtonProps extends BtnType {} // etc

// Method 2: React.[Element]HTMLAttributes
export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement>



export interface ButtonProps extends React.HTMLProps<HTMLButtonElement> {
  specialProp: string;
}
export function Button(props: ButtonProps) {
  const { specialProp, ...rest } = props;
  // ERROR: Type 'string' is not assignable to type '"button" | "submit" | "reset" | undefined'.
  return <button {...rest} />;
}

import { HTMLAttributes } from "react";

export interface ButtonProps extends HTMLAttributes<HTMLButtonElement> {
  /* etc */
}

function App() {
  // Property 'type' does not exist on type 'IntrinsicAttributes & ButtonProps'
  return <Button type="submit"> text </Button>;
}



import { CSSProperties } from "react";

const Box = (props: CSSProperties) => <div style={props} />;

const Card = (
  { title, children, ...props }: { title: string } & $ElementProps<typeof Box> // new utility, see below
) => (
  <Box {...props}>
    {title}: {children}
  </Box>
);


// ReactUtilityTypes.d.ts
declare type $ElementProps<T> = T extends React.ComponentType<infer Props>
  ? Props extends object
    ? Props
    : never
  : never;

import * as Recompose from "recompose";
export const defaultProps = <
  C extends React.ComponentType,
  D extends Partial<$ElementProps<C>>
>(
  defaults: D,
  Component: C
): React.ComponentType<$ElementProps<C> & Partial<D>> =>
  Recompose.defaultProps(defaults)(Component);


import { forwardRef, ReactNode } from "react";

// base button, with ref forwarding
type Props = { children: ReactNode; type: "submit" | "button" };
export type Ref = HTMLButtonElement;

export const FancyButton = forwardRef<Ref, Props>((props, ref) => (
  <button ref={ref} className="MyCustomButtonClass" type={props.type}>
    {props.children}
  </button>
));


function PassThrough(props: { as: React.ElementType<any> }) {
  const { as: Component } = props;

  return <Component />;
}

const PrivateRoute = ({ component: Component, ...rest }: PrivateRouteProps) => {
  const { isLoggedIn } = useAuth();

  return isLoggedIn ? <Component {...rest} /> : <Redirect to="/" />;
};
```

renderList

```ts
import {ReactNode, useState} from 'react';

interface Props<T> {
  items: T[];
  renderItem: (item: T) => ReactNode;
}

function List<T>(props: Props<T>) {
  const {items, renderItem} = props;
  const [state, setState] = useState<T[]>([]); // You can use type T in List function scope.
  return (
    <div>
      {items.map(renderItem)}
      <button onClick={() => setState(items)}>Clone</button>
      {JSON.stringify(state, null, 2)}
    </div>
  );
}

ReactDOM.render(
  <List
    items={['a', 'b']} // type of 'string' inferred
    renderItem={(item) => (
      <li key={item}>
        {/* Error: Property 'toPrecision' does not exist on type 'string'. */}
        {item.toPrecision(3)}
      </li>
    )}
  />,
  document.body
);

ReactDOM.render(
  <List<number>
    items={['a', 'b']} // Error: Type 'string' is not assignable to type 'number'.
    renderItem={(item) => <li key={item}>{item.toPrecision(3)}</li>}
  />,
  document.body
);

import {ReactNode, useState} from 'react';

interface Props<T> {
  items: T[];
  renderItem: (item: T) => ReactNode;
}

// Note the <T extends unknown> before the function definition.
// You can't use just `<T>` as it will confuse the TSX parser whether it's a JSX tag or a Generic Declaration.
// You can also use <T,> https://github.com/microsoft/TypeScript/issues/15713#issuecomment-499474386
const List = <T extends unknown>(props: Props<T>) => {
  const {items, renderItem} = props;
  const [state, setState] = useState<T[]>([]); // You can use type T in List function scope.
  return (
    <div>
      {items.map(renderItem)}
      <button onClick={() => setState(items)}>Clone</button>
      {JSON.stringify(state, null, 2)}
    </div>
  );
};
```

```tsx
import {PureComponent, ReactNode} from 'react';

interface Props<T> {
  items: T[];
  renderItem: (item: T) => ReactNode;
}

interface State<T> {
  items: T[];
}

class List<T> extends PureComponent<Props<T>, State<T>> {
  // You can use type T inside List class.
  state: Readonly<State<T>> = {
    items: []
  };
  render() {
    const {items, renderItem} = this.props;
    // You can use type T inside List class.
    const clone: T[] = items.slice(0);
    return (
      <div>
        {items.map(renderItem)}
        <button onClick={() => this.setState({items: clone})}>Clone</button>
        {JSON.stringify(this.state, null, 2)}
      </div>
    );
  }
}
```

```ts
class List<T> extends React.PureComponent<Props<T>, State<T>> {
  // Static members cannot reference class type parameters.ts(2302)
  static getDerivedStateFromProps(props: Props<T>, state: State<T>) {
    return {items: props.items};
  }
}

class List<T> extends React.PureComponent<Props<T>, State<T>> {
  static getDerivedStateFromProps<T>(props: Props<T>, state: State<T>) {
    return {items: props.items};
  }
}

Parent.propTypes = {
  children: PropTypes.shape({
    props: PropTypes.shape({
      // could share `propTypes` to the child
      value: PropTypes.string.isRequired
    })
  }).isRequired
};
```

```tsx
// Usage
function App() {
  return (
    <>
      {/* 😎 All good */}
      <Button target="_blank" href="https://www.google.com">
        Test
      </Button>
      {/* 😭 Error, `disabled` doesnt exist on anchor element */}
      <Button disabled href="x">
        Test
      </Button>
    </>
  );
}
```

```ts
// Button props
type ButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  href?: undefined;
};

// Anchor props
type AnchorProps = React.AnchorHTMLAttributes<HTMLAnchorElement> & {
  href?: string;
};

// Input/output options
type Overload = {
  (props: ButtonProps): React.JSX.Element;
  (props: AnchorProps): React.JSX.Element;
};

// Guard to check if href exists in props
const hasHref = (props: ButtonProps | AnchorProps): props is AnchorProps => 'href' in props;

// Component
const Button: Overload = (props: ButtonProps | AnchorProps) => {
  // anchor render
  if (hasHref(props)) return <a {...props} />;
  // button render
  return <button {...props} />;
};
```

```tsx
type ButtonProps = React.JSX.IntrinsicElements['button'];
type AnchorProps = React.JSX.IntrinsicElements['a'];

// optionally use a custom type guard
function isPropsForAnchorElement(props: ButtonProps | AnchorProps): props is AnchorProps {
  return 'href' in props;
}

function Clickable(props: ButtonProps | AnchorProps) {
  if (isPropsForAnchorElement(props)) {
    return <a {...props} />;
  } else {
    return <button {...props} />;
  }
}

type LinkProps = Omit<React.JSX.IntrinsicElements['a'], 'href'> & {
  to?: string;
};

function RouterLink(props: LinkProps | AnchorProps) {
  if ('href' in props) {
    return <a {...props} />;
  } else {
    return <Link {...props} />;
  }
}
```

```tsx
interface LinkProps {}
type AnchorProps = React.AnchorHTMLAttributes<HTMLAnchorElement>;
type RouterLinkProps = Omit<NavLinkProps, 'href'>;

const Link = <T extends {}>(
  props: LinkProps & T extends RouterLinkProps ? RouterLinkProps : AnchorProps
) => {
  if ((props as RouterLinkProps).to) {
    return <NavLink {...(props as RouterLinkProps)} />;
  } else {
    return <a {...(props as AnchorProps)} />;
  }
};

<Link<RouterLinkProps> to="/">My link</Link>; // ok
<Link<AnchorProps> href="/">My link</Link>; // ok
<Link<RouterLinkProps> to="/" href="/">
  My link
</Link>; // error
```

```tsx
type UserTextEvent = {
  type: 'TextEvent';
  value: string;
  target: HTMLInputElement;
};
type UserMouseEvent = {
  type: 'MouseEvent';
  value: [number, number];
  target: HTMLElement;
};
type UserEvent = UserTextEvent | UserMouseEvent;
function handle(event: UserEvent) {
  if (event.type === 'TextEvent') {
    event.value; // string
    event.target; // HTMLInputElement
    return;
  }
  event.value; // [number, number]
  event.target; // HTMLElement
}

type UserTextEvent = {value: string; target: HTMLInputElement};
type UserMouseEvent = {value: [number, number]; target: HTMLElement};
type UserEvent = UserTextEvent | UserMouseEvent;
function handle(event: UserEvent) {
  if (typeof event.value === 'string') {
    event.value; // string
    event.target; // HTMLInputElement | HTMLElement (!!!!)
    return;
  }
  event.value; // [number, number]
  event.target; // HTMLInputElement | HTMLElement (!!!!)
}
```

```tsx
import {useMemo} from 'react';

interface SingleElement {
  isArray: true;
  value: string[];
}
interface MultiElement {
  isArray: false;
  value: string;
}
type Props = SingleElement | MultiElement;

function Sequence(p: Props) {
  return useMemo(
    () => (
      <div>
        value(s):
        {p.isArray && p.value.join(',')}
        {!p.isArray && p.value}
      </div>
    ),
    [p.isArray, p.value] // TypeScript automatically matches the corresponding value type based on dependency change
  );
}

function App() {
  return (
    <div>
      <Sequence isArray={false} value={'foo'} />
      <Sequence isArray={true} value={['foo', 'bar', 'baz']} />
    </div>
  );
}
```

```tsx
type Props1 = {foo: string; bar?: never};
type Props2 = {bar: string; foo?: never};

const OneOrTheOther = (props: Props1 | Props2) => {
  if ('foo' in props && typeof props.foo === 'string') {
    // `props.bar` is of type `undefined`
    return <>{props.foo}</>;
  }
  // `props.foo` is of type `undefined`
  return <>{props.bar}</>;
};
const Component = () => (
  <>
    <OneOrTheOther /> {/* error */}
    <OneOrTheOther foo="" /> {/* ok */}
    <OneOrTheOther bar="" /> {/* ok */}
    <OneOrTheOther foo="" bar="" /> {/* error */}
  </>
);

type Props1 = {type: 'foo'; foo: string};
type Props2 = {type: 'bar'; bar: string};

const OneOrTheOther = (props: Props1 | Props2) => {
  if (props.type === 'foo') {
    // `props.bar` does not exist
    return <>{props.foo}</>;
  }
  // `props.foo` does not exist
  return <>{props.bar}</>;
};
const Component = () => (
  <>
    <OneOrTheOther type="foo" /> {/* error */}
    <OneOrTheOther type="foo" foo="" /> {/* ok */}
    <OneOrTheOther type="foo" bar="" /> {/* error */}
    <OneOrTheOther type="foo" foo="" bar="" /> {/* error */}
    <OneOrTheOther type="bar" /> {/* error */}
    <OneOrTheOther type="bar" foo="" /> {/* error */}
    <OneOrTheOther type="bar" bar="" /> {/* ok */}
    <OneOrTheOther type="bar" foo="" bar="" /> {/* error */}
  </>
);

interface All {
  a: string;
  b: string;
}

type Nothing = Record<string, never>;

const AllOrNothing = (props: All | Nothing) => {
  if ('a' in props) {
    return <>{props.b}</>;
  }
  return <>Nothing</>;
};

const Component = () => (
  <>
    <AllOrNothing /> {/* ok */}
    <AllOrNothing a="" /> {/* error */}
    <AllOrNothing b="" /> {/* error */}
    <AllOrNothing a="" b="" /> {/* ok */}
  </>
);

interface Props {
  obj?: {
    a: string;
    b: string;
  };
}

const AllOrNothing = (props: Props) => {
  if (props.obj) {
    return <>{props.obj.a}</>;
  }
  return <>Nothing</>;
};

const Component = () => (
  <>
    <AllOrNothing /> {/* ok */}
    <AllOrNothing obj={{a: ''}} /> {/* error */}
    <AllOrNothing obj={{b: ''}} /> {/* error */}
    <AllOrNothing obj={{a: '', b: ''}} /> {/* ok */}
  </>
);
```

```tsx
const App = () => (
  <>
    {/* these all typecheck */}
    <Text>not truncated</Text>
    <Text truncate>truncated</Text>
    <Text truncate expanded>
      truncate-able but expanded
    </Text>
    {/* TS error: Property 'truncate' is missing in type '{ children: string; expanded: true; }' but required in type '{ truncate: true; expanded?: boolean | undefined; }'. */}
    <Text expanded>truncate-able but expanded</Text>
  </>
);

import {ReactNode} from 'react';

interface CommonProps {
  children?: ReactNode;
  miscProps?: any;
}

type NoTruncateProps = CommonProps & {truncate?: false};

type TruncateProps = CommonProps & {truncate: true; expanded?: boolean};

// Function overloads to accept both prop types NoTruncateProps & TruncateProps
function Text(props: NoTruncateProps): React.JSX.Element;
function Text(props: TruncateProps): React.JSX.Element;
function Text(props: CommonProps & {truncate?: boolean; expanded?: boolean}) {
  const {children, truncate, expanded, ...otherProps} = props;
  const classNames = truncate ? '.truncate' : '';
  return (
    <div className={classNames} aria-expanded={!!expanded} {...otherProps}>
      {children}
    </div>
  );
}
```

```tsx
export interface Props {
  label: React.ReactNode; // this will conflict with the InputElement's label
}

// this comes inbuilt with TS 3.5
type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

// usage
export const Checkbox = (props: Props & Omit<React.HTMLProps<HTMLInputElement>, 'label'>) => {
  const {label} = props;
  return (
    <div className="Checkbox">
      <label className="Checkbox-label">
        <input type="checkbox" {...props} />
      </label>
      <span>{label}</span>
    </div>
  );
};

export interface Props {
  label: React.ReactNode; // conflicts with the InputElement's label
  onChange: (text: string) => void; // conflicts with InputElement's onChange
}

export const Textbox = (props: Props & Omit<React.HTMLProps<HTMLInputElement>, keyof Props>) => {
  // implement Textbox component ...
};

// a Modal component defined elsewhere
const defaultProps: React.ComponentProps<typeof Modal> = {
  title: 'Hello World',
  visible: true,
  onClick: jest.fn()
};
```

```tsx
import {ReactNode} from 'react';

interface Props {
  label?: ReactNode;
  children?: ReactNode;
}

const Card = ({children, label}: Props) => {
  return (
    <div>
      {label && <div>{label}</div>}
      {children}
    </div>
  );
};

import {ReactNode} from 'react';

interface Props {
  children: (foo: string) => ReactNode;
}
```

```tsx
class InvalidDateFormatError extends RangeError {}
class DateIsInFutureError extends RangeError {}

/**
 * // optional docblock
 * @throws {InvalidDateFormatError} The user entered date incorrectly
 * @throws {DateIsInFutureError} The user entered date in future
 *
 */
function parse(date: string) {
  if (!isValid(date)) throw new InvalidDateFormatError('not a valid date format');
  if (isInFuture(date)) throw new DateIsInFutureError('date is in the future');
  // ...
}

try {
  // call parse(date) somewhere
} catch (e) {
  if (e instanceof InvalidDateFormatError) {
    console.error('invalid date format', e);
  } else if (e instanceof DateIsInFutureError) {
    console.warn('date is in future', e);
  } else {
    throw e;
  }
}

function parse(date: string): Date | InvalidDateFormatError | DateIsInFutureError {
  if (!isValid(date)) return new InvalidDateFormatError('not a valid date format');
  if (isInFuture(date)) return new DateIsInFutureError('date is in the future');
  // ...
}

// now consumer *has* to handle the errors
let result = parse('mydate');
if (result instanceof InvalidDateFormatError) {
  console.error('invalid date format', result.message);
} else if (result instanceof DateIsInFutureError) {
  console.warn('date is in future', result.message);
} else {
  /// use result safely
}

// alternately you can just handle all errors
if (result instanceof Error) {
  console.error('error', result);
} else {
  /// use result safely
}

interface Option<T> {
  flatMap<U>(f: (value: T) => None): None;
  flatMap<U>(f: (value: T) => Option<U>): FormikOption<U>;
  getOrElse(value: T): T;
}
class Some<T> implements Option<T> {
  constructor(private value: T) {}
  flatMap<U>(f: (value: T) => None): None;
  flatMap<U>(f: (value: T) => Some<U>): Some<U>;
  flatMap<U>(f: (value: T) => Option<U>): Option<U> {
    return f(this.value);
  }
  getOrElse(): T {
    return this.value;
  }
}
class None implements Option<never> {
  flatMap<U>(): None {
    return this;
  }
  getOrElse<U>(value: U): U {
    return value;
  }
}

// now you can use it like:
let result = Option(6) // Some<number>
  .flatMap((n) => Option(n * 3)) // Some<number>
  .flatMap((n = new None())) // None
  .getOrElse(7);

// or:
let result = ask() // Option<string>
  .flatMap(parse) // Option<Date>
  .flatMap((d) => new Some(d.toISOString())) // Option<string>
  .getOrElse('error parsing string');
```

## prettier

```bash
yarn add -D prettier husky lint-staged
```

package.json

```json
// inside package.json
{
  //...
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "linters": {
      "src/*.{ts,tsx,js,jsx,css,scss,md}": [
        "prettier --trailing-comma es5 --single-quote --write",
        "git add"
      ],
      "ignore": ["**/dist/*, **/node_modules/*"]
    }
  },
  "prettier": {
    "printWidth": 80,
    "semi": false,
    "singleQuote": true,
    "trailingComma": "es5"
  }
}
```
