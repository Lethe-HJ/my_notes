## helloworld

### 编写
hello_world.sh
```shell
#!/bin/bash
echo "Hello World !"
```
> #! 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种 Shell
> echo 命令用于向窗口输出文本

### 运行脚本

#### 作为可执行程序

`chmod +x ./hello_world.sh` #使脚本具有执行权限
`./hello_world.sh` #执行脚本

> `./hello_world.sh` 在当前目录查找并运行hello_world.sh
> 直接写`hello_world.sh`， linux 系统会去 PATH 里寻找有没有叫 hello_world.sh 的

#### 作为解释器参数

`/bin/sh hello_world.sh`

> 这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。 

## 变量

### 变量的使用

```shell
# 显式赋值
your_name="lethe"
echo $your_name
# 使用变量的时候加$
# 用语句给变量赋值
for file in `ls /etc`
# 或
for file in $(ls /etc)
# 以上语句将 /etc 下目录的文件名循环出来

for skill in Ada Coffe Action Java; do
 echo "I am good at ${skill}Script"
done
# 打印如下
# I am good at AdaScript
# I am good at CoffeScript
# I am good at ActionScript
# I am good at JavaScript
# 变量名外面的花括号是可选的，加花括号是为了帮助解释器识别变量的边界
# 这里应该单独将skill看成一个变量 而不是skillScript

# 已定义的变量，可以被重新定义
your_name="hujin"
echo $your_name
# 第二次赋值的时候不能写$your_name="hujin"

# 只读变量
myUrl="http://www.google.com"
readonly myUrl
myUrl="http://www.runoob.com"
# 报错/bin/sh: NAME: This variable is read only.

# 删除变量
myUrl="http://www.runoob.com"
unset myUrl

```
### 变量类型

> 局部变量: 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
> 环境变量: 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
> shell变量: shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量

## Shell 字符串

### 单引号

```shell
str='this is a string'
# 单引号里的任何字符都会原样输出
# 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行）
```

### 双引号 

```shell
your_name='runoob'
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
# 输出结果Hello, I know you are "runoob"! 
# 双引号里可以有变量，可以出现转义字符
```

### 拼接字符串

```shell
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
# hello, runoob !

# 使用单引号拼接
greeting_2='hello, '$your_name' !'
#hello, runoob !
```

### 获取字符串长度

```shell
string="abcd"
echo ${#string} #输出 4
```

### 提取子字符串 

```shell
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

### 查找子字符串

```shell
string="runoob is a great site"
echo `expr index "$string" io` # 输出 4
# 以上脚本中 ` 是反引号，而不是单引号 '
```

## Shell 数组

### 数组的定义与赋值

```shell
array_name=(value0 value1 value2 value3)
# 或者
array_name=(
value0
value1
value2
value3
)

# 还可以单独定义数组的各个分量： 
array_name[0]=value0

```

### 读取数组

```shell
# 读取数组元素的值
valuen=${array_name[n]}

# 使用 @ 符号可以获取数组中的所有元素
echo ${array_name[@]}
```

### 获取数组的长度

```shell
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

## 注释

### 单行注释

在需要注释的行开头加#即可

### 多行注释

```shell
:<<EOF
注释内容...
注释内容...
注释内容...
EOF

EOF 也可以使用其他符号:

:<<'
注释内容...
注释内容...
注释内容...
'

:<<!
注释内容...
注释内容...
注释内容...
!

```

## shell传递参数

我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。
n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推，其中 $0 为执行的文件名
`$#` 传递到脚本或函数的参数个数
`$*` 以一个单字符串显示所有向脚本传递的参数。
`$@` 与$*相同，但是使用时加引号，并在引号中返回每个参数。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
`$$` 脚本运行的当前进程ID号
`$!` 后台运行的最后一个进程的ID号如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
`$-` 显示Shell使用的当前选项，与set命令功能相同。
`$?` 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错

## Shell 基本运算符

### 算术运算符

