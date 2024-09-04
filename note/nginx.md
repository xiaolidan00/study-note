```yml
server{
        listen       80;
        server_name  www.guihuajenkins.com;
        location / {
            proxy_pass http://192.168.13.99:8099;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
  
    server{
        listen       80;
        server_name  www.guihuafrontend.com;
        proxy_http_version  1.1;
        # http://www.guihuafrontend.com/vitebaseapi/api/weather/getTemp
        location /vitebaseapi/ {
            proxy_pass http://192.168.20.10:9691/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location /vitebaseimage/ {
            proxy_pass http://192.168.20.10:9586/v1/info/2d/icon/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location /vitegeoapi/ {
            proxy_pass http://192.168.20.10:9573/geoserver/shuilibase/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location /vitebaseterrainurl/ {
            proxy_pass http://192.168.20.10:9512/tomcat/data/terrain/guangdong/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location /configjsonurl/ {
            proxy_pass http://192.168.20.10:9697/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        location / {
            proxy_pass http://192.168.13.99:5501;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

    }
```
