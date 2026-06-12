# 使用ffmpeg和ffprobe

安装这两个包，然后将里面的exe执行文件复制到文件目录下

```sh
 "@ffmpeg-installer/ffmpeg": "^1.1.0",
    "@ffprobe-installer/ffprobe": "^2.1.2",
```

# electron+ffmpeg+express

```js
const {app, BrowserWindow} = require('electron');
const path = require('path');
const express = require('express');
const {spawn} = require('child_process'); // 引入 spawn

let mainWindow;
let videoServer;
const SERVER_PORT = 3000;

// 启动 Express 服务器
function startVideoServer() {
  const serverApp = express();

  serverApp.get('/stream/*', (req, res) => {
    const requestedPath = req.params[0];
    console.log(`Received request for: ${requestedPath}`);

    // --- 安全警告 ---
    // 与之前一样，此处的路径需要严格校验！
    // -----------------
    const videoFilePath = path.resolve(requestedPath);
    console.log(`Streaming file: ${videoFilePath}`);

    // 设置响应头
    res.setHeader('Content-Type', 'video/mp4'); // 根据输出格式调整
    res.setHeader('Access-Control-Allow-Origin', '*'); // 如有必要
    res.setHeader('Transfer-Encoding', 'chunked');

    let ffmpegProcess;

    try {
      // 构建 ffmpeg 命令参数数组
      // -i 指定输入文件
      // -c:v libx264 指定视频编码器为 H.264
      // -preset ultrafast (可选) 提高编码速度，牺牲部分压缩率
      // -crf 23 (可选) 控制质量，值越小质量越高
      // -c:a aac 指定音频编码器为 AAC
      // -f mp4 指定输出格式为 MP4
      // -movflags +frag_keyframe+empty_moov (可选) 对于流式传输可能有用
      // 'pipe:1' 表示将输出写入 stdout
      const ffmpegArgs = [
        '-i',
        videoFilePath,
        '-c:v',
        'libx264',
        // '-preset', 'ultrafast', // 可选：加快编码速度
        // '-crf', '23',           // 可选：控制质量
        '-c:a',
        'aac',
        '-f',
        'mp4',
        // '-movflags', '+frag_keyframe+empty_moov', // 可选：优化流式播放
        'pipe:1'
      ];

      console.log(`Spawning FFmpeg with args: ffmpeg ${ffmpegArgs.join(' ')}`);

      // 使用 spawn 启动 ffmpeg 子进程
      // stdio: ['pipe', 'pipe', 'pipe'] 分别代表 stdin, stdout, stderr
      ffmpegProcess = spawn('ffmpeg', ffmpegArgs, {
        stdio: ['pipe', 'pipe', 'pipe'] // 确保 stdout 和 stderr 是管道
      });

      // 将 ffmpeg 的 stdout (即转码后的视频流) 管道到 HTTP 响应
      ffmpegProcess.stdout.pipe(res);

      // 监听 ffmpeg 的 stderr，打印日志或错误信息
      ffmpegProcess.stderr.on('data', (data) => {
        console.error(`FFmpeg stderr: ${data}`);
      });

      // 监听 ffmpeg 进程退出
      ffmpegProcess.on('close', (code, signal) => {
        console.log(`FFmpeg process exited with code ${code} and signal ${signal}`);
        // 如果进程因错误而退出，可以在这里处理
        if (code !== 0 && !res.headersSent) {
          // 如果响应尚未开始发送，则发送错误
          res.status(500).send(`FFmpeg process exited with code ${code}`);
        }
        // HTTP 响应流会在 ffmpegProcess.stdout.pipe(res) 完成后自动关闭
        // 如果需要手动中断，可以调用 res.end()
      });

      // 监听 HTTP 请求关闭，此时也应终止 ffmpeg 进程以节省资源
      req.on('close', () => {
        console.log('Client disconnected, killing FFmpeg process...');
        if (ffmpegProcess && !ffmpegProcess.killed) {
          ffmpegProcess.kill(); // 发送 SIGTERM 信号
        }
      });

      // 监听 HTTP 请求错误
      req.on('aborted', () => {
        console.log('Client request aborted, killing FFmpeg process...');
        if (ffmpegProcess && !ffmpegProcess.killed) {
          ffmpegProcess.kill();
        }
      });
    } catch (error) {
      console.error('Error spawning FFmpeg:', error);
      if (!res.headersSent) {
        res.status(500).send('Error starting FFmpeg process');
      }
      // 如果进程已经启动但出错，也要确保清理
      if (ffmpegProcess && !ffmpegProcess.killed) {
        ffmpegProcess.kill();
      }
    }
  });

  videoServer = serverApp.listen(SERVER_PORT, () => {
    console.log(`Video streaming server running on port ${SERVER_PORT}`);
  });

  videoServer.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.error(`Port ${SERVER_PORT} is already in use.`);
      app.quit();
    }
  });
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
      // preload: path.join(__dirname, 'preload.js')
    }
  });

  mainWindow.loadFile('index.html');
}

app.whenReady().then(() => {
  startVideoServer();
  createWindow();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

app.on('before-quit', () => {
  if (videoServer) {
    videoServer.close(() => {
      console.log('Video streaming server closed.');
    });
    // 注意：这里没有全局的 ffmpegProcess 变量来清理，
    // 实际应用中最好将进程管理封装起来
  }
});
```

