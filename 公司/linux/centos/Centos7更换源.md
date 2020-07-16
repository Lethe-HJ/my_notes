清华源 https://mirrors.tuna.tsinghua.edu.cn


CentOS 镜像使用帮助

建议先备份 CentOS-Base.repo

sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

然后编辑 /etc/yum.repos.d/CentOS-Base.repo 文件，在 mirrorlist= 开头行前面加 # 注释掉；并将 baseurl= 开头行取消注释（如果被注释的话），把该行内的域名（例如mirror.centos.org）替换为 mirrors.tuna.tsinghua.edu.cn。

或者，你也可以直接使用如下内容覆盖掉 /etc/yum.repos.d/CentOS-Base.repo 文件：（未经充分测试）
选择你的 CentOS 版本:
```
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#


[base]
name=CentOS-$releasever - Base
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-7

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-7



#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-7



#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-7
```

最后，更新软件包缓存

sudo yum makecache

如果需要arm架构的包 将所有/centos/替换成/centos-altarch/即可

## EPEL 镜像使用帮助

EPEL(Extra Packages for Enterprise Linux)是由Fedora Special Interest Group维护的Enterprise Linux（RHEL、CentOS）中经 常用到的包。

下面以CentOS 7为例讲解如何使用tuna的epel镜像。

首先从CentOS Extras这个源（tuna也有镜像）里安装epel-release：

yum install epel-release

当前tuna已经在epel的官方镜像列表里，所以不需要其他配置，mirrorlist机制就能让你的服务器就近使用tuna的镜像。如果你想强制 你的服务器使用tuna的镜像，可以修改/etc/yum.repos.d/epel.repo，将mirrorlist和metalink开头的行注释掉。

接下来，取消注释这个文件里baseurl开头的行，并将其中的http://download.fedoraproject.org/pub替换成https://mirrors.tuna.tsinghua.edu.cn。

可以用如下命令自动替换：（来自 https://github.com/tuna/issues/issues/687）

sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!//download\.fedoraproject\.org/pub!//mirrors.tuna.tsinghua.edu.cn!g' \
    -e 's!http://mirrors\.tuna!https://mirrors.tuna!g' \
    -i /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo

修改结果如下：（仅供参考，不同版本可能不同）
```
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/$basearch/debug
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/SRPMS
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1
```


运行 yum update 测试一下吧。

yum install centos-release-openstack-queens  -y --downloadonly --downloaddir=~/package