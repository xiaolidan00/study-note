---
theme: fancy
highlight: vs
---

**组件定义：** 组件是对数据和方法的简单封装，是软件中具有相对独立功能、接口由契约指定、和语境有明显依赖关系、可独立部署、可组装的软件实体。

一个优秀的组件应该保证：

- 功能内聚
- 样式统一
- 与父元素仅通过 Props 通信

# 1. WebComponents

WebComponents 是一套不同的技术，允许你创建可重用的定制元素（它们的功能封装在你的代码之外）并且在你的 web 应用中使用它们。

目前支持`WebComponents`的浏览器使用比例占比`96%`左右，与 Vue3 用到的核心特性`Proxy`占比相近，可见大部分浏览器兼容都能兼容`WebComponents`特性。

另外如果有兼容性问题可以使用官方的 PollyFill 解决

- [@webcomponents/webcomponentsjs](https://www.jsdelivr.com/package/npm/@webcomponents/webcomponentsjs)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/8a6859f097dd4f11add54120bdfdf8dd~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=YhW1ABu7K%2BUtld7mwiGIvhr%2BARw%3D)
![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0d5652f467be42369c2a1493261bb138~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=ZcUoxkD9gwHFUM6FoZuIg85IcGM%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/d7a6d0074ae84c409bd84766db6aa635~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=5lrKzqtPBKqMLZscN2Ll6RppIvA%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/77463709ebd44b8795e18299d5ebfff7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=d%2BbF3kz1UOolnXp20k28BJyoPMs%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/9a7f62cd83ba40fd93073d6d6f9418d8~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=aaPBjYLNiALeeY87nkuzIikhnnk%3D)

# 2. 第一个 WebComponents

## 2.1 生命周期

官方说明：

- `connectedCallback()`：每当元素添加到文档中时调用。
- `disconnectedCallback()`：每当元素从文档中移除时调用。
- `adoptedCallback()`：每当元素被移动到新文档中时调用。该生命周期使用得比较少。
- `attributeChangedCallback()`：在属性更改、添加、移除或替换时调用。

```ts
class HelloWorldElement extends HTMLElement {
  constructor() {
    super();
    //可以做一些初始化操作
    this.style.fontWeight = 'bold';
    this.style.display = 'block';
  }
  connectedCallback() {
    console.log('自定义元素添加至页面。');
  }

  disconnectedCallback() {
    console.log('自定义元素从页面中移除。');
  }

  adoptedCallback() {
    console.log('自定义元素移动至新页面。');
  }

  //需要监听的属性名
  static observedAttributes = ['color', 'size'];
  //属性值改变
  attributeChangedCallback(name: string, oldValue: string, newValue: string) {
    console.log(`属性 ${name} 已变更。`);
    switch (name) {
      case 'color':
        this.style.color = newValue;
        break;

      case 'size':
        this.style.fontSize =
          newValue === 'small' ? '12px' : newValue === 'large' ? '20px' : '16px';
        break;
    }
  }
}
```

**注意：**

- 需要设置`observedAttributes`监听属性名数组才能在`attributeChangedCallback`监听到属性变化。

```ts
//第一种设置方式
 static observedAttributes = ['color', 'size'];
 //第二种设置方式
  static get observedAttributes() {
    return ["color", "size"];
  }
```

- `attributeChangedCallback`:监听属性值改变，不论是否添加到页面都会触发，初始化和属性增删和值变化都会被监听到，类似于`vue watch immediate开启`监听响应式数据变化。

- `connectedCallback`类似于`vue mounted`生命周期，`disconnectedCallback`类似于`vue unmounted`生命周期，一些定时器，动作监听等需要在这里注销

## 2.2 注册自定义组件

自定义组件有两种类型：

- 独立自定义元素：继承自 HTML 元素基`HTMLElement`，并从头开始实现。
- 自定义内置元素：继承自标准的 HTML 元素，例如`HTMLParagraphElement`。它们的实现定义了标准元素的行为。

**注意：** 自定义组件注册名称必须使用`小写字母`加`横杠-`

**注册独立自定义元素**

```ts
class HelloWorldElement extends HTMLElement {
  //...
}
//判断组件是否被注册
if (!window.customElements.get('hello-world')) {
  //未注册组件名，则进行自定义组件注册
  window.customElements.define('hello-world', HelloWorldElement);
} else {
  console.log('hello-world组件名已注册');
}
```

**注册自定义内置元素**

自定义内置元素，class 类要继承对应的内置元素，注册是也要配置继承对应的内置元素。

```ts
class HelloWorldElement extends HTMLParagraphElement {
  //...
}
//判断组件是否被注册
if (!window.customElements.get('hello-world')) {
  //继承p元素
  customElements.define('hello-world', HelloWorldElement, {extends: 'p'});
} else {
  console.log('hello-world组件名已注册');
}
```

## 2.3 创建自定义元素

**第一种方式：html 字符串（仅适用于独立自定义元素）**

```ts
{
  const content = document.createElement('div');
  content.innerHTML = '<hello-world color="blue" size="large">PPPPP</hello-world>';
  document.body.appendChild(content);
}
```

**第二种方式：class 实例（适用于独立自定义元素和自定义内置元素）**

```ts
const hello = new HelloWorldElement();
hello.innerHTML = 'PPPPP';
hello.setAttribute('size', 'large');
hello.setAttribute('color', 'blue');
document.body.appendChild(hello);
```

**注意：** 需要使用`setAttribute`方法赋值属性才能触发`attributeChangedCallback`生命周期。

**第三种方式：`document.createElement`方法创建（仅适用于独立自定义元素）**

```ts
const hello = document.createElement('hello-world');
hello.innerHTML = 'PPPPP';
hello.setAttribute('size', 'large');
hello.setAttribute('color', 'blue');
document.body.appendChild(hello);
```

**第四种方式：内置元素`is`属性（仅适用于自定义内置元素）**

```ts
const content = document.createElement('div');
content.innerHTML = '<p is="hello-world" color="blue" size="large">PPPPP</p>';
document.body.appendChild(content);
```

以上四种方式创建自定义元素，最终的效果都是一样的

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0abe4f4ea5d444259db4c21546e8b916~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=4IO8JKtxtFDD6Evn5q9eYw0XKXM%3D)

