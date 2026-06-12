# 需求

# PDF笔记编辑

- [ ] Ctrl+S保存文档到之前打开的文档路径
- [ ] Ctrl+Z/Y撤销重做
- [ ] Ctrl+C/V，复制内容，粘贴文本或图片到鼠标所在位置
- [ ] Alt+A截图
- [ ] 双击上部分上翻，双击下部分下翻，可设置滚动速度，右下角滚动球
- [ ] Canvas笔触感+添加各种颜色粗细的笔迹，画笔Ctrl+1，荧光笔Ctrl+2,橡皮擦Ctrl+3
- [ ] 缩放比例，自动适配，实际比例
- [ ] 旋转角度
- [ ] 单页双页
- [ ] 添加文本
- [ ] 高亮文本
- [ ] 框选范围
- [ ] 左侧栏目录（增删改，展开收起）
- [ ] 右侧栏标注 (所有笔记的位置，内容概要，勾选增删改)
- [ ] 页数跳转
- [ ] 搜索文本
- [ ] 打印
- [ ] 另存为
- [ ] 全屏
- [ ] OCR图文识别
- [ ] 编辑文本
- [ ] 区域动态显示，到该区域再绘制，优化性能
- [ ] 点击快速，切换笔与橡皮擦
- [ ] electron与web版
- [ ] 鼠标样式自定义
- [ ] 右击菜单快捷键
- [ ] 背景颜色定义

# 参考

`pdf-lib`

# 编辑PDF

在 JavaScript 中读取和编辑 PDF 是两个不同的任务，通常需要借助专门的库来实现。

简单来说：

- **读取/预览 PDF**：主要使用 Mozilla 开发的 **PDF.js** 库。
- **编辑/修改 PDF**：主要使用 **pdf-lib** 库。

下面为你分别介绍这两种场景的实现方法。

### 📖 如何读取和预览 PDF

要在网页中展示 PDF 内容，最成熟和通用的方案是使用 **PDF.js**。它是一个纯 JavaScript 库，可以将 PDF 文档解析并渲染到 HTML5 的 `<canvas>` 元素上，无需依赖任何浏览器插件。

**基本步骤如下：**

1.  **引入库**：通过 npm 安装 (`npm install pdfjs-dist`) 或使用 CDN 链接在页面中引入 `pdf.js` 和 `pdf.worker.js`。
2.  **配置 Worker**：设置 `pdf.worker.js` 的路径，它将负责繁重的解析工作，避免阻塞主线程。
3.  **加载并渲染**：使用 `pdfjsLib.getDocument()` 加载 PDF 文件，然后获取指定页面并渲染到 `<canvas>` 上。

**代码示例：**

```javascript
// 1. 配置 worker 路径 (根据你的项目结构调整)
pdfjsLib.GlobalWorkerOptions.workerSrc = 'path/to/pdf.worker.js';

// 2. 加载 PDF 文档
const loadingTask = pdfjsLib.getDocument('path/to/your/document.pdf');
const pdf = await loadingTask.promise;

// 3. 获取指定页面 (例如第1页)
const page = await pdf.getPage(1);

// 4. 设置渲染视口 (例如缩放比例为1.5)
const viewport = page.getViewport({scale: 1.5});

// 5. 获取 canvas 元素并设置尺寸
const canvas = document.getElementById('pdf-canvas');
const context = canvas.getContext('2d');
canvas.height = viewport.height;
canvas.width = viewport.width;

// 6. 渲染页面
const renderContext = {
  canvasContext: context,
  viewport: viewport
};
await page.render(renderContext).promise;
```

除了渲染，PDF.js 还支持文本提取、搜索、缩放等高级功能。

### ✏️ 如何编辑和修改 PDF

要对现有的 PDF 文件进行修改，例如添加文字、图片、水印或合并拆分页面，推荐使用 **pdf-lib** 库。它可以在浏览器和 Node.js 环境中运行。

**基本步骤如下：**

1.  **加载 PDF**：使用 `PDFDocument.load()` 加载一个已有的 PDF 文件（可以是 `ArrayBuffer`、`Uint8Array` 等格式）。
2.  **执行修改**：调用相应的方法进行修改，如 `addPage()`、`drawText()`、`embedPng()` 等。
3.  **保存文件**：使用 `pdfDoc.save()` 将修改后的 PDF 保存为 `Uint8Array`，然后可以下载或发送到服务器。

