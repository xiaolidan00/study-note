# updateComponent

```js
const updateComponent = (n1, n2, optimized) => {
  const instance = (n2.component = n1.component);
  if (shouldUpdateComponent(n1, n2, optimized)) {
    if (instance.asyncDep && !instance.asyncResolved) {
      if (true) {
        pushWarningContext(n2);
      }
      updateComponentPreRender(instance, n2, optimized);
      if (true) {
        popWarningContext();
      }
      return;
    } else {
      instance.next = n2;
      instance.update();
    }
  } else {
    n2.el = n1.el;
    instance.vnode = n2;
  }
};
```

# setupRenderEffect

当 reactive 响应式变量改变时触发渲染副作用

```sh
queueJob (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:309)
effect2.scheduler (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:5394)
ReactiveEffect.trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:250)
endBatch (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:300)
Dep.notify (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:587)
Dep.trigger (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:561)
RefImpl.set value (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:1504)
set (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+reactivity@3.5.10\node_modules\@vue\reactivity\dist\reactivity.esm-bundler.js:1542)
_createElementVNode.onClick._cache.<computed>._cache.<computed> (d:\code\my-vue3-ts\src\components\HelloWorld.vue:13)
callWithErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:199)
callWithAsyncErrorHandling (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-core@3.5.10\node_modules\@vue\runtime-core\dist\runtime-core.esm-bundler.js:206)
invoker (d:\code\my-vue3-ts\node_modules\.pnpm\@vue+runtime-dom@3.5.10\node_modules\@vue\runtime-dom\dist\runtime-dom.esm-bundler.js:722)
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
    if (!instance.isMounted) {
      let vnodeHook;
      const { el, props } = initialVNode;
      const { bm, m, parent, root, type } = instance;
      const isAsyncWrapperVNode = isAsyncWrapper(initialVNode);
      toggleRecurse(instance, false);
      if (bm) {
        invokeArrayFns(bm);
      }
      if (!isAsyncWrapperVNode && (vnodeHook = props && props.onVnodeBeforeMount)) {
        invokeVNodeHook(vnodeHook, parent, initialVNode);
      }
      toggleRecurse(instance, true);
      if (el && hydrateNode) {
        const hydrateSubTree = () => {
          if (true) {
            startMeasure(instance, `render`);
          }
          instance.subTree = renderComponentRoot(instance);
          if (true) {
            endMeasure(instance, `render`);
          }
          if (true) {
            startMeasure(instance, `hydrate`);
          }
          hydrateNode(el, instance.subTree, instance, parentSuspense, null);
          if (true) {
            endMeasure(instance, `hydrate`);
          }
        };
        if (isAsyncWrapperVNode && type.__asyncHydrate) {
          type.__asyncHydrate(el, instance, hydrateSubTree);
        } else {
          hydrateSubTree();
        }
      } else {
        if (root.ce) {
          root.ce._injectChildStyle(type);
        }
        if (true) {
          startMeasure(instance, `render`);
        }
        const subTree = (instance.subTree = renderComponentRoot(instance));
        if (true) {
          endMeasure(instance, `render`);
        }
        if (true) {
          startMeasure(instance, `patch`);
        }
        patch(null, subTree, container, anchor, instance, parentSuspense, namespace);
        if (true) {
          endMeasure(instance, `patch`);
        }
        initialVNode.el = subTree.el;
      }
      if (m) {
        queuePostRenderEffect(m, parentSuspense);
      }
      if (!isAsyncWrapperVNode && (vnodeHook = props && props.onVnodeMounted)) {
        const scopedInitialVNode = initialVNode;
        queuePostRenderEffect(
          () => invokeVNodeHook(vnodeHook, parent, scopedInitialVNode),
          parentSuspense
        );
      }
      if (
        initialVNode.shapeFlag & 256 ||
        (parent && isAsyncWrapper(parent.vnode) && parent.vnode.shapeFlag & 256)
      ) {
        instance.a && queuePostRenderEffect(instance.a, parentSuspense);
      }
      instance.isMounted = true;
      if (true) {
        devtoolsComponentAdded(instance);
      }
      initialVNode = container = anchor = null;
    } else {
      let { next, bu, u, parent, vnode } = instance;
      {
        const nonHydratedAsyncRoot = locateNonHydratedAsyncRoot(instance);
        if (nonHydratedAsyncRoot) {
          if (next) {
            next.el = vnode.el;
            updateComponentPreRender(instance, next, optimized);
          }
          nonHydratedAsyncRoot.asyncDep.then(() => {
            if (!instance.isUnmounted) {
              componentUpdateFn();
            }
          });
          return;
        }
      }
      let originNext = next;
      let vnodeHook;
      if (true) {
        pushWarningContext(next || instance.vnode);
      }
      toggleRecurse(instance, false);
      if (next) {
        next.el = vnode.el;
        updateComponentPreRender(instance, next, optimized);
      } else {
        next = vnode;
      }
      if (bu) {
        invokeArrayFns(bu);
      }
      if ((vnodeHook = next.props && next.props.onVnodeBeforeUpdate)) {
        invokeVNodeHook(vnodeHook, parent, next, vnode);
      }
      toggleRecurse(instance, true);
      if (true) {
        startMeasure(instance, `render`);
      }
      const nextTree = renderComponentRoot(instance);
      if (true) {
        endMeasure(instance, `render`);
      }
      const prevTree = instance.subTree;
      instance.subTree = nextTree;
      if (true) {
        startMeasure(instance, `patch`);
      }
      patch(
        prevTree,
        nextTree,
        // parent may have changed if it's in a teleport
        hostParentNode(prevTree.el),
        // anchor may have changed if it's in a fragment
        getNextHostNode(prevTree),
        instance,
        parentSuspense,
        namespace
      );
      if (true) {
        endMeasure(instance, `patch`);
      }
      next.el = nextTree.el;
      if (originNext === null) {
        updateHOCHostEl(instance, nextTree.el);
      }
      if (u) {
        queuePostRenderEffect(u, parentSuspense);
      }
      if ((vnodeHook = next.props && next.props.onVnodeUpdated)) {
        queuePostRenderEffect(
          () => invokeVNodeHook(vnodeHook, parent, next, vnode),
          parentSuspense
        );
      }
      if (true) {
        devtoolsComponentUpdated(instance);
      }
      if (true) {
        popWarningContext();
      }
    }
  };
  instance.scope.on();
  const effect2 = (instance.effect = new ReactiveEffect(componentUpdateFn));
  instance.scope.off();
  const update = (instance.update = effect2.run.bind(effect2));
  const job = (instance.job = effect2.runIfDirty.bind(effect2));
  job.i = instance;
  job.id = instance.uid;
  effect2.scheduler = () => queueJob(job);
  toggleRecurse(instance, true);
  if (true) {
    effect2.onTrack = instance.rtc ? (e) => invokeArrayFns(instance.rtc, e) : void 0;
    effect2.onTrigger = instance.rtg ? (e) => invokeArrayFns(instance.rtg, e) : void 0;
  }
  update();
};
```

