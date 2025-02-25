## SuspenseImpl

```ts
export const SuspenseImpl = {
  name: 'Suspense',
  // In order to make Suspense tree-shakable, we need to avoid importing it
  // directly in the renderer. The renderer checks for the __isSuspense flag
  // on a vnode's type and calls the `process` method, passing in renderer
  // internals.
  __isSuspense: true,
  process(
    n1: VNode | null,
    n2: VNode,
    container: RendererElement,
    anchor: RendererNode | null,
    parentComponent: ComponentInternalInstance | null,
    parentSuspense: SuspenseBoundary | null,
    namespace: ElementNamespace,
    slotScopeIds: string[] | null,
    optimized: boolean,
    // platform-specific impl passed from renderer
    rendererInternals: RendererInternals
  ): void {
    if (n1 == null) {
      mountSuspense(
        n2,
        container,
        anchor,
        parentComponent,
        parentSuspense,
        namespace,
        slotScopeIds,
        optimized,
        rendererInternals
      );
    } else {
      // #8678 if the current suspense needs to be patched and parentSuspense has
      // not been resolved. this means that both the current suspense and parentSuspense
      // need to be patched. because parentSuspense's pendingBranch includes the
      // current suspense, it will be processed twice:
      //  1. current patch
      //  2. mounting along with the pendingBranch of parentSuspense
      // it is necessary to skip the current patch to avoid multiple mounts
      // of inner components.
      if (parentSuspense && parentSuspense.deps > 0 && !n1.suspense!.isInFallback) {
        n2.suspense = n1.suspense!;
        n2.suspense.vnode = n2;
        n2.el = n1.el;
        return;
      }
      patchSuspense(
        n1,
        n2,
        container,
        anchor,
        parentComponent,
        namespace,
        slotScopeIds,
        optimized,
        rendererInternals
      );
    }
  },
  hydrate: hydrateSuspense as typeof hydrateSuspense,
  normalize: normalizeSuspenseChildren as typeof normalizeSuspenseChildren
};
```

## mountSuspense

```ts
function mountSuspense(
  vnode,
  container,
  anchor,
  parentComponent,
  parentSuspense,
  namespace,
  slotScopeIds,
  optimized,
  rendererInternals
) {
  const {
    p: patch,
    o: { createElement }
  } = rendererInternals;
  const hiddenContainer = createElement('div');
  const suspense = (vnode.suspense = createSuspenseBoundary(
    vnode,
    parentSuspense,
    parentComponent,
    container,
    hiddenContainer,
    anchor,
    namespace,
    slotScopeIds,
    optimized,
    rendererInternals
  ));
  patch(
    null,
    (suspense.pendingBranch = vnode.ssContent),
    hiddenContainer,
    null,
    parentComponent,
    suspense,
    namespace,
    slotScopeIds
  );
  if (suspense.deps > 0) {
    triggerEvent(vnode, 'onPending');
    triggerEvent(vnode, 'onFallback');
    patch(
      null,
      vnode.ssFallback,
      container,
      anchor,
      parentComponent,
      null,
      // fallback tree will not have suspense context
      namespace,
      slotScopeIds
    );
    setActiveBranch(suspense, vnode.ssFallback);
  } else {
    suspense.resolve(false, true);
  }
}
```

## patchSuspense

