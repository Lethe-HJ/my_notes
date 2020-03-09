# docker的使用

## 下载镜像

下载centos镜像
`docker pull centos:7`

查看镜像
`docker images`

由镜像开启一个容器

`sudo docker run --name controller -d centos:7 /bin/bash -c "tail -f /dev/null"`由centos:7镜像开启一个容器,后台运行，并执行命令开启一个前台守护进程 `docker run -dit --name ubuntu2 ubuntu`也可以

## 容器环境配置

查看哪个包提供ifconfig
`yum provides ifconfig`

结果中显示是net-tools
`yum install net-tools`
