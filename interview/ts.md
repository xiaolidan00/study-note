# typescript

<https://typescript.p6p.net/typescript-tutorial/interface.html>

## interface 与 type 的区别

1. type 能够表示非对象类型，而 interface 只能表示对象类型（包括数组、函数等）。
2. interface 可以继承其他类型，type 不支持继承。
3. 同名 interface 会自动合并，同名 type 则会报错。也就是说，TypeScript 不允许使用 type 多次定义同一个类型。
4. interface 不能包含属性映射（mapping），type 可以
5. type 可以扩展原始数据类型，interface 不行。
6. interface 无法表达某些复杂类型（比如交叉类型和联合类型），但是 type 可以。

相同点：

1. 都可以描述 '对象' 或者 '函数'
2. 都允许拓展(extends)

不同点：

1. type 可以声明基本类型，联合类型，元组
2. type 可以使用 typeof 获取实例的类型进行赋值
3. 多个相同的 interface 声明可以自动合并
   使用 interface 描述‘数据结构’，使用 type 描述‘类型关系’

## any,unknow,never 的区别

- unknown 跟 any 的相似之处，在于所有类型的值都可以分配给 unknown 类型。
- unknown 类型跟 any 类型的不同之处在于，它不能直接使用。
- unknown 类型的变量，不能直接赋值给其他类型的变量（除了 any 类型和 unknown 类型）。
- 不能直接调用 unknown 类型变量的方法和属性。
- unknown 类型变量能够进行的运算是有限的，只能进行比较运算（运算符==、===、!=、!==、||、&&、?）、取反运算（运算符!）、typeof 运算符和 instanceof 运算符这几种，其他运算都会报错。
- 只有经过“类型缩小”，unknown 类型变量才可以使用。所谓“类型缩小”，就是缩小 unknown 变量的类型范围，确保不会出错。
- never 空类型，抛出 error

## TypeScript 中 `?.、??、!、!.、_、**` 等符号的含义？

- `?. 可选链` 遇到 null 和 undefined 可以立即停止表达式的运行。
- `?? 空值合并运算符` 当左侧操作数为 null 或 undefined 时，其返回右侧的操作数，否则返回左侧的操作数。
- `! 非空断言运算符` x! 将从 x 值域中排除 null 和 undefined
- `!.`在变量名后添加，可以断言排除 undefined 和 null 类型
- `_ 数字分割符` 分隔符不会改变数值字面量的值，使人更容易读懂数字 .e.g 1_101_324。
- `**`求幂

## TypeScript 中 const 和 readonly 的区别？枚举和常量枚举的区别？接口和类型别名的区别？

- `const 和 readonly`: const 可以防止变量的值被修改，readonly 可以防止变量的属性被修改。
- `枚举和常量枚举`: 常量枚举只能使用常量枚举表达式，并且不同于常规的枚举，它们在编译阶段会被删除。 常量枚举成员在使用的地方会被内联进来。 之所以可以这么做是因为，常量枚举不允许包含计算成员。
- `接口和类型别名`: 两者都可以用来描述对象或函数的类型。与接口不同，类型别名还可以用于其他类型，如基本类型（原始值）、联合类型、元组。

## TypeScript 中 any、never、unknown、null & undefined 和 void 有什么区别？

- `any`: 动态的变量类型（失去了类型检查的作用）。
- `never`: 永不存在的值的类型。例如：never 类型是那些总是会抛出异常或根本就不会有返回值的函数表达式或箭头函数表达式的返回值类型。
- `unknown`: 任何类型的值都可以赋给  unknown  类型，但是  unknown  类型的值只能赋给  unknown  本身和  any  类型。
- `null & undefined`: 默认情况下 null 和 undefined 是所有类型的子类型。 就是说你可以把  null 和 undefined 赋值给 number 类型的变量。当你指定了 --strictNullChecks 标记，null 和 undefined 只能赋值给 void 和它们各自。
- `void`: 没有任何类型。例如：一个函数如果没有返回值，那么返回值可以定义为 void。

## TypeScript 中的 this 和 JavaScript 中的 this 有什么差异？

- TypeScript：noImplicitThis: true 的情况下，必须去声明 this 的类型，才能在函数或者对象中使用 this。
- Typescript 中箭头函数的 this 和 ES6 中箭头函数中的 this 是一致的。

## TypeScript 中 interface 可以给 Function / Array / Class（Indexable）做声明吗？

```ts
// 函数声明
interface Say {
  (name: string): viod;
}
let say: Say = (name: string): viod => {};
// Array 声明
interface NumberArray {
  [index: number]: number;
}
let fibonacci: NumberArray = [1, 1, 2, 3, 5];
// Class 声明
interface PersonalIntl {
  name: string;
  sayHi(name: string): string;
}
```

## TypeScript 如何设计 Class 的声明？

```ts
class Greeter {
  greeting: string;
  constructor(message: string) {
    this.greeting = message;
  }
  greet(): string {
    return 'Hello, ' + this.greeting;
  }
}
let greeter = new Greeter('world');
```

同名的 interface 会自动合并，同名的 interface 和 class 会自动聚合。

## TypeScript 中如何联合枚举类型的 Key?

```ts
enum str {
  A,
  B,
  C
}
type strUnion = keyof typeof str; // 'A' | 'B' | 'C'
```

keyof 索引类型查询操作符 获取索引类型的属性名，构成联合类型。
typeof 获取一个变量或对象的类型。

## declare，declare global 是什么？

- declare 是用来定义全局变量、全局函数、全局命名空间、js modules、class 等
- declare global 为全局对象 window 增加新的属性

```ts
declare global {
  interface Window {
    csrf: string;
  }
}
```

## 对 TypeScript 类中成员的 public、private、protected、readonly 修饰符的理解？

- public: 成员都默认为 public，被此限定符修饰的成员是可以被外部访问；
- private: 被此限定符修饰的成员是只可以被类的内部访问；
- protected: 被此限定符修饰的成员是只可以被类的内部以及类的子类访问;
- readonly: 关键字将属性设置为只读的。 只读属性必须在声明时或构造函数里被初始化。

## 类型工具

[Typescript类型工具](#/code/typescriptUtil.md)