**代码示例（向 PDF 添加文字）：**

```javascript
import {PDFDocument} from 'pdf-lib';

// 1. 加载一个已有的 PDF 文件 (这里假设你已经通过 fetch 或文件上传获得了 pdfBytes)
// const pdfBytes = await fetch('path/to/existing.pdf').then(res => res.arrayBuffer());
const pdfDoc = await PDFDocument.load(pdfBytes);

// 2. 获取第一页
const pages = pdfDoc.getPages();
const firstPage = pages[0];

// 3. 在指定位置绘制文字
firstPage.drawText('这是一段用 JavaScript 添加的文字！', {
  x: 100,
  y: 400,
  size: 20
});

// 4. 保存修改后的 PDF
const modifiedPdfBytes = await pdfDoc.save();
// 接下来可以将 modifiedPdfBytes 提供给用户下载
```

### 📝 其他常见方案

除了上述两个核心库，还有一些其他工具可以处理 PDF：

| 功能         | 库/工具             | 适用场景                                                          |
| :----------- | :------------------ | :---------------------------------------------------------------- |
| **生成 PDF** | **jsPDF**           | 在前端从零开始创建简单的 PDF 文档。                               |
| **生成 PDF** | **Puppeteer**       | 在 Node.js 服务端，通过无头浏览器将 HTML 页面高质量地渲染为 PDF。 |
| **生成 PDF** | **PDFKit**          | 在 Node.js 服务端以编程方式创建复杂的 PDF 报告。                  |
| **简单预览** | **`<iframe>` 标签** | 在现代桌面浏览器中快速嵌入 PDF，但移动端和旧版浏览器兼容性差。    |

**总结一下：**

- 如果你的需求是**在网页中展示** PDF，请选择 **PDF.js**。
- 如果你的需求是**修改** PDF 内容（如添加、删除、合并），请选择 **pdf-lib**。
- 如果你的需求是**从零创建** PDF，可以考虑 **jsPDF** (前端) 或 **Puppeteer**/**PDFKit** (后端)。

# 打开PDF保存到原路径

在 Web 端（浏览器环境）实现“打开具体文件 -> 修改 -> 按原路径保存（覆盖）”，核心在于利用 **File System Access API** 获取并持有**文件句柄（File Handle）**。

只要拿到了这个句柄，你就可以在修改后直接写入，从而实现“覆盖原文件”的效果，而不需要用户每次都重新选择路径。

以下是完整的实现逻辑和代码方案：

### 🛠️ 核心原理：持有文件句柄

1.  **打开时**：使用 `window.showOpenFilePicker()` 让用户选择文件。这会返回一个 `FileSystemFileHandle` 对象。
2.  **保存时**：调用该句柄的 `createWritable()` 方法。这会创建一个可写流，写入数据并关闭流后，**原文件就会被新内容覆盖**。

### 💻 代码实现方案

这是一个完整的类封装示例，展示了如何打开、修改（模拟）并保存回原路径。

```javascript
class FileHandler {
  constructor() {
    this.fileHandle = null; // 用于存储文件句柄
    this.fileName = '';
  }

  /**
   * 1. 打开文件（获取句柄）
   */
  async openFile() {
    try {
      // 弹出系统选择框，用户选择文件
      [this.fileHandle] = await window.showOpenFilePicker({
        types: [
          {
            description: 'PDF Files',
            accept: {'application/pdf': ['.pdf']}
          }
        ],
        excludeAcceptAllOption: true,
        multiple: false
      });

      this.fileName = this.fileHandle.name;

      // 请求读写权限（浏览器可能会提示用户授权）
      if ((await this.fileHandle.queryPermission({mode: 'readwrite'})) !== 'granted') {
        await this.fileHandle.requestPermission({mode: 'readwrite'});
      }

      console.log(`✅ 已打开文件: ${this.fileName}`);
      // 这里可以读取文件内容用于编辑
      const file = await this.fileHandle.getFile();
      const contents = await file.arrayBuffer();
      return contents;
    } catch (err) {
      if (err.name === 'AbortError') {
        console.log('用户取消了选择');
      } else {
        console.error('打开文件失败:', err);
      }
      return null;
    }
  }

  /**
   * 2. 保存到原路径（覆盖原文件）
   * @param {Blob|Uint8Array} content - 修改后的文件二进制数据
   */
  async saveToOriginalPath(content) {
    if (!this.fileHandle) {
      alert('请先打开一个文件！');
      return;
    }

    try {
      // 创建可写流
      const writable = await this.fileHandle.createWritable();

      // 写入内容
      await writable.write(content);

      // 关闭流（这一步执行后，磁盘上的原文件就被更新了）
      await writable.close();

      console.log('✅ 文件已成功覆盖保存！');
    } catch (err) {
      console.error('❌ 保存失败:', err);
      // 如果权限丢失，可能需要重新请求
      if (err.name === 'NotAllowedError') {
        await this.fileHandle.requestPermission({mode: 'readwrite'});
      }
    }
  }
}

