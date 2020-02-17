# openstack

## 出现原因

![ss](../img/2020-02-10-113718.png)

## 简单介绍

- Nova – 弹性计算模块
围绕虚拟机相关的所有操作（KVM，Xen，Linux Container）

- Neutron – 网络模块
Linuxbridge+vlan，open vswitch+vlan/gre/vxlan

- Cinder – 块存储模块（EBS共享存储）
Ceph、GlusterFS、SheepDog

- Swift – 对象存储模块
- KeyStone – 认证鉴权模块
- Glance – 镜像管理模块

## 实验环境要求

- Ubuntu 14.04 64bit os （最好安装双系统）
  
- Devstack自动化部署，可以先参照此blog练习：

[博客](http://blog.csdn.net/ustc_dylan/article/details/17732911)
– 代码开发调试环境： eclipse + pydev + egit (单步调试)

## 硬件虚拟化

![sss](../img/2020-02-10_115049.png)

![ddd](../img/2020-02-10_122121.png)

![aaa](../img/2020-02-10_122217.png)

![scs](../img/2020-02-10_122827.png)

`sudo apt-get dist-upgrade`最新操作系统

`lsb_release -a`查看操作系统版本

`uname -ar`查看内核版本

设置成使用豆瓣源
`mkdir $HOME/.pip`
`vi $HOME/.pip/pip.conf`

输入以下内容

```shell
[global]
index-url = http://pypi.douban.com/simple/
```

`sudo apt-get install git`安装git

`git clone https://github.com/openstack-dev/devstack.git`获取devstack源码

切换到`devstack/tools/`目录下
创建stack用户运行
`./create-stack-user.sh`

修改devstack目录权限,让stack用户可以运行

`chown -R stack:stack /home/devstack`

切换到stack用户下 执行stack.sh
`su stack`
`cd /home/devstack`
`FORCE=yes ./stack.sh`