`expr` 是一款表达式计算工具，使用它能完成表达式的求值操作。
```shell


val=`expr 2 + 2`
echo "两数之和为 : $val"
# 完整的表达式要被 ` ` 包含， 表达式和运算符之间要有空格
```
| 运算符 | 含义   | 说明                                                         |
| :----- | :----- | :----------------------------------------------------------- |
| `+`    | 加法   | `expr $a + $b` 结果为 30                                     |
| `-`    | 减法   | `expr $a - $b` 结果为 -10                                    |
| `*`    | 乘法   | `expr $a \* $b` 结果为 200                                   |
| `/`    | 除法   | `expr $b / $a` 结果为 2                                      |
| `%`    | 取余   | `expr $b % $a` 结果为 0                                      |
| `=`    | 赋值   | `a=$b` 将把变量 b 的值赋给 a                                 |
| `==`   | 相等   | 用于比较两个数字，相同则返回 true。`[ $a == $b ]` 返回 false |
| `!=`   | 不相等 | 用于比较两个数字，不相同则返回 true                          |

*注意 条件表达式要放在方括号之间，并且要有空格*
*乘号(*)前边必须加反斜杠\才能实现乘法运算*

### 关系运算符
| 运算符 | 说明                                                  | 举例                         |
| :----- | :---------------------------------------------------- | :--------------------------- |
| `-eq`  | 检测两个数是否相等，相等返回 true。                   | `[ $a -eq $b ]` 返回 false。 |
| `-ne`  | 检测两个数是否不相等，不相等返回 true。               | `[ $a -ne $b ]` 返回 true。  |
| `-gt`  | 检测左边的数是否大于右边的，如果是，则返回 true。     | `[ $a -gt $b ]` 返回 false。 |
| `-lt`  | 检测左边的数是否小于右边的，如果是，则返回 true。     | `[ $a -lt $b ]` 返回 true。  |
| `-ge`  | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | `[ $a -ge $b ]` 返回 false。 |
| `-le`  | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | `[ $a -le $b ]` 返回 true。  |

### 布尔运算符

| 运算符 | 说明                                                | 举例                                       |
| :----- | :-------------------------------------------------- | :----------------------------------------- |
| `!`    | 非运算，表达式为 true 则返回 false，否则返回 true。 | `[ ! false ]` 返回 true。                  |
| `-o`   | 或运算，有一个表达式为 true 则返回 true。           | `[ $a -lt 20 -o $b -gt 100 ]` 返回 true。  |
| `-a`   | 与运算，两个表达式都为 true 才返回 true。           | `[ $a -lt 20 -a $b -gt 100 ]` 返回 false。 |

### 逻辑运算符

| 运算符 | 说明       | 举例                                        |
| :----- | :--------- | :------------------------------------------ |
| `&&`   | 逻辑的 AND | `[[ $a -lt 100 && $b -gt 100 ]]` 返回 false |
| `||`   | 逻辑的 OR  | `[[ $a -lt 100 || $b -gt 100 ]]` 返回 true  |

### 字符串运算符

下表列出了常用的字符串运算符，假定变量 a 为 "abc"，变量 b 为 "efg"：
| 运算符 | 说明                                      | 举例                       |
| :----- | :---------------------------------------- | :------------------------- |
| `=`    | 检测两个字符串是否相等，相等返回 true。   | `[ $a = $b ]` 返回 false。 |
| `!= `  | 检测两个字符串是否相等，不相等返回 true。 | `[ $a != $b ]` 返回 true。 |
| `-z`   | 检测字符串长度是否为0，为0返回 true。     | `[ -z $a ]` 返回 false。   |
| `-n`   | 检测字符串长度是否为0，不为0返回 true。   | `[ -n "$a" ]` 返回 true。  |
| `$`    | 检测字符串是否为空，不为空返回 true。     | `[ $a ]` 返回 true。       |

### 文件测试运算符

文件测试运算符用于检测 Unix 文件的各种属性。num1="ru1noob"
num2="runoob"
if [ $num1 == $num2 ]
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi

if test $num1 == $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi

属性检测描述如下
| 操作符    | 说明                                                                        | 举例                        |
| :-------- | :-------------------------------------------------------------------------- | :-------------------------- |
| `-b file` | 检测文件是否是块设备文件，如果是，则返回 true。                             | `[ -b $file ]` 返回 false。 |
| `-c file` | 检测文件是否是字符设备文件，如果是，则返回 true。                           | `[ -c $file ]` 返回 false。 |
| `-d file` | 检测文件是否是目录，如果是，则返回 true。                                   | `[ -d $file `] 返回 false。 |
| `-f file` | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | `[ -f $file ]` 返回 true。  |
| `-g file` | 检测文件是否设置了 SGID 位，如果是，则返回 true。                           | `[ -g $file ]` 返回 false。 |
| `-k file` | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。                 | `[ -k $file ]` 返回 false。 |
| `-p file` | 检测文件是否是有名管道，如果是，则返回 true。                               | `[ -p $file ]` 返回 false。 |
| `-u file` | 检测文件是否设置了 SUID 位，如果是，则返回 true。                           | `[ -u $file ]` 返回 false。 |
| `-r file` | 检测文件是否可读，如果是，则返回 true。                                     | `[ -r $file ]` 返回 true。  |
| `-w file` | 检测文件是否可写，如果是，则返回 true。                                     | `[ -w $file ]` 返回 true。  |
| `-x file` | 检测文件是否可执行，如果是，则返回 true。                                   | `[ -x $file ]` 返回 true。  |
| `-s file` | 检测文件是否为空（文件大小是否大于0），不为空返回 true。                    | `[ -s $file ]` 返回 true。  |
| `-e file` | 检测文件（包括目录）是否存在，如果是，则返回 true。                         | `[ -e $file ]` 返回 true。  |

其他检查符：
`-S`: 判断某文件是否 socket。
`-L`: 检测文件是否存在并且是一个符号链接。 

## Shell echo命令

### 显示普通字符串
```shell
echo "It is a test"

# 这里的双引号完全可以省略，以下命令与上面实例效果一致：
echo It is a test
```

### 显示转义字符
```shell
echo "\"It is a test\""
# "It is a test"

# 同样，双引号也可以省略
```

### 显示变量

```shell
name = "hujin"
echo "$name It is a test"
```

### 显示换行与否

```shell
echo -e "OK! \n" # -e 开启转义
echo -e "OK! \c" # -e 开启转义 \c 不换行
```

### 显示结果定向至文件

```shell
echo "It is a test" > myfile
```

### 显示命令执行结果
```shell
echo `date`
# 这里使用的是反引号 `, 而不是单引号 '
```

## Shell printf 命令

```shell
# printf  format-string  [arguments...]
#参数说明：
#format-string: 为格式控制字符串
#arguments: 为参数列表。

printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
```

### printf的转义

| 序列    | 说明                                             |
| :------ | :----------------------------------------------- |
| `\a`    | 警告字符，通常为ASCII的BEL字符                   |
| `\b`    | 后退                                             |
| `\c`    | 抑制（不显示）输出结果中任何结尾的换行字符       |
| `\f`    | 换页（formfeed）                                 |
| `\n`    | 换行                                             |
| `\r`    | 回车（Carriage return）                          |
| `\t`    | 水平制表符                                       |
| `\v`    | 垂直制表符                                       |
| `\\`    | 一个字面上的反斜杠字符                           |
| `\ddd`  | 表示1到3位数八进制值的字符。仅在格式字符串中有效 |
| `\0ddd` | 表示1到3位的八进制值字符                         |
*注意`\c`（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略*

## test

### 数值测试

```shell
a=5
b=6

result=$[a+b] # 注意等号两边不能有空格
# [] 执行基本的算数运算 $用于取值
echo "result 为： $result"
```

### 字符串测试

```shell
num1="ru1noob"
num2="runoob"
if [ $num1 == $num2 ]
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi

if test $num1 == $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi
```

### 文件测试

```shell
if test -e ./bash
then
    echo '文件已存在!'
else
    echo '文件不存在!'
fi
```

### 逻辑连接

Shell提供了与`-a`、或`-o`、非`!` 三个逻辑操作符用于将测试条件连接起来，其优先级为：`!`最高，`-a`次之，`-o`最低
```shell
if test -e ./notFile -o -e ./bash
then
    echo '至少有一个文件存在!'
else
    echo '两个文件都不存在'
fi
```


## 流程控制

### if-else

写成一行（适用于终端命令提示符）
```shell
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```

判断两个变量是否相等
```shell
a=10
b=20
if [ $a == $b ]
then
   echo "a 等于 b"
elif [ $a -gt $b ]
then
   echo "a 大于 b"
elif [ $a -lt $b ]
then
   echo "a 小于 b"
else
   echo "没有符合的条件"
fi
```
if else语句经常与test命令结合使用，如下所示：
```shell
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo '两个数字相等!'
else
    echo '两个数字不相等!'
fi
```

### for

写成一行（适用于终端命令提示符）
```shell
for var in item1 item2 ... itemN; do command1; command2… done;
```

顺序输出当前列表中的数字：

```shell
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

