# python开发环境

## virtualenv

### 安装virtualenv

`$ pip install virtualenv`

### 新建环境

#### 使用环境变量指定的python新建环境

使用环境变量指定的python在项目根目录下创建一个独立的Python运行环境，命名为venv：
`$ virtualenv --no-site-packages venv`

`--no-site-packages` 不复制 系统Python环境中的第三方包

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
index-url = https://pypi.tuna.tsinghua.edu.cn/simple

##### windows

直接在user目录中创建一个pip目录，如：C:\Users\xx\pip，新建文件pip.ini，内容如下

[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple

