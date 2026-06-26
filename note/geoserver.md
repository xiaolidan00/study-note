OGC开放地理空间联盟

- WMS
- KML
- GeoTiff

- layer preview预览：对象保护全部Layer及layer Group，含多种展示方法
- workspace逻辑实体：基于特定目的将数据组合成逻辑组合
- store数据连接：连接特定数据路径
- layers图层：单一实际数据配置
- layer groups图层组合：多项数据连结
- styles样式：独立或连结

获取数据信息
`http://<服务器地址>/arcgis/rest/services/<服务名称>/MapServer?f=json`

如果需要token验证
`http://<服务器地址>/arcgis/rest/services/<服务名称>/MapServer?f=json&token=<token>`

动态生成token API，client类型选择`Request IP`
`arcgis/tokens/generateToken`

# leaflet

https://developers.arcgis.com/esri-leaflet/get-started/
https://www.jsdelivr.com/package/npm/esri-leaflet

```js
import * as esri from 'esri-leaflet';
this.pipeLineLayer = esri
  .tiledMapLayer({
    url: 'http://x.x.x.x:x/NewMapServer/arcgis/rest/services/XXXX/XXXX/MapServer/{z}/{y}/{x}',
    token,
    pane: 'overlayPane'
  })
  .addTo(map);

//http://x.x.x.x/arcgis/rest/services/XXXX/XXXX/MapServer/?f=json&token=<token>
this.pipeLineLayer = new L.tileLayer(
  'http://x.x.x.x/arcgis/rest/services/XXXX/XXXX/MapServer/tile/{z}/{y}/{x}?token=' + token,
  {
    tileSize: 256,
    minZoom: 0,
    maxZoom: 12,
    resolutions: [
      264.583862501058, 132.291931250529, 66.1459656252646, 33.0729828126323, 16.9333672000677,
      8.46668360003387, 4.23334180001693, 2.11667090000847, 1.05833545000423, 0.529167725002117,
      0.264583862501058, 0.132291931250529, 0.0661459656252646
    ]
  }
);
```

# GeoServer 教程

https://docs.geoserver.org/main/en/user/gettingstarted/

https://osgeo.cn/geoserver-user-manual/gettingstarted/geopkg-quickstart/index.html

JDK 17
https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html

Geoserver 3.0.0
Tomcat 11.0.x,admin,123456

默认登录账号：用户名 admin，密码 geoserver

### 1. 准备与安装 Java 17

GeoServer 3.0.0 基于 Jakarta EE 和 Spring 7，必须使用较新的 JDK 版本。

- **下载**：前往 Oracle 官网或 Adoptium (Eclipse Temurin) 下载 JDK 17 的安装包。
- **配置环境变量**：
  - 新建系统变量 `JAVA_HOME`，值为 JDK 的安装路径（例如：`C:\Program Files\Java\jdk-17`）。
  - 编辑系统变量 `Path`，添加 `%JAVA_HOME%\bin`。
- **验证**：打开命令行（CMD/Terminal），输入 `java -version`，确认输出为 `17.x.x`。

### 2. 准备与安装 Tomcat 11

Tomcat 11 是运行 GeoServer 3.0.0 的必备容器。

- **下载**：前往 Apache Tomcat 官网，下载 **Tomcat 11.0.x** 版本的 Core 压缩包（如 `zip` 或 `tar.gz`）。
- **解压**：将压缩包解压至一个**不包含中文和空格**的路径下（例如：`D:\Tomcat11`）。
- **配置环境变量**（可选但推荐）：
  - 新建系统变量 `CATALINA_HOME`，值为 Tomcat 的解压路径。

### 3. 部署 GeoServer 3.0.0

将 GeoServer 作为 Web 应用部署到 Tomcat 中。

- **下载**：前往 GeoServer 官方下载页面，获取 **3.0.0** 版本的 **Web Archive (war)** 文件（通常命名为 `geoserver.war`）。
- **部署**：将 `geoserver.war` 文件直接复制到 Tomcat 目录下的 `webapps` 文件夹中。
- **启动服务**：
  - Windows 系统：进入 `Tomcat安装目录\bin`，双击运行 `startup.bat`。
  - Linux/Mac 系统：在终端执行 `./startup.sh`。
- **自动解压**：Tomcat 启动后会自动将 `geoserver.war` 解压为 `geoserver` 文件夹。

### 4. 访问与验证

- 打开浏览器，在地址栏输入：`http://localhost:8080/geoserver`
- 如果看到 GeoServer 的欢迎页面，说明部署成功！
- **默认登录账号**：用户名 `admin`，密码 `geoserver`。

### 💡 常见问题排查提示

