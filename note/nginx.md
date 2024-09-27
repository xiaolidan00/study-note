```yml
server{
        listen       80;
        server_name  www.myjenkins.com;
        location / {
            proxy_pass http://192.168.1.99:8099;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
  
    server{
        listen       80;
        server_name  www.myfrontend.com;
        proxy_http_version  1.1;
        # http://www.myfrontend.com/vitebaseapi/api/weather/getTemp
        location /vitebaseapi/ {
            proxy_pass http://192.168.1.123:9691/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location /vitebaseimage/ {
            proxy_pass http://192.168.1.123:9586/v1/info/2d/icon/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
         
        location / {
            proxy_pass http://192.168.1.123:5501;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

    }
```

# Nginx配置

<https://mp.weixin.qq.com/s/uOG-fw3AyJiAaiuf0E7wpw>

```ini
user nginx; # nginx进行运行的用户
    error_log /var/log/nginx/error.log; # 错误日志

    http {
        log_format main ...; # nginx日志格式
        access_log /var/log/nginx/access.log main; # 日志位置
        
        # 引入的nginx配置文件，可以将server放在该目录下，方便管理
        include /etc/nginx/conf.d/*.conf; 
        # 一个nginx服务一个server
        server {
            listen 80; # 服务启动的端口
            server_name _; # 服务域名或IP
            root /usr/share/nginx/html; # 服务指向的文件地址
            
            error_page 404 /404.html; # 找不到资源重定向到404页面
            location = /40x.html {};
            
            error_page 500 502 503 504 /50x.html; # 系统错误重定向50x页面
            location = /50x.html {};
        }
        # server {
        #    listen 443; # 支持https协议
        #    server_name _;
        #    root /usr/share/nginx/html;
        #    ...
        # }
        server { 
            listen 80; 
            server_name localhost; 
            root /data/web; 
            index index.html; 
        }

        server { 
            listen 80; 
            server_name localhost; 
            root /data/www/; 
            # history模式增加一行try_files配置，当请求的地址找不到时，重新指向index.html文件
            location / { 
                try_files $uri $uri/ /index.html; 
                index index.html; 
            }
          }

        # 反向代理
        server {
            location /api {
                proxy_pass http://backend1.example.com;
                proxy_set_header Host $host; 
                proxy_set_header X-Real-IP $remote_addr; 
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                }
        }

        # 负载均衡
        upstream api {
            ip_hash;
            server backend1.example.com;
            server backend2.example.com;
        # server backend1.example.com weight=5;
        }
        server {
            location /api {
                proxy_pass http://api;
                proxy_set_header Host $host; 
                proxy_set_header X-Real-IP $remote_addr; 
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            }
        }

        # 配置日志
        log_format  gzip  '$remote_addr - $remote_user [$time_local]  '
            : '"$request" $status $bytes_sent '
            : '"$http_referer" "$http_user_agent" "$gzip_ratio"';

            access_log  /var/logs/nginx-access.log  gzip  buffer=32k;        
     
    }
# 配置Gzip压缩
    http {
        # 开启关闭
        gzip on;
        # 压缩的文件类型
        gzip_types text/plain text/css application/javascript;
        # 过小的文件没必要压缩
        gzip_min_length 1000; # 单位Byte
        gzip_comp_level 5; # 压缩比，默认1，范围时1-9，值越大压缩比最大，但处理最慢，所以设置5左右比较合理。

        # 配置请求头
        underscores_in_headers on;

## 允许客户端上传文件最大不超过1M，在开发上传接口时一定要注意，否则导致上传失败 

## 该字段可以放在`http、server、location`指令模块
        client_max_body_size 1m;


        ### 3、浏览器缓存配置

**缓存也是前端优化的一个重点，合理的缓存可以提高用户访问速度**

该字段可以放在`http、server、location`指令模块

配置浏览器缓存的有三个地方

#### 1）后端服务，配置请求头

后端根据语言不同，配置关键字段即可

#### 2）代理服务器（Nginx）配置缓存请求头

 
location /static {
 # /static匹配到的资源有效期设置为1d;
 expires 1d;  
 # /设置资源有效期为一周;
 # expires max-age=604800; 
 
 # 设置浏览器可以被缓存，设置7天后资源过期
 add_header Cache-Control "public, max-age=604800";
 # 阻止浏览器缓存动态内容
 # add_header Cache-Control "no-cache, no-store, must-revalidate";
 # 禁用浏览器缓存
 # add_header Cache-Control "no-store, private, max-age=0";
    }
```

# 命令

```bash
  # 检查nginx配置文件是否正确，如果错误会提示具体的错误信息
    nginx -t
    # 重新启动nginx服务
    nginx -s reload

    nginx -s stop
    nginx -s start
```

# 在前端资源中通过meta声明缓存信息

```html
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Expires" content="0">
```

# 跨域处理

```ini
server {

    location / {
        # 允许所有来源的跨域请求
        add_header Access-Control-Allow-Origin *;
        
        # 允许特定的HTTP方法（GET、POST等）
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE";

        # 允许特定的HTTP请求头字段
        add_header Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept";

        # 响应预检请求的最大时间
        add_header Access-Control-Max-Age 3600;

        # 允许携带身份凭证（如Cookie）
        add_header Access-Control-Allow-Credentials true;

        # 处理 OPTIONS 预检请求
        if ($request_method = 'OPTIONS') {
            add_header Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE";
            add_header Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept";
            add_header Access-Control-Max-Age 3600;
            add_header Access-Control-Allow-Credentials true;
            add_header Content-Length 0;
            add_header Content-Type text/plain;
            return 204;
        }
    }
}
```
