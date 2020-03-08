#　CentOS 6.x/7.x 对比一CentOS 6.x/7.x 对比


##　CentOS 6.x

内核版本(关键区别):2.6.x-x

文件系统: CentOS 6.x:EXT4
Ext4的单个文件系统容量达到1EB,单个文件大小则达到16TB

防火墙:iptables

默认数据库:MySQL

时间同步:ntpq -p

修改时区:/etc/sysconfig/clock

修改语言:/etc/sysconfig/i18n

主机名: 配置文件为/etc/sysconfig/network(永久设置)

网络服务管理: 

启动指定服务 `service 服务名 start`
关闭指定服务 `service 服务名 stop`
重启指定服务 `service 服务名 restart`
查看指定服务状态 `service 服务名 status`
查看所有服务状态 `service --status-all`
设置服务自启动 `chkconfig 服务名 on`
设置服务不自启动 `chkconfig 服务名 off`
查看所有服务自启动状态 `chkconfig --list`

默认的网卡名是:eth0
网络配置命令`ifconfig/setup`
网络服务默认使用 network 服务

## CentOS 7.x

内核版本(关键):3.10.x-x

文件系统:XFS
XFS默认支持8EB减1字节的单个文件系统,最大可支持的文件大小为9EB,最
大文件系统尺寸为18EBCentOS 6.x/7.x 对比 – 防火墙、内核版本、默认数据库

防火墙:firewalld

默认数据库:MariaDB

时间同步:`chronyc sources`
修改时区:`timedatectl set-timezone Asia/Shanghai`
修改语言:`localectl set-locale LANG=zh_CN.UTF-8`

主机名: 配置文件为`/etc/hostname`(永久设置)
还可以使用命令永久设置
`hostnamectl set-hostname hujin`

网络服务管理
启动指定服务 `systemctl start 服务名`
关闭指定服务 `systemctl stop 服务名`
重启指定服务 `systemctl restart 服务名`
查看指定服务状态 `systemctl status 服务名`
查看所有服务状态 `systemctl list-units`
设置服务自启动 `systemctl enable 服务名`
设置服务不自启动 `systemctl disable 服务名`
查看所有服务自启动状态 `systemctl list-unit-files`

默认的网卡名是:ens33

网络配置命令`ip/nmtui`

网络服务默认使用 NetworkManager 服务(network作为备用)