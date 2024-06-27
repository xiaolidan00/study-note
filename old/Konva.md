---
highlight: vs
theme: fancy
---
最近开发个web版的Excel表格，为了渲染性能，采用canvas画单元格，然后就用到了konva了，然后发现了一些坑。

# 1.有时候奇怪的图形重复画

已有的形状改变大小和位置，然后竟然原来的位置还有这个图形

【解决方案】删掉原来的重画

```js
//保存之前的动作监听
let listener=shape.eventListeners
//删掉
shape.destory()
//重新new一个
shape=new Konva.Shape({....})
//把动作监听赋值到新的形状
shape.eventListeners=listener
layer.add(shape)
```

# 2.字体和大小没反应

明明赋值了fontFamily和fontSize但就是不改变，那是因为字体引用出问题了

【解决方案】引入对应的字体

```css
@font-face {
  font-family: 微软雅黑, Microsoft YaHei;
  src: url('./font/msyh.ttf');
}
```

# 3.文本高度超过了范围没有隐藏超出部分

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/766c62956be142c28cfe69c592425afb~tplv-k3u1fbpfcp-watermark.image?)

【解决方案】

1. 计算text高度，扩展行高度，不能少于这个高度，保证包含文本

2. 创建一个新的canvas绘制对应文本，让新canvas帮你自动截取，再将内容作为image画到原来的canvas

#
