# webpack4 升级 webpack5 注意

- dev-server=>`webpack serve --config build/webpack.dev.js`
- `const {merge}=require('webpack-merge')`
- `const {CleanWebpackPlugin}=require('clean-webpack-plugin')`
- `module.rules`中 loader:['xxx-loader']=>use:['xxx-loader']
- `filename:'build.[contenthash:8].js'`,Hash 不能

# webpack 配置

- 公共配置，不同模式特有配置，merge
- 多入口
- 抽离 css
- 抽离公共代码
- 懒加载
- 处理 jsx,react,vue
  **babel 配置**
  react:@babel/preset-react
  vue:vue-loader

```js
const ASSET_PATH = process.env.ASSET_PATH || '/';
module.exports = {
  mode: 'development', //模式
  devtool: 'inline-source-map',
  //入口文件
  entry: './src/index.js',
  entry: {
    index: {
      import: './src/index.js',
      dependOn: 'shared' //设置共享模块
    },
    another: {
      import: './src/another-module.js',
      dependOn: 'shared'
    },
    shared: 'lodash'
  },
  entry: {
    home: ['./home.js', './home.scss'],
    account: ['./account.js', './account.scss']
  },
  output: {
    //输出
    filename: '[name].[contenthash].js',
    path: path.resolve(__dirname, 'dist'),
    clean: true, //清除遗留文件夹
    publicPath: '/',
    //输出资源名
    assetModuleFilename: 'images/[hash][ext][query]'
  },
  //运行优化
  optimization: {
    //压缩css
    minimizer: [new TerserJSPlugin({}), new OptimizeCSSAssetsPlugin({})],
    splitChunks: {
      chunks: 'all',
      /**
       * initial入口chunk,对于异步导入的文件不处理
       * async 异步chunk,只对异步导入的文件处理
       * all 全部chunk
       */
      //缓存分组
      cacheGroups: {
        //第三方模块
        vendor: {
          name: 'vendors', //chunk名称
          test: /node_modules/,
          priority: 1, //权限更高，优先抽离
          minSize: 0, //大小限制
          minChunks: 1 //最少复用过次数
        },
        //公共模块
        common: {
          name: 'common',
          priority: 0, //权限更高，优先抽离
          minSize: 0, //大小限制
          minChunks: 2 //最少复用过次数
        }
      }
    },
    //--------------

    usedExports: true, //删除掉未被引用的 export
    moduleIds: 'deterministic', ///第三方库不变
    runtimeChunk: 'single', //
    splitChunks: {
      chunks: 'all' //将公共的依赖模块提取到已有的入口 chunk 中
    },
    //第三方库提取到单独的 vendor chunk 中
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        }
      }
    }
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        //明确范围
        include: path.resolve(__dirname, 'src'),
        exclude: path.resolve(__dirname, 'node_modules'),
        use: ['babel-loader?cacheDirectory'] //开启缓存
      },

      //sass
      {
        test: /\.scss$/,
        use: [
          // fallback to style-loader in development
          process.env.NODE_ENV !== 'production' ? 'style-loader' : MiniCssExtractPlugin.loader, //生产环境抽离css
          'css-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.css$/i,
        //从后往前执行
        use: ['style-loader', 'css-loader', 'postcss-loader'] //加载css
        //style-loader将css注入<style></style>
        //postcss-loader 兼容css autoprefixer增加前缀
      },

      //处理图片
      { test: /\.(png|svg|jpg|jpeg|gif)$/i, use: ['file-loader'] },
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        use: {
          loader: 'url-loader',
          option: {
            limit: 5 * 1024,
            outputPath: '/images/'
          }
        }
      },
      //vue
      { test: /\.vue$/i, use: ['vue-loader'] },
      //--------------
      {
        loader: 'ts-loader',
        options: {
          transpileOnly: true
        }
      },
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      },

      //将某些资源发送到指定目录
      {
        test: /\.html/,
        type: 'asset/resource',
        generator: {
          filename: 'static/[hash][ext][query]'
        },
        //作为 data URI 注入
        test: /\.svg/,
        type: 'asset/inline',
        //转base64文件内容
        generator: {
          dataUrl: (content) => {
            content = content.toString();
            return svgToMiniDataURI(content);
          }
        },
        //webpack 将按照默认条件，自动地在 resource 和 inline 之间进行选择：小于 8kb 的文件
        //将会视为 inline 模块类型，否则会被视为 resource 模块类型
        parser: {
          dataUrlCondition: {
            maxSize: 4 * 1024 // 4kb
          }
        }
      },
      //通过使用 imports-loader 覆盖 this 指向
      {
        test: require.resolve('./src/index.js'),
        use: 'imports-loader?wrapper=window'
      },
      //将一个全局变量作为一个普通的模块来导出
      {
        test: require.resolve('./src/globals.js'),
        use: 'exports-loader?type=commonjs&exports=file,multiple|helpers.parse|parse'
      },

      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i, //加载图片
        type: 'asset/resource'
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/i, //加载字体
        type: 'asset/resource'
      },
      //加载数据
      {
        test: /\.(csv|tsv)$/i,
        use: ['csv-loader']
      },
      {
        test: /\.xml$/i,
        use: ['xml-loader']
      }
    ]
  },
  devServer: {
    port: 8080,
    hot: true, //HMR热更替
    //设置代理
    proxy: {
      '/api': ''
    }
  },
  plugins: [
    //多入口
    new HtmlWebpackPlugin({
      template: path.join(srcPath, 'index.html'),
      title: '管理输出', //替换html的<% title %>
      chunks: ['index', 'vendor', 'common'] //代码分割
    }),
    new HtmlWebpackPlugin({
      template: path.join(srcPath, 'test.html'),
      title: 'test',
      chunks: ['test', 'common']
    }),
    new CleanWebpackPlugin(), //清空output文件夹
    //压缩css
    new MiniCssExtractPlugin({
      filename: '[name].css',
      extract: true //抽离成外部的css
    }),
    //----------
    // 这可以帮助我们在代码中安全地使用环境变量
    new webpack.DefinePlugin({
      'process.env.ASSET_PATH': JSON.stringify(ASSET_PATH)
    }),

    //全局依赖，Shimming 预置全局变量
    new webpack.ProvidePlugin({
      _: 'lodash',
      join: ['lodash', 'join']
    })
  ]
};

//使用环境变量
module.exports = (env) => {
  // Use env.<YOUR VARIABLE> here:
  console.log('Goal: ', env.goal); // 'local'
  console.log('Production: ', env.production); // true

  return {
    entry: './src/index.js',
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
};

//运行热更替
const compiler = webpack(config);

// `hot` and `client` options are disabled because we added them manually
const server = new webpackDevServer({ hot: false, client: false }, compiler);

(async () => {
  await server.start();
  console.log('dev server is running');
})();

import('./list.js').then((res) => {
  console.log(res.default);
});
```

