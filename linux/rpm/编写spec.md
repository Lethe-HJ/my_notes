# spec.md

## spec文件解释

### 头
第一部分（未标记）定义了多种信息
`Summary`是一行关于该软件包的描述。
`Name` 是该软件包的基名
`Version` 是该软件的版本号
`Release` 是 RPM 本身的版本号 ― 如果修复了 spec 文件中的一个错误并发布了该软件同一版本的新 RPM，就应该增加发行版号。
`License` 应该给出一些许可术语（如：“GPL”、“Commercial”、“Shareware”）
`Group` 标识软件类型；那些试图帮助人们管理 RPM 的程序通常按照组列出 RPM
`Source0` 、 `Source1` 等等给这些源文件命名（通常为 tar.gz 文件）
`%{name}` 和 `%{version}` 是 RPM 宏，它们扩展成为头中定义的 rpm 名称和版本

### 描述

`%description` 提供该软件更多的描述，这样任何人使用 `rpm -qi` 查询您的软件包时都可以看到它。您可以解释这个软件包做什么，描述任何警告或附加的配置指令，等等。

### Shell 脚本

`%prep`部分 负责对软件包解包。在最常见情况下，您只要用 %setup 宏即可，它会在构建目录下解包源 tar 文件。加上 -q 项可以减少输出。

`%build`部分 负责编译软件包。该 shell 脚本从软件包的子目录下运行

`%install`部分 负责在构建系统上安装软件包

### 文件列表
`%files` 列出应该捆绑到 RPM 中的文件，并能够可选地设置许可权和其它信息。

在 %files 中%defattr 可以一次性定义缺省的许可权、所有者和组，比如`%defattr(-,root,root)`

`%attr(permissions,user,group)`用于覆盖个别文件的所有者和许可权。比如
`%attr(0444,root,root) 路径`
可以在 %files 中用一行包括多个文件。

`%doc` 告诉 RPM 这是一个文档文件，因此如果用户安装软件包时使用 `--excludedocs` ，将不安装该文件。也可以在 %doc 下不带路径列出文件名，RPM 会在构建目录下查找这些文件并在 RPM 文件中包括它们，并把它们安装到 `/usr/share/doc/%{name}-%{version}` 。以 %doc 的形式包括 `README` 和 `ChangeLog` 这样的文件是个好主意。

`%config` 告诉 RPM 这是一个配置文件。在升级时，RPM 将会试图避免用 RPM 打包的缺省配置文件覆盖用户仔细修改过的配置。

## 查看路径

`rpm --showrc|grep _topdir`
打印示例如下
-14: _builddir  %{_topdir}/BUILD
-14: _buildrootdir      %{_topdir}/BUILDROOT
-14: _rpmdir    %{_topdir}/RPMS
-14: _sourcedir %{_topdir}/SOURCES
-14: _specdir   %{_topdir}/SPECS
-14: _srcrpmdir %{_topdir}/SRPMS
-14: _topdir    %{getenv:HOME}/rpmbuild

_sourcedir
    RPM 在哪里查找源文件（tar 文件，等）
_srcrpmdir
    RPM 在哪里放入新的源 RPM 文件
_rpmdir
    RPM 将把新的二进制 RPM 文件放在哪里（在特定于体系结构的子目录中）

其中一些根据其它变量定义；例如，当您看到 %{_topdir} ，查找 _topdir 的定义，等等。 

```shell
$ rpm --showrc|grep _usrsrc
-14: _usrsrc    %{_usr}/src

$ rpm --showrc|grep _usr
-14: _usr       /usr
-14: _usrsrc    %{_usr}/src
```


## 示例

### 创建源程序hello.c

hello-0.1/hello.c

```c
#include <stdio.h>
int main()
{
    printf("Hello, World!\n");
    return 0;
}
```

执行
`cd hello-0.1`
`gcc -c hello.c -o hello.o`
`./hello.o`
输出Hello, World!说明c文件没问题

> gcc命令时需要添上 -c选项，用来保证得到的.o文件可重链接，不然基本会make报错

### 打包

`cd ..`
`tar -zcvf hello-0.1.tar.gz ./hello-0.1`
`cp hello-0.1.tar.gz ~/rpmbuild/SOURCE`

### 编写spec文件

~/rapmbuild/hello.spec

