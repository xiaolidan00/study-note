```js
const _sfc_main = /* @__PURE__ */ _defineComponent({
  __name: 'RefTemplate',
  setup(__props, { expose: __expose }) {
    __expose();
    const hello = ref('Hello World!');
    const msg = ref(1);
    const __returned__ = { hello, msg };
    Object.defineProperty(__returned__, '__isScriptSetup', { enumerable: false, value: true });
    return __returned__;
  }
});
```

```js
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return (
    _openBlock(),
    _createElementBlock(
      'h1',
      { title: $setup.hello },
      'Hello ' + _toDisplayString($setup.msg) + '!',
      9,
      _hoisted_1
    )
  );
}
```

```js
Proxy(Object)._sfc_render (d:\code\my-vue3-ts\src\RefTemplate.vue:2)
renderComponentRoot (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:6443)
componentUpdateFn (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5265)
ReactiveEffect.run (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:222)
setupRenderEffect (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5400)
mountComponent (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5175)
processComponent (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5128)
patch (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:4646)
render2 (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5925)
mount (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:3888)
app.mount (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-dom@3.5.10\node_modules\@vue\runtime-dom\dist\runtime-dom.esm-bundler.js:1756)
<anonymous> (d:\code\my-vue3-ts\src\main.ts:6)
```

```js
var isRef = (val) => {
  return !!(val && val['__v_isRef'] === true);
};
var toDisplayString = (val) => {
  return isString(val)
    ? val
    : val == null
    ? ''
    : isArray(val) ||
      (isObject(val) && (val.toString === objectToString || !isFunction(val.toString)))
    ? isRef(val)
      ? toDisplayString(val.value)
      : JSON.stringify(val, replacer, 2)
    : String(val);
};
```

```js
const setupRenderEffect = (
  instance,
  initialVNode,
  container,
  anchor,
  parentSuspense,
  namespace,
  optimized
) => {
  const componentUpdateFn = () => {
    //...
    const subTree = (instance.subTree = renderComponentRoot(instance));
    //...
    patch(null, subTree, container, anchor, instance, parentSuspense, namespace);
    //...
  };
};

function renderComponentRoot(instance) {
  const {
    type: Component,
    //...
    render,
    //...
    setupState
    //...
  } = instance;
  //...
  result = normalizeVNode(
    render.call(
      thisProxy,
      proxyToUse,
      renderCache,
      !!(process.env.NODE_ENV !== 'production') ? shallowReadonly(props) : props,
      setupState,
      data,
      ctx
    )
  );
  //...
}
```
