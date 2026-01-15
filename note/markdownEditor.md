# xnote

## CodeMirror markdown 编辑器

https://codemirror.net/

https://github.com/codemirror/lang-markdown

```js
import {EditorView, basicSetup} from 'codemirror';
import {markdown} from '@codemirror/lang-markdown';

const view = new EditorView({
  parent: document.body,
  doc: `*CodeMirror* Markdown \`mode\``,
  extensions: [basicSetup, markdown()]
});
```

## yjs 同步

## 预览样式 typora

`D:\softwares\Typora\resources\app\style\themes`

## 功能列表

- markdown 语法支持
  - 标题
  - 代码块，同行代码块
  - 有序列表，无序列表
  - 链接
  - 图片
  - 表格
  - 目录
  - 分割线
  - 任务列表，任务状态
  - 加粗
  - 斜体
  - 下划线
  - 删除线
- 操作细节
  - 格式化
  - 列表缩进子列表
  - 复制解析生成 markdown
  - 纯文本和带样式的复制
  - 导出 HTML，PDF
  - 查找替换高亮
  - 文件目录栏方便切换
  - 预览与编辑切换
  - 字数统计，选择文本数量统计
  - 新窗口打开
  - 快捷键：Ctrl+S 保存，Ctrl+B 加粗，Ctrl+A 全选，Ctrl+C 复制，Ctrl+V 粘贴，Ctrl+F 查找，Ctrl+H 替换
  - 历史记录，撤销，重做
- 云同步
- 打开文件导入
