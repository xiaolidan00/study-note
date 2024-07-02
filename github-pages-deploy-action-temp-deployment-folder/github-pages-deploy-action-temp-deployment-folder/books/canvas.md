# 《HTML5 Canvas 核心技术 图形、动画与游戏开发》 读书笔记

## 第 1 章 基础知识

```html
 <style>
        body{
            background: #dddddd;
        }
        #theCanvas{
            margin:10px;
            padding:10px;
            background: #ffffff;
            border: thin inset #aaaaaa;
        }

        #theCanvas1{
            margin:10px;
            padding:10px;
            background: #ffffff;
            border: thin inset #aaaaaa;
            height: 300px;
            width: 600px;
        }
        </style>
    </head>
<body>


    <!-- 注意：设置canvas的宽度高度时不可使用px后缀 -->
    <canvas id="theCanvas" height="300" width="600"></canvas>
    <!-- 默认情况下，canvas元素大小时300*150个屏幕元素，可通过css和width，height属性改变大小 -->

    <canvas id="theCanvas1" ></canvas>

    <script>
        //获取canvas引用
    var canvas=document.getElementById('theCanvas');
    //在canvas对象上调用getContext('2d'),注意'2d'必须小写d
    var context=canvas.getContext('2d');
    //设置绘制样式属性
    context.font='38pt Airal';
    context.fillStyle='cornflowerblue';
    context.strokeStyle='blue';
    //绘制文本内容
    context.fillText('Hello Canvas',canvas.width/2-150,canvas.height/2+15);
    context.strokeText("Hello Canvas",canvas.width/2-150,canvas.height/2+15);

         //获取canvas引用
         var canvas1=document.getElementById('theCanvas1');
    //在canvas对象上调用getContext('2d'),注意'2d'必须小写d
    var context1=canvas1.getContext('2d');
    //设置绘制样式属性
    context1.font='38pt Airal';
    context1.fillStyle='cornflowerblue';
    context1.strokeStyle='blue';
    //绘制文本内容
    context1.fillText('Hello Canvas',canvas1.width/2-150,canvas1.height/2+15);
    context1.strokeText("Hello Canvas",canvas1.width/2-150,canvas1.height/2+15);

    </script>
    </body>
```

对比 theCanvas 和 theCanvas1 可知

- canvas 元素实际上由两套尺寸，一个时元素本身的大小，还有一个时元素绘制表面的大小
- 属性 width 和 height 设置的时元素本身大小和元素绘制表面的大小
- css 设置 canvas 大小，只修改元素本身大小，不影响绘制表面，容易出现像素伸缩的情况
- 浏览器可能会自动缩放 canvas,当元素大小域 canvas 绘图表面不相符，浏览器会缩放后者，使之复合前者大小，可能会导致奇怪、无用的效果

**canvas 元素的属性**

| 属性   | 描述                                                                                                                                                                               | 类型     | 取值范围                                                     | 默认值 |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------ | ------ |
| width  | canvas 元素绘图表面的宽度，在默认情况下，浏览器会将 canvas 元素的大小设定与绘图表面大小一致，然而，如果在 CSS 中覆写了元素的大小，那么浏览器会将绘图表面进行缩放，使之复合元素尺寸 | 非负整数 | 在有效范围内的任意非负整数，可添加+与空格，不能给数值添加 px | 300    |
| height | canvas 元素绘图表面的高度。浏览器可能将绘图表面缩放至与元素相同的尺寸。                                                                                                            | 非负整数 | 在有效范围内的任意非负整数，可添加+与空格，不能给数值添加 px | 300    |

**canvas 元素的方法**

| 属性                          | 描述                                                                                                                                                                                                                                                                                                                         |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| getContext()                  | 返回与该 canvas 元素相关的绘图环境对象。每个 canvas 元素均有一个这样的环境对象，而且每个环境对象均与一个 canvas 元素相关联                                                                                                                                                                                                   |
| toDataURL(type,quality)       | 返回一个数据地址（data URL),你可以将它设定为 img 元素的 src 属性值。第一个参数指定了图形的类型，例如 image/jpeg 或 image/png，如果不指定第一个参数，则默认使用 image/png。第二个参数必须是 0~1.0 之间的 double 值，表示 JPEG 图像显示的质量                                                                                  |
| toBlob(callback,type,args...) | 创建一个用于表示 canvas 元素图像文件的 Blob，第一个参数是回调函数，浏览器会以一个指向 blob 的引用为参数，去调用该回调函数。第二个参数以“image/png"这样的象时来指定图像类型。如果不指定，则默认使用”image/png“，最后一个参数是介于 0~1.0 之间的值，表示 JPEG 图像的质量。将来很可能会加入其他一些用于精确调控图像属性的参数。 |

**CanvasRenderingContext2D 对象所含的属性**

| 属性                     | 简介                                                                                                                                                               |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| canvas                   | 指向该绘图环境所属的 canvas 对象，该属性最常见的用途就是通过它来获取 canvas 的宽度和高度，分别调用 context.canvas.width 与 context.canvas.height 即可              |
| fillstyle                | 指定该绘图环境在后续的图形填充操作中所使用的颜色、渐变色或图案                                                                                                     |
| font                     | 设定在调用绘图环境对象的 fillText()或 strokeText()方法所使用的字形                                                                                                 |
| globalAlpha              | 全局透明度设定，它可以取 0（完全透明）~1.0（完全不透明）之间的值，浏览器会将每个像素的 alpha 值与该值相乘，在绘制图像时也是如此                                    |
| globalCompositeOperation | 该值决定了浏览器将某个物体绘制在其他物体之上时，所采用的绘制方式。                                                                                                 |
| lineCap                  | 该值告诉浏览器如何绘制线段的端点，可用值：butt、round 及 square，默认 butt                                                                                         |
| lineWidth                | 该值决定了在 canvas 之中绘制线段的屏幕像素宽度，它必须时非负、非无穷的 double 值，默认 1.0                                                                         |
| lineJoin                 | 该值告诉浏览器两条线段相交时如何绘制焦点，可取值：bevel，round，miter，默认值 miter                                                                                |
| miterLimit               | 告诉浏览器如何绘制 miter 形式的线段焦点                                                                                                                            |
| shadowBlur               | 该值决定了路篮球如何延伸阴影效果。值越高，阴影效果延伸越远。该值不是指阴影的像素长度，而是代表高斯模糊方程式中的参数值，它必须时一个非负非无穷的 double 值，默认 0 |
| shadowColor              | 该值告诉浏览器使用何种颜色绘制阴影。通常采用半透明色作为该属性的值，以便让后面的背景能显示                                                                         |
| shadowOffsetX            | 以像素为单位，指定阴影效果的水平方向偏移量                                                                                                                         |
| shadowOffsetY            | 以像素为单位，指定阴影效果的垂直方向偏移量                                                                                                                         |
| strokeStyle              | 指定了对路径进行描边时索用的绘制风格，该值可被设定为某颜色、渐变色或图案                                                                                           |
| textAlign                | 决定了以 fillText()或 strokeText()进行描绘时，所画文本的水平对齐方式                                                                                               |
| textBaseline             | 决定了以 fillText()或 strokeText()进行绘制时，所画文本垂直对齐方式                                                                                                 |

canvas 提供 save()和 restore()用于保存以及回复当前 canvas 绘图环境属性

```js
function drawGrid(strokeStyle, fillStyle) {
  controlContext.save(); //保存context到栈
  controlContext.fillStyle = fillStyle;
  controlContext.strokeStyle = strokeStyle;
  /**draw grid*/
  controlContext.restore(); //从栈中恢复context
  //save()和restore()方法可以嵌套式调用
}
```

**CanvasRenderingContext2D 之中与状态操作有关的方法**

| 方法      | 描述                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| save()    | 将当前 canvas 的状态推送到一个保存 canvas 状态的堆栈顶部。canvas 状态包括了当前的坐标变换（transformation)信息、剪辑区域（clipping region）以及所有 canvas 绘图环境对象的属性，包括 strokeStyle，fillStyle 与 globalCompositeOperation 等。canvas 状态并不保存当前的路径或位图，只能通过调用 beginPath()来充值路径，至于位图，他是 canvas 本身的一个属性，并不属于绘图环境对象。注意：尽管位图是 canvas 对象本身的属性，而可以通过绘图环境对象来访问它（在环境对象上调用 getImageData()方法） |
| restore() | 将 canvas 状态堆栈顶部的条目弹出，原来保存于栈顶的那组状态，在弹出之后，被设置成 canvas 当前状态，浏览器必须根据该值来设定 canvas 对应的属性，因此在调用 save()与 restore()之前，对 canvas 状态所进行的修改，其效果指挥持续至 restore()方法调用之前。                                                                                                                                                                                                                                         |

**基本的绘制操作**

```js
.arc()
.beginPath()
.clearRect()
.fill()
.fillText()
.lineTo()
.moveTo()
.stroke()
```

**一个基本的时钟程序**

