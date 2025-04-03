function attr2Obj(that, attr, defaultVal) {
  let v = that.getAttribute(attr);
  if (v) {
    return JSON.parse(v);
  } else {
    return defaultVal;
  }
}
function attr2Num(that, attr, defaultVal) {
  let v = that.getAttribute(attr);
  if (v) {
    return Number(v);
  } else {
    return defaultVal;
  }
}
function attr2Bool(that, attr) {
  let v = that.getAttribute(attr);

  return v === 'true' ? true : false;
}

class LineChart extends HTMLElement {
  constructor() {
    super();
  }
  connectedCallback() {
    console.log(this.parentElement);
    const sheet = new CSSStyleSheet();
    sheet.replaceSync(`span.tooltip-item-color { display:inline-block;height:12px;width:12px;border-radius:50%;}
      .tooltip-container{line-height:24px;font-size:14px;}
      .tooltip-title{font-weight:600;}
      .tooltip-item{display:flex;align-items:center;}
      .tooltip-item-name{margin:0 10px;flex:1;}`);
    const that = this;
    const shadow = this.attachShadow({mode: 'open'});
    shadow.adoptedStyleSheets = [sheet];

    const chartDom = document.createElement('div');
    chartDom.style.display = 'inline-block';
    shadow.appendChild(chartDom);

    const chart = echarts.init(chartDom);
    let interval;
    let isMouse = false;
    let isHover = false;
    let data;

    const updateOption = () => {
      if (!this.style.width) {
        chartDom.style.width = (this.getAttribute('width') || this.parentElement.offsetWidth || 300) + 'px';
      } else {
        chartDom.style.width = this.style.width;
      }
      if (!this.style.height) {
        chartDom.style.height = (this.getAttribute('height') || this.parentElement.offsetHeight || 300) + 'px';
      } else {
        chartDom.style.height = this.style.height;
      }
      const title = this.getAttribute('title');
      const dataProps = attr2Obj(that, 'dataProps', {name: 'name', value0: 'value'});
      const series = attr2Obj(that, 'series', []);
      const tooltipFormatter = attr2Obj(that, 'tooltipFormatter', {
        isColor: true,
        isX: true,
        isName: true,
        isVal: true,
        isPrefix: false,
        isSuffix: false
      });
      data = attr2Obj(that, 'data', []);
      const dataMap = {};
      for (let k in dataProps) {
        dataMap[k] = [];
      }
      data.forEach((item) => {
        for (let k in dataProps) {
          dataMap[k].push(item[dataProps[k]]);
        }
      });
      const tooltipType = this.getAttribute('tooltipType');
      const option = {
        title: title
          ? {
              text: title
            }
          : undefined,
        tooltip: {
          show: true,
          trigger: tooltipType,
          //https://echarts.apache.org/zh/option.html#tooltip.formatter
          formatter: (params) => {
            let list = '';
            function getDataStr(item) {
              const i = item.seriesIndex;
              let str = '<div class="tooltip-item">';
              if (tooltipFormatter.isColor) {
                str += `<span class="tooltip-item-color" style="background:${item.color}"></span>`;
              }
              if (tooltipFormatter.isName) {
                str += `<span class="tooltip-item-name">${item.seriesName}</span>`;
              }
              if (tooltipFormatter.isPrefix) {
                str += `<span class="tooltip-item-prefix">${tooltipFormatter.prefix[i]}</span>`;
              }
              if (tooltipFormatter.isVal) {
                str += `<span class="tooltip-item-value">${item.value}</span>`;
              }

              if (tooltipFormatter.isSuffix) {
                str += `<span class="tooltip-item-suffix">${tooltipFormatter.suffix[i]}</span>`;
              }
              list += `${str}</div>`;
            }
            if (Array.isArray(params)) {
              for (let i = 0; i < params.length; i++) {
                const item = params[i];
                getDataStr(item);
              }
            } else {
              getDataStr(params);
            }

            let html = `<div class="tooltip-container">${
              tooltipType === 'axis' && tooltipFormatter.isX
                ? `<div class="tooltip-title">${params[0].axisValueLabel}</div>`
                : ''
            }
            ${list}</div>`;
            return html;
          }
        },
        legend: {
          left: 'center',
          bottom: 20,
          data: series.map((item) => item.name)
        },

        xAxis: {
          data: dataMap.name,
          type: 'category'
        },
        yAxis: {
          type: 'value'
        },
        series: data.map((item, i) => ({
          ...series[i],
          data: dataMap['value' + i] || []
        }))
      };
      chart.setOption(option);
      chart.resize();
      if (interval) {
        clearInterval(interval);
      }
      //循环播放
      if (attr2Bool(that, 'loop')) {
        const time = attr2Num(that, 'time', 2000);
        const count = data.length;
        const total = count * series.length;
        if (count > 0 && time > 0) {
          let currentIndex = 0;
          interval = setInterval(() => {
            //悬浮不走循环播放
            if (isHover) return;
            if (currentIndex >= total) {
              currentIndex = 0;
            }
            chart.dispatchAction({
              type: 'showTip',
              seriesIndex: Math.floor(currentIndex / count),
              dataIndex: currentIndex % count
            });
            currentIndex++;
          }, time);
        }
      }
    };
    this.addEventListener('mouseenter', () => {
      isHover = true;
    });
    this.addEventListener('mouseleave', () => {
      isHover = false;
    });
    chart.on('click', (ev) => {
      console.log('🚀 ~ webComponent.js ~ LineChart ~ chart.on ~ ev:', ev);
      const event = new CustomEvent('clickchart', ev);
      this.dispatchEvent(event);
    });

    updateOption();
    const observer = new MutationObserver(updateOption);
    observer.observe(this, {attributes: true});
  }
}

customElements.define('line-chart', LineChart);
const chart = document.getElementById('myChart');
function changeChart() {
  chart.setAttribute(
    'data',
    JSON.stringify([
      [55, 125, 135, 115, 115, 125],
      [15, 120, 136, 110, 110, 210]
    ])
  );
}
window.changeChart = changeChart;
chart.addEventListener('clickchart', (ev) => {
  console.log('🚀 ~ webComponent.js ~ chart.addEventListener ~ ev:', ev);
});
function onClickChart(ev) {
  console.log(ev);
}
