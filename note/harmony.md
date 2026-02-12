# 鸿蒙学习

## arkUI

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-declarative-ui-description

## arkTs

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/learning-arkts

# hello world

`entry/src/main/pages/Index.ets`

```ts
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
  }
}
```

# 操作

## 预览效果

顶部右上角有个设备管理，下载对应的镜像，然后点开右侧的眼睛previewer

# 查看日志

需要点击左下方的Log>HiLog才能查看运行中的打印

## 格式化快捷键

`Ctrl+Alt+L`格式选中区域

`Ctrl + Alt + Shift + L`格式化整个文档

# 状态管理

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-v1-component-state-management

## V1@State组内状态同步

```ts
@Entry
@Component
struct MyComponent {
  @State count: number = 0; // 使用@State装饰简单类型变量

  build() {
    Row() {
      Column() {
        Button(`click times: ${this.count}`)
          .onClick(() => {
            this.count += 1;
          })
          .width(300)
      }
      .width('100%')
    }
    .height('100%')
  }
}
```

```ts

class Model {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

@Entry
@Component
struct EntryComponent {
  build() {
    Column() {
      // 此处指定的参数都将在初始渲染时覆盖本地定义的默认值，并不是所有的参数都需要从父组件初始化
      MyComponent({ count: 1, increaseBy: 2 })
        .width(300)
      MyComponent({ title: new Model('Hello World 2'), count: 7 })
    }
  }
}

@Component
struct MyComponent {
  @State title: Model = new Model('Hello World');
  @State count: number = 0;
  increaseBy: number = 1;

  build() {
    Column() {
      Text(`${this.title.value}`)
        .margin(10)
      Button(`Click to change title`)
        .onClick(() => {
          // @State变量的更新将触发上面的Text组件内容更新
          this.title.value = this.title.value === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
        })
        .width(300)
        .margin(10)

      Button(`Click to increase count = ${this.count}`)
        .onClick(() => {
          // @State变量的更新将触发该Button组件的内容更新
          this.count += this.increaseBy;
        })
        .width(300)
        .margin(10)
    }
  }
}

```

## v1@Prop 属性传参

```ts
@Component
struct Son {
  @Prop message: string = 'Hi';

  build() {
    Column() {
      Text(this.message)
    }
  }
}

@Entry
@Component
struct Father {
  @State message: string = 'Hello';

  build() {
    Column() {
      Text(this.message)
      Button(`father click`).onClick(() => {
        this.message += '*';
      })
      Son({ message: this.message })
    }
  }
}



```

```ts
class Book {
  public title: string;
  public pages: number;
  public readIt: boolean = false;

  constructor(title: string, pages: number) {
    this.title = title;
    this.pages = pages;
  }
}

@Component
struct ReaderComp {
  @Prop book: Book = new Book('', 0);

  build() {
    Row() {
      Text(this.book.title)
      Text(`...has${this.book.pages} pages!`)
      Text(`...${this.book.readIt ? 'I have read' : 'I have not read it'}`)
        .onClick(() => this.book.readIt = true)
    }
  }
}

@Entry
@Component
struct Library {
  @State book: Book = new Book('100 secrets of C++', 765);

  build() {
    Column() {
      ReaderComp({ book: this.book })
      ReaderComp({ book: this.book })
    }
  }
}
```

## v1@Link 类似v-model双向同步变量

```ts
class LinkInfo {
  public value: string = 'Hello';
}

@Component
struct LinkChild {
  // 在子组件中，使用@Link装饰LinkInfo类型的test变量
  @Link test: LinkInfo;

  build() {
    Text(this.test.value)
  }
}

@Entry
@Component
struct LinkExample {
  @State info: LinkInfo = new LinkInfo();

  build() {
    Column() {
      // 在父组件中，使用@State装饰的info变量初始化LinkChild组件的test变量
      LinkChild({test: this.info})
    }
  }
}
```

## v1@Provide和@Consume 类似provide和inject跨层级

```ts
@Component
struct Child {
  @Consume num: number;
  // 从API version 20开始，@Consume装饰的变量支持设置默认值
  @Consume num1: number = 17;

  build() {
    Column() {
      Text(`Value of num: ${this.num}`)
      Text(`Value of num1: ${this.num1}`)
    }
  }
}

@Entry
@Component
struct Parent {
  @Provide num: number = 10;

  build() {
    Column() {
      Text(`Value of num: ${this.num}`)
      Child()
    }
  }
}
```

## v1@Observed和@ObjectLink，类似pinia全局状态管理

```ts
@Observed
class Info {
  public count: number;

  constructor(count: number) {
    this.count = count;
  }
}

@Component
struct Child {
  @ObjectLink num: Info;

  build() {
    Column() {
      Text(`num value: ${this.num.count}`)
        .onClick(() => {
          // 正确写法，可以更改@ObjectLink装饰变量的成员属性
          this.num.count = 20;
        })
    }
  }
}

@Entry
@Component
struct Parent {
  @State num: Info = new Info(10);

  build() {
    Column() {
      Text(`count value: ${this.num.count}`)
      Button('click')
        .onClick(() => {
          // 可以在父组件做整体替换
          this.num = new Info(30);
        })
      Child({ num: this.num })
    }
  }
}
```

## v1@Watch 监听

```ts
@Entry
@Component
struct UsePropertyName {
  @State @Watch('countUpdated') apple: number = 0;
  @State @Watch('countUpdated') cabbage: number = 0;
  @State fruit: number = 0;

  // @Watch 回调
  countUpdated(propName: string): void {
    if (propName === 'apple') {
      this.fruit = this.apple;
    }
  }

  build() {
    Column() {
      Text(`Number of apples: ${this.apple.toString()}`).fontSize(30)
      Text(`Number of cabbages: ${this.cabbage.toString()}`).fontSize(30)
      Text(`Total number of fruits: ${this.fruit.toString()}`).fontSize(30)
      Button('Add apples')
        .onClick(() => {
          this.apple++;
        })
      Button('Add cabbages')
        .onClick(() => {
          this.cabbage++;
        })
    }
  }
}
```

## v1@Track 深度状态

```ts
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateTrack]';

class LogTrack {
  @Track public str1: string;
  @Track public str2: string;

  constructor(str1: string) {
    this.str1 = str1;
    this.str2 = 'World';
  }
}

class LogNotTrack {
  public str1: string;
  public str2: string;

  constructor(str1: string) {
    this.str1 = str1;
    this.str2 = 'World';
  }
}

@Entry
@Component
struct AddLog {
  @State logTrack: LogTrack = new LogTrack('Hello');
  @State logNotTrack: LogNotTrack = new LogNotTrack('Hello');

  isRender(index: number) {
    hilog.info(DOMAIN_NUMBER, TAG, `Text ${index} is rendered`);
    return 50;
  }

  build() {
    Row() {
      Column() {
        Text(this.logTrack.str1) // Text1
          .id('str1')
          .fontSize(this.isRender(1))
          .fontWeight(FontWeight.Bold)
        Text(this.logTrack.str2) // Text2
          .fontSize(this.isRender(2))
          .fontWeight(FontWeight.Bold)
        Button('change logTrack.str1')
          .id('str2')
          .onClick(() => {
            this.logTrack.str1 = 'Bye';
          })
        Text(this.logNotTrack.str1) // Text3
          .fontSize(this.isRender(3))
          .fontWeight(FontWeight.Bold)
        Text(this.logNotTrack.str2) // Text4
          .fontSize(this.isRender(4))
          .fontWeight(FontWeight.Bold)
        Button('change logNotTrack.str1')
          .onClick(() => {
            this.logNotTrack.str1 = 'Bye';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
```

