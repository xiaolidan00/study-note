《Typescript+React Web》应用开发实战-王金柱

# typescript编译器

<https://github.com/microsoft/TypeScript>

- scanner.ts 扫描器：负责对ts源码进行扫描预处理，将源码转译为token数据流
- parser.ts 解析器：负责进行语法分析，将token数据流生成为抽象语法树ast
- binder.ts 绑定器：使用一个Symbol符号将相同结构的声明联合在一起，帮助类型系统推导出具体的声明。
- checker.ts 检查器：负责类型检查工作，是必不可少的功能
- emitter.ts 发射器和transformer.ts代码转换：实现JavaScript(.js)转译代码，声明(d.ts)或source maps(.js.map)文件的生成。

## ts源码编译流程

```txt
                                                                    类型检查
                                                                    ^
                                                                    |
                                                        ------->checker检查器<-------
                                                        |                           |
typescript源码->scanner扫描器->token数据流->parser解析器->ast抽象语法树->binder绑定器->symbol符号
                                                            |
                                                            emitter发射器<——chekcer检查器
                                                            |
                                                            javascript转译代码

```

1. typescript源码->ast抽象语法树：typescript源码经过scanner扫描器解析为token数据流，再由parser解析器将token数据流解析为ast语法树
2. ast抽象语法树->symbol符号：ast抽象语法树经过binder绑定器解析为symbol符号
3. ast抽象语法树+symbol符号->类型检查功能：ast抽象语法树+symbol符号经过checker实现类型检查功能
4. ast抽象语法树+checker检查器->javascript代码：ast抽象语法树+checker检查器经过emitter发射器解析为最终JavaScript转译代码

# typescript编译器主要架构

- 语言服务：services.ts:vs 管理语言服务，editors，vs shim(shims.ts)，tsserver(server.ts)
- 独立ts编译器：tsc.ts
- 核心typescript编译器(core.ts,scanner.ts,parser.ts,binder.ts,checker.ts,transformer.ts,emitter.ts)

core.ts定义了typescript语法的核心概念，常量描述，以及主要的工具函数等。
