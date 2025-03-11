# mountWorkInProgressHook

```js
function mountWorkInProgressHook() {
  var hook = {
    memoizedState: null,
    baseState: null,
    baseQueue: null,
    queue: null,
    next: null
  };
  null === workInProgressHook
    ? (currentlyRenderingFiber$1.memoizedState = workInProgressHook = hook)
    : (workInProgressHook = workInProgressHook.next = hook);
  return workInProgressHook;
}
```

# updateWorkInProgressHook

```js
function updateWorkInProgressHook() {
  if (null === currentHook) {
    var nextCurrentHook = currentlyRenderingFiber$1.alternate;
    nextCurrentHook = null !== nextCurrentHook ? nextCurrentHook.memoizedState : null;
  } else nextCurrentHook = currentHook.next;
  var nextWorkInProgressHook =
    null === workInProgressHook ? currentlyRenderingFiber$1.memoizedState : workInProgressHook.next;
  if (null !== nextWorkInProgressHook)
    (workInProgressHook = nextWorkInProgressHook), (currentHook = nextCurrentHook);
  else {
    if (null === nextCurrentHook) {
      if (null === currentlyRenderingFiber$1.alternate)
        throw Error(
          'Update hook called on initial render. This is likely a bug in React. Please file an issue.'
        );
      throw Error('Rendered more hooks than during the previous render.');
    }
    currentHook = nextCurrentHook;
    nextCurrentHook = {
      memoizedState: currentHook.memoizedState,
      baseState: currentHook.baseState,
      baseQueue: currentHook.baseQueue,
      queue: currentHook.queue,
      next: null
    };
    null === workInProgressHook
      ? (currentlyRenderingFiber$1.memoizedState = workInProgressHook = nextCurrentHook)
      : (workInProgressHook = workInProgressHook.next = nextCurrentHook);
  }
  return workInProgressHook;
}
```

# mountStateImpl

```js
function mountStateImpl(initialState) {
  var hook = mountWorkInProgressHook();
  if ('function' === typeof initialState) {
    var initialStateInitializer = initialState;
    initialState = initialStateInitializer();
    if (shouldDoubleInvokeUserFnsInHooksDEV) {
      setIsStrictModeForDevtools(!0);
      try {
        initialStateInitializer();
      } finally {
        setIsStrictModeForDevtools(!1);
      }
    }
  }
  hook.memoizedState = hook.baseState = initialState;
  hook.queue = {
    pending: null,
    lanes: 0,
    dispatch: null,
    lastRenderedReducer: basicStateReducer,
    lastRenderedState: initialState
  };
  return hook;
}
```

# mountState

```js
function mountState(initialState) {
  initialState = mountStateImpl(initialState);
  var queue = initialState.queue,
    dispatch = dispatchSetState.bind(null, currentlyRenderingFiber$1, queue);
  queue.dispatch = dispatch;
  return [initialState.memoizedState, dispatch];
}
```

# dispatchSetState

```js
function dispatchSetState(fiber, queue, action, JSCompiler_OptimizeArgumentsArray_p1) {
  'function' === typeof JSCompiler_OptimizeArgumentsArray_p1 &&
    console.error(
      "State updates from the useState() and useReducer() Hooks don't support the second callback argument. To execute a side effect after rendering, declare it in the component body with useEffect()."
    );
  JSCompiler_OptimizeArgumentsArray_p1 = requestUpdateLane(fiber);
  dispatchSetStateInternal(fiber, queue, action, JSCompiler_OptimizeArgumentsArray_p1);
  markStateUpdateScheduled(fiber, JSCompiler_OptimizeArgumentsArray_p1);
}
```

# useState

```js
 useState: function (initialState) {
        currentHookNameInDev = "useState";
        mountHookTypesDev();
        var prevDispatcher = ReactSharedInternals.H;
        ReactSharedInternals.H = InvalidNestedHooksDispatcherOnMountInDEV;
        try {
          return mountState(initialState);
        } finally {
          ReactSharedInternals.H = prevDispatcher;
        }
      },
```

# jsxDEV

```js
exports.jsxDEV = function (type, config, maybeKey, isStaticChildren, source, self) {
  return jsxDEVImpl(type, config, maybeKey, isStaticChildren, source, self);
};
```

# jsxDEVImpl

```js
function jsxDEVImpl(type, config, maybeKey, isStaticChildren, source, self) {
  if (
    'string' === typeof type ||
    'function' === typeof type ||
    type === REACT_FRAGMENT_TYPE ||
    type === REACT_PROFILER_TYPE ||
    type === REACT_STRICT_MODE_TYPE ||
    type === REACT_SUSPENSE_TYPE ||
    type === REACT_SUSPENSE_LIST_TYPE ||
    type === REACT_OFFSCREEN_TYPE ||
    ('object' === typeof type &&
      null !== type &&
      (type.$$typeof === REACT_LAZY_TYPE ||
        type.$$typeof === REACT_MEMO_TYPE ||
        type.$$typeof === REACT_CONTEXT_TYPE ||
        type.$$typeof === REACT_CONSUMER_TYPE ||
        type.$$typeof === REACT_FORWARD_REF_TYPE ||
        type.$$typeof === REACT_CLIENT_REFERENCE$1 ||
        void 0 !== type.getModuleId))
  ) {
    var children = config.children;
    if (void 0 !== children)
      if (isStaticChildren)
        if (isArrayImpl(children)) {
          for (isStaticChildren = 0; isStaticChildren < children.length; isStaticChildren++)
            validateChildKeys(children[isStaticChildren], type);
          Object.freeze && Object.freeze(children);
        } else
          console.error(
            'React.jsx: Static children should always be an array. You are likely explicitly calling React.jsxs or React.jsxDEV. Use the Babel transform instead.'
          );
      else validateChildKeys(children, type);
  } else {
    children = '';
    if (
      void 0 === type ||
      ('object' === typeof type && null !== type && 0 === Object.keys(type).length)
    )
      children +=
        " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports.";
    null === type
      ? (isStaticChildren = 'null')
      : isArrayImpl(type)
      ? (isStaticChildren = 'array')
      : void 0 !== type && type.$$typeof === REACT_ELEMENT_TYPE
      ? ((isStaticChildren = '<' + (getComponentNameFromType(type.type) || 'Unknown') + ' />'),
        (children = ' Did you accidentally export a JSX literal instead of a component?'))
      : (isStaticChildren = typeof type);
    console.error(
      'React.jsx: type is invalid -- expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s',
      isStaticChildren,
      children
    );
  }
  if (hasOwnProperty.call(config, 'key')) {
    children = getComponentNameFromType(type);
    var keys = Object.keys(config).filter(function (k) {
      return 'key' !== k;
    });
    isStaticChildren =
      0 < keys.length ? '{key: someKey, ' + keys.join(': ..., ') + ': ...}' : '{key: someKey}';
    didWarnAboutKeySpread[children + isStaticChildren] ||
      ((keys = 0 < keys.length ? '{' + keys.join(': ..., ') + ': ...}' : '{}'),
      console.error(
        'A props object containing a "key" prop is being spread into JSX:\n  let props = %s;\n  <%s {...props} />\nReact keys must be passed directly to JSX without using spread:\n  let props = %s;\n  <%s key={someKey} {...props} />',
        isStaticChildren,
        children,
        keys,
        children
      ),
      (didWarnAboutKeySpread[children + isStaticChildren] = !0));
  }
  children = null;
  void 0 !== maybeKey && (checkKeyStringCoercion(maybeKey), (children = '' + maybeKey));
  hasValidKey(config) && (checkKeyStringCoercion(config.key), (children = '' + config.key));
  if ('key' in config) {
    maybeKey = {};
    for (var propName in config) 'key' !== propName && (maybeKey[propName] = config[propName]);
  } else maybeKey = config;
  children &&
    defineKeyPropWarningGetter(
      maybeKey,
      'function' === typeof type ? type.displayName || type.name || 'Unknown' : type
    );
  return ReactElement(type, children, self, source, getOwner(), maybeKey);
}
```