```js
var canvas = document.getElementById('canvas');
var context = canvas.getContext('2d');
var FONT_HEIFHT = 15,
  MARGIN = 35,
  HAND_TRUNCATION = canvas.width / 25,
  HOUR_HAND_TRUNCATION = canvas.width / 10,
  NUMBER_SPACING = 20,
  RADIUS = canvas.width / 2 - MARGIN,
  HAND_RADIUS = RADIUS + NUMBER_SPACING;

function drawCircle() {
  context.beginPath();
  context.arc(canvas.width / 2, canvas.height / 2, RADIUS, 0, Math.PI * 2, true);
  context.stroke();
}

function drawNumerals() {
  var numerals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    angle = 0,
    numeralWidth = 0;
  numerals.forEach(function (numeral) {
    angle = (Math.PI / 6) * (numeral - 3);
    numeralWidth = context.measureText(numeral).width;
    context.fillText(
      numeral,
      canvas.width / 2 + Math.cos(angle) * HAND_RADIUS - numeralWidth / 2,
      canvas.height / 2 + Math.sin(angle) * HAND_RADIUS + FONT_HEIFHT / 3
    );
  });
}

function drawCenter() {
  context.beginPath();
  context.arc(canvas.width / 2, canvas.height / 2, 5, 0, Math.PI * 2, true);
  context.stroke();
}

function drawHand(loc, isHour) {
  var angle = Math.PI * 2 * (loc / 60) - Math.PI / 2,
    handRadius = isHour
      ? RADIUS - HAND_TRUNCATION - HOUR_HAND_TRUNCATION
      : RADIUS - HAND_TRUNCATION;
  context.moveTo(canvas.width / 2, canvas.height / 2);
  context.lineTo(
    canvas.width / 2 + Math.cos(angle) * handRadius,
    canvas.height / 2 + Math.sin(angle) * handRadius
  );
  context.stroke();
}

function drawHands() {
  var date = new Date(),
    hour = date.getHours();
  hour = hour > 12 ? hour - 12 : hour;
  drawHand(hour * 5 + (date.getMinutes() / 60) * 5, true, 0.5);
  drawHand(date.getMinutes(), false, 0.5);
  drawHand(date.getSeconds(), false, 0.2);
}

function drawClock() {
  context.clearRect(0, 0, canvas.width, canvas.height);
  drawCircle();
  drawCenter();
  drawHands();
  drawNumerals();
}
context.font = FONT_HEIFHT + 'px Arial';
loop = setInterval(drawClock, 1000);
```

**事件处理**

```js
//浏览器监听
canvas.onmousedown = function (e) {
  /**code*/
};
canvas.addEventListener('mousedown', function (e) {
  /**code*/
});

//将鼠标坐标转换为canvas坐标
function windowToCanvas(canvas, x, y) {
  var bbox = canvas.getBoundingClientRect();
  return {
    x: x - bbox.left * (canvas.width / bbox.width),
    y: y - bbox.top * (canvas.height / bbox.height)
  };
}
canvas.onmousemove = function (e) {
  var loc = windowToCanvas(canvas, e.clientX, e.clientY);
  drawBackground();
  drawSpritesheet();
  drawGuidelines(loc.x, loc.y);
  updateReadout(loc.x, loc.y);
};
```

**精灵表坐标查看器**

```html
<div id="readout"></div>
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    readout = document.getElementById('readout'),
    context = canvas.getContext('2d'),
    spritesheet = new Image();

  function windowToCanvas(canvas, x, y) {
    var bbox = canvas.getBoundingClientRect();
    return {
      x: x - bbox.left * (canvas.width / bbox.width),
      y: y - bbox.top * (canvas.height / bbox.height)
    };
  }
  function drawBackground() {
    var VERTICAL_LINE_SPACING = 12,
      i = context.canvas.height;
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.strokeStyle = 'lightgray';
    context.lineWidth = 0.5;
    while (i > VERTICAL_LINE_SPACING * 4) {
      context.beginPath();
      context.moveTo(0, i);
      context.lineTo(context.canvas.width, i);
      context.stroke();
      i -= VERTICAL_LINE_SPACING;
    }
  }
  function drawSpritesheet() {
    context.drawImage(spritesheet, 0, 0);
  }
  function drawGuidelines(x, y) {
    context.strokeStyle = 'rgba(0,0,230,0.8)';
    context.lineWidth = 0.5;
    drawVerticalLine(x);
    drawHorizontalLine(y);
  }

  function updateReadout(x, y) {
    readout.innerText = '(' + x.toFixed(0) + ',' + y.toFixed(0) + ')';
  }

  function drawHorizontalLine(y) {
    context.beginPath();
    context.moveTo(0, y + 0.5);
    context.lineTo(context.canvas.width, y + 0.5);
    context.stroke();
  }
  function drawVerticalLine(x) {
    context.beginPath();
    context.moveTo(x + 0.5, 0);
    context.lineTo(x + 0.5, context.canvas.height);
    context.stroke();
  }
  canvas.onmousemove = function (e) {
    var loc = windowToCanvas(canvas, e.clientX, e.clientY);
    drawBackground();
    drawSpritesheet();
    drawGuidelines(loc.x, loc.y);
    updateReadout(loc.x, loc.y);
  };
  spritesheet.src = 'close.svg';
  spritesheet.onload = function (e) {
    drawSpritesheet();
  };
  drawBackground();
</script>
```

**通过保存与恢复绘图表面来绘制辅助线**

```js
var canvas = document.getElementById('theCanvas'),
  context = canvas.getContext('2d');
function saveDrawingSurface() {
  drawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
}
function restoreDrawingSurface() {
  context.putImageData(drawingSurfaceImageData, 0, 0);
}
canvas.onmousedown = function (e) {
  saveDrawingSurface();
};
canvas.onmousemove = function (e) {
  var loc = windowToCanvas(e);
  if (dragging) {
    restoreDrawingSurface();

    if (guidewires) {
      drawGuidewires(mousedown.x, mousedown.y);
    }
  }
};
canvas.onmouseup = function (e) {
  restoreDrawingSurface();
};
```

**使用 DIV 元素来实现橡皮筋式选取框**

```html
 <style type="text/css">
    #rubberbandDiv{
        position: absolute;
        cursor: crosshair;
        display: none;
        height: 100px;
        width: 100px;
        border: solid 3px dodgerblue;
    }
    </style>
</head>

<body>
    <div id="controls">
        <button id="resetButton">reset</button>
    </div>
    <div id="rubberbandDiv"></div>
    <canvas height="800" width="1000" id="theCanvas"></canvas>
    <script>
var canvas=document.getElementById('theCanvas'),
context=canvas.getContext('2d');
rubberbandDiv=document.getElementById('rubberbandDiv'),
resetButton=document.getElementById('resetButton'),
image=new Image(),
mousedown={},
rubberbandRectangle={},
dragging=false;

function rubberbandStart(x,y){
    mousedown.x=x;
    mousedown.y=y;

    rubberbandRectangle.left=mousedown.x;
    rubberbandRectangle.top=mousedown.y;

    moveRubberbandDiv();
    showRubberbandDiv();

    dragging=true;
}

function rubberbandStretch(x,y){
rubberbandRectangle.left=x<mousedown.x?x:mousedown.x;
rubberbandRectangle.top=y<mousedown.y?y:mousedown.y;

rubberbandRectangle.width=Math.abs(x-mousedown.x);
rubberbandRectangle.height=Math.abs(y-mousedown.y);

moveRubberbandDiv();
resizeRubberbandDiv();
}

function rubberbandEnd(){
    var bbox=canvas.getBoundingClientRect();
    try{
        context.drawImage(canvas,
        rubberbandRectangle.left-bbox.left,
        rubberbandRectangle.top-bbox.top,
        rubberbandRectangle.width,
        rubberbandRectangle.height,
        0,0,canvas.width,canvas.height);
    }catch(e){

    }
    resetRubberbandRectangle();
    rubberbandDiv.style.width=0;
    rubberbandDiv.style.height=0;
    hideRubberbandDiv();
    dragging=false;
}
function moveRubberbandDiv(){
    rubberbandDiv.style.top=rubberbandRectangle.top+'px';
    rubberbandDiv.style.left=rubberbandRectangle.left+'px';
}

function resizeRubberbandDiv(){
    rubberbandDiv.style.width=rubberbandRectangle.width+'px';
    rubberbandDiv.style.height=rubberbandRectangle.height+'px';
}
function showRubberbandDiv(){
    rubberbandDiv.style.display='inline';
}
function hideRubberbandDiv(){
    rubberbandDiv.style.display='none';
}
function resetRubberbandRectangle(){
    rubberbandRectangle={top:0,left:0,width:0,height:0};
}
canvas.onmousedown=function(e){
    var x=e.clientX,y=e.clientY;
    e.preventDefault();
    rubberbandStart(x,y);
}
window.onmousemove=function(e){
    var x=e.clientX,y=e.clientY;
    e.preventDefault();
    if(dragging){
        rubberbandStretch(x,y);
    }
}
window.onmouseup=function(e){
    e.preventDefault();
    rubberbandEnd();
}
image.onload=function(){
    context.drawImage(image,0,0,canvas.width,canvas.height);
}
resetButton.onclick=function(e){
    context.clearRect(0,0,context.canvas.width,context.canvas.height);
    context.drawImage(image,0,0,canvas.width,canvas.height);
}
image.src='dlam1.jpg';
</script>
```

**使用 toDataURL()方法将 canvas 的内容打印出来**