# 3. 样式与 Shadow DOM

## 3.1 自定义元素设置样式

自定义元素可以直接使用全局样式

```css
custom-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  height: 40px;
  line-height: 40px;
  background: blue;
  color: white;
  padding: 0 10px;
  cursor: pointer;
}
custom-button:hover {
  background: rgb(3, 169, 244);
}
custom-button .more {
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 20px;
  width: 20px;
  background: rgba(255, 255, 255, 0.5);
}
```

```ts
class CustomButton extends HTMLElement {
  constructor() {
    super();
    const more = document.createElement('span');
    more.className = 'more';
    more.innerHTML = 'i';
    this.appendChild(more);
  }
}

customElements.define('custom-button', CustomButton);

{
  const content = document.createElement('div');
  content.innerHTML = '<custom-button  >详情</custom-button>';
  document.body.appendChild(content);
}
```

效果如下，自定义组件内样式会跟随全局样式规则渲染，类名为`.more`的`span`元素呈现圆形并有白色背景

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/51839271c13a4f9984f56fd3ef86a631~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=PuWaC9uDpQcOqrXHKnoVhQ9ICug%3D)

## 3.2 `Shadow DOM`影子节点

`Shadow DOM`影子节点会与文档的主 DOM 树分开渲染，可以做到 DOM 节点隔离和样式隔离。

可以通过`Element.attachShadow()`方法给自定义元素挂载影子根节点。

```ts
class CustomButton extends HTMLElement {
  constructor() {
    super();
    // 创建影子节点
    this.attachShadow({mode: 'open', delegatesFocus: true});
    //影子根节点
    const shadow = this.shadowRoot!;
    const more = document.createElement('span');
    more.className = 'more';
    more.innerHTML = 'i';
    shadow.appendChild(more);
  }
}
```

`attachShadow`可传的参数如下：

- `mode`模式：`open`时可以通过外部 js 访问`ShadowRoot`节点，`closed`时则不可以。
- `delegatesFocus`焦点委托：当 shadowRoot 内元素不可聚焦，则委托到父级可聚焦的元素，比如富文本编辑，点击内部自定义元素，则会聚焦到父级富文本编辑器。

可以看到内部的`ShadowRoot`影子根节点样式与外部样式隔离，不再呈现上面全局样式的效果。并且自定义元素包裹的其他子元素也会被忽略，只渲染影子根节点内元素。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/30e9fc8b910d42928b4f1c3944151d2d~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=YlpEFlDBZfdgCWBCdVqjvsaJlMg%3D)

可以将自定义元素包裹的其他子元素转移到`ShadowRoot`内

```ts
class CustomButton extends HTMLElement {
  constructor() {
    super();
    // 创建影子节点
    this.attachShadow({mode: 'open', delegatesFocus: true});
    //影子根节点
    const shadow = this.shadowRoot!;

    //子元素
    if (this.childNodes?.length) {
      shadow.append(...Array.from(this.childNodes));
    }

    const more = document.createElement('span');
    more.className = 'more';
    more.innerHTML = 'i';
    shadow.appendChild(more);
  }
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ebbe5eec161b467bb49e35f1233277ce~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=rm%2FIIMJ2%2FC7L7mpGFWGxQJfbE8I%3D)

## 3.3 `Shadow DOM`影子节点内使用局部样式

**第一种方式: `Shadow DOM`内添加 style 元素**
`Shadow DOM`内 style 元素的样式会作用于`Shadow DOM`内所有元素

```ts
const scopedStyle = document.createElement('style');
scopedStyle.innerHTML = `.more{
  border-radius:50%;
    display:inline-flex;
  align-items:center;
  justify-content:center;
  height:20px;
  width:20px;
  color:blue;
  background:white;
}`;
shadow.appendChild(scopedStyle);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/3246b25b2c1e4e3d92a2719e23853df8~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=l8cQqxPnOsGMh%2Biph87HNlOnDlY%3D)

**第二种方式: `Shadow DOM`应用样式规则表`CSSStyleSheet`**

```ts
const sheet = new CSSStyleSheet();
sheet.replaceSync(`.more{
  border-radius:50%;
    display:inline-flex;
  align-items:center;
  justify-content:center;
  height:20px;
  width:20px;
  color:blue;
  background:white;
}`);
shadow.adoptedStyleSheets = [sheet];
```

**注意：** `CSSStyleSheet`样式规则表优先级更高，如果 style 元素和`CSSStyleSheet`样式规则表同时存在，则优先使用`CSSStyleSheet`样式规则表的样式进行渲染。

**`CSSStyleSheet`的方法**

- `insertRule(cssString)`:插入一条样式规则，先插入的规则优先渲染

```ts
const sheet = new CSSStyleSheet();
sheet.insertRule(`.more{
       background:red;
      color:blue;
      }`);

sheet.insertRule(`.more{
       background:green;
      color:gray;
      }`);
```

插入多条样式规则的情况，为什么同样的样式属性，先插入覆盖后插入的样式规则进行渲染？

通过打印`CSSStyleSheet`样式规则表，可以看到后插入样式规则会排在前面，即`CSSStyleSheet`样式规则表样式渲染也是读取按前后顺序执行，只不过插入的方式从头部插入，导致样式规则的排序是倒着的，那么先插入的样式规则就会优先渲染。

另外，插入的样式规则会累积，并且可以重复插入相同的样式规则

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/16c5692a6181475c9d00ed82e8c6363e~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=DLsLhmbrJKe7YQNGOj7o4%2FH1Sk8%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0c002fa5a6be45818913c481bc9254c0~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=49xBHjejs9l3Cplal1yE7uwgcTk%3D)

- `replaceSync(cssString)`:替换更新成最新样式，只保留一条

```ts
//基于上面的insertRule代码再进行replaceSync
sheet.replaceSync(`.more{
      background:gray;
      color:white;
      }`);
sheet.insertRule(`.more{
       background:pink;
      color:gray;
      }`);

sheet.insertRule(`.more{
       background:black;
      color:white;
      }`);
sheet.replaceSync(`.more{
      background:orange;
      color:yellow;
      }`);
```