# validateChildKeys

```js
function validateChildKeys(node, parentType) {
  if ('object' === typeof node && node && node.$$typeof !== REACT_CLIENT_REFERENCE)
    if (isArrayImpl(node))
      for (var i = 0; i < node.length; i++) {
        var child = node[i];
        isValidElement(child) && validateExplicitKey(child, parentType);
      }
    else if (isValidElement(node)) node._store && (node._store.validated = 1);
    else if (
      (null === node || 'object' !== typeof node
        ? (i = null)
        : ((i = (MAYBE_ITERATOR_SYMBOL && node[MAYBE_ITERATOR_SYMBOL]) || node['@@iterator']),
          (i = 'function' === typeof i ? i : null)),
      'function' === typeof i && i !== node.entries && ((i = i.call(node)), i !== node))
    )
      for (; !(node = i.next()).done; )
        isValidElement(node.value) && validateExplicitKey(node.value, parentType);
}
```

# hasValidKey

```js
function hasValidKey(config) {
  if (hasOwnProperty.call(config, 'key')) {
    var getter = Object.getOwnPropertyDescriptor(config, 'key').get;
    if (getter && getter.isReactWarning) return !1;
  }
  return void 0 !== config.key;
}
```

# getOwner

```js
function getOwner() {
      var dispatcher = ReactSharedInternals.A;
      return null === dispatcher ? null : dispatcher.getOwner();
    }

     getOwner: function () {
        return current;
      }
```

# ReactElement

```js
function ReactElement(type, key, self, source, owner, props) {
  self = props.ref;
  type = {
    $$typeof: REACT_ELEMENT_TYPE,
    type: type,
    key: key,
    props: props,
    _owner: owner
  };
  null !== (void 0 !== self ? self : null)
    ? Object.defineProperty(type, 'ref', {
        enumerable: !1,
        get: elementRefGetterWithDeprecationWarning
      })
    : Object.defineProperty(type, 'ref', { enumerable: !1, value: null });
  type._store = {};
  Object.defineProperty(type._store, 'validated', {
    configurable: !1,
    enumerable: !1,
    writable: !0,
    value: 0
  });
  Object.defineProperty(type, '_debugInfo', {
    configurable: !1,
    enumerable: !1,
    writable: !0,
    value: null
  });
  Object.freeze && (Object.freeze(type.props), Object.freeze(type));
  return type;
}
```

# beginWork

