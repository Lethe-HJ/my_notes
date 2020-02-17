# Django中ORM介绍和字段及字段参数

## Object Relational Mapping(ORM)

## Django中的ORM

### Django项目使用MySQL数据库

1. 在Django项目的settings.py文件中，配置数据库连接信息：

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "你的数据库名称",  # 需要自己手动创建数据库
        "USER": "数据库用户名",
        "PASSWORD": "数据库密码",
        "HOST": "数据库IP",
        "POST": 3306
    }
}
```

2.在Django项目的__init__.py文件中写如下代码，告诉Django使用pymysql模块连接MySQL数据库:

```python
import pymysql

pymysql.install_as_MySQLdb()
```

### Model

在Django中model是你数据的单一、明确的信息来源。它包含了你存储的数据的重要字段和行为。通常，一个模型（model）映射到一个数据库表，

基本情况：

- 每个模型都是一个Python类，它是django.db.models.Model的子类。
- 模型的每个属性都代表一个数据库字段。

![img](https://images2018.cnblogs.com/blog/867021/201803/867021-20180325235218756-104285201.png)

 
### 快速入门

下面这个例子定义了一个 **Person** 模型，包含 **first_name **和 **last_name**。

models.py

```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
```

**first_name **和 **last_name** 是模型的字段。每个字段被指定为一个类属性，每个属性映射到一个数据库列。

再执行下面两条命令

`python  manage.py makemigrations`

`python manage.py migrate`

上面的 **Person** 模型将会像这样创建一个数据库表：

```mysql
CREATE TABLE myapp_person (
    "id" serial NOT NULL PRIMARY KEY,
    "first_name" varchar(30) NOT NULL,
    "last_name" varchar(30) NOT NULL
);
```

一些说明：

-   表myapp_person的名称是自动生成的，如果你要自定义表名，需要在model的Meta类中指定 db_table 参数，强烈建议使用小写表名，特别是使用MySQL作为后端数据库时。
-   id字段是自动添加的，如果你想要指定自定义主键，只需在其中一个字段中指定 primary_key=True 即可。如果Django发现你已经明确地设置了Field.primary_key，它将不会添加自动ID列。
-   本示例中的CREATE TABLE SQL使用PostgreSQL语法进行格式化，但值得注意的是，Django会根据配置文件中指定的数据库后端类型来生成相应的SQL语句。
-   Django支持MySQL5.5及更高版本。



## ORM增删改查

###查

```python
query = models.Person.objects.all()  #查询Person表中所有记录 返回列表
for i in query:
	print(i)
```

### 增

```python
 models.Person.objects.create(first_name=first_name, last_name=last_name)
 #往Person表中添加一条记录
```



```python
from django.shortcuts import render
from app_first import models


# Create your views here.
def person_list(request):
    query = models.Person.objects.all()  
    # 查询person表里面的所有记录 返回一个列表 
    return render(request, "user_list.html", {"user_list": query})

```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>用户列表页</title>
</head>
<body>
<a href="/add_user/">添加用户</a>
<table border="1">
    <thead>
    <tr>
        <th>id</th>
        <th>姓</th>
        <th>名</th>
    </tr>
    </thead>
    <tbody>
    {% for user in user_list %}  //遍历该列表
        <tr>
        <td>{{ user.id }}</td> //获取列表中每个记录对象id属性
        <td>{{ user.first_name }}</td>//获取first_name
        <td>{{ user.last_name }}</td>//last_name
        </tr>
    {% endfor %}

    </tbody>
</table>
</body>
</html>
```



# Django ORM 常用字段和参数

## 常用字段

### AutoField

int自增列，必须填入参数 primary_key=True。当model中如果没有自增列，则自动会创建一个列名为id的列。

### IntegerField

一个整数类型,范围在 -2147483648 to 2147483647。

### CharField

字符类型，必须提供max_length参数， max_length表示字符长度。

### DateField

日期字段，日期格式  YYYY-MM-DD，相当于Python中的datetime.date()实例。

### DateTimeField

日期时间字段，格式 YYYY-MM-DD HH:MM[:ss[.uuuuuu]][TZ]，相当于Python中的datetime.datetime()实例。

