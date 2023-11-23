《Vue.js 技术内幕》黄轶.著

# 源码优化

## vue2 源码 src 目录

- complier：模板编译的相关代码
- core：与平台无关的通用运行时代码
- platforms：平台专有代码
- server：服务端渲染的相关代码
- sfc：.vue 单文件解析相关代码
- shared：共享工具代码

## Vue3 源码 packages 目录

采用 monorepo

- compiler-core：与平台无关的编译器核心代码实现.

> 编译：把模板字符串转化成渲染函数。

> 包含编译器的基础编译流程:解析模板生成 AST->AST 的结点转换->根据 AST 生成代码。转换过程执行很多转换插件，包含所有与平台无关的转换插件。

- compiler-dom：专门针对浏览器的转换插件

> 浏览器编译时使用的编译器，在 compiler-core 基础上封装

- compiler-sfc：.vue 文件的解析，template、script、style 的解析相关代码

> SFC(single file component)单文件组件

> webpack 的 vue-loader，解析 vue 文件，把 template、script、style 分别抽离出来，然后各个模块运行自己的解析器，单独解析。

- runtime-core：与平台无关的运行时核心代码

> 包含虚拟 DOM 渲染器、组件实现和一些全局的 JavaScript API。可基于 runtime-core 创建针对特定平台的高阶运行时（自定义渲染器）

- runtime-dom：基于 runtime-core 创建的一浏览器为目标的运行时

> 包含对原生 DOM API、属性样式、事件等管理

- runtime-test：用于测试 runtime-core 的轻量级运行时。

> 仅用于 vue 自身的内部测试，确保使用此包测试的逻辑与 DOM 无关，并且运行速度比 jsdom 快。可在任何 js 环境使用，可渲染成一颗普通 js 对象树。可作为实现自定义渲染器的参考。

- reactivity：响应式系统的视线，是 runtime-core 的依赖，可作为框架无关的包独立使用
- template-explorer：调试模板编译输出的工具。

> 执行`yarn dev-complier`，再执行`yarn open`,可打开模板编译输出工具，调试编译结果。

- sfc-playground：用于调试 SFC 编译输出的工具。包含 template、script、style 的编译

- shared：包含多个包共享的内部实用工具库
- size-check：检测 tree-shaking 后 vue 运行时的代码体积
- server-render：包含服务器端渲染的核心实现
- vue：面向开发者的完整构建，包含运行时的版本和带编译器的版本
- vue-compat：提供可配置的 vue2 兼容行为

**各包依赖关系**

```js
              compiler-sfc
              |           |
              v           v
 -->   compiler-dom -->  compiler-core
 |
vue
 |
 -->   runtime-dom  ---> runtime-core->reactivity
```

**版本**
Runtime+Complier:动态编译 template

Runtime-only：借助 vue-loader，离线构建，把 template 编译成 render 函数，并添加到组件对象中。只需要 runtime。更轻量，性能更好。

vue3 采用并行编译：每个包的编译都是一个异步过程，他们之间的编译没有依赖编译。

## vue2 Flow 静态类型检查工具

不适用于复杂场景下的类型检查，props 类型推断为 any

## Vue3 Typescript 类型检查

支持复杂的类型推到

# 性能优化

## 源码体积优化：

- 移除一些冷门功能（比如 filter,inline-template 等）
- 引入 tree-shaking，减少打包体积。

> tree-shaking 原理：依赖 ES2015 模块语法的静态结构（即 import 和 export）,通过编译阶段的静态分析，找到没有导入的模块，大商标及，然后在压缩阶段删除已标记的代码。
> 压缩阶段会用：uglify-js 和 terser 等

## 数据劫持和优化

**响应式，双向绑定**

- DOM 是数据的一种映射，Vue.js 在数据发生改变后可自动更新 DOM,开发者只需专注于数据的修改，无额外的的负担。

- 数据劫持：当数据改变后，为了自动更新 DOM，必须劫持数据的更新，即数据改变后能自动执行一些代码去更新 DOM

- 收集依赖：更新哪个 DOM,在渲染 DOM 时，访问数据是就可以对其进行访问劫持，在内部建立依赖关系，数据即可对应 DOM。

- 思路：

1. 渲染=》访问数据=》数据的 getter=>收集依赖=》watcher 依赖管理=》

2. 改变数据 setter=》派发通知=》watcher 依赖管理=》

3. watcher 依赖管理=》触发对应 DOM 重新渲染=》执行组件渲染函数=》虚拟 DOM 树

![reactive](images/vue3/reactive.png)

- Vue2 通过 Object.defineProperty 去劫持数据的 getter 和 setter。

```js
Object.defineProperty(data, 'a', {
  get() {
    //track
  },
  set() {
    //trigger
  }
});
```

**Object.defineProperty 缺陷：**

1. 必须预先知道要拦截的 key 是什么，所以不能检测对象的属性的添加和删除。（通过`$set和$delete`实例函数解决）
2. 无法判断运行时访问哪个属性，嵌套比较深的对象若要劫持它的内部深层次的对象变换，需递归遍历整个对象，执行 Object.defineProperty 把每一处对象数据变成响应式，代价过大。

- Vue3 使用 Proxy 进行数据劫持，劫持的是整个对象，对属性增删都能检测到。

```js
observed = new Proxy(data, {
  get() {
    //track
  },
  set() {
    //trigger
  }
});
```

> Proxy 不能监听到内部深层次的对象变化，Vue3 在 Proxy 处理对象的 getter 中进行了递归响应。好处：只有真正访问到的内部对象才会变成响应式，而不是全部递归。

## 编译优化

**Vue2 new Vue 渲染成 DOM 流程**

1. new Vue
2. init（发生响应式过程）
3. $mout
4. complie
5. render
6. vnode
7. patch
8. DOM

> 模板 template 编译生成 render 函数的流程是可借助 vue-loader 在 webpack 编译阶段离线完成的，并非一定要在运行时完成。

- 通过数据劫持和依赖收集，Vue2 数据更新并触发重新渲染的粒度是组件级，保证触发更新的组件最小化，但在单个组件内部依旧需要遍历该组件的整个 vnode 树。

- Vue2 diff 算法：遍历所有结点，导致 vnode 的更新新能跟模板大小正相关，更动态结点的数量无关。当一些组件的整个模板内只有少量动态节点是，这些遍历就是浪费性能。

运行时的 patch 阶段优化：Vue3 通过在编译阶段对静态模板的分析，编译生成了 Block Tree.

> Block Tree 是将模板基于动态结点指令切割的嵌套区块，每个区块内部的节点结构是固定，而且每个区块只需要以一个 Array 来追踪自身包含的动态结点。

Vue3 将 vnode 的更新性能由于模板整体大小相关提升为与动态内容的数量相关。

## 语法 API 优化

- Vue2 选项式 API(Options API):包含描述组件配置项的对象。`method,computed,data,props`

- Vue3 组合式 API(Composition API)

- 逻辑复用：Vue2 mixin 存在命名冲突，数据来源不清晰的问题，所有都挂载在 this 上.Vue3 采用 hooks 函数,对 tree-shaking,代码压缩友好。

## 引入 RFC

RFC(Request For Comments)：在新功能进入框架提供一个一致且受控的路径。改动和设计是经过讨论并得到确认。

# 组件

**模板渲染组件流程**

1. 模板
2. 添加对象描述
3. 注入数据
4. 渲染出组件