```js
function beginWork(current, workInProgress, renderLanes) {
  if (workInProgress._debugNeedsRemount && null !== current) {
    renderLanes = createFiberFromTypeAndProps(
      workInProgress.type,
      workInProgress.key,
      workInProgress.pendingProps,
      workInProgress._debugOwner || null,
      workInProgress.mode,
      workInProgress.lanes
    );
    var returnFiber = workInProgress.return;
    if (null === returnFiber) throw Error('Cannot swap the root fiber.');
    current.alternate = null;
    workInProgress.alternate = null;
    renderLanes.index = workInProgress.index;
    renderLanes.sibling = workInProgress.sibling;
    renderLanes.return = workInProgress.return;
    renderLanes.ref = workInProgress.ref;
    renderLanes._debugInfo = workInProgress._debugInfo;
    if (workInProgress === returnFiber.child) returnFiber.child = renderLanes;
    else {
      var prevSibling = returnFiber.child;
      if (null === prevSibling) throw Error('Expected parent to have a child.');
      for (; prevSibling.sibling !== workInProgress; )
        if (((prevSibling = prevSibling.sibling), null === prevSibling))
          throw Error('Expected to find the previous sibling.');
      prevSibling.sibling = renderLanes;
    }
    workInProgress = returnFiber.deletions;
    null === workInProgress
      ? ((returnFiber.deletions = [current]), (returnFiber.flags |= 16))
      : workInProgress.push(current);
    renderLanes.flags |= 2;
    return renderLanes;
  }
  if (null !== current)
    if (
      current.memoizedProps !== workInProgress.pendingProps ||
      workInProgress.type !== current.type
    )
      didReceiveUpdate = !0;
    else {
      if (
        !checkScheduledUpdateOrContext(current, renderLanes) &&
        0 === (workInProgress.flags & 128)
      )
        return (
          (didReceiveUpdate = !1),
          attemptEarlyBailoutIfNoScheduledUpdate(current, workInProgress, renderLanes)
        );
      didReceiveUpdate = 0 !== (current.flags & 131072) ? !0 : !1;
    }
  else {
    didReceiveUpdate = !1;
    if ((returnFiber = isHydrating))
      warnIfNotHydrating(), (returnFiber = 0 !== (workInProgress.flags & 1048576));
    returnFiber &&
      ((returnFiber = workInProgress.index),
      warnIfNotHydrating(),
      pushTreeId(workInProgress, treeForkCount, returnFiber));
  }
  workInProgress.lanes = 0;
  switch (workInProgress.tag) {
    case 16:
      a: if (
        ((returnFiber = workInProgress.pendingProps),
        (current = callLazyInitInDEV(workInProgress.elementType)),
        (workInProgress.type = current),
        'function' === typeof current)
      )
        shouldConstruct(current)
          ? ((returnFiber = resolveClassComponentProps(current, returnFiber)),
            (workInProgress.tag = 1),
            (workInProgress.type = current = resolveFunctionForHotReloading(current)),
            (workInProgress = updateClassComponent(
              null,
              workInProgress,
              current,
              returnFiber,
              renderLanes
            )))
          : ((workInProgress.tag = 0),
            validateFunctionComponentInDev(workInProgress, current),
            (workInProgress.type = current = resolveFunctionForHotReloading(current)),
            (workInProgress = updateFunctionComponent(
              null,
              workInProgress,
              current,
              returnFiber,
              renderLanes
            )));
      else {
        if (void 0 !== current && null !== current)
          if (((prevSibling = current.$$typeof), prevSibling === REACT_FORWARD_REF_TYPE)) {
            workInProgress.tag = 11;
            workInProgress.type = current = resolveForwardRefForHotReloading(current);
            workInProgress = updateForwardRef(
              null,
              workInProgress,
              current,
              returnFiber,
              renderLanes
            );
            break a;
          } else if (prevSibling === REACT_MEMO_TYPE) {
            workInProgress.tag = 14;
            workInProgress = updateMemoComponent(
              null,
              workInProgress,
              current,
              returnFiber,
              renderLanes
            );
            break a;
          }
        workInProgress = '';
        null !== current &&
          'object' === typeof current &&
          current.$$typeof === REACT_LAZY_TYPE &&
          (workInProgress = ' Did you wrap a component in React.lazy() more than once?');
        current = getComponentNameFromType(current) || current;
        throw Error(
          'Element type is invalid. Received a promise that resolves to: ' +
            current +
            '. Lazy element type must resolve to a class or function.' +
            workInProgress
        );
      }
      return workInProgress;
    case 0:
      return updateFunctionComponent(
        current,
        workInProgress,
        workInProgress.type,
        workInProgress.pendingProps,
        renderLanes
      );
    case 1:
      return (
        (returnFiber = workInProgress.type),
        (prevSibling = resolveClassComponentProps(returnFiber, workInProgress.pendingProps)),
        updateClassComponent(current, workInProgress, returnFiber, prevSibling, renderLanes)
      );
    case 3:
      a: {
        pushHostContainer(workInProgress, workInProgress.stateNode.containerInfo);
        if (null === current) throw Error('Should have a current fiber. This is a bug in React.');
        var nextProps = workInProgress.pendingProps;
        prevSibling = workInProgress.memoizedState;
        returnFiber = prevSibling.element;
        cloneUpdateQueue(current, workInProgress);
        processUpdateQueue(workInProgress, nextProps, null, renderLanes);
        var nextState = workInProgress.memoizedState;
        nextProps = nextState.cache;
        pushProvider(workInProgress, CacheContext, nextProps);
        nextProps !== prevSibling.cache &&
          propagateContextChanges(workInProgress, [CacheContext], renderLanes, !0);
        suspendIfUpdateReadFromEntangledAsyncAction();
        nextProps = nextState.element;
        if (prevSibling.isDehydrated)
          if (
            ((prevSibling = {
              element: nextProps,
              isDehydrated: !1,
              cache: nextState.cache
            }),
            (workInProgress.updateQueue.baseState = prevSibling),
            (workInProgress.memoizedState = prevSibling),
            workInProgress.flags & 256)
          ) {
            workInProgress = mountHostRootWithoutHydrating(
              current,
              workInProgress,
              nextProps,
              renderLanes
            );
            break a;
          } else if (nextProps !== returnFiber) {
            returnFiber = createCapturedValueAtFiber(
              Error(
                'This root received an early update, before anything was able hydrate. Switched the entire root to client rendering.'
              ),
              workInProgress
            );
            queueHydrationError(returnFiber);
            workInProgress = mountHostRootWithoutHydrating(
              current,
              workInProgress,
              nextProps,
              renderLanes
            );
            break a;
          } else
            for (
              nextHydratableInstance = getNextHydratable(
                workInProgress.stateNode.containerInfo.firstChild
              ),
                hydrationParentFiber = workInProgress,
                isHydrating = !0,
                hydrationErrors = null,
                didSuspendOrErrorDEV = !1,
                hydrationDiffRootDEV = null,
                rootOrSingletonContext = !0,
                current = mountChildFibers(workInProgress, null, nextProps, renderLanes),
                workInProgress.child = current;
              current;

            )
              (current.flags = (current.flags & -3) | 4096), (current = current.sibling);
        else {
          resetHydrationState();
          if (nextProps === returnFiber) {
            workInProgress = bailoutOnAlreadyFinishedWork(current, workInProgress, renderLanes);
            break a;
          }
          reconcileChildren(current, workInProgress, nextProps, renderLanes);
        }
        workInProgress = workInProgress.child;
      }
      return workInProgress;
    case 26:
      return (
        markRef(current, workInProgress),
        null === current
          ? (current = getResource(workInProgress.type, null, workInProgress.pendingProps, null))
            ? (workInProgress.memoizedState = current)
            : isHydrating ||
              ((current = workInProgress.type),
              (renderLanes = workInProgress.pendingProps),
              (returnFiber = requiredContext(rootInstanceStackCursor.current)),
              (returnFiber = getOwnerDocumentFromRootContainer(returnFiber).createElement(current)),
              (returnFiber[internalInstanceKey] = workInProgress),
              (returnFiber[internalPropsKey] = renderLanes),
              setInitialProperties(returnFiber, current, renderLanes),
              markNodeAsHoistable(returnFiber),
              (workInProgress.stateNode = returnFiber))
          : (workInProgress.memoizedState = getResource(
              workInProgress.type,
              current.memoizedProps,
              workInProgress.pendingProps,
              current.memoizedState
            )),
        null
      );
    case 27:
      return (
        pushHostContext(workInProgress),
        null === current &&
          isHydrating &&
          ((prevSibling = requiredContext(rootInstanceStackCursor.current)),
          (returnFiber = getHostContext()),
          (prevSibling = workInProgress.stateNode =
            resolveSingletonInstance(
              workInProgress.type,
              workInProgress.pendingProps,
              prevSibling,
              returnFiber,
              !1
            )),
          didSuspendOrErrorDEV ||
            ((returnFiber = diffHydratedProperties(
              prevSibling,
              workInProgress.type,
              workInProgress.pendingProps,
              returnFiber
            )),
            null !== returnFiber &&
              (buildHydrationDiffNode(workInProgress, 0).serverProps = returnFiber)),
          (hydrationParentFiber = workInProgress),
          (rootOrSingletonContext = !0),
          (nextHydratableInstance = getNextHydratable(prevSibling.firstChild))),
        (returnFiber = workInProgress.pendingProps.children),
        null !== current || isHydrating
          ? reconcileChildren(current, workInProgress, returnFiber, renderLanes)
          : (workInProgress.child = reconcileChildFibers(
              workInProgress,
              null,
              returnFiber,
              renderLanes
            )),
        markRef(current, workInProgress),
        workInProgress.child
      );
    case 5:
      return (
        null === current &&
          isHydrating &&
          ((nextProps = getHostContext()),
          (returnFiber = validateDOMNesting(workInProgress.type, nextProps.ancestorInfo)),
          (prevSibling = nextHydratableInstance),
          (nextState = !prevSibling) ||
            ((nextState = canHydrateInstance(
              prevSibling,
              workInProgress.type,
              workInProgress.pendingProps,
              rootOrSingletonContext
            )),
            null !== nextState
              ? ((workInProgress.stateNode = nextState),
                didSuspendOrErrorDEV ||
                  ((nextProps = diffHydratedProperties(
                    nextState,
                    workInProgress.type,
                    workInProgress.pendingProps,
                    nextProps
                  )),
                  null !== nextProps &&
                    (buildHydrationDiffNode(workInProgress, 0).serverProps = nextProps)),
                (hydrationParentFiber = workInProgress),
                (nextHydratableInstance = getNextHydratable(nextState.firstChild)),
                (rootOrSingletonContext = !1),
                (nextProps = !0))
              : (nextProps = !1),
            (nextState = !nextProps)),
          nextState &&
            (returnFiber && warnNonHydratedInstance(workInProgress, prevSibling),
            throwOnHydrationMismatch(workInProgress))),
        pushHostContext(workInProgress),
        (prevSibling = workInProgress.type),
        (nextProps = workInProgress.pendingProps),
        (nextState = null !== current ? current.memoizedProps : null),
        (returnFiber = nextProps.children),
        shouldSetTextContent(prevSibling, nextProps)
          ? (returnFiber = null)
          : null !== nextState &&
            shouldSetTextContent(prevSibling, nextState) &&
            (workInProgress.flags |= 32),
        null !== workInProgress.memoizedState &&
          ((prevSibling = renderWithHooks(
            current,
            workInProgress,
            TransitionAwareHostComponent,
            null,
            null,
            renderLanes
          )),
          (HostTransitionContext._currentValue = prevSibling)),
        markRef(current, workInProgress),
        reconcileChildren(current, workInProgress, returnFiber, renderLanes),
        workInProgress.child
      );
    case 6:
      return (
        null === current &&
          isHydrating &&
          ((current = workInProgress.pendingProps),
          (renderLanes = getHostContext().ancestorInfo.current),
          (current = null != renderLanes ? validateTextNesting(current, renderLanes.tag) : !0),
          (renderLanes = nextHydratableInstance),
          (returnFiber = !renderLanes) ||
            ((returnFiber = canHydrateTextInstance(
              renderLanes,
              workInProgress.pendingProps,
              rootOrSingletonContext
            )),
            null !== returnFiber
              ? ((workInProgress.stateNode = returnFiber),
                (hydrationParentFiber = workInProgress),
                (nextHydratableInstance = null),
                (returnFiber = !0))
              : (returnFiber = !1),
            (returnFiber = !returnFiber)),
          returnFiber &&
            (current && warnNonHydratedInstance(workInProgress, renderLanes),
            throwOnHydrationMismatch(workInProgress))),
        null
      );
    case 13:
      return updateSuspenseComponent(current, workInProgress, renderLanes);
    case 4:
      return (
        pushHostContainer(workInProgress, workInProgress.stateNode.containerInfo),
        (returnFiber = workInProgress.pendingProps),
        null === current
          ? (workInProgress.child = reconcileChildFibers(
              workInProgress,
              null,
              returnFiber,
              renderLanes
            ))
          : reconcileChildren(current, workInProgress, returnFiber, renderLanes),
        workInProgress.child
      );
    case 11:
      return updateForwardRef(
        current,
        workInProgress,
        workInProgress.type,
        workInProgress.pendingProps,
        renderLanes
      );
    case 7:
      return (
        reconcileChildren(current, workInProgress, workInProgress.pendingProps, renderLanes),
        workInProgress.child
      );
    case 8:
      return (
        reconcileChildren(
          current,
          workInProgress,
          workInProgress.pendingProps.children,
          renderLanes
        ),
        workInProgress.child
      );
    case 12:
      return (
        (workInProgress.flags |= 4),
        (workInProgress.flags |= 2048),
        (returnFiber = workInProgress.stateNode),
        (returnFiber.effectDuration = -0),
        (returnFiber.passiveEffectDuration = -0),
        reconcileChildren(
          current,
          workInProgress,
          workInProgress.pendingProps.children,
          renderLanes
        ),
        workInProgress.child
      );
    case 10:
      return (
        (returnFiber = workInProgress.type),
        (prevSibling = workInProgress.pendingProps),
        (nextProps = prevSibling.value),
        'value' in prevSibling ||
          hasWarnedAboutUsingNoValuePropOnContextProvider ||
          ((hasWarnedAboutUsingNoValuePropOnContextProvider = !0),
          console.error(
            'The `value` prop is required for the `<Context.Provider>`. Did you misspell it or forget to pass it?'
          )),
        pushProvider(workInProgress, returnFiber, nextProps),
        reconcileChildren(current, workInProgress, prevSibling.children, renderLanes),
        workInProgress.child
      );
    case 9:
      return (
        (prevSibling = workInProgress.type._context),
        (returnFiber = workInProgress.pendingProps.children),
        'function' !== typeof returnFiber &&
          console.error(
            "A context consumer was rendered with multiple children, or a child that isn't a function. A context consumer expects a single child that is a function. If you did pass a function, make sure there is no trailing or leading whitespace around it."
          ),
        prepareToReadContext(workInProgress),
        (prevSibling = readContext(prevSibling)),
        markComponentRenderStarted(workInProgress),
        (returnFiber = callComponentInDEV(returnFiber, prevSibling, void 0)),
        markComponentRenderStopped(),
        (workInProgress.flags |= 1),
        reconcileChildren(current, workInProgress, returnFiber, renderLanes),
        workInProgress.child
      );
    case 14:
      return updateMemoComponent(
        current,
        workInProgress,
        workInProgress.type,
        workInProgress.pendingProps,
        renderLanes
      );
    case 15:
      return updateSimpleMemoComponent(
        current,
        workInProgress,
        workInProgress.type,
        workInProgress.pendingProps,
        renderLanes
      );
    case 19:
      return updateSuspenseListComponent(current, workInProgress, renderLanes);
    case 22:
      return updateOffscreenComponent(current, workInProgress, renderLanes);
    case 24:
      return (
        prepareToReadContext(workInProgress),
        (returnFiber = readContext(CacheContext)),
        null === current
          ? ((prevSibling = peekCacheFromPool()),
            null === prevSibling &&
              ((prevSibling = workInProgressRoot),
              (nextProps = createCache()),
              (prevSibling.pooledCache = nextProps),
              retainCache(nextProps),
              null !== nextProps && (prevSibling.pooledCacheLanes |= renderLanes),
              (prevSibling = nextProps)),
            (workInProgress.memoizedState = {
              parent: returnFiber,
              cache: prevSibling
            }),
            initializeUpdateQueue(workInProgress),
            pushProvider(workInProgress, CacheContext, prevSibling))
          : (0 !== (current.lanes & renderLanes) &&
              (cloneUpdateQueue(current, workInProgress),
              processUpdateQueue(workInProgress, null, null, renderLanes),
              suspendIfUpdateReadFromEntangledAsyncAction()),
            (prevSibling = current.memoizedState),
            (nextProps = workInProgress.memoizedState),
            prevSibling.parent !== returnFiber
              ? ((prevSibling = {
                  parent: returnFiber,
                  cache: returnFiber
                }),
                (workInProgress.memoizedState = prevSibling),
                0 === workInProgress.lanes &&
                  (workInProgress.memoizedState = workInProgress.updateQueue.baseState =
                    prevSibling),
                pushProvider(workInProgress, CacheContext, returnFiber))
              : ((returnFiber = nextProps.cache),
                pushProvider(workInProgress, CacheContext, returnFiber),
                returnFiber !== prevSibling.cache &&
                  propagateContextChanges(workInProgress, [CacheContext], renderLanes, !0))),
        reconcileChildren(
          current,
          workInProgress,
          workInProgress.pendingProps.children,
          renderLanes
        ),
        workInProgress.child
      );
    case 29:
      throw workInProgress.pendingProps;
  }
  throw Error(
    'Unknown unit of work tag (' +
      workInProgress.tag +
      '). This error is likely caused by a bug in React. Please file an issue.'
  );
}
```

