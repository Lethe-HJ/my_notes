# centos7常用操作与命令
 
## 1. CentOS 7更改yum源与更新系统

`mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup`
`cd   /etc/yum.repos.d/`
`wget http://mirrors.163.com/.help/CentOS7-Base-163.repo`
`yum clean all`
`yum makecache`
`yum -y update`

`yum install epel-release`
`yum makecache`

`wget http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm`
`rpm -ivh rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm`
`yum makecache`