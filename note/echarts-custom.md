---
theme: fancy
highlight: vs
---

最近产品指着某个类似 echarts 的图表说要这种效果，我看了一圈 echarts 的配置项，自定义系列都出动了，发现效果达不到，最终只能放弃`echarts`，自己用`canvas`仿照`echarts`的风格写一个图表。

![20250623_200713.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/bf45110371bd4778a1d2797efd9c1f06~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=ScgQVt0ou2Uc0h81vO89Ma%2FnG98%3D)

# 1. echarts 自定义系列实现的时间范围条形图

## 1.1 echarts 配置项

数据整理组装，设置每个条状的颜色，收集最大最小值用于设置 x 轴显示范围与合适的间隔大小

```ts
//不同状态名称和颜色设置
const types = [
  {name: '运行', color: '#32CD32'}, // 0
  {name: '离线', color: '#808080'}, // 1
  {name: '报警', color: '#FF6347'}, // 2
  {name: '静止', color: '#1E90FF'} // 3
];
const data: any[] = [];
let min = Number.MAX_SAFE_INTEGER;
let max = 0;
//类目
const categories: string[] = [];

//组装整理数据
dataList.forEach((item, index) => {
  categories.push(item.name);
  item.data.forEach((a: any, i: number) => {
    const typeItem = types[a.status] || types[3];
    const start = new Date(a.startTime).getTime();
    const end = new Date(a.endTime).getTime();
    //收集最大最小值
    min = Math.min(start, min);
    max = Math.max(max, end);
    data.push({
      name: typeItem.name,
      value: [index, start, end, a.timeRange, index + '-' + i, typeItem.name],
      itemStyle: {
        //条状颜色
        color: typeItem.color
      }
    });
  });
});
//时间范围类型，24小时内还是以天为单位
const timeType: string = max - min <= 3600 * 1000 * 24 ? '24' : 'day';
```

设置渲染自定义形状，设置正常时样式为变暗后的颜色，高亮时样式为原色

```ts
function renderItem(params: any, api: any) {
  //目录索引
  const categoryIndex = api.value(0);
  //开始坐标
  const start = api.coord([api.value(1), categoryIndex]);
  //结束坐标
  const end = api.coord([api.value(2), categoryIndex]);

  //条状宽度
  const height = api.size([0, 1])[1] * 0.6;
  //条状范围
  const rectShape = echarts.graphic.clipRectByRect(
    {
      x: start[0],
      y: start[1] - height / 2,
      width: end[0] - start[0],
      height: height
    },
    {
      x: params.coordSys.x,
      y: params.coordSys.y,
      width: params.coordSys.width,
      height: params.coordSys.height
    }
  );
  const style = api.style();
  const darkColor = getDarkColor(style.fill, 0.5);

  //矩形绘制样式与范围
  return (
    rectShape && {
      type: 'rect',
      name: '',
      transition: ['shape'],
      shape: rectShape,
      //正常效果，变暗的颜色
      style: {
        fill: darkColor
      },
      //高亮效果，原色
      emphasis: {
        style: {
          fill: style.fill
        }
      }
    }
  );
}
```

提示框格式化

```ts
function formatter(params: any) {
  const value = params.value;

  return /*html*/ `<div class="tooltip-container">
        <div class="tooltip-item">
        <span class="tooltip-item-color" style="background:${params.color}"></span>
        <span class="tooltip-item-name " >${params.name}
      </span>  <span style="color:#009ea1;">${Number(value[3]).toFixed(2)}</span>小时
        </div>
         <div class="tooltip-item">
           <span class="tooltip-item-name " >开始时间：</span>
           <span class="tooltip-item-value " >${dayjs(value[1]).format(
             'YYYY-MM-DD HH:mm:ss'
           )}</span>
         </div>
          <div class="tooltip-item">
           <span class="tooltip-item-name " >结束时间：</span>
           <span class="tooltip-item-value " >${dayjs(value[2]).format(
             'YYYY-MM-DD HH:mm:ss'
           )}</span>
         </div> 
        </div>`;
}
```

echarts 图表配置项，添加自定义系列，

