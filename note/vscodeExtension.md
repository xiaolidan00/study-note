# vscode 插件开发

<https://code.visualstudio.com/api/get-started/your-first-extension>
<https://code.visualstudio.com/api/extension-guides/webview>

官方示例
https://github.com/microsoft/vscode-extension-samples

官方教程
https://vscode.js.cn/api/get-started/your-first-extension

```bash
# vscode插件开发脚手架
npm install -g yo generator-code


yo code
```

1. 点开 debug，调试，ctrl+shift+I 打开开发者中心
2. 调试时在DEBUG CONSOLE可以看查看打印变量

注意，要用 npm 安装才能打包成功，不能用 pnpm 否则会识别路径失败

```bash
# 打包vsix插件包
vsce package

# 登录用户
vsce login <publisher>
# 然后输入access token

# 发布插件
vsce publish
```

- publisher注册时，因为使用谷歌的验证码，可能要科学上网才能成功
- access token 在 Azure DevOps 注册用户和创建组织，然后再用户设置的 Personal Access Tokens.里面创建该组织下的 token
- 发布插件的时候不要开启 fastGithub，否则会验证失败
- 另外，一些临时文件不需要打包的文件请在`.vscodeignore` 里面标识忽略