// --- 使用示例 ---
const handler = new FileHandler();

// 1. 用户点击“打开”按钮
document.getElementById('btn-open').onclick = async () => {
  await handler.openFile();
};

// 2. 用户点击“保存”按钮（假设你已经用 pdf-lib 修改完了数据）
document.getElementById('btn-save').onclick = async () => {
  // 假设这是修改后的 PDF 数据
  const modifiedPdfBlob = new Blob(['模拟的PDF数据'], {type: 'application/pdf'});
  await handler.saveToOriginalPath(modifiedPdfBlob);
};
```

### 🛡️ 兼容性与降级策略

**File System Access API** 目前主要在 **Chrome 86+**、**Edge 86+** 和 **Opera** 中可用。**Firefox** 和 **Safari** 尚未完全支持。

为了保证用户体验，你需要做一个检测：如果浏览器不支持该 API，则降级为“另存为”（下载到默认目录）。

```javascript
async function smartSave(content, defaultName) {
  // 检测是否支持原生文件访问
  if ('showSaveFilePicker' in window) {
    try {
      // 如果有句柄（即之前打开过），理论上可以直接写，
      // 但为了通用性，这里演示使用 showSaveFilePicker 让用户确认位置
      const handle = await window.showSaveFilePicker({
        suggestedName: defaultName,
        types: [{description: 'PDF', accept: {'application/pdf': ['.pdf']}}]
      });
      const writable = await handle.createWritable();
      await writable.write(content);
      await writable.close();
      return true;
    } catch (err) {
      if (err.name === 'AbortError') return false; // 用户取消
    }
  }

  // --- 降级方案：传统下载 ---
  // 在不支持的浏览器中，只能触发下载行为，无法指定具体路径
  const link = document.createElement('a');
  link.href = URL.createObjectURL(content);
  link.download = defaultName;
  link.click();
  alert('当前浏览器不支持直接覆盖原文件，文件已下载到默认文件夹。');
}
```

### ⚠️ 关键注意事项

1.  **用户授权**：浏览器出于安全考虑，**不允许网页静默修改用户硬盘文件**。
    - 第一次打开文件时，浏览器会弹出对话框让用户选择文件。
    - 第一次尝试写入时，浏览器可能会请求“读写权限”，用户必须点击“允许”。
2.  **沙箱限制**：网页只能操作用户明确授权的文件或目录，不能随意访问 `C:` 盘或其他系统目录。
3.  **PDF 编辑配合**：上述代码只负责“文件 IO”。你需要结合 **pdf-lib** 等库生成修改后的 `Blob` 或 `Uint8Array`，然后传给 `saveToOriginalPath` 方法。

# 笔触压感

在 Web 端实现电容笔压感，核心在于使用 **Pointer Events API**。这是目前最标准、兼容性最好的方案，能够统一处理鼠标、触摸和触控笔的输入。

以下是实现压感的完整步骤和关键代码：

### 🎯 核心步骤

1.  **使用 Pointer Events**：监听 `pointerdown`、`pointermove` 和 `pointerup` 事件，而不是传统的 `touch` 或 `mouse` 事件。
2.  **判断设备类型**：通过 `event.pointerType` 属性判断输入源是否为 `'pen'`（触控笔）。
3.  **获取压感数值**：读取 `event.pressure` 属性，该值通常在 `0.0` 到 `1.0` 之间。
4.  **应用压感效果**：根据 `pressure` 值动态调整画笔的粗细、透明度或颜色。

### 💻 代码实现示例

这是一个基于 HTML5 Canvas 的压感绘图核心逻辑：

```javascript
const canvas = document.getElementById('drawing-canvas');
const ctx = canvas.getContext('2d');
let isDrawing = false;
let lastX = 0;
let lastY = 0;