# updateFunctionComponent

```js
function updateFunctionComponent(current, workInProgress, Component, nextProps, renderLanes) {
  if (Component.prototype && 'function' === typeof Component.prototype.render) {
    var componentName = getComponentNameFromType(Component) || 'Unknown';
    didWarnAboutBadClass[componentName] ||
      (console.error(
        "The <%s /> component appears to have a render method, but doesn't extend React.Component. This is likely to cause errors. Change %s to extend React.Component instead.",
        componentName,
        componentName
      ),
      (didWarnAboutBadClass[componentName] = !0));
  }
  workInProgress.mode & StrictLegacyMode &&
    ReactStrictModeWarnings.recordLegacyContextWarning(workInProgress, null);
  null === current &&
    (validateFunctionComponentInDev(workInProgress, workInProgress.type),
    Component.contextTypes &&
      ((componentName = getComponentNameFromType(Component) || 'Unknown'),
      didWarnAboutContextTypes[componentName] ||
        ((didWarnAboutContextTypes[componentName] = !0),
        console.error(
          '%s uses the legacy contextTypes API which was removed in React 19. Use React.createContext() with React.useContext() instead. (https://react.dev/link/legacy-context)',
          componentName
        ))));
  prepareToReadContext(workInProgress);
  markComponentRenderStarted(workInProgress);
  Component = renderWithHooks(current, workInProgress, Component, nextProps, void 0, renderLanes);
  nextProps = checkDidRenderIdHook();
  markComponentRenderStopped();
  if (null !== current && !didReceiveUpdate)
    return (
      bailoutHooks(current, workInProgress, renderLanes),
      bailoutOnAlreadyFinishedWork(current, workInProgress, renderLanes)
    );
  isHydrating && nextProps && pushMaterializedTreeId(workInProgress);
  workInProgress.flags |= 1;
  reconcileChildren(current, workInProgress, Component, renderLanes);
  return workInProgress.child;
}
```

