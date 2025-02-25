https://cn.vuejs.org/api/general.html#nexttick

```js
flushPostFlushCbs (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:394)
flushJobs (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:432)
Promise.then (Unknown Source:0)
queueFlush (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:325)
queueJob (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:319)
effect2.scheduler (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5394)
trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:250)
endBatch (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:300)
notify (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:587)
trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:561)
set value (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:1504)
click (d:\code\my-vue3-ts\src\NextTick.vue:9)
callWithErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:199)
callWithAsyncErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:206)
invoker (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-dom@3.5.10\node_modules\@vue\runtime-dom\dist\runtime-dom.esm-bundler.js:722)
```

ref 响应式变量修改后
queueJob>queueFlush>queueJob>queueJob

```js
queueJob (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:309)
effect2.scheduler (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5394)
ReactiveEffect.trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:250)
endBatch (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:300)
Dep.notify (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:587)
Dep.trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:561)
RefImpl.set value (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:1504)
click (d:\code\my-vue3-ts\src\NextTick.vue:9)
callWithErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:199)
callWithAsyncErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:206)
invoker (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-dom@3.5.10\node_modules\@vue\runtime-dom\dist\runtime-dom.esm-bundler.js:722)
```

# nextTick

queueJob>queueFlush>flushJobs>checkRecursiveUpdates>flushPostFlushCbs

```js
let isFlushing = false;
let isFlushPending = false;
const queue = [];
let flushIndex = 0;
const pendingPostFlushCbs = [];
let activePostFlushCbs = null;
let postFlushIndex = 0;
const resolvedPromise = /* @__PURE__ */ Promise.resolve();
let currentFlushPromise = null;
const RECURSION_LIMIT = 100;
function nextTick(fn) {
  const p = currentFlushPromise || resolvedPromise;
  return fn ? p.then(this ? fn.bind(this) : fn) : p;
}
function findInsertionIndex(id) {
  let start = isFlushing ? flushIndex + 1 : 0;
  let end = queue.length;
  while (start < end) {
    const middle = (start + end) >>> 1;
    const middleJob = queue[middle];
    const middleJobId = getId(middleJob);
    if (middleJobId < id || (middleJobId === id && middleJob.flags & 2)) {
      start = middle + 1;
    } else {
      end = middle;
    }
  }
  return start;
}
```

# queueJob

```js
function queueJob(job) {
  if (!(job.flags & 1)) {
    const jobId = getId(job);
    const lastJob = queue[queue.length - 1];
    if (
      !lastJob || // fast path when the job id is larger than the tail
      (!(job.flags & 2) && jobId >= getId(lastJob))
    ) {
      queue.push(job);
    } else {
      queue.splice(findInsertionIndex(jobId), 0, job);
    }
    job.flags |= 1;
    queueFlush();
  }
}
```

# queueFlush

```js
function queueFlush() {
  if (!isFlushing && !isFlushPending) {
    isFlushPending = true;
    currentFlushPromise = resolvedPromise.then(flushJobs);
  }
}
```

# queuePostFlushCb

```js
function queuePostFlushCb(cb) {
  if (!isArray(cb)) {
    if (activePostFlushCbs && cb.id === -1) {
      activePostFlushCbs.splice(postFlushIndex + 1, 0, cb);
    } else if (!(cb.flags & 1)) {
      pendingPostFlushCbs.push(cb);
      cb.flags |= 1;
    }
  } else {
    pendingPostFlushCbs.push(...cb);
  }
  queueFlush();
}
```

# flushPreFlushCbs

```js
function flushPreFlushCbs(instance, seen, i = isFlushing ? flushIndex + 1 : 0) {
  {
    seen = seen || /* @__PURE__ */ new Map();
  }
  for (; i < queue.length; i++) {
    const cb = queue[i];
    if (cb && cb.flags & 2) {
      if (instance && cb.id !== instance.uid) {
        continue;
      }
      if (checkRecursiveUpdates(seen, cb)) {
        continue;
      }
      queue.splice(i, 1);
      i--;
      if (cb.flags & 4) {
        cb.flags &= ~1;
      }
      cb();
      if (!(cb.flags & 4)) {
        cb.flags &= ~1;
      }
    }
  }
}
```

# flushPostFlushCbs