## @LocalStorageProp和LocalStorageLink本地缓存

```ts
class Data {
  public code: number;

  constructor(code: number) {
    this.code = code;
  }
}

// 创建新实例并使用给定对象初始化
let para: Record<string, number> = { 'PropA': 47 };
let storage: LocalStorage = new LocalStorage(para);
storage.setOrCreate('PropB', new Data(50));

@Component
struct Child {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') childLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') childLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
      Button(`Child from LocalStorage ${this.childLinkNumber}`)
        .onClick(() => {
          this.childLinkNumber += 1;
        })
      // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
      Button(`Child from LocalStorage ${this.childLinkObject.code}`)
        .onClick(() => {
          this.childLinkObject.code += 1;
        })
    }
  }
}

// 使LocalStorage可从@Component组件访问
@Entry(storage)
@Component
struct Parent {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') parentLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      // 由于LocalStorage中PropA已经被初始化，因此this.parentLinkNumber的值为47
      Button(`Parent from LocalStorage ${this.parentLinkNumber}`)
        .onClick(() => {
          this.parentLinkNumber += 1;
        })
      // 由于LocalStorage中PropB已经被初始化，因此this.parentLinkObject.code的值为50
      Button(`Parent from LocalStorage ${this.parentLinkObject.code}`)
        .onClick(() => {
          this.parentLinkObject.code += 1;
        })
      // @Component子组件自动获得对Parent LocalStorage实例的访问权限
      Child()
    }
  }
}
```

```ts
// 创建新实例并使用给定对象初始化
let paraOneLocal: Record<string, number> = { 'PropA': 47 };
let storageOneLocal: LocalStorage = new LocalStorage(paraOneLocal);
// 使LocalStorage可从@Component组件访问
@Entry(storageOneLocal)
@Component
struct ParentOne {
  // @LocalStorageProp变量装饰器与LocalStorage中的'PropA'属性建立单向绑定
  @LocalStorageProp('PropA') storagePropOne: number = 1;

  build() {
    Column({ space: 15 }) {
      // 点击后从47开始加1，只改变当前组件显示的storagePropOne ，不会同步到LocalStorage中
      Button(`ParentOne from LocalStorage ${this.storagePropOne}`)
        .onClick(() => {
          this.storagePropOne += 1;
        })
      ChildOne()
    }
  }
}

@Component
struct ChildOne {
  // @LocalStorageProp变量装饰器与LocalStorage中的'PropA'属性建立单向绑定
  @LocalStorageProp('PropA') storagePropTwo: number = 2;

  build() {
    Column({ space: 15 }) {
      // 当ParentOne改变时，当前storagePropTwo不会改变，显示47
      Text(`ParentOne from LocalStorage ${this.storagePropTwo}`)
    }
  }
}
```

## @StorageLink和@StorageProp全局APP缓存

```ts
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG: string = '[SampleAppStorage]';

class Data {
  public code: number;

  constructor(code: number) {
    this.code = code;
  }
}

AppStorage.setOrCreate('propA', 47);
AppStorage.setOrCreate('propB', new Data(50));
let storage = new LocalStorage();
storage.setOrCreate('linkA', 48);
storage.setOrCreate('linkB', new Data(100));

@Entry(storage)
@Component
struct TestStorageProp {
  @StorageLink('propA') storageLink: number = 1;
  @StorageProp('propA') storageProp: number = 1;
  @StorageLink('propB') storageLinkObject: Data = new Data(1);
  @StorageProp('propB') storagePropObject: Data = new Data(1);

  build() {
    Column({ space: 20 }) {
      // @StorageLink与AppStorage建立双向联系，更改数据会同步回AppStorage中key为'propA'的值
      Text(`storageLink ${this.storageLink}`)
        .onClick(() => {
          this.storageLink += 1;
        })

      // @StorageProp与AppStorage建立单向联系，更改数据不会同步回AppStorage中key为'propA'的值
      // 但能被AppStorage的set/setorCreate更新值
      Text(`storageProp ${this.storageProp}`)
        .onClick(() => {
          this.storageProp += 1;
        })

      // AppStorage的API虽然能获取值，但是不具有刷新UI的能力，日志能看到数值更改
      // 依赖@StorageLink/@StorageProp才能建立起与自定义组件的联系，刷新UI
      Text(`change by AppStorage: ${AppStorage.get<number>('propA')}`)
        .onClick(() => {
          hilog.info(DOMAIN, TAG, `Appstorage.get: ${AppStorage.get<number>('propA')}`);
          AppStorage.set<number>('propA', 100);
        })

      Text(`storageLinkObject ${this.storageLinkObject.code}`)
        .onClick(() => {
          this.storageLinkObject.code += 1;
        })

      Text(`storagePropObject ${this.storagePropObject.code}`)
        .onClick(() => {
          this.storagePropObject.code += 1;
        })
    }
  }
}
```

## 持久化存储PersistentStorage

```ts
// 定义常量替代魔法值，明确数值含义
const DEFAULT_NUMBER: number = 10; // 默认数字值
const FONT_SIZE_LARGE: number = 50; // 大字体尺寸

// 初始化持久化属性，键名使用常量定义（若有多处使用可提取）
const STORAGE_KEY_P: string = 'P';
PersistentStorage.persistProp(STORAGE_KEY_P, undefined);

@Entry
@Component
struct TestCase6 {
  // 使用常量作为默认值，类型明确
  @StorageLink(STORAGE_KEY_P) p: number | undefined | null = DEFAULT_NUMBER;

  build() {
    Row() {
      Column() {
        Text(this.p + '')
          .fontSize(FONT_SIZE_LARGE)
          .fontWeight(FontWeight.Bold)
        Button('changeToNumber').onClick(() => {
          this.p = DEFAULT_NUMBER; // 引用常量，避免直接写10
        })
        Button('changeTo undefined').onClick(() => {
          this.p = undefined;
        })
        Button('changeTo null').onClick(() => {
          this.p = null;
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
```

## Environment系统环境变量

```ts
// 将设备languageCode存入AppStorage中
Environment.envProp('languageCode', 'en');

@Entry
@Component
struct UiEnvironment {
  @StorageProp('languageCode') languageCode: string = 'en';

  build() {
    Row() {
      Column() {
        // 输出当前设备的languageCode
        Text(this.languageCode)
      }
    }
  }
}
```