```html
<div id="controls">
  <input id="snapshotButton" type="button" value="Take snapshot" />
</div>
<img id="snapshotImageElement" />
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d');
  var snapshotButton = document.getElementById('snapshotButton'),
    snapshotImageElement = document.getElementById('snapshotImageElement'),
    loop;
  snapshotButton.onclick = function (e) {
    var dataUrl;
    if (snapshotButton.value === 'Take snapshot') {
      dataUrl = canvas.toDataURL();
      clearInterval(loop);
      snapshotImageElement.src = dataUrl;
      snapshotImageElement.style.display = 'inline';
      canvas.style.display = 'none';
      snapshotButton.value = 'Return to Canvas';
    } else {
      canvas.style.display = 'inline';
      snapshotImageElement.style.display = 'none';
      loop = setInterval(drawClock, 1000);
      snapshotButton.value = 'Take snapshot';
    }
  };

  //画时钟代码
</script>
```

**以图像方式实现的时钟程序**

```html
<style type="text/css">
  #snapshotImageElement {
    position: absolute;
    left: 10px;
    border: thin solid #aaaaaa;
  }
</style>
<img id="snapshotImageElement" />
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d');
  var snapshotImageElement = document.getElementById('snapshotImageElement');
  //离屏canvas
  //var offscreen=document.createElement('theCanvas');
  //.....
  function updateClockImage() {
    snapshotImageElement.src = canvas.toDataURL();
  }
  function drawClock() {
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.save();
    context.fillStyle = 'rgba(255,255,255,0.8)';
    context.fillRect(0, 0, canvas.width, canvas.height);

    drawCircle();
    drawCenter();
    drawHands();
    context.restore();
    drawNumerals();
    updateClockImage();
  }
  //.....
</script>
```

## 第 2 章 绘制

**Canvas 的绘制模型**

在向 canvas 之上绘制图像或图形时，浏览器按照以下步骤操作：

1.将图形或图像绘制到一个无限大的透明位图中，在绘制时遵从当前的填充模式、描边模式以及线条样式。

2.将图像或图形的阴影绘制到另外一幅位图中，在绘制时使用当前绘图环境的阴影设定。

3.将阴影中每一个像素的 alpha 分量诚意绘图环境对象的 globalAlpha 属性值。

4.将绘有阴影的位图与经过剪辑区域剪切过的 canvas 进行图像合成，在操作时使用当前的合成模式参数。

5.将图形或图像的每一个像素颜色分量，乘以绘图环境对象的 globalAlpha 属性值。

6.将绘有图形或图像的位图，合成到当前经过剪辑区域剪切过的 canvas 位图之上，在操作时使用当前的合成操作符。

只有在启用阴影效果时才会执行第 2~4 步。

**矩形的绘制**

```js
//将整个canvas的内容清除

context.clearRect(double x,double y,double w,double h)

//绘制矩形边框

context.strokeRect(double x,double y,double w,double h)

//绘制矩形填充

context.fillRect(double x,double y,double w,double h)

```

**绘制简单的矩形**

```html
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d');
  context.lineJoin = 'round';
  context.lineWidth = 30;
  context.font = '24px Helvetica';
  context.fillText('Click anywhere to erase', 175, 40);
  context.strokeRect(75, 100, 200, 200);
  context.fillRect(325, 100, 200, 200);
  context.canvas.onmousedown = function (e) {
    context.clearRect(0, 0, canvas.width, canvas.height);
  };
</script>
```

**矩形的清除、描边与填充**

| 方法                                            | 描述                                                                                                                                                                                                                                                                                                                    |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| clearRect(double x,double y,double w,double h)  | 将指定矩形与当前剪辑区域相交范围内的所有像素清除。在默认情况下，剪辑区域的大小就是整个 canvas。所以，吐过你没有改动剪辑区域的话，那么在参数所指范围内的所有像素都会被清除。所谓“清除像素”指的是将其颜色设置位全透明黑色，在实际效果上就等同于“擦除"或者“清除"了某个像素，从而使得 canvas 的背景可以透过该像素显示出来。 |
| strokeRect(double x,double y,double w,double h) | 使用如下属性，指定矩形的描边：strokeStyle,lineWidth,lineJoin,miterLimit 如果宽度 w，高度 h 有一个为 0 的话，那么该方法将会分别绘制一条竖线或横线，如果两者都是 0 则不绘制任何东西。                                                                                                                                     |
| fillRect(double x,double y,double w,double h)   | 使用 fillStyle 属性填充指定的矩形，如果宽度或高度是 0 的话，则不绘制任何东西。                                                                                                                                                                                                                                          |

**颜色与透明度**

```html
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d');
  context.lineJoin = 'round';
  context.lineWidth = 30;
  context.font = '24px Helvetica';
  context.fillText('Click anywhere to erase', 175, 200);
  context.strokeStyle = 'goldenrod';
  context.fillStyle = 'rgba(0,0,255,0.5)';
  context.strokeRect(75, 100, 200, 200);
  context.fillRect(325, 100, 200, 200);
  context.canvas.onmousedown = function (e) {
    context.clearRect(0, 0, canvas.width, canvas.height);
  };
</script>
```

**渐变**

```js
var canvas = document.getElementById('theCanvas'),
  context = canvas.getContext('2d');
//线性渐变
var gradient = context.createLinearGradient(0, 0, canvas.width, 0);
//放射渐变
//var gradient=context.createRadialGradient(canvas.width/2,canvas.width/2,0,100);
gradient.addColorStop(0, 'blue');
gradient.addColorStop(0.25, 'red');
gradient.addColorStop(0.5, 'purple');
gradient.addColorStop(0.75, 'red');
gradient.addColorStop(1, 'yellow');
context.fillStyle = gradient;
context.rect(0, 0, canvas.width, canvas.height);
context.fill();
```

**渐变色**

| 方法                                                          | 描述                                                                                                                                          |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| createLinearGradient(double x0,double y0,double x1,double y1) | 创建线性渐变，传入该方法的参数表示渐变线的两个端点，该方法返回一个 CanvasGradient 实例，可以通过 addColorStop()方法来向该渐变色增加颜色停止点 |
| createRadialGradient(double x0,double y0,double x1,double y1) | 创建放射渐变，该方法的参数代表位于圆锥形渐变区域两端的圆形，与 createLinearGradient 方法一样。                                                |

**图案**

```html
<div>
  <input type="radio" id="repeatRadio" name="patternRadio" checked />repeat
  <input type="radio" id="repeatXRadio" name="patternRadio" />repeat-x
  <input type="radio" id="repeatYRadio" name="patternRadio" />repeat-y

  <input type="radio" id="noRepeatRadio" name="patternRadio" />no repeat
</div>
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d');
  var repeatRadio = document.getElementById('repeatRadio'),
    repeatXRadio = document.getElementById('repeatXRadio'),
    repeatYRadio = document.getElementById('repeatYRadio'),
    noRepeatRadio = document.getElementById('noRepeatRadio'),
    image = new Image();

  function fillCnavasWidthPattern(repeatString) {
    var pattern = context.createPattern(image, repeatString);
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = pattern;
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.fill();
  }
  repeatRadio.onclick = function (e) {
    fillCnavasWidthPattern('repeat');
  };
  repeatXRadio.onclick = function (e) {
    fillCnavasWidthPattern('repeat-x');
  };
  repeatYRadio.onclick = function (e) {
    fillCnavasWidthPattern('repeat-y');
  };
  noRepeatRadio.onclick = function (e) {
    fillCnavasWidthPattern('no-repeat');
  };
  image.src = 'bell.png';
  image.onload = function (e) {
    fillCnavasWidthPattern('repeat');
  };
</script>
```

**createPattern()方法**

| 方法                                                                                            | 描述                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| createPattern(HTMLImageElement\|HTMLCanvasElement\|HTMLVideoElement image,DOMString repetition) | 创建一个可以用来在 canvas 之中对图形和文本进行描边与填充图案，该方法第一个参数指定了图案所用的图像，它可以是 image 元素，canvas 元素或者 video 元素，第 2 个参数告诉浏览器，在对图形进行描边或填充时，应该如何重复该图案。有效值：repeat,repeat-x,repeat-y,no-repeat |

**阴影**

- shadowColor:CSS3 格式的颜色
- shadowOffsetX:从图形或文本到阴影的水平像素偏移
- shadowOffsetY:从图形或文本到阴影的垂直像素偏移
- shadowBlur:一个与像素无关的值，高斯模糊方程。以便对阴影进行模糊化处理

如果满足以下条件，那么使用 canvas 的绘图环境对象就可以绘制阴影效果：

1.指定的 shadowColor 值不是全透明的。

2.在其余的阴影属性之中，存在一个非 0 的值

```js
var SHADOW_COLOR = 'rgba(0,0,0,0.7)';

//.....
function setIconShadow() {
  iconContext.shadowColor = SHADOW_COLOR;
  //负偏移 内嵌阴影 正偏移 外阴影
  iconContext.shadowOffsetX = 4;
  iconContext.shadowOffsetY = 4;
  iconContext.shadowBlur = 5;
}
```

**绘制内嵌阴影**

