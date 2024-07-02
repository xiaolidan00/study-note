# 测试 jest,cypress

## jest

<https://www.jestjs.cn/>

<https://www.jianshu.com/p/eec5e34ff0c2>

```bash
pnpm add  -D @babel/core @babel/preset-env @babel/preset-typescript @types/jest babel-jest jest ts-jest  typescript
```

```json
 "scripts": {
    "build": "tsc",
    "test": "jest --config jest.config.js",
    "test-c": "jest --config jest.config.js --coverage"
  },
  "jest": {
  //使用node环境读取config
    "testEnvironment": "node"
  },
```

jest.config.js

```js
module.exports = {
  //test文件夹下
  roots: ['<rootDir>/test'],
  testRegex: 'test/(.+)\\.test\\.(jsx?|tsx?)$',
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node']
};
```

```ts
//sum.ts
export const sum = (a: number, b: number) => a + b;

//hello.ts
export const hello = (msg: string) => 'hello ' + msg;
```

test/sum.test.ts

```ts
import { sum } from '../sum';

describe('sum module', () => {
  test('adds 1 + 2 to equal 3', () => {
    expect(sum(1, 2)).toBe(3);
  });
  test('adds 0 + 2 to equal 2', () => {
    expect(sum(0, 2)).toBe(2);
  });
  test('adds 1 + 0 to equal 1', () => {
    expect(sum(1, 0)).toBe(1);
  });
});
```

test/hello.test.ts

```ts
import { hello } from '../src/hello';
import axios from 'axios';
test('hello world', () => {
  expect(hello('world')).toBe('hello world');
});

test('fetch data', () => {
  //测试接口
  return axios.get('http://xiaolidan00.top/getRandNum.php').then(({ data: res }) => {
    console.log(res);
    expect(res.data.length).toBe(10);
  });
});
```

`npm run test-c`

测试报告地址`coverage\lcov-report\index.html`

vscode 调试，`.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Jest All",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--config", "jest.config.js", "--runInBand"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "disableOptimisticBPs": true,
      "windows": {
        "program": "${workspaceFolder}/node_modules/jest/bin/jest"
      }
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Jest Current File",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["${fileBasenameNoExtension}", "--config", "jest.config.js"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "disableOptimisticBPs": true,
      "windows": {
        "program": "${workspaceFolder}/node_modules/jest/bin/jest"
      }
    }
  ]
}
```

- vue-test:<https://alexjover.com/blog/write-the-first-vue-js-component-unit-test-in-jest/>
- react:<https://www.jestjs.cn/docs/tutorial-react>

## my-cypress

<https://docs.cypress.io/>

全局安装

```bash
npm i -g cypress
```

创建测试

```bash
cypress open
```

本项目安装

```bash
pnpm add -D cypress
pnpm exec cypress open
```

测试用例

cypress\e2e\spec.cy.js

```js
describe('template spec', () => {
  it('passes', () => {
    cy.visit('http://127.0.0.1:5500/index.html');
    cy.get('h1').should('have.length', 4);
  });
  it('api', () => {
    cy.request({
      url: 'http://xiaolidan00.top/getRandNum.php',
      method: 'GET'
    }).then((res) => {
      expect(res.body.data).to.have.length(10);
    });
  });
});


```
