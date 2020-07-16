## 什么是gerrit

Gerrit实际上一个Git服务器，它为在其服务器上托管的Git仓库提供一系列权限控制，以及一个用来做Code Review是Web前台页面。当然，其主要功能就是用来做Code Review。

## 配置步骤

`ssh-keygen -t rsa -C "hujin@kylinos.cn"`

`cat /.ssh/id_rsa.pub` 然后将这个内容复制放到gerrit的公钥配置中

确保gerrit管理员给自己设置了相应权限

## 获取代码

选择clone with commit-msg hook 得到以下命令
`git clone ssh://hujin@dev.kylincloud.me:29418/kylincloud-operation/koui-new && scp -p -P 29418 hujin@dev.kylincloud.me:hooks/commit-msg koui-new/.git/hooks/`
拷贝命令执行即可获取到代码

## 提交review

Gerrit相对Git提供了一个特有的命名空间“refs/for/”用来定义我们的提交上传到哪个branch，且可以用来区分我们的commit是提交到Gerrit进行审核还是直接提交到Git仓库，格式如下：
`refs/for/<target-branch>`

提交review
`$ git commit`
`$ git push origin HEAD:refs/for/master`
当我们的commit Push到Gerrit等待review时，Gerrit会将此commit保存在一个名为`refs/changes/xx/yy/zz`的一个暂存branch中。
其中`zz`为这个commit的patch set号，`yy`是change号，`xx`是change号的后两位。

## 验证别人提交的review

通过Gerrit页面中该commit右上角的Download按钮验证

### `Checkout`选项
`git fetch ssh://hujin@dev.kylincloud.me:29418/kylincloud-operation/koui-new refs/changes/64/9164/2 && git checkout FETCH_HEAD`

输出
`* branch  refs/changes/64/9164/1 -> FETCH_HEAD`
`Note: checking out 'FETCH_HEAD'.`
解释:
获得远程临时分支`refs/changes/64/9164/2`的代码,并将其放在本地临时分支`FETCH_HEAD`上，然后再切换到本地临时分支`FETCH_HEAD`上


### Cherry Pick选项
`git fetch ssh://hujin@dev.kylincloud.me:29418/kylincloud-operation/koui-new refs/changes/64/9164/2 && git cherry-pick FETCH_HEAD`获得远程临时分支`refs/changes/64/9164/2`的代码,并将其放在本地临时分支`FETCH_HEAD`上，并将`FETCH_HEAD`分支上的最近一次提交应用到当前分支上,会在当前分支产生新的提交