可以看到`replaceSync`前面不论插入的多少条样式规则，都会被清空并替换成最新的样式规则，只保留最新的一条。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/d491200b5fe841b3a726825500f916b4~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=g37Y6dejWyxDUuKnVWkBfIm4M3A%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/f465ae2b8a8b481bb77bc67b79ba1dbd~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=UzHA5qCfZfggc%2B%2FTZZ7%2Bn31N9nY%3D)

- `deleteRule(index)`:删除第 index 条样式规则

## 3.4 `Shadow DOM`的一些伪类和伪类函数

我们编写自定义组件的时候，可能不仅仅想要对`Shadow DOM`内部元素进行样式设置，有时还想对`Shadow DOM`的宿主元素进行样式设置。

### 3.4.1 `:host`

给`Shadow DOM`宿主组件添加样式

```ts
class CustomTitle extends HTMLElement {
  constructor() {
    super();
    // 创建影子节点
    this.attachShadow({mode: 'open', delegatesFocus: true});
    //影子根节点
    const shadow = this.shadowRoot!;
    //样式设置
    const sheet = new CSSStyleSheet();
    sheet.replaceSync(/*css*/ `
        * {
          box-sizing: border-box;
        }
        :host{
          font-size:18px;
          font-weight:600;
          display:block;
          line-height:40px;
          padding:0 20px;
          color:#505050;
        }
        :host::after{
        display:inline-block;
        content:'>'
        }
        `);
    shadow.adoptedStyleSheets = [sheet];

    if (this.childNodes?.length) {
      shadow.append(...Array.from(this.childNodes));
    }
  }
}
customElements.define('custom-title', CustomTitle);

{
  const content = document.createElement('div');
  content.innerHTML = '<custom-title  >The Title</custom-title>';
  document.body.appendChild(content);
}
```

可以看到`ShadowRoot`的宿主`custom-title`会应用上`:host`的样式，并且设置宿主元素的伪元素类`::after`也渲染了。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4120f88438e94d1287d45072c9becd88~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=jH90rn3t6lxZUW5kl4t6%2BQK%2B1I0%3D)

### 3.4.2 `:host()`

`ShadowRoot`宿主选择器，根据宿主设置的不同属性、类名、状态等可以赋予对应样式.

宿主元素`custom-title`，设置了类名、id、属性、状态等会呈现出不同效果，并可以叠加样式。

```css
:host(:hover) {
  color: red;
}
:host(.border) {
  border-left: solid 3px green;
}
:host([required='true']) {
  background: yellow;
}
:host(#first) {
  color: orange;
}
```

```ts
{
  const content = document.createElement('div');
  content.innerHTML = '<custom-title  class="border">The Title</custom-title>';
  document.body.appendChild(content);
}
{
  const content = document.createElement('div');
  content.innerHTML = '<custom-title  required="true">The Title</custom-title>';
  document.body.appendChild(content);
}
{
  const content = document.createElement('div');
  content.innerHTML = '<custom-title  id="first">The Title</custom-title>';
  document.body.appendChild(content);
}
{
  const content = document.createElement('div');
  content.innerHTML =
    '<custom-title  id="first" class="border" required="true">The Title</custom-title>';
  document.body.appendChild(content);
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/832ae92fae774140801dfc8bbb80bf5b~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=XITbPhnn6yNuiGFoOBJpCW7m1qs%3D)

### 3.4.3 `:host-context()`

`ShadowRoot`宿主元素父级选择器，根据宿主的父级元素类型、不同属性、类名等可以赋予对应样式。

如果自定义元素`custom-title`添加到`p`元素内的样式设置。

```css
:host-context(p) {
  text-decoration: underline;
}
:host-context(p:hover) {
  background: blue;
}
```

```ts
{
  const content = document.createElement('p');
  content.innerHTML = '<custom-title >The Title</custom-title>';
  document.body.appendChild(content);
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4080ceec6e26439586982399a04fe97b~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=E9m2Hew9KK0wOC%2FzcVROYPTMEIY%3D)

### 3.4.4 `::part()`

`::part()`part 属性选择器，给设置了`part`属性某值的元素赋予对应的样式

**写一个自定义 tab 元素**

`::part(tab)`设置 part 属性为包含 tab 值的样式，`::part(active)`设置 part 属性为包含 active 值的样式，样式叠加，只能选择一个属性值，渲染优先级按前后顺序。

```css
* {
  box-sizing: border-box;
}
:host {
  display: block;
  height: 40px;
}
.tab-container {
  overflow: auto hidden;
  height: 100%;
  color: gray;
  font-size: 14px;
}
:host::part(tab) {
  display: inline-flex;
  padding: 0 20px;
  cursor: pointer;
  align-items: center;
  justify-content: center;
  height: 100%;
}
:host::part(active) {
  transition: all ease 0.5s;
  background: rgba(0, 0, 255, 0.3);
  font-weight: bold;
  color: blue;
}
```

创建自定义 tab 元素

