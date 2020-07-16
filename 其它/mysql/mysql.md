# mysql

`net start mysql`启动mysql

mysql常用管理命令
  quit;  退出服务器连接
  show databases;  显示服务器上当前所有的数据库
  use  数据库名;  进入指定的数据库
  show  tables;  显示当前数据库中所有的数据表
  desc  表名;  描述表中都有哪些列(表头)

## 常用的SQL命令
  
  (1)丢弃指定的数据库，如果存在的话
   DROP  DATABASE  IF  EXISTS  xuezi;
  (2)创建新的数据库
   CREATE  DATABASE  xuezi;
  (3)进入创建的数据库
   USE  xuezi;
  (4)创建保存数据的表
   CREATE  TABLE  student(
     sid  INT,
     name  VARCHAR(8),
     sex  VARCHAR(1),
     score  INT
   );
  (5)向数据表中插入数据
   INSERT INTO  student  VALUES('1','tom','m','85');
  (6)查询表中所有的数据
   SELECT * FROM  student;
  (7)修改数据
   UPDATE student SET name='lucy',score='100' WHERE  sid='2';
  (8)删除数据
   DELETE  FROM  student  WHERE  sid='3';

## 标准SQL命令分类

DDL: Data Define Language 定义数据结构
 CREATE/DROP/ALTER
DML: Data Manipulate Languge 操作数据
 INSERT/UPDATE/DELETE
DQL: Data Query Language 查询数据
 SELECT
DCL: Data Control Language 控制用户权限
 GRANT(授权)/REVOKE(收权)

## 计算机存储字符

 (1)如何存储英文字符
  ASCII: 总共有128个,对所有的英文字母和符号进行编码
     abc    979898
  Latin-1: 总共有256，兼容ASCII码，同时对欧洲符号进行了编码，mysql默认使用这种编码。
 (2)如何存储中文字符
  GB2312: 对常用的6千多汉字进行编码，兼容ASCII码
  GBK: 对2万多汉字进行了编码，兼容GB2312
  BIG5: 台湾繁体字编码，兼容ASCII码
  Unicode: 对世界上主流的国家常用的语言进行了编码，兼容ASCII，不兼容GB2312,GBK,BIG5，具体分为UTF-8，UTF-16，UTF-32存储方案
 (3)解决mysql存储中文乱码
  使用UTF-8编码形式
   sql脚本文件另存为的编码
   客户端连接服务器的编码(SET NAMES UTF8)
   服务器端创建数据库使用的编码(CHARSET=UTF8)

### mysql中的列类型

 创建数据表的时候，指定的列可以存储的数据类型
  CREAT  TABLE  book( bid 列类型 );
  (1)数值类型——引号可加可不加
    TINYINT  微整型，占1个字节  范围-128~127
    SMALLINT 小整型，占2个字节 范围-32768~32767
    INT  整型，占4个字节
         范围 -2147483648~2147483647
    BIGINT  大整型，占8个字节

    FLOAT(M,D)  单精度浮点型，占4个字节，范围3.4E38，范围比INT大的多，可能产生计算误差。
    DOUBLE(M,D)  双精度浮点型，占8个字节，范围比BIGINT大的多
    DECIMAL(M,D)  定点小数，不会产生计算误差，M代表总的有效位数，D代表小数点后的有效位数
    BOOL  布尔型，只有两个结果TRUE、FALSE(不能加引号)，真正存储数据的时候，会自动变成1和0；也可以直接使用1和0；数据库的列类型自动变成TINYINT
  (2)日期时间类型——必须加引号
    DATE  日期型   '2018-12-31'
    TIME  时间型   '14:37:30'
    DATETIME  日期时间型   '2018-12-31 14:37:30'
  (3)字符串类型——必须加引号
    VARCHAR(M)  变长字符串，不会产生空间浪费，操作速度相对慢，M的最大值是65535
    CHAR(M)  定长字符串，可能产生空间浪费，操作速度快，用于存储手机号码、身份证号等固定长度字符，M最大值是255
    TEXT(M)  大型变长字符串，M最多存2G

                a           ab          abc         abcde       一二三
    CHAR(5)     a\0\0\0\0   ab\0\0\0    abc\0\0     abcde       一二三\0\0
    VARCHAR(5)  a\0         ab\0        abc\0       abcde       一二三\0

    ```sql
    CREATE  TABLE  t1(u
    id  INT,
    age  TINYINT,
    commentCount  INT,
    price  DECIMAL(6,2),     #9999.99
    phone  CHAR(11),
    article  VARCHAR(3000),
    sex  BOOL,   #1 男  0女
    pubTime  DATE
    );
    ```

3.列约束
 mysql可以对插入的数据进行特定的验证，只有满足条件才允许插入到数据表中，否则认为是非法的插入。
 (1)主键约束——PRIMARY KEY
  声明了主键约束的列上不能出现重复的值，表中查询的记录会按照主键从小到大排序——加快查找速度；通常主键添加到编号列中。
  注意：一个表中只能出现一个主键，主键列上不允许插入NULL。
NULL表示空，在插入数据时，无法确定要保存的值；
例如：无法确定员工的工资、姓名、声明...