# renderWithHooks

```js
function renderWithHooks(current, workInProgress, Component, props, secondArg, nextRenderLanes) {
  renderLanes = nextRenderLanes;
  currentlyRenderingFiber$1 = workInProgress;
  hookTypesDev = null !== current ? current._debugHookTypes : null;
  hookTypesUpdateIndexDev = -1;
  ignorePreviousDependencies = null !== current && current.type !== workInProgress.type;
  if (
    '[object AsyncFunction]' === Object.prototype.toString.call(Component) ||
    '[object AsyncGeneratorFunction]' === Object.prototype.toString.call(Component)
  )
    (nextRenderLanes = getComponentNameFromFiber(currentlyRenderingFiber$1)),
      didWarnAboutAsyncClientComponent.has(nextRenderLanes) ||
        (didWarnAboutAsyncClientComponent.add(nextRenderLanes),
        console.error(
          "async/await is not yet supported in Client Components, only Server Components. This error is often caused by accidentally adding `'use client'` to a module that was originally written for the server."
        ));
  workInProgress.memoizedState = null;
  workInProgress.updateQueue = null;
  workInProgress.lanes = 0;
  ReactSharedInternals.H =
    null !== current && null !== current.memoizedState
      ? HooksDispatcherOnUpdateInDEV
      : null !== hookTypesDev
      ? HooksDispatcherOnMountWithHookTypesInDEV
      : HooksDispatcherOnMountInDEV;
  shouldDoubleInvokeUserFnsInHooksDEV = nextRenderLanes =
    (workInProgress.mode & StrictLegacyMode) !== NoMode;
  var children = callComponentInDEV(Component, props, secondArg);
  shouldDoubleInvokeUserFnsInHooksDEV = !1;
  didScheduleRenderPhaseUpdateDuringThisPass &&
    (children = renderWithHooksAgain(workInProgress, Component, props, secondArg));
  if (nextRenderLanes) {
    setIsStrictModeForDevtools(!0);
    try {
      children = renderWithHooksAgain(workInProgress, Component, props, secondArg);
    } finally {
      setIsStrictModeForDevtools(!1);
    }
  }
  finishRenderingHooks(current, workInProgress);
  return children;
}
```

# renderWithHooksAgain

```js
function renderWithHooksAgain(workInProgress, Component, props, secondArg) {
  currentlyRenderingFiber$1 = workInProgress;
  var numberOfReRenders = 0;
  do {
    didScheduleRenderPhaseUpdateDuringThisPass && (thenableState = null);
    thenableIndexCounter = 0;
    didScheduleRenderPhaseUpdateDuringThisPass = !1;
    if (numberOfReRenders >= RE_RENDER_LIMIT)
      throw Error(
        'Too many re-renders. React limits the number of renders to prevent an infinite loop.'
      );
    numberOfReRenders += 1;
    ignorePreviousDependencies = !1;
    workInProgressHook = currentHook = null;
    if (null != workInProgress.updateQueue) {
      var children = workInProgress.updateQueue;
      children.lastEffect = null;
      children.events = null;
      children.stores = null;
      null != children.memoCache && (children.memoCache.index = 0);
    }
    hookTypesUpdateIndexDev = -1;
    ReactSharedInternals.H = HooksDispatcherOnRerenderInDEV;
    children = callComponentInDEV(Component, props, secondArg);
  } while (didScheduleRenderPhaseUpdateDuringThisPass);
  return children;
}
```

# finishRenderingHooks

```js
function finishRenderingHooks(current, workInProgress) {
  workInProgress._debugHookTypes = hookTypesDev;
  null === workInProgress.dependencies
    ? null !== thenableState &&
      (workInProgress.dependencies = {
        lanes: 0,
        firstContext: null,
        _debugThenableState: thenableState
      })
    : (workInProgress.dependencies._debugThenableState = thenableState);
  ReactSharedInternals.H = ContextOnlyDispatcher;
  var didRenderTooFewHooks = null !== currentHook && null !== currentHook.next;
  renderLanes = 0;
  hookTypesDev =
    currentHookNameInDev =
    workInProgressHook =
    currentHook =
    currentlyRenderingFiber$1 =
      null;
  hookTypesUpdateIndexDev = -1;
  null !== current &&
    (current.flags & 31457280) !== (workInProgress.flags & 31457280) &&
    console.error(
      'Internal React error: Expected static flag was missing. Please notify the React team.'
    );
  didScheduleRenderPhaseUpdate = !1;
  thenableIndexCounter = 0;
  thenableState = null;
  if (didRenderTooFewHooks)
    throw Error(
      'Rendered fewer hooks than expected. This may be caused by an accidental early return statement.'
    );
  null === current ||
    didReceiveUpdate ||
    ((current = current.dependencies),
    null !== current && checkIfContextChanged(current) && (didReceiveUpdate = !0));
  needsToResetSuspendedThenableDEV
    ? ((needsToResetSuspendedThenableDEV = !1), (current = !0))
    : (current = !1);
  current &&
    ((workInProgress = getComponentNameFromFiber(workInProgress) || 'Unknown'),
    didWarnAboutUseWrappedInTryCatch.has(workInProgress) ||
      didWarnAboutAsyncClientComponent.has(workInProgress) ||
      (didWarnAboutUseWrappedInTryCatch.add(workInProgress),
      console.error(
        '`use` was called from inside a try/catch block. This is not allowed and can lead to unexpected behavior. To handle errors triggered by `use`, wrap your component in a error boundary.'
      )));
}
```