```ts
const option = {
  //图表内数据缩放
  dataZoom: {
    type: 'inside',
    //过滤模式为不过滤数据，只改变数轴范围。
    filterMode: 'none',
    //数据缩放范围
    start: 0,
    end: 100
  },
  //图例不生效
  //legend: { show: true, top: 0, data: types.map((it) => ({ name: it.name, itemStyle: { color: it.color } })) },
  //信息提示
  tooltip: {
    trigger: 'item',
    formatter: function () {} //上面的信息提示格式
  },
  //网格范围
  grid: {
    left: 40,
    top: 20,
    right: 20,
    bottom: 30
  },
  //x轴
  xAxis: {
    //坐标轴显示范围
    min,
    max,
    //最小间隔
    minInterval: 3600 * 1000,
    //间隔大小
    interval: timeType == '24' ? 3600 * 4 * 1000 : 3600 * 12 * 1000,
    axisLabel: {
      //坐标轴显示标签
      formatter: function (val: number) {
        const s = dayjs(val).format('HH:mm');
        if (s === '00:00') {
          return dayjs(val).format('MM/DD');
        }
        return s;
      }
    },
    splitLine: {
      show: false
    }
  },
  //y轴
  yAxis: {
    data: categories,
    axisLine: {
      show: false
    },
    axisTick: {show: false},
    //倒序
    inverse: true
  },
  series: [
    {
      //自定义系列
      type: 'custom',
      //生成自定义行状态
      renderItem: renderItem,
      colorBy: 'data',
      encode: {
        //x坐标轴取值维度
        x: [1, 2],
        //y坐标轴取值维度
        y: 0
      },
      data: data
    }
  ]
};
```

![20250620_164840.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/33106a946c6c406cb5c7bdab2258e372~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=kak83l5C%2FnfeW3phAoroeRBQsmY%3D)

但是该图表达不到产品想要的效果

1.  x 轴时间需要只显示整点时间；
2.  条状需要没有悬浮的时候全部保持原色，而悬浮的当前条状保持原色，其他条状变暗；
3.  图表需要显示图例，并可交互控制某个状态条状显隐，因为数据按照类目组装的，所以没能根据状态生成图例；

好吧，我再研究研究！

## 1.2 高亮效果

- `renderItem`可以通过`chart.resize()`调整大小方法来重绘。
- 本来打算监听 echarts 的`highlight`高亮事件和`downplay`取消高亮事件，然后设置高亮开启和当前悬浮条状的 ID 来重绘，结果发现自定义系列监听不到`highlight`和`downplay`事件。
- 然后转而去用`mouseover`悬浮事件和`mouseout`离开事件，高亮效果渲染可以了！

```ts
//图表状态
const state = {
  //是否高亮
  highlight: false,
  //高亮id
  highlightId: ''
};
//自定义渲染
function renderItem(params: any, api: any) {
  //...
  const style = api.style();
  const darkColor = getDarkColor(style.fill, 0.5);
  //高亮是否开启
  if (state.highlight) {
    const color = state.highlightId === api.value(4) ? style.fill : darkColor;
    return (
      rectShape && {
        type: 'rect',
        name: '',
        transition: ['shape'],
        shape: rectShape,
        //正常效果，变暗的颜色
        style: {
          fill: color
        },
        emphasis: {
          style: color
        }
      }
    );
  }

  return (
    rectShape && {
      type: 'rect',
      name: '',
      transition: ['shape'],
      shape: rectShape,
      //正常效果，变暗的颜色
      style: {
        fill: style.fill
      }
    }
  );
}
```

监听`mouseover`和`mouseout`事件

```js
 chart.chart.on('mouseover', (ev) => {
    const data = ev.data as any;
    state.highlightId = data.value[4];
    state.highlight = true;
    chart.resize();
  });

  chart.chart.on('mouseout', (ev) => {
    state.highlight = false;
    state.highlightId = '';
    chart.resize();
  });
```

![20250620_190850.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/17046649843d413f9e078ca92cbc110f~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=4jcw8ljyBVkeFKv0c%2FJojzS8EV8%3D)

- 但还是有点问题，旧画面没清除干净，会出现多个条状高亮或没有悬浮时仍有置灰的情况！
- 然后我改成`chart.clear()`清空再`chart.setOption(option)`来完全重绘！这下渲染高亮效果没有问题！