# electron+stream视频流

用于浏览器可直接播放的视频

```ts
const getRange = async (filePath: string, rangeHeader: string | null) => {
  const {size} = await fs.promises.stat(filePath);
  let start = 0,
    end = size - 1;
  if (rangeHeader) {
    const match = rangeHeader.match(/bytes=(\d*)-(\d*)/);
    if (match) {
      start = match[1] ? parseInt(match[1], 10) : start;
      end = match[2] ? parseInt(match[2], 10) : end;
    }
  }
  const chunkSize = (end || size - 1) - start + 1;

  return {start, end, chunkSize, size};
};

const rangeHeader = req.headers.get('Range');

const {start, end, chunkSize, size} = await getRange(filePath, rangeHeader);
closeStream();
videoStream = fs.createReadStream(filePath, {start, end});
videoStream.on('error', (error) => {
  closeStream();
  console.log('error', error);
});

return new Response(videoStream as any, {
  status: rangeHeader ? 206 : 200,
  headers: {
    'Content-Range': `bytes ${start}-${end || size - 1}/${size}`,
    'Accept-Ranges': 'bytes',
    'Content-Length': chunkSize.toString(),
    'Content-Type': 'video/mp4',
    ...corsHeaders
  }
});
```

# hls视频流服务

```js
'use strict';
import {createServer} from 'node:http';
import {readFile, readdir, unlink, mkdir, access} from 'node:fs/promises';
import {existsSync} from 'node:fs';
import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import path from 'node:path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ffmpeg = path.join(__dirname, 'ffmpeg.exe');
const input = path.join(__dirname, 'input.mp4');
const outDir = path.join(__dirname, 'hls');
const m3u8Path = path.join(outDir, 'playlist.m3u8');
const PORT = 3000;

async function ensureHls() {
  if (!existsSync(input)) {
    console.error(`input file not found: ${input}`);
    process.exit(1);
  }
  if (existsSync(outDir)) {
    const files = await readdir(outDir);
    await Promise.all(files.map((f) => unlink(path.join(outDir, f))));
  }
  await mkdir(outDir, {recursive: true});
  return new Promise((resolve, reject) => {
    const args = [
      '-i',
      input,
      '-c:v',
      'libx264',
      '-preset',
      'veryfast',
      '-c:a',
      'aac',
      '-f',
      'hls',
      '-hls_time',
      '10',
      '-hls_list_size',
      '0',
      '-hls_segment_filename',
      path.join(outDir, 'seg%d.ts'),
      m3u8Path
    ];
    const proc = spawn(ffmpeg, args, {stdio: ['ignore', 'pipe', 'pipe']});
    let buf = '';
    proc.stderr.on('data', (d) => {
      buf += d;
    });
    proc.on('close', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`ffmpeg exited ${code}\n${buf}`));
    });
    proc.on('error', reject);
  });
}

const server = createServer(async (req, res) => {
  const u = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const p = u.pathname;

  if (p === '/m3u8') {
    try {
      const content = await readFile(m3u8Path, 'utf-8');
      const modified = content.replace(/seg(\d+)\.ts/g, '/video/$1');
      res.writeHead(200, {'Content-Type': 'application/vnd.apple.mpegurl'});
      res.end(modified);
    } catch {
      res.writeHead(500);
      res.end('Internal error');
    }
    return;
  }

  const m = p.match(/^\/video\/(\d+)$/);
  if (m) {
    try {
      const data = await readFile(path.join(outDir, `seg${m[1]}.ts`));
      res.writeHead(200, {'Content-Type': 'video/MP2T'});
      res.end(data);
    } catch {
      res.writeHead(404);
      res.end('Segment not found');
    }
    return;
  }

  res.writeHead(404);
  res.end('Not found');
});

ensureHls()
  .then(() => {
    server.listen(PORT, () => console.log(`HLS ready at http://localhost:${PORT}/m3u8`));
  })
  .catch((e) => {
    console.error('HLS generation failed:', e.message);
    process.exit(1);
  });