```ts
function patchSuspense(
  n1,
  n2,
  container,
  anchor,
  parentComponent,
  namespace,
  slotScopeIds,
  optimized,
  { p: patch, um: unmount, o: { createElement } }
) {
  const suspense = (n2.suspense = n1.suspense);
  suspense.vnode = n2;
  n2.el = n1.el;
  const newBranch = n2.ssContent;
  const newFallback = n2.ssFallback;
  const { activeBranch, pendingBranch, isInFallback, isHydrating } = suspense;
  if (pendingBranch) {
    suspense.pendingBranch = newBranch;
    if (isSameVNodeType(newBranch, pendingBranch)) {
      patch(
        pendingBranch,
        newBranch,
        suspense.hiddenContainer,
        null,
        parentComponent,
        suspense,
        namespace,
        slotScopeIds,
        optimized
      );
      if (suspense.deps <= 0) {
        suspense.resolve();
      } else if (isInFallback) {
        if (!isHydrating) {
          patch(
            activeBranch,
            newFallback,
            container,
            anchor,
            parentComponent,
            null,
            // fallback tree will not have suspense context
            namespace,
            slotScopeIds,
            optimized
          );
          setActiveBranch(suspense, newFallback);
        }
      }
    } else {
      suspense.pendingId = suspenseId++;
      if (isHydrating) {
        suspense.isHydrating = false;
        suspense.activeBranch = pendingBranch;
      } else {
        unmount(pendingBranch, parentComponent, suspense);
      }
      suspense.deps = 0;
      suspense.effects.length = 0;
      suspense.hiddenContainer = createElement('div');
      if (isInFallback) {
        patch(
          null,
          newBranch,
          suspense.hiddenContainer,
          null,
          parentComponent,
          suspense,
          namespace,
          slotScopeIds,
          optimized
        );
        if (suspense.deps <= 0) {
          suspense.resolve();
        } else {
          patch(
            activeBranch,
            newFallback,
            container,
            anchor,
            parentComponent,
            null,
            // fallback tree will not have suspense context
            namespace,
            slotScopeIds,
            optimized
          );
          setActiveBranch(suspense, newFallback);
        }
      } else if (activeBranch && isSameVNodeType(newBranch, activeBranch)) {
        patch(
          activeBranch,
          newBranch,
          container,
          anchor,
          parentComponent,
          suspense,
          namespace,
          slotScopeIds,
          optimized
        );
        suspense.resolve(true);
      } else {
        patch(
          null,
          newBranch,
          suspense.hiddenContainer,
          null,
          parentComponent,
          suspense,
          namespace,
          slotScopeIds,
          optimized
        );
        if (suspense.deps <= 0) {
          suspense.resolve();
        }
      }
    }
  } else {
    if (activeBranch && isSameVNodeType(newBranch, activeBranch)) {
      patch(
        activeBranch,
        newBranch,
        container,
        anchor,
        parentComponent,
        suspense,
        namespace,
        slotScopeIds,
        optimized
      );
      setActiveBranch(suspense, newBranch);
    } else {
      triggerEvent(n2, 'onPending');
      suspense.pendingBranch = newBranch;
      if (newBranch.shapeFlag & 512) {
        suspense.pendingId = newBranch.component.suspenseId;
      } else {
        suspense.pendingId = suspenseId++;
      }
      patch(
        null,
        newBranch,
        suspense.hiddenContainer,
        null,
        parentComponent,
        suspense,
        namespace,
        slotScopeIds,
        optimized
      );
      if (suspense.deps <= 0) {
        suspense.resolve();
      } else {
        const { timeout, pendingId } = suspense;
        if (timeout > 0) {
          setTimeout(() => {
            if (suspense.pendingId === pendingId) {
              suspense.fallback(newFallback);
            }
          }, timeout);
        } else if (timeout === 0) {
          suspense.fallback(newFallback);
        }
      }
    }
  }
}
```

## createSuspenseBoundary