- **端口冲突**：如果启动失败，可能是默认的 `8080` 端口被占用。可以修改 `Tomcat安装目录\conf\server.xml` 文件，将 `<Connector port="8080"...>` 中的 `8080` 改为其他端口（如 `8081`）。
- **内存溢出**：GeoServer 处理空间数据较耗内存。建议在 Tomcat 的 `bin` 目录下找到 `setenv.bat` (Windows) 或 `setenv.sh` (Linux)，添加 JVM 内存参数：`set CATALINA_OPTS=-Xms512m -Xmx1024m`。

## 图层预览

http://127.0.0.1:8080/geoserver/web/wicket/bookmarkable/org.geoserver.web.demo.MapPreviewPage?13&filter=false

# geoserver数据地址

`D:\softwares\Tomcat\webapps\geoserver\data`

# 地图瓦片数据

https://www.naturalearthdata.com/downloads/

# 国家地理数据

https://blog.51cto.com/fkxxgis/12824153

https://mulu.tianditu.gov.cn/

# shp数据转换

https://mapshaper.org/

# GeoServer学习路线 github

直接建议：先打牢 GIS 基础（坐标系、投影、矢量/栅格概念、PostGIS），再用 Docker 快速搭建 GeoServer 做端到端练习（发布 shapefile / PostGIS / GeoTIFF 为 WMS/WFS/WMTS），学样式（SLD / CSS）、缓存（GeoWebCache）、REST 自动化，并通过 OpenLayers/Leaflet/QGIS 做可视化与集成。下面给出分步详尽学习路线、周计划、练习与资源。

一、先决知识（必须掌握，节省后续学习时间）

- GIS 基础概念：矢量 vs 栅格、投影/坐标参考系（CRS）、空间索引、属性表、拓扑基础。
- 空间数据格式：Shapefile、GeoJSON、GeoPackage、GeoTIFF、MBTiles。
- 数据库：PostgreSQL + PostGIS（空间类型、空间索引、ST\_ 系列函数）。
- Web 地图基础：瓦片、XYZ、WMS/WFS/WCS/WMTS 的基本区别和用途。  
  学习资源：QGIS 教程、PostGIS 官方文档、Spatial SQL 入门文章。

二、环境搭建（推荐用 Docker 快速开始）

- 推荐方法（快速、可复现）：
  - 安装 Docker/Docker Compose。
  - 拉取 GeoServer 镜像并运行：
    docker run -d -p 8080:8080 --name geoserver -e GEOSERVER_ADMIN_PASSWORD=geoserver osgeo/geoserver
  - 或者用官方二进制安装、Tomcat 部署（用于生产或深入调试）。
- 同时准备 PostGIS 镜像用于练习：
  docker run --name postgis -e POSTGRES_PASSWORD=pass -d postgis/postgis
- 准备测试数据：Natural Earth、OSM 导出数据、自己的 shapefile / GeoTIFF。

三、核心学习模块（按先后顺序）

1. GeoServer 入门（界面与基本概念）
   - 工作区（Workspace）、数据存储（DataStore）、图层（Layer）、样式（Style）。
   - 发布第一个图层：从 shapefile 发布为 WMS。
   - 实验：发起简单的 WMS GetMap 请求（用浏览器/ curl / QGIS）。
2. 矢量服务：WFS / WFS-T
   - WFS GetFeature、事务（WFS-T）概念与权限。
   - 在 GeoServer 中启用 WFS 并用 QGIS/OSM 工具获取要素。
3. 栅格服务：WCS / GeoTIFF 发布
   - 发布 GeoTIFF 为 WCS，理解像素分辨率、金字塔（overview）。
4. 样式与渲染：SLD & GeoServer CSS
   - 学会写 SLD（过滤、符号化、分类、标注）。
   - 尝试 GeoServer CSS 简化样式编写。
   - 使用 SLD 实现专题图（按属性着色）、分类、热力图等。
5. 数据源：PostGIS 深入
   - 在 GeoServer 中配置 PostGIS DataStore，发布 SQL view、参数化查询。
   - 使用空间索引与视图提升性能。
6. 瓦片与缓存：GeoWebCache / WMTS / Tile Caching
   - 理解瓦片切片原理，启用图层缓存，提高 WMS 性能。
7. REST API 与自动化
   - 用 GeoServer REST API（或 python-gsconfig）进行批量发布、样式部署、配置管理。
   - 示例：用 curl 创建 workspace：
     curl -u admin:geoserver -XPOST -H "Content-type: text/xml" -d '<workspace><name=myws</name></workspace>' http://localhost:8080/geoserver/rest/workspaces