```ts
import {UIAbility} from '@kit.AbilityKit';
import {window} from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/Index');
    let window = windowStage.getMainWindow();
    window.then((window) => {
      let uiContext = window.getUIContext();
      uiContext.runScopedTask(() => {
        Environment.envProp('languageCode', 'en');
      });
    });
  }
}
```

## v2@Local

```ts
@Entry
@ComponentV2
struct Index {
  // 点击的次数
  @Local count: number = 0;
  @Local message: string = 'Hello';
  @Local flag: boolean = false;

  build() {
    Column() {
      Text(`${this.count}`)
      Text(`${this.message}`)
      Text(`${this.flag}`)
      Button('change Local')
        .onClick(() => {
          // 当@Local装饰简单类型时，能够观测到对变量的赋值
          this.count++;
          this.message += ' World';
          this.flag = !this.flag;
        })
    }
  }
}
```

```ts
@Entry
@ComponentV2
struct Index {
  // 点击的次数
  @Local count: number = 0;
  @Local message: string = 'Hello';
  @Local flag: boolean = false;

  build() {
    Column() {
      Text(`Local ${this.count}`)
      Text(`Local ${this.message}`)
      Text(`Local ${this.flag}`)
      Button('change Local')
        .onClick(() => {
          // 对数据源的更改会同步给子组件
          this.count++;
          this.message += ' World';
          this.flag = !this.flag;
        })
      Child({
        count: this.count,
        message: this.message,
        flag: this.flag
      })
    }
  }
}

@ComponentV2
struct Child {
  @Require @Param count: number;
  @Require @Param message: string;
  @Require @Param flag: boolean;

  build() {
    Column() {
      Text(`Param ${this.count}`)
      Text(`Param ${this.message}`)
      Text(`Param ${this.flag}`)
    }
  }
}
```

## v2@Once初始化只渲染一次

```ts
@ComponentV2
struct ChildComponent {
  @Param @Once onceParam: string = '';

  build() {
    Column() {
      Text(`onceParam: ${this.onceParam}`)
    }
  }
}

@Entry
@ComponentV2
struct MyComponent {
// ···
  @Local message: string = 'Hello World';

  build() {
    Column() {
      Text(`Parent message: ${this.message}`)
      Button('change message')
        .onClick(() => {
          this.message = 'Hello Tomorrow';
        })
      ChildComponent({ onceParam: this.message })
    }
  }
}
```

## v2@Event事件回调

```ts
@Entry
@ComponentV2
struct Index {
  @Local title: string = 'Title One';
  @Local fontColor: Color = Color.Red;

  build() {
    Column() {
      Child({
        title: this.title,
        fontColor: this.fontColor,
        changeFactory: (type: number) => {
          if (type == 1) {
            this.title = 'Title One';
            this.fontColor = Color.Red;
          } else if (type == 2) {
            this.title = 'Title Two';
            this.fontColor = Color.Green;
          }
        }
      })
    }
  }
}

@ComponentV2
struct Child {
  @Param title: string = '';
  @Param fontColor: Color = Color.Black;
  @Event changeFactory: (x: number) => void = (x: number) => {};

  build() {
    Column() {
      Text(`${this.title}`)
        .fontColor(this.fontColor)
      Button('change to Title Two')
        .onClick(() => {
          this.changeFactory(2);
        })
      Button('change to Title One')
        .onClick(() => {
          this.changeFactory(1);
        })
    }
  }
}
```

## v2@Provider装饰器和@Consumer装饰器

```ts
@Entry
@ComponentV2
struct Parent {
  @Provider() str1: string = 'hello';

  build() {
    Column() {
      Button(this.str1)
        .onClick(() => {
          this.str1 += '0';
        })
      Child()
    }
  }
}

@ComponentV2
struct Child {
  // @Consumer装饰的属性str和Parent组件中@Provider装饰的属性str1名称不同，无法建立双向绑定关系
  @Consumer() str: string = 'world';

  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
    }
  }
}
```

## v2@ObservedV2

```ts
let nextId: number = 0;

@ObservedV2
class Arr {
  public id: number = 0;
  @Trace public numberArr: number[] = [];

  constructor() {
    this.id = nextId++;
    this.numberArr = [0, 1, 2];
  }
}

@Entry
@ComponentV2
struct Index {
  arr: Arr = new Arr();

  build() {
    Column() {
      Text(`length: ${this.arr.numberArr.length}`)
        .fontSize(40)
      Divider()
      if (this.arr.numberArr.length >= 3) {
        Text(`${this.arr.numberArr[0]}`)
          .fontSize(40)
          .onClick(() => {
            this.arr.numberArr[0]++;
          })
        Text(`${this.arr.numberArr[1]}`)
          .fontSize(40)
          .onClick(() => {
            this.arr.numberArr[1]++;
          })
        Text(`${this.arr.numberArr[2]}`)
          .fontSize(40)
          .onClick(() => {
            this.arr.numberArr[2]++;
          })
      }

      Divider()

      ForEach(this.arr.numberArr, (item: number, index: number) => {
        Text(`${index} ${item}`)
          .fontSize(40)
      })

      Button('push')
        .onClick(() => {
          this.arr.numberArr.push(50);
        })

      Button('pop')
        .onClick(() => {
          this.arr.numberArr.pop();
        })

      Button('shift')
        .onClick(() => {
          this.arr.numberArr.shift();
        })

      Button('splice')
        .onClick(() => {
          this.arr.numberArr.splice(1, 0, 60);
        })


      Button('unshift')
        .onClick(() => {
          this.arr.numberArr.unshift(100);
        })

      Button('copywithin')
        .onClick(() => {
          this.arr.numberArr.copyWithin(0, 1, 2);
        })

      Button('fill')
        .onClick(() => {
          this.arr.numberArr.fill(0, 2, 4);
        })

      Button('reverse')
        .onClick(() => {
          this.arr.numberArr.reverse();
        })

      Button('sort')
        .onClick(() => {
          this.arr.numberArr.sort();
        })
    }
  }
}
```

## v2@Monitor 监听新旧值

```ts
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local name: string = 'Tom';
  @Local age: number = 24;

  @Monitor('message', 'name')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.info(0xFF00, 'testTag', '%{public}s',
        `${path} changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  build() {
    Column() {
      Button('change string')
        .onClick(() => {
          this.message += '!';
          this.name = 'Jack';
        })
    }
  }
}
```

## v2@Computed计算属性

```ts
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';

@Entry
@ComponentV2
struct CustomComponentUse {
  @Local firstName: string = 'Li';
  @Local lastName: string = 'Hua';
  age: number = 20; // 无法触发Computed

  @Computed
  get fullName() {
    hilog.info(DOMAIN, TAG, BUNDLE + '---------Computed----------');
    return this.firstName + ' ' + this.lastName + this.age;
  }