```ts
function createSuspenseBoundary(
  vnode: VNode,
  parentSuspense: SuspenseBoundary | null,
  parentComponent: ComponentInternalInstance | null,
  container: RendererElement,
  hiddenContainer: RendererElement,
  anchor: RendererNode | null,
  namespace: ElementNamespace,
  slotScopeIds: string[] | null,
  optimized: boolean,
  rendererInternals: RendererInternals,
  isHydrating = false
): SuspenseBoundary {
  /* v8 ignore start */
  if (__DEV__ && !__TEST__ && !hasWarned) {
    hasWarned = true;
    // @ts-expect-error `console.info` cannot be null error
    // eslint-disable-next-line no-console
    console[console.info ? 'info' : 'log'](
      `<Suspense> is an experimental feature and its API will likely change.`
    );
  }
  /* v8 ignore stop */

  const {
    p: patch,
    m: move,
    um: unmount,
    n: next,
    o: { parentNode, remove }
  } = rendererInternals;

  // if set `suspensible: true`, set the current suspense as a dep of parent suspense
  let parentSuspenseId: number | undefined;
  const isSuspensible = isVNodeSuspensible(vnode);
  if (isSuspensible) {
    if (parentSuspense && parentSuspense.pendingBranch) {
      parentSuspenseId = parentSuspense.pendingId;
      parentSuspense.deps++;
    }
  }

  const timeout = vnode.props ? toNumber(vnode.props.timeout) : undefined;
  if (__DEV__) {
    assertNumber(timeout, `Suspense timeout`);
  }

  const initialAnchor = anchor;
  const suspense: SuspenseBoundary = {
    vnode,
    parent: parentSuspense,
    parentComponent,
    namespace,
    container,
    hiddenContainer,
    deps: 0,
    pendingId: suspenseId++,
    timeout: typeof timeout === 'number' ? timeout : -1,
    activeBranch: null,
    pendingBranch: null,
    isInFallback: !isHydrating,
    isHydrating,
    isUnmounted: false,
    effects: [],

    resolve(resume = false, sync = false) {
      if (__DEV__) {
        if (!resume && !suspense.pendingBranch) {
          throw new Error(`suspense.resolve() is called without a pending branch.`);
        }
        if (suspense.isUnmounted) {
          throw new Error(
            `suspense.resolve() is called on an already unmounted suspense boundary.`
          );
        }
      }
      const { vnode, activeBranch, pendingBranch, pendingId, effects, parentComponent, container } =
        suspense;

      // if there's a transition happening we need to wait it to finish.
      let delayEnter: boolean | null = false;
      if (suspense.isHydrating) {
        suspense.isHydrating = false;
      } else if (!resume) {
        delayEnter =
          activeBranch && pendingBranch!.transition && pendingBranch!.transition.mode === 'out-in';
        if (delayEnter) {
          activeBranch!.transition!.afterLeave = () => {
            if (pendingId === suspense.pendingId) {
              move(
                pendingBranch!,
                container,
                anchor === initialAnchor ? next(activeBranch!) : anchor,
                MoveType.ENTER
              );
              queuePostFlushCb(effects);
            }
          };
        }
        // unmount current active tree
        if (activeBranch) {
          // if the fallback tree was mounted, it may have been moved
          // as part of a parent suspense. get the latest anchor for insertion
          // #8105 if `delayEnter` is true, it means that the mounting of
          // `activeBranch` will be delayed. if the branch switches before
          // transition completes, both `activeBranch` and `pendingBranch` may
          // coexist in the `hiddenContainer`. This could result in
          // `next(activeBranch!)` obtaining an incorrect anchor
          // (got `pendingBranch.el`).
          // Therefore, after the mounting of activeBranch is completed,
          // it is necessary to get the latest anchor.
          if (parentNode(activeBranch.el!) === container) {
            anchor = next(activeBranch);
          }
          unmount(activeBranch, parentComponent, suspense, true);
        }
        if (!delayEnter) {
          // move content from off-dom container to actual container
          move(pendingBranch!, container, anchor, MoveType.ENTER);
        }
      }

      setActiveBranch(suspense, pendingBranch!);
      suspense.pendingBranch = null;
      suspense.isInFallback = false;

      // flush buffered effects
      // check if there is a pending parent suspense
      let parent = suspense.parent;
      let hasUnresolvedAncestor = false;
      while (parent) {
        if (parent.pendingBranch) {
          // found a pending parent suspense, merge buffered post jobs
          // into that parent
          parent.effects.push(...effects);
          hasUnresolvedAncestor = true;
          break;
        }
        parent = parent.parent;
      }
      // no pending parent suspense nor transition, flush all jobs
      if (!hasUnresolvedAncestor && !delayEnter) {
        queuePostFlushCb(effects);
      }
      suspense.effects = [];

      // resolve parent suspense if all async deps are resolved
      if (isSuspensible) {
        if (
          parentSuspense &&
          parentSuspense.pendingBranch &&
          parentSuspenseId === parentSuspense.pendingId
        ) {
          parentSuspense.deps--;
          if (parentSuspense.deps === 0 && !sync) {
            parentSuspense.resolve();
          }
        }
      }

      // invoke @resolve event
      triggerEvent(vnode, 'onResolve');
    },

    fallback(fallbackVNode) {
      if (!suspense.pendingBranch) {
        return;
      }

      const { vnode, activeBranch, parentComponent, container, namespace } = suspense;

      // invoke @fallback event
      triggerEvent(vnode, 'onFallback');

      const anchor = next(activeBranch!);
      const mountFallback = () => {
        if (!suspense.isInFallback) {
          return;
        }
        // mount the fallback tree
        patch(
          null,
          fallbackVNode,
          container,
          anchor,
          parentComponent,
          null, // fallback tree will not have suspense context
          namespace,
          slotScopeIds,
          optimized
        );
        setActiveBranch(suspense, fallbackVNode);
      };

      const delayEnter = fallbackVNode.transition && fallbackVNode.transition.mode === 'out-in';
      if (delayEnter) {
        activeBranch!.transition!.afterLeave = mountFallback;
      }
      suspense.isInFallback = true;

      // unmount current active branch
      unmount(
        activeBranch!,
        parentComponent,
        null, // no suspense so unmount hooks fire now
        true // shouldRemove
      );

      if (!delayEnter) {
        mountFallback();
      }
    },

    move(container, anchor, type) {
      suspense.activeBranch && move(suspense.activeBranch, container, anchor, type);
      suspense.container = container;
    },

    next() {
      return suspense.activeBranch && next(suspense.activeBranch);
    },

    registerDep(instance, setupRenderEffect, optimized) {
      const isInPendingSuspense = !!suspense.pendingBranch;
      if (isInPendingSuspense) {
        suspense.deps++;
      }
      const hydratedEl = instance.vnode.el;
      instance
        .asyncDep!.catch((err) => {
          handleError(err, instance, ErrorCodes.SETUP_FUNCTION);
        })
        .then((asyncSetupResult) => {
          // retry when the setup() promise resolves.
          // component may have been unmounted before resolve.
          if (
            instance.isUnmounted ||
            suspense.isUnmounted ||
            suspense.pendingId !== instance.suspenseId
          ) {
            return;
          }
          // retry from this component
          instance.asyncResolved = true;
          const { vnode } = instance;
          if (__DEV__) {
            pushWarningContext(vnode);
          }
          handleSetupResult(instance, asyncSetupResult, false);
          if (hydratedEl) {
            // vnode may have been replaced if an update happened before the
            // async dep is resolved.
            vnode.el = hydratedEl;
          }
          const placeholder = !hydratedEl && instance.subTree.el;
          setupRenderEffect(
            instance,
            vnode,
            // component may have been moved before resolve.
            // if this is not a hydration, instance.subTree will be the comment
            // placeholder.
            parentNode(hydratedEl || instance.subTree.el!)!,
            // anchor will not be used if this is hydration, so only need to
            // consider the comment placeholder case.
            hydratedEl ? null : next(instance.subTree),
            suspense,
            namespace,
            optimized
          );
          if (placeholder) {
            remove(placeholder);
          }
          updateHOCHostEl(instance, vnode.el);
          if (__DEV__) {
            popWarningContext();
          }
          // only decrease deps count if suspense is not already resolved
          if (isInPendingSuspense && --suspense.deps === 0) {
            suspense.resolve();
          }
        });
    },

    unmount(parentSuspense, doRemove) {
      suspense.isUnmounted = true;
      if (suspense.activeBranch) {
        unmount(suspense.activeBranch, parentComponent, parentSuspense, doRemove);
      }
      if (suspense.pendingBranch) {
        unmount(suspense.pendingBranch, parentComponent, parentSuspense, doRemove);
      }
    }
  };

  return suspense;
}
```

## setActiveBranch

```ts
function setActiveBranch(suspense: SuspenseBoundary, branch: VNode) {
  suspense.activeBranch = branch;
  const { vnode, parentComponent } = suspense;
  let el = branch.el;
  // if branch has no el after patch, it's a HOC wrapping async components
  // drill and locate the placeholder comment node
  while (!el && branch.component) {
    branch = branch.component.subTree;
    el = branch.el;
  }
  vnode.el = el;
  // in case suspense is the root node of a component,
  // recursively update the HOC el
  if (parentComponent && parentComponent.subTree === vnode) {
    parentComponent.vnode.el = el;
    updateHOCHostEl(parentComponent, el);
  }
}
```
