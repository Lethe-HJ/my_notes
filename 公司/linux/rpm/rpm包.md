# rpm

## 常见linux系统中RPM包的通用命名规则
 

RPM包的一般格式为：
`name-version-arch.rpm`
`name-version-arch.src.rpm`

例：
`httpd-2.2.3-29.el5.i386.rpm`
`httpd-devel-2.2.3-29.el5.i386.rpm`
`httpd-manual-2.2.3-29.el5.i386.rpm`
`system-config-httpd-1.3.3.3-1.el5.noarch.rpm`

 

(1)name，如：httpd，是软件的名称。

(2)version，如:2.2.3 ,是软件的版本号。版本号的格式通常为“主版本号.次版本号.修正号”。

29，是发布版本号，表示这个RPM包是第几次编译生成的。

(3)arch,如:i386,表示包的适用的硬件平台，目前RPM支持的平台有：i386、i586、i686、sparc和alpha。

(4).rpm或.src.rpm,是RPM包类型的后缀，.rpm是编译好的二进制包，可用rpm命令直接安装；.src.rpm表示是源。

代码包，需要安装源码包生成源码，并对源码编译生成.rpm格式的RPM包，就可以对这个RPM包进行安装了。

特殊名称：
1. el*  表示这个软件包的发行商版本,el5表示这个软件包是在RHEL 5.x/CentOS 5.x下使用。
2. devel：表示这个RPM包是软件的开发包。
3. noarch：说明这样的软件包可以在任何平台上安装，不需要特定的硬件平台。在任何硬件平台上都可以运行
4. manual 手册文档。


## rpmbuild 
-ba 既生成src.rpm又生成二进制rpm
-bs 只生成src的rpm
-bb 只生二进制的rpm
-bp 执行到pre
-bc 执行到 build段
-bi 执行install段
-bl 检测有文件没包含 
可以先rpmbuild -bp ,再-bc 再-bi 如果没问题，rpmbuild -ba 生成src包与二进制包