组件渲染流程：创建 vnode->渲染 vnode->生成 DOM

## vnode

> 描述 DOM 的 js 对象

普通元素 vnode

```jsx
<button class="btn" style="width:100px;height:50px">
  Click me
</button>;

const vnode = {
  type: 'button',
  props: {
    class: 'btn',
    style: {
      height: '100px',
      width: '50px'
    }
  },
  children: 'Click me'
};
```

组件 vnode

```jsx
<my-btn text="Click me"></my-btn>;

const MyBtn = {
  //定义组件对象
};
const vnode = {
  type: MyBtn,
  props: {
    text: 'Click me'
  }
};
```

对 vnode 类型信息进行编码，为后面 vnode 挂在阶段根据类型执行对象处理逻辑

```js
//packages\runtime-core\src\vnode.ts 572
const shapeFlag = isString(type)
  ? ShapeFlags.ELEMENT
  : __FEATURE_SUSPENSE__ && isSuspense(type)
  ? ShapeFlags.SUSPENSE
  : isTeleport(type)
  ? ShapeFlags.TELEPORT
  : isObject(type)
  ? ShapeFlags.STATEFUL_COMPONENT
  : isFunction(type)
  ? ShapeFlags.FUNCTIONAL_COMPONENT
  : 0;
```

引入 vnode，可把渲染过程抽象化，使得组件抽象能力提升，并且可以更加容易实现跨平台。

## 创建 vnode

```js
//packages\runtime-core\src\vnode.ts 419
//createBaseVNode别名createElementVNode
function createBaseVNode(
  type: VNodeTypes | ClassComponent | typeof NULL_DYNAMIC_COMPONENT,
  props: (Data & VNodeProps) | null = null,
  children: unknown = null,
  patchFlag = 0,
  dynamicProps: string[] | null = null,
  shapeFlag = type === Fragment ? 0 : ShapeFlags.ELEMENT,
  isBlockNode = false,
  needFullChildrenNormalization = false//true时执行normalizeChildren去标准化子节点
) {
  const vnode = {
    __v_isVNode: true,
    __v_skip: true,
    type,
    props,
    key: props && normalizeKey(props),
    ref: props && normalizeRef(props),
    scopeId: currentScopeId,
    slotScopeIds: null,
    children,
    component: null,
    suspense: null,
    ssContent: null,
    ssFallback: null,
    dirs: null,
    transition: null,
    el: null,
    anchor: null,
    target: null,
    targetAnchor: null,
    staticCount: 0,
    shapeFlag,
    patchFlag,
    dynamicProps,
    dynamicChildren: null,
    appContext: null,
    ctx: currentRenderingInstance
  } as VNode
  //处理Block Tree

  return vnode;
}
```

```js
//packages\runtime-core\src\vnode.ts 510
function _createVNode(
  type: VNodeTypes | ClassComponent | typeof NULL_DYNAMIC_COMPONENT,
  props: (Data & VNodeProps) | null = null,
  children: unknown = null,
  patchFlag: number = 0,
  dynamicProps: string[] | null = null,
  isBlockNode = false
): VNode {
  //判断type是否为空，空的时候默认是Comment注释
  //判断type是否为一个vnode的组件
  //判断type是否为class类型组件
  //classhe style标准化
  //对vnode的类型信息做编码
  return createBaseVNode(
    type,
    props,
    children,
    patchFlag,
    dynamicProps,
    shapeFlag,
    isBlockNode,
    true
  );
}
```