## 字段合集（争取记忆）

```python
AutoField(Field)
- int自增列，必须填入参数 primary_key=True

BigAutoField(AutoField)
- bigint自增列，必须填入参数 primary_key=True

SmallIntegerField(IntegerField):
- 小整数 -32768 ～ 32767

PositiveSmallIntegerField(PositiveIntegerRelDbTypeMixin, IntegerField)
- 正小整数 0 ～ 32767
      
IntegerField(Field)
- 整数列(有符号的) -2147483648 ～ 2147483647

PositiveIntegerField(PositiveIntegerRelDbTypeMixin, IntegerField)
- 正整数 0 ～ 2147483647

BigIntegerField(IntegerField):
- 长整型(有符号的) -9223372036854775808 ～ 9223372036854775807

BooleanField(Field)
- 布尔值类型

NullBooleanField(Field):
- 可以为空的布尔值

CharField(Field)
- 字符类型
- 必须提供max_length参数， max_length表示字符长度

TextField(Field)
- 文本类型

EmailField(CharField)：
- 字符串类型，Django Admin以及ModelForm中提供验证机制

IPAddressField(Field)
- 字符串类型，Django Admin以及ModelForm中提供验证 IPV4 机制

GenericIPAddressField(Field)
- 字符串类型，Django Admin以及ModelForm中提供验证 Ipv4和Ipv6
- 参数：
protocol，用于指定Ipv4或Ipv6， 'both',"ipv4","ipv6"
unpack_ipv4， 如果指定为True，则输入::ffff:192.0.2.1时候，可解析为192.0.2.1，开启此功能，需要protocol="both"

URLField(CharField)
- 字符串类型，Django Admin以及ModelForm中提供验证 URL

SlugField(CharField)
- 字符串类型，Django Admin以及ModelForm中提供验证支持 字母、数字、下划线、连	接符（减号）

CommaSeparatedIntegerField(CharField)
- 字符串类型，格式必须为逗号分割的数字

UUIDField(Field)
- 字符串类型，Django Admin以及ModelForm中提供对UUID格式的验证

FilePathField(Field)
- 字符串，Django Admin以及ModelForm中提供读取文件夹下文件的功能
- 参数：
path,                      文件夹路径
match=None,                正则匹配
recursive=False,           递归下面的文件夹
allow_files=True,          允许文件
allow_folders=False,       允许文件夹

FileField(Field)
- 字符串，路径保存在数据库，文件上传到指定目录
- 参数：
upload_to = ""      上传文件的保存路径
storage = None      
存储组件，默认django.core.files.storage.FileSystemStorage

ImageField(FileField)
- 字符串，路径保存在数据库，文件上传到指定目录
- 参数：
upload_to = ""      上传文件的保存路径
storage = None      
存储组件，默认django.core.files.storage.FileSystemStorage
width_field=None,   上传图片的高度保存的数据库字段名（字符串）
height_field=None   上传图片的宽度保存的数据库字段名（字符串）

DateTimeField(DateField)
- 日期+时间格式 YYYY-MM-DD HH:MM[:ss[.uuuuuu]][TZ]

DateField(DateTimeCheckMixin, Field)
- 日期格式      YYYY-MM-DD

TimeField(DateTimeCheckMixin, Field)
- 时间格式      HH:MM[:ss[.uuuuuu]]

DurationField(Field)
- 长整数，时间间隔，数据库中按照bigint存储，ORM中获取的值为datetime.timedelta类型

FloatField(Field)
- 浮点型

DecimalField(Field)
- 10进制小数
- 参数：
max_digits，小数总长度
decimal_places，小数位长度

BinaryField(Field)
- 二进制类型
```



## 自定义字段（了解为主）

```python
class UnsignedIntegerField(models.IntegerField):
    def db_type(self, connection):
        return 'integer UNSIGNED'
```

自定义char类型字段：