```shell
Summary:    hello world rpm package
Name:       hello
Version:    0.1
Release:    1
Source:     %{name}-%{version}.tar.gz
#  %{name}-%{version}.tar.gz => hello-0.1.tar.gz
#  Source指打包后的源码文件压缩包
License:    GPL
Packager:   amoblin
Group:      Application
URL:        http://www.ossxp.com

%description
This is a software for making your life more beautiful!
BuildRoot:  %{_builddir}/%{name}-root
# %{_builddir}/%{name}-root => ~/rpmbuild/BUILD / hello-root
%prep
%setup -q

%build
gcc -o hello hello.c

%install
mkdir -p $RPM_BUILD_ROOT/usr/local/bin
install -m 755 hello $RPM_BUILD_ROOT/usr/local/bin/hello
# 递归创建目录
# 复制hello到$RPM_BUILD_ROOT/usr/local/bin/hello路径下 并赋予755权限
%files
/usr/local/bin/hello
# 检测文件是否存在
```

`cd ~/rpmbuild/SPEC`
`rpmbuild -ba hello.spec`

执行成功后会在`~/rpmbuild/RPMS/x86_64/`下生成二进制包`hello-0.1-1.x86_64.rpm`和`hello-debuginfo-0.1-1.x86_64.rpm`文件
在`~/rapmbuild/SRPMS/`下生成源码包`hello-0.1-1.src.rpm`

`yum localinstall ~/rpmbuild/RPMS/x86_64/hello-0.1-1.rpm`
就能安装这个包到本机
在命令行输入`hello`,输出如下：
Hello, World!

执行`rpm -qi hello`就能看到%description中的信息

### 路径说明

以%{}括起来的是RPM宏
name代表spec文件开头的Name字段值
%{name}

以下划线开头的builddir是系统RPM宏，可以通过`rpm --showrc`看到
`%{_builddir}` => `~/rpmbuild/BUILD`

### rpmbuild 命令

上述命令中 `rpmbuild`命令
-bs 只生成src.rpm包；
-bb 只生成rpm包；
-ba 生成src.rpm包和rpm包

-bp 执行到%prep阶段
-bc 执行到build阶段
-bi 执行到install阶段
-bl 检测文件包含

`rpm -qpi x86_64/hello-0.1-1.x86_64.rpm`
输出序言部分

`rpm -qpl x86_64/hello-0.1-1.x86_64.rpm`
输出%file部分的 文件列表

运行 rpm -ba filename.spec 时，RPM 都做些什么：

+ 读取并解析 filename.spec 文件
+ 运行 %prep 部分来将源代码解包到一个临时目录，并应用所有的补丁程序。
+ 运行 %build 部分来编译代码。
+ 运行 %install 部分将代码安装到构建机器的目录中。
+ 读取 %files 部分的文件列表，收集文件并创建二进制和源 RPM 文件。
+ 运行 %clean 部分来除去临时构建目录。 

### 自定义打包目录

我们可以通过修改topdir宏的值来自定义打包路径：

`$ echo %_topdir $HOME/rpmbuild > ~/.rpmmacros`

这样再查看topdir的值会发现已变为用户主目录下rpm子目录了。这时修改文件就方便多了

## 使用Makefile

hello-0.2/hello/Makefile
```shell
SRC = hello.c

hello: $(SRC)
    gcc $^ -o $@
# 将所以依赖文件编译成目标文件
clean:
    rm -f hello

install:
    -mkdir -p $(RPM_INSTALL_ROOT)/usr/local/bin/
    install -m 755 hello $(RPM_INSTALL_ROOT)/usr/local/bin/hello
```

`$@`表示目标文件，`$^`表示所有的依赖文件，`$<`表示第一个依赖文件。

新建hello-0.2.spec文件

```shell
Summary:    hello world rpm package
Name:       hello
# 版本号修改成了0.2
Version:    0.2
Release:    1
Source:     %{name}-%{version}.tar.gz
#           hello-0.2.tar.gz
License:    GPL
Packager:   amoblin
Group:      Application
URL:        http://www.ossxp.com

%description
This is a software for making your life more beautiful!
BuildRoot:  %{_builddir}/%{name}-root
#             ~/rpmbuild/BUILD/hello-root
%prep
%setup -q

%build
############这里加了make
make

%install
############这里改成了RPM_INSTALL_ROOT=$RPM_BUILD_ROOT make install
RPM_INSTALL_ROOT=$RPM_BUILD_ROOT make install
# 或者这样
#make DESTDIR=$RPM_BUILD_ROOT install
%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/local/bin/hello
```