```ts
class CustomTabs extends HTMLElement {
  container: HTMLDivElement;
  isChangeTabs = false;
  constructor() {
    super();
    // 创建影子根
    this.attachShadow({mode: 'open'});
    const shadow = this.shadowRoot!;
    const sheet = new CSSStyleSheet();
    sheet.replaceSync(/*css*/ `/**上面的样式*/`);
    shadow.adoptedStyleSheets = [sheet];
    //tabs容器
    this.container = document.createElement('div');
    this.container.className = 'tab-container';
    shadow.appendChild(this.container);
    this.render();
  }
  //渲染tab
  render(newIdx?: number) {
    const active = newIdx !== undefined ? newIdx : Number(this.getAttribute('active') || 0);

    if (this.container) {
      //tab改变重新渲染
      if (this.isChangeTabs) {
        let tabs: string[] = [];
        try {
          tabs = JSON.parse(this.getAttribute('tabs') || '[]');
        } catch (error) {}
        this.container.innerHTML = tabs
          .map((it, i) => `<div part="tab ${i == active ? 'active' : ''}" idx="${i}">${it}</div>`)
          .join('');
        this.isChangeTabs = false;
      } else {
        //active变化改变激活tab
        const beforeActive = this.container.querySelector('[part="tab active"]');
        if (beforeActive) {
          beforeActive.part = 'tab';
        }

        const child = this.container.children[active];
        if (child) {
          child.part = 'tab active';
        }
      }
    }
  }
  //监听属性值变化
  static observedAttributes = ['active', 'tabs'];
  attributeChangedCallback(name: string, oldValue: string, newValue: string) {
    if (name == 'tabs') {
      //tab改变
      this.isChangeTabs = true;
    }
    this.render();
  }
}
customElements.define('custom-tabs', CustomTabs);
{
  const content = document.createElement('div');
  content.innerHTML = `<custom-tabs tabs='${JSON.stringify([
    '语文',
    '数学',
    '英语'
  ])}' active="2" ></custom-tabs>`;
  document.body.appendChild(content);
}
```

`Element.part`属性可以直接赋值，或者通过`setAttribute`赋值

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/cd07c758df9046a7a6f708899a75a145~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=i4EfiKOU9Wah7gmo2nivQSspmAY%3D)

# 4. WebComponents 事件监听与分发

基于上面的自定义 tab 元素，使用 tab 容器做事件代理监听子级 tab 的点击动作

点击 tab 后，更新 tabs 的 active 属性，触发`attributeChangedCallback`属性变化监听，并创建自定义事件`CustomEvent`，通过`dispatchEvent`方法分派事件。

**注意：** 要在自定义元素从页面移除前注销动作监听、定时器等，避免内存泄漏。

```ts
class CustomTabs extends HTMLElement {
  constructor() {
    //....
    //使用tab容器做事件代理
    this.container.addEventListener('click', this.onClickTab.bind(this));
  }
  //从页面移除元素，注销监听
  disconnectedCallback() {
    this.container.removeEventListener('click', this.onClickTab.bind(this));
  }
  //点击切换tab，触发事件
  onClickTab(ev: MouseEvent) {
    const target = ev.target as HTMLElement;
    if (target.getAttribute('idx')) {
      //更新tab
      const newIdx = target.getAttribute('idx') || '0';
      //设置active属性，触发属性变化监听attributeChangedCallback
      this.setAttribute('active', newIdx);
      //创建自定义事件
      const event = new CustomEvent('change', {detail: newIdx});
      //分派事件
      this.dispatchEvent(event);
    }
  }
}
```

自定义元素通过`addEventListener`监听自定义事件。

```ts
const tabs = new CustomTabs();
tabs.setAttribute('tabs', JSON.stringify(['语文', '数学', '英语']));
tabs.setAttribute('active', '1');
document.body.appendChild(tabs);
tabs.addEventListener('change', (ev: Event) => {
  const target = ev.target as HTMLElement;
  const event = ev as CustomEvent;
  console.log(
    '🚀 ~ index.ts ~ tabs.addEventListener:',
    ev,
    event.detail,
    target.getAttribute('active')
  );
});
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4f15ffef536f46ceba5389bc6168a9b1~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=GdnVJOvQTtQtBW%2BTmXv8OZExiZI%3D)

这样自定义元素的动作交互就能形成闭环了\~

# 5. template 与 slot

## 5.1 `<slot>`插槽

插槽是 web 组件内部的占位符，预留位置，若自定义元素包裹的子元素有对应的元素则将其链接到该插槽位置，并重新排布 ShadowRoot 的 DOM 树进行渲染呈现。

### 5.1.1 默认插槽

在 ShadowRoot 内添加`<slot>`插槽元素，默认会将自定义元素包裹的子元素渲染在`<slot>`插槽元素的位置

```ts
class CustomCard extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({mode: 'open'});

    const shadow = this.shadowRoot!;
    shadow.innerHTML = /*html*/ `<div style="display:inline-block;border:solid 1px rgba(0,0,0,0.1);padding:20px;box-shadow:0 0 10px #ccc">
   <slot></slot>
   </div>`;
  }
}
customElements.define('custom-card', CustomCard);
{
  const card = new CustomCard();
  card.innerHTML = 'Card Card';
  document.body.appendChild(card);
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/1658a95f36384b8ebd868a403bc43c90~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=ksPRuepvZLPhWpjKBSIrMGd5Ssc%3D)

**注意：**

- 插槽内添加内容，可以在自定义元素没有子元素时仍有内容显示。当然具名插槽也可显示默认内容。

```html
<slot>No Data</slot>
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/5113255c8b874c2c9816542863efdc86~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=DbvbJ%2FJlEedzF2NOKgl3cwlr%2B5A%3D)

### 5.1.2 具名插槽

在 ShadowRoot 内添加有 name 属性的`<slot>`插槽元素，自定义元素包裹的子元素会渲染到具名插槽内。

```ts
class CustomLayout extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({mode: 'open'});
    const shadow = this.shadowRoot!;
    shadow.innerHTML = /*html*/ `
      <style>
      :host{
      display:flex;
      }
      :host>div{
      flex:1;
      }
      .left{
      text-align:left;
      }
      .center{
      text-align:center;
      }
      .right{
      text-align:right;
      }
      
      </style>
      <div class='left'><slot name='left'></slot></div>
      <div class='center'><slot name='center'></slot></div>
      <div class='right'><slot name='right'></slot></div>`;
  }
}
customElements.define('custom-layout', CustomLayout);
```

或者使用`document.createElement('slot')`创建`<slot>`插槽元素并添加

```ts
const leftSlot = document.createElement('slot');
leftSlot.name = 'left';
shadow.appendChild(leftSlot);

const centerSlot = document.createElement('slot');
centerSlot.name = 'center';
shadow.appendChild(centerSlot);

const rightSlot = document.createElement('slot');
rightSlot.name = 'right';
shadow.appendChild(rightSlot);
```

自定义元素包裹的子元素会按照 slot 属性的值，在渲染时移动到对应的名称的`<slot>`插槽元素内显示，并且包裹的子元素跟随外部样式配置进行渲染。

