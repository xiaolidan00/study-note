# defer 和 async 区别

区别主要在于一个执行时间

- defer 会在文档解析完之后执行,并且多个 defer 会按照顺序执行

- async 则是在 js 加载好之后就会执行,并且多个 async,哪个加载好就执行哪个,顺序不定

---

- 两个都是异步加载 JS 脚本，不阻塞 html 解析
- defer 是先加载，等到 dom 解析完，在 DOMContentLoaded 事件之前执行脚本
- async 是加载完立即执行
- type="module"的效果等同于 defer

# 重绘和回流

- 重绘是当节点需要更改外观而不会影响布局的，比如改变 color
- 回流是布局或者几何属性需要改变

所以以下几个动作可能会导致性能问题：

- 改变 window 大小
- 改变字体
- 添加或删除样式
- 文字改变
- 定位或者浮动
- 盒模型

## 和 Event loop 有关。

1. 当 Event loop 执行完 Microtasks 后，会判断 document 是否需要更新。
   因为浏览器是 60Hz 的刷新率，每 16ms 才会更新一次。
   然后判断是否有 resize 或者 scroll，有的话会去触发事件，所以 resize 和 scroll 事件也是至少 16ms 才会触发一次，并且自带节流功能。
2. 判断是否触发了 media query
3. 更新动画并且发送事件
4. 判断是否有全屏操作事件
5. 执行 requestAnimationFrame 回调
6. 执行 IntersectionObserver 回调，该方法用于判断元素是否可见，可以用于懒加载上，但是兼容性不好
7. 更新界面
8. 以上就是一帧中可能会做的事情。如果在一帧中有空闲时间，就会去执行 requestIdleCallback 回调。

## 减少重绘和回流

- 使用 translate 替代 top
- 使用 visibility 替换 display: none
- 把 DOM 离线后修改，比如：先把 DOM 给 display:none(有一次 Reflow)，然后你修改 100 次，然后再把它显示出来
- 不要把 DOM 结点的属性值放在一个循环里当成循环里的变量
- 不要使用 table 布局，可能很小的一个小改动会造成整个 table 的重新布局
- 动画实现的速度的选择，动画速度越快，回流次数越多，也可以选择使用 requestAnimationFrame
- CSS 选择符从右往左匹配查找，避免 DOM 深度过深
- 将频繁运行的动画变为图层，图层能够阻止该节点回流影响别的元素。比如对于 video 标签，浏览器会自动将该节点变为图层。
