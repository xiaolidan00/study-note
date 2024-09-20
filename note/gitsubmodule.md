# git submodule操作

```bash
git submodule add url 路径

# 目录存在时不可submodule
git rm -r --cached 路径

# clone后
git submoudle init
git submoudle update

git submodule foreach git pull
git submoulde sync

```

.gitmodules

```ini
[submodule "src/components"]
 path = src/components 
 url = http://192.168.20.10:8090/xhy/spatial-ui-module.git
 branch= dev
```