```ts
const content = document.createElement('div');
content.innerHTML = /*html*/ `
<style>
.border{
  display:inline-block;
  border:solid 1px blue;
  padding:10px;
}
#centerBody{
  background:yellow;
}
</style>
<custom-layout>
    <span slot='left' class="border">Left</span>
    <div slot='center' id='centerBody'>Center</div>
    <h1 slot='right'>Right</h1>
    </custom-layout>`;
document.body.appendChild(content);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/1398b60804dd443facbcbbba608cd988~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=apMFJ6DBVNK6BfEH3QKife3wmPg%3D)

**注意：**

- 当自定义元素包裹多个相同的 slot 属性值的子元素时，会累加到对应`<slot>`插槽元素中

```html
<custom-layout>
  <span slot="left" class="border">Left</span>
  <span slot="left" class="border">Left</span>
  <div slot="center" id="centerBody">Center</div>
  <h1 slot="right">Right</h1>
</custom-layout>
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4f6fc65728134b74865a16fb3d629256~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=ElA4gb9eSPPMVAGx5FH4cJ5rZYU%3D)

- 当`ShadowRoot`内出现重名`<slot>`元素，则只会渲染首次出现的`<slot>`插槽元素，后面重名的`<slot>`插槽元素则会被忽略

```html
<div class="left"><slot name="left"></slot></div>
<div class="center"><slot name="center"></slot></div>
<div class="right"><slot name="right"></slot></div>
<!--下面的插槽则会被忽略，但<div class='left'>还是会渲染，只不过是空-->
<div class="left"><slot name="left"></slot></div>
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/09767d83e55141809cbfd7d92d93c258~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=h7qzqi5MXsLH7YA2uHAXSS61X6I%3D)

- `<slot>`插槽元素可以动态添加，对应 slot 属性值的元素也会对应渲染出来，可以通过此种方式控制显示隐藏

```ts
class CustomLayout extends HTMLElement {
  tempslot?: HTMLSlotElement;
  constructor() {
    super();
    //...
    //点击动态添加<slot>
    this.addEventListener('click', this.addSlot.bind(this));
  }
  addSlot() {
    //判断<slot>是否被添加
    if (!this.tempslot) {
      const shadow = this.shadowRoot!;
      //动态添加<slot>
      const tempslot = document.createElement('slot');
      tempslot.name = 'tempSlot1';
      this.tempslot = tempslot;
      shadow.appendChild(tempslot);
    } else {
      //改变<slot>的name属性
      this.tempslot.name = this.tempslot.name == 'tempSlot' ? 'tempSlot1' : 'tempSlot';
    }
  }
}
```

提前添加`slot=tempSlot1`的子元素

```html
<custom-layout>
  <span slot="left" class="border">Left</span>
  <div slot="center" id="centerBody">Center</div>
  <h1 slot="right">Right</h1>
  <h1 slot="tempSlot1" style="color:red">tempSlot1</h1>
</custom-layout>
```

点击后动态添加`<slot name='tempSlot1'>`，通过改变`<slot>`的 name 属性控制显隐

![20250522_193227.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ff837192024048a6957cf123a2979253~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=HYfZBeMRNaYLBshb%2FzzeRCsy%2FjM%3D)

- `<slot>`的 name 属性改变也可以对 slot 属性的子元素进行切换控制，

```ts
<custom-layout>
  <span slot="left" class="border">
    Left
  </span>
  <div slot="center" id="centerBody">
    Center
  </div>
  <h1 slot="right">Right</h1>
  <h1 slot="tempSlot1" style="color:red">
    tempSlot1
  </h1>
  <h1 slot="tempSlot" style="color:orange">
    Hello
  </h1>
</custom-layout>
```

![20250522_200038.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/7bd20a2261fe4cb78dc3c7e288c4c1d5~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=iD%2BNstpqpX%2BF0YpXPG2nLtdfgYk%3D)

### 5.1.3 `slotchange`事件与 slot API

- **`slotchange`事件**：监听`<slot>`插槽元素 name 属性的变化

```ts
tempslot.addEventListener('slotchange', (ev) => {
  console.log(ev);
});
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/c4aeb917ce2d4dd8ad868311ccde759b~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=HPYqrTrjCwyW%2BD1LHgcciIsByec%3D)

- **`<slot>`插槽元素`assignedElements`方法**：获取插槽内渲染的元素

即将要渲染的 slot 插槽元素

```ts
<h1 slot="tempSlot1" style="color:red">
  tempSlot1<strong>HAHAHA</strong>
</h1>
```

```ts
console.log(tempslot.assignedElements().map((el) => el.outerHTML));
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4d890725d8e04609a7598f34a85a54a4~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=u9s76mKYvPh%2BhHwubZgSQGEurM8%3D)

- **同理`assignedNodes`方法**：获取插槽内渲染的节点

```ts
console.log(tempslot.assignedNodes().map((el) => el.outerHTML));
```

### 5.1.4 `<slot>`插槽元素 assign 动态分配

- **`<slot>`插槽元素 assign 方法**:当`ShadowRoot`设置`slotAssignment:'manual'`手动设置插槽渲染的元素，可以用`<slot>`插槽元素`assign`方法动态赋予元素。

> `ShadowRoot`设置`slotAssignment`默认值是`named`自动根据 slot 的 name 属性渲染插槽元素

自定义元素`attachShadow`影子根节点`ShadowRoot`的可以配置`slotAssignment:'manual'`

```ts
class CustomCard1 extends HTMLElement {
  titleSlot: HTMLSlotElement;
  bodySlot: HTMLSlotElement;
  constructor() {
    super();
    //slotAssignment定义slot手动配置
    this.attachShadow({mode: 'open', slotAssignment: 'manual'});
    const shadow = this.shadowRoot!;
    shadow.innerHTML = /*html*/ `<div style="display:inline-block;border:solid 1px rgba(0,0,0,0.1);padding:20px;box-shadow:0 0 10px #ccc">
   <slot></slot> 
   <div style="background:yellow">
      <slot></slot>
   </div>  
   </div>`;

    const slots = shadow.querySelectorAll('slot')!;
    this.titleSlot = slots[0];
    this.bodySlot = slots[1];
  }
}
customElements.define('custom-card1', CustomCard1);
```

创建自定义元素，根据元素内的 slot 插槽动态分配元素进行渲染

```ts
const card = new CustomCard1();
document.body.appendChild(card);
const title = document.createElement('h1');
title.innerHTML = 'TITLE';
//添加到自定义元素内
card.appendChild(title);
//插槽手动设置渲染元素
card.titleSlot.assign(title);