## 解释 tree shaking 和 sideEffects

sideEffects 和 usedExports（更多被认为是 tree shaking）是两种不同的优化方式。

sideEffects 更为有效 是因为它允许跳过整个模块/文件和整个文件子树。

usedExports 依赖于 terser 去检测语句中的副作用。它是一个 JavaScript 任务而且没有像 sideEffects 一样简单直接。而且它不能跳转子树/依赖由于细则中说副作用需要被评估。尽管导出函数能运作如常，但 React 框架的高阶函数（HOC）在这种情况下是会出问题的。

# module,chunk,bundle 的区别

- module:各个源文件，可以引入的，webpack 中一切皆模块
- chunk:多模块合成的，如 entry,import(),splitChunk
- bundle：最终的输出文件

# webpack 性能优化-构建速度

- 优化 babel-loader
- ignorePlugin 避免引入无用模块
- noParse 避免重复打包
- happyPack 多进程打包
- ParallelUglifyPlugin 多进程压缩 js

**不可用于生产环境**

- 自动刷新：整个网页刷新，速度慢，状态丢失，
- 热更新：新代码剩下，网页不刷新，状态不丢失
- DllPlugin 动态链接库， 体积大，稳定的库只构建一次。

多进程对大项目打包慢的能提高速度，小项目增加进程开销反而变慢

```js
import moment from 'moment';
import 'moment/locale/zh-cn';
moment.locale('zh-cn'); //设置语言为中文
console.log(moment.local());

plugins:[
new webpack.IgnorePlugin(/\.\/locale/, 'moment');
]

module:{
    //独完整的react.min.js文件没有采用模块化
    //忽略对该文件的递归解析处理
    noParse:[/react\.min\.js$/]
}

//HappyPack开启多进程打包
module:{
    rules:[
        {test:/\.js$/,
        //将js文件的处理转交给id为babel的happypack实例
        use:['happypack/loader?id=babel'],
        include:srcPath
        }
    ]
}
plugins:[
    new HappyPack({
        //用来处理一类特定的文件
        id:'babel',
        loaders:['babel-loader?cacheDirectory']
    })
]
//ParallelUglifyPlugin并行压缩输出js
new ParallelUglifyPlugin({
    uglifyJS:{
        output:{
            beatify:false,//最紧凑的输出
            comments:false//删除所有的注释
        },
        compress:{
            //删除所有的console,可兼容id
            drop_console:true,
            //内嵌定义了但是只用一次的变量
            collapse_vars:true,
            //提取出现多次但没有定义成变量去引用的静态值
            reduce_vars:true
        }
    }
})


//自动刷新
module.exports = {
  watch:true,
  watchOptions: {
    //当第一个文件更改，会在重新构建前增加延迟。
    //这个选项允许 webpack 将这段时间内进行的任何其他更改都聚合到一次重新构建里。以毫秒为单位
    aggregateTimeout: 200,
    //通过传递 true 开启 polling，将会设置默认轮询间隔为 5007，或者指定毫秒为单位进行轮询。
    poll: 1000,
    //对于某些系统，监听大量文件会导致大量的 CPU 或内存占用。可以使用正则排除像 node_modules 如此庞大的文件夹：
    ignored: /node_modules/,
  },
};



//热更新
const HotModuleReplacementPlugin

entry:{
    index:['webpack-dev-server/client?http:localhost:8080/','webpack/hot/dev-server',path.join(srcPath,'index.js')]
}

new HotModuleReplacementPlugin({

})
//开启热更新后的代码逻辑
if (module.hot) {
    //监听热更新模块
  module.hot.accept(['./library.js'], function() {
    // 对更新过的 library 模块做些事情...
  });
}
//DllPlugin
// 1. dllPlugin打包出dll文件
entry:{
    react:['react','react-dom']
},
output:{
    file:'[name].dll.js',
    path:distPath,
    library:'_dll_[name]'
}
new webpack.DllPlugin({
//动态链接库全局变量名称
  name: '_dll_[name]',
  //描述动态链接库manifest.json文件输出是的名称
  path: path.join(distPath, '[name].manifest.json'),
});

// 2. dllReferencePlugin使用dll文件
//告诉webpack使用了那些动态链接库
new webpack.DllReferencePlugin({
//描述react动态链接库的文件内容
  manifest: require(path.join(distPath, 'react.manifest.json')),

});

```