![20250620_191456.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/40c2bb206d584cac912193da4145d5bc~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=OH8TBrw7k7gV7lCuPX3cCpzB3Jk%3D)

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/fe34cacee8b74b5cbf1acfbb3be07ce8~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=3KUKcnq9JxiBS77ZElLYVQTyZd4%3D)

- 因为 tooltip 被频繁打断渲染，会报空错！能用就行，假装看不见！

- 然后又衍生出一个问题，`dataZoom`数据缩放在重绘后会不见了，所以得保存之前的缩放状态。可以增加一个 dataZoom 的事件监听，更新`option.dataZoom`的`start`和`end`缩放显示范围

```ts
chart.chart.on('dataZoom', (ev) => {
  const data = (ev as any).batch[0];
  option.dataZoom.start = data.start;
  option.dataZoom.end = data.end;
});
```

![20250620_205615.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/cd46efabe317418b8fb735d5d043f49d~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=q6coZTjzMZXEfMIYN98MVq50VfY%3D)

## 1.3 图例交互

- echarts 生成不了这个图例，那么可以手写一个图例 DOM，监听 click 事件,根据图例是否选择判断 Item 是否渲染，不渲染的直接 renderItem 返回空即可！

图例 DOM，为了方便，可以给每个图例的文本和圆圈加上`pointer-events:none`

```ts
//图表状态
const state = {
  //...
  //根据图例渲染
  legendMap: {} as {[k: string]: boolean}
};

const legend = document.createElement('div');
legend.style.display = 'inline-flex';
legend.style.alignItems = 'center';
legend.style.justifyContent = 'center';
legend.style.width = '800px';
legend.style.fontSize = '12px';
legend.style.gap = '10px';

function getLegend() {
  legend.innerHTML = types
    .map(
      (it, i) =>
        `<span data-key="${
          it.name
        }" style="cursor:pointer;padding:0 10px;display:inline-flex;align-items:center;text-align:center"><span style="background:${
          state.legendMap[it.name] === false ? '#efefef' : it.color
        };margin-right:5px;pointer-events:none" class="tooltip-item-color"></span><span style="pointer-events:none">${
          it.name
        }</span></span>`
    )
    .join('');
}
getLegend();
```

监听图例点击事件，并采用`chart.resize()`触发重绘，因为 renderItem 返回空就是不渲染该 Item，所以不会有旧画面不清楚的情况，可以放心使用！

```ts
//渲染自定义形状
function renderItem(params: any, api: any) {
  //...
  //判断图例是否渲染
  if (state.legendMap[api.value(5)] === false) return;
  if (state.highlight) {
    //...
  }
  //...
}
document.body.appendChild(legend);
legend.addEventListener('click', (ev: MouseEvent) => {
  const target = ev.target as HTMLElement;

  const name = target.dataset.key!;
  if (state.legendMap[name] || state.legendMap[name] === undefined) {
    state.legendMap[name] = false;
  } else {
    state.legendMap[name] = true;
  }
  getLegend();
  chart.resize();
});
```

![20250620_202339.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/9e7e31b69054434ca2d370c8361fa333~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=kQr%2BYJEpqWvfBsum26ZIeTh%2FFX4%3D)

- 虽然大部分问题解决了，但最关键的坐标轴时间整点标签的问题搞不定！echarts 的值坐标轴标签是自动生成的，设置的`interval`,`minInterval`等都不能强制，内部有个自动适配机制调整标签值，非凡人能左右！

- 没办法，echarts 暂时搞不定，只能自己动手丰衣足食，用 canvas 重写该图表\~

# 2. 用 canvas 实现时间范围条形图

## 2.1 绘制坐标和矩形

整理组装数据，包括时间范围，矩形的原色与暗色，状态名称等，计算出最大最小时间值，以及数据缩放的最大等级。

**注意：** 为了让时间轴只显示整点时间，让最小时间值取向下取整整点时间。