const cardBody = document.createElement('div');
cardBody.innerHTML = 'CARD BODY';
//添加到自定义元素内
card.appendChild(cardBody);
//插槽手动设置渲染元素
card.bodySlot.assign(cardBody);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/5fa6b5cd657a4e139b3bd6aac849a5a7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=N0xMJNMsS20ZXhynbKo9oHE%2B5OI%3D)

**注意**：给插槽重复分配不同子元素，旧的会被覆盖，会按照最新的子元素渲染显示。

## 5.2 `::slotted()`

插槽的`slot`属性元素选择器，根据宿主的父级元素类型、不同属性、类名等可以赋予对应样式，与上面的`::host()`，`::host-context()`用法相似。

```css
/**基于上面的CustomLayout*/
::slotted(*) {
  font-weight: bold;
}
::slotted(h1) {
  background: pink;
}
::slotted(.border) {
  color: green;
}
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/776edd72838842e3a1c9a564dfc7cb86~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=8VlXDOLQH9WIbooNOaK62bp7c4k%3D)

## 5.3 `template`模板

**内容模板**（`<template>`）元素是一种用于保存客户端内容机制，该内容在加载页面时不会呈现（template 内的内容不会渲染），但可以在运行时使用 js 实例化添加到页面渲染。

### 5.3.1 复制 template 的内容，添加到页面渲染

```ts
const template = document.createElement('template');
template.innerHTML = /*html*/ `<h1>Top</h1>
<h2>Center</h2>
<h3>Bottom</h3>`;
document.body.appendChild(template);
//复制template的内容
const clone = document.importNode(template.content, true);
document.body.appendChild(clone);
//添加复制的template的内容
document.body.appendChild(template.content.cloneNode(true));
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/48191c9bacc748fca68f18a61fbd909c~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=%2B83TLQBilzOwOAfrcDNcVVMRaWY%3D)

自定义元素中应用`template`，将模板中内容添加到`shadowRoot`

```ts
class CustomInfoItem extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({mode: 'open'});
    const shadow = this.shadowRoot!;
    shadow.innerHTML = /*html*/ `<div style="line-height:32px;">
    <label id="label" style="color:gray;margin-right:10px">
    </label>
    <span id="value" style="color:blue;"> 
    </span></div>`;
    const label = shadow.querySelector('#label')!;
    const labelTemplate = document.querySelector('#label-template');
    if (labelTemplate)
      label.appendChild((labelTemplate as HTMLTemplateElement).content.cloneNode(true));
    const value = shadow.querySelector('#value')!;
    const valueTemplate = document.querySelector('#value-template');
    if (valueTemplate) {
      value.appendChild((valueTemplate as HTMLTemplateElement).content.cloneNode(true));
    }
  }
}

customElements.define('custom-info-item', CustomInfoItem);
```

需保证对应的 template 要存在才能正确添加到自定义元素的 ShadowRoot 中，template 的位置不受限制，只有可以通过 js 获取到实例即可

```ts
const template = document.createElement('template');
template.id = 'label-template';
template.innerHTML = 'Hello';
document.body.appendChild(template);

const template1 = document.createElement('template');
template1.id = 'value-template';
template1.innerHTML = 'World';
document.body.appendChild(template1);

const infoItem = new CustomInfoItem();
document.body.appendChild(infoItem);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/a13ff6efbbcf4a8abc178263ccfb9922~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=doXs%2Bq2xJzgDI%2FuG6gYBb%2Bp1Hac%3D)

### 5.3.2 `template`作为为`ShadowRoot`使用

```html
<p>
  <template shadowrootmode="open">
    <div style="line-height: 32px">
      <label style="color: gray; margin-right: 10px"> <slot name="label"></slot>： </label>
      <span style="color: blue">
        <slot name="value"></slot>
      </span>
    </div>
  </template>
  <span slot="label">Label</span>
  <span slot="value">Value</span>
</p>
```

要直接在 html 中写属性`shadowrootmode="open"`的 template 的内容才能生效作为 ShadowRoot，不能用 innerHTML、append、`document.createElement('template')`等方式添加动态属性`shadowrootmode="open"`的 template，会依旧解析为 template，emmm\~好鸡肋！

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/597f7b0e2b1b4c9f958b410b4efc4d26~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=1tEaSTUBFzkhU3QNu%2FnKr1XSf3A%3D)

`shadowrootmode="open"`的 template 可以设置`:has-slotted`样式，插槽有内容渲染时的样式

```css
:has-slotted {
  color: red;
}
```

`:has-slotted`优先级比较高，直接覆盖原来的样式了！

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/e3e95737da944d9dbf1fa14cb8f46e1f~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=tkek7gTjHSwgkIXiX4yLopscbqM%3D)

**注意**：浏览器的 slot 和 template 用法跟 vue 的有所不同

- vue 会根据组件提前预留的 slot 插槽元素，对应寻找元素内的 template 元素，并将其内容渲染到插槽。
- 而 template 在浏览器中通过 slot 属性会整个元素渲染到 slot 插槽元素的位置，依旧不会渲染显示出来。

# 6. 表单组件

自定义元素通过`attachInternals()`返回一个`ElementInternals`对象，使其可以参与 HTML 表单。另外需要给自定义元素表单元素开启`formAssociated = true`

```ts
class CustomInput extends HTMLElement {
  //开启关联表单元素
  static formAssociated = true;
  internals: ElementInternals;
  constructor() {
    super();
    this.attachShadow({mode: 'open', delegatesFocus: true});
  }
  //获取关联表单
  get form() {
    return this.internals.form;
  }
  //设置表单字段名
  set name(v: string) {
    this.setAttribute('name', v);
  }
  get name() {
    return this.getAttribute('name') || '';
  }
}
```

## 6.1 自定义输入组件

组件布局

```html
<div class="input-wrapper">
  <input type="text" placeholder="${this.getAttribute('placeholder') || ''}" />
  <span class="num"></span>
