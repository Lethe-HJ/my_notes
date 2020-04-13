# python开发环境

## virtualenv

### 安装virtualenv

`$ pip install virtualenv`

### 新建环境

#### 使用环境变量指定的python新建环境

使用环境变量指定的python在项目根目录下创建一个独立的Python运行环境，命名为venv：
`$ virtualenv --no-site-packages venv`

`--no-site-packages` 不复制 系统Python环境中的第三方包 20版本没有这个参数

`--system-site-packages`是否继承系统三方库,项目检索库的时候，也会到系统的三方库中找
不添加时，默认只到虚拟环境中查找库

`virtualenv --system-site-packages ENV`

指定Python版本
`virtualenv -p /usr/local/bin/python2.7 testvirtual2`

#### 进入环境

mac使用source进入环境
`.\venv\bin\activate` 或`$ source venv/bin/activate`

退出当前的venv环境

`$ deactivate`

## 更换源

pip国内的一些镜像

  阿里云 http://mirrors.aliyun.com/pypi/simple/ 
  中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/ 
  豆瓣(douban) http://pypi.douban.com/simple/ 
  清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/ 
  中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

### 修改源方法

#### 临时使用

可以在使用pip的时候在后面加上-i参数，指定pip源 
eg: pip install scrapy -i https://pypi.tuna.tsinghua.edu.cn/simple   --trusted-host  pypi.tuna.tsinghua.edu.cn

#### 永久修改

##### linux

修改 ~/.pip/pip.conf (没有就创建一个)， 内容如下：

[global]
timeout = 60
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com

##### windows

直接在user目录中创建一个pip目录，如：C:\Users\xx\pip，新建文件pip.ini，内容如下

[global]
timeout = 60
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com


## python版本切换

打开终端分别输入下面两条命令：

`sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100`   
`sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150`

然后再终端输入：

    python

如果无误，此时python版本应该切换到默认的python3了。

如果需要重新切换回python只需要在终端输入：

`sudo update-alternatives --config python`

然后选者你需要的python版本，输入序号回车即可


## 解决Python2 pip问题

yum install epel-release -y

yum -y install python-pip

pip install --upgrade pip

pip -V


## 安装Python3

yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

wget https://www.python.org/ftp/python/3.6.6/Python-3.6.6.tar.xz

tar -xvJf Python-3.6.6.tar.xz

cd Python-3.6.6

./configure prefix=/usr/local/python3

make && make install

ln -s /usr/local/python3/bin/python3 /usr/bin/python3

cd /usr/local/python3/bin/

ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

pip3 install --upgrade pip

pip3 -V