```
class FixedCharField(models.Field):
    """
    自定义的char类型的字段类
    """
    def __init__(self, max_length, *args, **kwargs):
        super().__init__(max_length=max_length, *args, **kwargs)
        self.length = max_length

    def db_type(self, connection):
        """
        限定生成数据库表的字段类型为char，长度为length指定的值
        """
        return 'char(%s)' % self.length


class Class(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=25)
    # 使用上面自定义的char类型的字段
    cname = FixedCharField(max_length=25)
```

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

创建的表结构：

![img](https://images2017.cnblogs.com/blog/867021/201801/867021-20180119164437990-1369210170.png)

附ORM字段与数据库实际字段的对应关系

对应关系

```python
对应关系：
    'AutoField': 'integer AUTO_INCREMENT',
    'BigAutoField': 'bigint AUTO_INCREMENT',
    'BinaryField': 'longblob',
    'BooleanField': 'bool',
    'CharField': 'varchar(%(max_length)s)',
    'CommaSeparatedIntegerField': 'varchar(%(max_length)s)',
    'DateField': 'date',
    'DateTimeField': 'datetime',
    'DecimalField': 'numeric(%(max_digits)s, %(decimal_places)s)',
    'DurationField': 'bigint',
    'FileField': 'varchar(%(max_length)s)',
    'FilePathField': 'varchar(%(max_length)s)',
    'FloatField': 'double precision',
    'IntegerField': 'integer',
    'BigIntegerField': 'bigint',
    'IPAddressField': 'char(15)',
    'GenericIPAddressField': 'char(39)',
    'NullBooleanField': 'bool',
    'OneToOneField': 'integer',
    'PositiveIntegerField': 'integer UNSIGNED',
    'PositiveSmallIntegerField': 'smallint UNSIGNED',
    'SlugField': 'varchar(%(max_length)s)',
    'SmallIntegerField': 'smallint',
    'TextField': 'longtext',
    'TimeField': 'time',
    'UUIDField': 'char(32)',

对应关系
```



## 字段参数

### null

用于表示某个字段可以为空。

### **unique**

如果设置为unique=True 则该字段在此表中必须是唯一的 。

### **db_index**

如果db_index=True 则代表着为此字段设置数据库索引。

### **default**

为该字段设置默认值。

## 时间字段独有

DatetimeField、DateField、TimeField这个三个时间字段，都可以设置如下属性。

### auto_now_add

配置auto_now_add=True，创建数据记录的时候会把当前时间添加到数据库。

### auto_now

配置上auto_now=True，每次更新数据记录的时候会更新该字段。

 

# 关系字段

# ForeignKey

外键类型在ORM中用来表示外键关联关系，一般把ForeignKey字段设置在 '一对多'中'多'的一方。

ForeignKey可以和其他表做关联关系同时也可以和自身做关联关系。

## 字段参数

### to

设置要关联的表

### to_field

设置要关联的表的字段

### related_name

反向操作时，使用的字段名，用于代替原反向查询时的'表名_set'。

例如：

```python
class Classes(models.Model):
    name = models.CharField(max_length=32)

class Student(models.Model):
    name = models.CharField(max_length=32)
    theclass = models.ForeignKey(to="Classes")
```

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

当我们要查询某个班级关联的所有学生（反向查询）时，我们会这么写：

```python
models.Classes.objects.first().student_set.all()
```

当我们在ForeignKey字段中添加了参数 related_name 后，

```python
class Student(models.Model):
    name = models.CharField(max_length=32)
    theclass = models.ForeignKey(to="Classes", related_name="students")
```

当我们要查询某个班级关联的所有学生（反向查询）时，我们会这么写：

```python
models.Classes.objects.first().students.all()
```

### **related_query_name**

反向查询操作时，使用的连接前缀，用于替换表名。

### **on_delete**

当删除关联表中的数据时，当前表与其关联的行的行为。

**models.CASCADE**
删除关联数据，与之关联也删除

**models.DO_NOTHING**
删除关联数据，引发错误IntegrityError

**models.PROTECT**
删除关联数据，引发错误ProtectedError

**models.SET_NULL**
删除关联数据，与之关联的值设置为null（前提FK字段需要设置为可空）

**models.SET_DEFAULT**
删除关联数据，与之关联的值设置为默认值（前提FK字段需要设置默认值）

**models.SET**

删除关联数据，
a. 与之关联的值设置为指定值，设置：models.SET(值)
b. 与之关联的值设置为可执行对象的返回值，设置：models.SET(可执行对象)

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
def func():
    return 10

class MyModel(models.Model):
    user = models.ForeignKey(
        to="User",
        to_field="id"，
        on_delete=models.SET(func)
    )
```

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### db_constraint

是否在数据库中创建外键约束，默认为True。

# OneToOneField

一对一字段。

通常一对一字段用来扩展已有字段。

## 示例

一对一的关联关系多用在当一张表的不同字段查询频次差距过大的情况下，将本可以存储在一张表的字段拆开放置在两张表中，然后将两张表建立一对一的关联关系。

```python
class Author(models.Model):
    name = models.CharField(max_length=32)
    info = models.OneToOneField(to='AuthorInfo')
    

class AuthorInfo(models.Model):
    phone = models.CharField(max_length=11)
    email = models.EmailField()
```

 

## 字段参数

### to

设置要关联的表。

### to_field

设置要关联的字段。

### on_delete

同ForeignKey字段。

# ManyToManyField

用于表示多对多的关联关系。在数据库中通过第三张表来建立关联关系。

## 字段参数

### to

设置要关联的表

### related_name

同ForeignKey字段。

### related_query_name

同ForeignKey字段。

### symmetrical

仅用于多对多自关联时，指定内部是否创建反向操作的字段。默认为True。

举个例子：

```python
class Person(models.Model):
    name = models.CharField(max_length=16)
    friends = models.ManyToManyField("self")
```

此时，person对象就没有person_set属性。

```python
class Person(models.Model):
    name = models.CharField(max_length=16)
    friends = models.ManyToManyField("self", symmetrical=False)
```

此时，person对象现在就可以使用person_set属性进行反向查询。

### through

在使用ManyToManyField字段时，Django将自动生成一张表来管理多对多的关联关系。

但我们也可以手动创建第三张表来管理多对多关系，此时就需要通过through来指定第三张表的表名。

### **through_fields**

设置关联的字段。

### db_table

默认创建第三张表时，数据库中表的名称。

## 多对多关联关系的三种方式

### 方式一：自行创建第三张表

```python
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")


class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")


# 自己创建第三张表，分别通过外键关联书和作者
class Author2Book(models.Model):
    author = models.ForeignKey(to="Author")
    book = models.ForeignKey(to="Book")

    class Meta:
        unique_together = ("author", "book")
```

### 方式二：通过ManyToManyField自动创建第三张表

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```python
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")


# 通过ORM自带的ManyToManyField自动创建第三张表
class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")
    books = models.ManyToManyField(to="Book", related_name="authors")
```

### 方式三：设置ManyTomanyField并指定自行创建的第三张表

```python
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")


# 自己创建第三张表，并通过ManyToManyField指定关联
class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")
    books = models.ManyToManyField(to="Book", through="Author2Book", through_fields=("author", "book"))
    # through_fields接受一个2元组（'field1'，'field2'）：
    # 其中field1是定义ManyToManyField的模型外键的名（author），field2是关联目标模型（book）的外键名。


class Author2Book(models.Model):
    author = models.ForeignKey(to="Author")
    book = models.ForeignKey(to="Book")

    class Meta:
        unique_together = ("author", "book")
```

注意：

当我们需要在第三张关系表中存储额外的字段时，就要使用第三种方式。

但是当我们使用第三种方式创建多对多关联关系时，就无法使用set、add、remove、clear方法来管理多对多的关系了，需要通过第三张表的model来管理多对多关系。

## 元信息

ORM对应的类里面包含另一个Meta类，而Meta类封装了一些数据库的信息。主要字段如下:

### **db_table**

ORM在数据库中的表名默认是 **app_**类名，可以通过**db_table**可以重写表名。

### index_together

联合索引。

### unique_together

联合唯一索引。

### ordering

指定默认按什么字段排序。

只有设置了该属性，我们查询到的结果才可以被reverse()。