// 1. 防止触摸屏幕时触发默认滚动行为
canvas.style.touchAction = 'none';

canvas.addEventListener('pointerdown', (e) => {
  isDrawing = true;
  [lastX, lastY] = [e.clientX, e.clientY];
});

canvas.addEventListener('pointermove', (e) => {
  if (!isDrawing) return;

  // 2. 判断是否为触控笔
  if (e.pointerType === 'pen') {
    draw(e);
  }
  // 如果也想支持手指或鼠标绘图，可以在这里添加其他逻辑
});

canvas.addEventListener('pointerup', () => {
  isDrawing = false;
});

function draw(e) {
  // 3. 获取压感值 (0.0 - 1.0)
  const pressure = e.pressure;

  // 4. 根据压感动态调整画笔粗细
  // 基础粗细为 2，最大增加 10
  const lineWidth = 2 + pressure * 10;

  ctx.beginPath();
  ctx.moveTo(lastX, lastY);
  ctx.lineTo(e.clientX, e.clientY);

  ctx.strokeStyle = '#000';
  ctx.lineWidth = lineWidth;
  ctx.lineCap = 'round'; // 让线条端点更圆润
  ctx.lineJoin = 'round'; // 让线条拐角更平滑
  ctx.stroke();

  [lastX, lastY] = [e.clientX, e.clientY];
}
```

### ⚠️ 关键注意事项

1.  **硬件与浏览器支持**
    - **硬件**：你的设备和电容笔必须支持压感。普通的被动式电容笔（笔尖是导电橡胶的那种）通常不支持压感，只有主动式电容笔或电磁笔（如 Apple Pencil, S Pen, M-Pencil 等）才支持。
    - **浏览器**：现代浏览器（Chrome, Edge, Firefox, Safari 13+）基本都已支持 Pointer Events。

2.  **压感值的归一化**
    - 虽然 Web 标准将 `pressure` 归一化到 `0.0` - `1.0`，但在某些平台或旧设备上，原始数据范围可能不同（如 Windows Ink 可能是 0-4095）。浏览器通常会帮你处理，但如果发现数据异常，可能需要手动归一化。

3.  **提升流畅度（进阶）**
    - **高频采样**：为了捕捉快速移动时的笔迹，可以使用 `e.getCoalescedEvents()` 方法。它在一次 `pointermove` 事件中包含了多个高频插值点，能让你画出更平滑的线条。
    - **倾斜支持**：通过 `e.tiltX` 和 `e.tiltY` 可以获取笔的倾斜角度，用于实现更高级的笔刷效果（如模拟扁头画笔）。

4.  **CSS 设置**
    - 务必给绘图区域（如 `canvas`）设置 `touch-action: none;`，这可以防止在绘图时触发浏览器的默认行为（如页面滚动或缩放）。

# 抗锯齿

实现笔触的平滑抗锯齿效果，需要从**坐标精度**、**渲染设置**和**绘制算法**三个层面入手。单纯地绘制线条往往会产生锯齿，尤其是在高分屏或斜线绘制时。

以下是实现平滑笔触的完整技术方案：

### 1. 核心基础：像素对齐与坐标修正

Canvas 绘制 1px 宽的线条时，如果坐标是整数（如 `x=100`），线条会跨越两个物理像素，导致浏览器进行模糊处理（抗锯齿），看起来发虚。

**解决方案**：将坐标偏移 `0.5` 个像素，使线条中心对齐物理像素网格。

```javascript
function alignToPixel(x, y) {
  // 四舍五入后 + 0.5，确保线条落在像素中心
  return {
    x: Math.round(x) + 0.5,
    y: Math.round(y) + 0.5
  };
}