```js
var drawingContext = document.getElementById('drawingCanvas').getContext('2d'),
  ERASER_LINE_WIDTH = 1,
  ERASER_SHADOW_STYLE = 'blue',
  ERASER_STROKE_STYLE = 'rgba(0,0,255,0.6)',
  ERASER_SHADOW_OFFSET = -5,
  ERASER_SHADOW_BLUR = 20,
  ERASER_RADIUS = 60;
function setEraserAttributes() {
  drawingContext.lineWidth = ERASER_LINE_WIDTH;
  drawingContext.shadowColor = ERASER_SHADOW_STYLE;
  drawingContext.shadowOffsetX = ERASER_SHADOW_OFFSET;
  drawingContext.shadowOffsetY = ERASER_SHADOW_OFFSET;
  drawingContext.shadowBlur = ERASER_SHADOW_BLUR;
  drawingContext.strokeStyle = ERASER_STROKE_STYLE;
}
function drawEraser(loc) {
  drawingContext.save();
  setEraserAttributes();
  drawingContext.beginPath();
  drawingContext.arc(loc.x, loc.y, ERASER_RADIUS, 0, Math.PI * 0.2, false);
  drawingContext.clip();
  drawingContext.stroke();
  drawingContext.restore();
}
```

**CanvasRenderingContext2D 之中与阴影效果有关的属性**

| 属性          | 描述                                                                                                                               |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| shadowBlur    | 表示阴影效果如何延伸的 double 值，浏览器在阴影之上运用高斯模糊时，将会用到该值，它与像素无关，只会被用在高斯模糊方程之中，默认值 0 |
| shadowColor   | CSS 格式的颜色字串，默认值 rgba(0,0,0,0)                                                                                           |
| shadowOffsetX | 阴影在 X 轴上偏移量，以像素为单位，默认 0                                                                                          |
| shadowOffsetY | 阴影在 Y 轴上偏移量，以像素为单位，默认 0                                                                                          |

**文本、矩形与圆弧的描边及填充**

```js
var context = document.getElementById('drawingCanvas').getContext('2d');
function drawGrid(context, color, stepx, stepy) {}
drawGrid(context, 'lightgray', 10, 10);
context.font = '48pt Helvetica';
context.fillStyle = 'red';
context.lineWidth = '2';
context.strokeText('Stroke', 60, 110);
context.fillText('Fill', 440, 110);
context.strokeText('Stroke & Fill', 650, 110);
context.fillText('Stroke & Fill', 650, 110);
context.lineWidth = '5';
context.beginPath();
context.rect(80, 150, 150, 100);
context.stroke();

context.beginPath();
context.rect(400, 150, 150, 100);
context.arc(475, 370, 60, 0, (Math.PI * 3) / 2);
context.closePath();
context.fill();
```

**CanvasRenderingContext2D 之中与路径有关**

| 方法                                       | 描述                                                                                                                                                                                                                                                                                               |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| arc()                                      | 在当前路径中增加一段表示圆弧或圆形的子路径，与 rect 方法不同，可以通过一个 boolean 参数来控制该段子路径的方向。参数为 true，那么 arc()所创建的子路径就是顺时针的，否在逆时针。如果在调用该方法时以及由其他的子路径存在，那么 arc()方法则会用一条线段把已有路径的终点与这段圆弧路径的起点连接起来。 |
| beginPath()                                | 将当前路径之中的所有子路径都清除掉，以此来重置当前路径。                                                                                                                                                                                                                                           |
| closePath()                                | 显式地封闭某段开放路径，该方法用于封闭圆弧路径以及由曲线或线段所创建的开放路径。                                                                                                                                                                                                                   |
| fill()                                     | 使用 fillStyle 对当前路径的内部进行填充                                                                                                                                                                                                                                                            |
| rect(double x,double y,double w, double h) | 在坐标(x,y)外建立一个宽度为 w，高度为 h 的矩形子路径，该子路径一定时封闭的，而且总是按逆时针方向来创建                                                                                                                                                                                             |
| stroke()                                   | 使用 strokeStyle 来描绘当前路径的轮廓线                                                                                                                                                                                                                                                            |

**运用非零环绕规则来实现剪纸效果**

```js
var context = document.getElementById('drawingCanvas').getContext('2d');
function drawGrid(context, color, stepx, stepy) {}
function drawTwoArcs() {
  context.beginPath();
  context.arc(300, 190, 150, 0, Math.PI * 2, false);
  context.arc(300, 190, 100, 0, Math.PI * 2, true);
  context.fill();
  context.shadowColor = undefined;
  (context.shadowOffsetX = 0), (context.shadowOffsetY = 0);
  context.stroke();
}

function draw() {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  drawGrid('lightgray', 10, 10);
  context.save();
  context.shadowColor = 'rgba(0,0,0,0.8)';
  context.shadowOffsetX = 12;
  context.shadowOffsetY = 12;
  context.shadowBlur = 15;
  drawTwoArcs();
  context.restore();
}
context.fillStyle = 'rgba(100,140,230,0.5)';
context.strokeStyle = context.fillStyle;
draw();

function drawCutouts() {
  context.beginPath();
  addOutRectanglePath();
  addCirclePath();
  addRectanglePath();
  addTrianglePath();
  context.fill();
}

function rect(x, y, w, h, direction) {
  if (direction) {
    context.moveTo(x, y);
    context.lineTo(x, y + h);
    context.lineTo(x + w, y + h);
    context.lineTo(x + w, y);
  } else {
    context.moveTo(x, y);
    context.lineTo(x + w, y);
    context.lineTo(x + w, y + h);
    context.lineTo(x, y + h);
  }
  context.closePath();
}
function addOuterRectanglePath() {
  context.rect(110, 25, 370, 335);
}
function addRectanglePath() {
  rect(310, 55, 70, 35, true);
}
```

**绘制剪纸图形**

```js
var canvas = document.getElementById('theCanvas').getContext('2d');
function drawGrid(color, stepx, stepy) {}
function draw() {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  drawGrid('lightgray', 10, 10);
  context.save();
  context.shadowColor = 'rgba(200,200,0,0,0.5)';
  context.shadowOffsetX = 12;
  context.shadowOffsetY = 12;
  context.shadowBlur = 15;
  drawCutouts();
  strokeCutoutShapes();
  context.restore();
}
function drawCutouts() {
  context.beginPath();
  addOuterRectanglePath();
  addCirclePath();
  addRectanglePath();
  addTrianglePath();
  context.fill();
}
function strokeCutoutShapes() {
  context.save();
  context.strokeStyle = 'rgba(0,0,0,0.7)';
  context.beginPath();
  addOuterRectanglePath();
  context.stroke();
  context.beginPath();
  addCirclePath();
  addRectanglePath();
  addTrianglePath();
  context.stroke();
  context.restore();
}
function rect(x, y, w, h, direction) {
  if (direction) {
    context.moveTo(x, y);
    context.lineTo(x, y + h);
    context.lineTo(x + w, y + h);
    context.lineTo(x + w, y);
  } else {
    context.moveTo(x, y);
    context.lineTo(x + w, y);
    context.lineTo(x + w, y + h);
    context.lineTo(x, y + h);
  }
  context.closePath();
}
function addOuterRectanglePath() {
  context.rect(110, 25, 370, 335);
}
function addRectanglePath() {
  rect(310, 55, 70, 35, true);
}
function addCirclePath() {
  context.arc(300, 300, 40, 0, Math.PI * 2, true);
}
function addTrianglePath() {
  context.moveTo(400, 200);
  context.lineTo(250, 115);
  context.lineTo(200, 200);
  context.closePath();
}
context.fillStyle = 'goldenrod';
draw();
```

**绘制线段**

```js
var canvas = document.getElementById('theCanvas').getContext('2d');
context.lineWidth = 1;
context.beginPath();
context.moveTo(50, 10);
context.lineTo(450, 10);
context.stroke();
```

**moveTo()和 lineTo()**

| 方法        | 描述                                                                                                                                                                                      |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| moveTo(x,y) | 向当前路径中增加一条子路径，该子路径只包含一个点，就是由参数传入的那个点，该方法并不会从当前路径中清除任何子路径                                                                          |
| lineTo(x,y) | 如果当前路径中没有子路径，那么这个方法的行为与 moveTo()方法，他会创建一条新的子路径，其中包含了经由参数所传入的那个点。如果当前路径中存在子路径，那该方法将你所指定的那个点加入子路径中。 |

**绘制网格**

```js
var canvas = document.getElementById('theCanvas').getContext('2d');
function drawGrid(context, color, stepx, stepy) {
  context.strokeStyle = color;
  context.lineWidth = 0.5;
  for (var i = stepx + 0.5; i < context.canvas.width; i += stepx) {
    context.beginPath();
    context.moveTo(i, 0);
    context.lineTo(i, context.canvas.height);
    context.stroke();
  }
  for (var i = stepy + 0.5; i < context.canvas.height; i += stepy) {
    context.beginPath();
    context.moveTo(0, i);
    context.lineTo(context.canvas.width, i);
    context.stroke();
  }
}
drawGrid(context, 'lightgray', 10, 10);
```

**绘制坐标轴**

