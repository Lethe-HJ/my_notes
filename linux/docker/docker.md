# docker

## 概述
Docker 是 dotcloud 公司开源的一款产品 dotcloud 是 2010 年新成立的一家公司,
主要基于 PAAS ( Platfrom as a Service ) 平台为开发者提供服务


Linux Container(LXC)是一种内核虚拟化技术,可以提供轻量级的虚拟化,以便隔离进程和资源

Docker是PAAS提供商 dotCloud开源的一个基于 LXC 的高级容器引擎,源代码托管在 Github 上, 基于 go 语言并遵从 Apache2.0 协议开源

Docker 设想是交付运行环境如同海运,OS 如同一个货轮,每一个在 OS 基础上的软
件都如同一个集装箱,用户可以通过标准化手段自由组装运行环境,同时集装箱的内容可
以由用户自定义,也可以由专业人员制造

## *AAS

![](2020-02-26-22-45-25.png)
 
## container与VMs的区别

![](../img/2020-02-25-22-11-48.png)
container相对于VMs安全性差但性能强
因为VMs在操作系统层消耗了更多资源，但操作系统能有效隔离，故安全性高




Docker 仓库：https://hub.docker.com

Docker 自身组件
> Docker Client:Docker 的客户端
> Docker Server:Docker daemon 的主要组成部分,接受用户通过 Docker Client
发出的请求,并按照相应的路由规则实现路由分发
> Docker 镜像:Docker 镜像运行之后变成容器(docker run)

## 安装docker

更换到阿里源

    ```shell
        cat >/etc/yum.repos.d/docker.repo <<-EOF
        [dockerrepo]
        name=Docker Repository
        baseurl=https://yum.dockerproject.org/repo/main/centos/7
        enabled=1
        gpgcheck=1
        gpgkey=https://yum.dockerproject.org/gpg EOF
    ```
`yum makecache`重新产生源的缓存
`systemctl start docker`
`systemctl enable docker`
`docker run hello-world`

## 加速docker

`cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service.bak`
`chmod 777 /etc/systemd/system/docker.service`
`vim /etc/systemd/system/docker.service`
插入以下内容
ExecStart=/usr/bin/dockerd-current --registry-
mirror=https://kfp63jaj.mirror.aliyuncs.com \

`systemctl daemon-reload`
`systemctl restart`
`ps -ef | grep docker`


`docker run --name db --env MYSQL_ROOT_PASSWORD=example -d mariadb`
`docker run --name MyWordPress --link db:mysql -p 8080:80 -d wordpress`


## 基本命令

### 镜像

docker images 列出本地所有镜像
docker info 守护进程的系统资源设置
docker search IMAGE_NAME 仓库的查询
docker pull Docker 仓库的下载
docker images Docker 镜像的查询
docker rmi IMAGE_NAME:TAG或者IAMGE_ID 删除镜像

### 容器

docker ps 查看当前运行的容器
docker ps -a 查看所有容器
docker run CONTAINER 容器的创建启动
docker start/stop CONTAINER 容器启动停止
docker rm CONTAINER
docker inspect MywordPress 查看容器所有基本信息
docker logs MywordPress 查看容器日志
docker stats MywordPress 查看容器所占用的系统资源
docker exec 容器名 容器内执行的命令 容器执行命令
docker exec -it 容器名 /bin/bash 登入容器的bash

docker cp cranky_elion:/home/hujin/20-02-28 /home/hujin 从容器中拷贝文件到宿主机

docker run的参数
--restart=always 容器的自动启动
-h x.xx.xx 设置容器主机名
--dns xx.xx.xx.xx 设置容器使用的 DNS 服务器
--dns-search DNS 搜索设置
--add-host hostname:IP 注入 hostname <> IP 解析
--rm 服务停止时自动删除
-d 后台运行
-p 80:8080

容器创建时需要指定镜像，每个镜像都由唯一的标示Image ID ，和容器的Container ID 一样，
也可以使用镜像名与版本号两部分组合唯一标示，如果省略版本号，默认使用最新版本标签(latesr)

