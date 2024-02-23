# Vue 性能优化

- 合理使用 v-show 和 v-if
- 合理使用 computed
- v-for 加 key，避免与 v-if 同时使用
- 自定义事件和 dom 事件及时销毁
- 合理使用异步组件
- 合理使用 keep-alive
- data 层级不要太深
- vue-loader
- webpack
- 懒加载等前端性能优化
- SSR
- 使用 tree-shaking 友好的 esmodule 第三方库
- props 稳定性
- v-once：只渲染一次，更新跳过
- v-memo：有条件地跳过某些大型子树或者 v-for 列表的更新
- 虚拟滚动
- 减少大型不可变数据的响应性开销：通过使用 shallowRef() 和 shallowReactive() 来绕开深度响应
- 避免不必要的组件抽象

**v-memo**

- v-memo="[valueA, valueB]":当组件重新渲染，如果 valueA 和 valueB 都保持不变，这个 `<div>` 及其子项的所有更新都将被跳过。实际上，甚至虚拟 DOM 的 vnode 创建也将被跳过，因为缓存的子树副本可以被重新使用。
- v-memo 传入空依赖数组 (v-memo="[]") 将与 v-once 效果相同。
- 当搭配 v-for 使用 v-memo，确保两者都绑定在同一个元素上。v-memo 不能用在 v-for 内部。

```vue
<template>
  <!-- 错误做法 -->
  <ListItem v-for="item in list" :id="item.id" :active-id="activeId" />
  <!-- 正确做法 -->
  <ListItem v-for="item in list" :id="item.id" :active="item.id === activeId" />

  <!--v-memo="[item.id == selected]"只有当该项的被选中状态改变时才需要更新-->
  <div v-for="item in list" :key="item.id" v-memo="[item.id == selected]">
    <p>ID: {{ item.id }} - selected: {{ item.id == selected }}</p>
    <p>...more child nodes</p>
  </div>
</template>
```

# SPA 首屏加载慢

- DNS 预解析：dns-prefetch 会与 preconnect
- 资源预加载：Preload/Prefetch
- 减小入口文件积，按需加载
- 静态资源本地缓存
- 显示 loading
- 图片资源的压缩
- 抽离公共代码和第三方库打包
- 使用 SSR

# webpack 性能优化-构建速度

- 优化 babel-loader
- ignorePlugin 避免引入无用模块
- noParse 避免重复打包
- happyPack 多进程打包
- ParallelUglifyPlugin 多进程压缩 js

**开发时**

- 自动刷新：整个网页刷新，速度慢，状态丢失，
- 热更新：新代码剩下，网页不刷新，状态不丢失
- DllPlugin 动态链接库， 体积大，稳定的库只构建一次。

# webpack 性能优化-产出代码

- 体积更小
- 合理分包，不重复加载
- 速度快，内存使用更少
- 小图片 base64 编码
- bundle 加 hash
- 懒加载
- 提取公共代码，代码分割
- IgnorePlugin 避免引入无用模块
- 使用 CDN 加速：publicPath 添加前缀，将 js 文件上传到 CDN
- 使用 production：自动 tree-shaking
- Scope Hosting:合并文件，减少作用域，webpack.optimize.ModuleConcatenationPlugin

# rollup 打包性能优化

- external:外部引入，不打入包里，vite-plugin-cdn-import 可添加 cdn
- rollup-plugin-visualizer 查看包体积分布、各插件占比情况
- vite-plugin-imagemin 压缩图片
- @rollup/plugin-terser 压缩代码
