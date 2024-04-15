# 手写 promise

- 初始化和异步回调
- then catch 链式调用
- API:resolve,reject,all,race

```js
class MyPromise {
  KEY = { pending: 'pending', fullfilled: 'fullfilled', rejected: 'rejected' };
  state = 'pending'; //pending,fullfilled,rejected
  value = undefined; //成功后的值
  reason = undefined; //失败后的原因
  resolveCallbacks = []; //pending状态下存储成功的回调
  rejectCallbacks = []; //pending状态下存储失败的回调
  constructor(fn) {
    const resolveHandler = (value) => {
      if (this.state == this.KEY.pending) {
        this.state = this.KEY.fullfilled;
        this.value = value;
        this.resolveCallbacks.forEach((fn) => fn(value));
      }
    };
    const rejectHandler = (reason) => {
      if (this.state == this.KEY.pending) {
        this.state = this.KEY.rejected;
        this.reason = reason;
        this.rejectCallbacks.forEach((fn) => fn(reason));
      }
    };
    try {
      fn(resolveHandler, rejectHandler);
    } catch (error) {
      rejectHandler(error);
    }
  }
  then(fn1, fn2) {
    //当pending状态下，fn1,fn2会存储到callbacks中
    fn1 = typeof fn1 === 'function' ? fn1 : (v) => v;
    fn2 = typeof fn2 === 'function' ? fn2 : (e) => e;

    //链式调用 return MyPromise
    if (this.state == this.KEY.pending) {
      return new MyPromise((resolve, reject) => {
        this.resolveCallbacks.push(() => {
          try {
            const v = fn1(this.value);
            resolve(v);
          } catch (error) {
            reject(error);
          }
        });
        this.rejectCallbacks.push(() => {
          try {
            const v = fn2(this.reason);
            reject(v);
          } catch (error) {
            reject(error);
          }
        });
      });
    }
    if (this.state === this.KEY.fullfilled) {
      return new MyPromise((resolve, reject) => {
        try {
          const v = fn1(this.value);
          resolve(v);
        } catch (error) {
          reject(error);
        }
      });
    }

    if (this.state === this.KEY.rejected) {
      return new MyPromise((resolve, reject) => {
        try {
          const v = fn2(this.reason);
          reject(v);
        } catch (error) {
          reject(error);
        }
      });
    }
  }
  catch(fn) {
    return this.then(null, fn);
  }
}
MyPromise.resolve = function (value) {
  return new MyPromise((resolve, reject) => resolve(value));
};
MyPromise.reject = function (reason) {
  return new MyPromise((resolve, reject) => reject(reason));
};
//传入promise数组，等待全部都fullfilled，才返回
MyPromise.all = function (promises) {
  return new MyPromise((resolve, reject) => {
    const result = []; //存储所有promise的结果
    const len = promises.length;
    let resolveCount = 0;
    promises.forEach((p) => {
      p.then((data) => {
        result.push(data);
        resolveCount++;
        if (resolveCount == len) {
          //已经完成最后一个promise
          resolve(result);
        }
      }).catch((err) => {
        reject(err);
      });
    });
  });
};
//传入promise数组，只要有一个fullfilled，就立即返回
MyPromise.race = function (promises) {
  return new MyPromise((resolve, reject) => {
    let tag = false;
    promises.forEach((p) => {
      p.then((data) => {
        if (!tag) {
          resolve(data);
          tag = true;
        }
      }).catch((err) => {
        reject(err);
      });
    });
  });
};

new MyPromise((resolve, reject) => {
  console.log(0);
  resolve(1);
})
  .then((v) => {
    console.log(v);
    return v + 1;
  })
  .then((v) => {
    console.log(v);
  });
//0,1,2

MyPromise.all([
  new MyPromise.resolve(1),
  new MyPromise.resolve(2),
  new MyPromise.resolve(3),
  new MyPromise.resolve(4)
]).then((data) => {
  console.log('all', data); //1,2,3,4
});
MyPromise.race([
  new MyPromise.resolve(1),
  new MyPromise.resolve(2),
  new MyPromise.resolve(3),
  new MyPromise.resolve(4)
]).then((data) => {
  console.log('race', data); //1
});
```