顺序输出字符串中的字符：

```shell
for str in 'This is a string'
do
    echo $str
done
```

### while

```shell
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done
#  let 命令，它用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量
```

while循环可用于读取键盘信息。下面的例子中，输入信息被设置为变量FILM，按<Ctrl-D>结束循环。
```shell
echo '按下 <CTRL-D> 退出'
echo -n '输入你最喜欢的网站名: '
while read FILM
do
    echo "是的！$FILM 是一个好网站"
done
```

### until
```shell
a=0
until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
```

### case
```shell
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```

### break
跳出循环，终止后面的所有循环

### continue
跳出当前这次循环，继续下一次循环

### 无限循环

无限循环语法格式
```shell
while :
do
    command
done
# 或者
while true
do
    command
done
# 或者
for (( ; ; ))
```

## Shell 函数

### 函数定义
shell中函数的定义格式如下：
```shell
[ function ] funname [()]

{

    action;

    [return int;]

}
```
> 说明：
> 1、可以带`function fun()` 定义，也可以直接`fun()` 定义,不带任何参数。
> 2、参数返回，可以显示加`return` 返回，如果不加，将以最后一条命令运行结果，作为返回值。 return后跟数值n(0-255)
> 3、函数返回值在调用该函数后通过 `$?` 来获得。

举例
```shell
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```

### 函数参数
在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，例如，$1表示第一个参数，$2表示第二个参数... 

```shell
funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```
`$10` 不能获取第十个参数，获取第十个参数需要`${10}`。当n>=10时，需要使用`${n}`来获取参数

## Shell 输入/输出重定向

重定向命令

| 命令            | 说明                                               |
| :-------------- | :------------------------------------------------- |
| `command > file`  | 将输出重定向到 file。                              |
| `command < file`  | 将输入重定向到 file。                              |
| c`ommand >> file` | 将输出以追加的方式重定向到 file。                  |
| `n > file`        | 将文件描述符为 n 的文件重定向到 file。             |
| `n >> file`       | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| `n >& m `         | 将输出文件 m 和 n 合并。                           |
| `n <& m`          | 将输入文件 m 和 n 合并。                           |
| `<< tag`          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

*需要注意的是文件描述符 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。*

执行下面的 who 命令，它将命令的完整的输出重定向在用户文件中(users):
```shell
who > users
```
执行后，并没有在终端输出信息，这是因为输出已被从默认的标准输出设备（终端）重定向到指定的文件。

你可以使用 `cat` 命令查看文件内容


一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：

+ 标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
+ 标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
+ 标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

默认情况下，command > file 将 stdout 重定向到 file，command < file 将stdin 重定向到 file。

如果希望 stderr 重定向到 file，可以这样写：

$ command 2 > file

如果希望 stderr 追加到 file 文件末尾，可以这样写：

$ command 2 >> file

2 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：

$ command > file 2>&1

或者

$ command >> file 2>&1

如果希望对 stdin 和 stdout 都重定向，可以这样写：

$ command < file1 >file2

command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。 

### Here Document

 Here Document 是 Shell 中的一种特殊的重定向方式，用来将输入重定向到一个交互式 Shell 脚本或程序。

它的基本的形式如下：
```shell
command << delimiter
    document
delimiter
```
它的作用是将两个 delimiter 之间的内容(document) 作为输入传递给 command。

注意：
结尾的delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符，包括空格和 tab 缩进。
开始的delimiter前后的空格会被忽略掉。

```shell
$ cat << EOF
欢迎来到
菜鸟教程
www.runoob.com
EOF
```

### /dev/null 文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：
```shell
$ command > /dev/null
```
/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到"禁止输出"的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：
```shell
$ command > /dev/null 2>&1
```

*注意：0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。*

## Shell 文件包含
Shell 可以包含外部脚本。这样可以很方便的封装一些公用的代码作为一个独立的文件。

Shell 文件包含的语法格式如下：
```shell
. filename   # 注意点号(.)和文件名中间有一空格

# 或
source filename
```

test2.sh 
```shell
#使用 . 号来引用test1.sh 文件
. ./test1.sh

# 或者使用以下包含文件代码
# source ./test1.sh
```
接下来，我们为 test2.sh 添加可执行权限并执行：
```shell
$ chmod +x test2.sh 
$ ./test2.sh
```