# updateComponentPreRender

```js
const updateComponentPreRender = (instance, nextVNode, optimized) => {
  nextVNode.component = instance;
  const prevProps = instance.vnode.props;
  instance.vnode = nextVNode;
  instance.next = null;
  updateProps(instance, nextVNode.props, prevProps, optimized);
  updateSlots(instance, nextVNode.children, optimized);
  pauseTracking();
  flushPreFlushCbs(instance);
  resetTracking();
};
```

# patchChildren

```js
const patchChildren = (
  n1,
  n2,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  namespace,
  slotScopeIds,
  optimized = false
) => {
  const c1 = n1 && n1.children;
  const prevShapeFlag = n1 ? n1.shapeFlag : 0;
  const c2 = n2.children;
  const { patchFlag, shapeFlag } = n2;
  if (patchFlag > 0) {
    if (patchFlag & 128) {
      patchKeyedChildren(
        c1,
        c2,
        container,
        anchor,
        parentComponent,
        parentSuspense,
        namespace,
        slotScopeIds,
        optimized
      );
      return;
    } else if (patchFlag & 256) {
      patchUnkeyedChildren(
        c1,
        c2,
        container,
        anchor,
        parentComponent,
        parentSuspense,
        namespace,
        slotScopeIds,
        optimized
      );
      return;
    }
  }
  if (shapeFlag & 8) {
    if (prevShapeFlag & 16) {
      unmountChildren(c1, parentComponent, parentSuspense);
    }
    if (c2 !== c1) {
      hostSetElementText(container, c2);
    }
  } else {
    if (prevShapeFlag & 16) {
      if (shapeFlag & 16) {
        patchKeyedChildren(
          c1,
          c2,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          namespace,
          slotScopeIds,
          optimized
        );
      } else {
        unmountChildren(c1, parentComponent, parentSuspense, true);
      }
    } else {
      if (prevShapeFlag & 8) {
        hostSetElementText(container, '');
      }
      if (shapeFlag & 16) {
        mountChildren(
          c2,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          namespace,
          slotScopeIds,
          optimized
        );
      }
    }
  }
};
```

# patchUnkeyedChildren

```js
const patchUnkeyedChildren = (
  c1,
  c2,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  namespace,
  slotScopeIds,
  optimized
) => {
  c1 = c1 || EMPTY_ARR;
  c2 = c2 || EMPTY_ARR;
  const oldLength = c1.length;
  const newLength = c2.length;
  const commonLength = Math.min(oldLength, newLength);
  let i;
  for (i = 0; i < commonLength; i++) {
    const nextChild = (c2[i] = optimized ? cloneIfMounted(c2[i]) : normalizeVNode(c2[i]));
    patch(
      c1[i],
      nextChild,
      container,
      null,
      parentComponent,
      parentSuspense,
      namespace,
      slotScopeIds,
      optimized
    );
  }
  if (oldLength > newLength) {
    unmountChildren(c1, parentComponent, parentSuspense, true, false, commonLength);
  } else {
    mountChildren(
      c2,
      container,
      anchor,
      parentComponent,
      parentSuspense,
      namespace,
      slotScopeIds,
      optimized,
      commonLength
    );
  }
};
```