  build() {
    Column() {
      Text(this.lastName + ' ' + this.firstName)
      Text(this.lastName + ' ' + this.firstName)
      Divider()
      Text(this.fullName)
      Text(this.fullName)
      Button('changed lastName')
        .onClick(() => {
          this.lastName += 'a';
        })

      Button('changed age')
        .onClick(() => {
          this.age++;  // 无法触发Computed
        })
    }
  }
}
```

## AppStorageV2

```ts
// 数据中心
// Sample.ets
@ObservedV2
export class Sample {
  @Trace public p1: number = 0;
  public p2: number = 10;
}
import { AppStorageV2 } from '@kit.ArkUI';
import { Sample } from './Sample';

@Entry
@ComponentV2
struct PageOne {
  // 在AppStorageV2中创建一个key为Sample的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
  @Local prop: Sample = AppStorageV2.connect(Sample, () => new Sample())!;
  pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Column() {
        Button('Go to pageTwo')
          .onClick(() => {
            this.pageStack.pushPathByName('PageTwo', null);
          })

        Button('PageOne connect the key Sample')
          .onClick(() => {
            // 在AppStorageV2中创建一个key为Sample的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
            this.prop = AppStorageV2.connect(Sample, 'Sample', () => new Sample())!;
          })

        Button('PageOne remove the key Sample')
          .onClick(() => {
            // 从AppStorageV2中删除后，prop将不会再与key为Sample的值关联
            AppStorageV2.remove(Sample);
          })

        Text(`PageOne add 1 to prop.p1: ${this.prop.p1}`)
          .fontSize(30)
          .onClick(() => {
            this.prop.p1++;
          })

        Text(`PageOne add 1 to prop.p2: ${this.prop.p2}`)
          .fontSize(30)
          .onClick(() => {
            // 页面不刷新，但是p2的值改变了
            this.prop.p2++;
          })

        // 获取当前AppStorageV2里面的所有key
        Text(`all keys in AppStorage: ${AppStorageV2.keys()}`)
          .fontSize(30)
      }
    }
  }
}


import { AppStorageV2 } from '@kit.ArkUI';
import { Sample } from './Sample';

@Builder
export function PageTwoBuilder() {
  PageTwo()
}

@ComponentV2
struct PageTwo {
  // 在AppStorageV2中创建一个key为Sample的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
  @Local prop: Sample = AppStorageV2.connect(Sample, () => new Sample())!;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Button('PageTwo connect the key Sample1')
          .onClick(() => {
            // 在AppStorageV2中创建一个key为Sample1的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
            this.prop = AppStorageV2.connect(Sample, 'Sample1', () => new Sample())!;
          })

        Text(`PageTwo add 1 to prop.p1: ${this.prop.p1}`)
          .fontSize(30)
          .onClick(() => {
            this.prop.p1++;
          })

        Text(`PageTwo add 1 to prop.p2: ${this.prop.p2}`)
          .fontSize(30)
          .onClick(() => {
            // 页面不刷新，但是p2的值改变了；只有重新初始化才会改变
            this.prop.p2++;
          })

        // 获取当前AppStorageV2里面的所有key
        Text(`all keys in AppStorage: ${AppStorageV2.keys()}`)
          .fontSize(30)
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
```

## PersistenceV2

```ts
// EntryAbility.ets
// 以下为代码片段，需要开发者自己在EntryAbility.ets中补全
import { PersistenceV2 } from '@kit.ArkUI';

// 在EntryAbility外部定义class
@ObservedV2
class Storage {
  @Trace isPersist: boolean = false;
}

// 在onWindowStageCreate的loadContent回调中调用PersistenceV2
onWindowStageCreate(windowStage: window.WindowStage): void {
  windowStage.loadContent('pages/Index', (err) => {
    if (err.code) {
      return;
    }
    PersistenceV2.connect(Storage, () => new Storage());
  });
}
```

## $$双向同步

```ts
// xxx.ets
@Entry
@Component
struct TextInputExample {
  @State text: string = '';
  controller: TextInputController = new TextInputController();

