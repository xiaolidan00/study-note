# Vite 自定义Markdown Plugin

<https://rollupjs.org/plugin-development/#transform>
<https://cn.vitejs.dev/guide/api-plugin#universal-hooks>
plugin同rollup的plugin的生命周期，只不过通过vite的格式封装起来

```ts
import { type Plugin } from 'vite';
import markdownit from 'markdown-it';
import hljs from 'highlight.js';

const md = markdownit({
  linkify: true,
  //markdown code 高亮
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        return (
          '<pre><code class="hljs">' +
          hljs.highlight(str, { language: lang, ignoreIllegals: true }).value +
          '</code></pre>'
        );
      } catch (__) {}
    }

    return '<pre><code class="hljs">' + md.utils.escapeHtml(str) + '</code></pre>';
  }
});
let count = 1;
const fileRegex = /\.(md)$/;
export default function markdownPlugin(): Plugin {
  return {
    // 插件名称
    name: 'vite:markdown',
    //使用时机，是编译前还是编译后
    enforce: 'pre',
    // 代码转译，这个函数的功能类似于 `webpack` 的 `loader`，编译输出为js可读的文件
    transform(code, id, opt) {
      //匹配要处理的文件类型
      if (fileRegex.test(id)) {
        console.log(count, id);
        count++;
        return { code: `export default \`<section>${md.render(code)}</section>\``, map: null };
      }
    },
    //构建完成要执行的处理脚本
    buildEnd: (a) => {
      console.log('hahahaah');
    }
  };
}
```

transform返回对象

```ts
type TransformResult = string | null | Partial<SourceDescription>;

interface SourceDescription {
 code: string;
 map?: string | SourceMap;
 ast?: ESTree.Program;
 attributes?: { [key: string]: string } | null;
 meta?: { [plugin: string]: any } | null;
 moduleSideEffects?: boolean | 'no-treeshake' | null;
 syntheticNamedExports?: boolean | string | null;
}

```

vite使用自定义plugin

```ts
import { defineConfig } from 'vite';
import markdownPlugin from './plugins/markdownPlugin';

export default defineConfig({
  plugins: [markdownPlugin(), htmlPlugin()],

  build: {
    rollupOptions: {
      input: './src/index.ts'
    }
  }
});

```

# webapack loader

将源码编译处理解析成js可以理解的代码

```js
const markdownit = require('markdown-it');
const md = markdownit();
module.exports = function loader(source) {
  const options = this.query;
  let content = source.toString();
  for (let k in options) {
    content = content.replaceAll(k, options[k]);
  }
  return `export default \`${md.render(content)}\``;
};
```

自定义cleanPlugin,编译后先删除之前的结果

```js
function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}
const path = _interopRequireDefault(require('path'));
const fs = _interopRequireDefault(require('fs'));

class CleanPlugin {
  constructor() {}

  apply(compiler) {
    const pluginName = 'CleanPlugin';
    const outputPath = compiler.options.output.path;
    if (!path) return;

    compiler.hooks.emit.tap(pluginName, () => {
      const distPath = path.default.resolve(process.cwd(), outputPath);
      const files = fs.readdirSync(distPath);
      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const filename = path.default.resolve(distPath, file);
        console.log(filename);
        fs.unlinkSync(filename);
      }
    });
  }
}

module.exports = CleanPlugin;

```

编译生成资源列表markdown

```js
const defaultOptions = {
  outputFile: 'assets.md'
};
class FileListPlugin {
  constructor(options = {}) {
    this.options = { ...defaultOptions, ...options };
  }

  apply(compiler) {
    const pluginName = 'FileListPlugin';
    const { webpack } = compiler;

    // Compilation 对象提供了对一些有用常量的访问。
    const { Compilation } = webpack;

    // RawSource 是其中一种 “源码”("sources") 类型，
    // 用来在 compilation 中表示资源的源码
    const { RawSource } = webpack.sources;
    compiler.hooks.thisCompilation.tap(pluginName, (compilation) => {
      // 绑定到资源处理流水线(assets processing pipeline)
      compilation.hooks.processAssets.tap(
        {
          name: pluginName,

          // 用某个靠后的资源处理阶段，
          // 确保所有资源已被插件添加到 compilation
          stage: Compilation.PROCESS_ASSETS_STAGE_SUMMARIZE
        },
        (assets) => {
          // "assets" 是一个包含 compilation 中所有资源(assets)的对象。
          // 该对象的键是资源的路径，
          // 值是文件的源码

          // 遍历所有资源，
          // 生成 Markdown 文件的内容
          const content =
            '# In this build:\n\n' +
            Object.keys(assets)
              .map((filename) => `- ${filename}`)
              .join('\n');

          // 向 compilation 添加新的资源，
          // 这样 webpack 就会自动生成并输出到 output 目录
          const d = new Date();
          const str =
            d.getFullYear() +
            '-' +
            (d.getMonth() + 1) +
            '-' +
            d.getDate() +
            '-' +
            d.getHours() +
            '-' +
            d.getMinutes() +
            '-' +
            d.getSeconds();
          compilation.emitAsset(str + this.options.outputFile, new RawSource(content));
        }
      );
    });
  }
}

module.exports = FileListPlugin;

```

使用loader和plugin

```js
const path = require('path');
const CleanPlugin = require('./plugins/CleanPlugin');
const FileListPlugin = require('./plugins/FileListPlugin');
module.exports = {
  entry: {
    index: './src/index.js'
  },
  output: {
    // library: {
    //   type: 'commonjs2'
    // },
    path: path.resolve(__dirname, 'dist'),
    filename: '[name]-[contenthash].js'
  },
  module: {
    rules: [
      {
        test: /\.md$/,
        // type: 'asset/resource',
        // type: 'asset/source',
        use: [
          //   'raw-loader',
          {
            loader: 'markdownloader',
            options: {
              _AAA_: 'Hello world'
            }
          }
        ]
      }
    ]
  },
  resolveLoader: {
    modules: ['node_modules', path.resolve(__dirname, 'loaders')]
  },
  plugins: [
    new CleanPlugin(),
    new FileListPlugin({
      outputFile: 'result.md'
    })
  ]
};

```
