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

## gerrit 提交

`git branch`
`git checkout master`
`git pull`
`git checkout hujin`
`git rebase -i master`
`git commit --amend`
`git-review -y`

多次rebase导致commit重复，无法提交patch

场景：开发中出现功能依赖情况，例，c基于b，b基于a，当a分支更新时，b分支需执行rebase a，c分支需执行rebase b，当a多次更新时，b和c会出现多次rebase，导致commit信息多次重复

解决方案：每次rebase后，删除重复commit信息，保留最后的即可，git rebase -i commitId


Gerrit使用一般流程
Gerrit登陆
管理员事先创建好大家的单点登录账号，按照如下流程登陆及初始化设置Gerrit：
访问ipa.kylincloud.me，初次登陆修改密码
修改密码后登陆gerrit，http://dev.kylincloud.me/gerrit/
gerrit页面，右上角个人设置里面，修改profile的用户名（都写名字的全拼）
SSH Public Keys里面添加各自的公钥
GIT安装
我们用GIT来做版本管理和协作开发，所以首先需要在本地安装Git，安装方法这里不做说明。注意，如果是做khatch前端的开发，要求版本高于2.13.0
Clone项目代码
所有的项目通过gerrit管理，可以在Projects->List里面看到项目列表，在列表中找到相应的项目，点击项目名，在General信息里面，可以看到相应的克隆地址，以khatch为例，一般选择‘SSH’的方式：
git clone ssh://xxxxxxxxx@dev.kylincloud.me:29418/kylincloud/khatch
如果没有找到相应的项目，可能有3种情况
项目属于自创项目，需要从头开始创建
在gerrit页面上创建project。Projects->Create New Project,选择Create initial empty commit。
本地git clone并初始化。地址从gerrit页面获取（如上khatch）
git clone ssh://xxxxxxxx@dev.kylincloud.me:29418/kylincloud/xxxx
将.gitignore和.gitreview两文件从其它已有git项目中复制至本项目根目录。下载gitinit-files.tar.gz， 在文件中修改项目相应的参数
切换分支，这一步是常规操作，每次做修改之前都要基于原始分支创建一个新的分支
git checkout -b initial-first-commit
完成添加或修改文件，执行第一次commit
...Do something...
git add .
git commit -am "Inital-first-commit"
执行推送，将代码推送到gerrit
git review master
此方法如有问题，执行: git-review --amend 修改其中的Author为自己的用户名
已有项目，但gerrit上还没有创建，通知管理员去后台初始化项目
项目存在但没有权限访问，通知相应的core或者管理员授权
针对云平台相关的项目，我们都会创建相应版本的分支，以Q版本为例，正常每个项目都会有一个kc/queens分支，Q版的开发都是基于这个分支。
代码提交
查看当前分支，确保是基于正确的base分支，以Q版为例，OpenStack相关的项目基本都是基于kc/queens分支，有些自创项目应该是基于master分支，在做代码修改前，最好向相关人员确认base分支
git status
git checkout kc/queens
基于base分支，创建工作分支，分支名字最好能够简单的表示用途
git checkout -b fix_xxx_issue
在新建的分支中，完成相应的修改，原则上除逻辑代码外，需要添加相应的单元测试，python单元测试参考：unittest
NOTE：如果代码涉及API添加或修改，原则上需要先编写API文档并且和前端一起确定通过后，才开始实现相关的代码，api规范参见：Restful API规范
本地测试
完成代码修改后，本地先做一轮测试，测试通过后才能提交到gerrit，以openstack相关项目为例：
tox -e pep8    # 代码格式检查
tox -e py27    # 单元测试 
更多tox用法，可以参考：tox测试，如测试报错，按照错误提示进行修复
对于python开发，pep8标准参考：
pep8标准-中文
pep8标准-官方
生成commit
代码修改，默认在stage状态，对于新增的文件还需要用git add xxxx命令放到stage中，生成commit
git commit -a
这个命令会自动打开编辑器，用来完善commit的描述（即我们说的commit message），commit message需要满足规范，参见：Commit提交规范
提交代码
提交代码到远端的相应分支，对于openstack相关项目，这个分支正常是kc/queens，其它项目大部分是master。当然，最好是先跟相关人员确认
git review kc/queens
or
git review master      # master可以省略
代码审核
代码提交成功后，即在Gerrit上进入审核阶段。能看到这个项目的人都可以进行审核，并且提意见，讨论。对于产品开发来说，代码审核至关重要，具体可参见：Google的工程实践文档
再次提交
审核阶段，开发人员需时刻关注Gerrit上代码审核过程。Gerrit会配合Jenkins和zuul进行自动化的测试，测试有问题或者审核人员有修改建议，都需要对代码进行修改。修改代码后，再次提交：
git commit -a --amend
git review xxxx
上面两个步骤会多次循环，直到审核人员确认代码无误，给出code review +2和workflow + 1后，代码merge进入仓库
常见问题处理方法（QA）
NOTE：以下的操作处理示例大多是以base分支为master为例，具体的分支以实际为准
代码提交有冲突
Q：和组员修改同一文件，组员patch先合并，从master分支git pull下来后，切到自己本地分支，git rebase master，出现文件冲突
A：
git status查看冲突的文件
依次打开冲突的文件，git已经标记了冲突的位置，搜索‘HEAD’关键字就能找到，解决冲突，保留最终的代码
git add xxx将冲突的文件加入到stage中
git rebase --continue
多次rebase导致commit重复，无法提交patch
Q：开发中出现功能依赖情况，例，c基于b，b基于a，当a分支更新时，b分支需执行rebase a，c分支需执行rebase b，当a多次更新时，b和c会出现多次rebase，导致commit信息多次重复
A：每次rebase后，删除重复commit信息，保留最后的即可，git rebase -i commitId
初次提交失败
Q：第一次提交patch失败，缺少change id
A：在第一次执行git-review时未能执行到远程的钩子函数，生成change id，可根据命令行的提示，进行操作
patch审核完成后合并失败
Q： patch审核通过后，发现合并有冲突
A：获取最新的master代码，本地分支git rebase master，解决冲突，重新提交
amend覆盖了上一次commit后如何回退
Q: 场景: 误操作使用了git commit --amend 替换了前一次的提交内容。如何操作进行取消？
A：后面的amend提交会合并覆盖上一次的commit，生成新的commit id。通过git reflog找到上一次提交的commit id，然后git reset last_commit_id即可
操作失误问题：
Q：git rebase后解决冲突，误操作直接执行git commit -a --amend，没有git rebase --continue，应该怎么处理
A：参考上一个问题处理办法回退
分支依赖问题：
Q: 从主分支切到分支1开发保存后，从分支1切到分支2开发功能保存后。再切回分支1更新，然后分支2 rebase 分支1的新代码，会出现分支1有两个重复提交记录。分支代码做更新后，后面依赖的分支怎么操作才不受影响？
A: 没有复现这个问题，怀疑是在跟新分支1后，commit时没有amend而生成了一个新的提交，且commit message和原来一样，这样就出现了两个看起来一样的提交记录。
单个分支下生成多个commitId问题：
Q： 1、主分支切到分支1进行开发，执行git commit -a 提交保存；  2、再进行代码更新，再次执行git commit -a；  3、第三次进行代码修改，再次执行git commit -a。此时单个分支下会生成多个commitId，要怎么进行修改第一次提交的代码？
（原文：一个分支上 有多个commit  还没有review到gerrit上面去，比如有 a b c d  四个 commit 我在d这个位置，要修改前面的 a或者b的代码 怎么解）
A: 我们不建议有这种一个分支多个commit的骚操作，正常也不会有这种情况发生，都是一个commit对应一个分支。当然如果出现这种情况，想要去修改a commit的内容，可以通过git log 找到a的commitid，然后从a这个commit新建一个分支就行：git checkout -b new_branch commitid
其他疑问
Q：审查阶段，如果patch1有修改，patch2、patch3需要分别rebase patch1，patch2，保持同步吗
A：是的
Q：如果patch1 abandon后，patch2和patch3应该如何提交
A：这时候有多种情况
如果整个大的功能都不需要了，那patch2和patch3也得abandon
正常的依赖关系是patch3->patch2->patch1->master，如果patch1 abandon了，那么需要patch2 rebase到master，patch3再rebase到patch2
Q：rebase阶段误操作导致有两个commit有相同的change-id该怎么抢救
A：没遇到这种情况，可以回退代码后再重新rebase，实在不行就重建分支重新rebase
Q：拆分patch有推荐的操作步骤吗
A：原则上大的patch需要拆分成多个小的patch提交，小patch之间肯定有依赖但都相对独立，以khatch后端代码为例，一个大patch可以拆分成：
model相关的
resource层的代码（和openstack底层交互）
异步任务
api层
文档
Q：误操作（具体什么误操作忘记了）导致git-review的时候报错remote: (W) No changes between prior commit xxxx and new commit xxxx 怎么处理
A: 这个不是错误信息，是表示两个提交之间没有变化。已经提交后，没有做任何修改，再一次提交，就会有这个提示