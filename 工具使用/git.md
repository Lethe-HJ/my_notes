## git cherry-pick

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





## 撤销add添加的文件

`git reset HEAD`撤销所有add

`git reset HEAD 文件名`撤销该文件的add

`git checkout -- 文件名` 丢弃工作区中该文件的修改

 



## gerrit 提交



`git branch`
`git checkout master`
`git pull`
`git checkout hujin`
`git rebase -i master`
`git commit --amend`
`git-review -y`