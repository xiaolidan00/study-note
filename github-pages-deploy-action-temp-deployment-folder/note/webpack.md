# 打包流程

**初始化阶段：**

- 初始化参数：从配置文件、 配置对象、Shell 参数中读取，与默认配置结合得出最终的参数
- 创建编译器对象：用上一步得到的参数创建 Compiler 对象
- 初始化编译环境：包括注入内置插件、注册各种模块工厂、初始化 RuleSet 集合、加载配置的插件等
- 开始编译：执行 compiler 对象的 run 方法
- 确定入口：根据配置中的 entry 找出所有的入口文件，调用 compilition.addEntry 将入口文件转换为 dependence 对象
  **构建阶段：**
- 编译模块(make)：根据 entry 对应的 dependence 创建 module 对象，调用 loader 将模块转译为标准 JS 内容，调用 JS 解释器将内容转换为 AST 对象，从中找出该模块依赖的模块，再 递归 本步骤直到- 所有入口依赖的文件都经过了本步骤的处理
- 完成模块编译：上一步递归处理所有能触达到的模块后，得到了每个模块被翻译后的内容以及它们之间的 依赖关系图
  **生成阶段：**
- 输出资源(seal)：根据入口和模块之间的依赖关系，组装成一个个包含多个模块的 Chunk，再把每个 Chunk 转换成一个单独的文件加入到输出列表，这步是可以修改输出内容的最后机会
- 写入文件系统(emitAssets)：在确定好输出内容后，根据配置确定输出的路径和文件名，把文件内容写入到文件系统

# 名词

Entry：编译入口，webpack 编译的起点
Compiler：编译管理器，webpack 启动后会创建 compiler 对象，该对象一直存活知道结束退出
Compilation：单次编辑过程的管理器，比如 watch = true 时，运行过程中只有一个 compiler 但每次文件变更触发重新编译时，都会创建一个新的 compilation 对象
Dependence：依赖对象，webpack 基于该类型记录模块间依赖关系
Module：webpack 内部所有资源都会以“module”对象形式存在，所有关于资源的操作、转译、合并都是以 “module” 为基本单位进行的
Chunk：编译完成准备输出时，webpack 会将 module 按特定的规则组织成一个一个的 chunk，这些 chunk 某种程度上跟最终输出一一对应
Loader：资源内容转换器，其实就是实现从内容 A 转换 B 的转换器
Plugin：webpack 构建过程中，会在特定的时机广播对应的事件，插件监听这些事件，在特定时间点介入编译过程

# Webpack 编译过程会将源码解析为 AST 吗？webpack 与 babel 分别实现了什么？

构建阶段会读取源码，解析为 AST 集合。
Webpack 读出 AST 之后仅遍历 AST 集合；babel 则对源码做等价转换

# Webpack 编译过程中，如何识别资源对其他资源的依赖？

Webpack 遍历 AST 集合过程中，识别 require/ import 之类的导入语句，确定模块对其他资源的依赖关系

# 相对于 grant、gulp 等流式构建工具，为什么 webpack 会被认为是新一代的构建工具？

Grant、Gulp 仅执行开发者预定义的任务流；而 webpack 则深入处理资源的内容，功能上更强大
