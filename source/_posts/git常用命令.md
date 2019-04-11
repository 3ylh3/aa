---
title: git常用命令
date: 2019-04-04 14:49:38
categories: 其他
tags: git
---
在列举git常用命令之前，首先介绍一下git工作区和版本库的概念。  
工作区(working directory):通俗讲就是电脑中的目录。
版本库(repository):工作区中有一个隐藏的.git目录，就是git的版本库，其中包含一个被称为stage(又叫index)的暂存区，还有git自动创建的一个master分支，以及一个指向master的指针HEAD。
<!-- more -->
接下来介绍git的常用命令：
 - git init：将目录变为可管理的仓库
 - git add <file>:把对file的修改添加进暂存区
 - git commit -m "xxx":将修改提交到当前分支，-m参数后跟的是提交说明
 - git log:查看提交过的版本信息，加上--graph参数可以看到合并图
 - git reflog:查看所有分支的所有操作记录（包括已经被删除的 commit 记录和 reset 的操作）
 - git reset  版本号:回退版本，参数：--soft:回退到commit之前的状态（工作区已经修改并且add进暂存区的状态） --mixed(默认):回退到add之前的状态（工作区已经修改但还没有add进暂存区的状态） --hard:强制回退，回退到工作区修改前的状态
 - git reset HEAD^:回退到上一版本
 - git reset HEAD~n:回退上n个版本
 - git status:查看当前分支状态
 - git checkout -- <file>:撤销对工作区中file的修改
 - git reset HEAD <file>:撤销对暂存区中file的修改，撤销后状态回到add之前的状态
 - git checkout HEAD -- <file>:撤销暂存区和工作区中对file的修改，相当于先执行git reset HEAD <file>然后执行git checkout -- [file]。撤销后状态回到工作区修改前的状态
 - git rm <file>:从暂存区删除file\
 - git remote:查看远程仓库信息，加上-v参数可以查看详细信息
 - git remote add origin git@github.com:xxxx/xxxx.git:关联远程仓库,origin是默认远程仓库名
 - git push -u origin <branch>:推送本地分支到远程分支，-u参数是把本地分支和远程分支关联起来，关联后以后pill或push时可以直接git pull/push
 - git clone:克隆远程仓库
 - git branch:查看分支
 - git branch <branch>:创建分支branch
 - git checkout <branch>:切换分支branch
 - git checkout -b <branch>:创建+切换分支
 - git merge <branch>:合并branch分支到当前分支,合并分支时默认Fast forward模式，这种模式下删除分支后会丢失分支信息，--no-ff参数表示禁用Fast forward会在merge时生成一个新的commit，因为要commit，所以需要加上 -m参数:git merge --no-ff -m "xxx" <branch>
 - git branch -d <branch>:删除分支branch
 - git branch -D <branch>:强行删除未合并的分支
 - git checkout -b <branch> origin/<branch>:在本地创建远程分支
 - git branch --set-upstream-to=origin/<branch> <branch>:将本地分支与远程分支关联
 - git rebase:把分叉的提交历史整理成一条线
 - git stash:保存工作现场,在当前分支上还有工作没有commit但又需要修改并提交其他分支的内容时，需要用git stash保存工作现场，否则切换到要修改的分支时工作区不是干净的
 - git stash list:查看保存起来的工作
 - git stash apply:恢复工作现场但不删除stash内容
 - git stash drop:删除stash内容
 - git stash pop:恢复工作现场并删除stash内容
 - git tag <name>:给分支打标签，默认是打在最新提交的commit上
 - git tag <name> <commit id>:给对应的commit id打标签
 - git tag:查看标签列表（按字母顺序排列）
 - git show <tagname>:查看标签信息
 - git tag -d <name>:删除标签
 - git push origin <tagname>:推送本地标签到远程
 - git push origin --tags:推送所有本地标签到远程
 - git push origin :refs/tags/<tagname>:删除远程标签（需要首先删除本地）

各操作图解如下：
![git](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/git/git.png)
