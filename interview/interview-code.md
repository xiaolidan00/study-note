## 手写 promise

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

## 深度拷贝 deepClone

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

# 排序算法

## 冒泡排序

```js
function bubbleSort(arr) {
  var len = arr.length;
  for (var i = 0; i < len - 1; i++) {
    for (var j = 0; j < len - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        // 相邻元素两两对比
        var temp = arr[j + 1]; // 元素交换
        arr[j + 1] = arr[j];
        arr[j] = temp;
      }
    }
  }
  return arr;
}
```

## 选择排序

```js
function selectionSort(arr) {
  var len = arr.length;
  var minIndex, temp;
  for (var i = 0; i < len - 1; i++) {
    minIndex = i;
    for (var j = i + 1; j < len; j++) {
      if (arr[j] < arr[minIndex]) {
        // 寻找最小的数
        minIndex = j; // 将最小数的索引保存
      }
    }
    temp = arr[i];
    arr[i] = arr[minIndex];
    arr[minIndex] = temp;
  }
  return arr;
}
```

## 插入排序

```js
function insertionSort(arr) {
  var len = arr.length;
  var preIndex, current;
  for (var i = 1; i < len; i++) {
    preIndex = i - 1;
    current = arr[i];
    while (preIndex >= 0 && arr[preIndex] > current) {
      arr[preIndex + 1] = arr[preIndex];
      preIndex--;
    }
    arr[preIndex + 1] = current;
  }
  return arr;
}
```

## 希尔排序

```js
function shellSort(arr) {
  let length = arr.length;
  let temp;
  for (let step = Math.floor(length / 2); step >= 1; step = Math.floor(step / 2)) {
    for (let i = step; i < length; i++) {
      temp = arr[i];
      let j = i - step;
      while (j >= 0 && arr[j] > temp) {
        arr[j + step] = arr[j];
        j -= step;
      }
      arr[j + step] = temp;
    }
  }
  return arr;
}
```

## 归并排序

```js
function mergeSort(arr) {
  // 采用自上而下的递归方法
  var len = arr.length;
  if (len < 2) {
    return arr;
  }
  var middle = Math.floor(len / 2),
    left = arr.slice(0, middle),
    right = arr.slice(middle);
  return merge(mergeSort(left), mergeSort(right));
}

function merge(left, right) {
  var result = [];

  while (left.length && right.length) {
    if (left[0] <= right[0]) {
      result.push(left.shift());
    } else {
      result.push(right.shift());
    }
  }

  while (left.length) result.push(left.shift());

  while (right.length) result.push(right.shift());

  return result;
}
```

## 快速排序

```js
function quickSort(arr, left, right) {
  var len = arr.length,
    partitionIndex,
    left = typeof left != 'number' ? 0 : left,
    right = typeof right != 'number' ? len - 1 : right;

  if (left < right) {
    partitionIndex = partition(arr, left, right);
    quickSort(arr, left, partitionIndex - 1);
    quickSort(arr, partitionIndex + 1, right);
  }
  return arr;
}

function partition(arr, left, right) {
  // 分区操作
  var pivot = left, // 设定基准值（pivot）
    index = pivot + 1;
  for (var i = index; i <= right; i++) {
    if (arr[i] < arr[pivot]) {
      swap(arr, i, index);
      index++;
    }
  }
  swap(arr, pivot, index - 1);
  return index - 1;
}

function swap(arr, i, j) {
  var temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}
function partition2(arr, low, high) {
  let pivot = arr[low];
  while (low < high) {
    while (low < high && arr[high] > pivot) {
      --high;
    }
    arr[low] = arr[high];
    while (low < high && arr[low] <= pivot) {
      ++low;
    }
    arr[high] = arr[low];
  }
  arr[low] = pivot;
  return low;
}

function quickSort2(arr, low, high) {
  if (low < high) {
    let pivot = partition2(arr, low, high);
    quickSort2(arr, low, pivot - 1);
    quickSort2(arr, pivot + 1, high);
  }
  return arr;
}
```

## 堆排序

