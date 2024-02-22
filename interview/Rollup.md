# Rollup 的核心概念是什么？

- Rollup 的核心概念是将小块的代码（模块）编译成大块的代码（库或应用程序），它支持 ES6 模块，并提供了 Tree-shaking 功能来移除未使用的代码。

# Rollup 如何处理模块解析？

- Rollup 使用 `@rollup/plugin-node-resolve` 插件来解析 Node.js 模块，它能够处理 CommonJS 和 ES6 模块。此外，还可以通过 `@rollup/plugin-commonjs` 插件来支持 CommonJS 模块。

# 什么是 Tree-shaking，Rollup 如何实现它？

- Tree-shaking 是一种去除未使用代码的技术。Rollup 在构建过程中会分析模块之间的依赖关系，只包含实际被引用的代码，从而减小最终打包文件的大小。

# Rollup 如何处理外部依赖？

- Rollup 使用 `external` 选项来指定哪些模块应该被视为外部依赖，这些模块在最终的打包文件中不会被包含，而是在运行时通过模块系统（如 npm 或者 CDN）加载。

# Rollup 支持哪些输出格式？

- Rollup 支持多种输出格式，包括 AMD、CJS（CommonJS）、ESM（ES6 模块）、IIFE（立即执行函数表达式）、UMD（通用模块定义）和 SystemJS。

# 如何配置 Rollup 的入口文件和输出文件？

- 在 Rollup 的配置文件（通常是 `rollup.config.js`）中，可以通过 `input` 选项指定入口文件，通过 `output` 选项指定输出文件的路径、格式和名称。

# Rollup 如何处理 TypeScript 文件？

- Rollup 可以通过 `@rollup/plugin-typescript` 插件来处理 TypeScript 文件，这个插件会将 TypeScript 编译成 JavaScript，然后 Rollup 再进行打包。

# Rollup 和 Webpack 的主要区别是什么？

- Rollup 更专注于库的打包，它提供了更好的 Tree-shaking 支持，而 Webpack 更适合应用级别的打包，它提供了更丰富的插件生态和更复杂的构建流程。

# Rollup 如何处理热模块替换（HMR）？

- Rollup 本身不支持 HMR，但可以通过配置 `watch` 选项来实现文件变化时的自动重新打包。

# Rollup 如何处理 CSS 和图片等静态资源？

Rollup 可以通过 `@rollup/plugin-url` 插件来处理 URL 引用的静态资源，如图片和字体。对于 CSS，可以使用 `@rollup/plugin-css-only` 或 `rollup-plugin-postcss` 等插件。

# 如何优化 Rollup 的构建速度？

可以通过配置 `cache` 选项来缓存构建结果，或者使用 `terser` 插件来压缩代码，减少文件大小。

- 代码分割（Code Splitting）：将代码拆分成多个独立的文件，以提高加载性能。您可以使用 Rollup 的代码分割功能将代码按功能或模块拆分成多个文件。
- 压缩输出文件：通过使用压缩插件，如 terser，可以减小输出文件的大小，提高加载速度。
- 缓存构建结果：使用缓存来保存构建结果，以便在下次构建时重用，从而减少构建时间。
- 配置插件：根据项目需求选择合适的插件，并根据实际情况进行配置，以满足特定的构建需求。
- 优化模块导入：尽量减少模块的导入数量，避免重复导入相同的模块，以减少构建时间和输出文件的大小

# Rollup 的构建流程是怎样的？

Rollup 的构建流程包括解析模块、构建依赖图、处理模块（通过插件）、生成输出文件等步骤。

Rollup 的构建流程主要包括以下几个步骤：

- 解析入口文件：Rollup 会读取您指定的入口文件，并解析其中的代码和依赖关系。
- 加载模块：Rollup 会根据解析结果加载入口文件及其依赖的其他模块。
- 转换代码：如果您使用了 Babel 等插件来转换代码，Rollup 会在加载模块后应用这些转换。
- 合并模块：Rollup 会将所有加载的模块合并成一个单独的输出文件。
- 输出文件：Rollup 会将合并后的代码输出到您指定的输出文件中。

# 使用 rollup-plugin-visualizer：

安装并使用 rollup-plugin-visualizer 插件来分析打包后的文件大小分布，这有助于识别和移除不必要的依赖。