# reconcileChildren

```js
function reconcileChildren(current, workInProgress, nextChildren, renderLanes) {
  workInProgress.child =
    null === current
      ? mountChildFibers(workInProgress, null, nextChildren, renderLanes)
      : reconcileChildFibers(workInProgress, current.child, nextChildren, renderLanes);
}
```

# reconcileChildFibersImpl

```js
function reconcileChildFibersImpl(returnFiber, currentFirstChild, newChild, lanes) {
  'object' === typeof newChild &&
    null !== newChild &&
    newChild.type === REACT_FRAGMENT_TYPE &&
    null === newChild.key &&
    (validateFragmentProps(newChild, null, returnFiber), (newChild = newChild.props.children));
  if ('object' === typeof newChild && null !== newChild) {
    switch (newChild.$$typeof) {
      case REACT_ELEMENT_TYPE:
        var prevDebugInfo = pushDebugInfo(newChild._debugInfo);
        a: {
          for (var key = newChild.key; null !== currentFirstChild; ) {
            if (currentFirstChild.key === key) {
              key = newChild.type;
              if (key === REACT_FRAGMENT_TYPE) {
                if (7 === currentFirstChild.tag) {
                  deleteRemainingChildren(returnFiber, currentFirstChild.sibling);
                  lanes = useFiber(currentFirstChild, newChild.props.children);
                  lanes.return = returnFiber;
                  lanes._debugOwner = newChild._owner;
                  lanes._debugInfo = currentDebugInfo;
                  validateFragmentProps(newChild, lanes, returnFiber);
                  returnFiber = lanes;
                  break a;
                }
              } else if (
                currentFirstChild.elementType === key ||
                isCompatibleFamilyForHotReloading(currentFirstChild, newChild) ||
                ('object' === typeof key &&
                  null !== key &&
                  key.$$typeof === REACT_LAZY_TYPE &&
                  callLazyInitInDEV(key) === currentFirstChild.type)
              ) {
                deleteRemainingChildren(returnFiber, currentFirstChild.sibling);
                lanes = useFiber(currentFirstChild, newChild.props);
                coerceRef(lanes, newChild);
                lanes.return = returnFiber;
                lanes._debugOwner = newChild._owner;
                lanes._debugInfo = currentDebugInfo;
                returnFiber = lanes;
                break a;
              }
              deleteRemainingChildren(returnFiber, currentFirstChild);
              break;
            } else deleteChild(returnFiber, currentFirstChild);
            currentFirstChild = currentFirstChild.sibling;
          }
          newChild.type === REACT_FRAGMENT_TYPE
            ? ((lanes = createFiberFromFragment(
                newChild.props.children,
                returnFiber.mode,
                lanes,
                newChild.key
              )),
              (lanes.return = returnFiber),
              (lanes._debugOwner = returnFiber),
              (lanes._debugInfo = currentDebugInfo),
              validateFragmentProps(newChild, lanes, returnFiber),
              (returnFiber = lanes))
            : ((lanes = createFiberFromElement(newChild, returnFiber.mode, lanes)),
              coerceRef(lanes, newChild),
              (lanes.return = returnFiber),
              (lanes._debugInfo = currentDebugInfo),
              (returnFiber = lanes));
        }
        returnFiber = placeSingleChild(returnFiber);
        currentDebugInfo = prevDebugInfo;
        return returnFiber;
      case REACT_PORTAL_TYPE:
        a: {
          prevDebugInfo = newChild;
          for (newChild = prevDebugInfo.key; null !== currentFirstChild; ) {
            if (currentFirstChild.key === newChild)
              if (
                4 === currentFirstChild.tag &&
                currentFirstChild.stateNode.containerInfo === prevDebugInfo.containerInfo &&
                currentFirstChild.stateNode.implementation === prevDebugInfo.implementation
              ) {
                deleteRemainingChildren(returnFiber, currentFirstChild.sibling);
                lanes = useFiber(currentFirstChild, prevDebugInfo.children || []);
                lanes.return = returnFiber;
                returnFiber = lanes;
                break a;
              } else {
                deleteRemainingChildren(returnFiber, currentFirstChild);
                break;
              }
            else deleteChild(returnFiber, currentFirstChild);
            currentFirstChild = currentFirstChild.sibling;
          }
          lanes = createFiberFromPortal(prevDebugInfo, returnFiber.mode, lanes);
          lanes.return = returnFiber;
          returnFiber = lanes;
        }
        return placeSingleChild(returnFiber);
      case REACT_LAZY_TYPE:
        return (
          (prevDebugInfo = pushDebugInfo(newChild._debugInfo)),
          (newChild = callLazyInitInDEV(newChild)),
          (returnFiber = reconcileChildFibersImpl(returnFiber, currentFirstChild, newChild, lanes)),
          (currentDebugInfo = prevDebugInfo),
          returnFiber
        );
    }
    if (isArrayImpl(newChild))
      return (
        (prevDebugInfo = pushDebugInfo(newChild._debugInfo)),
        (returnFiber = reconcileChildrenArray(returnFiber, currentFirstChild, newChild, lanes)),
        (currentDebugInfo = prevDebugInfo),
        returnFiber
      );
    if (getIteratorFn(newChild)) {
      prevDebugInfo = pushDebugInfo(newChild._debugInfo);
      key = getIteratorFn(newChild);
      if ('function' !== typeof key)
        throw Error(
          'An object is not an iterable. This error is likely caused by a bug in React. Please file an issue.'
        );
      var newChildren = key.call(newChild);
      if (newChildren === newChild) {
        if (
          0 !== returnFiber.tag ||
          '[object GeneratorFunction]' !== Object.prototype.toString.call(returnFiber.type) ||
          '[object Generator]' !== Object.prototype.toString.call(newChildren)
        )
          didWarnAboutGenerators ||
            console.error(
              'Using Iterators as children is unsupported and will likely yield unexpected results because enumerating a generator mutates it. You may convert it to an array with `Array.from()` or the `[...spread]` operator before rendering. You can also use an Iterable that can iterate multiple times over the same items.'
            ),
            (didWarnAboutGenerators = !0);
      } else
        newChild.entries !== key ||
          didWarnAboutMaps ||
          (console.error(
            'Using Maps as children is not supported. Use an array of keyed ReactElements instead.'
          ),
          (didWarnAboutMaps = !0));
      returnFiber = reconcileChildrenIterator(returnFiber, currentFirstChild, newChildren, lanes);
      currentDebugInfo = prevDebugInfo;
      return returnFiber;
    }
    if ('function' === typeof newChild.then)
      return (
        (prevDebugInfo = pushDebugInfo(newChild._debugInfo)),
        (returnFiber = reconcileChildFibersImpl(
          returnFiber,
          currentFirstChild,
          unwrapThenable(newChild),
          lanes
        )),
        (currentDebugInfo = prevDebugInfo),
        returnFiber
      );
    if (newChild.$$typeof === REACT_CONTEXT_TYPE)
      return reconcileChildFibersImpl(
        returnFiber,
        currentFirstChild,
        readContextDuringReconciliation(returnFiber, newChild),
        lanes
      );
    throwOnInvalidObjectType(returnFiber, newChild);
  }
  if (
    ('string' === typeof newChild && '' !== newChild) ||
    'number' === typeof newChild ||
    'bigint' === typeof newChild
  )
    return (
      (prevDebugInfo = '' + newChild),
      null !== currentFirstChild && 6 === currentFirstChild.tag
        ? (deleteRemainingChildren(returnFiber, currentFirstChild.sibling),
          (lanes = useFiber(currentFirstChild, prevDebugInfo)),
          (lanes.return = returnFiber),
          (returnFiber = lanes))
        : (deleteRemainingChildren(returnFiber, currentFirstChild),
          (lanes = createFiberFromText(prevDebugInfo, returnFiber.mode, lanes)),
          (lanes.return = returnFiber),
          (lanes._debugOwner = returnFiber),
          (lanes._debugInfo = currentDebugInfo),
          (returnFiber = lanes)),
      placeSingleChild(returnFiber)
    );
  'function' === typeof newChild && warnOnFunctionType(returnFiber, newChild);
  'symbol' === typeof newChild && warnOnSymbolType(returnFiber, newChild);
  return deleteRemainingChildren(returnFiber, currentFirstChild);
}
```