# 深度拷贝 deepClone

- 浅拷贝：Object.assign()、Array.prototype.concat()、Array.prototype.slice()、扩展运算符...

jquery 的$.extend,lodash 的 cloneDeep

```js
JSON.parse(JSON.stringify()); //存在问题，Date等不会对应转换
function deepClone(obj) {
  if (typeof object !== 'object' || obj == null) {
    return obj;
  }
  let res;
  if (obj instanceof Array) {
    res = [];
  } else {
    res = {};
  }
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      res[key] = deepClone(obj[key]);
    }
  }
  return res;
}
```

# Ajax

```js
function get(url) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        resolve(xhr.responseText);
      }
    };
    xhr.onerror = (err) => {
      reject(err);
    };
    xhr.send(null);
  });
}
function post(url, data) {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;chartset=uft-8');
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        resolve(xhr.responseText);
      }
    };
    xhr.onerror = (err) => {
      reject(err);
    };

    const form = [];
    for (let k in data) {
      form.push(`${k}=${data[k]}`);
    }

    xhr.send(form.join('&'));
  });
}

function postFile(url, data) {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;chartset=uft-8');
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        resolve(xhr.responseText);
      }
    };
    xhr.onerror = (err) => {
      reject(err);
    };

    const form = new FormData();
    for (let k in data) {
      form.append(k, data[k]);
    }

    xhr.send(form);
  });
}
function getBlob(url, cb) {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'blob';
    xhr.onload = function () {
      if (xhr.status === 200) {
        resolve(xhr.response);
      }
    };
    xhr.onerror = function (err) {
      console.log(err);
      reject();
    };
    xhr.send();
  });
}

function jsonp(url) {
  return new Promise((resolve, reject) => {
    const cb = (data) => {
      resolve(data);
    };
    let fun = 'jsonp' + new Date().getTime();
    window[fun] = cb;
    const dom = document.createElement('script');
    dom.src = url + '?callback=' + fun;
    document.body.appendChild(dom);
    dom.onload = () => {
      //调用成功后，fun回调函数会自动执行，将返回data传入
      document.body.removeChild(dom);
    };
  });
}
```

# 柯里化

在一个函数中，首先填充几个参数，然后再返回一个新的函数。

通常可用于在不侵入函数的前提下，为函数预置通用参数，供多次重复调用。

**特点：**

- 参数复用
- 提前返回
- 延迟执行

```js
const add = function add(x) {
  return function (y) {
    return x + y;
  };
};

const add1 = add(1);

add1(2) === 3;
add1(20) === 21;

const curry = (fn) => {
  return (curried = (...args) => {
    if (args.length >= fn.length) {
      return fn.apply(this.args);
    } else {
      return (...innerArgs) => {
        return curry.apply(this, [...args, ...innerArgs]);
      };
    }
  });
};
```

# 节流（n 秒内只触发一次，再触发拦截返回）

高频事件触发，但在 n 秒内只会执行一次，所以节流会稀释函数的执行频率

```js
//每次触发事件时都判断当前是否有等待执行的延时函数
function throttle(fn) {
  let canRun = true; // 通过闭包保存一个标记
  return function () {
    if (!canRun) return; // 在函数开头判断标记是否为true，不为true则return
    canRun = false; // 立即设置为false
    setTimeout(() => {
      // 将外部传入的函数的执行放在setTimeout中
      fn.apply(this, arguments);
      // 最后在setTimeout执行完毕后再把标记设置为true(关键)表示可以执行下一次循环了。当定时器没有执行的时候标记永远是false，在开头被return掉
      canRun = true;
    }, 500);
  };
}
```

# 防抖（n 秒内只触发一次，再触发重新计算）

触发高频事件后 n 秒内函数只会执行一次，如果 n 秒内高频事件再次被触发，则重新计算时间

```js
//每次触发事件时都取消之前的延时调用方法
function debounce(fn) {
  let timeout = null; // 创建一个标记用来存放定时器的返回值
  return function () {
    clearTimeout(timeout); // 每当用户输入的时候把前一个 setTimeout clear 掉
    timeout = setTimeout(() => {
      // 然后又创建一个新的 setTimeout, 这样就能保证输入字符后的 interval 间隔内如果还有字符输入的话，就不会执行 fn 函数
      fn.apply(this, arguments);
    }, 500);
  };
}
```