# patchKeyedChildren

```js
const patchKeyedChildren = (
  c1,
  c2,
  container,
  parentAnchor,
  parentComponent,
  parentSuspense,
  namespace,
  slotScopeIds,
  optimized
) => {
  let i = 0;
  const l2 = c2.length;
  let e1 = c1.length - 1;
  let e2 = l2 - 1;
  while (i <= e1 && i <= e2) {
    const n1 = c1[i];
    const n2 = (c2[i] = optimized ? cloneIfMounted(c2[i]) : normalizeVNode(c2[i]));
    if (isSameVNodeType(n1, n2)) {
      patch(
        n1,
        n2,
        container,
        null,
        parentComponent,
        parentSuspense,
        namespace,
        slotScopeIds,
        optimized
      );
    } else {
      break;
    }
    i++;
  }
  while (i <= e1 && i <= e2) {
    const n1 = c1[e1];
    const n2 = (c2[e2] = optimized ? cloneIfMounted(c2[e2]) : normalizeVNode(c2[e2]));
    if (isSameVNodeType(n1, n2)) {
      patch(
        n1,
        n2,
        container,
        null,
        parentComponent,
        parentSuspense,
        namespace,
        slotScopeIds,
        optimized
      );
    } else {
      break;
    }
    e1--;
    e2--;
  }
  if (i > e1) {
    if (i <= e2) {
      const nextPos = e2 + 1;
      const anchor = nextPos < l2 ? c2[nextPos].el : parentAnchor;
      while (i <= e2) {
        patch(
          null,
          (c2[i] = optimized ? cloneIfMounted(c2[i]) : normalizeVNode(c2[i])),
          container,
          anchor,
          parentComponent,
          parentSuspense,
          namespace,
          slotScopeIds,
          optimized
        );
        i++;
      }
    }
  } else if (i > e2) {
    while (i <= e1) {
      unmount(c1[i], parentComponent, parentSuspense, true);
      i++;
    }
  } else {
    const s1 = i;
    const s2 = i;
    const keyToNewIndexMap = /* @__PURE__ */ new Map();
    for (i = s2; i <= e2; i++) {
      const nextChild = (c2[i] = optimized ? cloneIfMounted(c2[i]) : normalizeVNode(c2[i]));
      if (nextChild.key != null) {
        if (keyToNewIndexMap.has(nextChild.key)) {
          warn$1(
            `Duplicate keys found during update:`,
            JSON.stringify(nextChild.key),
            `Make sure keys are unique.`
          );
        }
        keyToNewIndexMap.set(nextChild.key, i);
      }
    }
    let j;
    let patched = 0;
    const toBePatched = e2 - s2 + 1;
    let moved = false;
    let maxNewIndexSoFar = 0;
    const newIndexToOldIndexMap = new Array(toBePatched);
    for (i = 0; i < toBePatched; i++) newIndexToOldIndexMap[i] = 0;
    for (i = s1; i <= e1; i++) {
      const prevChild = c1[i];
      if (patched >= toBePatched) {
        unmount(prevChild, parentComponent, parentSuspense, true);
        continue;
      }
      let newIndex;
      if (prevChild.key != null) {
        newIndex = keyToNewIndexMap.get(prevChild.key);
      } else {
        for (j = s2; j <= e2; j++) {
          if (newIndexToOldIndexMap[j - s2] === 0 && isSameVNodeType(prevChild, c2[j])) {
            newIndex = j;
            break;
          }
        }
      }
      if (newIndex === void 0) {
        unmount(prevChild, parentComponent, parentSuspense, true);
      } else {
        newIndexToOldIndexMap[newIndex - s2] = i + 1;
        if (newIndex >= maxNewIndexSoFar) {
          maxNewIndexSoFar = newIndex;
        } else {
          moved = true;
        }
        patch(
          prevChild,
          c2[newIndex],
          container,
          null,
          parentComponent,
          parentSuspense,
          namespace,
          slotScopeIds,
          optimized
        );
        patched++;
      }
    }
    const increasingNewIndexSequence = moved ? getSequence(newIndexToOldIndexMap) : EMPTY_ARR;
    j = increasingNewIndexSequence.length - 1;
    for (i = toBePatched - 1; i >= 0; i--) {
      const nextIndex = s2 + i;
      const nextChild = c2[nextIndex];
      const anchor = nextIndex + 1 < l2 ? c2[nextIndex + 1].el : parentAnchor;
      if (newIndexToOldIndexMap[i] === 0) {
        patch(
          null,
          nextChild,
          container,
          anchor,
          parentComponent,
          parentSuspense,
          namespace,
          slotScopeIds,
          optimized
        );
      } else if (moved) {
        if (j < 0 || i !== increasingNewIndexSequence[j]) {
          move(nextChild, container, anchor, 2);
        } else {
          j--;
        }
      }
    }
  }
};
```