# createFiberFromElement

```js
function createFiberFromElement(element, mode, lanes) {
  mode = createFiberFromTypeAndProps(
    element.type,
    element.key,
    element.props,
    element._owner,
    mode,
    lanes
  );
  mode._debugOwner = element._owner;
  return mode;
}
```

# createFiberFromTypeAndProps

```js
function createFiberFromTypeAndProps(type, key, pendingProps, owner, mode, lanes) {
  var fiberTag = 0,
    resolvedType = type;
  if ('function' === typeof type)
    shouldConstruct(type) && (fiberTag = 1),
      (resolvedType = resolveFunctionForHotReloading(resolvedType));
  else if ('string' === typeof type)
    (fiberTag = getHostContext()),
      (fiberTag = isHostHoistableType(type, pendingProps, fiberTag)
        ? 26
        : 'html' === type || 'head' === type || 'body' === type
        ? 27
        : 5);
  else
    a: switch (type) {
      case REACT_FRAGMENT_TYPE:
        return createFiberFromFragment(pendingProps.children, mode, lanes, key);
      case REACT_STRICT_MODE_TYPE:
        fiberTag = 8;
        mode |= StrictLegacyMode;
        mode |= StrictEffectsMode;
        break;
      case REACT_PROFILER_TYPE:
        return (
          (type = pendingProps),
          (owner = mode),
          'string' !== typeof type.id &&
            console.error(
              'Profiler must specify an "id" of type `string` as a prop. Received the type `%s` instead.',
              typeof type.id
            ),
          (key = createFiber(12, type, key, owner | ProfileMode)),
          (key.elementType = REACT_PROFILER_TYPE),
          (key.lanes = lanes),
          (key.stateNode = { effectDuration: 0, passiveEffectDuration: 0 }),
          key
        );
      case REACT_SUSPENSE_TYPE:
        return (
          (key = createFiber(13, pendingProps, key, mode)),
          (key.elementType = REACT_SUSPENSE_TYPE),
          (key.lanes = lanes),
          key
        );
      case REACT_SUSPENSE_LIST_TYPE:
        return (
          (key = createFiber(19, pendingProps, key, mode)),
          (key.elementType = REACT_SUSPENSE_LIST_TYPE),
          (key.lanes = lanes),
          key
        );
      case REACT_OFFSCREEN_TYPE:
        return createFiberFromOffscreen(pendingProps, mode, lanes, key);
      default:
        if ('object' === typeof type && null !== type)
          switch (type.$$typeof) {
            case REACT_PROVIDER_TYPE:
            case REACT_CONTEXT_TYPE:
              fiberTag = 10;
              break a;
            case REACT_CONSUMER_TYPE:
              fiberTag = 9;
              break a;
            case REACT_FORWARD_REF_TYPE:
              fiberTag = 11;
              resolvedType = resolveForwardRefForHotReloading(resolvedType);
              break a;
            case REACT_MEMO_TYPE:
              fiberTag = 14;
              break a;
            case REACT_LAZY_TYPE:
              fiberTag = 16;
              resolvedType = null;
              break a;
          }
        resolvedType = '';
        if (
          void 0 === type ||
          ('object' === typeof type && null !== type && 0 === Object.keys(type).length)
        )
          resolvedType +=
            " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports.";
        null === type
          ? (pendingProps = 'null')
          : isArrayImpl(type)
          ? (pendingProps = 'array')
          : void 0 !== type && type.$$typeof === REACT_ELEMENT_TYPE
          ? ((pendingProps = '<' + (getComponentNameFromType(type.type) || 'Unknown') + ' />'),
            (resolvedType = ' Did you accidentally export a JSX literal instead of a component?'))
          : (pendingProps = typeof type);
        (fiberTag = owner ? getComponentNameFromOwner(owner) : null) &&
          (resolvedType += '\n\nCheck the render method of `' + fiberTag + '`.');
        fiberTag = 29;
        pendingProps = Error(
          'Element type is invalid: expected a string (for built-in components) or a class/function (for composite components) but got: ' +
            (pendingProps + '.' + resolvedType)
        );
        resolvedType = null;
    }
  key = createFiber(fiberTag, pendingProps, key, mode);
  key.elementType = type;
  key.type = resolvedType;
  key.lanes = lanes;
  key._debugOwner = owner;
  return key;
}
```

# createFiber

```js
function createFiber(tag, pendingProps, key, mode) {
  return new FiberNode(tag, pendingProps, key, mode);
}
```

# FiberNode

```js
function FiberNode(tag, pendingProps, key, mode) {
  this.tag = tag;
  this.key = key;
  this.sibling = this.child = this.return = this.stateNode = this.type = this.elementType = null;
  this.index = 0;
  this.refCleanup = this.ref = null;
  this.pendingProps = pendingProps;
  this.dependencies = this.memoizedState = this.updateQueue = this.memoizedProps = null;
  this.mode = mode;
  this.subtreeFlags = this.flags = 0;
  this.deletions = null;
  this.childLanes = this.lanes = 0;
  this.alternate = null;
  this.actualDuration = -0;
  this.actualStartTime = -1.1;
  this.treeBaseDuration = this.selfBaseDuration = -0;
  this._debugOwner = this._debugInfo = null;
  this._debugNeedsRemount = !1;
  this._debugHookTypes = null;
  hasBadMapPolyfill ||
    'function' !== typeof Object.preventExtensions ||
    Object.preventExtensions(this);
}
```

