# 代码阅读 1

```js
async function async1() {
  console.log('async1 start');

  await async2();

  console.log('async1 end');
}

async function async2() {
  console.log('async2');
}

console.log('script start');

setTimeout(function () {
  console.log('settimeout');
});

async1();

new Promise(function (resolve) {
  console.log('promise1');

  resolve();
}).then(function () {
  console.log('promise2');
});

console.log('script end');
```

题目的本质，就是考察 setTimeout、promise、async await 的实现及执行顺序，以及 JS 的事件循环的相关问题。

答案：

```js
script start
async1 start
async2
promise1
script end
async1 end
promise2
settimeout
```

# 代码阅读 2

```js
// timer -> pending -> idle -> prepare -> poll io -> check -> close

// timer phase
setTimeout(() => {
  Promise.resolve().then(() => {
    console.log('promise resolve in timeout');
    process.nextTick(() => {
      console.log('tick task in timeout promise');
    });
  });
  process.nextTick(() => {
    console.log('tick task in timeout');
    process.nextTick(() => {
      console.log('tick task in timeout->tick');
    });
  });
  console.log('timer task');
}, 0);

// check phase
setImmediate(() => {
  process.nextTick(() => {
    console.log('imeediate->tick task');
  });
  console.log('immediate task');
});

Promise.resolve().then(() => {
  console.log('promise resolve');
});

process.nextTick(() => {
  console.log('tick task');
});

console.log('run main thread');
```

```js
// result
run main thread
tick task
promise resolve
timer task
tick task in timeout
tick task in timeout->tick
promise resolve in timeout
tick task in timeout promise
immediate task
imeediate->tick task
```