```ts
setData(data: any[]) {
    let min = Number.MAX_SAFE_INTEGER;
    let max = 0;

    const list: DrawItems[] = [];
    data.forEach((item: DataItems) => {
      const draw: DrawItem[] = [];
      item.data.forEach((a: DataItem) => {
        const start = new Date(a.startTime).getTime();
        const end = new Date(a.endTime).getTime();
        const typeItem = this.config.types[a.status];
        draw.push({
          start,
          end,
          timeRange: a.timeRange,
          name: typeItem.name,
          color: typeItem.color,
          darkColor: typeItem.darkColor
        });
        min = Math.min(start, min);
        max = Math.max(max, end);
      });
      list.push({
        name: item.name,
        data: draw
      });
    });
    this.list = list;
    this.max = max;
    //向下取整点时间
    this.min = Math.floor(min / (3600 * 1000)) * 3600 * 1000;
    this.range = max - min;
    //最大缩放等级
    this.maxScale = Math.ceil(((max - min) / 24) * 3600 * 1000) + 1;
    //重置缩放等级和数据缩放移动
    this.scale = 1;
    this.moveOffset = 0;

    this.draw();
  }
```

计算绘制相关的参数，矩形宽高，绘制范围(要预留左侧 y 轴类目标签和底部 x 轴时间标签的位置)，大小映射等

```ts
//清空绘制内容
ctx.clearRect(0, 0, canvas.width, canvas.height);

//条状展示长度
const barLen = canvas.width - op.paddingLeft - op.paddingRight;
//条状长度
const barLength = barLen * this.scale;

this.barLen = barLen;

//条状宽度
const heightUnit = (canvas.height - op.textBottom) / this.data.length;
const heightHalf = heightUnit * 0.5;
//间隔
const heightGap = (1 - op.barPercent) * heightUnit * 0.5;
//条状宽度
const barWidth = heightUnit * op.barPercent;

//大小位置映射
const lerp = (size: number) => {
  return this.moveOffset + ((size - min) / range) * barLength;
};
```

绘制 x 轴时间标签，根据时间范围大小 range 计算出要展示的整点时间间隔大小和数量，然后基于最小开始时间递增间隔时间大小取整点时间，然后计算出标签大小和位置进行位置。

```ts
//字体样式
ctx.font = `${op.fontSize}px serif`;
ctx.fillStyle = op.fontColor;
ctx.textAlign = 'left';
ctx.textBaseline = 'middle';
//x轴时间标签
let step = 4;
if (range > 24 * 3600 * 1000) {
  step = 12;
}
//整点时间间隔大小
step = Math.round(step / this.scale);
//整点时间间隔数量
const count = Math.ceil(range / (step * 3600 * 1000));
for (let i = 0; i <= count; i++) {
  const d = dayjs(min)
    .add(i * step, 'hour')
    .format('YYYY-MM-DD HH:mm:ss');

  const t = new Date(d).getTime();
  //时间标签格式
  let text = dayjs(t).format('HH:mm');
  if (text == '00:00') text = dayjs(t).format('MM/DD');
  //时间标签位置
  const x = lerp(t);
  //数据缩放时只绘制可视范围内容的标签文本
  if (x < 0) continue;
  if (x > barLen + 1) continue;
  //标签居中
  const textW = ctx.measureText(text).width;
  ctx.fillText(text, x + op.paddingLeft - textW * 0.5, canvas.height - op.textBottom * 0.5);
}
```

绘制 y 轴类目和不同状态颜色的矩形，根据条状的开始时间和结束时间计算出条状在图表中映射的长度和位置，绘制出矩形的范围，并收集该范围，用于后续悬浮动作判断。

```ts
list.forEach((item: DrawItems, i: number) => {
  //y轴类目
  ctx.font = `${op.fontSize}px serif`;
  ctx.fillStyle = op.fontColor;
  ctx.textBaseline = 'middle';
  ctx.textAlign = 'left';
  //类目居中
  const textW = ctx.measureText(item.name).width;
  ctx.fillText(item.name, op.paddingLeft - textW - 5, heightUnit * i + heightHalf);
  //绘制时间范围条状
  item.data.forEach((a: DrawItem, j: number) => {
    //判断图例是否显示
    if (this.legendMap[a.name] === false) return;

    let x = lerp(a.start);
    let x1 = lerp(a.end);
    //数据缩放时只绘制可视范围内的矩形
    if (x < 0 && x1 < 0) return;
    else if (x > barLen) return;
    else {
      //一部分在可视范围内的调整开始结束坐标位置
      if (x < 0) {
        x = 0;
      }
      if (x1 > barLen) {
        x1 = barLen;
      }
    }

    const w = x1 - x;
    if (w <= 0) return;
    const left = op.paddingLeft + x;
    const top = heightUnit * i + heightGap;
    const id = i + '-' + j;
    //悬浮时，其他矩形变暗
    if (this.active && this.active !== id) {
      ctx.fillStyle = a.darkColor;
    } else {
      ctx.fillStyle = a.color;
    }
    ctx.fillRect(left, top, w, barWidth);

    //缓存矩形范围，用于悬浮动作判断
    this.actionMap.push({
      id,
      data: a,
      left: left,
      top: top,
      w,
      h: barWidth
    });
  });
});
```

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/1e493f5b13cf4f17a34eaa1d6bf46b5b~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=IxM6KQgv7RPI6lYx7HXV2uNFTS0%3D)