```js
var len; // 因为声明的多个函数都需要数据长度，所以把len设置成为全局变量

function buildMaxHeap(arr) {
  // 建立大顶堆
  len = arr.length;
  for (var i = Math.floor(len / 2); i >= 0; i--) {
    heapify(arr, i);
  }
}

function heapify(arr, i) {
  // 堆调整
  var left = 2 * i + 1,
    right = 2 * i + 2,
    largest = i;

  if (left < len && arr[left] > arr[largest]) {
    largest = left;
  }

  if (right < len && arr[right] > arr[largest]) {
    largest = right;
  }

  if (largest != i) {
    swap(arr, i, largest);
    heapify(arr, largest);
  }
}

function swap(arr, i, j) {
  var temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

function heapSort(arr) {
  buildMaxHeap(arr);

  for (var i = arr.length - 1; i > 0; i--) {
    swap(arr, 0, i);
    len--;
    heapify(arr, 0);
  }
  return arr;
}
```

## 计数排序

```js
function countingSort(arr, maxValue) {
  var bucket = new Array(maxValue + 1),
    sortedIndex = 0;
  (arrLen = arr.length), (bucketLen = maxValue + 1);

  for (var i = 0; i < arrLen; i++) {
    if (!bucket[arr[i]]) {
      bucket[arr[i]] = 0;
    }
    bucket[arr[i]]++;
  }

  for (var j = 0; j < bucketLen; j++) {
    while (bucket[j] > 0) {
      arr[sortedIndex++] = j;
      bucket[j]--;
    }
  }

  return arr;
}
```

## 桶排序

```js
function bucketSort(arr, bucketSize) {
  if (arr.length === 0) {
    return arr;
  }

  var i;
  var minValue = arr[0];
  var maxValue = arr[0];
  for (i = 1; i < arr.length; i++) {
    if (arr[i] < minValue) {
      minValue = arr[i]; // 输入数据的最小值
    } else if (arr[i] > maxValue) {
      maxValue = arr[i]; // 输入数据的最大值
    }
  }

  //桶的初始化
  var DEFAULT_BUCKET_SIZE = 5; // 设置桶的默认数量为5
  bucketSize = bucketSize || DEFAULT_BUCKET_SIZE;
  var bucketCount = Math.floor((maxValue - minValue) / bucketSize) + 1;
  var buckets = new Array(bucketCount);
  for (i = 0; i < buckets.length; i++) {
    buckets[i] = [];
  }

  //利用映射函数将数据分配到各个桶中
  for (i = 0; i < arr.length; i++) {
    buckets[Math.floor((arr[i] - minValue) / bucketSize)].push(arr[i]);
  }

  arr.length = 0;
  for (i = 0; i < buckets.length; i++) {
    insertionSort(buckets[i]); // 对每个桶进行排序，这里使用了插入排序
    for (var j = 0; j < buckets[i].length; j++) {
      arr.push(buckets[i][j]);
    }
  }

  return arr;
}
```

## 基数排序

```js
//LSD Radix Sort
var counter = [];
function radixSort(arr, maxDigit) {
  var mod = 10;
  var dev = 1;
  for (var i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
    for (var j = 0; j < arr.length; j++) {
      var bucket = parseInt((arr[j] % mod) / dev);
      if (counter[bucket] == null) {
        counter[bucket] = [];
      }
      counter[bucket].push(arr[j]);
    }
    var pos = 0;
    for (var j = 0; j < counter.length; j++) {
      var value = null;
      if (counter[j] != null) {
        while ((value = counter[j].shift()) != null) {
          arr[pos++] = value;
        }
      }
    }
  }
  return arr;
}
```

# 发布订阅者模式

# 观察者模式

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
class EventEmitter {
  constructor() {
    this._events = {};
  }
  getEvenCall(event) {
    return this._events[event] || [];
  }
  on(event, callback) {
    let callbacks = this.getEvenCall(event);
    callbacks.push(callback);
    this._events[event] = callbacks;
    return this;
  }
  off(event, callback) {
    if (callback) {
      let callbacks = this.getEvenCall(event);
      this._events[event] = callbacks.filter((fn) => fn !== callback);
    } else {
      this._events[event] = [];
    }
    return this;
  }
  emit(...args) {
    const event = args[0];
    const params = args.slice(1);
    const callbacks = this._events[event] || [];
    callbacks.forEach((fn) => {
      fn.apply(this, params);
    });
    return this;
  }
  once(event, callback) {
    let wrapFanc = (...args) => {
      callback.apply(this, args);
      this.off(event, wrapFanc);
    };
    this.on(event, wrapFanc);
    return this;
  }
}
```
