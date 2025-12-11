# 爬取网页

https://cloud.tencent.com/developer/article/2527648

```sh
pip install requests beautifulsoup4 lxml
```

```python
# file: simple_spider.py

import requests
from bs4 import BeautifulSoup
from pyquery import PyQuery as pq

def fetch_title(url):
    try:
        # 1. 发送 GET 请求
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) ...'
        }
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()  # 如果状态码不是 200，引发 HTTPError

        # 2. 设置正确的编码
        response.encoding = response.apparent_encoding

        # 3. 解析 HTML
        soup = BeautifulSoup(response.text, 'lxml')

        # 4. 提取 <title> 标签内容
        title_tag = soup.find('title')
        if title_tag:
            return title_tag.get_text().strip()
        else:
            return '未找到 title 标签'
    except Exception as e:
        return f'抓取失败：{e}'

if __name__ == '__main__':
    url = 'https://www.xiaolidan00.top/?markdown=%2Fprojects%2FpointLine%2Findex.html'
    title = fetch_title(url)
    print(f'网页标题：{title}')
```

## soup

**查找单个节点**

- `soup.find(tag_name, attrs={}, recursive=True, text=None, **kwargs)`
- 示例：`soup.find('div', class_='content')`
- 可以使用 `attrs={'class': 'foo', 'id': 'bar'}` 精确定位。

**查找所有节点**

- `soup.find_all(tag_name, attrs={}, limit=None, **kwargs)`
- 示例：`soup.find_all('a', href=True)` 返回所有带 `href` 的链接。

**CSS 选择器**

- `soup.select('div.content > ul li a')`，返回列表。
- 支持 id（`#id`）、class（`.class`）、属性（`[attr=value]`）等。

**获取属性或文本**

- `node.get('href')`：拿属性值；
- `node['href']`：同上，但如果属性不存在会抛异常；
- `node.get_text(strip=True)`：获取节点文本，并去除前后空白；
- `node.text`：获取节点及子节点合并文本。

**常用属性**

- `soup.title` / `soup.title.string` / `soup.title.text`
- `soup.body` / `soup.head` / `soup.a` / `soup.div` 等快捷属性。

## Pip 更换镜像

https://blog.csdn.net/weixin_43360896/article/details/113529960

阿里云 http://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
豆瓣 http://pypi.douban.com/simple/
清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/
中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

pip.ini

```ini
[global]
timeout = 6000
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn

```

```sh
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