镜像的分层：Docker 的镜像通过联合文件系统(union filesystem) 将各层文件系统叠加在一起
> bootfs：用于系统引导的文件系统，包括bootloader 和kernel，容器启动完成后会被卸载以节省内存资源
> roofs：位于bootfs之上，表现为Docker 容器的跟文件系统
>> 传统模式中，系统启动时，内核挂载rootfs时会首先将其挂载为“只读”模式，完整性自检完成后将其挂载为读写模式
>> Docker 中，rootfs由内核挂载为“只读”模式，而后通过UFS技术挂载一个“可写”层

镜像的特性
已有的分层只能读不能修改
上层镜像优先级大于底层镜像

容器 > 镜像 :docker commit CID xx.xx.xx
工作在前台的守护进程至少一个

docker run --name test -d centos:6.8
开启一个centos:6.8镜像的容器　该容器名为test

yum -y install mysql mysql-server
service mysqld start
chkconfig mysqld on
mysqladmin -u root password 123

docker commit mysql mysql:5.1
由容器生成镜像

DockerFile
Dockfile 是一种被 Docker 程序解释的脚本,Dockerfile 由一条一条的指令组成,每条指令对应 Linux 下面
的一条命令。Docker 程序将这些 Dockerfile 指令翻译真正的 Linux 命令。Dockerfile 有自己书写格式和支持的命令,
Docker 程序解决这些命令间的依赖关系,类似于 Makefile。Docker 程序将读取 Dockerfile,根据指令生成定制的 image
生成命令:docker
打开 DockerFile 说明
build -t wangyang/jdk-tomcat .


docker tag OLDNAME NEWNAME
修改镜像名
docker push IMAGENAME
上传镜像到镜像仓库

docker rmi -f $(docker immages -q)
删除所有镜像

## Dockerfile 语法
1、FROM（指定基础 image）：
构建指令，必须指定且需要在Dockerfile其他指令的前面。后续的指令都依赖于该指令指定的image。FROM指令指定的基础image可以是官方远程仓库中的，也可以位于本地仓库

example：
	FROM centos:7.2
	FROM centos

2、MAINTAINER（用来指定镜像创建者信息）：
构建指令，用于将image的制作者相关的信息写入到image中。当我们对该image执行docker inspect命令时，输出中有相应的字段记录该信息。
	
example：
	MAINTAINER  wangyang "wangyang@itxdl.cn"
	
3、RUN（安装软件用）：
构建指令，RUN可以运行任何被基础image支持的命令。如基础image选择了Centos，那么软件管理部分只能使用Centos 的包管理命令

example：	
	RUN cd /tmp && curl -L 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/bin/apache-tomcat-7.0.8.tar.gz' | tar -xz 
	RUN ["/bin/bash", "-c", "echo hello"]

4、CMD（设置container启动时执行的操作）：
设置指令，用于container启动时指定的操作。该操作可以是执行自定义脚本，也可以是执行系统命令。该指令只能在文件中存在一次，如果有多个，则只执行最后一条

example：
	CMD echo “Hello, World!”  

5、ENTRYPOINT（设置container启动时执行的操作）:
设置指令，指定容器启动时执行的命令，可以多次设置，但是只有最后一个有效。
	
example：
	ENTRYPOINT ls -l 
	
#该指令的使用分为两种情况，一种是独自使用，另一种和CMD指令配合使用。当独自使用时，如果你还使用了CMD命令且CMD是一个完整的可执行的命令，那么CMD指令和ENTRYPOINT会互相覆盖只有最后一个CMD或者ENTRYPOINT有效
	# CMD指令将不会被执行，只有ENTRYPOINT指令被执行  
	CMD echo “Hello, World!” 
	ENTRYPOINT ls -l  
	 
	
#另一种用法和CMD指令配合使用来指定ENTRYPOINT的默认参数，这时CMD指令不是一个完整的可执行命令，仅仅是参数部分；ENTRYPOINT指令只能使用JSON方式指定执行命令，而不能指定参数
	FROM ubuntu  
	CMD ["-l"]  
	ENTRYPOINT ["/usr/bin/ls"]  
	
