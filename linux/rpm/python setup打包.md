## 简单示例

新建hello/hello.py文件
```python
print "hello world!"
```
同目录下新建hello/setup.py文件
```python
from distutils.core import setup
setup(name = 'hello',
    version = '1.0',
    description = 'A simple example',
    author = 'hujin',
    py_modules = ['hello'])
```

执行`python setup.py build`
输出
running build
running build_py
creating build
creating build/lib
copying hello.py -> build/lib

当前目录会生成build/lib/hello.py这样的路径
此时的目录结构为
hello/
├── build
│   └── lib
│       └── hello.py
├── hello.py
└── setup.py

执行`python setup.py install`
输出
running install
running build
running build_py
running install_lib
copying build/lib/hello.py -> /usr/lib/python2.7/site-packages
byte-compiling /usr/lib/python2.7/site-packages/hello.py to hello.pyc
running install_egg_info
Writing /usr/lib/python2.7/site-packages/hello-1.0-py2.7.egg-info

hello包会安装到默认的python解释器路径下的site-packages目录下

执行`python setup.py sdist`
输出
running sdist
running check
writing manifest file 'MANIFEST'
creating hello-1.0
making hard links in hello-1.0...
hard linking hello.py -> hello-1.0
hard linking setup.py -> hello-1.0
creating dist
Creating tar archive
removing 'hello-1.0' (and everything under it)

hello会被打包成hello-1.0.tar.gz 放到/hello/dist目录下

此时的目录结构为
hello/
├── build
│   └── lib
│       └── hello.py
├── dist
│   └── hello-1.0.tar.gz
├── hello.py
├── MANIFEST
└── setup.py

hello-1.0.tar.gz解压缩之后文件结构为
hello-1.0
├── hello.py
├── PKG-INFO
└── setup.py
