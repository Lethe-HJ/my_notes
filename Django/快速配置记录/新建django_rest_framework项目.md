# 快速配置django_rest_framework新项目

1. 确保python环境正确(这里用的是python3.74)
2. `pip install virtualenv` 安装virtualenv
3. 新建项目文件夹learn,并切换到该文件夹下
4. `virtualenv --no-site-packages venv` 新建python环境
5. 进入环境
`.\venv\bin\activate`(windows) 或 `$ source venv/bin/activate`(mac或linux)
6. 安装djangorestframework`pip install djangorestframework`
7. `django-admin startproject learn1`新建django项目
8. `pip install pymysql`安装数据库驱动
9. 在learn1 app下的__init__.py中加入以下代码,来设置用pymysql驱动连接mysql

    ```python
    import pymysql
    pymysql.install_as_MySQLdb()
    ```

10. 修改settings.py中数据库连接配置

    ```python
    DATABASES = {
        'default': {
            # 数据库引擎（是mysql还是oracle等）
            'ENGINE': 'django.db.backends.mysql',
            # 数据库的名字
            'NAME': 'django_test',
            # 连接mysql数据库的用户名
            'USER': 'root',
            # 连接mysql数据库的密码
            'PASSWORD': 'hujin666..',
            # mysql数据库的主机地址
            'HOST': '127.0.0.1',
            # mysql数据库的端口号
            'PORT': '3306',
        }
    }
    ```

11. 启动django,确认成功 `python manage.py runserver`
12. 启动mariadb`net start mysql`
13. 同步数据库`python manage.py migrate`
13. 