```js
var canvas = document.getElementById('canvas'),
  context = canvas.getContext('2d'),
  AXIS_MARGIN = 40,
  AXIS_ORIGIN = { x: AXIS_MARGIN, y: canvas.height - AXIS_MARGIN },
  AXIS_TOP = AXIS_MARGIN,
  AXIS_RIGHT = canvas.width - AXIS_MARGIN,
  HORIZONTAL_TICK_SPACING = 10,
  VERTICAL_THICK_SPACING = 10,
  AXIS_WIDTH = AXIS_RIGHT - AXIS_ORIGIN.x,
  AXIS_HEIGHT = AXIS_ORIGIN.y - AXIS_TOP,
  NUM_VERTICAL_TICKS = AXIS_HEIGHT / VERTICAL_THICK_SPACING,
  NUM_HORIZONTAL_TICKS = AXIS_WIDTH / HORIZONTAL_TICK_SPACING,
  TICK_WIDTH = 10,
  TICK_LINEWIDTH = 0.5,
  TICK_COLOR = 'navy',
  AXIS_LINEWIDTH = 1.0,
  AXIS_COLOR = 'blue';

function drawGrid(color, stepx, stepy) {}
function drawAxes() {
  context.save();
  context.strokeStyle = AXIS_COLOR;
  context.lineWidth = AXIS_LINEWIDTH;
  drawHorizontalAxis();
  drawVerticalAxis();
  context.lineWidth = 0.5;
  context.lineWidth = TICK_LINEWIDTH;
  context.strokeStyle = TICK_COLOR;
  drawVerticalAxisTicks();
  drawHorizontalAxisTicks();
  context.restore();
}
function drawHorizontalAxis() {
  context.beginPath();
  context.moveTo(AXIS_ORIGIN.x, AXIS_ORIGIN.y);
  context.lineTo(AXIS_RIGHT, AXIS_ORIGIN.y);
  context.stroke();
}
function drawVerticalAxis() {
  context.beginPath();
  context.moveTo(AXIS_ORIGIN.x, AXIS_ORIGIN.y);
  context.lineTo(AXIS_ORIGIN.x, AXIS_TOP);
  context.stroke();
}
function drawVerticalAxisTicks() {
  var deltaX;
  for (var i = 1; i < NUM_VERTICAL_TICKS; ++i) {
    context.beginPath();
    if (i % 5 === 0) deltaX = TICK_WIDTH;
    else deltaX = TICK_WIDTH / 2;
    context.moveTo(AXIS_ORIGIN.x - deltaX, AXIS_ORIGIN.y - i * VERTICAL_THICK_SPACING);
    context.lineTo(AXIS_ORIGIN.x + deltaX, AXIS_ORIGIN.y - i * VERTICAL_THICK_SPACING);
    context.stroke();
  }
}

function drawHorizontalAxisTicks() {
  var deltaY;
  for (var i = 1; i < NUM_VERTICAL_TICKS; ++i) {
    context.beginPath();
    if (i % 5 === 0) deltaY = TICK_WIDTH;
    else deltaY = TICK_WIDTH / 2;
    context.moveTo(AXIS_ORIGIN.x - deltaY, AXIS_ORIGIN.y - i * HORIZONTAL_TICK_SPACING);
    context.lineTo(AXIS_ORIGIN.x + deltaY, AXIS_ORIGIN.y - i * HORIZONTAL_TICK_SPACING);
    context.stroke();
  }
}
drawGrid('lightgray', 10, 10);
drawAxes();
```

**橡皮筋式的线条绘制**

```html
<div id="controls">
  Stroke color:
  <select id="strokeStyleSelect">
    <option value="red">red</option>
    <option value="green">green</option>
    <option value="blue">blue</option>
    <option value="orange">orange</option>
    <option value="cornflowerblue">cornflowerblue</option>
    <option value="goldenrod">goldenrod</option>
    <option value="navy">navy</option>
    <option value="purple">purple</option>
  </select>
  Guidewires:
  <input type="checkbox" checked id="guidewireCheckbox" />
  <input type="button" id="eraseAllButton" value="Erase all" />
</div>
<canvas height="500" width="500" id="theCanvas"></canvas>
<script>
  var canvas = document.getElementById('theCanvas'),
    context = canvas.getContext('2d'),
    eraseAllButton = document.getElementById('eraseAllButton'),
    strokeStyleSelect = document.getElementById('strokeStyleSelect'),
    guidewireCheckbox = document.getElementById('guidewireCheckbox'),
    drawingSurfaceImageData,
    mousedown = {},
    rubberbandRect = {},
    dragging = false,
    guidewires = guidewireCheckbox.checked;

  function drawGird(color, stepx, stepy) {}

  function windowToCanvas(x, y) {
    var bbox = canvas.getBoundingClientRect();
    return {
      x: x - bbox.left * (canvas.width / bbox.width),
      y: y - bbox.top * (canvas.height / bbox.height)
    };
  }
  function saveDrawingSurface() {
    drawingSurfaceImageData = context.getImageData(0, 0, canvas.width, canvas.height);
  }
  function restoreDrawingSurface() {
    putImageData(drawingSurfaceImageData, 0, 0);
  }
  function updateRubberbandRectangle(loc) {
    rubberbandRect.width = Math.abs(loc.x - mousedown.x);
    rubberbandRect.height = Math.abs(loc.y - mousedown.y);
    if (loc.x > mousedown.x) rubberbandRect.left = mousedown.x;
    else rubberbandRect.left = loc.x;
    if (loc.y > mousedown.y) rubberbandRect.top = mousedown.y;
    else rubberbandRect.top = loc.y;
  }
  function drawRubberbandShape(loc) {
    context.beginPath();
    context.moveTo(mousedown.x, mousedown.y);
    context.lineTo(loc.x, loc.y);
    context.stroke();
  }
  function updateRubberband(loc) {
    updateRubberbandRectangle(loc);
    drawRubberbandShape(loc);
  }
  function drawHorizontalLine(y) {
    context.beginPath();
    context.moveTo(0, y + 0.5);
    context.lineTo(context.canvas.width, y + 0.5);
    context.stroke();
  }
  function drawVerticalLine(x) {
    context.beginPath();
    context.moveTo(x + 0.5, 0);
    context.lineTo(x + 0.5, context.canvas.height);
    context.stroke();
  }
  function drawGuidewires(x, y) {
    context.save();
    context.strokeStyle = 'rgba(0,0,230,0.4)';
    context.lineWidth = 0.5;
    drawVerticalLine(x);
    drawHorizontalLine(y);
    context.restore();
  }
  canvas.onmousedown = function (e) {
    var loc = windowToCanvas(e.clientX, e.clientY);
    e.preventDefault();
    saveDrawingSurface();
    mousedown.x = loc.x;
    mousedown.y = loc.y;
    dragging = true;
  };
  canvas.onmousemove = function (e) {
    var loc;
    if (dragging) {
      e.preventDefault();
      loc = windowToCanvas(e.clientX, e.clientY);
      restoreDrawingSurface();
      updateRubberband(loc);

      if (guidewires) {
        drawGuidewires(loc.x, loc.y);
      }
    }
  };
  canvas.onmousedown = function (e) {
    loc = windowToCanvas(e.clientX, e.clientY);
    restoreDrawingSurface();
    updateRubberband(loc);
    dragging = false;
  };
  eraseAllButton.onclick = function (e) {
    context.clearRect(0, 0, canvas.width, canvas.height);
    drawGird('lightgray', 10, 10);
    saveDrawingSurface();
  };
  strokeStyleSelect.onchange = function (e) {
    context.strokeStyle = strokeStyleSelect.value;
  };
  guidewireCheckbox.onchange = function (e) {
    guidewires = guidewireCheckbox.checked;
  };
  context.strokeStyle = strokeStyleSelect.value;
  drawGird('lightgray', 10, 10);
</script>
```

**虚线绘制**

```js
var context = document.getElementById('theCanvas').getContext('2d');
function drawDashedLine(context, x1, y1, x2, y2, dashLength) {
  dashLength = dashLength === undefined ? 5 : dashLength;
  var deltaX = x2 - x1;
  var deltaY = y2 - y1;
  var numDashes = Math.floor(Math.sqrt(deltaX * deltaX + deltaY * deltaY) / dashLength);
  for (var i = 0; i < numDashes; i++) {
    context[i % 2 === 0 ? 'moveTo' : 'lineTo'](
      x1 + (deltaX / numDashes) * i,
      y1 + (deltaY / numDashes) * i
    );
  }
  context.stroke();
}
context.lineWidth = 3;
context.strokeStyle = 'blue';
drawDashedLine(context, 20, 20, context.canvas.width - 20, 20);
drawDashedLine(context, context.canvas.width - 20, 20, context.canvas.height - 20, 10);
drawDashedLine(
  context,
  context.canvas.width - 20,
  context.canvas.height - 20,
  context.canvas.height - 20,
  15
);
drawDashedLine(context, 20, context.canvas.height - 20, 20, 2);
```

**扩展 CanvasRenderingContext2D 对象**

