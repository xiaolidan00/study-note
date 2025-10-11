# SVG

## 基础

```html
<svg width="100" height="100"></svg>

<svg width="200" height="200" viewBox="0 0 100 100"></svg>

<svg
  version="1.1"
  baseProfile="full"
  width="300"
  height="200"
  xmlns="http://www.w3.org/2000/svg"
></svg>
```

## 形状

### 矩形

```html
<rect x="10" y="10" width="30" height="30" />
```

### 圆角矩形

```html
<rect x="60" y="10" rx="10" ry="10" width="30" height="30" />
```

### 圆形

```html
<circle cx="25" cy="75" r="20" />
```

### 椭圆

```html
<ellipse cx="75" cy="75" rx="20" ry="5" />
```

### 直线

```html
<line x1="10" x2="50" y1="110" y2="150" stroke="black" stroke-width="5" />
```

### 折线

`点列表 (0,0), (1,1) 和 (2,2) 可以写成这样：“0 0, 1 1, 2 2”`

```html
<polyline points="60, 110 65, 120 70, 115 75, 130 80, 125 85, 140 90, 135 95, 150 100, 145" />
```

### 多边形

```html
<polygon points="50, 160 55, 180 70, 180 60, 190 65, 205 50, 195 35, 205 40, 190 30, 180 45, 180" />
```

### 路径

```html
<path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5" />
```

- 一种是用大写字母，表示采用绝对定位。另一种是用小写字母，表示采用相对定位
- Move To：`M x y` `m dx dy`
- Line To:`L x y` `l dx dy`
- H 绘制水平线:`H x` `h dx`
- V 绘制垂直线：`V y` `v dy`
- Z 是否闭合路径，放到路径的最后
- C 三次贝塞尔曲线:`C x1 y1, x2 y2, x y` `c dx1 dy1, dx2 dy2, dx dy`
- S 三次贝塞尔曲线（前一个点作为控制点起始点）:`S x2 y2, x y` `s dx2 dy2, dx dy`
- Q 二次贝塞尔曲线:`Q x1 y1, x y` `q dx1 dy1, dx dy`
- T 二次贝塞尔曲线（前一个点作为控制点起始点）:`T x y` `t dx dy`
- A 弧形:`A rx ry x-axis-rotation large-arc-flag sweep-flag x y` `a rx ry x-axis-rotation large-arc-flag sweep-flag dx dy`

### 文本

```html
<text x="10" y="10">Hello World!</text>

<text>
  <tspan font-weight="bold" fill="red">This is bold and red</tspan>
</text>

<text id="example">This is an example text.</text>

<text>
  <tref xlink:href="#example" />
</text>

<path id="my_path" d="M 20,20 C 40,40 80,40 100,20" fill="transparent" />
<text>
  <textPath xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#my_path">
    This text follows a curve.
  </textPath>
</text>
```

```html
<font id="Super_Sans">
  <!-- and so on -->
</font>

<style>
  @font-face {
    font-family: 'Super Sans';
    src: url(#Super_Sans);
  }
</style>

<text font-family="Super Sans">My text uses Super Sans</text>
```

## 样式

### 填充和描边

```html
<rect
  x="10"
  y="10"
  width="100"
  height="100"
  stroke="blue"
  fill="purple"
  fill-opacity="0.5"
  stroke-opacity="0.8"
/>
```

### 整体透明

```html
<rect x="0" y="0" width="100" height="100" opacity=".5" />
```

### 线头样式`stroke-linecap`

```html
<?xml version="1.0" standalone="no"?>
<svg width="160" height="140" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <line x1="40" x2="120" y1="20" y2="20" stroke="black" stroke-width="20" stroke-linecap="butt" />
  <line x1="40" x2="120" y1="60" y2="60" stroke="black" stroke-width="20" stroke-linecap="square" />
  <line
    x1="40"
    x2="120"
    y1="100"
    y2="100"
    stroke="black"
    stroke-width="20"
    stroke-linecap="round"
  />
</svg>
```

### 虚线样式`stroke-dasharray`

```html
<?xml version="1.0" standalone="no"?>
<svg width="200" height="150" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <path
    d="M 10 75 Q 50 10 100 75 T 190 75"
    stroke="black"
    stroke-linecap="round"
    stroke-dasharray="5,10,5"
    fill="none"
  />
  <path
    d="M 10 75 L 190 75"
    stroke="red"
    stroke-linecap="round"
    stroke-width="1"
    stroke-dasharray="5,5"
    fill="none"
  />
</svg>
```

### 使用 css

```html
<rect x="10" height="180" y="10" width="180" style="stroke: black; fill: red;" />

<?xml version="1.0" standalone="no"?>
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <defs>
    <style>
      <![CDATA[
             #MyRect {
               stroke: black;
               fill: red;
             }
             ]]>
    </style>
  </defs>
  <rect x="10" height="180" y="10" width="180" id="MyRect" />
</svg>
```

### stylesheet 样式