# performUnitOfWork

```js
function performUnitOfWork(unitOfWork) {
  var current = unitOfWork.alternate;
  (unitOfWork.mode & ProfileMode) !== NoMode
    ? (startProfilerTimer(unitOfWork),
      (current = runWithFiberInDEV(
        unitOfWork,
        beginWork,
        current,
        unitOfWork,
        entangledRenderLanes
      )),
      stopProfilerTimerIfRunningAndRecordDuration(unitOfWork))
    : (current = runWithFiberInDEV(
        unitOfWork,
        beginWork,
        current,
        unitOfWork,
        entangledRenderLanes
      ));
  unitOfWork.memoizedProps = unitOfWork.pendingProps;
  null === current ? completeUnitOfWork(unitOfWork) : (workInProgress = current);
}
```

# reconcileChildrenArray

```js
function reconcileChildrenArray(returnFiber, currentFirstChild, newChildren, lanes) {
  for (
    var knownKeys = null,
      resultingFirstChild = null,
      previousNewFiber = null,
      oldFiber = currentFirstChild,
      newIdx = (currentFirstChild = 0),
      nextOldFiber = null;
    null !== oldFiber && newIdx < newChildren.length;
    newIdx++
  ) {
    oldFiber.index > newIdx
      ? ((nextOldFiber = oldFiber), (oldFiber = null))
      : (nextOldFiber = oldFiber.sibling);
    var newFiber = updateSlot(returnFiber, oldFiber, newChildren[newIdx], lanes);
    if (null === newFiber) {
      null === oldFiber && (oldFiber = nextOldFiber);
      break;
    }
    knownKeys = warnOnInvalidKey(returnFiber, newFiber, newChildren[newIdx], knownKeys);
    shouldTrackSideEffects &&
      oldFiber &&
      null === newFiber.alternate &&
      deleteChild(returnFiber, oldFiber);
    currentFirstChild = placeChild(newFiber, currentFirstChild, newIdx);
    null === previousNewFiber
      ? (resultingFirstChild = newFiber)
      : (previousNewFiber.sibling = newFiber);
    previousNewFiber = newFiber;
    oldFiber = nextOldFiber;
  }
  if (newIdx === newChildren.length)
    return (
      deleteRemainingChildren(returnFiber, oldFiber),
      isHydrating && pushTreeFork(returnFiber, newIdx),
      resultingFirstChild
    );
  if (null === oldFiber) {
    for (; newIdx < newChildren.length; newIdx++)
      (oldFiber = createChild(returnFiber, newChildren[newIdx], lanes)),
        null !== oldFiber &&
          ((knownKeys = warnOnInvalidKey(returnFiber, oldFiber, newChildren[newIdx], knownKeys)),
          (currentFirstChild = placeChild(oldFiber, currentFirstChild, newIdx)),
          null === previousNewFiber
            ? (resultingFirstChild = oldFiber)
            : (previousNewFiber.sibling = oldFiber),
          (previousNewFiber = oldFiber));
    isHydrating && pushTreeFork(returnFiber, newIdx);
    return resultingFirstChild;
  }
  for (oldFiber = mapRemainingChildren(oldFiber); newIdx < newChildren.length; newIdx++)
    (nextOldFiber = updateFromMap(oldFiber, returnFiber, newIdx, newChildren[newIdx], lanes)),
      null !== nextOldFiber &&
        ((knownKeys = warnOnInvalidKey(returnFiber, nextOldFiber, newChildren[newIdx], knownKeys)),
        shouldTrackSideEffects &&
          null !== nextOldFiber.alternate &&
          oldFiber.delete(null === nextOldFiber.key ? newIdx : nextOldFiber.key),
        (currentFirstChild = placeChild(nextOldFiber, currentFirstChild, newIdx)),
        null === previousNewFiber
          ? (resultingFirstChild = nextOldFiber)
          : (previousNewFiber.sibling = nextOldFiber),
        (previousNewFiber = nextOldFiber));
  shouldTrackSideEffects &&
    oldFiber.forEach(function (child) {
      return deleteChild(returnFiber, child);
    });
  isHydrating && pushTreeFork(returnFiber, newIdx);
  return resultingFirstChild;
}
```

# createChild

```js
function createChild(returnFiber, newChild, lanes) {
  if (
    ('string' === typeof newChild && '' !== newChild) ||
    'number' === typeof newChild ||
    'bigint' === typeof newChild
  )
    return (
      (newChild = createFiberFromText('' + newChild, returnFiber.mode, lanes)),
      (newChild.return = returnFiber),
      (newChild._debugOwner = returnFiber),
      (newChild._debugInfo = currentDebugInfo),
      newChild
    );
  if ('object' === typeof newChild && null !== newChild) {
    switch (newChild.$$typeof) {
      case REACT_ELEMENT_TYPE:
        return (
          (lanes = createFiberFromElement(newChild, returnFiber.mode, lanes)),
          coerceRef(lanes, newChild),
          (lanes.return = returnFiber),
          (returnFiber = pushDebugInfo(newChild._debugInfo)),
          (lanes._debugInfo = currentDebugInfo),
          (currentDebugInfo = returnFiber),
          lanes
        );
      case REACT_PORTAL_TYPE:
        return (
          (newChild = createFiberFromPortal(newChild, returnFiber.mode, lanes)),
          (newChild.return = returnFiber),
          (newChild._debugInfo = currentDebugInfo),
          newChild
        );
      case REACT_LAZY_TYPE:
        var _prevDebugInfo = pushDebugInfo(newChild._debugInfo);
        newChild = callLazyInitInDEV(newChild);
        returnFiber = createChild(returnFiber, newChild, lanes);
        currentDebugInfo = _prevDebugInfo;
        return returnFiber;
    }
    if (isArrayImpl(newChild) || getIteratorFn(newChild))
      return (
        (lanes = createFiberFromFragment(newChild, returnFiber.mode, lanes, null)),
        (lanes.return = returnFiber),
        (lanes._debugOwner = returnFiber),
        (returnFiber = pushDebugInfo(newChild._debugInfo)),
        (lanes._debugInfo = currentDebugInfo),
        (currentDebugInfo = returnFiber),
        lanes
      );
    if ('function' === typeof newChild.then)
      return (
        (_prevDebugInfo = pushDebugInfo(newChild._debugInfo)),
        (returnFiber = createChild(returnFiber, unwrapThenable(newChild), lanes)),
        (currentDebugInfo = _prevDebugInfo),
        returnFiber
      );
    if (newChild.$$typeof === REACT_CONTEXT_TYPE)
      return createChild(
        returnFiber,
        readContextDuringReconciliation(returnFiber, newChild),
        lanes
      );
    throwOnInvalidObjectType(returnFiber, newChild);
  }
  'function' === typeof newChild && warnOnFunctionType(returnFiber, newChild);
  'symbol' === typeof newChild && warnOnSymbolType(returnFiber, newChild);
  return null;
}
```

# createFiberFromText

```js
function createFiberFromText(content, mode, lanes) {
  content = createFiber(6, content, null, mode);
  content.lanes = lanes;
  return content;
}
```
