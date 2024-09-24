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