```html
<?xml version="1.0" standalone="no"?>
<?xml-stylesheet type="text/css" href="style.css"?>

<svg width="200" height="150" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <rect height="10" width="10" id="MyRect" />
</svg>
```

### 渐变

linear

```html
<svg width="120" height="240" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="Gradient1">
      <stop class="stop1" offset="0%" />
      <stop class="stop2" offset="50%" />
      <stop class="stop3" offset="100%" />
    </linearGradient>
    <linearGradient id="Gradient2" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0%" stop-color="red" />
      <stop offset="50%" stop-color="black" stop-opacity="0" />
      <stop offset="100%" stop-color="blue" />
    </linearGradient>
    <style type="text/css">
      <![CDATA[
              #rect1 { fill: url(#Gradient1); }
              .stop1 { stop-color: red; }
              .stop2 { stop-color: black; stop-opacity: 0; }
              .stop3 { stop-color: blue; }
            ]]>
    </style>
  </defs>

  <rect id="rect1" x="10" y="10" rx="15" ry="15" width="100" height="100" />
  <rect x="10" y="120" rx="15" ry="15" width="100" height="100" fill="url(#Gradient2)" />
</svg>
```

radial

```html
<?xml version="1.0" standalone="no"?>
<svg width="120" height="240" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="RadialGradient1">
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
    <radialGradient id="RadialGradient2" cx="0.25" cy="0.25" r="0.25">
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
  </defs>

  <rect x="10" y="10" rx="15" ry="15" width="100" height="100" fill="url(#RadialGradient1)" />
  <rect x="10" y="120" rx="15" ry="15" width="100" height="100" fill="url(#RadialGradient2)" />
</svg>
```

中心点和焦点

```html
<?xml version="1.0" standalone="no"?>

<svg width="120" height="120" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="Gradient" cx="0.5" cy="0.5" r="0.5" fx="0.25" fy="0.25">
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
  </defs>

  <rect
    x="10"
    y="10"
    rx="15"
    ry="15"
    width="100"
    height="100"
    fill="url(#Gradient)"
    stroke="black"
    stroke-width="2"
  />

  <circle cx="60" cy="60" r="50" fill="transparent" stroke="white" stroke-width="2" />
  <circle cx="35" cy="35" r="2" fill="white" stroke="white" />
  <circle cx="60" cy="60" r="2" fill="white" stroke="white" />
  <text x="38" y="40" fill="white" font-family="sans-serif" font-size="10pt">(fx,fy)</text>
  <text x="63" y="63" fill="white" font-family="sans-serif" font-size="10pt">(cx,cy)</text>
</svg>
```

spreadMethod 属性，该属性控制了当渐变到达终点的行为

```html
<?xml version="1.0" standalone="no"?>

<svg width="220" height="220" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient
      id="GradientPad"
      cx="0.5"
      cy="0.5"
      r="0.4"
      fx="0.75"
      fy="0.75"
      spreadMethod="pad"
    >
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
    <radialGradient
      id="GradientRepeat"
      cx="0.5"
      cy="0.5"
      r="0.4"
      fx="0.75"
      fy="0.75"
      spreadMethod="repeat"
    >
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
    <radialGradient
      id="GradientReflect"
      cx="0.5"
      cy="0.5"
      r="0.4"
      fx="0.75"
      fy="0.75"
      spreadMethod="reflect"
    >
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="blue" />
    </radialGradient>
  </defs>

  <rect x="10" y="10" rx="15" ry="15" width="100" height="100" fill="url(#GradientPad)" />
  <rect x="10" y="120" rx="15" ry="15" width="100" height="100" fill="url(#GradientRepeat)" />
  <rect x="120" y="120" rx="15" ry="15" width="100" height="100" fill="url(#GradientReflect)" />

  <text x="15" y="30" fill="white" font-family="sans-serif" font-size="12pt">Pad</text>
  <text x="15" y="140" fill="white" font-family="sans-serif" font-size="12pt">Repeat</text>
  <text x="125" y="140" fill="white" font-family="sans-serif" font-size="12pt">Reflect</text>
</svg>
```

gradientUnits（渐变单元）的属性，它描述了用来描述渐变的大小和方向的单元系统。该属性有两个值：userSpaceOnUse 、objectBoundingBox。默认值为 objectBoundingBox.

```html
<radialGradient
  id="Gradient"
  cx="60"
  cy="60"
  r="50"
  fx="35"
  fy="35"
  gradientUnits="userSpaceOnUse"
></radialGradient>
```

gradientTransform 给渐变添加额外的变化

### 图案 pattern

```html
<?xml version="1.0" standalone="no"?>
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <defs>
    <linearGradient id="Gradient1">
      <stop offset="5%" stop-color="white" />
      <stop offset="95%" stop-color="blue" />
    </linearGradient>
    <linearGradient id="Gradient2" x1="0" x2="0" y1="0" y2="1">
      <stop offset="5%" stop-color="red" />
      <stop offset="95%" stop-color="orange" />
    </linearGradient>

    <pattern id="Pattern" x="0" y="0" width=".25" height=".25">
      <rect x="0" y="0" width="50" height="50" fill="skyblue" />
      <rect x="0" y="0" width="25" height="25" fill="url(#Gradient2)" />
      <circle cx="25" cy="25" r="20" fill="url(#Gradient1)" fill-opacity="0.5" />
    </pattern>
  </defs>

  <rect fill="url(#Pattern)" stroke="black" x="0" y="0" width="200" height="200" />
</svg>
```

