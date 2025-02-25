https://zhuanlan.zhihu.com/p/666672251

# patchKeyedChildren

```ts
const patchKeyedChildren = (...) => {
  let i = 0;
  const l2 = c2.length;
  let e1 = c1.length - 1; // 旧虚拟 DOM 树的末尾节点索引
  let e2 = l2 - 1; // 新虚拟 DOM 树的末尾节点索引

  /**
   * 第一步
   * 从前往后遍历
   * 索引 i 递增
   */
  while (i <= e1 && i <= e2) {
    // 新旧虚拟节点同时遍历
    const n1 = c1[i];
    const n2 = (c2[i] = optimized
      ? cloneIfMounted(c2[i] as VNode)
      : normalizeVNode(c2[i]));
    if (isSameVNodeType(n1, n2)) {
      // 存在类型相同，且key值相同的节点就 patch
      patch(...);
    } else {
      // 存在不一致的节点，立即退出循环
      break;
    }
    i++;
  }

  /**
   * 第二步
   * 从后往前遍历
   * 索引 e1、e2 递减少
   */
  while (i <= e1 && i <= e2) {
    // 新旧虚拟节点同时遍历
    const n1 = c1[e1];
    const n2 = (c2[e2] = optimized
      ? cloneIfMounted(c2[e2] as VNode)
      : normalizeVNode(c2[e2]));
    if (isSameVNodeType(n1, n2)) {
      // 存在类型相同，且key值相同的节点就patch
      patch(...);
    } else {
      // 存在不一致的节点，立即退出循环
      break;
    }
    e1--;
    e2--;
  }

  /**
   * 第三步
   * 对比索引大小
   * 处理新增或被删除节点
   */
  if (i > e1) {
    if (i <= e2) {
      // 存在新增节点
      /**
       * 1. 左侧新增
       * (a b)
       * c (a b)
       * i = 0, e1 = -1, e2 = 0
       */
      /**
       * 2. 中间新增
       * (a b)
       * (a) c d (b)
       * i = 1, e1 = 0, e2 = 2
       */
      /**
       * 3. 右侧新增
       * (a b)
       * (a b) c
       * i = 2, e1 = 1, e2 = 2
       */
      // nextPos 作为新节点的后一位节点的索引，当作插入锚点
      const nextPos = e2 + 1;
      const anchor = nextPos < l2 ? (c2[nextPos] as VNode).el : parentAnchor;
      while (i <= e2) {
        /**
         * i 到 e2 之间的节点即为新增节点
         * 直接挂载
         * oldvnode 置为 null，复用 path 函数进行挂载
         */
        patch(
          null,
          (c2[i] = optimized
            ? cloneIfMounted(c2[i] as VNode)
            : normalizeVNode(c2[i])),
          ...
        );
        i++;
      }
    }
  } else if (i > e2) {
    // 存在被删除节点
    /**
     * 1. 左侧被删除
     * a (b c)
     *   (b c)
     * i = 0, e1 = 0, e2 = -1
     */
    /**
     * 2. 中间被删除
     * (a) c d (b)
     * (a)     (b)
     * i = 1, e1 = 2, e2 = 0
     */
    /**
     * 3. 右侧被删除
     * (a b) c
     * (a b)
     * i = 2, e1 = 2, e2 = 1
     */
    while (i <= e1) {
      /**
       * i 到 e1 之间的节点即为被删除节点
       * 直接卸载
       */
      unmount(c1[i], parentComponent, parentSuspense, true);
      i++;
    }
  }
  /**
   * 第四步
   * 处理其它特殊情况
   * 我们的示例也将走到这里
   */
  else {
    // 新旧虚拟 DOM 树不一致的节点起始索引
    const s1 = i;
    const s2 = i;
    /**
     * 遍历新节点
     * 生成map，键值即新节点的key值，值为节点的索引
     * 伪代码：keyToNewIndexMap<key, index>
     */
    const keyToNewIndexMap: Map<string | number | symbol, number> = new Map();
    for (i = s2; i <= e2; i++) {
      const nextChild = (c2[i] = optimized
        ? cloneIfMounted(c2[i] as VNode)
        : normalizeVNode(c2[i]));
      if (nextChild.key != null) {
        keyToNewIndexMap.set(nextChild.key, i);
      }
    }
    let j;
    // 记录已经 patch 的节点数
    let patched = 0;
    // 计算新节点中还有多少节点需要被 patch
    const toBePatched = e2 - s2 + 1;
    // 标记是否需要移动
    let moved = false;
    // 记录这次对比的旧节点到新节点最长可复用的索引
    let maxNewIndexSoFar = 0;

    /**
     * 创建将要patch的节点数组
     * 新节点对应旧节点的数组
     * 数组下标为新节点的索引，值为旧节点的索引+1
     */
    const newIndexToOldIndexMap = new Array(toBePatched);
    /**
     * 默认置为 0
     * 表示新增节点
     * 这也是为什么值是 旧节点索引+1 而不直接存索引的原因了
     * 后续判断是否存在可复用的旧节点再重新赋值
     */
    for (i = 0; i < toBePatched; i++) newIndexToOldIndexMap[i] = 0;

    // 遍历 i 到 e2 之间需要处理的节点
    for (i = s1; i <= e1; i++) {
      // 获取一下旧虚拟节点
      const prevChild = c1[i];
      if (patched >= toBePatched) {
        // 已经patch的节点数量大于或等于需要被patch的节点数
        // 说明当前节点是需要被删除的
        unmount(prevChild, parentComponent, parentSuspense, true);
        continue;
      }
      // 获取当前旧节点对应的新节点索引
      let newIndex;
      if (prevChild.key != null) {
        /**
         * 旧节点存在key值
         * 直接在 keyToNewIndexMap 查找
         * 获取新节点的索引（newIndex）
         */
        newIndex = keyToNewIndexMap.get(prevChild.key);
      } else {
        // 旧节点不存在 key 值
        for (j = s2; j <= e2; j++) {
          // 遍历新节点剩余索引（s2 即新旧虚拟DOM树存在不同节点的位置）
          if (
            newIndexToOldIndexMap[j - s2] === 0 &&
            isSameVNodeType(prevChild, c2[j] as VNode)
          ) {
            /**
             * 判断当前索引是不是还没 patch（newIndexToOldIndexMap[j - s2] === 0）
             * 同时判断当前新旧节点是否 key、type 都一致
             * 一致就获取当前新节点索引（newIndex = j）
             * 跳出当前循环
             */
            newIndex = j;
            break;
          }
        }
      }
      if (newIndex === undefined) {
        /**
         * newIndex 为 undefined
         * 说明当前旧节点在新的虚拟 DOM 树中被删了
         * 直接卸载
         */
        unmount(prevChild, parentComponent, parentSuspense, true);
      } else {
        /**
         * newIndex有值
         * 说明当前旧节点在新节点数组中还存在，可能只是挪了位置
         */

        /**
         * 记录一下 newIndexToOldIndexMap
         * 表明当前新旧节点需要 patch
         */
        newIndexToOldIndexMap[newIndex - s2] = i + 1;
        if (newIndex >= maxNewIndexSoFar) {
          // 新节点索引大于或等于最长可复用索引，重新赋值
          maxNewIndexSoFar = newIndex;
        } else {
          /**
           * 反之
           * 说明新节点在最长可复用节点的左侧
           * 需要移动（左移）
           */
          moved = true;
        }
        // 直接复用，patch（处理可能存在的孙子节点、更新一下属性等）
        patch(
          prevChild,
          c2[newIndex] as VNode,
          ...
        );
        patched++;
      }
    }
    /**
     * 根据 newIndexToOldIndexMap 数组
     * 生成最长稳定序列
     * 最长稳定序列在这里存的就是不需要移动的节点索引
     */
    const increasingNewIndexSequence = moved
      ? getSequence(newIndexToOldIndexMap)
      : EMPTY_ARR;
    // 最长稳定序列末尾节点索引
    j = increasingNewIndexSequence.length - 1;
    // 从后往前遍历需要 patch 的节点数
    for (i = toBePatched - 1; i >= 0; i--) {
      // 新虚拟节点索引
      const nextIndex = s2 + i;
      // 新虚拟节点
      const nextChild = c2[nextIndex] as VNode;
      // 将新节点的真实 DOM 作为后续插入的锚点
      const anchor =
        nextIndex + 1 < l2 ? (c2[nextIndex + 1] as VNode).el : parentAnchor;
      if (newIndexToOldIndexMap[i] === 0) {
        /**
         * 为 0 的话就是新增的节点
         * 直接挂载新节点
         */
        patch(
          null,
          nextChild,
          container,
          anchor,
          ...
        );
      } else if (moved) {
        // 需要移动
        if (j < 0 || i !== increasingNewIndexSequence[j]) {
          /**
           * 当前索引不在最长递增序列中
           * 移动当前索引对应的新节点
           * 移动到锚点节点之前
           */
          move(nextChild, container, anchor, MoveType.REORDER);
        } else {
          j--;
        }
      }
    }
  }
};
```

