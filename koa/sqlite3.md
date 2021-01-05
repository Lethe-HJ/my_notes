打开sqlite命令行

`sqlite3`

打开sqlite数据库文件

`.open lol.db`

建表

`CREATE TABLE HERO(
   id INT PRIMARY KEY NOT NULL,
   ch_name CHAR(20) NOT NULL,
   en_name CHAR(20),
   nick_name CHAR(20),
   formula TEXT
);`