```

# 获取视频分片

```ts
function getVideoSegment(index: string) {
  if (segmentCache.has(index)) return Promise.resolve(segmentCache.get(index));
  if (inflight.has(index)) return inflight.get(index);
  const p = new Promise<any>(async (resolve, reject) => {
    const filePath = videoManager.filePath;
    const frame = videoManager.getFrame(index);

    if (frame) {
      const start = frame[0];
      const time = frame[1];
      const tempFile = path.join(hlsPath, index + '.ts');
      const args: string[] = [
        '-y',
        '-i',
        filePath,
        '-threads',
        '2',
        '-max_muxing_queue_size',
        '1024',
        '-ss',
        start.toString(),
        '-t',
        time.toString(),
        '-c:v',
        'libx264',
        '-preset',
        'veryfast',
        '-c:a',
        'aac',
        '-f',
        'mpegts',
        'pipe:1'
      ];
      try {
        const cmd = `${ffmpegPath} ${args.join(' ')}`;
        console.log('cmd', cmd);
        const buf = await runCMDBuffer(ffmpegPath, args);

        if (buf) {
          segmentCache.set(index, buf);
          inflight.delete(index);
          resolve(
            new Response(buf as any, {
              status: 200,
              headers: {'Content-Type': 'video/mp2t', ...corsHeaders}
            })
          );
        } else {
          mainConsole('no data' + index);
          reject('no data');
        }
      } catch (err) {
        inflight.delete(index);
        reject(err);
      }

      // const buf = await runCMDBuffer(
      //   ffmpegPath,
      //   args,
      //   (buf: any) => {
      //     console.log(buf);
      //     segmentCache.set(index, buf);
      //     inflight.delete(index);
      //   },
      //   (err: any) => {
      //     inflight.delete(index);
      //     reject(err);
      //   }
      // );
    }
  });
  inflight.set(index, p);
  return p;
}
```

# 转成hls视频分片

```ts
const splitVideo = (filePath: string) => {
  return new Promise((resolve, reject) => {
    const files = fs.readdirSync(hlsPath);
    for (let i = 0; i < files.length; i++) {
      fs.unlinkSync(path.join(hlsPath, files[i]));
    }

    exec(
      `${ffmpegPath} -i ${filePath} -c:v libx264 -c:a aac -strict -2 -f hls -hls_time 10 -hls_list_size 0 -hls_segment_filename "${path.join(hlsPath, 'seg%d.ts')}" ${m3u8File}`,
      (error, stdout, stderr) => {
        if (error) {
          console.error(`命令执行出错: ${error}`);
          reject(error);
          return;
        }
        resolve('');
      }
    );
  });
};
```

# 视频信息

```ts
export const getVideoInfo = async (filePath: string) => {
  const args = [
    '-v',
    'quiet', // 设置日志级别为静默，只输出 -show_... 请求的数据
    '-print_format',
    'json', // 输出格式为 JSON
    '-show_format', // 显示格式信息 (如总时长、文件大小、格式名称等)
    '-show_streams', // 显示所有流的信息 (视频流、音频流、字幕流等)
    filePath // 输入文件路径
  ];
  try {
    const data = await runCMDStr(ffprobePath, args);

    const info = JSON.parse(data);
    console.log(info);
    videoManager.setfilePath(filePath);
    videoManager.setInfo(info);
    return info;
  } catch (error) {
    console.log('getVideoInfo', error);
  }
  return '';
};
```

# 视频帧,m3u8

```ts
export const getVideoFrames = (filePath: string, duration: number) => {
  return new Promise(async (resolve, reject) => {
    // const command = `${ffprobePath} -v error -skip_frame nokey -select_streams v:0 -show_entries frame=pts_time,key_frame -of csv=p=0 ${filePath}`;
    const data = await runCMDStr(ffprobePath, [
      '-v',
      'error',
      '-skip_frame',
      'nokey',
      '-select_streams',
      'v:0',
      '-show_entries',
      'frame=pts_time,key_frame',
      '-of',
      'csv=p=0',
      filePath
    ]);
    // stdout 就是经过 grep 过滤后，包含 ",1" 的关键帧数据
    const keyFrames = data.trim().split('\n');
    const result: Array<[number, number]> = [];

    const m3u8List: string[] = [];

    let start = 0;
    let max = 0;

    keyFrames.forEach((item: string, i: number) => {
      const s = item.split(',');
      const f = Number(s[1]);
      const time = f - start;
      result.push([start, time]);
      m3u8List.push(`#EXTINF:${time},`);
      m3u8List.push(`media://video?file=${filePath}&index=${i}`);
      start = f;
      max = Math.max(max, time);
    });
    const last = duration - start;
    max = Math.max(max, last);
    result.push([start, last]);
    m3u8List.push(`#EXTINF:${last},`);
    m3u8List.push(`media://video?file=${filePath}&index=${keyFrames.length}`);
    m3u8List.push('#EXT-X-ENDLIST');

    m3u8List.unshift(
      '#EXTM3U',
      '#EXT-X-VERSION:3',
      '#EXT-X-TARGETDURATION:' + max,
      '#EXT-X-MEDIA-SEQUENCE:0'
      // "#EXT-X-PLAYLIST-TYPE:VOD"
    );
    videoManager.setFrames(result);

    const m3u8content = m3u8List.join('\n') + '\n';
    videoManager.setM3u8Text(m3u8content);
    // mainConsole(m3u8content);

    resolve(result);
  });
};
```

# cmd

```ts
const runCMDBuffer = (cmd: string, args: string[]) => {
  return new Promise<Buffer>((resolve, reject) => {
    const proc = spawn(cmd as string, args, {stdio: ['pipe', 'pipe', 'pipe']});
    const chunks: any[] = [];
    proc.stdout.on('data', (d) => {
      chunks.push(d);
    });
    proc.stdout.on('end', () => {
      const buf = Buffer.concat(chunks);

      proc.kill();
      resolve(buf);
    });
    proc.on('error', (err) => {
      reject(err);
    });
    proc.stderr.on('data', (data: string) => {
      console.error(`stderr: ${data}`);
    });
  });
};
const runExec = (cmd: string) => {
  return new Promise<any>((resolve, reject) => {
    exec(cmd, (error, stdout, stderr) => {
      if (error) {
        // console.log("runExec", error);
        // // console.error(`命令执行出错: ${error}`);
        // reject(error);
        // return;
      }
      resolve(stdout);
    });
  });
};
const runCMDStr = (cmd: string, args: string[]) => {
  return new Promise<string>((resolve, reject) => {
    const proc = spawn(cmd as string, args, {stdio: ['ignore', 'pipe', 'pipe']});
    let chunks = '';
    proc.stdout.on('data', (d) => {
      chunks += d;
    });
    proc.stdout.on('end', () => {
      resolve(chunks);
    });

    proc.on('error', reject);
    // proc.stderr.on("data", () => {});
  });
};
```

# ffmpeg+electron+protocol

```ts
const {app, BrowserWindow, protocol} = require('electron');
const path = require('path');
const {spawn} = require('child_process');
const {Readable} = require('stream');