## 2.2 给 canvas 图表添加提示框 tooltip 和悬浮高亮效果

**提示框 tooltip**

监听 canvas 的`pointermove`动作，遍历时间范围条状的绘制范围，如果在范围内则弹出提示框，否则隐藏提示框。提示框样式同上，位置在间范围条状的开始位置的上方。

```ts
 canvas.addEventListener('pointermove', this.onHover.bind(this));
 onHover(ev: PointerEvent) {
    const x = ev.offsetX;
    const y = ev.offsetY;
    const tooltip = this.tooltip;
    const bound = this.canvas.getBoundingClientRect();

    for (let i = 0; i < this.actionMap.length; i++) {
      const item = this.actionMap[i];
      if (x >= item.left && x <= item.left + item.w && y >= item.top && y <= item.h + item.top) {
        if (this.active != item.id) {
        //当前悬浮条状
          this.active = item.id;

          tooltip.innerHTML = this.tooltipFormatter(item.data);
          tooltip.style.left = `${bound.left + item.left}px`;
          const t = bound.top + item.top - (tooltip.offsetHeight || 92);
          tooltip.style.top = `${Math.max(t, 0)}px`;
          tooltip.style.display = 'block';
          this.draw();
        }
        return;
      }
    }
    this.hideTooltip();
  }

   hideTooltip() {
    this.tooltip.style.display = 'none';
    this.active = '';
    this.draw();
  }
```

![20250623_170455.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/55d45c2cf8fd451a8be395c3d88f35ce~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=GJxBIu5fSllNUoX%2Fom%2FSZ1uMPas%3D)

**高亮效果**

判断是否设置了当前悬浮的条状 id，如果有且不等于该 id 的其他条状颜色变暗，当前悬浮条状保持原色，如果没有悬浮条状，全部保持原色。

```ts
const id = i + '-' + j;
//悬浮时，其他矩形变暗
if (this.active && this.active !== id) {
  ctx.fillStyle = a.darkColor;
} else {
  ctx.fillStyle = a.color;
}
ctx.fillRect(left, top, w, barWidth);
```

![20250623_171730.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/4f46d64647b54f749deb8e8bc20830ed~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=6Evxey89nfQVgnGW8q%2FAsjSbMZA%3D)

## 2.3 给 canvas 图表添加数据缩放

数据缩放有两个动作，一个是滚轮控制缩放等级，一个是鼠标滑动移动数据显示范围。

缩放和移动后的条状总大小与位置映射也要对应调整。

- 缩放只进行横向大小缩放，将展示大小（canvas 宽度减去左右边距）乘以`scale`即总的长度。
- 移动则在位置映射对应加上偏移量，使得展示范围改变。

```ts
//条状展示长度
const barLen = canvas.width - op.paddingLeft - op.paddingRight;
//条状长度
const barLength = barLen * this.scale;

this.barLen = barLen;
//大小位置映射
const lerp = (size: number) => {
  return this.moveOffset + ((size - min) / range) * barLength;
};
```

监听滚轮缩放动作，增减缩放等级，重绘 canvas 图表。

**注意**

- 为了避免滚轮滚动太快导致缩放绘制太频繁，加了个防抖！
- 这里加了个偏移位置的设置，按照鼠标所在位置比例设置缩放后的偏移量，不用从零开始移动
- 缩放前后显示的数据范围的偏移位置要检查，回到该缩放等级的有效范围内，否则会出现空白
- 数据缩放移动时要隐藏`tooltip`和禁用高亮效果，避免频繁重绘。

