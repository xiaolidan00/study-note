// 调用 HTTP 模块
const http = require('http');
const axios = require('axios');
const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,HEAD,PUT,PATCH,POST,DELETE'
};
// 创建 HTTP 服务器并监听 8000 端口的所有请求
http
  .createServer((request, response) => {
    const url = request.url.toString();

    if (url.startsWith('/detail')) {
      const id = url.substring(url.lastIndexOf('/') + 1);
      //   console.log(id);

      axios
        .get(`https://fe.ecool.fun/api/exercise/practice/detail?vid=9&exerciseKey=${id}`)
        .then((res) => res.data.data)
        .then((data) => {
          //   console.log(data);
          response.writeHead(200, { 'Content-Type': 'application/json', ...cors });
          response.end(JSON.stringify(data));
        })
        .catch((err) => {
          console.log(err);
          response.writeHead(500, { 'Content-Type': 'application/json', ...cors });
          response.end('{"msg":"err"}');
        });
    } else {
      // 用 HTTP 状态码和内容类型来设定 HTTP 响应头
      response.writeHead(200, { 'Content-Type': 'application/json', ...cors });

      // 发送响应体 "Hello World"
      response.end('{"msg":"Hello World"}');
    }
  })
  .listen(8000);

// 在控制台打印访问服务器的 URL
console.log('服务器运行于 http://127.0.0.1:8000/');