```js
var context = document.getElementById('theCanvas').getContext('2d'),
  moveToFunction = CanvasRenderingContext2D.prototype.moveTo;
CanvasRenderingContext2D.prototype.lastMoveToLocation = {};
CanvasRenderingContext2D.prototype.moveTo = function (x, y) {
  moveToFunction.apply(context, [x, y]);
  this.lastMoveToLocation.x = x;
  this.lastMoveToLocation.y = y;
};
CanvasRenderingContext2D.prototype.dashedLineTo = function (x, y, dashLength) {
  dashLength = dashLength === undefined ? 5 : dashLength;
  var startX = this.lastMoveToLocation.x;
  var startY = this.lastMoveToLocation.y;
  var deltaX = x - startX;
  var deltaY = y - startY;
  var numDashes = Math.floor(Math.sqrt(deltaX * deltaX + deltaY * deltaY) / dashLength);
  for (var i = 0; i < numDashes; i++) {
    this[i % 2 === 0 ? 'moveTo' : 'lineTo'](
      startX + (deltaX / numDashes) * i,
      startY + (deltaY / numDashes) * i
    );
  }
  this.moveTo(x, y);
};
context.lineWidth = 3;
context.strokeStyle = 'blue';
context.moveTo(20, 20);
context.dashedLineTo(context.canvas.width - 20, 20);
context.dashedLineTo(context.canvas.width - 20, context.canvas.height - 20);
context.dashedLineTo(20, context.canvas.height - 20);
context.dashedLineTo(20, 20);
context.stroke();
```

**CanvasRenderingContext2D 对象中与线段绘制有关**

| 属性       | 描述                                                                                                  | 类型      | 取值范围           | 默认值 |
| ---------- | ----------------------------------------------------------------------------------------------------- | --------- | ------------------ | ------ |
| lineWidth  | 以像素为单位的线段宽度                                                                                | double    | 非零正数           | 1.0    |
| lineCap    | 该值决定浏览器如何绘制线段的端点                                                                      | DOMString | butt,round,square  | butt   |
| lineJoin   | 该值决定浏览器如何绘制线段的连接点                                                                    | DOMString | round,bevel，miter | bevel  |
| miterLimit | 斜接线长度与二分之一线宽的比值，如果斜接线的长度超过了该值，浏览器就会以 bevel 方式来绘制线段的连接点 | double    | 非零正数           | 10.0   |

**以橡皮筋式辅助线来协助用户画圆**

```js
function drawRubberbandShape(loc) {
  var angle, radius;
  if (mousedown.y === loc.y) {
    radius = Math.abs(loc.x - mousedown.x);
  } else {
    angle = Math.atan(rubberbandRect.height / rubberbandRect.width);
    radius = rubberbandRect.height / Math.sin(angle);
  }
  context.beginPath();
  context.arc(mousedown.x, mousedown.y, radius, 0, Math.PI * 2, false);
  context.stroke();
  if (fillCheckbox.checked) {
    context.fill();
  }
}
```

**arcTo()**

```js
var context = document.getElementById('theCanvas').getContext('2d');
function drawRubberbandShape(loc) {
  var angle, radius;
  if (mousedown.y === loc.y) {
    radius = Math.abs(loc.x - mousedown.x);
  } else {
    angle = Math.atan(rubberbandRect.height / rubberbandRect.width);
    radius = rubberbandRect.height / Math.sin(angle);
  }
  context.beginPath();
  context.arc(mousedown.x, mousedown.y, radius, 0, Math.PI * 2, false);
  context.stroke();
  if (fillCheckbox.checked) {
    context.fill();
  }
}

function roundedRect(cornerX, cornerY, width, height, cornerRadius) {
  if (width > 0) context.moveTo(cornerX + cornerRadius, cornerY);
  else context.moveTo(cornerX - cornerRadius, cornerY);
  context.arcTo(cornerX + width, cornerY, cornerX + width, cornerY + height, cornerRadius);
  context.arcTo(cornerX + width, cornerY + height, cornerX, cornerY + height, cornerRadius);
  context.arcTo(cornerX, cornerY + height, cornerX, cornerY, cornerRadius);
  if (width > 0) {
    context.arcTo(cornerX, cornerY, cornerX + cornerRadius, cornerY, cornerRadius);
  } else {
    context.arcTo(cornerX, cornerY, cornerX - cornerRadius, cornerY, cornerRadius);
  }
}

function drawRoundedRect(strokeStyle, fillStyle, cornerX, cornerY, width, height, cornerRadius) {
  context.beginPath();
  roundedRect(cornerX, cornerY, width, height, cornerRadius);
  context.strokeStyle = strokeStyle;
  context.fillStyle = fillStyle;
  context.stroke();
  context.fill();
}
drawRoundedRect('blue', 'yellow', 50, 40, 100, 100, 10);
drawRoundedRect('purple', 'green', 275, 40, -100, 100, 20);
drawRoundedRect('red', 'white', 300, 140, 100, -100, 30);
drawRoundedRect('white', 'blue', 525, 140, -100, -100, 40);
```

**CanvasRenderingContext2D 对象用于绘制圆弧及圆形**

| 方法                                                                                            | 描述                                                                                                                                                                                                                                                                                                          |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| arc(double x,double y,double radius,double startAngle,double endAngle,boolean counterClockwise) | 创建一条(x,y)为圆心，以 radius 为半径，以 startAngle,endAngle 为起止角的圆弧路径。角度单位式弧度，不是角度（180 角度=PI 弧度）最后一个参数可选，如果 true，则按逆时针画弧，如果 false（默认），则按顺时针画弧。如果再调用该方法时，当前路径中有子路径存在，那么浏览器将子路径的终点与所画弧的起点以线段相连。 |
| arcTo(double x1,double y1,double x2,double y2,double radius)                                    | 创建一条以 radius 为半径的圆弧路径。该圆弧与当前点到（x1,y1)点的连线相切，同时(x1,y1)到（x2,y2）连线相切。与 arc()一样，如果调用该方法时，当前路径中有子路径存在，那么浏览器将会从子路径的终点向起点处画一条线段。                                                                                            |

**二次方贝塞尔曲线**

```js
//创建一条表示二次方贝塞尔曲线的路径，第一个点曲线的控制点，第二个点锚点
context.quadraticCurveTo(double x1,double y1,double x2,double y2)

//创建一条代表三次方贝塞尔曲线的路径，三个坐标的中，前两个点控制点，最后一个锚点
context.bezierCurveTo(double x1,double y1,double x2,double y2,double x3,double y3)
```

**CanvasRenderingContext2D 用于平移、旋转坐标系**
|方法|描述|
|----|----|
|rotate(double angleInRadians)|按照给定的角度来旋转坐标系|
|scale(double x,double y)|在 X 与 Y 方向上分别按照给定的数值来缩放坐标系|
|translate(double x,double y)|将坐标系平移到给定的 X、y 坐标处|

**变换矩阵方法**

- transform()可以在当前的变化矩阵之上叠加运用另外的变化效果；
- setTransform()将当前的变化矩阵设置为默认的单位矩阵，然后在单位矩阵之上运用用户指定的变化效果。
- 多次调用 transform()方法造成的变换效果是累积，每次只要调用 setTransform()，它就会将上一次的变换矩阵彻底清除。

**用于坐标变换的方法**

```js
transform(double a,double b,double c,double d,double e,double f);
setTransform(double a,double b,double c,double d,double e,double f);
//使用该方程对平移，缩放，旋转操作
x1=ax+cy+e;
y1=bx+dy+f;
```

**图形合成**

| 合成模式         | 说明                                           | 合成模式         | 说明                               |
| ---------------- | ---------------------------------------------- | ---------------- | ---------------------------------- |
| source-atop      | 整个新图，并包含与旧图重叠部分在上方           | source-in        | 新图与旧图重叠的新图部分(不可移植) |
| source-out       | 新图与旧图不重叠的新图部分(不可移植)           | source-over      | 新图遮盖旧图                       |
| destination-atop | 整个旧图，并包含与新图重叠部分在上方(不可移植) | destination-in   | 新图与旧图重叠的旧图部分(不可移植) |
| destination-out  | 新图与旧图不重叠的旧图部分                     | destination-over | 旧图遮盖新图                       |
| lighter          | 两图重叠部分作加色处理                         | copy             | 只保留新图(不可移植)               |
| xor              | 两图重叠部分变透明                             | darker           | 两图重叠部分作减色处理             |

```js
//设置合成模式
context.globalCompositeOperation = 'source-in';
```

**剪辑区域**

他是在 canvas 之中由路径所定义的一块区域，浏览器会将所有的绘图操作都限制在本区域内执行，在默认情况下，剪辑区域的大小与 canvas 一致，除非你通过创建路径并调用 canvas 绘图环境对象**clip()**方法来显示的设定剪辑区域，否则默认的剪辑区域不会影响 canvas 之中所绘制的内容，然而，一旦设置好剪辑区域，那么在 canvas 之中绘制的所有内容都将局限在该区域内，这意味在剪辑区域以外进行绘制时没有任何效果的

**clip()**

将剪辑区域设置为当前剪辑区域与当前路径的交集。第一次调用 clip 之前。剪辑区域的大小与整个 canvas 一致。

因为 clip()方法会将剪辑区域设置为当前剪辑区域与当前路径的交际，所以对该方法的调用一般都是嵌入 save()与 restore()方法之间的，否则剪辑区域将会越变越小。

## 第 3 章 文本

**文本的描边与填充**

```js
//文本内容填充 maxWidth以像素为单位指定所绘文本的的最大宽度，可选
context.fillText(text, canvas.width / 2, canvas.height / 2, maxWidth);
//文本描边
context.strokeText(text, canvas.width / 2, canvas.height / 2, maxWidth);
//测量文本，返回TextMetrics对象,包含width文本像素宽度
context.measureText(text);
//设置文本属性
context.font = '256px Palatino';
context.textAlign = 'center';
context.textBaseline = 'bottom';
//渐变色填充文本
var gradient = context.createLinearGradient(0, 0, canvas.width, canvas.height);
context.fillStyle = gradient;
context.fillText(text, 65, 200);
context.strokeText(text, 65, 200);
```