后面按照之前的步骤进行打包 rpmbuild编译即可

## 使用补丁文件

复制一份hello-0.2的源代码文件夹改名为hello-0.3,相应版本号也改过来
按照之前的步骤进行打包 rpmbuild编译
然后复制hello-0.3为hello-0.3.1 进入hello-0.3.1 修改c文件的部分内容
然后执行
`diff -uNr hello-0.3 hello-0.3.1 > hello-0.3.1.patch`
> -u 以 统一格式创建补丁文件，这种格式比缺省格式更紧凑些。 -N 确保补丁文件将正确地处理已经创建或删除文件的情况。 -r 比较命令行上所给出的两个目录的所有子目录中的所有文件。

生成patch文件复制到~/rapmbuild/SOURCES
复制~/rpmbuild/SPEC/hello-0.3.spec 为 hello-0.3.1.spec
修改hello-0.3.1.spec
在文件开头的字段声明部分的末尾加上`Patch:  %{name}-%{version}.patch`
在%prep部分的末尾加上`%patch -p1`
> 在 %prep 部分中的 %patch -p1 行是一个 RPM 宏， 它将在您系统的构建目录中运行补丁程序，其中把第一个补丁文件作为输入。 需要将 -p1 传递给补丁程序，告诉它从补丁文件中的路径中剥去一层目录,RPM 将在该目录内运行该补丁文
然后再执行`rpmbuild -ba hello-0.3.1.spec`
成功后`rpm -qpl ../SRPMS/hello-0.3-1.src.rpm`
显示
hello-0.3.1.patch.spec
hello-0.3.patch
hello-0.3.tar.gz
说明补丁已经被打进来了


## 不作为 root 用户来构建RPM包
构建 RPM 软件包通常要求您以 root 用户登录。 其原因如下：
    RPM 在打包过程中安装软件，并且通常只有 root 用户可以写到安装目录中。
    RPM 需要读写 /usr/src/redhat（一般用户不能修改它）下的目录。

前面探讨了通过用 RPM 构建根（build root）来解决第一个问题。
要解决第二个问题，可以通过更改 %_topdir 设置来告诉 RPM 查找和创建不同目录集中的文件
在您的主目录下创建一个名为`.rpmmacros`的文件,输入以下内容
%_topdir /home/your_userid/rpm

这个文件会告诉 RPM：它先前在 `~/rpmbuild/` 下查找的所有目录应该改为在 `/home/hujin/rpm` 下查找


## 通过示例学习

与安装二进制 RPM 包类似，可以使用 rpm -i filename.rpm 安装源 RPM 包。 安装完之后，.spec 文件将在您的 %_specdir 目录中，源文件和补丁文件将在您的 %_sourcedir 目录中

尝试用 rpm -ba foo.spec 构建这些 .spec 文件

多数情况下，构建在某个 Linux 分发版上的 RPM 不能应用到另一个 Linux 分发版。 更不要说应用到同一个分发版的另一个版本上，原因有很多，包括基本内核版本、库版本和目录结构方面的差异

如果 .spec 文件在带有源码的 tar 压缩包（.tar.gz 文件）中，那么用户只需运行：
	
`rpm -tb foo.tar.gz`

并构建该包的二进制 RPM ― 甚至无需解压该 tar 文件!

如果无法使 .spec 文件包含在软件中，则可以分发一个源 RPM 包。 有了这，用户就可以运行：
	
`rpm --rebuild foo.src.rpm`

并在他们的系统上构建二进制 RPM。


## 安装和卸载脚本

可以使用%pre,%post,%preun,%postun段落来定义安装前后，卸载前后的脚本动作

在某种情况下您希望安装过程失败。一种好的技术是使用 %pre 脚本来检查安装前提条件，它们比 RPM 可以直接支持的更复杂。 如果不符合前提条件，那么脚本以非零状态退出，而且 RPM 不会继续安装。


## 升级

RPM 如何执行升级：
+ 运行新包的 %pre
+ 安装新文件
+ 运行新包的 %post
+ 运行旧包的 %preun
+ 删除新文件未覆盖的所有旧文件
+ 运行旧包的 %postun