</div>
<div class="error-tip"></div>
```

输入组件样式，并设置错误时显示的样式

```css
* {
  box-sizing: border-box;
}
:host {
  display: inline-block;
}
.input-wrapper {
  display: inline-flex;
  border-radius: 4px;
  height: 32px;
  border: solid 1px gray;
  align-items: center;
  padding: 0 10px;
}
.input-wrapper.error {
  border: solid 1px red;
}
.input-wrapper.error .num {
  color: red;
}
input {
  border: none;
  background: transparent;
  height: 30px;
  outline: none;
  display: inline-block;
}
.num {
  display: inline-block;
  font-size: 12px;
  color: gray;
}
.error-tip {
  padding: 5px;
  font-size: 12px;
  color: red;
}
```

实现自定义输入组件，`formAssociated=true`设置关联表单，通过`ElementInternals`的`setFormValue(v)`设置关联表单的数据值

```ts
class CustomInput extends HTMLElement {
  static formAssociated = true;
  internals: ElementInternals;
  input: HTMLInputElement;
  num: HTMLSpanElement;
  tip: HTMLDivElement;
  wrap: HTMLDivElement;
  constructor() {
    super();
    //...
    this.wrap = shadow.querySelector('.input-wrapper') as HTMLDivElement;
    this.input = shadow.querySelector('input') as HTMLInputElement;
    this.num = shadow.querySelector('.num') as HTMLSpanElement;
    this.tip = shadow.querySelector('.error-tip') as HTMLDivElement;
    //设置初始输入值
    this.setInputVal(this.getAttribute('value') || '');
    //...
  }
  //设置输入值
  setInputVal(v: string) {
    if (this.input) this.input.value = v;
    this.updateNum();
    //设置表单值
    this.internals.setFormValue(v);
    this.validate();
  }
  set value(v: string) {
    this.setInputVal(v);
  }
  get value() {
    return this.input?.value || '';
  }
}
```

监听属性

```ts
static observedAttributes = ['maxlength', 'placeholder', 'required'];
  attributeChangedCallback(name: string, oldValue: string, newValue: string) {
    switch (name) {
      case 'placeholder':
      //文本占位符
        this.input.placeholder = newValue;
        break;
      case 'maxlength':
        //更新文本长度
        this.updateNum();
        break;
      case 'required':
        //表单验证
        this.validate();
        break;
    }
  }
```

监听输入事件，其中可以通过利用构造函数复制 input 事件，作为自定义输入组件的事件分发出去

```ts
class CustomInput extends HTMLElement {
  //...
  constructor() {
    super();
    //...
    //输入事件监听
    this.input.addEventListener('input', this.onInputEvent.bind(this));
    this.input.addEventListener('change', this.onInputEvent.bind(this));
  }
  //注销事件监听
  disconnectedCallback() {
    this.input.removeEventListener('input', this.onInputEvent.bind(this));
    this.input.removeEventListener('change', this.onInputEvent.bind(this));
  }
  onInputEvent(e: Event) {
    //输入值
    const v = this.input.value;
    //文本长度
    this.updateNum();
    //设置表单值
    this.internals.setFormValue(v);
    //表单验证
    this.validate();

    //分发事件，利用构造函数复制事件
    //@ts-ignore
    const clone = new e.constructor(e.type, e);
    this.dispatchEvent(clone);
  }
}
```

验证输入，并提示信息，设置显示错误时的样式

```ts
//文本长度验证
  updateNum() {
    const v = this.input.value;
    const len = Number(this.getAttribute('maxlength')) || 0;
    this.num.innerHTML = `${v.length}/${len}`;
    //超过长度则显示错误样式
    if (v.length <= len) {
      this.wrap.classList.remove('error');
    } else {
      this.wrap.classList.add('error');
    }
  }
//表单自带验证
  validate() {
    if (this.getAttribute('maxlength') && this.input.value.length > Number(this.getAttribute('maxlength'))) {
      const text = `最多输入${this.getAttribute('maxlength')}个字符`;
      this.tip.innerHTML = text;
      this.tip.style.display = 'block';
      this.internals.setValidity({ tooLong: true }, text, this.tip);
    } else if (this.getAttribute('required') === 'true' && this.input.value === '') {
      const text = this.getAttribute('placeholder') || '请输入';
      this.tip.innerHTML = text;
      this.tip.style.display = 'block';
      this.internals.setValidity({ valueMissing: true }, text, this.tip);
    } else {
      this.internals.setValidity({});
      this.tip.style.display = 'none';
    }
    //显示提示信息框
    this.internals.reportValidity();
  }

```

`CustomInput`添加到 form

```ts
const cinput = new CustomInput();
cinput.setAttribute('placeholder', '请输入数值');
cinput.setAttribute('required', 'true');
cinput.setAttribute('maxlength', '10');
cinput.value = '1234';
cinput.name = 'money';

const form = document.createElement('form');
document.body.appendChild(form);
form.appendChild(cinput);
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/9c86f6459a6e4de4b5af101f7d425089~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=rwBU17yjnQM30GeXYF8Lug8j8eg%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0554575fac614d54abef08d3665c6972~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=gWBLAiQzO%2Bljd%2BPHksi3c9ro0DY%3D)

可以看到浏览器自带的错误验证提示

其中，浏览器自带表单验证提示可以通过`ElementInternals.setValidity(flags, message, anchor)`方法设置

flags 的可选值有

- `valueMissing`:开启了`required`必填属性时，当 input 和 textarea 值为空时开启`valueMissing`，显示提示
- `typeMismatch`:当 input 的 type 为 url 或 email，值不匹配该类型时，开启`typeMismatch`，显示提示
- `patternMismatch`:设置了 pattern 属性，且 input 的值与该 pattern 不符合时，开启`patternMismatch`，显示提示。
- `tooLong`:设置了 maxlength 属性，且 input 和 textarea 值超过长度，开启`tooLong`，显示提示。
- `tooShort`:设置了 minlength 属性，且 input 和 textarea 值小于长度，开启`tooShort`，显示提示。
- `rangeUnderflow`:设置了 min 属性，且 input 的值小于 min，开启`rangeUnderflow`，显示提示。
- `rangeOverflow`:设置了 max 属性，且 input 的值大于 max，开启`rangeOverflow`，显示提示。
- `stepMismatch`:设置了 step 属性，且 input 的值不能整除 step，开启`stepMismatch`，显示提示。
- `badInput`:浏览器无法转换输入值

**监听自定义输入组件，获取表单数据和表单校验结果**

```ts
//监听change事件
cinput.addEventListener('change', (e: Event) => {
  console.log('🚀 ~ cinput.addEventListener ~ e:', e);
  //获取表单数据
  const formData = new FormData(form);
  //获取表单值
  console.log('🚀 ~ formData:', formData.get('money'));
  //表单校验结果，是否通过校验
  console.log('🚀 ~ Validity:', form.checkValidity());
});
```

form 获取自定义输入组件的值，校验通过

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/b1144cefc96142848a70e19a3eb6d080~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=l67iyx24iJXzciBMuIne6ug30LA%3D)

form 获取自定义输入组件的值，校验失败

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/37db3117507b47aab7121ab797d43b60~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=7HrS1VoTY2QZQDBwpMw%2B2wSzGiY%3D)

## 6.2 自定义 switch 开关组件

自定义开关组件的样式，并设置选中时的样式

```css
* {
  box-sizing: border-box;
}
:host {
  display: inline-flex;
  height: 20px;
  width: 40px;
  background: white;
  border-radius: 10px;
  overflow: hidden;
  padding: 2px;
  background: gray;
}
:host::before {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  height: 16px;
  width: 16px;
  border-radius: 50%;
  content: '';
  background: white;
}
:host(:state(checked)) {
  background: dodgerblue;
  justify-content: flex-end;
  transition: all 0.5s ease;
}
```

实现`CustomSwitch`自定义开关，其中开关是否勾选的状态，可以通过`ElementInternals.states`设置。

`ElementInternals.states`是一个自定义状态集`CustomStateSet`，可以通过增删等操作管理状态值，并可以使用 css`:state()`自定义状态伪类函数，从而给组件不同状态设置不同样式。

```ts
class CustomSwitch extends HTMLElement {
  internals: ElementInternals;
  //开启关联表单元素
  static formAssociated = true;
  constructor() {
    super();
    //...
    this.addEventListener('click', this.onClick.bind(this));
  }
  onClick(e: Event) {
    //切换开关状态
    this.checked = !this.checked;

    //分发事件
    //@ts-ignore
    const event = new Event('change', {detail: {checked: this.checked}});
    this.dispatchEvent(event);
  }
  disconnectedCallback() {
    this.removeEventListener('click', this.onClick.bind(this));
  }
  get checked() {
    return this.internals.states.has('checked');
  }
  set checked(flag) {
    //设置状态值
    if (flag) {
      this.internals.states.add('checked');
      this.internals.setFormValue('on');
    } else {
      this.internals.states.delete('checked');
      this.internals.setFormValue('off');
    }
  }
  //判断状态语法是否可用
  static isStateSyntaxSupported() {
    return CSS.supports('selector(:state(checked))');
  }
}
```

获取开关组件的表单值

```ts
const form = document.createElement('form');
document.body.appendChild(form);

const switchEl = new CustomSwitch();
switchEl.name = 'Hello';
switchEl.checked = true;

form.appendChild(switchEl);
//监听change事件
switchEl.addEventListener('change', (e: Event) => {
  console.log('🚀 ~ addEventListener ~ e:', e);
  //获取表单数据
  const formData = new FormData(form);
  //获取表单值
  console.log('🚀 ~ formData:', formData.get('Hello'));
  //表单校验结果，是否通过校验
  console.log('🚀 ~ Validity:', form.checkValidity());
});
```

form 获取开关的`false`值

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4bbb5c78642d4a0b91a07567936ee3b9~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=zTBcJHNydDK89SrXLCnp8g0pKpA%3D)

form 获取开关的`true`值

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0de674cb09964a3cb5a267bd1c13bbd3~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1750042092&x-orig-sign=ZgUoGp%2BUpPj0pECu2lxV%2FuZGgeQ%3D)

# 7. GitHub 地址

`https://github.com/xiaolidan00/demo-vite-ts`

**参考：**

- [字节跳动-国际化电商-S 项目团队《浅谈前端组件设计》](https://mp.weixin.qq.com/s/gIPvBEFh7qGLlyVSfSs6RA)
- [MDN 使用自定义元素](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_components/Using_custom_elements)
- [MDN ShadowRoot](https://developer.mozilla.org/zh-CN/docs/Web/API/ShadowRoot)
- [MDN Shadow DOM](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/attachShadow)
- [MDN `<slot>`元素](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Elements/slot)
- [MDN `<template>`元素](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Elements/template)
- [MDN slot 属性](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Global_attributes/slot)
- [github web-components-examples](https://github.com/mdn/web-components-examples)
- [github awesome-web-components](https://github.com/web-padawan/awesome-web-components)
- [MDN :host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host)
- [MDN :host()](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:host_function)
- [MDN :host-context()](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context)
- [MDN :has-slotted()](https://developer.mozilla.org/en-US/docs/Web/CSS/:has-slotted)
- [MDN part 属性](https://developer.mozilla.org/en-US/docs/Web/API/Element/part)
- [MDN Element.attachInternals 方法](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/attachInternals)
- [MDN ElementInternals](https://developer.mozilla.org/en-US/docs/Web/API/ElementInternals)
- [MDN input](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Elements/input)
- [MDN CustomStateSet](https://developer.mozilla.org/en-US/docs/Web/API/CustomStateSet)
- [web-components-can-now-be-native-form-elements](https://www.dannymoerkerke.com/blog/web-components-can-now-be-native-form-elements/)
