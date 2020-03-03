
## 实例来源
[src.rpm来源](http://vault.centos.org/centos/7/cloud/Source/openstack-queens/python-novaclient-10.1.1-1.el7.src.rpm)


## 头

```shell
%{!?upstream_version: %global upstream_version %{version}%{?milestone}}
#global是用来定义一些全局变量，变量的反问语法是%{!},如果是%{?}，则表示变量如果有定义才取值
%global sname novaclient

%if 0%{?fedora}
# 如果fedora定义了那么0%{?fedora}就为0%{fedora} 非0 执行这个if block
%global with_python3 1
%endif

%global common_desc \
This is a client for the OpenStack Nova API. There\'s a Python API (the \
novaclient module), and a command-line script (nova). Each implements 100% of \
the OpenStack Nova API.

Name:             python-novaclient
Epoch:            1
Version:          10.1.1
Release:          1%{?dist}
Summary:          Python API and CLI for OpenStack Nova
License:          ASL 2.0
URL:              https://launchpad.net/%{name}
Source0:          https://pypi.io/packages/source/p/%{name}/%{name}-%{version}.tar.gz
BuildArch:        noarch

# build时 需要的依赖
BuildRequires:  git
BuildRequires:  openstack-macros

```
具体执行的shell代码见下面的prep部分

## 描述

```shell
#这是默认包即python-novaclient包的描述
%description
%{common_desc}

%package -n python2-%{sname}
# 定义一个新的包，名字为python2-novaclient， 所有关于这个包的信息，依赖都在这个字段下面书写

Summary:          Python API and CLI for OpenStack Nova
%{?python_provide:%python_provide python2-novaclient}

#以BuildRequires定义的包是指在python setup.py build编译的时候需要用到的依赖
BuildRequires:    python2-devel
BuildRequires:    python2-pbr
BuildRequires:    python2-setuptools

#以Requires定义的包是指在安装rpm包的时候依赖或者说对python来说就是指：python setup.py install
Requires:         python2-babel >= 2.3.4
Requires:         python2-iso8601 >= 0.1.11
Requires:         python2-keystoneauth1 >= 3.3.0
Requires:         python2-oslo-i18n >= 3.15.3
Requires:         python2-oslo-serialization >= 2.18.0
Requires:         python2-oslo-utils >= 3.33.0
Requires:         python2-pbr >= 2.0.0
Requires:         python2-prettytable >= 0.7.1
Requires:         python-simplejson >= 3.5.1
Requires:         python2-six >= 1.10.0

# 新包python2-novaclient的描述
%description -n python2-%{sname}
%{common_desc}

%if 0%{?with_python3}
%package -n python3-%{sname}
Summary:          Python API and CLI for OpenStack Nova
%{?python_provide:%python_provide python3-novaclient}


BuildRequires:    python3-devel
BuildRequires:    python3-pbr
BuildRequires:    python3-setuptools

Requires:         python3-babel >= 2.3.4
Requires:         python3-iso8601 >= 0.1.11
Requires:         python3-keystoneauth1 >= 3.3.0
Requires:         python3-oslo-i18n >= 3.15.3
Requires:         python3-oslo-serialization >= 2.18.0
Requires:         python3-oslo-utils >= 3.33.0
Requires:         python3-pbr >= 2.0.0
Requires:         python3-prettytable >= 0.7.1
Requires:         python3-simplejson >= 3.5.1
Requires:         python3-six >= 1.10.0

%description -n python3-%{sname}
%{common_desc}
%endif

%package doc
Summary:          Documentation for OpenStack Nova API Client

BuildRequires:    python2-sphinx
BuildRequires:    python2-openstackdocstheme
BuildRequires:    python2-oslo-utils
BuildRequires:    python2-keystoneauth1
BuildRequires:    python2-oslo-serialization
BuildRequires:    python2-prettytable

%description      doc
%{common_desc}

This package contains auto-generated documentation.
```
具体执行的shell代码见下面的prep部分

## prep部分

```shell
# 编译前准备,将源码包解压在BUILD构建
%prep
%autosetup -n %{name}-%{upstream_version} -S git
# autosetup是rpm替代setup的宏,其中 -n表示解压到BUILD目录下面的目录名 -S git表示把源码包初始化成一个git项目包  

# Let RPM handle the requirements
%py_req_cleanup
```

先删除/var/tmp/下的所有rpm-tmp文件`rm -rf /var/tmp/rpm-tmp*`
然后在python-novaclient.spec 中%prep后面插入一行 `cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS`将临时生成的脚本文件复制出来，然后就执行`rpmbuild -bp python-novaclient.spec`命令，就可以在SPEC目录下看到rpm-tmp*文件

rpm-tmp*
```shell
  RPM_SOURCE_DIR="/root/rpmbuild/SOURCES"
  RPM_BUILD_DIR="/root/rpmbuild/BUILD"
  RPM_OPT_FLAGS="-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches   -m64 -mtune=generic"
  RPM_LD_FLAGS="-Wl,-z,relro "
  RPM_ARCH="x86_64"
  RPM_OS="linux"
  export RPM_SOURCE_DIR RPM_BUILD_DIR RPM_OPT_FLAGS RPM_LD_FLAGS RPM_ARCH RPM_OS
  RPM_DOC_DIR="/usr/share/doc"
  export RPM_DOC_DIR
  RPM_PACKAGE_NAME="python-novaclient"
  RPM_PACKAGE_VERSION="10.1.1"
  RPM_PACKAGE_RELEASE="1.el7"
  export RPM_PACKAGE_NAME RPM_PACKAGE_VERSION RPM_PACKAGE_RELEASE
  LANG=C
  export LANG
  unset CDPATH DISPLAY ||:
  RPM_BUILD_ROOT="/root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
  export PKG_CONFIG_PATH
  # 前面这些都是头和描述部分的内容

  set -x
  umask 022
  # 设置屏蔽码为022 相当于新建的文件夹权限为777-022 新建的文件为666-022 即新建的 文件夹与文件不可写

  cd "/root/rpmbuild/BUILD"
cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS
# 这一行是我们加到.spec文件中的也被打出来了


cd '/root/rpmbuild/BUILD'
rm -rf 'python-novaclient-10.1.1'
# 删除历史遗留文件夹

/usr/bin/gzip -dc '/root/rpmbuild/SOURCES/python-novaclient-10.1.1.tar.gz' | /usr/bin/tar -xf - 
# 解压缩python-novaclient-10.1.1.tar.gz并将解压缩之后的文件输出到标准输出设备
# -x从归档中解出文件 -f使用后面跟着的归档文件 （就是|之前命令的输出）

STATUS=$?
# $?最后命令的退出状态

if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
如果前面解压失败 那么就以$STATUS为退出状态值终止脚本

cd 'python-novaclient-10.1.1'
/usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
# 强制递归地给权限 所有用户都给rX 拥有者给写 同组者和其它人不可写

/usr/bin/git init -q
/usr/bin/git config user.name "rpm-build"
/usr/bin/git config user.email "<rpm-build>"
/usr/bin/git add .
/usr/bin/git commit -q -a\
        --author "rpm-build <rpm-build>" -m "python-novaclient-10.1.1 base"



# Let RPM handle the requirements

sed -i 's/^warning-is-error.*/warning-is-error = 0/g' setup.cfg
# -i ∶插入 g 表示行内全面替换   将^warning-is-error.*按行替换成warning-is-error = 0
rm -rf *requirements.txt
```

## build部分

python-novaclient.spec
```shell
%build
%py2_build
%if 0%{?with_python3}
%py3_build
%endif
cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS
# 这一行是为了查看临时脚本而加上去的
```

rpm-tmp*
```shell
set -x
  umask 022
  cd "/root/rpmbuild/BUILD"
cd 'python-novaclient-10.1.1'
\
  CFLAGS="-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches   -m64 -mtune=generic" /usr/bin/python2 setup.py  build --executable="/usr/bin/python2 -s" 
  sleep 1
# 这里先给CFLAGS变量赋值 然后再build python包 其中--executable是指定最终目标解释器的路径
cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS
# 这一行是为了查看临时脚本而加上去的
```


## install 部分

python-novaclient.spec
```shell
%install
%if 0%{?with_python3}
%py3_install
mv %{buildroot}%{_bindir}/nova %{buildroot}%{_bindir}/nova-%{python3_version}
ln -s ./nova-%{python3_version} %{buildroot}%{_bindir}/nova-3
# Delete tests
rm -fr %{buildroot}%{python3_sitelib}/novaclient/tests
%endif
cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS
```

rpm-tmp*
```shell
set -x
umask 022
cd "/root/rpmbuild/BUILD"
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "${RPM_BUILD_ROOT}"
# "$RPM_BUILD_ROOT" == "/" 说明是要安装到/ 否则则是临时安装到RPM_BUILD_ROOT 临时安装需要先把这个目录清空
mkdir -p `dirname "$RPM_BUILD_ROOT"`
mkdir "$RPM_BUILD_ROOT"

cd 'python-novaclient-10.1.1'


CFLAGS="-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches   -m64 -mtune=generic" 

/usr/bin/python2 setup.py  install -O1 --skip-build --root /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64 
# 指定root路径 安装python包 

mv /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/bin/nova /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/bin/nova-2.7
ln -s ./nova-2.7 /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/bin/nova-2
# 创建软链接

ln -s ./nova-2 /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/bin/nova

mkdir -p /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/etc/bash_completion.d
install -pm 644 tools/nova.bash_completion \
    /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/etc/bash_completion.d/nova
# 将指定路径下的文件复制到目标路径下 其中 -p修改源文件的访问/修改时间以与目标文件保持一致 -m 指定权限

# Delete tests
rm -fr /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/lib/python2.7/site-packages/novaclient/tests

/usr/bin/python2 setup.py build_sphinx -b html
/usr/bin/python2 setup.py build_sphinx -b man
# /usr/bin/python2 setup.py --help-commands列出所有可用的命令 build_sphinx => Build Sphinx documentation 
# --builder (-b)           The builder (or builders) to use. Can be a comma or space-separated list. Defaults to "html"

install -p -D -m 644 doc/build/man/nova.1 /root/rpmbuild/BUILDROOT/python-novaclient-10.1.1-1.el7.x86_64/usr/share/man/man1/nova.1
# -D    创建目标目录的所有必要的父目录，然后将源文件复制至该目录
# Fix hidden-file-or-dir warnings
rm -fr doc/build/html/.doctrees doc/build/html/.buildinfo

cp /var/tmp/rpm-tmp* ~/rpmbuild/SPECS

    
   /usr/lib/rpm/find-debuginfo.sh --strict-build-id -m --run-dwz\
   --dwz-low-mem-die-limit 10000000\
   --dwz-max-die-limit 110000000  "/root/rpmbuild/BUILD/python-novaclient-10.1.1"

    /usr/lib/rpm/check-buildroot
    
    /usr/lib/rpm/redhat/brp-compress 
     
    /usr/lib/rpm/redhat/brp-strip-static-archive /usr/bin/strip 
    /usr/lib/rpm/brp-python-bytecompile /usr/bin/python 1 
    /usr/lib/rpm/redhat/brp-python-hardlink 
    /usr/lib/rpm/redhat/brp-java-repack-jars
```


```shell
%py2_install
mv %{buildroot}%{_bindir}/nova %{buildroot}%{_bindir}/nova-%{python2_version}
ln -s ./nova-%{python2_version} %{buildroot}%{_bindir}/nova-2

ln -s ./nova-2 %{buildroot}%{_bindir}/nova

mkdir -p %{buildroot}%{_sysconfdir}/bash_completion.d
install -pm 644 tools/nova.bash_completion \
    %{buildroot}%{_sysconfdir}/bash_completion.d/nova

# Delete tests
rm -fr %{buildroot}%{python2_sitelib}/novaclient/tests

%{__python2} setup.py build_sphinx -b html
%{__python2} setup.py build_sphinx -b man

install -p -D -m 644 doc/build/man/nova.1 %{buildroot}%{_mandir}/man1/nova.1

# Fix hidden-file-or-dir warnings
rm -fr doc/build/html/.doctrees doc/build/html/.buildinfo

%files -n python2-%{sname}
%license LICENSE
%doc README.rst
%{python2_sitelib}/%{sname}
%{python2_sitelib}/*.egg-info
%{_sysconfdir}/bash_completion.d
%{_mandir}/man1/nova.1.gz
%{_bindir}/nova
%{_bindir}/nova-2
%{_bindir}/nova-%{python2_version}


%if 0%{?with_python3}
%files -n python3-%{sname}
%license LICENSE
%doc README.rst
%{python3_sitelib}/%{sname}
%{python3_sitelib}/*.egg-info
%{_sysconfdir}/bash_completion.d
%{_mandir}/man1/nova.1.gz
%{_bindir}/nova-3
%{_bindir}/nova-%{python3_version}
%endif

%files doc
%doc doc/build/html
%license LICENSE

%changelog
* Fri Nov 01 2019 RDO <dev@lists.rdoproject.org> 1:10.1.1-1
- Update to 10.1.1

* Tue Jun 05 2018 RDO <dev@lists.rdoproject.org> 1:10.1.0-1
- Update to 10.1.0
```



其他说明
#如果是自己手动打的tarball，最好要通过python标准的打包方式：python setup.py sdist来发布，否则会涉及到解压出来的发布软件包的版本问题.

#dist的值在/etc/rpm/macros.dist里面定义：%dist .el7.centos

用以下命令将spec文件取出。
　　$rpm -qlp *.src.rpm
　　$rpm2cpio *.src.rpm｜cpio -ivh *.spec
