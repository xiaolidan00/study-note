# git命令

```bash
git init
# clone仓库
git clone https://github.com/user/repo.git projectName


# 查看所有远程
git remote -v
# 添加远程git
git remote add origin https://github.com/user/repo.git
# 重命名远程
git remote rename origin new-origin
# 移除远程
git remote remove new-origin
# 修改远程
git remote set-url origin https://github.com/user/new-repo.git
# 查看某个远程
git remote show origin


# 查看git配置
git config --list
# 查看当前仓库配置
git config -e
# 查看仓库全局配置
git config -e --global
# 设置用户名和邮箱
git config --global user.name "xiaolidan00"
git config --global user.email 764937567@qq.com

# 创建新分支
git checkout -b new-feature
# 切换到某个分支
git checkout main
# 合并某个分支
git merge new-feature
# 删除某个分支
git branch -d new-feature
# 删除远程某个分支
git push origin --delete new-feature
# 查看远程分支
git branch -r
# 查看所有本地和远程分支
git branch -a
# 查看分支
git branch
# 切换到指定分支
git switch branch-name
# 创建并切换到新分支
git switch -c new-branch

# 暂存某个文件
git add file.txt
git add *.c
# 暂存所有文件
git add .
# 查看暂存区的文件
git status
# 查看历史提交信息
git log 
# 以简洁模式显示提交历史
git log --oneline
# 查看工作区和暂存区之间的差异
git diff
# 查看暂存区和最后一次提交之间的差异
git diff --cached

git branch -M main
git push -u origin main


git commit -m "feat:init"

# 推送当前分支到远程
git push
# 推送到远程某个分支
git push origin new-feature
# 拉取远程当前分支
git pull
# 拉取远程某个分支
git pull origin branch-name
git fetch origin branch-name
git merge origin/branch-name



# 保存到暂存区
git  stash
# 从暂存区恢复
git  git stash pop
# 暂存区列表
git  stash list
# 恢复第二次暂存
git stash apply stash@{2}
#  清空暂存区
git stash clear
# 逐块选择要暂存的更改。
git add -p
# 删除特定存储
git stash drop stash@{n}

# 回退所有内容到上一个版本
git reset HEAD^            
# 回退 hello.php 文件的版本到上一个版本
git reset HEAD^ hello.php  
# 回退到指定版本
git  reset  052e
# 回退到某个版本
git reset --soft HEAD
# 回退上上上一个版本 
git reset --soft HEAD~3 
# 撤销工作区中所有未提交的修改内容，将暂存区与工作区都回到上一次版本，并删除之前的所有信息提交
git reset --hard HEAD 
# 回退上上上一个版本
git reset --hard HEAD~3
# 回退到某个版本回退点之前的所有信息。   
git reset –hard bae128   
# 将本地的状态回退到和远程的一样 
git reset --hard origin/master  
# HEAD 表示当前版本

# HEAD^ 上一个版本

# HEAD^^ 上上一个版本

# HEAD^^^ 上上上一个版本  

# 列出所有标签
git tag 
# 创建一个新标签
git tag v1.0
# 删除标签
git tag -d v1.0
# 附注标签
git tag -a v1.0 -m "runoob.com标签"
# PGP 签名标签命令
git tag -s <tagname> -m "runoob.com标签"
# 分支提交信息路径
git log --oneline --decorate --graph
# 查看标签信息
git show v1.0
# 推送标签到远程仓库
git push origin v1.0
# 推送所有标签
git push origin --tags
# 删除远程标签
git push origin --delete v1.0

# 初始化子模块
git submodule init
# 更新子模块
git submodule update
# 添加子模块
git submodule add https://github.com/example/libfoo.git folderName
# 移除子模块
git submodule deinit folderName
git rm folderName
# 列出子模块
git submodule
# 更新所有子模块
git submodule update --recursive --remote
# 检查子模块状态
git submodule status


# 将一个分支上的更改移到另一个分支之上
git rebase main
# 交互式变基 
git rebase -i <commit>
# 交互式变基，编辑提交历史
git rebase -i HEAD~3
# 选择提交
git cherry-pick <commit>

```

# gitflow

## 分支命名

- master 分支：

永远保持稳定和可发布的状态。
每次发布一个新的版本时，都会从 develop 分支合并到 master 分支。

- develop 分支：

用于集成所有的开发分支。
代表了最新的开发进度。
功能分支、发布分支和修复分支都从这里分支出去，最终合并回这里。

- feature 分支：

用于开发新功能。
从 develop 分支创建，开发完成后合并回 develop 分支。
命名规范：feature/feature-name。

- release 分支(test分支)：

用于准备新版本的发布。
从 develop 分支创建，进行最后的测试和修复，然后合并回 develop 和 master 分支，并打上版本标签。
命名规范：release/release-name。

- hotfix 分支：

用于修复紧急问题。
从 master 分支创建，修复完成后合并回 master 和 develop 分支，并打上版本标签。
命名规范：hotfix/hotfix-name。

## 分支操作原理

Master 分支上的每个 Commit 应打上 Tag，Develop 分支基于 Master 创建。
Feature 分支完成后合并回 Develop 分支，并通常删除该分支。
Release 分支基于 Develop 创建，用于测试和修复 Bug，发布后合并回 Master 和 Develop，并打 Tag 标记版本号。
Hotfix 分支基于 Master 创建，完成后合并回 Master 和 Develop，并打 Tag 1。

# gitflow命令

```bash
# 初始化 Git Flow
git flow init
# 当开始开发一个新功能时，从 develop 分支创建一个功能分支。
git flow feature start feature-name
# 完成开发后，将功能分支合并回 develop 分支，并删除功能分支。
git flow feature finish feature-name
# 当准备发布一个新版本时，从 develop 分支创建一个发布分支。
git flow release start release-name
# 在发布分支上进行最后的测试和修复，准备好发布后，将发布分支合并回 develop 和 master 分支，并打上版本标签。
git flow release finish release-name

git flow release start v1.0.0 # 测试和修复
git flow release finish v1.0.0


# 当发现需要紧急修复的问题时，从 master 分支创建一个修复分支。
git flow hotfix start hotfix-name
# 修复完成后，将修复分支合并回 master 和 develop 分支，并打上版本标签。
git flow hotfix finish hotfix-name


git flow hotfix start hotfix-1.0.1. # 修复紧急问题
git flow hotfix finish hotfix-1.0.1


```