**设置字型属性**

| 字型属性分量 | 有效取值                                                               |
| ------------ | ---------------------------------------------------------------------- |
| font-style   | normal,italic,oblique                                                  |
| font-variant | nromal,small-caps                                                      |
| font-weight  | normal,bold,bolder,lighter,100,200,300,...,900                         |
| font-size    | xx-small,x-small,medium,large,x-large,xx-large,smaller,larger,length,% |
| line-height  | normal,px,                                                             |
| font-family  | helvetica,verdana,palatino...                                          |
| textAlign    | start,center,end,left,right                                            |
| textBaseline | top,bottom,middle,alphabetic,ideographic,hanging                       |

## 第 4 章 图像与视频

**drawImage()**

源图像:source-image ------ s

目标 canvas:destination-canvas -----d

```js
//将整幅图像绘制在目标canvas中的指定位置上
drawImage(image, dx, dy);
//将图像完整地绘制到指定的位置上，绘制时会根据目标区域的宽度与高度进行缩放
drawImage(image, dx, dy, dw, dh);
//将整幅图像或其一部分绘制到目标canvas的指定位置上，绘制时会根据目标区域的宽高对图像进行缩放。
drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
```

| 方法        | 描述                                                                                                                                                                                                                                                                                                                                                                                                    |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| drawImage() | 将图像绘制到 canvas 之中，如果图像参数时一个 HTMLVideoElement 类型的适配对象，那么 drawIamge 会将视频的当前帧绘制出来，这图像参数也可时另一个 HTMLCanvasElement 的 canvas 对象。向 canvas 之中绘制的图像可以是一整幅，也可以是它的一部分，并且在绘制时有可能要对图像进行缩放。源图像中需要被绘制的区域是通过 sx,sy,sw,sh 参数来确定的，浏览器会根据 dw 与 dh 参数对所绘内容进行缩放，前三参数是必须的。 |

```js
//创建新的空白 ImageData 对象。
context.createImageData(width, height);
context.createImageData(imageData);
//返回 ImageData 对象，该对象拷贝了画布指定矩形的像素数据。
context.getImageData(sx, sy, sw, sh);
//将图像数据（从指定的 ImageData 对象）放回画布上。
context.putImageData(imgData, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
```

| 方法           | 描述                                                                                                                                                                                                                                                                                                                                                                                          |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| getImageData() | 返回一个 ImageData 对象，该对象所含的数组具有 4XwXh 个整数值，w 和 h 表示以设备像素为单位的图像宽度与高度，可以通过 width 与 height 属性来访问该 ImageData 对象的宽度与高度。ImageData 对象所含的 data 数组中，每 4 个整数值代表 1 个像素，这些整数分别表示红，绿，栏色分量，透明度的 alpha 值。注意：该方法返回 ImageData 对象的宽度(设备像素)并不总是等于传递给它的宽度（CSS 像素）参数值。 |
| putImageData() | 将图像数据绘制在 canvas 的(dx,dy)坐标处，该坐标以 CSS 像素为单位，后面 4 个参数指定的脏矩形表示浏览器将会把这个矩形范围内的图像数据赋值到屏幕 canvas，指定该矩形时需以设备像素为单位。                                                                                                                                                                                                        |

**修改图像数据**

ImageData 对象中的 data 属性指向一个包含 8 位二进制整数的数组，这些整数的值位于 0~255 之间，分别表示一个像素的红绿栏及透明度分量。

| imageData.data[i] | 对应颜色 |
| ----------------- | -------- |
| i                 | 红色     |
| i+1               | 绿色     |
| i+2               | 蓝色     |
| i+3               | 透明度   |

```js
var data=imageData.data;
//反色滤镜
for(var i=0;i<data.length-4;i+=4){
    data[i]=255-data[i];
     data[i+1]=255-data[i+1];
     data[i+2]=255-data[i+2];
}
//黑白滤镜
for(var i=0;i<data.length-4;i+=4){
    var average=(data[i]+data[i+1]+data[i+2])/3;
    data[i]=average;
     data[i+1]=average;
     data[i+2]=average;
}
//浮雕滤镜
var width=imageData.width;
for(var i=0;i<data.length;i++){
    if(i<=data.length-width*4){
        if((i+1)%4!==0){
            if((i+4)%(width*4)==0){
                data[i]=data[i-4];
                data[i+1]=data[i-3];
                data[i+2]=data[i-2];
                data[i+3]=data[i-1];
                i+=4;
            }else{
                data[i]=255/2+2*data[i]-data[i+4]-data[i+width*4];
            }
        }
    }else{
        if((i+1)%4!==0){
            data[i]=data[i-width*4];
        }
    }
}
//主线程
for(var i=0;i<data.length;++i){
    if((i+1)%4!=0){
        if((i+4)%(width*4)==0){
            data[i]=data[i-4];
                data[i+1]=data[i-3];
                data[i+2]=data[i-2];
                data[i+3]=data[i-1];
                i+=4;
        }else{
             data[i]=2*data[i]-data[i+4]-0.5*data[i+4];
        }
    }
}

//半透明
for(var i=3;i<data.length;i+=4){
    data[i]=0.5；
}
```

**将 canvas 保存位图片文件,FIleSystem API 用法**

```js
canvas.addEventListener(
  'dragenter',
  function (e) {
    e.preventDefault();
    e.dataTransfer.effectAllowed = 'copy';
  },
  false
);
canvas.addEventListener(
  'dragover',
  function (e) {
    e.preventDefault();
  },
  false
);

window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;

canvas.addEventListener(
  'drop',
  function (e) {
    var file = e.dataTransfer.files[0];
    window.requestFileSystem(
      window.TEMPORARY,
      5 * 1024 * 1024,
      function (fs) {
        fs.root.getFile(
          file.name,
          { create: true },
          function (fileEntry) {
            fileEntry.createWriter(function (writer) {
              writer.write(file);
            });
            image.src = fileEntry.toURL();
          },
          function (e) {
            alert(e.code);
          }
        );
      },
      function (e) {
        alert(e.code);
      }
    );
  },
  false
);
```

**视频处理**

```js
//在canvas中播放视频文件
function animate() {
  if (!video.ended) {
    context.drawIamge(video, 0, 0, canvas.width.canvas.height);
    window.requestNextAnimationFrame(animate);
  }
}
video.play();
window.requestNextAnimationFrame(animate);
```

## 第 5 章 动画

| 方法                                                      | 描述                                                                                                                   |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| long window.requestAnimationFrame(FrameRequestCallback c) | 请求浏览器在绘制下一帧动画时调用指定的回调函数。若取消回调，可将该方法所返回的句柄传递给 cancelRequestAnimationFrame() |
| viod window.cancelRequestAnimationFrame(long handle)      | 将原来以 requestAnimationFrame()方法所注册的回调函数取消执行，必须在浏览器还未执行回调函数时才能调用此方法。           |

```js
//Firefox
window.mozRequestAnimationFrame(FrameRequestCallback c)
//chrome
window.webkitRequestAnimationFrame(FrameRequestCallback c)
//Internet Explorer
window.msRequestAnimationFrame(FrameRequestCallback c)

window.requestNextAnimationFrame=(function(){
return window.requestAnimationFrame||
window.webkitRequestAnimationFrame||
window.mozRequestAnimationFrame||
window.msRequestAnimationFrame||
function(callback,element){
   var self=this,start,finish;
   window.setTimeout(function(){
       start=+new Date();
       callback(start);
       finish=+new Date();
       self.timeout=1000/60-(finish-start);
   },self.timeout);
}})();

//用于实现W3C规范所定义requestAnimationFrame()功能的“Polyfill式方法”
window.requestAnimationFrame=(function(){
var originWebkitMethod,
wrapper=undefined,
callback=undefined,
geckoVersion=0,
userAgent=navigator.userAgent,
index=0,
self=this;

if(window.webkitRequestAnimationFrame){
    wrapper=function(time){
        if(time===undefined){
            time=+new Date();
        }
        self.callback(time);
    };

    originWebkitMethod=window.webkitRequestAnimationFrame;
    window.webkitRequestAnimationFrame=function(callback,element){
        self.callback=callback;
        originWebkitMethod(wrapper,element);
    }
}

if(window.mozRequestAnimationFrame){
    index=userAgent.indexOf('rv:');
    if(userAgent.indexOf('Gecko')!=-1){
        geckoVersion=userAgent.substr(index+3,3);
        if(geckoVersion==='2.0'){
            window.mozRequestAnimationFrame=undefined;
        }
    }
}

return window.requestAnimationFrame||
window.webkitRequestAnimationFrame||
window.mozRequestAnimationFrame||
window.msRequestAnimationFrame||
function(callback,element){
   var self=this,start,finish;
   window.setTimeout(function(){
       start=+new Date();
       callback(start);
       finish=+new Date();
       self.timeout=1000/60-(finish-start);
   },self.timeout);
};

})();
```

## 第 6 章 精灵