```js
function flushPostFlushCbs(seen) {
  if (pendingPostFlushCbs.length) {
    const deduped = [...new Set(pendingPostFlushCbs)].sort((a, b) => getId(a) - getId(b));
    pendingPostFlushCbs.length = 0;
    if (activePostFlushCbs) {
      activePostFlushCbs.push(...deduped);
      return;
    }
    activePostFlushCbs = deduped;
    {
      seen = seen || /* @__PURE__ */ new Map();
    }
    for (postFlushIndex = 0; postFlushIndex < activePostFlushCbs.length; postFlushIndex++) {
      const cb = activePostFlushCbs[postFlushIndex];
      if (checkRecursiveUpdates(seen, cb)) {
        continue;
      }
      if (cb.flags & 4) {
        cb.flags &= ~1;
      }
      if (!(cb.flags & 8)) cb();
      cb.flags &= ~1;
    }
    activePostFlushCbs = null;
    postFlushIndex = 0;
  }
}
const getId = (job) => (job.id == null ? (job.flags & 2 ? -1 : Infinity) : job.id);
```

# flushJobs

```js
function flushJobs(seen) {
  isFlushPending = false;
  isFlushing = true;
  {
    seen = seen || /* @__PURE__ */ new Map();
  }
  const check = (job) => checkRecursiveUpdates(seen, job);
  try {
    for (flushIndex = 0; flushIndex < queue.length; flushIndex++) {
      const job = queue[flushIndex];
      if (job && !(job.flags & 8)) {
        if (check(job)) {
          continue;
        }
        if (job.flags & 4) {
          job.flags &= ~1;
        }
        callWithErrorHandling(job, job.i, job.i ? 15 : 14);
        if (!(job.flags & 4)) {
          job.flags &= ~1;
        }
      }
    }
  } finally {
    for (; flushIndex < queue.length; flushIndex++) {
      const job = queue[flushIndex];
      if (job) {
        job.flags &= ~1;
      }
    }
    flushIndex = 0;
    queue.length = 0;
    flushPostFlushCbs(seen);
    isFlushing = false;
    currentFlushPromise = null;
    if (queue.length || pendingPostFlushCbs.length) {
      flushJobs(seen);
    }
  }
}
```

# checkRecursiveUpdates

```js
function checkRecursiveUpdates(seen, fn) {
  const count = seen.get(fn) || 0;
  if (count > RECURSION_LIMIT) {
    const instance = fn.i;
    const componentName = instance && getComponentName(instance.type);
    handleError(
      `Maximum recursive updates exceeded${
        componentName ? ` in component <${componentName}>` : ``
      }. This means you have a reactive effect that is mutating its own dependencies and thus recursively triggering itself. Possible sources include component template, render function, updated hook or watcher source function.`,
      null,
      10
    );
    return true;
  }
  seen.set(fn, count + 1);
  return false;
}
```

# job

```js
setupRenderEffect;
baseCreateRenderer;
```

job.flags=4

job.flags=5 跳过添加 queue

```js
const mountComponent = (
  initialVNode,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  namespace,
  optimized
) => {};
function setupComponent(instance, isSSR = false, optimized = false) {}
function setupStatefulComponent(instance, isSSR) {
  const setupResult = callWithErrorHandling(setup, instance, 0, [
    true ? shallowReadonly(instance.props) : instance.props,
    setupContext
  ]);
  handleSetupResult(instance, setupResult, isSSR);
}
callWithErrorHandling(fn, instance, type, args);
callWithErrorHandling(fn, instance, type, args);
flushJobs(seen);

function createInvoker(initialValue, instance) {
  const invoker = (e) => {
    if (!e._vts) {
      e._vts = Date.now();
    } else if (e._vts <= invoker.attached) {
      return;
    }
    callWithAsyncErrorHandling(patchStopImmediatePropagation(e, invoker.value), instance, 5, [e]);
  };
  invoker.value = initialValue;
  invoker.attached = getNow();
  return invoker;
}
```

createInvoker>flushJobs

# patchEvent

```js
patchEvent (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:11148)
patchProp (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:11235)
mountElement (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6958)
processElement (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6905)
patch (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6773)
componentUpdateFn (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7413)
ReactiveEffect.run (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:479)
setupRenderEffect (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7541)
mountComponent (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7316)
processComponent (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7269)
patch (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6785)
mountChildren (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7017)
processFragment (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7199)
patch (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6759)
componentUpdateFn (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7413)
ReactiveEffect.run (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:479)
setupRenderEffect (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7541)
mountComponent (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7316)
processComponent (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:7269)
patch (d:\code\my-vue3-ts\node_modules\.vite\deps\vue.js:6785)
```

使用 promise 链式调用
eventLoop，执行栈为空，promise.then 开始调用异步任务，渲染真实 DOM， nextTick

```js
hostPatchProp(el, key, null, props[key], namespace, parentComponent);

if (isOn(key)) {
  if (!isModelListener(key)) {
    patchEvent(el, key, prevValue, nextValue, parentComponent);
  }
}
```

```
 notify(): void {
    if (
      this.flags & EffectFlags.RUNNING &&
      !(this.flags & EffectFlags.ALLOW_RECURSE)
    ) {
      return
    }
    if (!(this.flags & EffectFlags.NOTIFIED)) {
      batch(this)
    }
  }
```