脚本有一种方法可以告之是否正在安装、删除或升级包。每个脚本都被传递单一命令行参数 ― 一个数字。 这应该告诉脚本 在当前包完成安装或卸载之后将安装多少个包的副本。

这里是在安装期间传递的实际值：

    运行新包的 %pre (1)
    安装新文件
    运行新包的 %post (1)

这里是在升级期间传递的值：

    运行新包的 %pre (2)
    安装新文件
    运行新包的 %post (2)
    运行旧包的 %preun (1)
    删除新文件未覆盖的任何旧文件
    运行旧包的 %postun (1)

这里是在删除期间传递的值：

    运行旧包的 %preun (0)
    删除文件
    运行旧包的 %postun (0)

一个示例：

```shell
Summary: GNU indent
Name: indent
Version: 2.2.6
        Release: 5
         
Source0: %{name}-%{version}.tar.gz
License: GPL
Group: Development/Tools
BuildRoot: %{_builddir}/%{name}-root
%description
The GNU indent program reformats C code to any of a variety of
formatting standards, or you can define your own.
%prep
%setup -q
%build
./configure
make
%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
%post
        if [ "$1" = "1" ] ; then  # first install
         
 if [ -x /sbin/install-info ]; then
   /sbin/install-info /usr/local/info/indent.info /usr/local/info/dir
 fi
        fi
         
%preun
        if [ "$1" = "0" ] ; then # last uninstall
         
 if [ -x /sbin/install-info ]; then
   /sbin/install-info --delete /usr/local/info/indent.info /usr/local/info/dir
 fi
        fi
         
%clean
rm -rf $RPM_BUILD_ROOT
%files
%defattr(-,root,root)
/usr/local/bin/indent
%doc /usr/local/info/indent.info
%doc %attr(0444,root,root) /usr/local/man/man1/indent.1
%doc COPYING AUTHORS README NEWS

```

## 在安装或卸载其它包时运行脚本

触发器示例

```shell
%triggerin -- emacs
# Insert code here to run if your package is already installed,
# then emacs is installed,
# OR if emacs is already installed, then your package is installed
%triggerin -- xemacs
# Insert code here to run if your package is already installed,
# then xemacs is installed,
# OR if xemacs is already installed, then your package is installed
%triggerun -- emacs
# insert code here to run if your package is already installed,
# then emacs is uninstalled
%triggerun -- xemacs
# insert code here to run if your package is already installed,
# then xemacs is uninstalled
%postun
# Insert code here to run if your package is uninstalled
```
触发器脚本被传递了 两个参数。第一个参数是当触发器脚本完成运行时将安装的 您的包的实例数。第二个参数是当触发器脚本完成运行时将安装的 要触发的包的实例数。 

RPM 升级期间脚本执行和文件安装及卸载的顺序

```shell
new-%pre  for new version of package being installed
 ...       (all new files are installed)
 new-%post for new version of package being installed
 any-%triggerin (%triggerin from other packages set off by new install)
 new-%triggerin
 old-%triggerun
 any-%triggerun (%triggerun from other packages set off by old uninstall)
 old-%preun    for old version of package being removed
 ...       (all old files are removed)
 old-%postun   for old version of package being removed
 old-%triggerpostun
 any-%triggerpostun (%triggerpostun from other packages set off by old un
       install)
```


## 高级脚本编制

### 备用解释器

通常，所有安装时脚本和触发器脚本都是使用 /bin/sh shell 程序运行的，不过也可以通过将 -p interpreter 添加到脚本行来告诉 RPM 应该使用另一种解释器运行您的脚本
```shell
%post -p /usr/bin/perl
# Perl script here
%triggerun -p /usr/bin/perl -- xemacs
# Another Perl script here
```

### RPM 变量
RPM 在将 RPM 变量存储到 RPM 包文件之前先在您的脚本中扩充它们

```shell
...
%define foo_dir /usr/lib/foo
...
%install
cp install.time.message $RPM_BUILD_ROOT/%{foo_dir}
%files
%{foo_dir}/install.time.message
%post
/bin/cat %{foo_dir}/install.time.message
```

## 相关链接

[IBM Developer用RPM打包软件](https://www.ibm.com/developerworks/cn/linux/management/package/rpm/part1/index.html)