let mainWindow;

// 注册自定义协议
async function registerCustomProtocol() {
  const scheme = 'myapp';

  try {
    // 确保协议未被注册
    if (protocol.isProtocolRegistered(scheme)) {
      console.warn(`Protocol ${scheme} was already registered.`);
      return;
    }

    // 使用 protocol.handle 注册协议处理器
    // handler 函数接收一个 FetchEvent 对象
    await protocol.handle(scheme, async (request) => {
      const url = new URL(request.url);
      const pathname = decodeURIComponent(url.pathname);

      // --- 安全警告 ---
      // pathname 仍然需要严格校验，防止路径遍历！
      // 例如，检查是否在允许的目录下
      // const allowedDir = path.resolve('./allowed_videos/');
      // const resolvedPath = path.resolve(pathname.substring(1)); // 移除开头的 '/'
      // if (!resolvedPath.startsWith(allowedDir)) {
      //   console.error('Unauthorized path access attempt:', resolvedPath);
      //   return new Response(null, { status: 403, statusText: 'Forbidden' });
      // }
      // -----------------

      // 假设 URL 结构为 myapp://stream/<video_path>
      const pathParts = pathname.split('/');
      if (pathParts.length < 2 || pathParts[1] !== 'stream') {
        console.error('Invalid URL format:', request.url);
        return new Response(null, {status: 400, statusText: 'Bad Request'});
      }

      // 提取视频文件路径 (例如，从第三部分开始)
      const videoPath = pathParts.slice(2).join('/');

      console.log(`Streaming file via protocol: ${videoPath}`);

      // 使用 spawn 启动 ffmpeg 子进程
      const ffmpegArgs = ['-i', videoPath, '-c:v', 'libx264', '-c:a', 'aac', '-f', 'mp4', 'pipe:1'];

      console.log(`Spawning FFmpeg with args: ffmpeg ${ffmpegArgs.join(' ')}`);

      const ffmpegProcess = spawn('ffmpeg', ffmpegArgs, {
        stdio: ['pipe', 'pipe', 'pipe']
      });

      // 将 ffmpeg 的 stdout (Readable Stream) 作为 Response 的 body
      // Node.js 的 Readable Stream 可以被 Web Streams API 消费
      const responseBody = ffmpegProcess.stdout;

      // 创建一个 AbortController 来监听请求的中断
      const controller = new AbortController();
      const signal = controller.signal;

      // 监听 fetch 请求的中断信号 (e.g., 浏览器取消请求)
      request.signal.addEventListener('abort', () => {
        console.log('Fetch request aborted, killing FFmpeg process...');
        if (ffmpegProcess && !ffmpegProcess.killed) {
          ffmpegProcess.kill(); // 发送 SIGTERM
        }
      });

      // 监听 ffmpeg 错误
      ffmpegProcess.stderr.on('data', (data) => {
        console.error(`FFmpeg stderr: ${data.toString()}`);
      });

      ffmpegProcess.on('error', (err) => {
        console.error('Failed to start FFmpeg:', err);
        // 如果进程启动失败，但响应尚未发送，需要处理
        // 但由于我们立即返回了带有流的响应，这里较难处理
        // 更好的方式是在启动前验证文件是否存在
      });

      ffmpegProcess.on('close', (code, signal_code) => {
        console.log(`FFmpeg process exited with code ${code} and signal ${signal_code}`);
        // 流会随 ffmpegProcess.stdout 自动关闭
        // 如果需要在关闭时做些清理，可以在这里添加
      });

      // 返回一个 Response 对象
      // body 是 Node.js Readable Stream
      // headers 设置 Content-Type 等
      return new Response(responseBody, {
        headers: {
          'Content-Type': 'video/mp4' // 根据实际输出格式调整
          // 'Transfer-Encoding': 'chunked', // 通常由 Node.js/浏览器自动处理
        }
        // status: 200, // 默认就是 200
      });
    });

    console.log(`Custom protocol '${scheme}' registered successfully.`);
  } catch (error) {
    console.error('Failed to register custom protocol:', error);
    app.quit(); // 或者采取其他错误处理措施
  }
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
      // preload: path.join(__dirname, 'preload.js') // 如果需要 IPC
    }
  });

  mainWindow.loadFile('index.html');
}

