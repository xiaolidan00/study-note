# 阮一峰《Typescript 教程》读书笔记

内容来源于(阮一峰《Typescript 教程》)[https://wangdoc.com/typescript/intro]

# 安装与常用命令

```js
npm install -g typescript

tsc -v//获取ts版本
tsc -h//获取帮助信息
tsc --all//查看完整帮助信息
tsc app.ts//编译脚本文件
tsc file1.ts file2.ts file3.ts
//编译多个脚本文件输入到一个文件里面
tsc file1.ts file2.ts --outFile app.js
//编译结果输出到指定目录
tsc app.ts --outDir dist
//指定编译后的js版本
tsc --target es2015 app.ts
//一旦报错就停止编译，不生成编译产物
tsc --noEmitOnError app.ts
//只检查类型是否正确，不生成 JavaScript 文件
tsc --noEmit app.ts
```

## tsconfig.json 配置

配置了 tsconfig.json 后直接运行 tsc 命令即可

```js
//tsc file1.js file2.js --outFile dist/app.js
{
  "files": ["file1.ts", "file2.ts"],
  "compilerOptions": {
    "outFile": "dist/app.js"
  }
}

```

## ts-node

```js
npm install -g ts-node
ts-node script.ts

ts-node const twice = (x:string) => x + x;//直接运行ts代码
```

# 类型

- any 类型没限制
- unknown 不限制类型，但不能直接声明赋值
- never 空类型，不可赋值

声明变量为赋值时，ts 会推断类型

## 基础类型

- boolean
- string
- number
- bigint
- symbol
- object
- undefined
- null

## 包装对象

- Boolean 和 boolean
- String 和 string
- Number 和 number
- BigInt 和 bigint
- Symbol 和 symbol
- Object 和 object

前者是对象，后者是类型,前者兼容后者，后者不兼容前者

```js
const s = new String('hello');
typeof s; // 'object'

const s1: String = 'hello'; // 正确
const s2: String = new String('hello'); // 正确
const s3: string = 'hello'; // 正确
const s4: string = new String('hello'); // 报错
```

## 严格类型检查

```js
strictNullChecks:true

tsc --strictNullChecks app.ts
```

- undefined 和 null 就不能赋值给其他类型的变量（除了 any 类型和 unknown 类型）

- undefined 和 null 只能赋值给自身，或者 any 类型和 unknown 类型的变量

## 联合类型

```js
let x: string | number;
let gender: 'male' | 'female';
```

## 交叉类型

```js
let obj: { foo: string } & { bar: string };
obj = {
  foo: 'hello',
  bar: 'world'
};
```

# type 声明类型别名

- 别名不允许重名。
- 别名的作用域是块级作用域。代码块内部定义的别名，影响不到外部。
- 别名支持使用表达式，也可以在定义一个别名时，使用另一个别名，即别名允许嵌套。

```js
type Age = number;
let age: Age = 55;

type Color = 'red';
if (Math.random() < 0.5) {
  type Color = 'blue';
}

type World = 'world';
type Greeting = `hello ${World}`;
```

## js 判别类型

```js
typeof undefined; // "undefined"
typeof true; // "boolean"
typeof 1337; // "number"
typeof 'foo'; // "string"
typeof {}; // "object"
typeof parseInt; // "function"
typeof Symbol(); // "symbol"
typeof 127n; // "bigint"
```

## type 判别类型

```js
const a = { x: 0 };
type T0 = typeof a; // { x: number }
type T1 = typeof a.x; // number
```

# 数组

```js
let arr: number[] = [1, 2, 3];
let arr: (number | string)[];

let arr: any[];

let arr: Array<number> = [1, 2, 3];
let arr: Array<number | string>;

type Names = string[];
type Name = Names[0]; // string

type Names = string[];
type Name = Names[number]; // string

const arr: readonly number[] = [0, 1]; //不可修改数组,只读
//readonly关键字不能与数组的泛型写法一起使用。

const a1: ReadonlyArray<number> = [0, 1];
const a2: Readonly<number[]> = [0, 1];

const arr = [0, 1] as const;
//多维数组
var multi: number[][] = [
  [1, 2, 3],
  [23, 24, 25]
];
```

# 元组

成员类型可以自由设置的数组，即数组的各个成员的类型可以不同。

元组必须明确声明每个成员的类型。

元组的成员数量是有限的，从类型声明就可以明确知道，元组包含多少个成员，越界的成员会报错。

```js
const s: [string, number, boolean] = ['a', 2, true];
//元组成员的类型可以添加问号后缀（?），表示该成员是可选的。
let a: [number, number?] = [1];
//问号只能用于元组的尾部成员，也就是说，所有可选成员必须在必选成员之后。
type myTuple = [number, number, number?, string?];

//使用扩展运算符（...），可以表示不限成员数量的元组。
type NamedNums = [string, ...number[]];
const b: NamedNums = ['B', 1, 2, 3];
//扩展运算符用在元组的任意位置都可以，但是它后面只能是数组或元组。
type t1 = [string, number, ...boolean[]];
type t2 = [string, ...boolean[], number];
type t3 = [...boolean[], string, number];
//不确定元组成员的类型和数量
type Tuple = [...any[]];
//读取成员类型
type Tuple = [string, number];
type Age = Tuple[1]; // number
type Tuple = [string, number, Date];
type TupleEl = Tuple[number]; // string|number|Date
```

## 只读元组

元组可以替代只读元组，而只读元组不能替代元组。

```js
// 写法一
type t = readonly [number, string];
// 写法二
type t = Readonly<[number, string]>;

function f(point: [number, number]) {
  return Math.sqrt(point[0] ** 2 + point[1] ** 2);
}
let point = [3, 4] as const;
distanceFromOrigin(point);

//扩展运算符与成员数量
const arr: [number, number] = [1, 2];
function add(x: number, y: number) {
  // ...
}
add(...arr);
```

# Symbol

每一个 Symbol 值都是独一无二的，与其他任何值都不相等

```js
let x: symbol = Symbol();

//不能修改值的，只能用const命令声明，不能用let声明 不能把一个赋值给另一个 不能使用严格相等运算符进行比较
const x: unique symbol = Symbol();
const a: unique symbol = Symbol.for('foo');
const a: unique symbol = Symbol();
const b: typeof a = a; // 正确

const x: unique symbol = Symbol();
const y: symbol = Symbol();
interface Foo {
  [x]: string; // 正确
  [y]: string; // 报错
}

class C {
  static readonly foo: unique symbol = Symbol();
}
```

# 函数

```js
function hello(txt: string): void {
  console.log('hello ' + txt);
}

// 写法一
const hello = function (txt: string) {
  console.log('hello ' + txt);
};
// 写法二
const hello: (txt: string) => void = function (txt) {
  console.log('hello ' + txt);
};

type MyFunc = (a: string, b: number) => number;

let myFunc: MyFunc;
myFunc = (a: number) => a; // 正确

function add(x: number, y: number) {
  return x + y;
}
const myAdd: typeof add = function (x, y) {
  return x + y;
};
//对象写法
let add: {
  (x: number, y: number): number
};
add = function (x, y) {
  return x + y;
};
let foo: {
  (x: number): void,
  version: string
} = f;
f.version = '1.0';

interface myfn {
  (a: number, b: number): number;
}
var add: myfn = (a, b) => a + b;

//传入函数
function doSomething(f: Function) {
  return f(1, 2, 3);
}
```

## 箭头函数

```js
//箭头函数
const repeat = (str: string, times: number): string => str.repeat(times);

function greet(fn: (a: string) => void): void {
  fn('world');
}

//可选参数 函数的可选参数只能在参数列表的尾部，跟在必选参数的后面。
function f(x?: number) {
  // ...
}
f(); // OK
f(10); // OK
f(undefined); // 正确

function f(x: number | undefined) {
  return x;
}
f(); // 报错

let myFunc: (a: number, b?: number) => number;
myFunc = function (x, y) {
  if (y === undefined) {
    return x;
  }
  return x + y;
};
```

## 默认值

```js
//默认值
function add(x: number = 0, y: number) {
  return x + y;
}
add(1); // 报错
add(undefined, 1); // 正确
//方法1
interface Config {
  file: string;
  test: boolean;
  production: boolean;
  dbUrl: string;
}
function getConfig(
  config: Config = { file: 'test.log', test: true, production: false, dbUrl: 'localhost:5432' }
) {
  console.log(config);
}
//方法2
interface Person {
  firstName: string;
  lastName: string;
}

function getPerson({ firstName = 'Steve', lastName = 'Jobs' }: Person) {
  console.log(firstName + ' ' + lastName);
}
```

## 解构

```js
//解构
function f([x, y]: [number, number]) {
  // ...
}
function sum({ a, b, c }: { a: number, b: number, c: number }) {
  console.log(a + b + c);
}
```

## 扩展符读取参数

```js
// rest 参数为数组
function joinNumbers(...nums: number[]) {
  // ...
}
// rest 参数为元组
function f(...args: [boolean, number]) {
  // ...
}
function f(...args: [boolean, string?]) {}
function multiply(n: number, ...m: number[]) {
  return m.map((x) => n * x);
}
function f(...args: [boolean, ...string[]]) {
  // ...
}

function repeat(...[str, times]: [string, number]): string {
  return str.repeat(times);
}
// 等同于
function repeat(str: string, times: number): string {
  return str.repeat(times);
}
```

## readonly 和 never

```js
//readonly
function arraySum(arr: readonly number[]) {
  // ...
  arr[0] = 0; // 报错
}
//不返回值 允许返回undefined或null
function f(): void {
  console.log('hello');
}
function f(): void {
  return undefined; // 正确
}
function f(): void {
  return null; // 正确 strictNullChecks:true 报错
}
//抛出错误 返回值为never
function fail(msg:string):never {
  throw new Error(msg);
}
//返回Error
function fail():Error {
  return new Error("Something failed");
}
//无限循环函数
const sing = function():never {
  while (true) {
    console.log('sing');
};
//never类型不同于void类型。前者表示函数没有执行结束，不可能有返回值；后者表示函数正常执行结束，但是不返回值，或者说返回undefined。
```

## 局部类型/高阶函数/函数重载

```js
//局部类型
function hello(txt: string) {
  type message = string;
  let newTxt: message = 'hello ' + txt;
  return newTxt;
}

//高阶函数
(someValue: number) => (multiplier: number) => someValue * multiplier;

//函数重载
function add(x: number, y: number): number;
function add(x: any[], y: any[]): any[];
function add(x: number | any[], y: number | any[]): number | any[] {
  if (typeof x === 'number' && typeof y === 'number') {
    return x + y;
  } else if (Array.isArray(x) && Array.isArray(y)) {
    return [...x, ...y];
  }
  throw new Error('wrong parameters');
}
```

## 构造函数

```js
class Animal {
  numLegs:number = 4;
}
type AnimalConstructor = new () => Animal;
function create(c:AnimalConstructor):Animal {
  return new c();
}
const a = create(Animal);

type F = {
  new (s:string): object;
};
type F = {
  new (s:string): object;
  (n?:number): number;
}
```

# 对象

```js
const obj: {
  x: number,
  y: number
} = { x: 1, y: 1 };

// 属性类型以分号结尾
type MyObj = {
  x: number,
  y: number
};
// 属性类型以逗号结尾
type MyObj = {
  x: number,
  y: number
};
//const只读，不可delete 不可添加没有声明的变量

const obj: {
  x: number,
  y: number,
  add(x: number, y: number): number
  // 或者写成
  // add: (x:number, y:number) => number;
} = {
  x: 1,
  y: 1,
  add(x, y) {
    return x + y;
  }
};
//读取属性类型
type User = {
  name: string,
  age: number
};
type Name = User['name']; // string

interface MyObj {
  x: number;
  y: number;
}

interface MyInterface {
  toString(): string; // 继承的属性
  prop: number; // 自身的属性
}
const obj: MyInterface = {
  // 正确
  prop: 123
};
```

## 可选属性

```js
const obj: {
  x: number,
  y?: number
} = { x: 1 };

type User = {
  firstName: string,
  lastName?: string
};
// 等同于
type User = {
  firstName: string,
  lastName: string | undefined
};
//判断是否为undefined
const user: {
  firstName: string,
  lastName?: string
} = { firstName: 'Foo' };
if (user.lastName !== undefined) {
  console.log(`hello ${user.firstName} ${user.lastName}`);
}

// 写法一
let firstName = user.firstName === undefined ? 'Foo' : user.firstName;
let lastName = user.lastName === undefined ? 'Bar' : user.lastName;
// 写法二 使用 Null 判断运算符??
let firstName = user.firstName ?? 'Foo';
let lastName = user.lastName ?? 'Bar';
```

## 只读属性

```js
interface MyInterface {
  readonly prop: number;//只读不可修改
}

interface Home {
  readonly resident: {//不可替换对象，只能修改对象里的属性
    name: string;
    age: number
  };
}

const h:Home = {
  resident: {
    name: 'Vicky',
    age: 42
  }
};
h.resident.age = 32; // 正确
h.resident = {
  name: 'Kate',
  age: 23
} // 报错

//一个对象两个引用 影响到只读变量
interface Person {
  name: string;
  age: number;
}
interface ReadonlyPerson {
  readonly name: string;
  readonly age: number;
}
let w:Person = {
  name: 'Vicky',
  age: 42,
};
let r:ReadonlyPerson = w;
w.age += 1;
r.age // 43

//不可修改属性
const myUser = {
  name: "Sabrina",
} as const;
```

## 属性名的索引类型

```js
type MyObj = {
  [property: string]: string
};
const obj: MyObj = {
  foo: 'a',
  bar: 'b',
  baz: 'c'
};

type T1 = {
  [property: number]: string
};
type T2 = {
  [property: symbol]: string
};

type MyArr = {
  [n: number]: number
};
const arr: MyArr = [1, 2, 3];
// 或者
const arr: MyArr = {
  0: 1,
  1: 2,
  2: 3
};
//索引冲突  JavaScript 语言内部，所有的数值属性名都会自动转为字符串属性名
type MyType = {
  [x: number]: boolean, // 报错
  [x: string]: string
};

type MyType = {
  foo: boolean, // 报错
  [x: string]: string
};
```

## 解构赋值

```js
const {
  id,
  name,
  price
}: {
  id: string,
  name: string,
  price: number
} = product;

function draw(obj: { shape?: Shape, xPos: number, yPos: number } = { xPos: 100, yPos: 100 }) {
  let myShape = obj.shape;
  let x = obj.xPos;
}
```

## 结构类型原则

```js
//子类型兼容父类型
type A = {
  x: number
};
type B = {
  x: number,
  y: number
};
const b = {
  x: 1,
  y: 1
};
const a: A = b; // 正确

//关闭多余属性检查 新增属性
{
  "compilerOptions": {
    "suppressExcessPropertyErrors": true
  }
}
```

## 空对象

```js
const obj = {};
obj.prop = 123;

const pt0 = {};
const pt1 = { x: 3 };
const pt2 = { y: 4 };
const pt = {
  ...pt0,
  ...pt1,
  ...pt2
};

let d: {};
// 等同于
// let d:Object;
d = {};
d = { x: 1 };
d = 'hello';
d = 2;

//强制使用没有任何属性的对象
interface WithoutProperties {
  [key: string]: never;
}
```

# interface 接口

```js
interface Foo {
  a: string;
}
type A = Foo['a']; // string
```

## 对象属性

```js
//对象属性
interface Point {
  x: number;
  y: number;
}
interface Foo {
  x?: string;
}
interface A {
  readonly a: string;
}
```

## 对象的属性索引

```js
//对象的属性索引
interface A {
  [prop: string]: number;
}
//属性的数值索引，其实是指定数组的类型
interface A {
  [prop: number]: string;
}
const obj: A = ['a', 'b', 'c'];

//数值属性名最终是自动转换成字符串属性名。
interface B {
  [prop: string]: number;
  [prop: number]: number; // 正确
}
```

## 对象的方法

```js
//对象的方法
// 写法一
interface A {
  f(x: boolean): string;
}
// 写法二
interface B {
  f: (x: boolean) => string;
}
// 写法三
interface C {
  f: { (x: boolean): string };
}

const f = 'f';
interface A {
  [f](x: boolean): string;
}
//重载
interface A {
  f(): number;
  f(x: boolean): boolean;
  f(x: string, y: string): string;
}

interface A {
  f(): number;
  f(x: boolean): boolean;
  f(x: string, y: string): string;
}
function MyFunc(): number;
function MyFunc(x: boolean): boolean;
function MyFunc(x: string, y: string): string;
function MyFunc(
  x?:boolean|string, y?:string
):number|boolean|string {
  if (x === undefined && y === undefined) return 1;
  if (typeof x === 'boolean' && y === undefined) return true;
  if (typeof x === 'string' && typeof y === 'string') return 'hello';
  throw new Error('wrong parameters');
}
const a:A = {
  f: MyFunc
}
```

## 函数

```js
interface Add {
  (x: number, y: number): number;
}
const myAdd: Add = (x, y) => x + y;
```

## 构造函数

```js
interface ErrorConstructor {
  new(message?: string): Error;
}
```

## 继承

```js
interface Style {
  color: string;
}
interface Shape {
  name: string;
}
interface Circle extends Style, Shape {
  radius: number;
}
//子接口与父接口的同名属性必须是类型兼容的，不能有冲突

type Country = {
  name: string,
  capital: string
};
interface CountryWithPop extends Country {
  population: number;
}

class A {
  x: string = '';
  y(): boolean {
    return true;
  }
}
interface B extends A {
  z: number;
}
const b: B = {
  x: '',
  y: function () {
    return true;
  },
  z: 123
};
```

## 接口合并

```js
//对windows对象和document对象添加自定义属性,把自定义属性写成 interface，合并进原始定义
interface Document {
  foo: string;
}
document.foo = 'hello';

//越靠后的定义，优先级越高，排在函数重载的越前面
interface Cloner {
  clone(animal: Animal): Animal;
}
interface Cloner {
  clone(animal: Sheep): Sheep;
}
interface Cloner {
  clone(animal: Dog): Dog;
  clone(animal: Cat): Cat;
}
// 等同于
interface Cloner {
  clone(animal: Dog): Dog;
  clone(animal: Cat): Cat;
  clone(animal: Sheep): Sheep;
  clone(animal: Animal): Animal;
}

interface Document {
  createElement(tagName: any): Element;
}
interface Document {
  createElement(tagName: "div"): HTMLDivElement;
  createElement(tagName: "span"): HTMLSpanElement;
}
interface Document {
  createElement(tagName: string): HTMLElement;
  createElement(tagName: "canvas"): HTMLCanvasElement;
}
// 等同于
interface Document {
  createElement(tagName: "canvas"): HTMLCanvasElement;
  createElement(tagName: "div"): HTMLDivElement;
  createElement(tagName: "span"): HTMLSpanElement;
  createElement(tagName: string): HTMLElement;
  createElement(tagName: any): Element;
}


//联合类型
interface Circle {
  area: bigint;
}
interface Rectangle {
  area: number;
}
declare const s: Circle | Rectangle;
s.area;   // bigint | number
```

## interface 与 type 的区别

1. type 能够表示非对象类型，而 interface 只能表示对象类型（包括数组、函数等）。
2. interface 可以继承其他类型，type 不支持继承。
3. 同名 interface 会自动合并，同名 type 则会报错。也就是说，TypeScript 不允许使用 type 多次定义同一个类型。
4. interface 不能包含属性映射（mapping）
5. this 关键字只能用于 interface。
6. type 可以扩展原始数据类型，interface 不行。
7. interface 无法表达某些复杂类型（比如交叉类型和联合类型），但是 type 可以。

```js
//继承的主要作用是添加属性，type定义的对象类型如果想要添加属性，只能使用&运算符，重新定义一个类型。
type Animal = {
  name: string
};
type Bear = Animal & {
  honey: boolean
};

interface Animal {
  name: string;
}
interface Bear extends Animal {
  honey: boolean;
}

type Foo = { x: number };
interface Bar extends Foo {
  y: number;
}
interface Foo {
  x: number;
}
type Bar = Foo & { y: number };


//不含映射属性
interface Point {
  x: number;
  y: number;
}
// 正确
type PointCopy1 = {
  [Key in keyof Point]: Point[Key];
};
// 报错
interface PointCopy2 {
  [Key in keyof Point]: Point[Key];
};

//this
// 正确
interface Foo {
  add(num:number): this;
};
// 报错
type Foo = {
  add(num:number): this;
};

class Calculator implements Foo {
  result = 0;
  add(num：number) {
    this.result += num;
    return this;
  }
}
//扩展原始类型
type MyStr = string & {
  type: 'new'
};
//复杂类型
type A = { /* ... */ };
type B = { /* ... */ };
type AorB = A | B;
type AorBwithName = AorB & {
  name: string
};
```

# class 类型

```js
class Point {
  x: number;
  y: number;
}
//ts自动类型推断
class Point {
  x = 0;
  y = 0;
}
//非空断言
class Point {
  x!:number;
  y!:number;
}
```

## readonly 修饰符

```js
class A {
  readonly id = 'foo';
}
const a = new A();
a.id = 'bar'; // 报错

class A {
  readonly id:string;
  constructor() {
    this.id = 'bar'; // 正确
  }
}

class A {
  readonly id:string = 'foo';
  constructor() {
    this.id = 'bar'; // 正确
  }
}


class Point {
  x:number;
  y:number;
  constructor(x:number, y:number) {
    this.x = x;
    this.y = y;
  }
  add(point:Point) {
    return new Point(
      this.x + point.x,
      this.y + point.y
    );
  }
}
//函数重载
class Point {
  constructor(x:number, y:string);
  constructor(s:string);
  constructor(xs:number|string, y?:string) {
    // ...
  }
}

```

## 存取器方法

1. 如果某个属性只有 get 方法，没有 set 方法，那么该属性自动成为只读属性。
2. set 方法的参数类型，必须兼容 get 方法的返回值类型，否则报错。
3. get 方法与 set 方法的可访问性必须一致，要么都为公开方法，要么都为私有方法。

```js
class C {
  _name = '';
  get name() {
    return this._name;
  }
  set name(value) {
    this._name = value;
  }
}

class C {
  _name = 'foo';
  get name() {
    //只读
    return this._name;
  }
}

class C {
  _name = '';
  get name(): string {
    return this._name;
  }
  set name(value: number | string) {
    this._name = String(value); // 正确
  }
}
```

## 属性索引

```js
class MyClass {
  [s:string]: boolean |
    ((s:string) => boolean);
  get(s:string) {
    return this[s] as boolean;
  }
}
```

## 类的 interface 接口

```js
//implements 关键字 表示当前类满足这些外部类型条件的限制。
interface Country {
  name: string;
  capital: string;
}
// 或者
type Country = {
  name: string,
  capital: string
};
class MyCountry implements Country {
  name = '';
  capital = '';
}

//interface 只是指定检查条件，如果不满足这些条件就会报错。它并不能代替 class 自身的类型声明。
interface A {
  get(name: string): boolean;
}
class B implements A {
  get(s) {
    // s 的类型是 any
    return true;
  }
}

interface A {
  x: number;
  y?: number;
}
class B implements A {
  x = 0;
}
const b = new B();
b.y = 10; // 报错

class Car {
  id: number = 1;
  move(): void {}
}
class MyCar implements Car {
  id = 2; // 不可省略
  move(): void {} // 不可省略
}
```

## 实现多个接口

```js
class Car implements MotorVehicle {}
class SecretCar extends Car implements Flyable, Swimmable {}

interface MotorVehicle {
  // ...
}
interface Flyable {
  // ...
}
interface Swimmable {
  // ...
}
interface SuperCar extends MotoVehicle, Flyable, Swimmable {
  // ...
}
class SecretCar implements SuperCar {
  // ...
}
```

## 类与接口的合并

```js
class A {
  x: number = 1;
}
interface A {
  y: number;
}
let a = new A();
a.y = 10;
a.x; // 1
a.y; // 10
```

## Class 类型

```js
interface MotorVehicle {}
class Car implements MotorVehicle {}
// 写法一
const c: Car = new Car();
// 写法二
const c: MotorVehicle = new Car();
```

## 类的自身类型

```js
class Point {
  x:number;
  y:number;
  constructor(x:number, y:number) {
    this.x = x;
    this.y = y;
  }
}
function createPoint(PointClass: typeof Point, x: number, y: number): Point {
  return new PointClass(x, y);
}
//类只是构造函数的一种语法糖，本质上是构造函数的另一种写法。所以，类的自身类型可以写成构造函数的形式
function createPoint(
  PointClass: new (x:number, y:number) => Point,
  x: number,
  y: number
):Point {
  return new PointClass(x, y);
}

interface PointConstructor {
  new(x:number, y:number):Point;
}
function createPoint(
  PointClass: PointConstructor,
  x: number,
  y: number
):Point {
  return new PointClass(x, y);
}
```

## 结构原则

```js
//空类不包含任何成员，任何其他类都可以看作与空类结构相同。因此，凡是类型为空类的地方，所有类（包括对象）都可以使用。
class Empty {}
function fn(x: Empty) {
  // ...
}
fn({});
fn(window);
fn(fn);

//确定两个类的兼容关系时，只检查实例成员，不考虑静态成员和构造方法。
class Point {
  x: number;
  y: number;
  static t: number;
  constructor(x: number) {}
}
class Position {
  x: number;
  y: number;
  z: number;
  constructor(x: string) {}
}
const point: Point = new Position('');

//如果类中存在私有成员（private）或保护成员（protected），那么确定兼容关系时，TypeScript 要求私有成员和保护成员来自同一个类，这意味着两个类需要存在继承关系。

// 情况一
class A {
  private name = 'a';
}
class B extends A {
}
const a:A = new B();
// 情况二
class A {
  protected name = 'a';
}
class B extends A {
  protected name = 'b';
}
const a:A = new B();
```

## 类的继承

```js
//extends 关键字继承另一个类（这里又称“基类”）的所有属性和方法
class A {
  greet() {
    console.log('Hello, world!');
  }
}
class B extends A {}
const b = new B();
b.greet(); // "Hello, world!"
//子类可以覆盖基类的同名方法。
class B extends A {
  greet(name?: string) {
    if (name === undefined) {
      super.greet();
    } else {
      console.log(`Hello, ${name}`);
    }
  }
}
//子类的同名方法不能与基类的类型定义相冲突。
class B extends A {
  // 报错
  greet(name: string) {
    console.log(`Hello, ${name}`);
  }
}
//如果基类包括保护成员（protected修饰符），子类可以将该成员的可访问性设置为公开（public修饰符），也可以保持保护成员不变，但是不能改用私有成员（private修饰符
class A {
  protected x: string = '';
  protected y: string = '';
  protected z: string = '';
}
class B extends A {
  // 正确
  public x:string = '';
  // 正确
  protected y:string = '';
  // 报错
  private z: string = '';
}

//extends关键字后面不一定是类名，可以是一个表达式，只要它的类型是构造函数就可以了
// 例一
class MyArray extends Array<number> {}
// 例二
class MyError extends Error {}
//
interface Greeter {
  greeting(): string;
}
interface GreeterConstructor {
  new (): Greeter;
}
function getGreeterBase():GreeterConstructor {
  return Math.random() >= 0.5 ? A : B;
}
class Test extends getGreeterBase() {
  sayHello() {
    console.log(this.greeting());
  }
}

//
interface Animal {
  animalStuff: any;
}
interface Dog extends Animal {
  dogStuff: any;
}
class AnimalHouse {
  resident: Animal;
  constructor(animal:Animal) {
    this.resident = animal;
  }
}
class DogHouse extends AnimalHouse {
  resident: Dog;
  constructor(dog:Dog) {
    super(dog);
  }
}
const dog = {
  animalStuff: 'animal',
  dogStuff: 'dog'
};
const dogHouse = new DogHouse(dog);
console.log(dogHouse.resident) // undefined
//编译设置的target设成大于等于ES2022，或者useDefineForClassFields设成true 子类被重置为undefined
```

## 可访问性修饰符

```js
//public修饰符表示这是公开成员，外部可以自由访问。
class Greeter {
  public greet() {
    console.log("hi!");
  }
}
const g = new Greeter();
g.greet();
//private修饰符表示私有成员，只能用在当前类的内部，类的实例和子类都不能使用该成员。
class A {
  private x:number = 0;
}
const a = new A();
a.x // 报错
class B extends A {
  showX() {
    console.log(this.x); // 报错
  }
}
//子类不能定义父类私有成员的同名成员
class A {
  private x = 0;
}
class B extends A {
  x = 1; // 报错
}
const a = new A();
a['x'] // 1
if ('x' in a) { // 正确
  // ...
}

class A {
  #x = 1;
}
const a = new A();
a['x'] // 报错

//单例模式
class Singleton {
  private static instance?: Singleton;
  private constructor() {}
  static getInstance() {
    if (!Singleton.instance) {
      Singleton.instance = new Singleton();
    }
    return Singleton.instance;
  }
}
const s = Singleton.getInstance();

//protected修饰符表示该成员是保护成员，只能在类的内部使用该成员，实例无法使用该成员，但是子类内部可以使用。

class A {
  protected x = 1;
}
class B extends A {
  getX() {
    return this.x;
  }
}
const a = new A();
const b = new B();
a.x // 报错
b.getX() // 1


//子类不仅可以拿到父类的保护成员，还可以定义同名成员。

class A {
  protected x = 1;
}
class B extends A {
  x = 2;
}
//在类的外部，实例对象不能读取保护成员，但是在类的内部可以。


class A {
  constructor(
    public a: number,
    protected b: number,
    private c: number,
    readonly d: number
  ) {}
}

class A {
  constructor(
    public readonly x:number,
    protected readonly y:number,
    private readonly z:number
  ) {}
}
```

## 静态成员

静态成员是只能通过类本身使用的成员，不能通过实例对象使用。

```js
class MyClass {
  static x = 0;
  static printX() {
    console.log(MyClass.x);
  }
}
MyClass.x; // 0
MyClass.printX(); // 0

//static关键字前面可以使用 public、private、protected 修饰符。

class MyClass {
  private static x = 0;
}
MyClass.x // 报错

class MyClass {
  static #x = 0;
}
```

## 泛型类

静态成员不能使用泛型的类型参数。

```js
class Box<Type> {
  contents: Type;
  constructor(value: Type) {
    this.contents = value;
  }
}
const b: Box<string> = new Box('hello!');
```

## 抽象类，抽象成员

- 允许在类的定义前面，加上关键字 abstract，表示该类不能被实例化，只能当作其他类的模板。这种类就叫做“抽象类”

- 如果抽象类的属性前面加上 abstract，就表明子类必须给出该方法的实现。

```js
abstract class A {
  id = 1;
}
class B extends A {
  amount = 100;
}
const b = new B();
b.id // 1
b.amount // 100

abstract class A {
  abstract foo:string;
  bar:string = '';
}
class B extends A {
  foo = 'b';
}
```

1. 抽象成员只能存在于抽象类，不能存在于普通类。

2. 抽象成员不能有具体实现的代码。也就是说，已经实现好的成员前面不能加 abstract 关键字。

3. 抽象成员前也不能有 private 修饰符，否则无法在子类中实现该成员。

4. 一个子类最多只能继承一个抽象类。

## this 问题

```js
class A {
  name = 'A';
  getName() {
    return this.name;
  }
}
const a = new A();
a.getName(); // 'A'
const b = {
  name: 'b',
  getName: a.getName
};
b.getName();

//noImplicitThis 如果this的值推断为any类型，就会报错
class Rectangle {
  constructor(
    public width:number,
    public height:number
  ) {}
  getAreaFunction() {
    return function () {
      return this.width * this.height; // 报错
    };
  }
}

//this本身也可以当作类型使用，表示当前类的实例对象
class Box {
  contents:string = '';
  set(value:string):this {
    this.contents = value;
    return this;
  }
}

//this类型不允许应用于静态成员。
class A {
  static a:this; // 报错
}

//返回值类型可以写成this is Type的形式 用到了is运算符。
class FileSystemObject {
  isFile(): this is FileRep {
    return this instanceof FileRep;
  }
  isDirectory(): this is Directory {
    return this instanceof Directory;
  }
  // ...
}
```

# 泛型

函数返回值的类型与参数类型是相关的

带有“类型参数”

```js
function getFirst<T>(arr: T[]): T {
  return arr[0];
}
function comb<T>(arr1: T[], arr2: T[]): T[] {
  return arr1.concat(arr2);
}
//联合类型
//comb < number | string > ([1, 2], ['a', 'b']); // 正确

function map<T, U>(arr: T[], f: (arg: T) => U): U[] {
  return arr.map(f);
}
// 用法实例
map < string, number > (['1', '2', '3'], (n) => parseInt(n)); // 返回 [1, 2, 3]
```

```js
function id<T>(arg: T): T {
  return arg;
}

// 写法一
let myId: <T>(arg: T) => T = id;
// 写法二
let myId: { <T>(arg: T): T } = id;

interface Box<Type> {
  contents: Type;
}
let box: Box<string>;

interface Comparator<T> {
  compareTo(value: T): number;
}
class Rectangle implements Comparator<Rectangle> {
  compareTo(value: Rectangle): number {
    // ...
  }
}

interface Fn {
  <Type>(arg: Type): Type;
}
function id<Type>(arg: Type): Type {
  return arg;
}
let myId: Fn = id;

class Pair<K, V> {
  key: K;
  value: V;
}

//继承
class A<T> {
  value: T;
}
class B extends A<any> {}

const Container = class<T> {
  constructor(private readonly data:T) {}
};
const a = new Container<boolean>(true);
const b = new Container<number>(0);

class C<NumType> {
  value!: NumType;
  add!: (x: NumType, y: NumType) => NumType;
}
let foo = new C<number>();
foo.value = 0;
foo.add = function (x, y) {
  return x + y;
};
//构造函数
type MyClass<T> = new (...args: any[]) => T;
// 或者
interface MyClass<T> {
  new(...args: any[]): T;
}
// 用法实例
function createInstance<T>(
  AnyClass: MyClass<T>,
  ...args: any[]
):T {
  return new AnyClass(...args);
}
//泛型类描述的是类的实例，不包括静态属性和静态方法，因为这两者定义在类的本身。因此，它们不能引用类型参数
class C<T> {
  static data: T;  // 报错
  constructor(public value:T) {}
}
//type 命令定义的类型别名，也可以使用泛型
type Nullable<T> = T | undefined | null;

type Container<T> = { value: T };
const a: Container<number> = { value: 0 };
const b: Container<string> = { value: 'b' };

//树结构
type Tree<T> = {
  value: T;
  left: Tree<T> | null;
  right: Tree<T> | null;
};
```

```js
//类型参数的默认值
class Generic<T = string> {
  list:T[] = []
  add(t:T) {
    this.list.push(t)
  }
}
const g = new Generic<number>();
g.add(4) // 正确
g.add('hello') // 报错

//一旦类型参数有默认值，就表示它是可选参数。如果有多个类型参数，可选参数必须在必选参数之后
//<T = boolean, U> // 错误
//<T, U = boolean> // 正确

//数组的泛型
interface Array<Type> {
  length: number;
  pop(): Type|undefined;
  push(...items:Type[]): number;
  // ...
}
let arr:Array<number> = [1, 2, 3];

//约束条件
function comp<Type>(a:Type, b:Type) {
  if (a.length >= b.length) {
    return a;
  }
  return b;
}

function comp<T extends { length: number }>(
  a: T,
  b: T
) {
  if (a.length >= b.length) {
    return a;
  }
  return b;
}

comp([1, 2], [1, 2, 3]) // 正确
comp('ab', 'abc') // 正确
comp(1, 2) // 报错

//类型参数可以同时设置约束条件和默认值，前提是默认值必须满足约束条件。
type Fn<A extends string, B extends string = 'world'>
  =  [A, B];
type Result = Fn<'hello'> // ["hello", "world"]
```

## 注意

（1）尽量少用泛型。

泛型虽然灵活，但是会加大代码的复杂性，使其变得难读难写。一般来说，只要使用了泛型，类型声明通常都不太易读，容易写得很复杂。因此，可以不用泛型就不要用。

（2）类型参数越少越好。

多一个类型参数，多一道替换步骤，加大复杂性。因此，类型参数越少越好。

（3）类型参数需要出现两次。

如果类型参数在定义后只出现一次，那么很可能是不必要的。
只有当类型参数用到两次或两次以上，才是泛型的适用场合。

（4）泛型可以嵌套。

类型参数可以是另一个泛型。

# Enum 枚举

```js
enum Color {
  Red,     // 0
  Green,   // 1
  Blue     // 2
}
// 编译后
let Color = {
  Red: 0,
  Green: 1,
  Blue: 2
};

// 等同于 只读的，不能重新赋值。
enum Color {
  Red = 0,
  Green = 1,
  Blue = 2
}
let c = Color.Green; // 1
// 等同于
let c = Color['Green']; // 1

let c:Color = Color.Green; // 正确
let c:number = Color.Green; // 正确

enum Operator {
  ADD,
  DIV,
  MUL,
  SUB
}
function compute(
  op:Operator,
  a:number,
  b:number
) {
  switch (op) {
    case Operator.ADD:
      return a + b;
    case Operator.DIV:
      return a / b;
    case Operator.MUL:
      return a * b;
    case Operator.SUB:
      return a - b;
    default:
      throw new Error('wrong operator');
  }
}
compute(Operator.ADD, 1, 3) // 4


//Enum 作为类型有一个缺点，就是输入任何数值都不报错。
enum Bool {
  No,
  Yes
}
function foo(noYes:Bool) {
  // ...
}
foo(33);  // 不报错

enum Foo {
  A,
  B,
  C,
}
const Bar = {
  A: 0,
  B: 1,
  C: 2,
} as const;
if （x === Foo.A）{}
// 等同于
if (x === Bar.A) {}

enum Permission {
  UserRead     = 1 << 8,
  UserWrite    = 1 << 7,
  UserExecute  = 1 << 6,
  GroupRead    = 1 << 5,
  GroupWrite   = 1 << 4,
  GroupExecute = 1 << 3,
  AllRead      = 1 << 2,
  AllWrite     = 1 << 1,
  AllExecute   = 1 << 0,
}
enum Bool {
  No = 123,
  Yes = Math.random(),
}
//加上const修饰，表示这是常量，不能再次赋值。
const enum Color {
  Red,
  Green,
  Blue
}
const x = Color.Red;
const y = Color.Green;
const z = Color.Blue;
// 编译后
const x = 0 /* Color.Red */;
const y = 1 /* Color.Green */;
const z = 2 /* Color.Blue */;

//同名 Enum 的合并
enum Foo {
  A,
}
enum Foo {
  B = 1,
}
enum Foo {
  C = 2,
}
// 等同于
enum Foo {
  A,
  B = 1，
  C = 2
}

//字符串 Enum
enum Direction {
  Up = 'UP',
  Down = 'DOWN',
  Left = 'LEFT',
  Right = 'RIGHT',
}

enum Enum {
  One = 'One',
  Two = 'Two',
  Three = 3,
  Four = 4,
}

const enum MediaTypes {
  JSON = 'application/json',
  XML = 'application/xml',
}
const url = 'localhost';
fetch(url, {
  headers: {
    Accept: MediaTypes.JSON,
  },
}).then(response => {
  // ...
});

//联合类型（union）
function move(
  where:'Up'|'Down'|'Left'|'Right'
) {
  // ...
 }

 //keyof 运算符
 enum MyEnum {
  A = 'a',
  B = 'b'
}
// 'A'|'B'
type Foo = keyof typeof MyEnum;

type Foo = keyof MyEnum;
// "toString" | "toFixed" | "toExponential" |
// "toPrecision" | "valueOf" | "toLocaleString"

// { a：any, b: any }
type Foo = { [key in MyEnum]: any };

//反向映射

enum Weekdays {
  Monday = 1,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday
}
console.log(Weekdays[3]) // Wednesday

//编译后
var Weekdays;
(function (Weekdays) {
    Weekdays[Weekdays["Monday"] = 1] = "Monday";//Weekdays["Monday"] = 1;Weekdays[1] = "Monday";
    Weekdays[Weekdays["Tuesday"] = 2] = "Tuesday";
    Weekdays[Weekdays["Wednesday"] = 3] = "Wednesday";
    Weekdays[Weekdays["Thursday"] = 4] = "Thursday";
    Weekdays[Weekdays["Friday"] = 5] = "Friday";
    Weekdays[Weekdays["Saturday"] = 6] = "Saturday";
    Weekdays[Weekdays["Sunday"] = 7] = "Sunday";
})(Weekdays || (Weekdays = {}));

//字符串不进行反向映射
enum MyEnum {
  A = 'a',
  B = 'b'
}
// 编译后
var MyEnum;
(function (MyEnum) {
    MyEnum["A"] = "a";
    MyEnum["B"] = "b";
})(MyEnum || (MyEnum = {}));
```

## preserveConstEnums

如果希望加上 const 关键词后，运行时还能访问 Enum 结构（即编译后依然将 Enum 转成对象），需要在编译时打开 preserveConstEnums 编译选项。

# 类型断言

```js
type T = 'a' | 'b' | 'c';
let foo = 'a';
let bar: T = foo; // 报错

let bar:T = foo as T; // 正确

// 语法一：<类型>值
//<Type>value
// 语法二：值 as 类型
//value as Type

// 语法一
//let bar:T = <T>foo;
// 语法二
//let bar:T = foo as T;

// 正确
const p0:{ x: number } =
  { x: 0, y: 0 } as { x: number };
// 正确
const p1:{ x: number } =
  { x: 0, y: 0 } as { x: number; y: number };

  const username = document.getElementById('username');
if (username) {
  (username as HTMLInputElement).value; // 正确
}

const s1:number|string = 'hello';
const s2:number = s1 as number;

const n = 1;
const m:string = n as unknown as string; // 正确

let s = 'JavaScript' as const;
type Lang =
  |'JavaScript'
  |'TypeScript'
  |'Python';
function setLang(language:Lang) {
  /* ... */
}
setLang(s);

// a1 的类型推断为 number[]
const a1 = [1, 2, 3];
// a2 的类型推断为 readonly [1, 2, 3]
const a2 = [1, 2, 3] as const;

const v1 = {
  x: 1,
  y: 2,
}; // 类型是 { x: number; y: number; }
const v2 = {
  x: 1 as const,
  y: 2,
}; // 类型是 { x: 1; y: number; }
const v3 = {
  x: 1,
  y: 2,
} as const; // 类型是 { readonly x: 1; readonly y: 2; }


function add(x:number, y:number) {
  return x + y;
}
const nums = [1, 2] as const;
const total = add(...nums); // 正确

enum Foo {
  X,
  Y,
}
let e1 = Foo.X;            // Foo
let e2 = Foo.X as const;   // Foo.X


//非空断言
function f(x?:number|null) {
  validateNumber(x); // 自定义函数，确保 x 是数值
  console.log(x!.toFixed());
}
function validateNumber(e?:number|null) {
  if (typeof e !== 'number')
    throw new Error('Not a number');
}

const root = document.getElementById('root')!;


class Point {
  x!:number; // 正确
  y!:number; // 正确
  constructor(x:number, y:number) {
    // ...
  }
}


//断言函数
function isString(value:unknown):void {
  if (typeof value !== 'string')
    throw new Error('Not a string');
}
const aValue:string|number = 'Hello';
isString(aValue);

function isString(value:unknown):asserts value is string {
  if (typeof value !== 'string')
    throw new Error('Not a string');
}

type AccessLevel = 'r' | 'w' | 'rw';
function allowsReadAccess(
  level:AccessLevel
):asserts level is 'r' | 'rw' {
  if (!level.includes('r'))
    throw new Error('Read not allowed');
}

function assertIsDefined<T>(
  value:T
):asserts value is NonNullable<T> {
  if (value === undefined || value === null) {
    throw new Error(`${value} is not defined`)
  }
}

// 写法一
const assertIsNumber = (
  value:unknown
):asserts value is number => {
  if (typeof value !== 'number')
    throw Error('Not a number');
};
// 写法二
type AssertIsNumber =
  (value:unknown) => asserts value is number;
const assertIsNumber:AssertIsNumber = (value) => {
  if (typeof value !== 'number')
    throw Error('Not a number');
};


function isString(
  value:unknown
):value is string {
  return typeof value === 'string';
}

function assert(x:unknown):asserts x {
  if (!x) {
    throw new Error(`${x} should be a truthy value.`);
  }
}


type Person = {
  name: string;
  email?: string;
};
function loadPerson(): Person | null {
  return null;
}
let person = loadPerson();
function assert(
  condition: unknown,
  message: string
):asserts condition {
  if (!condition) throw new Error(message);
}
// Error: Person is not defined
assert(person, 'Person is not defined');
console.log(person.name);
```

# 模块

```js
type Bool = true | false;
export { Bool };

import { Bool } from './a';
let foo: Bool = true;

// a.ts
export interface A {
  foo: string;
}
export let a = 123;
// b.ts
import { A, a } from './a';

import { type A, a } from './a';
//import type DefaultType from 'moduleA';
import type { A } from './a';

//输入所有类型
import type * as TypeNS from 'moduleA';

type A = 'a';
type B = 'b';
// 方法一
export {type A, type B};
// 方法二
export type {A, B};

class Point {
  x: number;
  y: number;
}
export type { Point };

import type { Point } from './module';
const p:Point = { x: 0, y: 0 };


//commonJs node.js
import fs = require('fs');
const code = fs.readFileSync('hello.ts', 'utf8');
import * as fs from 'fs';
// 等同于
import fs = require('fs');

let obj = { foo: 123 };
export = obj;

import obj = require('./a');
console.log(obj.foo); // 123
```

## importsNotUsedAsValues

（1）remove：这是默认值，自动删除输入类型的 import 语句。

（2）preserve：保留输入类型的 import 语句。

（3）error：保留输入类型的 import 语句（与 preserve 相同），但是必须写成 import type 的形式，否则报错。

## 模块定位

一种称为 Classic 方法，另一种称为 Node 方法。可以使用编译参数 moduleResolution，指定使用哪一种方法。

相对模块指的是路径以/、./、../开头的模块。下面 import 语句加载的模块，都是相对模块。

```js
import Entry from './components/Entry';
import { DefaultHeaders } from '../constants/http';
import '/mod';
```

非相对模块指的是不带有路径信息的模块。下面 import 语句加载的模块，都是非相对模块。

```js
import * as $ from 'jquery';
import { Component } from '@angular/core';
```

相对模块依然是以当前脚本的路径作为“基准路径”。比如，脚本文件 a.ts 里面有一行代码 let x = require("./b");，TypeScript 按照以下顺序查找。

1. 当前目录是否包含 b.ts、b.tsx、b.d.ts。
2. 当前目录是否有子目录 b，该子目录是否存在文件 package.json，该文件的 types 字段是否指定了入口文件，如果是的就加载该文件。
3. 当前目录的子目录 b 是否包含 index.ts、index.tsx、index.d.ts。

非相对模块则是以当前脚本的路径作为起点，逐级向上层目录查找是否存在子目录 node_modules。比如，脚本文件 a.js 有一行 let x = require("b");，TypeScript 按照以下顺序进行查找。

1. 当前目录的子目录 node_modules 是否包含 b.ts、b.tsx、b.d.ts。
2. 当前目录的子目录 node_modules，是否存在文件 package.json，该文件的 types 字段是否指定了入口文件，如果是的就加载该文件。
3. 当前目录的子目录 node_modules 里面，是否包含子目录@types，在该目录中查找文件 b.d.ts。
4. 当前目录的子目录 node_modules 里面，是否包含子目录 b，在该目录中查找 index.ts、index.tsx、index.d.ts。
5. 进入上一层目录，重复上面 4 步，直到找到为止。

## 路径映射

```js
//baseUrl字段可以手动指定脚本模块的基准目录。
{
  "compilerOptions": {
    "baseUrl": "."
  }
}
//paths字段指定非相对路径的模块与实际脚本的映射。
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "jquery": ["node_modules/jquery/dist/jquery"]
    }
  }
}
//rootDirs字段指定模块定位时必须查找的其他目录。
{
  "compilerOptions": {
    "rootDirs": ["src/zh", "src/de", "src/#{locale}"]
  }
}

//tsc 命令有一个--traceResolution参数，能够在编译时在命令行显示模块定位的每一步

//tsc 命令的--noResolve参数，表示模块定位时，只考虑在命令行传入的模块。
```

# namespace

namespace 用来建立一个容器，内部的所有变量和函数，都必须在这个容器里面使用。

```js
namespace Utils {
  function isString(value:any) {
    return typeof value === 'string';
  }
  // 正确
  isString('yes');
}
Utils.isString('no'); // 报错

namespace Utility {
  export function log(msg:string) {
    console.log(msg);
  }
  export function error(msg:string) {
    console.error(msg);
  }
}
Utility.log('Call me');
Utility.error('maybe!');

//编译后
var Utility;
(function (Utility) {
  function log(msg) {
    console.log(msg);
  }
  Utility.log = log;
  function error(msg) {
    console.error(msg);
  }
  Utility.error = error;
})(Utility || (Utility = {}));

namespace Utils {
  export function isString(value:any) {
    return typeof value === 'string';
  }
}
namespace App {
  import isString = Utils.isString;
  isString('yes');
  // 等同于
  Utils.isString('yes');
}

namespace Shapes {
  export namespace Polygons {
    export class Triangle {}
    export class Square {}
  }
}
import polygons = Shapes.Polygons;
// 等同于 new Shapes.Polygons.Square()
let sq = new polygons.Square();

namespace Utils {
  export namespace Messaging {
    export function log(msg:string) {
      console.log(msg);
    }
  }
}
Utils.Messaging.log('hello') // "hello"

//namespace 不仅可以包含实义代码，还可以包括类型代码。
namespace N {
  export interface MyInterface{}
  export class MyClass{}
}

//如果 namespace 代码放在一个单独的文件里，那么引入这个文件需要使用三斜杠的语法。
/// <reference path = "SomeFileName.ts" />
```

namespace 与模块的作用是一致的，都是把相关代码组织在一起，对外输出接口。区别是一个文件只能有一个模块，但可以有多个 namespace。由于模块可以取代 namespace，而且是 JavaScript 的标准语法，还不需要编译转换，所以建议总是使用模块，替代 namespace。

```js
// shapes.ts
export namespace Shapes {
  export class Triangle {
    // ...
  }
  export class Square {
    // ...
  }
}
// 写法一
import { Shapes } from './shapes';
let t = new Shapes.Triangle();
// 写法二
import * as shapes from "./shapes";
let t = new shapes.Shapes.Triangle();


namespace Animals {
  export class Cat {}
}
namespace Animals {
  export interface Legged {
    numberOfLegs: number;
  }
  export class Dog {}
}
// 等同于
namespace Animals {
  export interface Legged {
    numberOfLegs: number;
  }
  export class Cat {}
  export class Dog {}
}
```

# 装饰器

装饰器（Decorator）是一种语法结构，用来在定义时修改类（class）的行为。

（1）第一个字符（或者说前缀）是@，后面是一个表达式。

（2）@后面的表达式，必须是一个函数（或者执行后可以得到一个函数）。

（3）这个函数接受所修饰对象的一些相关值作为参数。

（4）这个函数要么不返回值，要么返回一个新对象取代所修饰的目标对象。

```js
function simpleDecorator(target: any, context: any) {
  console.log('hi, this is ' + target);
  return target;
}
@simpleDecorator
class A {} // "hi, this is class A {}"

@myFunc
@myFuncFactory(arg1, arg2)
@libraryModule.prop
@someObj.method(123)
@wrap(dict['prop'])
@frozen
class Foo {
  @configurable(false)
  @enumerable(true)
  method() {}
  @throttle(500)
  expensiveMethod() {}
}
//$ tsc --target ES5 --experimentalDecorators


//装饰器类型
type Decorator = (
  value: DecoratedValue,
  context: {
    kind: string;
    name: string | symbol;
    addInitializer?(initializer: () => void): void;
    static?: boolean;
    private?: boolean;
    access: {
      get?(): unknown;
      set?(value: unknown): void;
    };
  }
) => void | ReplacementValue;
```

value：所装饰的对象。

context：上下文对象，TypeScript 提供一个原生接口 ClassMethodDecoratorContext，描述这个对象。

context 对象的属性，根据所装饰对象的不同而不同，其中只有两个属性（kind 和 name）是必有的，其他都是可选的。

（1）kind：字符串，表示所装饰对象的类型，可能取以下的值。

- class
- method
- getter
- setter
- field
- accessor

这表示一共有六种类型的装饰器。

（2）name：字符串或者 Symbol 值，所装饰对象的名字，比如类名、属性名等。

（3）addInitializer()：函数，用来添加类的初始化逻辑。以前，这些逻辑通常放在构造函数里面，对方法进行初始化，现在改成以函数形式传入 addInitializer()方法。注意，addInitializer()没有返回值。

（4）private：布尔值，表示所装饰的对象是否为类的私有成员。

（5）static：布尔值，表示所装饰的对象是否为类的静态成员。

（6）access：一个对象，包含了某个值的 get 和 set 方法。

## 类装饰器

```js

type ClassDecorator = (
  value: Function,
  context: {
    kind: 'class',
    name: string | undefined,
    addInitializer(initializer: () => void): void
  }
) => Function | void;

function Greeter(value, context) {
  if (context.kind === 'class') {
    value.prototype.greet = function () {
      console.log('你好');
    };
  }
}
@Greeter
class User {}
let u = new User();
u.greet(); // "你好"

//类装饰器可以返回一个函数，替代当前类的构造方法。
function countInstances(value:any, context:any) {
  let instanceCount = 0;
  const wrapper = function (...args:any[]) {
    instanceCount++;
    const instance = new value(...args);
    instance.count = instanceCount;
    return instance;
  } as unknown as typeof MyClass;
  wrapper.prototype = value.prototype; // A
  return wrapper;
}
@countInstances
class MyClass {}
const inst1 = new MyClass();
inst1 instanceof MyClass // true
inst1.count // 1

//类装饰器也可以返回一个新的类，替代原来所装饰的类。
function countInstances(value:any, context:any) {
  let instanceCount = 0;
  return class extends value {
    constructor(...args:any[]) {
      super(...args);
      instanceCount++;
      this.count = instanceCount;
    }
  };
}

//通过类装饰器，禁止使用new命令新建类的实例。
function functionCallable(
  value as any, {kind} as any
) {
  if (kind === 'class') {
    return function (...args) {
      if (new.target !== undefined) {
        throw new TypeError('This function can’t be new-invoked');
      }
      return new value(...args);
    }
  }
}
@functionCallable
class Person {
  constructor(name) {
    this.name = name;
  }
}
const robin = Person('Robin');
robin.name // 'Robin'


//类装饰器的上下文对象context的addInitializer()方法，用来定义一个类的初始化函数，在类完全定义结束后执行。
function customElement(name: string) {
  return <Input extends new (...args: any) => any>(
    value: Input,
    context: ClassDecoratorContext
  ) => {
    context.addInitializer(function () {
      customElements.define(name, value);
    });
  };
}
@customElement("hello-world")
class MyComponent extends HTMLElement {
  constructor() {
    super();
  }
  connectedCallback() {
    this.innerHTML = `<h1>Hello World</h1>`;
  }
}
```

## 方法装饰器

```js
type ClassMethodDecorator = (
  value: Function,
  context: {
    kind: 'method';
    name: string | symbol;
    static: boolean;
    private: boolean;
    access: { get: () => unknown };
    addInitializer(initializer: () => void): void;
  }
) => Function | void;



function trace(decoratedMethod) {
  // ...
}
class C {
  @trace
  toString() {
    return 'C';
  }
}
// `@trace` 等同于
// C.prototype.toString = trace(C.prototype.toString);

function replaceMethod() {
  return function () {
    return `How are you, ${this.name}?`;
  }
}
class Person {
  constructor(name) {
    this.name = name;
  }
  @replaceMethod
  hello() {
    return `Hi ${this.name}!`;
  }
}
const robin = new Person('Robin');
robin.hello() // 'How are you, Robin?'


class Person {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  @log
  greet() {
    console.log(`Hello, my name is ${this.name}.`);
  }
}
function log(originalMethod:any, context:ClassMethodDecoratorContext) {
  const methodName = String(context.name);
  function replacementMethod(this: any, ...args: any[]) {
    console.log(`LOG: Entering method '${methodName}'.`)
    const result = originalMethod.call(this, ...args);
    console.log(`LOG: Exiting method '${methodName}'.`)
    return result;
  }
  return replacementMethod;
}
const person = new Person('张三');
person.greet()
// "LOG: Entering method 'greet'."
// "Hello, my name is 张三."
// "LOG: Exiting method 'greet'."


function delay(milliseconds: number = 0) {
  return function (value, context) {
    if (context.kind === "method") {
      return function (...args: any[]) {
        setTimeout(() => {
          value.apply(this, args);
        }, milliseconds);
      };
    }
  };
}
class Logger {
  @delay(1000)
  log(msg: string) {
    console.log(`${msg}`);
  }
}
let logger = new Logger();
logger.log("Hello World");


class Person {
  name: string;
  constructor(name: string) {
    this.name = name;
    // greet() 绑定 this
    this.greet = this.greet.bind(this);
  }
  greet() {
    console.log(`Hello, my name is ${this.name}.`);
  }
}
const g = new Person('张三').greet;
g() // "Hello, my name is 张三."


function bound(
  originalMethod:any, context:ClassMethodDecoratorContext
) {
  const methodName = context.name;
  if (context.private) {
    throw new Error(`不能绑定私有方法 ${methodName as string}`);
  }
  context.addInitializer(function () {
    this[methodName] = this[methodName].bind(this);
  });
}


function collect(
  value,
  {name, addInitializer}
) {
  addInitializer(function () {
    if (!this.collectedMethodKeys) {
      this.collectedMethodKeys = new Set();
    }
    this.collectedMethodKeys.add(name);
  });
}
class C {
  @collect
  toString() {}
  @collect
  [Symbol.iterator]() {}
}
const inst = new C();
inst.@collect // new Set(['toString', Symbol.iterator])

```

## 属性装饰器

```js
function twice() {
  return (initialValue) => initialValue * 2;
}
class C {
  @twice
  field = 3;
}
const inst = new C();
inst.field; // 6

let acc;
function exposeAccess(value, { access }) {
  acc = access;
}
class Color {
  @exposeAccess
  name = 'green';
}
const green = new Color();
green.name; // 'green'
acc.get(green); // 'green'
acc.set(green, 'red');
green.name; // 'red'
```

## getter 装饰器，setter 装饰器

```js
class C {
  @lazy
  get value() {
    console.log('正在计算……');
    return '开销大的计算结果';
  }
}
function lazy(value: any, { kind, name }: any) {
  if (kind === 'getter') {
    return function (this: any) {
      const result = value.call(this);
      Object.defineProperty(this, name, {
        value: result,
        writable: false
      });
      return result;
    };
  }
  return;
}
const inst = new C();
inst.value;
// 正在计算……
// '开销大的计算结果'
inst.value;
// '开销大的计算结果'
```

## accessor 装饰器

```js
class C {
  accessor x = 1;
}
//等同于
class C {
  #x = 1;
  get x() {
    return this.#x;
  }
  set x(val) {
    this.#x = val;
  }
}
class C {
  static accessor x = 1;
  accessor #y = 2;
}


type ClassAutoAccessorDecorator = (
  value: {
    get: () => unknown;
    set(value: unknown) => void;
  },
  context: {
    kind: "accessor";
    name: string | symbol;
    access: { get(): unknown, set(value: unknown): void };
    static: boolean;
    private: boolean;
    addInitializer(initializer: () => void): void;
  }
) => {
  get?: () => unknown;
  set?: (value: unknown) => void;
  init?: (initialValue: unknown) => unknown;
} | void;


class C {
  @logged accessor x = 1;
}
function logged(value, { kind, name }) {
  if (kind === "accessor") {
    let { get, set } = value;
    return {
      get() {
        console.log(`getting ${name}`);
        return get.call(this);
      },
      set(val) {
        console.log(`setting ${name} to ${val}`);
        return set.call(this, val);
      },
      init(initialValue) {
        console.log(`initializing ${name} with value ${initialValue}`);
        return initialValue;
      }
    };
  }
}
let c = new C();
c.x;
// getting x
c.x = 123;
// setting x to 123
```

## 装饰器的执行顺序

装饰器的执行分为两个阶段。

（1）评估（evaluation）：计算@符号后面的表达式的值，得到的应该是函数。

（2）应用（application）：将评估装饰器后得到的函数，应用于所装饰对象。

也就是说，装饰器的执行顺序是，先评估所有装饰器表达式的值，再将其应用于当前类。

应用装饰器时，顺序依次为方法装饰器和属性装饰器，然后是类装饰器。

```js
function d(str: string) {
  console.log(`评估 @d(): ${str}`);
  return (value: any, context: any) => console.log(`应用 @d(): ${str}`);
}
function log(str: string) {
  console.log(str);
  return str;
}
@d('类装饰器')
class T {
  @d('静态属性装饰器')
  static staticField = log('静态属性值');
  @d('原型方法')
  [log('计算方法名')]() {}
  @d('实例属性')
  instanceField = log('实例属性值');
}

// "评估 @d(): 类装饰器"
// "评估 @d(): 静态属性装饰器"
// "评估 @d(): 原型方法"
// "计算方法名"
// "评估 @d(): 实例属性"
// "应用 @d(): 原型方法"
// "应用 @d(): 静态属性装饰器"
// "应用 @d(): 实例属性"
// "应用 @d(): 类装饰器"
// "静态属性值"
```

（1）装饰器评估：这一步计算装饰器的值，首先是类装饰器，然后是类内部的装饰器，按照它们出现的顺序。

注意，如果属性名或方法名是计算值（本例是“计算方法名”），则它们在对应的装饰器评估之后，也会进行自身的评估。

（2）装饰器应用：实际执行装饰器函数，将它们与对应的方法和属性进行结合。

原型方法的装饰器首先应用，然后是静态属性和静态方法装饰器，接下来是实例属性装饰器，最后是类装饰器。

注意，“实例属性值”在类初始化的阶段并不执行，直到类实例化时才会执行。

如果一个方法或属性有多个装饰器，则内层的装饰器先执行，外层的装饰器后执行。

```js
class Person {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  @bound
  @log
  greet() {
    console.log(`Hello, my name is ${this.name}.`);
  }
}
```

# declare

declare 关键字用来告诉编译器，某个类型是存在的，可以在当前文件中使用。

- 变量（const、let、var 命令声明）
- type 或者 interface 命令声明的类型
- class
- enum
- 函数（function）
- 模块（module）
- 命名空间（namespace）

```js
declare var document;
document.title = 'Hello';

declare function sayHello(
  name:string
):void;
sayHello('张三');

declare class Animal {
  constructor(name:string);
  eat():void;
  sleep():void;
}


declare class C {
  // 静态成员
  public static s0():string;
  private static s1:string;
  // 属性
  public a:number;
  private b:number;
  // 构造函数
  constructor(arg:number);
  // 方法
  m(x:number, y:number):number;
  // 存取器
  get c():number;
  set c(value:number);
  // 索引签名
  [index:string]:any;
}

//declare module，declare namespace 加不加 export 关键字都可以

declare namespace AnimalLib {
  class Animal {
    constructor(name:string);
    eat():void;
    sleep():void;
  }
  type Animals = 'Fish' | 'Dog';
}
// 或者
declare module AnimalLib {
  class Animal {
    constructor(name:string);
    eat(): void;
    sleep(): void;
  }
  type Animals = 'Fish' | 'Dog';
}
let aa=new AnimalLib.Animal('Fish')

import { Foo as Bar } from 'moduleA';
declare module 'moduleA' {
  interface Bar extends Foo {
    custom: {
      prop1:string;
    }
  }
}

//一个项目有多个模块，可以在一个模型中，对另一个模块的接口进行类型扩展。
// a.ts
export interface A {
  x: number;
}
// b.ts
import { A } from './a';
declare module './a' {
  interface A {
    y: number;
  }
}
const a:A = { x: 0, y: 0 };
```

使用这种语法进行模块的类型扩展时，有两点需要注意：

（1）declare module NAME 语法里面的模块名 NAME，跟 import 和 export 的模块名规则是一样的，且必须跟当前文件加载该模块的语句写法（上例 import { A } from './a'）保持一致。

（2）不能创建新的顶层类型。也就是说，只能对 a.ts 模块中已经存在的类型进行扩展，不允许增加新的顶层类型，比如新定义一个接口 B。

（3）不能对默认的 default 接口进行扩展，只能对 export 命令输出的命名接口进行扩充。这是因为在进行类型扩展时，需要依赖输出的接口名。

```js
//使用通配符
declare module 'my-plugin-*' {
  interface PluginOptions {
    enabled: boolean;
    priority: number;
  }
  function initialize(options: PluginOptions): void;
  export = initialize;
}

//global

export {};
declare global {
  interface String {
    toSmallString(): string;
  }
}
String.prototype.toSmallString = ():string => {
  // 具体实现
  return '';
};


export {};
declare global {
  interface window {
    myAppConfig:object;
  }
}
const config = window.myAppConfig;


declare enum E1 {
  A,
  B,
}
declare enum E2 {
  A = 0,
  B = 1,
}
declare const enum E3 {
  A,
  B,
}
declare const enum E4 {
  A = 0,
  B = 1,
}

//定义一个.d.ts文件，把该脚本用到的类型定义都放在这个文件里面
declare module "url" {
  export interface Url {
    protocol?: string;
    hostname?: string;
    pathname?: string;
  }
  export function parse(
    urlStr: string,
    parseQueryString?,
    slashesDenoteHost?
  ): Url;
}
declare module "path" {
  export function normalize(p: string): string;
  export function join(...paths: any[]): string;
  export var sep: string;
}
//使用时，自己的脚本使用三斜杠命令，加载这个类型声明文件。
/// <reference path="node.d.ts"/>
```

# d.ts 类型声明文件

```js
export function getArrayLength(arr: any[]): number;
export const maxInterval: 12;


// 模块输出
module.exports = 3.142;
// 类型输出文件
// 写法一
declare const pi: number;
export default pi;
// 写法二
declare const pi: number;
export= pi;


// types.d.ts
export interface Character {
  catchphrase?: string;
  name: string;
}
//类型声明文件也可以包括在项目的 tsconfig.json 文件里面，这样的话，编译器打包项目时，会自动将类型声明文件加入编译，而不必在每个脚本里面加载类型声明文件。
{
  "compilerOptions": {},
  "files": [
    "src/index.ts",
    "typings/moment.d.ts"
  ]
}
```

## 类型声明文件的来源

- TypeScript 编译器自动生成。

```js
{
  "compilerOptions": {
    "declaration": true
  }
}
$ tsc --declaration
```

- TypeScript 内置类型文件。

```js
//TypeScript 编译器会自动根据编译目标target的值，加载对应的内置声明文件，所以不需要特别的配置。但是，可以使用编译选项lib，指定加载哪些内置声明文件。
{
  "compilerOptions": {
    "lib": ["dom", "es2021"]
  }
}
```

- 外部模块的类型声明文件，需要自己安装。

  @types 名称空间之下
  `https://github.com/DefinitelyTyped/DefinitelyTyped`

```js
$ npm install @types/jquery --save-dev

//TypeScript 会自动加载node_modules/@types目录下的模块，但可以使用编译选项typeRoots改变这种行为。
{
  "compilerOptions": {
    "typeRoots": ["./typings", "./vendor/types"]
  }
}

//默认情况下，TypeScript 会自动加载typeRoots目录里的所有模块，编译选项types可以指定加载哪些模块。

{
  "compilerOptions": {
    "types" : ["jquery"]
  }
}
```

```js
declare module 'moment' {
  export interface Moment {
    format(format:string): string;
    add(
      amount: number,
      unit: 'days' | 'months' | 'years'
    ): Moment;
    subtract(
      amount:number,
      unit:'days' | 'months' | 'years'
    ): Moment;
  }
  function moment(
    input?: string | Date
  ): Moment;
  export default moment;
}

declare namespace D3 {
  export interface Selectors {
    select: {
      (selector: string): Selection;
      (element: EventTarget): Selection;
    };
  }
  export interface Event {
    x: number;
    y: number;
  }
  export interface Base extends Selectors {
    event: Event;
  }
}
declare var d3: D3.Base;
```

## 发布模块

当前模块如果包含自己的类型声明文件，可以在 package.json 文件里面添加一个 types 字段或 typings 字段，指明类型声明文件的位置。

```js
{
  "name": "awesome",
  "author": "Vandelay Industries",
  "version": "1.0.0",
  "main": "./lib/main.js",
  "types": "./lib/main.d.ts"
}
```

## 三斜杆

```js
//当前脚本依赖于 Node.js 类型声明文件
/// <reference path="node.d.ts"/>
import * as URL from 'url';
let myUrl = URL.parse('https://www.typescriptlang.org');

//安装到node_modules/@types目录中的子目录
/// <reference types="node" />

//命令允许脚本文件显式包含内置 lib 库，等同于在tsconfig.json文件里面使用lib属性指定 lib 库。
/// <reference lib="es2017.string" />
```

# 类型运算符 keyof

```js
type MyObj = {
  foo: number,
  bar: string,
};
type Keys = keyof MyObj; // 'foo'|'bar'

interface T {
  0: boolean;
  a: string;
  b(): void;
}
type KeyT = keyof T; // 0 | 'a' | 'b'

// string | number | symbol
type KeyT = keyof any;

type MyKeys<Obj extends object> = Capital<string & keyof Obj>;

//精确表达对象的属性类型
function prop<Obj, K extends keyof Obj>(
  obj:Obj, key:K
):Obj[K] {
  return obj[key];
}

//将一个类型的所有属性逐一映射成其他值
type NewProps<Obj> = {
  [Prop in keyof Obj]: boolean;
};
// 用法
type MyObj = { foo: number; };
// 等于 { foo: boolean; }
type NewObj = NewProps<MyObj>;

//去掉 readonly 修饰符
type Mutable<Obj> = {
  -readonly [Prop in keyof Obj]: Obj[Prop];
};
// 用法
type MyObj = {
  readonly foo: number;
}
// 等于 { foo: number; }
type NewObj = Mutable<MyObj>;

//让可选属性变成必有的属性。
type Concrete<Obj> = {
  [Prop in keyof Obj]-?: Obj[Prop];
};
// 用法
type MyObj = {
  foo?: number;
}
// 等于 { foo: number; }
type NewObj = Concrete<MyObj>;
```

# in 运算符

```js
type U = 'a'|'b'|'c';
type Foo = {
  [Prop in U]: number;
};
// 等同于
type Foo = {
  a: number,
  b: number,
  c: number
};
```

# 方括号运算符

```js
type Person = {
  age: number,
  name: string,
  alive: boolean
};
// Age 的类型是 number
type Age = Person['age'];

// MyArray 的类型是 { [key:number]：string }
const MyArray = ['a', 'b', 'c'];
// 等同于 (typeof MyArray)[number]
// 返回 string
type Person = (typeof MyArray)[number];
```

# extends…?: 条件运算符

```js
// true
type T = 1 extends number ? true : false;

interface Animal {
  live(): void;
}
interface Dog extends Animal {
  woof(): void;
}
// number
type T1 = Dog extends Animal ? number : string;
// string
type T2 = RegExp extends Animal ? number : string;


(A|B) extends U ? X : Y
// 等同于
(A extends U ? X : Y) |
(B extends U ? X : Y)


type LiteralTypeName<T> =
  T extends undefined ? "undefined" :
  T extends null ? "null" :
  T extends boolean ? "boolean" :
  T extends number ? "number" :
  T extends bigint ? "bigint" :
  T extends string ? "string" :
  never;
```

# infer 关键字

定义泛型里面推断出来的类型参数

```js
type Flatten<Type> =
  Type extends Array<infer Item> ? Item : Type;

  type ReturnPromise<T> =
  T extends (...args: infer A) => infer R
  ? (...args: A) => Promise<R>
  : T;

  type MyType<T> =
  T extends {
    a: infer M,
    b: infer N
  } ? [M, N] : never;
// 用法示例
type T = MyType<{ a: string; b: number }>;
// [string, number]


type Str = 'foo-bar';
type Bar = Str extends `foo-${infer rest}` ? rest : never // 'bar'
```

# is 运算符

is 运算符总是用于描述函数的返回值类型，写法采用 parameterName is Type 的形式，即左侧为当前函数的参数名，右侧为某一种类型。它返回一个布尔值，表示左侧参数是否属于右侧的类型。

```js
function isFish(
  pet: Fish|Bird
):pet is Fish {
  return (pet as Fish).swim !== undefined;
}

type A = { a: string };
type B = { b: string };
function isTypeA(x: A|B): x is A {
  if ('a' in x) return true;
  return false;
}
```

# 模板字符串

```js
type World = "world";
// "hello world"
type Greeting = `hello ${World}`;

type T = 'A'|'B';
type U = '1'|'2';
// 'A1'|'A2'|'B1'|'B2'
type V = `${T}${U}`;
```

# 类型映射

```js
type A = {
  foo: number;
  bar: number;
};
type B = {
  [prop in keyof A]: string;
};
 //复制原始类型
type B = {
  [prop in keyof A]: A[prop];
};
//映射写成泛型

type ToBoolean<Type> = {
  [Property in keyof Type]: boolean;
};

type MyObj = {
  [P in 0|1|2]: string;
};
// 等同于
type MyObj = {
  0: string;
  1: string;
  2: string;
};


type MyObj = {
  [p in string]: boolean;
};
// 等同于
type MyObj = {
  [p: string]: boolean;
};

//某个对象的所有属性改成可选属性
type B = {
  [Prop in keyof A]?: A[Prop];
};


// 将 T 的所有属性改为只读属性
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};
```

## 映射修饰符

+修饰符：写成+?或+readonly，为映射属性添加?修饰符或 readonly 修饰符。
–修饰符：写成-?或-readonly，为映射属性移除?修饰符或 readonly 修饰符。

```js
// 添加可选属性
type Optional<Type> = {
  [Prop in keyof Type]+?: Type[Prop];
};
// 移除可选属性
type Concrete<Type> = {
  [Prop in keyof Type]-?: Type[Prop];
};

// 添加 readonly
type CreateImmutable<Type> = {
  +readonly [Prop in keyof Type]: Type[Prop];
};
// 移除 readonly
type CreateMutable<Type> = {
  -readonly [Prop in keyof Type]: Type[Prop];
};

//同时增删?和readonly
// 增加
type MyObj<T> = {
  +readonly [P in keyof T]+?: T[P];
};
// 移除
type MyObj<T> = {
  -readonly [P in keyof T]-?: T[P];
}

type A<T> = {
  +readonly [P in keyof T]+?: T[P];
};
// 等同于
type B<T> = {
  readonly [P in keyof T]?: T[P];
};
```

## 键名重映射

```js
type A = {
  foo: number;
  bar: number;
};
type B = {
  [p in keyof A as `${p}ID`]: number;
};
// 等同于
type B = {
  fooID: number;
  barID: number;
}；



interface Person {
  name: string;
  age: number;
  location: string;
}
type Getters<T> = {
  [P in keyof T
    as `get${Capitalize<string & P>}`]: () => T[P];
};
type LazyPerson = Getters<Person>;
// 等同于
type LazyPerson = {
  getName: () => string;
  getAge: () => number;
  getLocation: () => string;
}
```

## 属性过滤

```js
//只保留字符串属性
type User = {
  name: string,
  age: number
}
type Filter<T> = {
  [K in keyof T
    as T[K] extends string ? K : never]: string
}
type FilteredUser = Filter<User> // { name: string }
```

## 联合类型的映射

```js
type S = {
  kind: 'square',
  x: number,
  y: number,
};
type C = {
  kind: 'circle',
  radius: number,
};
type MyEvents<Events extends { kind: string }> = {
  [E in Events as E['kind']]: (event: E) => void;
}
type Config = MyEvent<S|C>;
// 等同于
type Config = {
  square: (event:S) => void;
  circle: (event:C) => void;
}
```

# 17 个类型工具

Awaited<Type>用来取出 Promise 的返回值类型，适合用在描述 then()方法和 await 命令的参数类型。

```js
// string
type A = Awaited<Promise<string>>;
//多重promise
// number
type B = Awaited<Promise<Promise<number>>>;

// number | boolean
type C = Awaited<boolean | Promise<number>>;

type Awaited<T> =
  T extends null | undefined ? T :
  T extends object & {
    then(
      onfulfilled: infer F,
      ...args: infer _
    ): any;
  } ? F extends (
    value: infer V,
    ...args: infer _
  ) => any ? Awaited<...> : never:
  T;


```

ConstructorParameters<Type>提取构造方法 Type 的参数类型，组成一个元组类型返回。

# 注释指令

```js
// @ts-nocheck告诉编译器不对当前脚本进行类型检查，可以用于 TypeScript 脚本，也可以用于 JavaScript 脚本。
// @ts-nocheck
const element = document.getElementById(123);

// @ts-check，那么编译器将对该脚本进行类型检查，不论是否启用了checkJs编译选项。

// @ts-check
let isChecked = true;
console.log(isChceked); // 报错 拼写错误

// @ts-ignore或// @ts-expect-error，告诉编译器不对下一行代码进行类型检查，可以用于 TypeScript 脚本，也可以用于 JavaScript 脚本。

let x: number;
x = 0;
// @ts-expect-error
x = false; // 不报错
```

# JSDoc

（1）JSDoc 注释必须以`/**`开始，其中星号`（*）`的数量必须为两个。若使用其他形式的多行注释，则 JSDoc 会忽略该条注释。

（2）JSDoc 注释必须与它描述的代码处于相邻的位置，并且注释在上，代码在下。

```js
/**
 * @param {string} somebody
 */
function sayHello(somebody) {
  console.log('Hello ' + somebody);
}

//@typedef命令创建自定义类型，等同于 TypeScript 里面的类型别名。

/**
 * @typedef {(number | string)} NumberLike
 */

type NumberLike = string | number;

//@type命令定义变量的类型。

/**
 * @type {string}
 */
let a;

/**
 * @typedef {(number | string)} NumberLike
 */
/**
 * @type {NumberLike}
 */
let a = 0;

/**@type {true | false} */
let a;
/** @type {number[]} */
let b;
/** @type {Array<number>} */
let c;
/** @type {{ readonly x: number, y?: string }} */
let d;
/** @type {(s: string, b: boolean) => number} */
let e;

//@param命令用于定义函数参数的类型。

/**
 * @param {string}  x
 */
function foo(x) {}

//可选参数
/**
 * @param {string}  [x]
 */
function foo(x) {}

//指定参数默认值
/**
 * @param {string} [x="bar"]
 */
function foo(x) {}

//@return和@returns命令的作用相同，指定函数返回值的类型。

/**
 * @return {boolean}
 */
function foo() {
  return true;
}
/**
 * @returns {number}
 */
function bar() {
  return 0;
}

//@extends命令用于定义继承的基类。

/**
 * @extends {Base}
 */
class Derived extends Base {}

//@public、@protected、@private分别指定类的公开成员、保护成员和私有成员。
//@readonly指定只读成员。
class Base {
  /**
   * @public
   * @readonly
   */
  x = 0;
  /**
   *  @protected
   */
  y = 0;
}
```

# tsconfig.json

```js
{
  "compilerOptions": {
    "outDir": "./built",
    "allowJs": true,
    "target": "es5"
  },
  "include": ["./src/**/*"]
}
```

- include：指定哪些文件需要编译。
- allowJs：指定源目录的 JavaScript 文件是否原样拷贝到编译后的目录。
- outDir：指定编译产物存放的目录。
- target：指定编译产物的 JS 版本。

# tsc

```js
# 使用 tsconfig.json 的配置
$ tsc
# 只编译 index.ts
$ tsc index.ts
# 编译 src 目录的所有 .ts 文件
$ tsc src/*.ts
# 指定编译配置文件
$ tsc --project tsconfig.production.json
# 只生成类型声明文件，不编译出 JS 文件
$ tsc index.js --declaration --emitDeclarationOnly
# 多个 TS 文件编译成单个 JS 文件
$ tsc app.ts util.ts --target esnext --outfile index.js
```

# ES6 类型

```js
let map2 = new Map(); // Key any, value any
let map3 = new Map<string, number>(); // Key string, value number
const myMap: Map<boolean,string> = new Map([
  [false, 'no'],
  [true, 'yes'],
]);

const p:Promise<number> = /* ... */;
async function fn(): Promise<number> {
  var i = await p;
  return i + 1;
}

interface Iterable<T> {
  [Symbol.iterator](): Iterator<T>;
}

interface Iterator<T> {
  next(value?: any): IteratorResult<T>;
  return?(value?: any): IteratorResult<T>;
  throw?(e?: any): IteratorResult<T>;
}

interface IteratorResult<T> {
  done: boolean; //表示遍历是否结束
  value: T; // 当前遍历得到的值
}

function* g():Iterable<string> {
  for (var i = 0; i < 100; i++) {
    yield '';
  }
  yield* otherStringGenerator();
}

function* g() {
  for (var i = 0; i < 100; i++) {
    yield ""; // infer string
  }
  yield* otherStringGenerator();
}

function toArray<X>(xs: Iterable<X>):X[] {
  return [...xs]
}

interface IterableIterator<T> extends Iterator<T> {
    [Symbol.iterator](): IterableIterator<T>;
}

function* createNumbers(): IterableIterator<number> {
  let n = 0;
  while (1) {
    yield n++;
  }
}
let numbers = createNumbers()
// {value: 0, done: false}
numbers.next()
// {value: 1, done: false}
numbers.next()
// {value: 2, done: false}
numbers.next()
```