  build() {
    Column({ space: 20 }) {
      Text(this.text)
      TextInput({ text: $$this.text, placeholder: 'input your word...', controller: this.controller })
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width(300)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## !!双向绑定

```ts
Child({
  value: this.value,
  $value: (val: number) => {
    this.value = val;
  }
});

//等价于
Star({value: this.value!!});
```

# 布局

## 线性布局（Row、Column）

Column类似于`display:flex;flex-direction:column;`

```ts
Column({ space: 20 }) {
      Text('space: 20').fontSize(15).fontColor(Color.Gray).width('90%')
      Row().width('90%').height(50).backgroundColor(0xF5DEB3)
      Row().width('90%').height(50).backgroundColor(0xD2B48C)
      Row().width('90%').height(50).backgroundColor(0xF5DEB3)
    }.width('100%').height('100%')
```

## Row类似于`display:flex;flex-direction:row;`

```ts
Row({ space: 35 }) {
  Text('space: 35').fontSize(15).fontColor(Color.Gray)
  Row().width('10%').height(150).backgroundColor(0xF5DEB3)
  Row().width('10%').height(150).backgroundColor(0xD2B48C)
  Row().width('10%').height(150).backgroundColor(0xF5DEB3)
}.width('90%')
```

### 排列方式

```ts
//顶部对齐
Column({}) {
  Column() {
  }.width('80%').height(50).backgroundColor(0xF5DEB3)

  Column() {
  }.width('80%').height(50).backgroundColor(0xD2B48C)

  Column() {
  }.width('80%').height(50).backgroundColor(0xF5DEB3)
}.width('100%').height(300).backgroundColor('rgb(242,242,242)').justifyContent(FlexAlign.Start)
//垂直居中
FlexAlign.Center
//底部对齐
FlexAlign.End

//平均间隔
FlexAlign.SpaceBetween

//平均间隔,两侧为两端元素一半的边距
FlexAlign.SpaceAround
//平均间隔，两侧边距也同样
FlexAlign.SpaceEvenly

//同理
Row({}) {
  Column() {
  }.width('20%').height(30).backgroundColor(0xF5DEB3)

  Column() {
  }.width('20%').height(30).backgroundColor(0xD2B48C)

  Column() {
  }.width('20%').height(30).backgroundColor(0xF5DEB3)
}.width('100%').height(200).backgroundColor('rgb(242,242,242)').justifyContent(FlexAlign.SpaceEvenly)
```

### 对齐方式

```ts
//水平左对齐
Column({}) {
  Column() {
  }.width('80%').height(50).backgroundColor(0xF5DEB3)

  Column() {
  }.width('80%').height(50).backgroundColor(0xD2B48C)

  Column() {
  }.width('80%').height(50).backgroundColor(0xF5DEB3)
}.width('100%').alignItems(HorizontalAlign.Start).backgroundColor('rgb(242,242,242)')

//水平居中
HorizontalAlign.Center
//水平右对齐
HorizontalAlign.End
```

```ts
//顶部对齐
Row({}) {
  Column() {
  }.width('20%').height(30).backgroundColor(0xF5DEB3)

  Column() {
  }.width('20%').height(30).backgroundColor(0xD2B48C)

  Column() {
  }.width('20%').height(30).backgroundColor(0xF5DEB3)
}.width('100%').height(200).alignItems(VerticalAlign.Top).backgroundColor('rgb(242,242,242)')

//垂直居中
VerticalAlign.Center

//底部对齐
VerticalAlign.Bottom
```

### 填充空白 Blank()

填充空白自适应拉伸

```ts
@Entry
@Component
struct BlankExample {
  build() {
    Column() {
      Row() {
        Text('Bluetooth').fontSize(18)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: true })
      }.backgroundColor(0xFFFFFF).borderRadius(15).padding({ left: 12 }).width('100%')
    }.backgroundColor(0xEFEFEF).padding(20).width('100%')
  }
}
```

### 按比例权重缩放 layoutWeight(n)

```ts
@Entry
@Component
struct LayoutWeightExample {
  build() {
    Column() {
      Text('1:2:3').width('100%')
      Row() {
        Column() {
          Text('layoutWeight(1)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(1).backgroundColor(0xF5DEB3).height('100%')

        Column() {
          Text('layoutWeight(2)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(2).backgroundColor(0xD2B48C).height('100%')

        Column() {
          Text('layoutWeight(3)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(3).backgroundColor(0xF5DEB3).height('100%')

      }.backgroundColor(0xffd306).height('30%')

      Text('2:5:3').width('100%')
      Row() {
        Column() {
          Text('layoutWeight(2)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(2).backgroundColor(0xF5DEB3).height('100%')

        Column() {
          Text('layoutWeight(5)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(5).backgroundColor(0xD2B48C).height('100%')

        Column() {
          Text('layoutWeight(3)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(3).backgroundColor(0xF5DEB3).height('100%')
      }.backgroundColor(0xffd306).height('30%')
    }
  }
}
//或者直接使用百分比
@Entry
@Component
struct WidthExample {
  build() {
    Column() {
      Row() {
        Column() {
          Text('left width 20%')
            .textAlign(TextAlign.Center)
        }.width('20%').backgroundColor(0xF5DEB3).height('100%')

        Column() {
          Text('center width 50%')
            .textAlign(TextAlign.Center)
        }.width('50%').backgroundColor(0xD2B48C).height('100%')

        Column() {
          Text('right width 30%')
            .textAlign(TextAlign.Center)
        }.width('30%').backgroundColor(0xF5DEB3).height('100%')
      }.backgroundColor(0xffd306).height('30%')
    }
  }
}
```

## 滚动条 Scroll(this.scroller)

```ts
//纵向滚动
@Entry
@Component
struct ScrollVerticalExample {
  scroller: Scroller = new Scroller();
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.arr, (item?:number|undefined) => {
          if(item){
            Text(item.toString())
              .width('90%')
              .height(150)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ top: 10 })
          }
        }, (item:number) => item.toString())
      }.width('100%')
    }
    .backgroundColor(0xDCDCDC)
    .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.On) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
  }
}

//横向滚动
@Entry
@Component
struct ScrollHorizontalExample {
  scroller: Scroller = new Scroller();
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Scroll(this.scroller) {
      Row() {
        ForEach(this.arr, (item?:number|undefined) => {
          if(item){
            Text(item.toString())
              .height('90%')
              .width(150)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ left: 10 })
          }
        })
      }.height('100%')
    }
    .backgroundColor(0xDCDCDC)
    .scrollable(ScrollDirection.Horizontal) // 滚动方向为水平方向
    .scrollBar(BarState.On) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
  }
}
```

## 层叠布局（Stack）

```ts
let mTop:Record<string,number> = { 'top': 50 }

@Entry
@Component
struct StackLayoutExample {
  build() {
    Column(){
      Stack({ }) {
        Column(){}.width('90%').height('100%').backgroundColor('#ff58b87c')//最外层
        Text('text').width('60%').height('60%').backgroundColor('#ffc3f6aa')//中间层
        Button('button').width('30%').height('30%').backgroundColor('#ff8ff3eb').fontColor('#000')//里层
      }.width('100%').height(150).margin(mTop)
    }
  }
}
```

### 对齐方式

```ts
@Entry
@Component
struct StackAlignContentExample {
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('Stack').width('90%').height('100%').backgroundColor('#e1dede').align(Alignment.BottomEnd)//最外层
      Text('Item 1').width('70%').height('80%').backgroundColor(0xd2cab3).align(Alignment.BottomEnd)//中间层
      Text('Item 2').width('50%').height('60%').backgroundColor(0xc1cbac).align(Alignment.BottomEnd)//里层
    }.width('100%').height(150).margin({ top: 5 })
  }
}
//
Alignment.TopStart
Alignment.Top
Alignment.TopEnd

Alignment.Start
Alignment.Center
Alignment.End


Alignment.BottomStart
Alignment.Bottom
Alignment.BottomEnd
```

## 遍历添加组件

```ts
@Entry
@Component
struct StackSample {
  private arr: string[] = ['APP1', 'APP2', 'APP3', 'APP4', 'APP5', 'APP6', 'APP7', 'APP8'];

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.arr, (item:string) => {
          Text(item)
            .width(100)
            .height(100)
            .fontSize(16)
            .margin(10)
            .textAlign(TextAlign.Center)
            .borderRadius(10)
            .backgroundColor(0xFFFFFF)
        }, (item:string):string => item)
      }.width('100%').height('100%')


    }.width('100%').height('100%').backgroundColor('#CFD0CF')
  }
}
```

## 弹性布局（Flex）

排布方向

```ts
//平分空间
Flex({ direction: FlexDirection.Row }) {
  Text('1').width('33%').height(50).backgroundColor('#F5DEB3')
  Text('2').width('33%').height(50).backgroundColor('#D2B48C')
  Text('3').width('33%').height(50).backgroundColor('#F5DEB3')
}
.height(70)
.width('90%')
.padding(10)
.backgroundColor('#AFEEEE')


//
FlexDirection.RowReverse

FlexDirection.Column

FlexDirection.ColumnReverse
```

换行

```ts
Flex({ wrap: FlexWrap.NoWrap }) {
  Text('1').width('50%').height(50).backgroundColor('#F5DEB3')
  Text('2').width('50%').height(50).backgroundColor('#D2B48C')
  Text('3').width('50%').height(50).backgroundColor('#F5DEB3')
}
.width('90%')
.padding(10)
.backgroundColor('#AFEEEE')


FlexWrap.Wrap

FlexWrap.WrapReverse
```

对齐

```ts
Flex({ justifyContent: FlexAlign.Start }) {
  Text('1').width('20%').height(50).backgroundColor('#F5DEB3')
  Text('2').width('20%').height(50).backgroundColor('#D2B48C')
  Text('3').width('20%').height(50).backgroundColor('#F5DEB3')
}
.width('90%')
.padding({ top: 10, bottom: 10 })
.backgroundColor('#AFEEEE')
//FlexAlign.Center
//FlexAlign.End
//FlexAlign.SpaceBetween
//FlexAlign.SpaceAround
// FlexAlign.SpaceEvenly


Flex({ alignItems: ItemAlign.Auto }) {
  Text('1').width('33%').height(30).backgroundColor('#F5DEB3')
  Text('2').width('33%').height(40).backgroundColor('#D2B48C')
  Text('3').width('33%').height(50).backgroundColor('#F5DEB3')
}
.size({ width: '90%', height: 80 })
.padding(10)
.backgroundColor('#AFEEEE')
//ItemAlign.Center
//ItemAlign.End
//ItemAlign.Stretch
// ItemAlign.Baseline

//设置子元素对齐 .alignSelf(ItemAlign.Start)
Text('alignSelf Start').width('25%').height(80)
    .alignSelf(ItemAlign.Start)
    .backgroundColor('#F5DEB3')

//内容适配 alignContent
Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Start }) {
  Text('1').width('30%').height(20).backgroundColor('#F5DEB3')
  Text('2').width('60%').height(20).backgroundColor('#D2B48C')
  Text('3').width('40%').height(20).backgroundColor('#D2B48C')
  Text('4').width('30%').height(20).backgroundColor('#F5DEB3')
  Text('5').width('20%').height(20).backgroundColor('#D2B48C')
}
.width('90%')
.height(100)
.backgroundColor('#AFEEEE')
```

### 自适应拉伸

flexBasis('auto')

```ts
Flex() {
  Text('flexBasis("auto")')
    .flexBasis('auto')// 未设置width以及flexBasis值为auto，内容自身宽度
    .height(100)
    .backgroundColor('#F5DEB3')
  Text('flexBasis("auto")'+' width("40%")')
    .width('40%')
    .flexBasis('auto')//设置width以及flexBasis值auto，使用width的值
    .height(100)
    .backgroundColor('#D2B48C')

  Text('flexBasis(100)') // 未设置width以及flexBasis值为100，宽度为100vp
    .flexBasis(100)
    .height(100)
    .backgroundColor('#F5DEB3')

  Text('flexBasis(100)')
    .flexBasis(100)
    .width(200)// flexBasis值为100，覆盖width的设置值，宽度为100vp
    .height(100)
    .backgroundColor('#D2B48C')
}.width('90%').height(120).padding(10).backgroundColor('#AFEEEE')
```

flexGrow(1)拉伸

```ts
  Flex() {
    Text('flexGrow(1)')
      .flexGrow(1)
      .width(100)
      .height(100)
      .backgroundColor('#F5DEB3')
    Text('flexGrow(4)')
      .flexGrow(4)
      .width(100)
      .height(100)
      .backgroundColor('#D2B48C')

    Text('no flexGrow')
      .width(100)
      .height(100)
      .backgroundColor('#F5DEB3')
  }.width(360).height(120).padding(10).backgroundColor('#AFEEEE')
```

flexShrink(3)收缩

```ts
Flex({ direction: FlexDirection.Row }) {
  Text('flexShrink(3)')
    .flexShrink(3)
    .width(200)
    .height(100)
    .backgroundColor('#F5DEB3')

  Text('no flexShrink')
    .width(200)
    .height(100)
    .backgroundColor('#D2B48C')

  Text('flexShrink(2)')
    .flexShrink(2)
    .width(200)
    .height(100)
    .backgroundColor('#F5DEB3')
}.width(400).height(120).padding(10).backgroundColor('#AFEEEE')
```

## 相对布局（RelativeContainer）

父组件为锚点相对布局

```ts
let alignRus: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
}
let alignRue: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
}
let marginLeft: Record<string, number> = { 'left': 20 }
let bwc: Record<string, number | string> = { 'width': 2, 'color': '#6699FF' }

@Entry
@Component
struct ParentRefRelativeContainer {
  build() {
    RelativeContainer() {
      Row() {
        Text('row1')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#a3cf62')
      .alignRules(alignRus)
      .id('row1')

      Row() {
        Text('row2')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#00ae9d')
      .alignRules(alignRue)
      .id('row2')
    }.width(300).height(300)
    .margin(marginLeft)
    .border(bwc)
  }
}
```

兄弟元素为锚点相对布局

```ts
let alignRus001: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
}
let relConB: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': 'row1', 'align': VerticalAlign.Bottom },
  'left': { 'anchor': 'row1', 'align': HorizontalAlign.Start }
}
let marginLeft001: Record<string, number> = { 'left': 20 }
let bwc001: Record<string, number | string> = { 'width': 2, 'color': '#6699FF' }

@Entry
@Component
struct SiblingRefRelativeContainer {
  build() {
    RelativeContainer() {
      Row() {
        Text('row1')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#00ae9d')
      .alignRules(alignRus001)
      .id('row1')

      Row() {
        Text('row2')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#a3cf62')
      .alignRules(relConB)
      .id('row2')
    }.width(300).height(300)
    .margin(marginLeft001)
    .border(bwc001)
  }
}
```

子组件偏移 offset

```ts
@Entry
@Component
struct ChildComponentOffsetExample {
  build() {
    Row() {
      RelativeContainer() {
        Row() {
          Text('row1')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .height(100)
        .backgroundColor('#a3cf62')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('row1')

        Row() {
          Text('row2')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .backgroundColor('#00ae9d')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: 'row1', align: VerticalAlign.Center },
        })
        .offset({
          x: -40,
          y: -20
        })
        .id('row2')

      }
    }
  }
}
```

辅助线辅助定位子组件

```ts
@Entry
@Component
struct RelativeGuideLineExample {
  build() {
    Row() {
      RelativeContainer() {
        Row()
          .width(100)
          .height(100)
          .backgroundColor('#a3cf62')
          .alignRules({
            left: { anchor: 'guideline1', align: HorizontalAlign.End },
            top: { anchor: 'guideline2', align: VerticalAlign.Top }
          })
          .id('row1')
      }
      .width(300)
      .height(300)
      .margin({ left: 50 })
      .border({ width: 2, color: '#6699FF' })
      .guideLine([{ id: 'guideline1', direction: Axis.Vertical, position: { start: 50 } },
        { id: 'guideline2', direction: Axis.Horizontal, position: { start: 50 } }])
    }
    .height('100%')
  }
}
```

多组件屏障

```ts
@Entry
@Component
struct Index {
  build() {
    Row() {
      RelativeContainer() {
        Row() {
          Text('row1')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .height(100)
        .backgroundColor('#a3cf62')
        .id('row1')

        Row() {
          Text('row2')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .height(100)
        .backgroundColor('#00ae9d')
        .alignRules({
          middle: { anchor: 'row1', align: HorizontalAlign.End },
          top: { anchor: 'row1', align: VerticalAlign.Bottom }
        })
        .id('row2')

        Row() {
          Text('row3')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .height(100)
        .backgroundColor('#0a59f7')
        .alignRules({
          left: { anchor: 'barrier1', align: HorizontalAlign.End },
          top: { anchor: 'row1', align: VerticalAlign.Top }
        })
        .id('row3')

        Row() {
          Text('row4')
        }
        .justifyContent(FlexAlign.Center)
        .width(50)
        .height(50)
        .backgroundColor('#2ca9e0')
        .alignRules({
          left: { anchor: 'row1', align: HorizontalAlign.Start },
          top: { anchor: 'barrier2', align: VerticalAlign.Bottom }
        })
        .id('row4')
      }
      .width(300)
      .height(300)
      .margin({ left: 50 })
      .border({ width: 2, color: '#6699FF' })
      .barrier([{ id: 'barrier1', direction: BarrierDirection.RIGHT, referencedId: ['row1', 'row2'] },
        { id: 'barrier2', direction: BarrierDirection.BOTTOM, referencedId: ['row1', 'row2'] }])
    }
    .height('100%')
  }
}
```

## 栅格布局（GridRow、GridCol）

```ts
@Entry
@Component
struct WindowRefGridLayout {
  @State currentBp: string = "unknown"
  @State bgColors: ResourceColor[] =
    ['rgb(213,213,213)', 'rgb(150,150,150)', 'rgb(0,74,175)', 'rgb(39,135,217)', 'rgb(61,157,180)', 'rgb(23,169,141)',
      'rgb(255,192,0)', 'rgb(170,10,33)'];

  build() {
    Column({ space: 6 }) {
      Text(this.currentBp)

      GridRow({
        columns: {
          xs: 2, // 窗口宽度落入xs断点上，栅格容器分为2列。
          sm: 4, // 窗口宽度落入sm断点上，栅格容器分为4列。
          md: 8, // 窗口宽度落入md断点上，栅格容器分为8列。
          lg: 12, // 窗口宽度落入lg断点上，栅格容器分为12列。
          xl: 12, // 窗口宽度落入xl断点上，栅格容器分为12列。
          xxl: 12 // 窗口宽度落入xxl断点上，栅格容器分为12列。
        },
        breakpoints: {
          value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'], // 表示在保留默认断点['320vp', '600vp', '840vp']的同时自定义增加'1440vp', '1600vp'的断点，实际开发中需要根据实际使用场景，合理设置断点值实现一次开发多端适配。
          reference: BreakpointsReference.WindowSize
        }
      }) {
        ForEach(this.bgColors, (color: ResourceColor, index?: number | undefined) => {
          GridCol({ span: 1 }) { // 所有子组件占一列。
            Row() {
              Text(`${index}`)
            }.width('100%').height('50vp')
          }.backgroundColor(color)
        })
      }
      .height(200)
      .border({ color: 'rgb(39,135,217)', width: 2 })
      .onBreakpointChange((breakPoint) => {
        this.currentBp = breakPoint
      })
    }
  }
}
```

间距

```ts
GridRow({ gutter: 10 }) { /* ... */ }
GridRow({ gutter: { x: 20, y: 50 } }) { /* ... */ }
```

排列方向

```ts
GridRow({ direction: GridRowDirection.Row }) { /* ... */ }
GridRow({ direction: GridRowDirection.RowReverse }) { /* ... */ }
```

## 选项卡（Tabs）

```ts
Tabs() {
  TabContent() {
    Text('111')
      .fontSize(30)
  }
  .tabBar('tab1')

  TabContent() {
    Text('222')
      .fontSize(30)
  }
  .tabBar('tab2')

  TabContent() {
    Text('333')
      .fontSize(30)
  }
  .tabBar('tab3')
}
```

### Tab位置

```ts
//底部
Tabs({ barPosition: BarPosition.End }) {

  // ···
}
//顶部
Tabs({ barPosition: BarPosition.Start }) {

  // ···
}
//左侧栏
 Tabs({ barPosition: BarPosition.Start }) {
    // ···
  }
  .vertical(true)
  .barWidth(100)
  .barHeight(200)
```

### 限制滑动切换

```ts
Tabs({ barPosition: BarPosition.Start }) {
  // ···
}.scrollable(false)
```

### 导航栏是否可滚动

```ts
//固定不滚动
Tabs({ barPosition: BarPosition.End }) {
  // ···
}
.barMode(BarMode.Fixed)
//可滚动
Tabs({ barPosition: BarPosition.Start }) {
  // ···
}
.barMode(BarMode.Scrollable)
```

### 导航栏自定义样式

```ts
@State currentIndex: number = 0;

@Builder
tabBuilder(title: ResourceStr, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
  Column() {
    Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
      .size({ width: 25, height: 25 })
    Text(title)
      .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
  }
  .width('100%')
  .height(50)
  .justifyContent(FlexAlign.Center)
}
```

```ts
TabContent() {
  Column() {

    Text('1111')
  }
  .width('100%')
  .height('100%')
  .backgroundColor('#007DFF')
}
.tabBar(this.tabBuilder('tab1', 0, 'active.png', 'normal.png'))
```

```ts
@Entry
@Component
export struct ContentPageNoAndTabLinkage {

  @State selectIndex: number = 0;
  @Builder tabBuilder(title: Resource, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.selectIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
  }
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // ...
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              // app.string.homepage_content资源文件中的value值为“首页内容”
              Text($r('app.string.homepage_content')).width('100%').height('100%').backgroundColor('rgb(213,213,213)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            //app.string.homepage资源文件中的value值为“首页”
            }.tabBar(this.tabBuilder($r('app.string.homepage'), 0))

            TabContent() {
              // app.string.discover_content资源文件中的value值为“发现内容”
              Text($r('app.string.discover_content')).width('100%').height('100%').backgroundColor('rgb(112,112,112)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            // app.string.discover资源文件中的value值为“发现”
            }.tabBar(this.tabBuilder($r('app.string.discover'), 1))

            TabContent() {
              // app.string.recommend_content资源文件中的value值为“推荐内容”
              Text($r('app.string.recommend_content')).width('100%').height('100%').backgroundColor('rgb(39,135,217)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            // app.string.recommend资源文件中的value值为“推荐”
            }.tabBar(this.tabBuilder($r('app.string.recommend'), 2))

            TabContent() {
              // app.string.mine_content资源文件中的value值为“我的内容”
              Text($r('app.string.mine_content')).width('100%').height('100%').backgroundColor('rgb(0,74,175)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            }
            // app.string.mine资源文件中的value值为“我的”
            .tabBar(this.tabBuilder($r('app.string.mine'), 3))
          }
          .animationDuration(0)
          .backgroundColor('#F1F3F5')
          .onSelected((index: number) => {
            this.selectIndex = index;
          })
        // ...
      }
      .width('100%')
      // ...
    }
    // ...
  }
}
```

# 网络请求

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/http-request

```ts
import { http } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface IDataItem {
  name: string;
  value: number;
}

interface GeneratedTypeLiteralInterface_1 {
  data: IDataItem[];
}

@Entry
@Component
struct WindowRefGridLayout {
  @State list: Array<IDataItem> = [];

  // onPageShow(): void {
  //   hilog.info(0x0000, 'testTag', 'onPageShow');
  // }
  //   // 组件生命周期
  //   aboutToAppear() {
  //     hilog.info(0x0000, 'testTag', 'Parent aboutToAppear');
  //   }
  //
  //   // 组件生命周期
  //   onDidBuild() {
  //     hilog.info(0x0000, 'testTag', 'Parent onDidBuild');
  //   }
  //
  //   // 组件生命周期
  //   aboutToDisappear() {
  //     hilog.info(0x0000, 'testTag', 'Parent aboutToDisappear');
  //   }

  aboutToAppear() {
    const httpRequest = http.createHttp();

    httpRequest.request('https://www.xiaolidan00.top/getRandNum.php', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
    }, (err: BusinessError, res: http.HttpResponse) => {
      if (err) {
        hilog.info(0x0000, 'testTag', err.message)
      } else {
        if (res.responseCode === 200) {
          hilog.info(0x0000, 'testTag', JSON.stringify(res.result))
          try {
            const data = JSON.parse(res.result as string) as GeneratedTypeLiteralInterface_1;
            hilog.info(0x0000, 'testTag', data.data.length + '')
            this.list = data.data

          } catch (e) {
            hilog.info(0x0000, 'testTag', e.message)
          }
        }
      }
      httpRequest.destroy();
    })


  }

  aboutToDisappear(): void {
    this.list = [];
  }

  build() {
    Tabs() {
      ForEach(this.list, (item: IDataItem, i: number) => {
        TabContent() {
          Text(item.name + ':' + item.value)
            .fontSize(30)
        }
        .tabBar('tab' + i)
      })
    }.barMode(BarMode.Scrollable)
  }
}
```

# 懒加载LazyForEach

```ts
import { hilog } from '@kit.PerformanceAnalysisKit';
/** BasicDataSource代码见文档末尾BasicDataSource示例代码: String类型数组的BasicDataSource代码。**/
import { BasicDataSource } from './BasicDataSource';
const TAG = '[Sample_RenderingControl]';
const DOMAIN = 0xF811;

class SwappingDataSource extends BasicDataSource {
  private dataArray: string[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public getAllData(): string[] {
    return this.dataArray;
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

  public moveData(from: number, to: number): void {
    let temp: string = this.dataArray[from];
    this.dataArray[from] = this.dataArray[to];
    this.dataArray[to] = temp;
    this.notifyDataMove(from, to);
  }
}

@Entry
@Component
struct SwappingData {
  private moved: number[] = [];
  private data: SwappingDataSource = new SwappingDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(`Hello ${i}`);
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: string, index: number) => {
        ListItem() {
          Row() {
            Text(item).fontSize(50)
              .onAppear(() => {
                hilog.info(DOMAIN, TAG, 'appear: ${item}');
              })
          }.margin({ left: 10, right: 10 })
        }
        .onClick(() => {
          this.moved.push(this.data.getAllData().indexOf(item));
          if (this.moved.length === 2) {
            // 点击交换子组件
            this.data.moveData(this.moved[0], this.moved[1]);
            this.moved = [];
          }
        })
      }, (item: string) => item)
    }
    .cachedCount(5)
  }
}
```

# 重复渲染Repeat

```ts
// 在List容器组件中使用Repeat
@Entry
@ComponentV2 // 推荐使用V2装饰器
struct RepeatExampleWithTemplates {
  @Local dataArr: Array<string> = []; // 数据源

  aboutToAppear(): void {
    for (let i = 0; i < 50; i++) {
      this.dataArr.push(`data_${i}`); // 为数组添加一些数据
    }
  }

  build() {
    Column() {
      List() {
        Repeat<string>(this.dataArr)
          .each((ri: RepeatItem<string>) => { // 默认渲染模板
            ListItem() {
              Text('each_' + ri.item).fontSize(30).fontColor('rgb(161,10,33)') // 文本颜色为红色
            }
          })
          .key((item: string, index: number): string => JSON.stringify(item)) // 键值生成函数
          .virtualScroll({ totalCount: this.dataArr.length }) // 打开懒加载，totalCount为期望加载的数据长度
          .templateId((item: string, index: number): string => { // 根据返回值寻找对应的模板子组件进行渲染
            return index <= 4 ? 'A' : (index <= 10 ? 'B' : ''); // 前5个节点模板为A，接下来的5个为B，其余为默认模板
          })
          .template('A', (ri: RepeatItem<string>) => { // 'A'模板
            ListItem() {
              Text('A_' + ri.item).fontSize(30).fontColor('rgb(23,169,141)') // 文本颜色为绿色
            }
          }, { cachedCount: 3 }) // 'A'模板的缓存列表容量为3
          .template('B', (ri: RepeatItem<string>) => { // 'B'模板
            ListItem() {
              Text('B_' + ri.item).fontSize(30).fontColor('rgb(39,135,217)') // 文本颜色为蓝色
            }
          }, { cachedCount: 4 }) // 'B'模板的缓存列表容量为4
      }
      .cachedCount(2) // 容器组件的预加载区域大小
      .height('70%')
      .border({ width: 1 }) // 边框
    }
  }
}
```

虚拟滚动

```ts
@Entry
@ComponentV2
struct RepeatLazyLoadingSync {
  @Local arr: Array<string> = [];
  build() {
    Column({ space: 5 }) {
      List({ space: 5 }) {
        Repeat(this.arr)
          .virtualScroll({
            onTotalCount: () => { return 100; },
            // 实现数据懒加载。
            onLazyLoading: (index: number) => {
              // 创建占位符。
              this.arr[index] = '';
              // 模拟高耗时加载过程，通过异步任务加载数据。
              setTimeout(() => { this.arr[index] = index.toString(); }, 1000);
            }
          })
          .each((obj: RepeatItem<string>) => {
            ListItem() {
              Row({ space: 5 }) {
                Text(`${obj.index}: Item_${obj.item}`)
              }
            }
            .height(50)
          })
      }
      .height('100%')
      .border({ width: 1})
    }
  }
}
```

# ContentSlot插槽

```ts
import nativeNode from 'libentry.so'; // 开发者自己实现的so
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Parent {
  // ···
  private nodeContent_1: Content = new NodeContent();
  private nodeContent_2: Content = new NodeContent();

  aboutToAppear() {
    // ···
    // 通过C-API创建节点，并添加到管理器nodeContent_1和nodeContent_2上
    nativeNode.createNativeNode(this.nodeContent_1);
    nativeNode.createNativeNode(this.nodeContent_2);
  }

  build() {
    Column() {
      // ···
      ContentSlot(this.nodeContent_1);// nodeContent_1将被挂载到下一个Contentslot节点，此处无法显示
      ContentSlot(this.nodeContent_1); // 正常显示
      ContentSlot(this.nodeContent_2); // 正常显示
    }
  }
}
```