## 基础变形

### 元素集合

```html
<g fill="red">
  <rect x="0" y="0" width="10" height="10" />
  <rect x="20" y="0" width="10" height="10" />
</g>
```

### 平移

```html
<rect x="0" y="0" width="10" height="10" transform="translate(30,40)" />
```

### 旋转

```html
<rect x="20" y="20" width="20" height="20" transform="rotate(45)" />
```

### 斜切

```html
<rect x="20" y="20" width="20" height="20" transform="skewX(5)" />
<rect x="20" y="20" width="20" height="20" transform="skewY(5)" />
```

### 缩放

```html
<rect x="20" y="20" width="20" height="20" transform="scale(0.5)" />
```

## 剪切

```html
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <clipPath id="cut-off-bottom">
      <rect x="0" y="0" width="200" height="100" />
    </clipPath>
  </defs>

  <circle cx="100" cy="100" r="100" clip-path="url(#cut-off-bottom)" />
</svg>
```

## 遮罩

```html
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient id="Gradient">
      <stop offset="0" stop-color="white" stop-opacity="0" />
      <stop offset="1" stop-color="white" stop-opacity="1" />
    </linearGradient>
    <mask id="Mask">
      <rect x="0" y="0" width="200" height="200" fill="url(#Gradient)" />
    </mask>
  </defs>

  <rect x="0" y="0" width="200" height="200" fill="green" />
  <rect x="0" y="0" width="200" height="200" fill="red" mask="url(#Mask)" />
</svg>
```

## Image

```html
<svg
  version="1.1"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  width="200"
  height="200"
>
  <image
    x="90"
    y="-65"
    width="128"
    height="146"
    transform="rotate(45)"
    xlink:href="image/mdn_logo_only_color.png"
  />
</svg>
```

## 滤镜效果

```html
<svg width="250" viewBox="0 0 200 85" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <defs>
    <!-- Filter declaration -->
    <filter id="MyFilter" filterUnits="userSpaceOnUse" x="0" y="0" width="200" height="120">
      <!-- offsetBlur -->
      <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur" />
      <feOffset in="blur" dx="4" dy="4" result="offsetBlur" />

      <!-- litPaint -->
      <feSpecularLighting
        in="blur"
        surfaceScale="5"
        specularConstant=".75"
        specularExponent="20"
        lighting-color="#bbbbbb"
        result="specOut"
      >
        <fePointLight x="-5000" y="-10000" z="20000" />
      </feSpecularLighting>
      <feComposite in="specOut" in2="SourceAlpha" operator="in" result="specOut" />
      <feComposite
        in="SourceGraphic"
        in2="specOut"
        operator="arithmetic"
        k1="0"
        k2="1"
        k3="1"
        k4="0"
        result="litPaint"
      />

      <!-- merge offsetBlur + litPaint -->
      <feMerge>
        <feMergeNode in="offsetBlur" />
        <feMergeNode in="litPaint" />
      </feMerge>
    </filter>
  </defs>

  <!-- Graphic elements -->
  <g filter="url(#MyFilter)">
    <path
      fill="none"
      stroke="#D90000"
      stroke-width="10"
      d="M50,66 c-50,0 -50,-60 0,-60 h100 c50,0 50,60 0,60z"
    />
    <path fill="#D90000" d="M60,56 c-30,0 -30,-40 0,-40 h80 c30,0 30,40 0,40z" />
    <g fill="#FFFFFF" stroke="black" font-size="45" font-family="Verdana">
      <text x="52" y="52">SVG</text>
    </g>
  </g>
</svg>
```

## 动画

```html
<rect x="0" y="0" width="300" height="100" stroke="black" stroke-width="1">
  <animate attributeName="cx" from="0" to="500" dur="5s" repeatCount="indefinite" />
</rect>

<rect x="0" y="50" width="15" height="34" fill="blue" stroke="black" stroke-width="1">
  <animateTransform
    attributeName="transform"
    begin="0s"
    dur="20s"
    type="rotate"
    from="0 60 60"
    to="360 100 60"
    repeatCount="indefinite"
  />
</rect>

<circle cx="0" cy="50" r="15" fill="blue" stroke="black" stroke-width="1">
  <animateMotion path="M 0 0 H 300 Z" dur="3s" repeatCount="indefinite" />
</circle>

<rect x="0" y="0" width="20" height="20" fill="blue" stroke="black" stroke-width="1">
  <animateMotion
    path="M 250,80 H 50 Q 30,80 30,50 Q 30,20 50,20 H 250 Q 280,20,280,50 Q 280,80,250,80Z"
    dur="3s"
    repeatCount="indefinite"
    rotate="auto"
  />
</rect>
```
