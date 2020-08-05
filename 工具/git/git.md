# git

## 远程仓库

`ssh-keygen -t rsa -C "youremail@example.com"`
将`id_rsa.pub`粘贴到github的`SSH key`中

`git remote add origin git@github.com:michaelliao/learngit.git`

`git remote` 查看远程库的信息
`git remote -v` 更加详细的远程库信息
`git remote rm origin` 删除origin这个远程库关联
第一次推送
`git push -u origin master`

创建远程origin的dev分支到本地
`git checkout -b dev origin/dev`

pull非master分支的时候一般需要设置一下链接
设置dev和origin/dev的链接
`git branch --set-upstream-to=origin/dev dev`

## 版本库，工作区和暂存区

工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库

`git add`把文件添加进去，实际上就是把文件修改添加到暂存区
`git commit`提交更改，实际上就是把暂存区的所有内容提交到当前分支。

`git diff HEAD -- <file>`
可以查看工作区和版本库里面最新版本的区别

Git还提供了一个stash功能，可以把当前工作现场“储藏”起来，等以后恢复现场后继续工作
`git stash`

`git stash list`
stash@{0}: WIP on dev: f52c633 add merge

`git stash apply`应用栈顶的代码
`git stash drop`删除栈顶的代码
`git stash pop`弹出栈顶的代码并应用

你可以多次stash，恢复的时候，先用`git stash list`查看，然后恢复指定的stash
`git stash apply stash@{0}`

## 撤销修改

`git checkout -- <file>`可以丢弃工作区的修改

`git reset HEAD <file>`可以把暂存区对指定文件的修改撤销掉，重新放回工作区

`git reset HEAD`可以把暂存区全部修改撤销掉，重新放回工作区

## 版本回退

HEAD指向的版本就是版本库里的当前版本

`git reset --hard HEAD^` 回退一次commit 不保留代码
  `HEAD^^` 两次
  `HEAD~100` 100次

`git reset --soft HEAD^` 回退一次commit 保留代码

`git reset --hard <commit-id>` 直接跳转到指定的commit

例如
`git log`打印出当前的commit历史为

  a428e2e
  cd45a76
  b73a771

现在我们想回到cd45a76

`git reset --hard HEAD^`

现在又想撤销刚才的回退，想回到a428e2e

先`git log`

  cd45a76
  b73a771

发现已经没有a428e2e了,这时可以刚刚打从印的信息中获取到COMMIT_ID

`git reset --hard a428e2e`

我们还能从`git reflog`中找到对应的COMMIT_ID

## 删除

当你需要删除某个文件
`rm <file>` 在工作区删除这个文件

然后反悔了 想恢复这个文件

`git checkout -- <file>` 从版本库中恢复上一个版本的这个文件

如果想把版本库里的这个文件也删除掉

`git rm <file>`

然后`git commit`就可以

## 分支

`git checkout -b dev` 切换并创建分支dev
相当于
`git branch dev`
`git checkout dev`

使用switch来切换分支更加科学
`git switch -c dev`

`git branch`查看当前分支

`git merge dev`合并dev分支到当前分支

如果两个分支没有冲突，会使用Fast forward模式合并
但这种模式下，删除分支后，会丢掉分支信息
`--no-ff`参数，表示禁用Fast forward,用普通模式合并，合并后的历史有分支，能看出来曾经做过合并
`git merge --no-ff -m "merge with no-ff" dev`

`git branch -d dev`删除dev分支
`git branch -D dev`如果分支没有合并，无法删除，那就强行删除

## 解决冲突

`git status`可以查看冲突的文件

修改冲突之后 add,commit之后就可以成功合并分支

`git log --graph` 查看分支合并图

## cherry-pick

cherry-pick命令，让我们能复制一个特定的提交到当前分支

`git cherry-pick <commitHash>或<branchName>`
将指定commitHash的提交或指定分支名的最近一次提交应用到当前分支，会在当前分支产生一个对应的新提交

git cherry-pick支持一次转移多个提交
将AB提交都应用到当前分支，会在当前分支产生两个对应提交
`git cherry-pick <commitHashA> <commitHashB>`

### 代码冲突

`--continue`
如果操作过程中发生代码冲突，Cherry pick 会停下来，让用户决定如何继续操作。
用户解决代码冲突后，第一步将修改的文件重新加入暂存区（git add .），第二步使用下面的命令，让 Cherry pick 过程继续执行。
`git cherry-pick --continue`

`--abort`
发生代码冲突后，放弃合并，回到操作前的样子。

`--quit`
发生代码冲突后，退出 Cherry pick，但是不回到操作前的样子。

## 多人协作

多人协作的工作模式通常是这样：

首先，在本地创建和远程分支对应的分支，使用`git checkout -b branch-name origin/branch-name`
修改代码后add,commit,然后，试图用`git push origin <branch-name>`推送自己的修改；
如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；
如果合并有冲突，则解决冲突，并在本地提交；
没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！
如果git pull提示no tracking information，则说明本地分支和远程分支的链接关系没有创建，用命令`git branch --set-upstream-to <branch-name> origin/<branch-name>`

## rebase

rebase操作可以把本地未push的分叉提交历史整理成直线，使得我们在查看历史提交的变化时更容易

本地commit之后,如果远程领先于本地，那么先pull，然后`git log` 看到本地的提交历史不是直线
那么我们继续执行`git rebase`将本地的master更改为基于刚刚pull过来的的版本，这样刚刚的commit就是
在现在远程版本的基础上的修改，然后`git log`，提交历史就是直线,push到远程之后提交历史也是直线

`git rebase master` 将当前分支的变基为本地master的当前HEAD

`git rebase -i HEAD~2` 合并最近两次提交
然后会弹出编辑器，按指示操作即可

## 标签

发布一个版本时，我们通常先在版本库中打一个标签（tag）
Git的标签虽然是版本库的快照，但其实它就是指向某个commit的指针，但是这个指针不能移动
tag就是一个有意义的名字，它跟某个commit绑定

切换到需要打标签的分支上

`git tag <tagname>`

这样就可以往的该分支上最近的提交上绑定一个标签

还可以指定特定的COMMIT_ID

`git tag <tagname> <commit_id>`

还可以创建带有说明的标签，用-a指定标签名，-m指定说明文字：

`git tag -a <tag_name> -m "<commit_msg>" <commit_id>`
`git show <tagname>`用来查看标签信息

删除标签

`git tag -d <tag_name>`

推送标签

`git push origin <tagname>`

一次性推送全部尚未推送到远程的本地标签

`git push origin --tags`

删除远程标签，先删除本地标签，然后删除远程标签

`git push origin :refs/tags/<tagname>`

## git配置

### gitignore

.gitignore文件写法

```js
// 文件名以.pyc， .pyo, .pyd结尾的文件
*.py[cod]
// 文件名以.so 结尾的文件
*.so
// dist文件夹
dist
```

强行添加被.gitignore忽略的文件

`git add -f App.so`

你发现，可能是.gitignore写得有问题，需要找出来到底哪个规则写错了，可以用git check-ignore命令检查：

`git check-ignore -v App.so`

## git配置文件

每个仓库的配置文件路径是`.git/config`

当前用户的Git配置文件放在用户主目录下的一个隐藏文件`.gitconfig`中