8. 性能、扩展与安全
   - 缓存策略、内存/堆配置、启用 gzip、图层分级、瓦片预生成。
   - 身份认证、角色权限、发布私有/公开服务。
9. 高级功能
   - 矢量切片（Vector Tiles）、MBTiles 输出、WMTS 短 URL。
   - GeoServer 扩展（KML、WPS 等）。
   - 集群、反向代理（Nginx）、Docker 部署与 Kubernetes 生产化。

四、渐进式 8 周学习计划（可根据时间拉长或压缩）

- 第1周：GIS 基础、坐标系、安装 Docker、运行 GeoServer、发布第一个 shapefile。目标：理解工作流。
- 第2周：学习 WMS、WFS、WCS 概念与在 GeoServer 中使用；用 QGIS 连接 GeoServer。
- 第3周：PostGIS 基础，导入数据（ogr2ogr / shp2pgsql），在 GeoServer 中发布 PostGIS 图层。
- 第4周：学习 SLD 与 GeoServer CSS，完成专题图、标注与比例尺符号化。
- 第5周：GeoWebCache、瓦片缓存设置、使用 OpenLayers/Leaflet 加载缓存瓦片。
- 第6周：REST API 自动化（curl、python-gsconfig），编写脚本批量发布图层与样式。
- 第7周：性能调优（内存、线程、数据库视图与索引）、安全设置（角色、认证）。
- 第8周：完整项目（例如：基于 PostGIS 的城市地理信息发布+前端地图应用），部署到 Docker Compose 或云环境。

五、实战练习清单（每条都要能动手完成）

- 将 Natural Earth shapefile 发布为 WMS，并在 Leaflet 中显示。
- 用 PostGIS 存储点/路网数据，发布为 WFS，使用 WFS-T 更新要素。
- 为栅格 DEM 数据生成金字塔并发布为 WCS/WMS，绘制坡度或阴影。
- 写 3 个不同复杂度的 SLD：单一符号、基于属性分类、按比例尺分级显示。
- 用 GeoWebCache 预生成某个图层的瓦片，并通过 OpenLayers 直接加载 WMTS。
- 使用 GeoServer REST API 批量创建 5 个 workspace 与图层（脚本化）。
- 性能评估：比较启用/不启用缓存时同一请求的响应时间。

六、进阶与生产化注意事项

- 备份 GeoServer 数据目录（styles、workspaces、security），版本化管理样式（在 Git 中保存 SLD/CSS）。
- 使用 Dockerfile 或 Helm chart 管理部署；在 CI/CD 中用 REST API 自动部署样式与图层。
- 监控：JVM heap、响应时间、瓦片命中率（GeoWebCache），使用 Prometheus + Grafana。
- 安全：启用 HTTPS、细粒度权限、限制匿名 WFS 写操作。
- 横向扩展：把 GeoServer 放在负载均衡/只读副本后面，数据层用强大的 PostGIS 主从复制/读写分离。

七、推荐书籍与资源

- 官方文档：GeoServer User Manual — https://geoserver.org/ (中文版可找社区翻译)。
- GeoServer REST API docs — https://docs.geoserver.org/latest/en/user/rest/
- 入门书籍：GeoServer Beginner’s Guide / GeoServer Cookbook（任选一本做系统性学习）。
- PostGIS：PostGIS 官方文档、PostGIS in Action（书）。
- 前端：OpenLayers 官方文档（https://openlayers.org/）、Leaflet（https://leafletjs.com/）。
- 教程/视频：B站搜索 “GeoServer 教程”、慕课网相关课程；GIS StackExchange 与 GIS 博客大量实战问题解答。
- 示例数据：Natural Earth（https://www.naturalearthdata.com/）、OpenStreetMap extracts、USGS DEM。

八、常见坑与建议

- 投影问题最容易出错：发布前确认数据 CRS，GeoServer 可做 reproject，但最好数据预处理好。
- Shapefile 字段名限制与编码问题（中文属性需注意编码）。
- 不要把所有复杂渲染放在 GeoServer SLD 中做重计算，复杂空间运算交给 PostGIS 做好后再发布。
- 生产环境内存与 JVM 参数必调优（Xmx/Xms），默认内存常不足。
- 样式与配置要版本化（用 Git），避免直接在界面长期编辑未备份。

九、如何测评进度（里程碑）

- 能独立部署 GeoServer 并发布至少 5 个不同类型的图层（shapefile、PostGIS、GeoTIFF）。
- 能写 SLD 实现专题渲染并通过 OpenLayers 展示。
- 能使用 REST API 自动化发布与备份配置。
- 能进行基本性能调优并启用瓦片缓存。

