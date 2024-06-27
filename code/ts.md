```ts
const types=['AA','BB']
type Props=(typeof types)[number];// 'AA'|'BB'


type FunctionParams<T>=T extends (...args:infer P)=>any?P:never;
function fn(a:number){

}
type fnProps=FunctionParams<typeof fn> // [number]
```
