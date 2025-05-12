# vue2 项目升级

## webpack4 升级成 webpack5

vue-cli4 是 webpack4

vue-cli5 是 webpack5

```json
 "dependencies": {
    "core-js": "^3.8.3",
    "vue": "^2.6.14",
    "vue-router": "^3.5.1",
    "vuex": "^3.6.2"
  },
  "devDependencies": {
    "@babel/core": "^7.12.16",
    "@babel/eslint-parser": "^7.12.16",
    "@vue/cli-plugin-babel": "~5.0.0",
    "@vue/cli-plugin-eslint": "~5.0.0",
    "@vue/cli-plugin-router": "~5.0.0",
    "@vue/cli-plugin-vuex": "~5.0.0",
    "@vue/cli-service": "~5.0.0",
    "eslint": "^7.32.0",
    "eslint-config-prettier": "^8.3.0",
    "eslint-plugin-prettier": "^4.0.0",
    "eslint-plugin-vue": "^8.0.3",
    "prettier": "^2.4.1",
    "vue-template-compivler": "^2.6.14"
  }
```

vue.config.js

```js
const {defineConfig} = require('@vue/cli-service');
module.exports = defineConfig({
  configureWebpack: {
    //没有该选项
    //devtool: 'cheap-module-eval-source-map',
  },
  devServer: {
    //没有该选项
    // disableHostCheck: true,
  }
});
```

## eslint

eslintrc.js

`vue/max-attributes-per-line`失效注释掉

## webpack < 5 used to include polyfills for node.js core modules by default

https://blog.csdn.net/qq_45796592/article/details/137104774

```js
const NodePolyfillPlugin = require('node-polyfill-webpack-plugin'); // 引入

module.exports = defineConfig({
  configureWebpack: {
    plugins: [new NodePolyfillPlugin()]
  }
});
```

## sass 变量 :export

`variables.scss`=>`variables.module.scss`模块变量
更新变量路径

## common.js 和 esmodule 混用的情况下不要开启

`transpileDependencies: true`注释掉或删除
该属性默认只能用 esmodule