如果你愿意，我可以：

- 帮你生成一个可运行的 Docker Compose 配置（GeoServer + PostGIS + 示例数据）并给出一步步命令；或者
- 根据你每天/每周可投入时间，给出一个更精细的日程表与练习任务清单。

你想先要哪个？我可以立刻生成 Docker Compose 文件和快速入门脚本。

# GeoServer学习路径 千问

学习 GeoServer 需要循序渐进，从基础的地图服务发布到高级的性能优化，再到二次开发。以下为您整理的详细学习路线：

### 阶段一：GIS 基础与前置知识准备

在正式接触 GeoServer 之前，需要掌握一定的 GIS 基础和 Web 基础知识，这有助于更好地理解 GeoServer 的工作机制。

- **GIS 数据基础**：了解矢量数据（点、线、面）与栅格数据（影像、地形）的区别；熟悉常见的坐标系（如 WGS84、GCJ02、CGCS2000）以及数据格式（如 Shapefile、GeoJSON、Tile 等）。
- **Web 基础**：了解 HTTP 协议、RESTful 接口概念以及 GET/POST 请求方式，这为后续使用 GeoServer 的 REST API 打下基础。

### 阶段二：GeoServer 核心入门

这一阶段主要目标是能够独立搭建环境并发布基础的地图服务。

- **环境搭建**：学习安装 Java 运行环境（JDK 8+）和 Apache Tomcat，并成功安装与启动 GeoServer。
- **核心概念与界面**：熟悉 GeoServer 的管理界面，理解工作空间（Workspace）、数据存储（Data Store）、图层（Layer）等核心概念。
- **数据发布**：从最简单的 Shapefile 数据开始，学习创建工作空间、添加数据存储，并最终发布 WMS（Web 地图服务）和 WFS（Web 要素服务）。
- **服务预览与测试**：使用 GeoServer 内置的 Layer Preview 功能预览地图，检查坐标系、数据边界和样式是否正确。

### 阶段三：样式定制与数据管理进阶

掌握地图的美化以及更复杂的数据源接入。

- **地图样式定制**：学习 SLD（Styled Layer Descriptor）和 CSS 样式方案，掌握点、线、面符号的配置，以及添加标注、专题制图和图层合并等高级样式设置。
- **空间数据库接入**：学习配置 PostGIS 等空间数据库作为数据存储源，掌握在 PostGIS 中加载数据并在 GeoServer 中发布的完整流程。
- **桌面端辅助工具**：学习使用 QGIS 进行数据编辑、格式转换和配图，并将 QGIS 中配置好的样式导出到 GeoServer 中使用。

### 阶段四：性能优化与安全配置

面向实际生产环境，提升服务的稳定性和安全性。

- **性能与缓存**：深入理解地图瓦片（Tile）原理，学习使用 GeoWebCache 进行切片缓存配置，掌握网格集和瓦片层的设置，以提升地图加载速度。
- **安全管理**：学习 GeoServer 的安全配置，包括设置基本安全策略、定义用户/组/角色，以及对数据和访问服务进行权限控制。
- **生产环境调整**：学习如何调整 Java 参数、删除未使用的服务、设置代理以及避免服务故障，确保 GeoServer 在生产环境中的稳定运行。

### 阶段五：自动化、高级特性与二次开发

满足企业级复杂需求，具备定制开发和运维能力。

- **REST API 自动化**：学习使用 GeoServer REST 接口，通过代码自动化管理数据、数据存储和要素类型，实现批量发布等自动化任务。
- **高级服务与三维支持**：学习发布 WFS-T（支持数据编辑的 WFS）、WMTS 服务，以及通过自定义插件支持发布 3D Tiles 和 Cesium 地形（Terrain）服务。
- **集群部署与源码研究**：了解 Nginx 集群配置方案，构建高可用的生产级 GeoServer 集群。如有深度定制需求，可进一步学习 GeoServer 源码，了解断点调试、内存溢出处理及自定义插件开发。

### 💡 学习资源推荐

- **系统教程**：推荐参考《GeoServer 入门与实践》官方文档，或《WebGIS开发从入门到实践》等系统性书籍。
- **实战指南**：可以查阅“GeoServer Cookbook”等保姆级教程，这类教程通常包含大量截图、实战配置示例和常见问题处理方案，非常适合上手。
- **快速体验**：对于初学者，也可以尝试使用 InsCode 等在线平台一键部署 GeoServer，免去本地搭建环境的繁琐，直接在线体验各项功能。

---

需要我帮你整理一份 GeoServer 核心概念（工作空间、数据存储、图层、样式）的速查表吗？学的时候随时对照着看。