6、USER（设置container容器的用户）：
设置指令，设置启动容器的用户，默认是root用户

example：
	USER daemon  =  ENTRYPOINT ["memcached", "-u", "daemon"]  

7、EXPOSE（指定容器需要映射到宿主机器的端口）：设置指令，该指令会将容器中的端口映射成宿主机器中的某个端口。当你需要访问容器的时候，可以不是用容器的IP地址而是使用宿主机器的IP地址和映射后的端口。要完成整个操作需要两个步骤，首先在Dockerfile使用EXPOSE设置需要映射的容器端口，然后在运行容器的时候指定-p选项加上EXPOSE设置的端口，这样EXPOSE设置的端口号会被随机映射成宿主机器中的一个端口号。也可以指定需要映射到宿主机器的那个端口，这时要确保宿主机器上的端口号没有被使用。EXPOSE指令可以一次设置多个端口号，相应的运行容器的时候，可以配套的多次使用-p选项。

example：
	映射一个端口  
	EXPOSE 22
	相应的运行容器使用的命令  
	docker run -p port1 image  
  
	映射多个端口  
	EXPOSE port1 port2 port3  
	相应的运行容器使用的命令  
	docker run -p port1 -p port2 -p port3 image  
	还可以指定需要映射到宿主机器上的某个端口号  
	docker run -p host_port1:port1 -p host_port2:port2 -p host_port3:port3 image  

8、ENV（用于设置环境变量）：构建指令，在image中设置一个环境变量
	  
example：
	设置了后，后续的RUN命令都可以使用，container启动后，可以通过docker inspect查看这个环境变量，也可以通过在docker run --env key=value时设置或修改环境变量。假如你安装了JAVA程序，需要设置JAVA_HOME，那么可以在Dockerfile中这样写：
	ENV JAVA_HOME /path/to/java/dirent
	

	
	
9、ADD（从src复制文件到container的dest路径）

example：	
	ADD <src> <dest>  
		<src> 是相对被构建的源目录的相对路径，可以是文件或目录的路径，也可以是一个远程的文件url;
		<dest> 是container中的绝对路径

10、COPY （从src复制文件到container的dest路径）
example：	
	COPY <src> <dest> 

10、VOLUME（指定挂载点）：
设置指令，使容器中的一个目录具有持久化存储数据的功能，该目录可以被容器本身使用，也可以共享给其他容器使用。我们知道容器使用的是AUFS，这种文件系统不能持久化数据，当容器关闭后，所有的更改都会丢失。当容器中的应用有持久化数据的需求时可以在Dockerfile中使用该指令

examp：	
	FROM base  
	VOLUME ["/tmp/data"]  

11、WORKDIR（切换目录）：设置指令，可以多次切换(相当于cd命令)，对RUN,CMD,ENTRYPOINT生效

example：
	WORKDIR /p1 WORKDIR p2 RUN vim a.txt  
	
12、ONBUILD（在子镜像中执行）：ONBUILD 指定的命令在构建镜像时并不执行，而是在它的子镜像中执行

example：	
	ONBUILD ADD . /app/src
	ONBUILD RUN /usr/local/bin/python-build --dir /app/src

###　镜像的导出以及导入
导出：docker save -o  xx.xx.xx  xx.xx.xx.tar
导入：docker load -i xx.xx.xx.tar


##　镜像仓库构建
1、官方仓库构建方式
仓库服务器配置：
	docker run -d -v /opt/registry:/var/lib/registry -p 5000:5000 --restart=always registry
	
	vim /etc/docker/daemon.json
		{
			"insecure-registries": ["10.10.10.11:5000"]
		}

客户机设置：
	vim /etc/sysconfig/docker
		--insecure-registry 10.10.10.11:5000    增加
	
	curl -XGET http://10.10.10.11:5000/v2/_catalog    查看已有镜像
