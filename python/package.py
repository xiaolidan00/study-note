f = open('workfile', 'rb+')
f.write(b'0123456789abcdef')

f.seek(5)      # 定位到文件中的第 6 个字节

f.read(1)

f.seek(-3, 2)  # 定位到倒数第 3 个字节

f.read(1)

import json
x = [1, 'simple', 'list']
json.dumps(x)