app.whenReady().then(async () => {
  await registerCustomProtocol(); // 等待协议注册完成
  createWindow();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

app.on('before-quit', () => {
  // 注意：这里没有全局的 ffmpegProcess 变量来清理，
  // 实际应用中最好将进程管理封装起来
  // protocol.unhandle('myapp'); // 可选：取消注册
});
```

# ffmpeg+node.js视频推流怎么实现

使用 FFmpeg 结合 Node.js 实现视频推流，通常有两种主流的架构方案。一种是**轻量级的 WebSocket 直连方案**（适合低延迟、小规模场景），另一种是**专业的 RTMP/HTTP-FLV 媒体服务器方案**（适合生产级直播场景）。

以下是这两种方案的详细实现步骤：

### 方案一：WebSocket + FFmpeg 实时流传输（轻量级）

这种方案通过 Node.js 的 `child_process` 模块调用 FFmpeg，将转换后的视频流（如 MPEG-TS 或 MJPEG）直接输出到标准输出（stdout），再通过 WebSocket 推送给前端播放。

#### 1. 后端 (Node.js)

使用 `ws` 库创建 WebSocket 服务，启动 FFmpeg 进程并将数据转发：

```javascript
const {spawn} = require('child_process');
const WebSocket = require('ws');

// 创建 WebSocket 服务器
const wss = new WebSocket.Server({port: 8080});

wss.on('connection', (ws) => {
  console.log('Client connected');

  // 启动 FFmpeg 进程（以抓取桌面为例）
  const ffmpeg = spawn('ffmpeg', [
    '-f',
    'gdigrab',
    '-i',
    'desktop',
    '-f',
    'mpegts',
    '-c:v',
    'libx264',
    '-preset',
    'ultrafast',
    '-tune',
    'zerolatency',
    '-bf',
    '0', // 禁用 B 帧以降低延迟
    '-an', // 禁用音频
    'pipe:1' // 关键：输出到标准输出
  ]);

  // 将 FFmpeg 的输出发送给 WebSocket 客户端
  ffmpeg.stdout.on('data', (data) => {
    if (ws.readyState === ws.OPEN) {
      ws.send(data); // 发送二进制数据
    }
  });

  // 客户端断开时关闭 FFmpeg 进程
  ws.on('close', () => {
    console.log('Client disconnected');
    ffmpeg.kill();
  });
});
console.log('WebSocket server is running on ws://localhost:8080');
```

#### 2. 前端播放

引入 `mpegts.js` 等支持 MSE 的播放器进行解码播放：

```html
<script src="mpegts.js"></script>
<video id="videoPlayer" controls autoplay muted></video>
<script>
  const player = mpegts.createPlayer({
    type: 'mpegts',
    isLive: true,
    url: 'ws://localhost:8080'
  });
  player.attachMediaElement(document.getElementById('videoPlayer'));
  player.load();
  player.play();
</script>
```

---

### 方案二：Node-Media-Server + RTMP/FLV（专业级推荐）

对于正式的直播业务，推荐使用成熟的开源组件 `node-media-server`。它充当流媒体服务器，接收 FFmpeg 的 RTMP 推流，并转换为 HTTP-FLV 供浏览器拉流。

#### 1. 搭建服务端

安装并配置 `node-media-server`：

```bash
npm install node-media-server
```

```javascript
// main.js
const NodeMediaServer = require('node-media-server');
const config = {
  rtmp: {port: 1935, chunk_size: 60000, gop_cache: true, ping: 60},
  http: {port: 8000, allow_origin: '*'}
};
new NodeMediaServer(config).run();
console.log('Server is running...');
```

#### 2. FFmpeg 推流端

你可以将本地文件、摄像头或桌面画面推送到该服务器：

- **推送本地文件**：`ffmpeg -re -i test.mp4 -c copy -f flv rtmp://localhost:1935/live/stream`
- **推送摄像头**：`ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 -preset veryfast -tune zerolatency -f flv rtmp://localhost:1935/live/stream`
- **推送桌面**：`ffmpeg -f gdigrab -i desktop -vcodec libx264 -preset veryfast -tune zerolatency -f flv rtmp://localhost:1935/live/stream`

#### 3. 前端拉流播放

使用 `flv.js` 在网页中无插件播放：

```html
<script src="flv.min.js"></script>
<video id="video" controls autoplay></video>
<script>
  if (flvjs.isSupported()) {
    const player = flvjs.createPlayer({
      type: 'flv',
      isLive: true,
      url: 'http://localhost:8000/live/stream.flv'
    });
    player.attachMediaElement(document.getElementById('video'));
    player.load();
    player.play();
  }
</script>
```

### 💡 核心优化建议

结合你之前的提问，无论采用哪种方案，都建议在 FFmpeg 参数中加入 `-preset ultrafast` 和 `-tune zerolatency`，这能极大降低推流的编码延迟；同时如果条件允许，尽量使用硬件加速（如 `-c:v h264_nvenc`）来减轻 CPU 负担。

# 修复声音画质不同步

使用 FFmpeg 解决视频音画不同步问题，通常需要根据具体的原因采取不同的策略。以下是几种常见且有效的修复方案：

### 1. 诊断与定位问题

在修复之前，首先需要确认音视频的时间戳（PTS）偏差情况。可以使用 `ffprobe` 检查音视频流的起始时间戳：

```bash
ffprobe -show_entries stream=codec_type,start_pts,duration -v quiet INPUT.mp4
```

通过对比音频和视频的 `start_pts` 差值，可以判断音频是超前还是滞后。

### 2. 使用 `-itsoffset` 进行无损偏移（推荐）

如果视频整体音画存在固定的时间差（例如音频超前或滞后），最安全且高效的方法是使用 `-itsoffset` 参数。这种方法不需要对视频进行重新编码（零重编码），可以最大程度保留原始画质。

- **音频滞后（需要音频延后）**：使用正值。例如，将音频整体向后延迟 0.3 秒：
  ```bash
  ffmpeg -itsoffset 0.3 -i input.mp4 -c:v copy -c:a aac output.mp4
  ```
- **音频超前（需要音频提前）**：使用负值。例如，将音频提前 0.125 秒：
  ```bash
  ffmpeg -i INPUT.mp4 -itsoffset -0.125 -i INPUT.mp4 -c:v copy -c:a aac -map 1:v:0 -map 0:a:0 OUTPUT.mp4
  ```

### 3. 修复时间戳（PTS）错乱

如果视频在剪辑、拼接或转码后，时间戳（PTS）本身出现了跳跃、倒退或不连续，可以通过重置时间戳来修复。为了确保音视频保持同步，必须同时对视频和音频的时间戳进行处理：

```bash
ffmpeg -i input.mp4 \
  -vf "setpts=PTS-STARTPTS" \
  -af "asetpts=PTS-STARTPTS" \
  -c:v libx264 -c:a aac output_sync.mp4
```

- `-vf "setpts=PTS-STARTPTS"`：将视频时间戳归零并线性递增。
- `-af "asetpts=PTS-STARTPTS"`：同理处理音频，确保双轨同步起点一致。

### 4. 应对源文件时间轴损坏

如果源视频文件（如录屏、在线下载的流媒体）本身的时间戳存在缺失或错误，后续的所有操作都会基于错误的基础进行。此时可以在命令中加入 `-fflags +genpts` 参数，强制 FFmpeg 重新生成一份干净、连续的时间戳，为后续处理提供可靠的基准：

```bash
ffmpeg -fflags +genpts -i input.mp4 ...
```

### 5. 统一时基与强制重编码

如果是因为硬件加速异步、帧率混用或可变帧率（VFR）导致的累积性不同步，可以尝试强制统一时间基准并重新编码音视频流：

```bash
ffmpeg -i input.mp4 -c:v libx264 -c:a aac -r 25 -ar 48000 -ac 2 -vsync cfr output.mp4
```

通过显式设定固定的视频帧率（`-r`）、音频采样率（`-ar`）以及恒定帧率同步策略（`-vsync cfr`），可以强制对齐音视频的时基。

### 💡 修复后的验证

修复完成后，建议使用 `ffplay` 结合向量示波器进行终极校验，观察音视频轨迹是否稳定收敛：

```bash
ffplay -autoexit -vf "avectorscope,scale=320:240" OUTPUT.mp4
```