// 使用示例
ctx.beginPath();
const pos = alignToPixel(100, 100);
ctx.moveTo(pos.x, pos.y);
ctx.lineTo(pos.x + 100, pos.y);
ctx.lineWidth = 1;
ctx.stroke();
```

### 2. 高清屏适配 (Retina/DPR)

在高分屏（如 MacBook、现代手机）上，CSS 像素与物理像素不一致。如果不处理，画布会被拉伸，导致所有笔触模糊。

**解决方案**：根据 `devicePixelRatio` 放大画布分辨率，并用 CSS 缩放回显示尺寸。

```javascript
const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const dpr = window.devicePixelRatio || 1;

// 1. 获取 CSS 设定的尺寸
const rect = canvas.getBoundingClientRect();

// 2. 将实际分辨率放大 dpr 倍
canvas.width = rect.width * dpr;
canvas.height = rect.height * dpr;

// 3. 缩放绘图上下文，使绘图坐标仍按 CSS 像素计算
ctx.scale(dpr, dpr);

// 4. 开启图像平滑（针对 drawImage）
ctx.imageSmoothingEnabled = true;
ctx.imageSmoothingQuality = 'high';
```

### 3. 算法平滑：贝塞尔曲线插值

手指或笔的移动是高频采样的点，直接连接这些点（`lineTo`）会产生折线感。使用二次贝塞尔曲线（`quadraticCurveTo`）可以让转折处变得圆润。

**原理**：取前一点和当前点的中点作为控制点。

```javascript
function drawSmoothPath(ctx, points) {
  if (points.length < 2) return;

  ctx.beginPath();
  ctx.moveTo(points[0].x, points[0].y);

  for (let i = 1; i < points.length - 1; i++) {
    const p1 = points[i];
    const p2 = points[i + 1];

    // 计算中点作为控制点
    const midPoint = {
      x: (p1.x + p2.x) / 2,
      y: (p1.y + p2.y) / 2
    };

    // 使用二次贝塞尔曲线连接
    ctx.quadraticCurveTo(p1.x, p1.y, midPoint.x, midPoint.y);
  }

  // 连接最后一点
  const lastP = points[points.length - 1];
  ctx.lineTo(lastP.x, lastP.y);
  ctx.stroke();
}
```

### 4. 视觉优化：圆角与压感模拟

为了让笔触看起来像真实的笔，需要设置线条端点和拐角样式，并结合压感（如果设备支持）或速度模拟。

```javascript
// 设置线条样式
ctx.lineCap = 'round'; // 线条末端圆润
ctx.lineJoin = 'round'; // 线条连接处圆润

// 压感或速度模拟逻辑
function getLineWidth(prevPoint, currPoint, pressure) {
  // 如果有原生压感，直接使用
  if (pressure && pressure > 0) {
    return 1 + pressure * 10; // 基础宽度 + 压感变化
  }

  // 否则根据速度模拟：速度快线条细，速度慢线条粗
  const dx = currPoint.x - prevPoint.x;
  const dy = currPoint.y - prevPoint.y;
  const speed = Math.sqrt(dx * dx + dy * dy);

  // 简单的反比映射，限制在 2px 到 10px 之间
  return Math.max(2, Math.min(10, 20 / (speed + 1)));
}
```

### 5. 性能优化：避免抖动与延迟

- **使用 `requestAnimationFrame`**：不要在 `pointermove` 事件中直接绘制，而是收集坐标点，在 `requestAnimationFrame` 中统一绘制。这能保证 60fps 的流畅度并避免主线程阻塞导致的掉帧。
- **OffscreenCanvas**：对于极其复杂的笔触（如带纹理、阴影），可以使用 `OffscreenCanvas` 在后台线程预渲染，再贴到主画布上。

### 📌 总结检查清单

| 优化点       | 关键代码/设置                  | 作用                       |
| :----------- | :----------------------------- | :------------------------- |
| **坐标对齐** | `Math.round(x) + 0.5`          | 消除 1px 线条的模糊虚边    |
| **高清屏**   | `ctx.scale(dpr, dpr)`          | 确保在 Retina 屏上清晰锐利 |
| **路径平滑** | `quadraticCurveTo`             | 消除折线感，使曲线圆润     |
| **端点样式** | `lineCap = 'round'`            | 消除线条两端的平头锯齿     |
| **图像平滑** | `imageSmoothingEnabled = true` | 确保图片缩放时不锯齿       |

通过以上组合拳，你可以实现专业级的平滑绘图体验，效果接近原生应用。