# webpack 性能优化-产出代码

- 体积更小
- 合理分包，不重复加载
- 速度快，内存使用更少

- 小图片 base64 编码
- bundle 加 hash
- 懒加载
- 提取公共代码，代码分割
- IgnorePlugin
- 使用 CDN 加速：publicPath 添加前缀，将 js 文件上传到 CDN
- 使用 production
- Scope Hosting:合并文件，减少作用域

**使用 production**

- 自动压缩代码
- Vue React 等会自动删除掉调试代码(如开发环境的 warning)
- 启动 tree-shaking：删除没有用到的函数，es Module 才能生效

**Scope Hosting**

- 代码体积更少
- 创建函数作用域更少
- 代码可读性更好

```js
resolve: {
  //正对npm中第三方模块优先采用，jsnext:main中指向的es6模块化语法的文件
  mainFields: ['jsnext:main', 'browser', 'main'];
}
//开启Scope Hosting
new webpack.optimize.ModuleConcatenationPlugin();
```

# esmodule 与 commonJs 区别

- esmodule 静态引入，编译时引入
- commonJs 动态引入，执行时引入
- 只有 es module 才能静态分析， 实现 tree-shaking

```js
let a = require('./config.base.js');
if (isDev) {
  a = require('./config.dev.js');
}

import a from './config.base.js';
if (isDev) {
  //编译时报错，只能静态引入
  import a from './config.dev.js';
}
```

# babel

```js
@babel/cli

@babel/core
@babel/plugin-transform-runtime
@babel/preset-env
@babel/preset-react//jsx
@babel/preset-typescript

@babel/polyfill//兼容支持当前浏览器的方法，添加新语法
@babel/runtime//命名成_Promise不重名,第三方库用这个
```

**polyfill**

- core-js ：集成了新语法的库
- regenerator-runtime： generator-yeild 的语法库
- Babel7.4 弃用 babel-polyfill,推荐直接使用两个库

```js
require('@babel/polyfill');
Promise.resolve(100).then((data) => data);
```

polyfill 问题

- 污染全局环境=》重名问题

**.babelrc**

presets 插件集合

```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        //按需引入polyfill
        "useBuiltIns": "usage",
        "corejs": 3 //最新版本3
      }
    ]
  ]，
  "plugins":[
    ["@babel/plugin-transform-runtime",
        {
            "absoluteRuntime":false,
            "corejs":3,
            "helpers":true,
            "regenerator":true,
            "useESModules":false
        }
    ]
  ]
}
```

# 前端为什么要打包和构建

**代码层面**

- 体积更小（tree-shaking，压缩，合并），加载更快
- 编译高级语言或语法（ts,es6+,模块化,scss)
- 兼容性和错误检查（polyfill，postcss,eslint)

**项目管理**

- 统一、高效的开发环境
- 统一构建流程和产出标准
- 集成了公司构建规范（提测、上线等）

# loader 和 plugin 区别

- loader 模块转换器，编译阶段，如 scss->css
- plugin 扩展插件，作用于生命周期，如 htmlwebpackPlugin

常用 loader

常用 plugin

# babel 和 webpack 区别

- babel:js 新语法编译工具，不关心模块化
- webpack：打包构建工具，是多个 loader plugin 的集合

# 打包 library

```js
output: {
  library: 'my-lib';
}
```

# webpack 懒加载

- import()
- 异步组件：vue:defineAsyncComponent,react:lazy
- 异步加载路由：vue：import(),react:lazy

# Proxy 不能被 Polyfill

可以 Polyfill

- class 可以用 funciton
- promise 可以用 callback
- Proxy 不能用 Object.defineProperty