# patchChildren

```ts
const patchChildren: PatchChildrenFn = (...) => {
    // 取一哈新旧虚拟节点的子节点
    const c1 = n1 && n1.children
    const prevShapeFlag = n1 ? n1.shapeFlag : 0
    const c2 = n2.children
    const { patchFlag, shapeFlag } = n2
    if (patchFlag > 0) {
      // patchFlag > 0 就表示子节点含有动态属性，如：动态style、动态class、动态文案等
      if (patchFlag & PatchFlags.KEYED_FRAGMENT) {
        // 子节点带 key
        patchKeyedChildren(...)
        return
      } else if (patchFlag & PatchFlags.UNKEYED_FRAGMENT) {
        // 子节点不带 key
        patchUnkeyedChildren(...)
        return
      }
    }
    // 子节点存在3种可能的情况：文本、数组、没有子节点
    if (shapeFlag & ShapeFlags.TEXT_CHILDREN) {
      // 新虚拟节点的子节点是文本
      if (prevShapeFlag & ShapeFlags.ARRAY_CHILDREN) {
        // 对应的旧虚拟节点的子节点是数组
        // 卸载旧虚拟节点的数组子节点
        unmountChildren(c1 as VNode[], parentComponent, parentSuspense)
      }
      // 再挂载新虚拟节点的文本子节点
      if (c2 !== c1) {
        hostSetElementText(container, c2 as string)
      }
    } else {
      if (prevShapeFlag & ShapeFlags.ARRAY_CHILDREN) {
        // 旧虚拟节点的子节点是数组
        if (shapeFlag & ShapeFlags.ARRAY_CHILDREN) {
          // 新虚拟节点的子节点也是数组，做全量diff
          patchKeyedChildren(...)
        } else {
          // 能走到这就说明新虚拟节点没有子节点，这里只需要卸载久虚拟节点的子节点
          unmountChildren(c1 as VNode[], parentComponent, parentSuspense, true)
        }
      } else {
        // 走到这就说明
        // 旧虚拟节点的子节点要么是文本要么也没有子节点
        // 新虚拟节点的子节点要么是数组要么就没有子节点
        if (prevShapeFlag & ShapeFlags.TEXT_CHILDREN) {
          // 旧虚拟节点的子节点是文本，更新
          hostSetElementText(container, '')
        }
        if (shapeFlag & ShapeFlags.ARRAY_CHILDREN) {
          // 新虚拟节点的子节点是数组，挂载
          mountChildren(...)
        }
      }
    }
  }
```

# patchUnkeyedChildren

```ts
const patchUnkeyedChildren = (...) => {
  c1 = c1 || EMPTY_ARR;
  c2 = c2 || EMPTY_ARR;
  const oldLength = c1.length;
  const newLength = c2.length;
  const commonLength = Math.min(oldLength, newLength);
  let i;
  // 依次从头遍历，将旧的虚拟节点更新为新节点
  for (i = 0; i < commonLength; i++) {
    const nextChild = (c2[i] = optimized
      ? cloneIfMounted(c2[i] as VNode)
      : normalizeVNode(c2[i]));
    patch(...);
  }
  if (oldLength > newLength) {
    // 旧虚拟节点的子节点长度更大，说明被删除了
    // 卸载多余的旧虚拟节点
    unmountChildren(...);
  } else {
    // 反之，存在新增的节点，挂载
    mountChildren(...);
  }
};
```
