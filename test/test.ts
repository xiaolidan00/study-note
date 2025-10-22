export default {
  //默认属性值
  config: {
    series: [{name: '柱体1'}, {name: '柱体2'}],
    tooltip: {
      trigger: 'axis'
    }
  },
  //绝对布局大小
  screen: {
    width: 400,
    height: 300
  },
  //相对布局大小
  flow: {
    col: 6,
    row: 4
  },
  //是否有预设样式
  isPreDefine: true,
  //是否使用主题颜色
  isTheme: true,
  //是否有交互动作
  isAction: true,
  //交互动作类型
  actionType: 'change',
  //是否有数据配置
  isData: true,
  //数据配置
  dataSetting: {
    dataType: 'json',
    dataMap: {name: 'name', value0: 'value', value1: 'value1'},
    dataList: [{name: '', value0: 10, value1: 20}]
  },
  //数据字段映射
  dataFields: (config: any) => {
    return [
      {label: '名称', prop: 'name', type: 'string'},
      ...config.series.map((it: any, i: number) => ({
        label: '系列' + (i + 1),
        prop: 'value' + i,
        type: 'number'
      }))
    ];
  },
  //属性配置
  formConfig: (elmt: any) => {
    return [];
  }
};