# 二分查找法

```js
function binarySearch(arr, target) {
  let left = 0,
    right = arr.length - 1; //在[left,right]之间查找

  while (left <= right) {
    //left==right时仍有效
    let mid = left + (right - left) / 2;
    if (arr[mid] == target) {
      return mid;
    }
    //mid不是target
    if (target > arr[mid]) {
      //target在[mid+1,right]之间
      left = mid + 1;
    } else {
      //target在[left,mid-1]之间
      right = mid - 1;
    }
  }
  return -1;
}
```

# 快速排序

```js
function quick_sort(s, l, r) {
  if (l < r) {
    //Swap(s[l], s[(l + r) / 2]); //将中间的这个数和第一个数交换 参见注1
    let i = l,
      j = r,
      x = s[l];
    while (i < j) {
      while (i < j && s[j] >= x)
        // 从右向左找第一个小于x的数
        j--;
      if (i < j) s[i++] = s[j];

      while (i < j && s[i] < x)
        // 从左向右找第一个大于等于x的数
        i++;
      if (i < j) s[j--] = s[i];
    }
    s[i] = x;
    quick_sort(s, l, i - 1); // 递归调用
    quick_sort(s, i + 1, r);
  }
}
```

# Tree

## list2tree

```js
function list2tree(list, id = 'id', parentId = 'parentId', children = 'children') {
  let map = {};
  let root = [];
  list.forEach((item) => {
    if (item[parentId]) {
      if (Array.isArray(map[item[parentId]])) {
        map[item[parentId]].push(item);
      } else {
        map[item[parentId]] = [item];
      }
    } else {
      root.push(item);
    }
  });
  function toTree(root, map) {
    for (let k in map) {
      for (let i = 0; i < root.length; i++) {
        if (root[i][id] == k) {
          root[i][children] = map[k];
          delete map[k];
          toTree(root[i][children], map);
        }
      }
    }
  }
  toTree(root, map);
  return root;
}
```

## tree2list

```js
function tree2list(root, id = 'id', parentId = 'parentId', children = 'children') {
  function getChildren(tree, parent) {
    let list = [{ ...tree, [parentId]: parent, [children]: [] }];
    if (Array.isArray(tree[children]) && tree[children].length > 0) {
      tree[children].forEach((item) => {
        list = list.concat(getChildren(item, tree[id]));
      });
    }
    return list;
  }
  if (Array.isArray(root)) {
    let result = [];
    root.forEach((item) => {
      result = result.concat(getChildren(item, ''));
    });
    return result;
  } else {
    return getChildren(root, '');
  }
}
```

# 实现 Event emitter 类

```js
export class EventEmitter {
  constructor() {
    this.eventMap = new Map();
  }
  on(event, fn) {
    if (typeof fn === 'function') {
      const fns = this.eventMap.get(event);
      if (fns) {
        if (!fns.has(fn)) {
          fns.set(fn, 1);
        }
      } else {
        //采用map可以更加快速增删改查
        const fns = new Map();
        fns.set(fn, 1);
        this.eventMap.set(event, fns.set(fn, 1));
      }
    }
  }
  off(event, fn) {
    if (typeof fn === 'function') {
      const fns = this.eventMap.get(event);
      if (fns.has(fn)) {
        fns.delete(fn);
      }
    }
  }
  emit(event, data) {
    const fns = this.eventMap.get(event);
    if (fns) {
      fns.forEach((i, fn) => {
        fn(data);
      });
    }
  }
  once(event, fn) {
    //包裹一层function，一旦触发就销毁
    const fun = (data) => {
      fn(data);
      this.off(event, fun);
    };
    this.on(event, fun);
  }
}
```

# compose 函数

```js
//div2(mul3(add1(add1(0))));=>compose(div2, mul3, add1, add1)(0)
function compose(...fn) {
  if (!fn.length) return (v) => v;
  if (fn.length === 1) return fn[0];
  return fn.reduce(
    (pre, cur) =>
      (...args) =>
        pre(cur(...args))
  );
}
```
