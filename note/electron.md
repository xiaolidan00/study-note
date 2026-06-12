# electron

https://vite.electron.js.cn/guide/getting-started.html

## 快速创建项目

```sh
npm create vite@latest my-electron-vite-project
```

# 标题栏样式

在 Electron 中，你可以通过在创建 `BrowserWindow` 时配置不同的参数来设置标题栏样式。以下是几种常见的实现方式：

### 1. 隐藏默认标题栏并保留原生控件（推荐）

这是最常用的自定义标题栏方案。通过设置 `titleBarStyle: 'hidden'`，可以隐藏默认的标题栏，让网页内容占据完整尺寸，同时保留系统的窗口控制按钮。

**跨平台兼容代码示例：**

```javascript
const {app, BrowserWindow} = require('electron');

function createWindow() {
  const win = new BrowserWindow({
    titleBarStyle: 'hidden', // 隐藏默认标题栏
    // 针对 Windows 和 Linux，添加原生的窗口控制覆盖层
    ...(process.platform !== 'darwin' ? {titleBarOverlay: true} : {})
  });
  win.loadFile('index.html');
}

app.whenReady().then(() => {
  createWindow();
});
```

_注：在 macOS 上，此设置会保留左上角的“红绿灯”控件；而在 Windows/Linux 上，配合 `titleBarOverlay: true` 可将窗口控件添加回窗口顶部。_

### 2. 完全移除系统标题栏（无边框模式）

如果你希望彻底抛弃原生标题栏，完全使用 HTML/CSS 自己设计一套包含最小化、最大化、关闭等按钮的标题栏，可以将 `frame` 设置为 `false`：

```javascript
const mainWindow = new BrowserWindow({
  frame: false, // 去掉整个系统操作栏
  webPreferences: {
    preload: path.join(__dirname, 'preload.js')
  }
});
```

### 3. macOS 专属的标题栏微调

Electron 为 macOS 提供了一些额外的标题栏样式选项，用于更精细地控制“红绿灯”按钮的外观与位置：

- **`hiddenInset`**：隐藏标题栏，并将交通灯按钮稍微向内缩进。
- **`customButtonsOnHover`**：隐藏标题栏，仅当鼠标悬停在窗口左上角时才显示交通灯按钮。
- **自定义红绿灯位置**：通过传入坐标对象来精确调整位置。

```javascript
const win = new BrowserWindow({
  titleBarStyle: 'hidden',
  trafficLightPosition: {x: 10, y: 10} // 自定义交通灯位置
});
```

### 💡 关键补充：实现可拖拽区域

当你隐藏了默认标题栏后，应用窗口将无法被拖动。你需要在渲染进程（HTML/CSS）中指定一个区域作为拖拽区。只需给该区域的元素添加以下 CSS 属性即可：

```css
.custom-titlebar {
  -webkit-app-region: drag; /* 允许拖拽移动窗口 */
  user-select: none; /* 避免标题栏文字被选中 */
}
```

对于自定义标题栏中的交互按钮（如关闭、最小化按钮），需要单独取消拖拽属性以恢复点击功能：

```css
.btn-item {
  -webkit-app-region: no-drag; /* 取消拖拽，使按钮可点击 */
  cursor: pointer;
}
```

# 升级版本

在 Electron + Vite 项目中实现版本自动升级，业界最成熟且常用的方案是结合 `electron-updater` 和 `electron-builder`。以下是完整的实现流程，分为依赖安装、主进程逻辑、预加载脚本、渲染进程 UI 以及打包发布五个核心步骤：

### 1. 安装核心依赖

首先需要在项目中安装自动更新和日志记录相关的插件：

```bash
npm install electron-updater electron-log
```

### 2. 配置主进程 (Main Process)

在主进程中初始化 `autoUpdater`，处理更新事件并通过 IPC 与渲染进程通信。建议将更新逻辑抽离到独立文件（如 `updater.ts`）：

