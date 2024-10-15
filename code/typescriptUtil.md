<https://www.typescriptlang.org/docs/handbook/utility-types.html>

# `Awaited<Type>`

```ts
type A = Awaited<Promise<string>>;
    
//type A = string
 
type B = Awaited<Promise<Promise<number>>>;
    
//type B = number
 
type C = Awaited<boolean | Promise<number>>;
    
//type C = number | boolean
```

# `Partial<Type>`

```ts
type A={
    a:string;
    b:number;
    c:boolean;
}
type B=Partial<A>;

// type B={
//     a?:string;
//     b?:number;
//     c?:boolean;
// }

```

# `Required<Type>`

```ts
type A={
    a?:string;
    b?:number;
    c?:boolean;
}
type B=Required<A>;
// type B={
//     a:string;
//     b:number;
//     c:boolean;
// }
```

# `Readonly<Type>`

```ts
type A={
    a:string;
    b?:number;
    c:boolean;
}
type B=Readonly<A>;

// type A={
//   readonly a:string;
//   readonly b?:number;
//   readonly c:boolean;
// }
```

# `Record<Keys, Type>`

```ts
type A={
    a:string;
    b:number;
    c:boolean;
}
type B='AAA'|'BBB'|'CCC'
type C=Record<B,A>;


// type C={
//     AAA:{
//     a:string;
//     b:number;
//     c:boolean;
// },
// BBB:{
//     a:string;
//     b:number;
//     c:boolean;
// },
// CCC:{
//     a:string;
//     b:number;
//     c:boolean;
// }
// }
```

# `Pick<Type, Keys>`

```ts
type A={
    a:string;
    b:number;
    c:boolean;
}
type B='a'|'b'
type C=Pick<A,B>;

// type C={
//      a:string;
//     b:number;
// }
```

# `Omit<Type, Keys>`

```ts
type A={
    a:string;
    b:number;
    c:boolean;
}
type B='a'|'b'
type C=Omit<A,B>;

// type C={
//      c:boolean; 
// }
```

# `Exclude<UnionType, ExcludedMembers>`

```ts
 
type A=Exclude<1|2|3,1>;
// type A=2|3;


type B = Exclude<string | number | (() => void), Function>;
     
//type B = string | number

type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "square"; x: number }
  | { kind: "triangle"; x: number; y: number };

type C = Exclude<Shape, { kind: "circle" }>
//type C ={ kind: "square"; x: number }  |{ kind: "triangle"; x: number; y: number };
```

# `Extract<Type, Union>`

```ts
type T0 = Extract<"a" | "b" | "c", "a" | "f">;
     
// type T0 = "a"

type T1 = Extract<string | number | (() => void), Function>;
     
// type T1 = () => void
 
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "square"; x: number }
  | { kind: "triangle"; x: number; y: number };
 
type T2 = Extract<Shape, { kind: "circle" }>
     
// type T2 = {
//     kind: "circle";
//     radius: number;
// }
```

# `NonNullable<Type>`

```ts
type T0 = NonNullable<string | number | undefined>;
     
//type T0 = string | number

type T1 = NonNullable<string[] | null | undefined>;
     
//type T1 = string[]
```

# `Parameters<Type>`

```ts
declare function f1(arg: { a: number; b: string }): void;
 
type T0 = Parameters<() => string>;
     
//type T0 = []

type T1 = Parameters<(s: string) => void>;
     
//type T1 = [s: string]

type T2 = Parameters<<T>(arg: T) => T>;
     
//type T2 = [arg: unknown]

type T3 = Parameters<typeof f1>;
     
// type T3 = [arg: {
//     a: number;
//     b: string;
// }]

type T4 = Parameters<any>;
     
//type T4 = unknown[]

type T5 = Parameters<never>;
     
//type T5 = never
```

# `ConstructorParameters<Type>`

```ts
type T0 = ConstructorParameters<ErrorConstructor>;
     
//type T0 = [message?: string]

type T1 = ConstructorParameters<FunctionConstructor>;
     
//type T1 = string[]

type T2 = ConstructorParameters<RegExpConstructor>;
     
//type T2 = [pattern: string | RegExp, flags?: string]

class C {
  constructor(a: number, b: string) {}
}
type T3 = ConstructorParameters<typeof C>;
     
//type T3 = [a: number, b: string]

type T4 = ConstructorParameters<any>;
     
//type T4 = unknown[]
```

# `ReturnType<Type>`

```ts
declare function f1(): { a: number; b: string };
 
type T0 = ReturnType<() => string>;
     
//type T0 = string

type T1 = ReturnType<(s: string) => void>;
     
//type T1 = void

type T2 = ReturnType<<T>() => T>;
     
//type T2 = unknown

type T3 = ReturnType<<T extends U, U extends number[]>() => T>;
     
//type T3 = number[]

type T4 = ReturnType<typeof f1>;
     
// type T4 = {
//     a: number;
//     b: string;
// }

type T5 = ReturnType<any>;
     
//type T5 = any

type T6 = ReturnType<never>;
     
//type T6 = never
```

# `InstanceType<Type>`

```ts
class C {
  x = 0;
  y = 0;
}
 
type T0 = InstanceType<typeof C>;
     
//type T0 = C

type T1 = InstanceType<any>;
     
//type T1 = any

type T2 = InstanceType<never>;
     
//type T2 = never
```

# `NoInfer<Type>`

```ts
function createStreetLight<C extends string>(
  colors: C[],
  defaultColor?: NoInfer<C>,
) {
  // ...
}
createStreetLight(["red", "yellow", "green"], "red");  // OK
createStreetLight(["red", "yellow", "green"], "blue");  // Error
```

# `ThisParameterType<Type>`

```ts
function toHex(this: Number) {
  return this.toString(16);
}
 
function numberToString(n: ThisParameterType<typeof toHex>) {
  return toHex.apply(n);
}
```

# `OmitThisParameter<Type>`

```ts
function toHex(this: Number) {
  return this.toString(16);
}
 
const fiveToHex: OmitThisParameter<typeof toHex> = toHex.bind(5);
 
console.log(fiveToHex());
```

# `ThisType<Type>`

```ts
type ObjectDescriptor<D, M> = {
  data?: D;
  methods?: M & ThisType<D & M>; // Type of 'this' in methods is D & M
};
 
function makeObject<D, M>(desc: ObjectDescriptor<D, M>): D & M {
  let data: object = desc.data || {};
  let methods: object = desc.methods || {};
  return { ...data, ...methods } as D & M;
}
 
let obj = makeObject({
  data: { x: 0, y: 0 },
  methods: {
    moveBy(dx: number, dy: number) {
      this.x += dx; // Strongly typed this
      this.y += dy; // Strongly typed this
    },
  },
});
 
obj.x = 10;
obj.y = 20;
obj.moveBy(5, 5);
```