**Sprite 对象的属性**

| 属性      | 描述                                                                           |
| --------- | ------------------------------------------------------------------------------ |
| top       | y 坐标                                                                         |
| left      | x 坐标                                                                         |
| width     | 宽度                                                                           |
| height    | 高度                                                                           |
| velocityX | 水平速度                                                                       |
| velocityY | 垂直速度                                                                       |
| behaviors | 包含行为对象的数组，在执行更新逻辑时，该数组中的各行为对象都会被运用于此精灵。 |
| painter   | 用于绘制此对象的绘制器                                                         |
| visible   | 是否可见的 boolean 标志                                                        |
| animating | 是否正在执行动画效果的 Boolean 标志                                            |

```js
var Sprite = function (name, painter, behaviors) {
  if (name !== undefined) this.name = name;
  if (painter !== undefined) this.painter = painter;

  this.top = 0;
  this.left = 0;
  this.width = 10;
  this.height = 10;
  this.velocityX = 0;
  this.velocityY = 0;
  this.visible = true;
  this.animating = false;
  this.behaviors = behaviors || [];
  return this;
};

Sprite.prototype = {
  paint: function (context) {
    if (this.painter !== undefined && this.visible) {
      this.painter.paint(this, context);
    }
  },
  update: function (context, time) {
    for (var i = 0; i < this.behaviors.length; ++i) {
      this.behaviors[i].execute(this, context, time);
    }
  }
};
```

**图片绘制器**

```js
var ImagePainter = function (imageUrl) {
  this.image = new Image();
  this.image.src = imageUrl;
};
ImagePainter.prototype = {
  paint: function (sprite, context) {
    if (this.image.complete) {
      context.drawImage(this.image, sprite.left, sprite.top, sprite.width, sprite.height);
    }
  }
};
```

**精灵表绘制器**

```js
SpriteSheetPainter = function (cells) {
  this.cells = cells || [];
  this.cellIndex = 0;
};
SpriteSheetPainter.prototype = {
  advance: function () {
    if (this.cellIndex == this.cells.length - 1) {
      this.cellIndex = 0;
    } else {
      this.cellIndex++;
    }
  },
  paint: function (sprite, context) {
    var cell = this.cells[this.cellIndex];
    context.drawImage(
      spritesheet,
      cell.x,
      cell.y,
      cell.w,
      cell.h,
      sprite.left,
      sprite.top,
      cell.w,
      cell.h
    );
  }
};
```

**精灵制作器**

```js
var SpriteAnimator = function (painters, elapsedCallback) {
  this.painters = painters || [];
  this.elapsedCallback = elapsedCallback;
  this.duration = 1000;
  this.startTime = 0;
  this.index = 0;
};
SpriteAnimator.prototype = {
  end: function (sprite, originPainter) {
    sprite.animating = false;
    if (this.elapsedCallback) this.elapsedCallback(sprite);
    else sprite.painter = originPainter;
  },
  start: function (sprite, duration) {
    var endTime = +new Date() + duration,
      period = duration / this.painters.length,
      animator = this,
      originalPainter = sprite.painter,
      lastUpdate = 0;
    this.index = 0;
    sprite.animating = true;
    sprite.painter = this.painters[this.index];
    requestNextAnimationFrame(function spriteAnimatorAnimate(time) {
      if (time < endTime) {
        if (time - lastUpdate > period) {
          sprite.painter = animator.painters[++animator.index];
          lastUpdate = time;
        }
        requestNextAnimationFrame(spriteAnimatorAnimate);
      } else {
        animator.end(sprite, originalPainter);
      }
    });
  }
};
```

## 第 7 章 物理效果

**重力**

```js
//抛体垂直速度的修正公式
Vy = Vy0 - gt;
ARENA_LENGTH_IN_METERS = 10;
pixelsPerMeter = canvas.width / ARENA_LENGTH_IN_METERS;
top += velocityY / fps;
velocityY = GRAVITY_FORCE * (elapsedTime / 1000) * pixelsPerMeter;
//摆钟运动角度计算公式
a = a0 * cos(根号(g / 1) * t);
```

**AnimationTimer**

```js
AnimationTimer = function (duration, timeWarp) {
  if (timeWarp !== undefined) this.timeWarp = timeWarp;
  if (duration !== undefined) this.duration = duration;
  this.stopwatch = new Stopwatch();
};
AnimationTimer.prototype = {
  start: function () {
    this.stopwatch.start();
  },
  stop: function () {
    this.stopwatch.stop();
  },
  getElapsedTime: function () {
    var elapsedTime = this.stopwatch.getElapsedTime(),
      percentComplete = elapsedTime / this.duration;
    if (!this.stopwatch.running) return undefined;
    if (this.timeWarp == undefined) return elapsedTime;
    return elapsedTime * (this.timeWarp(percentComplete) / percentComplete);
  },
  isRunning: function () {
    return this.stopwatch.running;
  },
  isOver: function () {
    return this.stopwatch.getElapsedTime() > this.duration;
  }
};
```

**时间轴扭曲函数**

```js
AnimationTimer.makeEaseInt = function (strength) {
  return function (percentComplete) {
    //y=x^2
    return Math.pow(percentComplete, strength * 2);
  };
};

AnimationTimer.makeEaseOut = function (strength) {
  return function (percentComplete) {
    //y=1-(1-x)^2
    return 1 - Math.pow(1 - percentComplete, strength * 2);
  };
};

AnimationTimer.makeEaseInOut = function () {
  return function (percentComplete) {
    //y=x-sin(x*2*PI)/(2*PI)
    return percentComplete - Math.sin((percentComplete * 2 * Math.PI) / (2 * Math.PI));
  };
};

AnimationTimer.makeElastic = function (passes) {
  passes = passes || DEFAULT_ELASTIC_PASSES;
  return function (percentComplete) {
    //y=(1-cos(x*Npasses*PI)*(1-x))+x
    return (
      (1 - Math.cos(1 - percentComplete * Math.PI * passes)) * (1 - percentComplete) +
      percentComplete
    );
  };
};

AnimationTimer.makeBounce = function (bounces) {
  var fn = AnimationTimer.makeElastic(bounces);
  return function (percentComplete) {
    percentComplete = fn(percentComplete);
    return percentComplete <= 1 ? percentComplete : 2 - percentComplete;
  };
};
AnimationTimer.makeLinear = function () {
  return function (percentComplete) {
    //y=x
    return percentComplete;
  };
};
```

## 第 8 章 碰撞检测

**外接矩形判别法**

```js
ballWillHitLegde:function(ledge){
    var ballRight=ball.left+ball.width,
        ledgeRight=ledge.left+ledge.width,
        ballBottom=ball.top+ball.height,
        nextBallBottomEstimate=ballBottom+ballvelocityY/fps;
    return ballRight>ledge.left&&
        ball.left<ledgeRight&&
        ballBottom<ledge.top&&
        nextBallBottomEstimate>ledge.top;
}
```

**外接圆判别法**

```js
isBallInBucket:function(){
    var ballCenter={x:ball.left+BALL_RADIUS,
                   y:ball.top+BALL_RADIUS},
        distance=Math.sqrt(Math.pow(bucketHitCenter.x-ballCenter.x,2)+Math.pow(bucketHitCenter.y-ballCenter.y,2));
    return distance<BALL_RADIUS+bucketHitRadius;
}
//圆心之间的距离
c=根号(a^2+b^2);
```

**碰到墙壁即被弹回的小球**

```js
handleEdgeCollisions:function(){
    var bbox=getBoundingBox(ball),
    right=bbox.left+bbox.width,
    bottom=bbox.top+bbox.height;
    if(right>canvas.width||bbox.left<0){
        velocityX=-velocityX;
        if(right>canvas.width){
            ball.left-=right-canvas.width;
        }
        if(bbox.left<0){
            ball.left-=bbox.left;
        }
    }
    if(bottom>canvas.height||bbox.top<0){
        velocityY=-velocityY;
        if(bottom>canvas.height){
            ball.top-=bottom-canvas.height;
        }
        if(bbox.top<0){
            ball.top-=bbox.top;
        }
    }
}
```

**光线投射法**

```js
catchBall = {
  intersectionPoint: { x: 0, y: 0 },
  isBallInBucket: function () {
    if (lastBallPostion.left === ball.left || lastBallPostion.top === ball.top) {
      return;
    }

    var x1 = lastBallPostion.left,
      y1 = lastBallPostion.top,
      x2 = ball.left,
      y2 = ball.top,
      x3 = BUCKET_LEFT + BUCKET_WIDTH / 4,
      y3 = BUCKET_TOP,
      x4 = BUCKET_LEFT + BUCKET_WIDTH,
      y4 = y3,
      m1 = (ball.top - lastBallPostion.top) / (ball.left - lastBallPostion.left),
      m2 = (y4 - y3) / (x4 - x3),
      b1 = y1 - m1 * x1,
      b2 = y3 - m2 * x3;
    this.intersectionPoint.x = (b2 - b1) / (m1 - m2);
    this.intersectionPoint.y = m1 * this.intersectionPoint.x + b1;
    return (
      this.intersectionPoint.x > x3 &&
      this.intersectionPoint.x < x4 &&
      ball.top + ball.height > y3 &&
      ball.left + ball.width < x4
    );
  }
};
```
