https://monorepo.tools/

# monorepo 定义

monorepo 是包含多个不同项目的单个存储库，具有明确定义的关系。
不仅仅是“代码托管”
如果存储库包含大型应用程序，而没有对离散部分进行划分和封装，则它只是一个大型存储库。
事实上，这样的 repo 是令人望而却步的单体式，这通常是人们想到 monorepo 时首先想到的事情。
继续阅读，你会发现一个好的 monorepo 与 monolithic 相反。
一个好的 monorepo 是 monolithic 的对立面！
假设 monorepo 的反面是 “polyrepo”。polyrepo 是当前开发应用程序的标准方式：每个团队、应用程序或项目的 repo。每个存储库通常都有一个生成构件和简单的生成管道。

## polyrepo 问题

这些都是好事，那么团队为什么要做任何不同的事情呢？因为这种自主性是由隔离提供的，而隔离会损害协作。更具体地说，这些是 polyrepo 环境的常见缺点：

- 繁琐的代码共享

要在存储库之间共享代码，您可能需要为共享代码创建一个存储库。现在，您必须设置工具和 CI 环境，将提交者添加到存储库，并设置包发布，以便其他存储库可以依赖它。让我们不要开始协调存储库中第三方库的不兼容版本...

- 大量代码重复

没有人愿意经历设置共享存储库的麻烦，因此团队只需在每个存储库中编写自己的常见服务和组件实现。这浪费了前期时间，而且随着组件和服务的变化，也增加了维护、安全和质量控制的负担。

- 对共享库和使用者进行成本高昂的跨存储库更改

考虑共享库中的关键错误或重大更改：开发人员需要设置其环境，以将更改应用于具有断开连接的修订历史记录的多个存储库。更不用说版本控制和发布软件包的协调工作了。

- 工具不一致

每个项目都使用自己的命令集来运行测试、构建、服务、linting、部署等。不一致会产生记住从一个项目到另一个项目使用哪些命令的心理开销。

## 但是 monorepo 如何帮助解决所有这些问题呢？

在 polyrepo 中工作时，我们最终可能会遇到非常棘手的情况。但是 monorepo 如何帮助解决所有这些问题呢？

- 创建新项目没有开销

使用现有的 CI 设置，如果所有使用者都位于同一存储库中，则无需发布版本控制包。

- 跨项目的原子提交

每次提交时，一切都会协同工作。当你在同一个提交中修复所有内容时，没有破坏性变更这样的事情。

- 一个版本的所有内容

无需担心由于项目依赖于第三方库的冲突版本而导致的不兼容。

- 开发人员移动性

以一致的方式构建和测试使用不同工具和技术编写的应用程序。开发人员可以放心地为其他团队的应用程序做出贡献，并验证他们的更改是否安全。

## 优点

Monorepo 有很多优点，但要让它们发挥作用，你需要有合适的工具。随着您的工作空间的增长，这些工具必须帮助您保持快速、可理解和可管理。

- 本地计算缓存

存储和重放文件以及处理任务输出的能力。在同一台计算机上，您永远不会两次构建或测试相同的事物。

- 本地任务编排

能够以正确的顺序并行运行任务。所有列出的工具都可以以大致相同的方式完成，除了 Lerna，它更受限制。

- 分布式计算缓存

在不同环境之间共享缓存构件的能力。这意味着您的整个组织，包括 CI 代理，永远不会两次构建或测试相同的事物。

- 透明的远程执行

能够在多台计算机上执行任何命令，同时在本地开发。

- 分布式任务执行

能够在多台计算机上分发命令，同时在很大程度上保留在单台计算机上运行该命令的开发人体工程学。

- 检测受影响的项目/包

确定更改可能影响的内容，以仅运行生成/测试受影响的项目。

- 工作区分析

无需额外配置即可理解工作区的项目图的能力。

- 依赖关系图可视化

可视化项目和/或任务之间的依赖关系。可视化是交互式的，这意味着您可以搜索、过滤、隐藏、聚焦/高亮和查询图表中的节点。

- 代码共享

有助于共享离散的源代码。

- 一致的工具

无论您使用什么来开发项目，该工具都可以帮助您获得一致的体验：不同的 JavaScript 框架、Go、Rust、Java 等。
换句话说，该工具以相同的方式处理不同的技术。
例如，该工具可以分析 package.json 和 JS/TS 文件以找出 JS 项目依赖项，以及如何构建和测试它们。但它会分析 Cargo.toml 文件对 Rust 做同样的事情，或者分析 Gradle 文件对 Java 做同样的事情。这要求该工具是可插拔的。

- 代码生成

对生成代码的本机支持

- 项目约束和可见性

支持定义规则以约束存储库中的依赖关系。例如，开发人员可以将某些项目标记为其团队的私有项目，这样其他人就不能依赖它们。开发人员还可以根据使用的技术（例如 React 或 Nest.js）来标记项目，并确保后端项目不会导入前端项目。