```ts
 this.onScale = debounce(this.onWheel.bind(this), 100);
 canvas.addEventListener('wheel', this.onScale.bind(this));
 //滚轮缩放
  onWheel(ev: WheelEvent) {
    let s = this.scale;
    if (ev.deltaY > 0) {
      //down
      s = s - this.scaleStep;
      if (s < this.minScale) {
        s = this.minScale;
      }
    } else {
      //up
      s = s + this.scaleStep;
      if (s > this.maxScale) {
        s = this.maxScale;
      }
    }
    this.scale = s;
    if (this.scale === 1) {
      this.moveOffset = 0;
    } else {
      this.moveOffset = -((ev.offsetX - this.config.paddingLeft) / this.barLen) * this.scale * this.barLen;
    }
    this.checkMove();
      this.active = '';
    this.tooltip.style.display = 'none';
    this.draw();
  }
    //检查移动范围
  checkMove() {
    if (this.moveOffset > 0) {
      this.moveOffset = 0;
    } else if (this.moveOffset < this.barLen - this.barLen * this.scale) {
      this.moveOffset = this.barLen - this.barLen * this.scale;
    }
  }
```

另外，x 轴时间标签也要根据缩放等级进行按比例调整，缩放等级变大，则时间间隔大小变小。

```ts
//x轴时间标签
let step = 4;
if (range > 24 * 3600 * 1000) {
  step = 12;
}
//整点时间间隔大小
step = Math.round(step / this.scale);
//整点时间间隔数量
const count = Math.ceil(range / (step * 3600 * 1000));
```

监听 canvas 的`pointerdown`,`pointermove`,`pointerup`,`pointerleave`事件，记录鼠标按下的位置，然后根据鼠标移动算出图表移动偏移量，鼠标放开时绘制更新图表。

**注意：**

- 数据缩放移动偏移量要做范围检查。

```ts
 canvas.addEventListener('pointerdown', this.onMoveStart.bind(this));
    canvas.addEventListener('pointermove', this.onHover.bind(this));
    canvas.addEventListener('pointerup', this.onMoveEnd.bind(this));
    canvas.addEventListener('pointerleave', this.onMoveEnd.bind(this));
   onMoveEnd() {
    if (this.isMove && this.scale > 1) {
      this.isMove = false;

      this.draw();
    }
  }
  onMoveStart(ev: PointerEvent) {
    this.isMove = true;
    this.moveStart = ev.offsetX;
    this.hideTooltip();
  }
    onHover(ev: PointerEvent) {
    const x = ev.offsetX;
    const y = ev.offsetY;

    if (this.isMove) {
      this.moveOffset += (ev.offsetX - this.moveStart) * this.moveStep;

      this.checkMove();
      this.moveStart = x;
     this.active = '';
      this.tooltip.style.display = 'none';
      return;
    }
    }
```

![20250623_192910.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/0727761b8a8f4c3ea59965ad419a9fd7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=pmvR7jAc4z%2FLDRwU1wEJtWrGGpw%3D)

## 2.4 给 canvas 图表添加图例动作

样式和动作与上面图例交互一样，监听图例的点击动作，然后给单个图例状态置为`true`或`false`，重绘图表。

```ts
onClickLegend(ev: MouseEvent) {
   const target = ev.target as HTMLElement;

   const name = target.dataset.key!;
   if (this.legendMap[name] || this.legendMap[name] === undefined) {
     this.legendMap[name] = false;
   } else {
     this.legendMap[name] = true;
   }
   this.getLegend();
   this.draw();
 }
```

绘制时间范围条状的时候，判断该图例是否为`false`，如果为`false`则跳过绘制。

```ts
item.data.forEach((a: DrawItem, j: number) => {
  //判断图例是否显示
  if (this.legendMap[a.name] === false) return;
  //...
});
```

![20250623_195725.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ddee1a5b69624c31b8737247c5141276~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=UJzDbO4c8yRlZjKH%2FkRpPFNUv38%3D)

# 3.GitHub 地址

`https://github.com/xiaolidan00/demo-vite-ts`

![20250623_200713.gif](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/bf45110371bd4778a1d2797efd9c1f06~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5pWy5pWy5pWy5pWy5pq05L2g6ISR6KKL:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiMjI0NzgxNDAzMTYyNzk4In0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1751339124&x-orig-sign=ScgQVt0ou2Uc0h81vO89Ma%2FnG98%3D)