```typescript
// src/main/updater.ts
import {autoUpdater} from 'electron-updater';
import {BrowserWindow, ipcMain} from 'electron';
import log from 'electron-log';

export function setupAutoUpdater(mainWindow: BrowserWindow) {
  // 配置日志
  log.transports.file.level = 'info';
  autoUpdater.logger = log;
  // 关闭自动下载，由用户手动触发
  autoUpdater.autoDownload = false;

  // 检查更新
  autoUpdater.checkForUpdates();

  // 发现新版本
  autoUpdater.on('update-available', (info) => {
    mainWindow.webContents.send('update-available', info);
  });

  // 下载进度
  autoUpdater.on('download-progress', (progressObj) => {
    mainWindow.webContents.send('download-progress', progressObj);
  });

  // 下载完成
  autoUpdater.on('update-downloaded', (info) => {
    mainWindow.webContents.send('update-downloaded', info);
  });

  // 监听渲染进程发来的指令
  ipcMain.on('start-download', () => autoUpdater.downloadUpdate());
  ipcMain.on('install-update', () => autoUpdater.quitAndInstall());
}
```

### 3. 配置预加载脚本 (Preload)

为了安全，需要通过 `contextBridge` 暴露安全的 API 给渲染进程使用：

```typescript
// electron/preload/index.ts
import {contextBridge, ipcRenderer} from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
  checkUpdate: () => ipcRenderer.send('check-update'),
  startDownload: () => ipcRenderer.send('start-download'),
  installUpdate: () => ipcRenderer.send('install-update'),
  onUpdateAvailable: (cb) => ipcRenderer.on('update-available', cb),
  onDownloadProgress: (cb) => ipcRenderer.on('download-progress', cb),
  onUpdateDownloaded: (cb) => ipcRenderer.on('update-downloaded', cb)
});
```

### 4. 渲染进程 UI 交互 (Vue3 示例)

在 Vue 页面中监听更新状态，展示下载进度并提供安装按钮：

```vue
<script setup>
import {ref, onMounted} from 'vue';

const isDownloading = ref(false);
const progress = ref(0);

onMounted(() => {
  // 监听新版本可用
  window.electronAPI?.onUpdateAvailable((_event, info) => {
    if (confirm(`检测到新版本 ${info.version}，是否立即下载？`)) {
      isDownloading.value = true;
      window.electronAPI?.startDownload();
    }
  });

  // 监听下载进度
  window.electronAPI?.onDownloadProgress((_event, progressObj) => {
    progress.value = Math.floor(progressObj.percent);
  });

  // 监听下载完成
  window.electronAPI?.onUpdateDownloaded(() => {
    isDownloading.value = false;
    if (confirm('更新已下载完成，是否立即安装并重启？')) {
      window.electronAPI?.installUpdate();
    }
  });
});
</script>

<template>
  <div v-if="isDownloading">
    <p>正在下载更新... {{ progress }}%</p>
    <!-- 这里可以接入如 Element Plus 的进度条组件 -->
  </div>
</template>
```

### 5. 打包与发布配置

在 `package.json` 中配置 `electron-builder` 的发布规则。这里以发布到自建服务器（generic）或 GitHub 为例：

```json
"build": {
  "appId": "com.yourcompany.yourapp",
  "productName": "Your App",
  "publish": {
    "provider": "generic",
    "url": "http://your-server.com/updates/"
  },
  "win": {
    "target": "nsis"
  }
}
```

**发布注意事项：**

- **全量更新**：打包后，将生成的安装包（如 `Your App Setup 1.0.0.exe`）和 `latest.yml` 文件上传至你配置的 `publish.url` 目录下。
- **增量更新**：如果希望支持增量更新（基于 `.blockmap` 差分下载），需要在 `package.json` 中配置 `"nsis": { "differentialPackage": true }`，并且**必须**将生成的 `.blockmap` 文件一并上传到服务器。

按照以上流程，即可在 Electron + Vite 项目中实现一套完整的版本自动升级闭环。