## monorepo 改变了您的组织

它不仅仅是代码和工具。一个单仓库改变了你的组织和你对代码的看法。通过增加一致性、减少创建新项目和执行大规模重构的摩擦，通过促进代码共享和跨团队协作，它将使您的组织更高效地工作。

## Nx

https://nx.dev/concepts/decisions/why-monorepos#monorepos?utm_source=monorepo.tools

## 带你了解更全面的 Monorepo - 优劣、踩坑、选型

https://juejin.cn/post/7215886869199896637

# pnpm monorepo

项目结构

- `examples`组件使用示例
  - `vuedemos` vue 使用示例
  - `reactdemos` react 使用示例
  - `angulardemos` angular 使用示例
- `docs`文档
  - `apis`组件配置 API
  - `guide`使用指南,版本记录，常见问题
  - package.json
- `packages`组件库
  - `components` class 组件
  - `types`公共类型
  - `utils`公共工具
  - `configs`公共配置参数
  - `index.ts`所有组件入口
- `@types` typescript 类型
- `tests`组件测试
- `scripts`构建脚本
- `README.md` 记录相关开发注意事项
- `package.json`

**pnpm-workspace.yaml**

```yaml
packages:
  - packages/*
  - examples/vuedemos
  - examples/reactdemos
  - examples/angulardemos
  - docs
```

**package.json**

```json
{
  "name": "my-components",
  "packageManager": "pnpm@10.6.2",
  "version": "1.0.0",
  "type": "module",
  "main": "build/clazz/index.umd.js",
  "module": "build/clazz/index.js",
  "types": "build/index.d.ts",
  "files": ["build"],
  "exports": {
    ".": {
      "types": "./build/index.d.ts",
      "import": "./build/clazz/index.js",
      "require": "./build/clazz/index.umd.js"
    },
    "./*": "./build/*"
  },
  "workspaces": ["packages/*", "examples/vuedemos", "examples/reactdemos", "examples/angulardemos", "docs"],
  //不会安装到node_modules
  "devDependencies": {},
  //引用组件库的时候会按照到node_modules
  "dependencies": {
    "echarts": "^5.6.0",
    "echarts-gl": "^2.0.9"
  }
}
```

**项目中使用组件库**
直接在依赖中写当前组件库的名称，版本是`workspace:*`，然后`pnpm install`通过 install 从 `node_modules` 软链接到组件库目录

```json
{
  "name": "vuedemos",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "dev": "vite"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": "",
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.2.1",
    "@vue/tsconfig": "^0.7.0",
    "typescript": "^5.8.2",
    "vite": "^6.2.1",
    "vue": "^3.5.13",
    "vue-tsc": "^2.2.8",
    //使用组件库
    "my-components": "workspace:*"
  }
}
```

```vue
<template>
  <div>
    <div style="height: 500px; width: 500px" ref="chartRef"></div>
  </div>
</template>

<script setup lang="ts">
import 'echarts-gl';
import {ref, useTemplateRef, onMounted, onBeforeMount} from 'vue';
import 'sw-components/clazz/index.css';
import SWCOMP from 'sw-components';

const dataRef = ref([]);
const chartRef = useTemplateRef<HTMLElement>('chartRef');
const chart = new SWCOMP.LineBarChart();

const getData = () => {
  fetch('https://www.xiaolidan00.top/getRandNum.php')
    .then((res) => res.json())
    .then(({data}) => {
      dataRef.value = data;
      chartRef.value &&
        chart.init(
          chartRef.value,
          {
            loop: false,
            time: 2000,
            dataProps: {name: 'name', value0: 'value', value1: 'value1'},
            series: [
              {name: '销量', type: 'line'},
              {name: '盈利', type: 'bar'}
            ]
          },
          data
        );
    });
};
onMounted(() => {
  getData();
});
onBeforeMount(() => {
  chart.destory();
});
</script>
```

```vue
<template>
  <div>
    <line-bar-chart
      color='["#3fb1e3","#6be6c1"]'
      ref="chartRef"
      time="2000"
      style="height: 500px; width: 500px"
      series='[{"name":"销量","type":"line"},{"name":"盈利","type":"bar"}]'
      dataProps='{"name":"name","value0":"value","value1":"value1"}'
      :data="JSON.stringify(dataRef)"
    ></line-bar-chart>
  </div>
</template>

<script setup lang="ts">
import {ref} from 'vue';
import 'sw-components/webcomponents/index.css';
import {install} from 'sw-components/webcomponents/index.js';

//引入注册组件
install();
const dataRef = ref([]);

fetch('https://www.xiaolidan00.top/getRandNum.php')
  .then((res) => res.json())
  .then(({data}) => {
    console.log('🚀 ~ WebComponents ~ data:', data);
    dataRef.value = data;
  });
</script>
```