vue 官方提供的在线模板导出工具[vue template explorer](https://template-explorer.vuejs.org/)

```jsx
<div>
  <p  class="aaa" style="color:blue">Hello World
  </p>
  <my-btn type="primary">Click me</button>
  </div>

  //编译后render函数
  import { createElementVNode as _createElementVNode, createTextVNode as _createTextVNode, resolveComponent as _resolveComponent, withCtx as _withCtx, createVNode as _createVNode, openBlock as _openBlock, createElementBlock as _createElementBlock } from "vue"

export function render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_my_btn = _resolveComponent("my-btn")

  return (_openBlock(), _createElementBlock("div", null, [
    _createElementVNode("p", {
      class: "aaa",
      style: {"color":"blue"}
    }, "Hello World "),
    _createVNode(_component_my_btn, { type: "primary" }, {
      default: _withCtx(() => [
        _createTextVNode("Click me")
      ], undefined, true),
      _: 1 /* STABLE */
    })
  ]))
}
```

## 组件挂载

```js
//packages\runtime-core\src\renderer.ts 1182
const mountComponent: MountComponentFn = (
  initialVNode, //组件vnode
  container, //挂载父节点
  anchor, //挂载参考锚点
  parentComponent, //父组件实例
  parentSuspense,
  isSVG,
  optimized
) => {
  //创建组件实例
  const instance: ComponentInternalInstance =
    compatMountInstance ||
    (initialVNode.component = createComponentInstance(
      initialVNode,
      parentComponent,
      parentSuspense
    ));
  //设置组件实例
  setupComponent(instance);
  //设置并运行呆副作用的渲染函数
  setupRenderEffect(instance, initialVNode, container, anchor, parentSuspense, isSVG, optimized);
};
```

> vue2 通过类的方式实例化组件，vue3 对象的方式创建

> instance:保存了组件相关数据，维护组件的上下文，包括 props、插槽、以及其他实例的属性的初始化处理

## 设置副作用渲染函数

```js
//packages\runtime-core\src\renderer.ts 1292
const setupRenderEffect: SetupRenderEffectFn = (
  instance,
  initialVNode,
  container,
  anchor,
  parentSuspense,
  isSVG,
  optimized
) => {
  //组件渲染和更新函数
  const componentUpdateFn = () => {
    if (!instance.isMounted) {
      //渲染组件生成子树vnode
      const subTree = (instance.subTree = renderComponentRoot(instance));
      //把子树vnode挂载到container中
      patch(null, subTree, container, anchor, instance, parentSuspense, isSVG);
      //保存渲染生成的子树根DOM结点
      initialVNode.el = subTree.el;
      instance.isMounted = true;
    } else {
      //更新组件
    }
    //创建组件渲染的副作用响应式对象
    const effect = (instance.effect = new ReactiveEffect(
      componentUpdateFn,
      () => queueJob(update),
      instance.scope // track it in component's effect scope
    ));

    const update: SchedulerJob = (instance.update = () => effect.run());
    update.id = instance.uid;
    //递归更新自己
    toggleRecurse(instance, true);
    update();
  };
};
```

初始化渲染：渲染组件生成 subTree,把 subTree 挂载到 container 中

## 渲染组件生成 subTree

```js
//packages\runtime-core\src\componentRenderUtils.ts 43

export function renderComponentRoot(
  instance: ComponentInternalInstance
): VNode {
  const {
    type: Component,
    vnode,
    proxy,
    withProxy,
    props,
    propsOptions: [propsOptions],
    slots,
    attrs,
    emit,
    render,
    renderCache,
    data,
    setupState,
    ctx,
    inheritAttrs
  } = instance

  let result

  try {
    if (vnode.shapeFlag & ShapeFlags.STATEFUL_COMPONENT) {
        //有状态的组件渲染
      const proxyToUse = withProxy || proxy
      result = normalizeVNode(
        render!.call(
          proxyToUse,
          proxyToUse!,
          renderCache,
          props,
          setupState,
          data,
          ctx
        )
      )
      fallthroughAttrs = attrs
    } else {
    //函数式组件渲染
    }

  } catch (err) {
    blockStack.length = 0
    handleError(err, instance, ErrorCodes.RENDER_FUNCTION)
    //渲染错误则渲染成注释节点
    result = createVNode(Comment)
  }


  return result;
}
```

## subTree 挂载

```js
//packages\runtime-core\src\renderer.ts 358
const patch: PatchFn = (
  n1, //旧vnode,为null即是第一次挂载
  n2, //新vnode
  container, //DOM容器
  anchor = null, //挂载参考锚点
  parentComponent = null,
  parentSuspense = null,
  isSVG = false,
  slotScopeIds = null,
  optimized = __DEV__ && isHmrUpdating ? false : !!n2.dynamicChildren
) => {
  const { type, ref, shapeFlag } = n2;
  switch (type) {
    case Text: //处理文本节点
      processText(n1, n2, container, anchor);
      break;
    case Comment: //处理注释节点
      processCommentNode(n1, n2, container, anchor);
      break;
    case Static: //处理静态节点
      if (n1 == null) {
        mountStaticNode(n2, container, anchor, isSVG);
      } else if (__DEV__) {
        patchStaticNode(n1, n2, container, isSVG);
      }
      break;
    case Fragment: //处理fragment
      break;
    default:
      if (shapeFlag & ShapeFlags.ELEMENT) {
        //处理普通DOM元素
        processElement(
          n1,
          n2,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          isSVG,
          slotScopeIds,
          optimized
        );
      } else if (shapeFlag & ShapeFlags.COMPONENT) {
        //处理组件
        processComponent(
          n1,
          n2,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          isSVG,
          slotScopeIds,
          optimized
        );
      } else if (shapeFlag & ShapeFlags.TELEPORT) {
        //处理teleport
      } else if (__FEATURE_SUSPENSE__ && shapeFlag & ShapeFlags.SUSPENSE) {
        //处理suspense
      } else if (__DEV__) {
        warn('Invalid VNode type:', type, `(${typeof type})`);
      }
  }
};
```

patch 函数功能：根据 vnode 挂载 DOM，根据新 vnode 更新 DOM

## 普通元素的挂载

```js
//packages\runtime-core\src\renderer.ts 577
const processElement = (
  n1: VNode | null,
  n2: VNode,
  container: RendererElement,
  anchor: RendererNode | null,
  parentComponent: ComponentInternalInstance | null,
  parentSuspense: SuspenseBoundary | null,
  isSVG: boolean,
  slotScopeIds: string[] | null,
  optimized: boolean
) => {
  isSVG = isSVG || n2.type === 'svg';
  if (n1 == null) {
    //挂载元素节点
    mountElement(
      n2,
      container,
      anchor,
      parentComponent,
      parentSuspense,
      isSVG,
      slotScopeIds,
      optimized
    );
  } else {
    //更新组件
  }
};
```

```js
//packages\runtime-core\src\renderer.ts 613
  const mountElement = (
    vnode: VNode,
    container: RendererElement,
    anchor: RendererNode | null,
    parentComponent: ComponentInternalInstance | null,
    parentSuspense: SuspenseBoundary | null,
    isSVG: boolean,
    slotScopeIds: string[] | null,
    optimized: boolean
  ) => {
    let el: RendererElement
    let vnodeHook: VNodeHook | undefined | null
    const { type, props, shapeFlag, transition, dirs } = vnode
//创建DOM元素节点
    el = vnode.el = hostCreateElement(
      vnode.type as string,
      isSVG,
      props && props.is,
      props
    )

    //子节点优先处理

//处理子节点vnode是纯文本的情况
    if (shapeFlag & ShapeFlags.TEXT_CHILDREN) {
      hostSetElementText(el, vnode.children as string)
    } else if (shapeFlag & ShapeFlags.ARRAY_CHILDREN) {
        //处理子节点vnode是数组的情况
      mountChildren(
        vnode.children as VNodeArrayChildren,
        el,
        null,
        parentComponent,
        parentSuspense,
        isSVG && type !== 'foreignObject',
        slotScopeIds,
        optimized
      )
    }

    if (props) {
        //处理props,如class,style,events等属性
      for (const key in props) {
        if (key !== 'value' && !isReservedProp(key)) {
          hostPatchProp(
            el,
            key,
            null,
            props[key],
            isSVG,
            vnode.children as VNode[],
            parentComponent,
            parentSuspense,
            unmountChildren
          )
        }
      }
    }
    //把创建的DOM元素节点挂载到container
    hostInsert(el, container, anchor)
  }
```

hostCreateElement 创建 DOM 元素节点，与平台相关

浏览器下 hostCreateElement:createElement,调用 document.createElement 或 document.createElementNS

```js
//packages\runtime-dom\src\nodeOps.ts

createElement: (tag, isSVG, is, props): Element => {
    const el = isSVG
      ? doc.createElementNS(svgNS, tag)
      : doc.createElement(tag, is ? { is } : undefined)

    if (tag === 'select' && props && props.multiple != null) {
      ;(el as HTMLSelectElement).setAttribute('multiple', props.multiple)
    }

    return el
  }
//设置文本内容
 setElementText: (el, text) => {
    el.textContent = text
  },
//在处理子节点后执行insert:child插入到anchor前面，若anchor为空，child插入到parent子节点的末尾
  insert: (child, parent, anchor) => {
    parent.insertBefore(child, anchor || null)
  },
```

**处理子节点**

```js
// packages\runtime-core\src\renderer.ts 761
const mountChildren: MountChildrenFn = (
    children,
    container,
    anchor,
    parentComponent,
    parentSuspense,
    isSVG,
    slotScopeIds,
    optimized,
    start = 0
  ) => {
    for (let i = start; i < children.length; i++) {
      const child = (children[i] = optimized
        ? cloneIfMounted(children[i] as VNode)
        : normalizeVNode(children[i]))
        //递归patch挂载child
      patch(
        null,
        child,
        container,
        anchor,
        parentComponent,
        parentSuspense,
        isSVG,
        slotScopeIds,
        optimized
      )
    }
  }
```

patch 深度优先遍历树

**DOM 挂载顺序：**

1. 子节点
2. 父节点
3. 最外层容器

## 组件嵌套挂载

```js
//packages\runtime-core\src\renderer.ts 1145
 const processComponent = (
    n1: VNode | null,
    n2: VNode,
    container: RendererElement,
    anchor: RendererNode | null,
    parentComponent: ComponentInternalInstance | null,
    parentSuspense: SuspenseBoundary | null,
    isSVG: boolean,
    slotScopeIds: string[] | null,
    optimized: boolean
  ) => {
    n2.slotScopeIds = slotScopeIds
    if (n1 == null) {
        //keep-alive
      if (n2.shapeFlag & ShapeFlags.COMPONENT_KEPT_ALIVE) {
        ;(parentComponent!.ctx as KeepAliveContext).activate(
          n2,
          container,
          anchor,
          isSVG,
          optimized
        )
      } else {
        //挂载组件
        mountComponent(
          n2,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          isSVG,
          optimized
        )
      }
    } else {
      updateComponent(n1, n2, optimized)
    }
  }
```

## 应用程序初始化

```js
//packages\runtime-dom\src\index.ts 65
//创建渲染器对象
export const createApp = ((...args) => {
  const app = ensureRenderer().createApp(...args)
}


//41
// 延时创建渲染器
function ensureRenderer() {
  return (
    renderer ||
    (renderer = createRenderer<Node, Element | ShadowRoot>(rendererOptions))
  )
}

//33
//与平台渲染相关的一些配置，如更新属性，操作DOM的函数等
const rendererOptions = /*#__PURE__*/ extend({ patchProp }, nodeOps)
```

延时创建渲染器：当用户只依赖响应式包的时候，并不会创建渲染器，可通过 tree-shaking 移除与核心渲染逻辑相关的代码

```js
//packages\runtime-core\src\renderer.ts 297
export function createRenderer<HostNode = RendererNode, HostElement = RendererElement>(
  options: RendererOptions<HostNode, HostElement>
) {
  return baseCreateRenderer < HostNode, HostElement > options;
}

function baseCreateRenderer(
  options: RendererOptions,
  createHydrationFns?: typeof createHydrationFunctions
): any {
  return {
    render,
    hydrate,
    createApp: createAppAPI(render, hydrate)
  };
}
// packages\runtime-core\src\apiCreateApp.ts 199
export function createAppAPI<HostElement>(
  render: RootRenderFunction<HostElement>,
  hydrate?: RootHydrateFunction
): CreateAppFunction<HostElement> {
  //createApp函数接收根组件的对象和跟props
  return function createApp(rootComponent, rootProps = null) {
    const app = {
     mount(
        rootContainer: HostElement,
        isHydrate?: boolean,
        isSVG?: boolean
      ): any {
        //创建更组件的vnode
        //利用渲染器渲染vnode

         return getExposeProxy(vnode.component!) || vnode.component!.proxy
      }
    };
    return app;
  };
}
```

## 重写 app.mount

支持跨平台渲染

```js
// packages\runtime-core\src\apiCreateApp.ts 319
mount(
        rootContainer: HostElement,
        isHydrate?: boolean,
        isSVG?: boolean
      ): any {

      const vnode = createVNode(rootComponent, rootProps)

          vnode.appContext = context
           render(vnode, rootContainer, isSVG)

          isMounted = true
          app._container = rootContainer
 return getExposeProxy(vnode.component!) || vnode.component!.proxy
           }
```

浏览器端渲 mount

```js
//packages\runtime-dom\src\index.ts 74
app.mount = (containerOrSelector: Element | ShadowRoot | string): any => {
  //标准化容器
  const container = normalizeContainer(containerOrSelector);
  if (!container) return;

  const component = app._component;
  //如果组件对象没有定义render函数和template模板，则取innerHTML作为组件模板内容
  if (!isFunction(component) && !component.render && !component.template) {
    component.template = container.innerHTML;
  }

  //挂在前清空容器内容
  container.innerHTML = '';
  //挂载
  const proxy = mount(container, false, container instanceof SVGElement);
  if (container instanceof Element) {
    container.removeAttribute('v-cloak');
    container.setAttribute('data-v-app', '');
  }
  return proxy;
};
```

## 执行 mount 函数渲染应用

```js
// packages\runtime-core\src\renderer.ts 2318
const render: RootRenderFunction = (vnode, container, isSVG) => {
  if (vnode == null) {
    //销毁组件
    if (container._vnode) {
      unmount(container._vnode, null, null, true);
    }
  } else {
    //创建或更新组件
    patch(container._vnode || null, vnode, container, null, null, null, isSVG);
  }
  flushPreFlushCbs();
  flushPostFlushCbs();
  //缓存vnode节点，表示已经渲染
  container._vnode = vnode;
};
```

## Vue App 渲染流程

![渲染流程](images/vue3/vueApp.png)

# 组件更新

更新组件 vnode 节点，渲染新的子树 vnode，以及根据新旧子树 vnode 执行 patch 逻辑

```js
//packages\runtime-core\src\renderer.ts 1292
const setupRenderEffect: SetupRenderEffectFn = (
  instance,
  initialVNode,
  container,
  anchor,
  parentSuspense,
  isSVG,
  optimized
) => {
  if (!instance.isMounted) {
  } else {
    //更新组件
    let { next, bu, u, parent, vnode } = instance;

    if (next) {
      next.el = vnode.el;
      updateComponentPreRender(instance, next, optimized);
    } else {
      next = vnode;
    }
  }
};
```

```js
//packages\runtime-core\src\renderer.ts 358
const patch: PatchFn = (
  n1,
  n2,
  container,
  anchor = null,
  parentComponent = null,
  parentSuspense = null,
  isSVG = false,
  slotScopeIds = null,
  optimized = __DEV__ && isHmrUpdating ? false : !!n2.dynamicChildren
) => {
  //如果存在新旧节点且类型不同，则销毁旧节点
  if (n1 && !isSameVNodeType(n1, n2)) {
    anchor = getNextHostNode(n1);
    unmount(n1, parentComponent, parentSuspense, true);
    //n1置空，保证后续执行mount逻辑
    n1 = null;
  }
};

// packages\runtime-core\src\vnode.ts 354
export function isSameVNodeType(n1: VNode, n2: VNode): boolean {
  //只有n1和n2节点的type和key都相同，才是相同的节点
  return n1.type === n2.type && n1.key === n2.key;
}
```

```js
//packages\runtime-core\src\renderer.ts 1145
 const processComponent = (
    n1: VNode | null,
    n2: VNode,
    container: RendererElement,
    anchor: RendererNode | null,
    parentComponent: ComponentInternalInstance | null,
    parentSuspense: SuspenseBoundary | null,
    isSVG: boolean,
    slotScopeIds: string[] | null,
    optimized: boolean
  ) => {
    if (n1 == null) {
    }else{
       updateComponent(n1, n2, optimized)
    }
  }
//1258
   const updateComponent = (n1: VNode, n2: VNode, optimized: boolean) => {
    const instance = (n2.component = n1.component)!
    //根据新旧子组件vnode判断是否需要更新子组件
    if (shouldUpdateComponent(n1, n2, optimized)) {
      if (
        __FEATURE_SUSPENSE__ &&
        instance.asyncDep &&
        !instance.asyncResolved      ) {

        updateComponentPreRender(instance, n2, optimized)
        return
      } else {
        //省略异步组件逻辑，只保留普通更新逻辑
        //将新的子组件vnode赋值给instance.next
        instance.next = n2
        //子组件也可能因为数据变化而被添加 到更新队列里，移除他们以防对子组件重复更新
        invalidateJob(instance.update)
        //执行子组件的副作用渲染函数
        instance.update()
      }
    } else {
      // 不需更新.只复制属性
      n2.el = n1.el
      instance.vnode = n2
    }
   }
```

shouldUpdateComponent 通过检测并对比组件 vnode 中的 props、children、dirs、transition 等属性，来决定子组件是否需要更新。（取决于子组件是否存在一些影响组件更新的属性变化）

```js
//packages\runtime-core\src\renderer.ts 1570
const updateComponentPreRender = (
  instance: ComponentInternalInstance,
  nextVNode: VNode,
  optimized: boolean
) => {
  //新组件vnode的component属性指向组件实例
  nextVNode.component = instance;
  //旧组件vnode的 props属性
  const prevProps = instance.vnode.props;
  //组件实例的vnode属性指向新的组件vnode
  instance.vnode = nextVNode;
  //清空next属性，为重新渲染做准备
  instance.next = null;
  //更新props
  updateProps(instance, nextVNode.props, prevProps, optimized);
  //更新插槽
  updateSlots(instance, nextVNode.children, optimized);

  pauseTracking();
  // props update may have triggered pre-flush watchers.
  // flush them before the render update.
  flushPreFlushCbs();
  resetTracking();
};
```

组件重新渲染的可能两种场景：

1. 组件本身的数据变化，next=null
2. 父组件在更新的过程中遇到子组件节点，先判断子组件是否需要更新，若需要更新，则主动执行子组件的重新渲染函数，next 为新的子组件 vnode

```js
// packages\runtime-core\src\renderer.ts 577
const processElement = (
  n1: VNode | null,
  n2: VNode,
  container: RendererElement,
  anchor: RendererNode | null,
  parentComponent: ComponentInternalInstance | null,
  parentSuspense: SuspenseBoundary | null,
  isSVG: boolean,
  slotScopeIds: string[] | null,
  optimized: boolean
) => {
  if (n1 == null) {
    //挂载元素
  } else {
    //更新元素
    patchElement(n1, n2, parentComponent, parentSuspense, isSVG, slotScopeIds, optimized);
  }
};

//790
const patchElement = (
  n1: VNode,
  n2: VNode,
  parentComponent: ComponentInternalInstance | null,
  parentSuspense: SuspenseBoundary | null,
  isSVG: boolean,
  slotScopeIds: string[] | null,
  optimized: boolean
) => {
  //更新props
  patchProps(el, n2, oldProps, newProps, parentComponent, parentSuspense, isSVG);
  //更新子节点
  patchChildren(
    n1,
    n2,
    el,
    null,
    parentComponent,
    parentSuspense,
    areChildrenSVG,
    slotScopeIds,
    false
  );
};
```

```js
//packages\runtime-core\src\renderer.ts 1589
const patchChildren: PatchChildrenFn = (
  n1,
  n2,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  isSVG,
  slotScopeIds,
  optimized = false
) => {
  if (patchFlag > 0) {
    if (patchFlag & PatchFlags.KEYED_FRAGMENT) {
      patchKeyedChildren(/****/);
      return;
    } else if (patchFlag & PatchFlags.UNKEYED_FRAGMENT) {
      patchUnkeyedChildren(/****/);
      return;
    }
  }
};
```

元素子节点 vnode 情况：纯文本、vnode 数组和空

## 核心 diff 算法

```js
//packages\runtime-core\src\renderer.ts 1751
const patchKeyedChildren = (
  c1: VNode[],
  c2: VNodeArrayChildren,
  container: RendererElement,
  parentAnchor: RendererNode | null,
  parentComponent: ComponentInternalInstance | null,
  parentSuspense: SuspenseBoundary | null,
  isSVG: boolean,
  slotScopeIds: string[] | null,
  optimized: boolean
) => {
  let i = 0; //头部索引
  const l2 = c2.length; //新子节点数量
  let e1 = c1.length - 1; // 旧子节点的尾部索引
  let e2 = l2 - 1; // 新子节点的尾部索引
};
```

同步头部节点：从头部开始，依次对比新节点和旧节点，如果他们相同，则执行 patch 更新节点，如果不同或者索引 i 大于 e1 或 e2，则同步过程结束。

同步尾部节点：从尾部开始，依次对比新节点和旧节点，如果他们相同，则执行 patch 更新节点，如果不同或者索引 i 大于 e1 或 e2，则同步过程结束。

添加新节点：先判断新子节点是否有剩余，如果有则添加新子节点，如果索引 i 大于尾部索引 e1 且小于 e2，那么直接挂载新子树从索引 i 开始索引 e2 部分的结点

删除多余节点：如果不满足添加新节点的条件，就接着判断旧节点是否有剩余，如果有，则删除旧节点。如果索引 i 大于尾部索引 e2，那么直接删除旧子树从索引 i 开始到索引 e1 部分的结点。

处理未知子序列：

移动子节点：在目标序列中找到一个递增子序列，然后对目标序列数组进行倒序遍历，移动所有不在递增序列的元素即可。递增子序列越长，需要移动元素的次数越少，求解最长递增子序列。

查找需要操作的结点和对应的操作，双重循环，复杂度 O(n^2)，=》空间换时间，简历索引图，时间复杂度为 O(n)

建立索引图：v-for 的 key 作为唯一 id,如果 key 相同，则为同一个节点，直接执行 patch 更新。

新旧子序列都是从 i 开始的，先用 s1 和 s2 分别作为新旧子序列的开始索引，简历 keyToNewIndexMap 的`Map<key,index>`结构，遍历芯子序列，并把节点的 key 和 index 添加到 Map 中。

keyToNewIndexMap 存储新子序列中每个节点在新子序列的索引。

更新和移除旧节点：通过 patch 更新相同的节点，移除那些不在的新子序列中的节点，并找出是否有需要移动节点。

newIndexToOldIndexMap 的数组，存储新子序列节点的索引和旧子序列节点的索引自己的映射关系，用于确定最长递增子序列。长度为新子序列的长度，每个元素的初始值是 0.若遍历后值仍为 0，说明遍历就子序列的过程中，没有处理该节点，节点是新增的。

---

## 组件更新流程

![组件更新的流程](images/vue3/comp-update.png)

# 组件实例

```js
//packages\runtime-core\src\renderer.ts 1182
const mountComponent: MountComponentFn = (
  initialVNode,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  isSVG,
  optimized
) => {
  //创建组件实例
  const compatMountInstance = __COMPAT__ && initialVNode.isCompatRoot && initialVNode.component;
  const instance: ComponentInternalInstance =
    compatMountInstance ||
    (initialVNode.component = createComponentInstance(
      initialVNode,
      parentComponent,
      parentSuspense
    ));
  //设置组件实例
  setupComponent(instance);
  //设置并运行带副作用的渲染函数
  setupRenderEffect(instance, initialVNode, container, anchor, parentSuspense, isSVG, optimized);
};
```

```js
//packages\runtime-core\src\component.ts 484
export function createComponentInstance(
  vnode: VNode,
  parent: ComponentInternalInstance | null,
  suspense: SuspenseBoundary | null
) {}

//658
export function setupComponent(instance: ComponentInternalInstance, isSSR = false) {
  const setupResult = isStateful ? setupStatefulComponent(instance, isSSR) : undefined;
  isInSSRComponentSetup = false;
  return setupResult;
}
//676 处理setup函数
function setupStatefulComponent(instance: ComponentInternalInstance, isSSR: boolean) {}

//982
export function createSetupContext(instance: ComponentInternalInstance): SetupContext {}
//
const setupResult = callWidthErrorHandling();

function handleSetupResult() {}

//完成组件实例设置
function finishComponentSetup() {}

//是否注册complier
function registerRuntimeComplier() {}
```

```js
//packages\runtime-core\src\componentPublicInstance.ts 297
//创建渲染上下文代理
export const PublicInstanceProxyHandlers: ProxyHandler<any> = {};
//运行时编译的渲染函数，渲染上下文的代理
const RuntimeCompliedPublicInstanceProxyHandlers = {};
```

```js
//packages\runtime-core\src\componentOptions.ts
//兼容Options API
function applyOptions() {}
```

## 组件初始化流程

![image](images/vue3/init-comp.png)

# 组件的 props

```js
//packages\runtime-core\src\componentProps.ts
//标准化props
export function normalizePropsOptions(
  comp: ConcreteComponent,
  appContext: AppContext,
  asMixin = false
): NormalizedPropsOptions {}

//props值的初始化
export function initProps(
  instance: ComponentInternalInstance,
  rawProps: Data | null,
  isStateful: number, // result of bitwise flag comparison
  isSSR = false
) {}

//设置props
function setFullProps() {}
//转换props的key needCastKeys
function resolvePropValue() {}
//验证props
function validateProps() {}
//响应式处理
instance.props = isSSR ? props : shadowReactive(props);
//props更新
function updateProps() {}
```

# 组件的生命周期

vue2->vue3

```
beforeCreate->setup
created->setup
beforeMount->onBeforeMounted
mounted->onMounted
beforeUpdate->onBeforeUpdate
updated->onUpdated
beforeDestroy->onBeforeUnmount
destroy->onUnmounted
activated->onActivited
deactivated->onDeactivated
errorCaptured->onErrorCaptured
renderTracked->onRenderTracked
renderTriggered->onRenderTriggered
```

注册钩子函数

```js
//packages\runtime-core\src\apiLifecycle.ts
export const onBeforeMount = createHook(LifecycleHooks.BEFORE_MOUNT)
export const onMounted = createHook(LifecycleHooks.MOUNTED)
export const onBeforeUpdate = createHook(LifecycleHooks.BEFORE_UPDATE)
export const onUpdated = createHook(LifecycleHooks.UPDATED)
export const onBeforeUnmount = createHook(LifecycleHooks.BEFORE_UNMOUNT)
export const onUnmounted = createHook(LifecycleHooks.UNMOUNTED)
export const onServerPrefetch = createHook(LifecycleHooks.SERVER_PREFETCH)
//钩子函数
export const createHook =
  <T extends Function = () => any>(lifecycle: LifecycleHooks) =>
  (hook: T, target: ComponentInternalInstance | null = currentInstance) =>
    // post-create lifecycle registrations are noops during SSR (except for serverPrefetch)
    (!isInSSRComponentSetup || lifecycle === LifecycleHooks.SERVER_PREFETCH) &&
    injectHook(lifecycle, (...args: unknown[]) => hook(...args), target)
//注入hook
export function injectHook(
  type: LifecycleHooks,
  hook: Function & { __weh?: Function },
  target: ComponentInternalInstance | null = currentInstance,
  prepend: boolean = false
): Function | undefined {
  }

```

```js
//packages\runtime-core\src\renderer.ts
const setupRenderEffect=(){
  //onBeforeMount onMounted
  queuePostRenderEffect()//钩子函数推入队列
  //onBeforeUpdate onUpdated

  // onBeforeUnmount onUnmounted
}
```

```js
//packages\runtime-core\src\errorHandling.ts
export function handleError(
  err: unknown,
  instance: ComponentInternalInstance | null,
  type: ErrorTypes,
  throwInDev = true
) {}
```

## 组件生命周期

![image](images/vue3/life-cycle.png)

# 异步组件

```js
const AsyncComp = defineAsyncComponent({
  // 加载函数
  loader: () => import('./Foo.vue'),

  // 加载异步组件时使用的组件
  loadingComponent: LoadingComponent,
  // 展示加载组件前的延迟时间，默认为 200ms
  delay: 200,

  // 加载失败后展示的组件
  errorComponent: ErrorComponent,
  // 如果提供了一个 timeout 时间限制，并超时了
  // 也会显示这里配置的报错组件，默认值是：Infinity
  timeout: 3000,
  /**
   * @param error错误信息
   * @param retry函数，用于只是当promise加载器拒绝reject时，加载器是否应该重试
   * @param fail函数 指示加载程序结束退出
   * @param attemps允许的最大重试次数
   */
  onError: (error, retry, fail, attempts) => {}
});
```

```js
//packages\runtime-core\src\apiAsyncComponent.ts
//渲染占位节点，加载异步js模块以获取组件对象，重新渲染组件
function defineAsyncComponent() {}
//packages\runtime-core\src\vnode.ts
//渲染占位点,空的注释节点
function normalizeVNode() {
  if (child == null || typeof child == 'boolean') {
    return createVNode(Comment);
  }
}

//packages\runtime-core\src\apiAsyncComponent.ts
//加载异步js模块，loader函数内部通过执行用户自定义函数loader发送请求
const load = () => {
  let thisRequest;
  return defineComponent({})
};
//重新渲染组件
load().then(()=>{
load.value=true
}).catch(err=>{
  //错误处理
})
//已加载，渲染真实组件
if（load.value&&resolvedComp){
  return createInnerComp(resolvedComp,instance)
}else if(error.value&&errorComponent){//加载失败且配置error组件，渲染error组件
return createVNode(errorComponent,{error:error.value})
}else if(loadingComponent&&!delayed.value){//配置loading组件且没设置时延，直接渲染loading组件
  return createVNode(loadingComponent)
}
//延时
const delayed=ref(!!delay)

//重试
let retries=0
const retry=()=>{
  retries++
  peddingRequest=null
  return load()
}
//错误处理
const error=ref()
const onError=()=>{}
```

# 响应式的内部实现原理

```js
//packages\reactivity\src\reactive.ts
export function reactive(target: object) {
  // if trying to observe a readonly proxy, return the readonly version.
  if (isReadonly(target)) {
    return target;
  }
  return createReactiveObject(
    target,
    false,
    mutableHandlers,
    mutableCollectionHandlers,
    reactiveMap
  );
}
function createReactiveObject(
  target: Target,
  isReadonly: boolean,
  baseHandlers: ProxyHandler<any>,
  collectionHandlers: ProxyHandler<any>,
  proxyMap: WeakMap<Target, any>
) {}
```

createReactiveObject

1. 函数首先判断 target 是不是数组或对象类型的，不是则直接返回。
2. 如果已经是响应式对象，直接返回，`target._v_raw`判断是否为响应式对象
3. 如果对同一个原始数据多次执行 reactive，则返回相同的响应式对象。`proxyMap`判断是否存在对应的响应式对象
4. 对原始对象的类型做进一步限制

```js
//packages\reactivity\src\reactive.ts
function targetTypeMap(rawType: string) {
  switch (rawType) {
    //对象和数组
    case 'Object':
    case 'Array':
      return TargetType.COMMON;
    //集合类
    case 'Map':
    case 'Set':
    case 'WeakMap':
    case 'WeakSet':
      return TargetType.COLLECTION;
    default:
      return TargetType.INVALID;
  }
}
function getTargetType(value: Target) {
  return value[ReactiveFlags.SKIP] || !Object.isExtensible(value)
    ? TargetType.INVALID
    : targetTypeMap(toRawType(value));
}
```

`__v_skip`或对象是否可扩展，Date 等内置对象不动，判断是否合法

5. 通过 Proxy 劫持 target 对象，变成响应式。
   集合类型用 collectionHandlers
   普通对象和数组类型用 baseHandlers

6. 把原始对象 target 作为 key，响应式对象 Proxy 作为 value 存储到 Map 类型对象 proxyMap 中。这是对同一个原始对象多次执行 reactive 函数，却返回同一个响应式对象的原因。

```js
//packages\reactivity\src\baseHandlers.ts
//baseHandlers传入mutableHandlers
export const mutableHandlers: ProxyHandler<object> = /*#__PURE__*/ new MutableReactiveHandler();
//set,get,deleteProperty,has,ownKeys

//收集依赖
class BaseReactiveHandler implements ProxyHandler<Target> {
  get() {}
}
```

get 函数：

1. 对特殊的 key 做代理，比如`_v_raw`则直接返回原始对象 target
2. 若 target 是数组且 key 命中 arrayInstrumentations，则执行器内部对应函数。arrayInstrumentations 重写了数组中的 includes,indexOf,lastIndexOf
3. get 函数通过 Reflect.get 函数求值，并执行 track 函数收集依赖
4. 最后对计算出的值 res 进行判断，如果是数组或对象，则递归执行 reactive 把 res 变成响应式对象

Vue2 会递归执行 Object.defineProperty 定义子对象是响应式。
Vue3 只有在对象属性被访问的时候才会判断子属性类型，再决定要不要递归执行 reactive。这是一种延时定义响应式子对象的视线，在性能上有一定提升。

get 函数的最核心部分：执行 track 函数收集依赖

```js
//packages\reactivity\src\effect.ts
type KeyToDepMap = Map<any, Dep>
const targetMap = new WeakMap<object, KeyToDepMap>()
export function track(target: object,//原始数据
 type: TrackOpTypes, //依赖收集的类型
 key: unknown//访问属性
 ) {
  if (shouldTrack && activeEffect) {
    let depsMap = targetMap.get(target)
    if (!depsMap) {
      targetMap.set(target, (depsMap = new Map()))
    }
    let dep = depsMap.get(key)
    if (!dep) {
      depsMap.set(key, (dep = createDep()))
    }

    const eventInfo = __DEV__
      ? { effect: activeEffect, target, type, key }
      : undefined

    trackEffects(dep, eventInfo)
  }
}
```

收集依赖就是数据变化后执行副作用函数

每次执行 track 函数，就会把当前激活的副作用函数 activeEffect 作为依赖，然后将其收集到与 target 相关的 depsMap 所对应 key 下的依赖集合 dep 中

```js
//packages\reactivity\src\baseHandlers.ts
class MutableReactiveHandler extends BaseReactiveHandler {
  set() {}
}
```

set 函数：

1. 通过 Reflect.set 求值
2. 通过 trigger 函数派发通知，依据 key 是否存在于 target 上确定通知类型，即新增或修改

```js
//packages\reactivity\src\effect.ts
const targetMap = new WeakMap<object, KeyToDepMap>()
export function trigger(
  target: object,
  type: TriggerOpTypes,
  key?: unknown,
  newValue?: unknown,
  oldValue?: unknown,
  oldTarget?: Map<unknown, unknown> | Set<unknown>
) {}
export function triggerEffects(
  dep: Dep | ReactiveEffect[],
  debuggerEventExtraInfo?: DebuggerEventExtraInfo
) {}
function triggerEffect(
  effect: ReactiveEffect,
  debuggerEventExtraInfo?: DebuggerEventExtraInfo
) {}
```

trigger 函数

1. 从 targetMap 中获取 target 对应的依赖集合 depsMap
2. 创建运行的 effects 集合
3. 根据 key 从 depsMap 中找到对应的 effects 并添加到 effects 集合中
4. 遍历 effects，执行相关的副作用函数

- 判断 effect 的状态是否为 active（控制手段）,允许在非 active 状态且非低调执行的情况下，直接执行原始函数 fn 返回。
- 判断 effectStack 中是否包含 effect,若没有，则把 effect 压入栈内
- 针对嵌套的 effect 场景，不能简单的赋值 activeEffect=effect,函数的执行是一种入栈出栈的操作。
- effectStack 每次进入 reactiveEffect 函数时先让它入栈，然后让 activeEffect 指向这个 reactiveEffect 函数，并在 fn 执行完毕后让它出栈，再让 activeEffect 指向 effectStack 的最后一个元素，几最外层的 effect 对应的 reactiveEffect

```js
//packages\reactivity\src\effect.ts
function cleanupEffect(effect: ReactiveEffect) {
  const { deps } = effect;
  if (deps.length) {
    for (let i = 0; i < deps.length; i++) {
      deps[i].delete(effect);
    }
    deps.length = 0;
  }
}
```

在入栈前会执行 cleanupEffect 清空 reactiveEffect 函数对应的依赖。
在执行 track 函数是，除了收集当前激活的 effect 的依赖，还通过 activeEffect.deps.push(dep)把 dep 作为 activeEffect 的依赖。这样在 cleanup 时刻找到 effect 的 dep，然后把 effect 从 dep 中删除

## 响应式实现的优化

### 依赖收集的优化

相比之前执行 effect 函数都需要先清空依赖，在添加依赖的过程，现在的实现，会在每次执行 effect 包裹的函数之前标记依赖的状态。在此过程中，不会重复收集已经收集的依赖，在执行 effect 函数之后还会溢出已被收集但在新一轮中没有被收集的依赖。（减少了对依赖 dep 集合的操作）

### trackOpBit 的设计

trackOpBit 标记当前层的依赖已经被收集。看看递归深度是否超过 maxMarkerBits，超过就执行 cleanup,没有就打标记
标记依赖的 trackOpBit 在每次计算是采用左移运算符`trackOpBit=1<<++effectTrackDepth`,并且在赋值时使用了或运算

```js
deps[i].w |= trackOpBit;
dep.n |= trackOpBit;
```

# ref

```js
//packages\reactivity\src\ref.ts
function createRef(rawValue: unknown, shallow: boolean) {}

class RefImpl<T> {}
```

createRef 函数

1. 处理了嵌套 ref 的情况（如果传入的原始值也是 ref，直接返回原始值）
2. 返回 RefImpl 对象的实例：劫持实例的 value 属性的 getter 和 setter

- 当访问一个 ref 对象的 value 属性是，会触发 getter，执行 track 函数收集依赖，然后返回他的值
- 当修改一个 ref 对象的 value 值，会触发 setter，设置新值并且执行 trigger 函数派发通知
- 如果新值 newVal 是对象或者数组，那么会把它转换成一个 reactive 对象

## ref 的优化

```js
//packages\reactivity\src\ref.ts
//收集依赖
export function trackRefValue(ref: RefBase<any>) {}
//派发通知
export function triggerRefValue(ref: RefBase<any>, newVal?: any) {}
```

## unref

```js
//packages\reactivity\src\ref.ts

export function proxyRefs<T extends object>(
  objectWithRefs: T
): ShallowUnwrapRef<T> {
  return isReactive(objectWithRefs)
    ? objectWithRefs
    : new Proxy(objectWithRefs, shallowUnwrapHandlers)
}

const shallowUnwrapHandlers: ProxyHandler<any> = {
  get: (target, key, receiver) => unref(Reflect.get(target, key, receiver)),
  set: (target, key, value, receiver) => {
    const oldValue = target[key];
    if (isRef(oldValue) && !isRef(value)) {
      oldValue.value = value;
      return true;
    } else {
      return Reflect.set(target, key, value, receiver);
    }
  }
};
```

setup 函数的返回结果 setupResult 会做一层响应式处理
setupResult 经过响应式处理的结果会被赋值给组件实例中的 setupState 属性，因为初始化过程中创建渲染上下文处理。在 render 函数中访问\_ctx.xxx=instance.setupState.xxx.
setup 函数返回的 setupResult 一开始并不是一个响应式对象，所以通过 new proxy 做一层劫持。

```js
export function unref<T>(ref: MaybeRef<T>): T {
  return isRef(ref) ? ref.value : ref;
}
```

## readonly

只读对象

```js
// packages\reactivity\src\reactive.ts
export function readonly<T extends object>(
  target: T
): DeepReadonly<UnwrapNestedRefs<T>> {
  return createReactiveObject(
    target,
    true,
    readonlyHandlers,
    readonlyCollectionHandlers,
    readonlyMap
  )
}
```

readonly 和 reactive 主要区别

1. 执行 createReactiveObject 函数时的参数 isReadonly 不同
2. baseHandlers 和 collectionHandlers 的区别，对于普通对象和数组类型数据的 proxy 处理器对象，readonly 函数 baseHandlers 的值 readonlyHandlers

# 计算属性

```js
//packages\reactivity\src\computed.ts
export function computed<T>(
  getterOrOptions: ComputedGetter<T> | WritableComputedOptions<T>,
  debugOptions?: DebuggerOptions,
  isSSR = false
) {}

export class ComputedRefImpl<T> {}
//packages\reactivity\src\effect.ts
export class ReactiveEffect<T = any> {}
```

computed

1. 标准化参数，拿到计算属性对应的 getter 和 setter
   如果传递参数仅是 getter，一旦修改计算属性值，会执行对应的 setter，提醒该计算属性的值只是只读的
2. computed 返回 ComputedRefImpl 的实例，在构造器内部，通过 new ReactiveEffect 的方式创建副作用实例 effect

ComputedRefImpl 的内部，还对实例的 value 属性创建了 getter 和 setter.
当 Computed 对象的 value 属性被访问是会触发 getter,对计算属性本身进行依赖收集，然后判断是否`_dirty`，如果是，则执行 effect.run 函数，并重置`_dirty`的值。
当直接设置 computed 对象的 value 属性时会触发 setter，即执行 computed 函数内部定义的 setter

computed 内部两个重要变量`_dirty`计算属性值是否是脏的，判断是否需要重新计算
`_value`计算属性每次计算后的结果。
![image](images/vue3/computed.png)

核心：延迟计算和缓存
优势：只要它依赖的响应式数据不变化，就可以使用缓存的`_value`，而不用每次渲染数组时执行函数进行计算。（空间换时间的优化）

# 侦听器

```js
//packages\runtime-core\src\apiWatch.ts
export function watch<T = any, Immediate extends Readonly<boolean> = false>(
  source: T | WatchSource<T>,
  cb: any,
  options?: WatchOptions<Immediate>
): WatchStopHandle {
  return doWatch(source as any, cb, options)
}

function doWatch(
  source: WatchSource | WatchSource[] | WatchEffect | object,
  cb: WatchCallback | null,
  { immediate, deep, flush, onTrack, onTrigger }: WatchOptions = EMPTY_OBJ
): WatchStopHandle {
  //标准化source
  //创建job
  //创建scheduler
  //创建effect
  //返回销毁函数
}
```

source 标准化

1. source 是 ref 对象，创建访问 source.value 的 getter 函数
2. source 是 reactive 对象，创建访问 sourced 的 gttter 函数，并设置 deep 为 true
3. source 是 function,
4. source 是数组，生成的 getter 函数内部通过 source.map 函数映射出一个新数组，它会判断每个数组元素的类型，映射规则与前面的 source 的规则类似

侦听器用于观测响应式数据的变换，然后自动执行某些逻辑，执行机制有同步，渲染前，渲染后。
即使观测的响应式数据在同一个 tick 内多次修改，在非同步的情况下，回调函数只会执行一次
当执行方式是 post 时，内部的 effect runner 会被推入 vue 内部实现的异步队列，在下一个 tick 内执行

# 模板解析

baseCompile：解析 template 生成 AST（抽象语法树），AST 转换和生成代码
baseParse:创建解析上下文，解析子节点，创建 AST 根节点
parseChildren:解析模板并创建 AST 节点数组。自顶向下分析代码，生成 AST 节点数组 nodes。空白字符串处理，用于提高编译效率
parseComment：注释节点的解析
parseInterpolation:插值的解析
parseText:普通文本的解析
parseElement:元素节点的解析：解析开始标签，解析子节点，解析闭合标签

# AST 转换

transformExpression:转换插值和元素指令中的动态表达式，把简单的表达式对象转换成复合表达式对象

## 静态提升 hoistStatic

render 阶段，
好处：创建在 render 函数外部，不用每次在 render 阶段都执行一次 createVNode 创建 node 对象，直接用之前在内存中创建好的 vnode 即可

静态节点不依赖动态数据，一旦创建就不会改变，所以只有静态节点才能被提升到外部创建

静态提升过程的最终结果是修改了可以被静态提升的节点的 codegenNode，它在会生成代码阶段帮助我们生成静态提升的相关代码。

问题：render 外部创建，内部始终保持对静态节点的引用，导致即使组件被销毁，静态提升的节点所占用的内存也不会被释放。

# 生成代码

自顶向下的过程，依据前面转换的 AST 对象生成相应的代码
**生成代码**

1. 创建 codengen 上下文，负责维护整个代码生成的一些状态数据，如当前代码和索引，提供一些修改上下文数据的辅助函数。
2. 生成一些预设代码，比如引入辅助函数、生成静态提升相关代码等
3. 生成与渲染函数相关的代码，如生成渲染函数的名称和参数，生成资源声明的代码，生成创建 vnode 树的代码

**生成 vnode 树**
通过 genNode 针对不通节点执行不同端代码生成逻辑，可能存在递归执行 genCode 的情况，完成整个 vnode 树代码构建

**编译阶段**
给动态结点搭上相应 patchFlag，运行阶段就可收集所有的动态结点，形成一棵 Block Tree。在 patch 更新组件的结点，可遍历 Block，只比对这些动态节点，从而达到性能优化。

# provide/inject 依赖注入

实例中的 provides 对象

- 默认情况下，子组件 provides 对象直接指向父组件的 provides 对象。
- 当组件执行 provide(key,value)函数提供的数据时，会使用父级的 provides 对象作为原型，创建自己的 provides 对象，然后再给自己的 provides 对象添加新的属性值
- 当子组件执行 inject(key)注入数据的时候，会直接从它的父组件 provides 对象中查找，如果找到对应数据则返回，若找不到，则从原型开始找，通过原型链查找的方式，实现蹭蹭查找组件提供 key 对应的数据
- 问题：组件与当前组织的方式耦合，关联性很强，重构变得困难。

# 插槽

`renderSlot`

延时渲染，把父组件中变形的插槽内容保存到一个对象上，并且把具体渲染 DOM 的代码用函数的方式封装，然后在子组件渲染的时候，根据插槽名称在对象中找到对应的函数，在执行这些函数生成对应的 vnode

# teleport 组件会

创建 teleport 类型的 vnode 节点，在 patch 阶段会运行自己单独的逻辑执行 process 函数。如果配置了 to，指定目标元素，则会把 teleport 组件包裹的节点挂载到目标元素的内部

# keepAlive

缓存子树 vnode，让内部子组件在切换的时候，从缓存中直接拿到渲染好的 dom 并挂载，并且不会走一整天递归卸载和挂载组件的流程，从而优化性能。
