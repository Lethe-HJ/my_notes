## PHP 标记

当解析一个文件时，PHP 会寻找起始和结束标记，也就是 <?php 和 ?>，这告诉 PHP 开始和停止解析二者之间的代码。此种解析方式使得 PHP 可以被嵌入到各种不同的文档中去，而任何起始和结束标记之外的部分都会被 PHP 解析器忽略。

PHP 也允许使用短标记 <? 和 ?>，但不鼓励使用。只有通过激活 php.ini 中的 short_open_tag 配置指令或者在编译 PHP 时使用了配置选项 --enable-short-tags 时才能使用短标记。

如果文件内容是纯 PHP 代码，最好在文件末尾删除 PHP 结束标记。这可以避免在 PHP 结束标记之后万一意外加入了空格或者换行符，会导致 PHP 开始输出这些空白，而脚本中此时并无输出的意图。 

PHP 开始和结束标记
```php
<?php echo 'if you want to serve XHTML or XML documents, do it like this'; ?>
<script language="php">
    echo 'some editors (like FrontPage) don\'t
    like processing instructions';
</script>
```

## 与html混合
可以使 PHP 嵌入到 HTML 文档中去，如下例所示。
<p>This is going to be ignored by PHP and displayed by the browser.</p>
<?php echo 'While this is going to be parsed.'; ?>
<p>This will also be ignored by PHP and displayed by the browser.</p>
这将如预期中的运行，因为当 PHP 解释器碰到 ?> 结束标记时就简单地将其后内容原样输出（除非马上紧接换行 - 见指令分隔符）直到碰到下一个开始标记；例外是处于条件语句中间时，此时 PHP 解释器会根据条件判断来决定哪些输出，哪些跳过。见下例。

使用条件结构： 

```php
<?php if ($expression == true): ?>
  This will show if the expression is true.
<?php else: ?>
  Otherwise this will show.
<?php endif; ?>
```


## php的数据类型

PHP 支持 9 种原始数据类型。

四种标量类型：
boolean（布尔型）
integer（整型）
float（浮点型，也称作 double)
string（字符串）

三种复合类型：
array（数组）
object（对象）
callable（可调用）

最后是两种特殊类型：
resource（资源）
NULL（无类型）

伪类型：
mixed（混合类型）
number（数字类型）
callback（回调类型，又称为 callable）
array|object（数组 | 对象类型）
void （无类型）

以及伪变量 $...

查看某个表达式的值和类型，用 `var_dump()` 函数
得到一个易读懂的类型的表达方式用于调试，用 `gettype()`函数。
要检验某个类型，用 `is_type()` 函数

```php

<?php
$a_bool = TRUE;   // 布尔值 boolean
$a_str  = "foo";  // 字符串 string
$a_str2 = 'foo';  // 字符串 string
$an_int = 12;     // 整型 integer

echo gettype($a_bool); // 输出:  boolean
echo gettype($a_str);  // 输出:  string

// 如果是整型，就加上 4
if (is_int($an_int)) {
    $an_int += 4;
}

// 如果 $bool 是字符串，就打印出来
// (啥也没打印出来)
if (is_string($a_bool)) {
    echo "String: $a_bool";
}
?>
```

如果要将一个变量强制转换为某类型，可以对其使用强制转换或者 `settype()` 函数

### Boolean 布尔类型
使用常量 TRUE 或 FALSE。两个都不区分大小写
$foo = True;
$foo = TRUE;


== 是一个操作符，它检测两个变量是否相等，并返回一个布尔值
当运算符，函数或者流程控制结构需要一个 boolean 参数时，该值会被自动转换

当转换为 boolean 时，以下值被认为是 FALSE：

    布尔值 FALSE 本身
    整型值 0（零）
    浮点型值 0.0（零）
    空字符串，以及字符串 "0"
    不包括任何元素的数组
    特殊类型 NULL（包括尚未赋值的变量）
    从空标记生成的 SimpleXML 对象

所有其它值都被认为是 TRUE（包括任何资源 和 NAN）。 


### Integer 整型

```php
<?php
$a = 1234; // 十进制数
$a = -123; // 负数
$a = 0123; // 八进制数 (等于十进制 83)
$a = 0x1A; // 十六进制数 (等于十进制 26)
$a = 0b11111111; // 二进制数字 (等于十进制 255)
?>
```
字长`PHP_INT_SIZE`
最大值`PHP_INT_MAX`
最小值`PHP_INT_MIN`


整数溢出
64 位平台下的最大值通常是大约 9E18
如果给定的一个数超出了 integer 的范围，将会被解释为 float。同样如果执行的运算结果超出了 integer 范围，也会返回 float。 

PHP 中没有整除的运算符。1/2 产生出 float 0.5。 值可以舍弃小数部分，强制转换为 integer，或者使用 round() 函数可以更好地进行四舍五入

要明确地将一个值转换为 integer，用 (int) 或 (integer) 强制转换。不过大多数情况下都不需要强制转换，因为当运算符，函数或流程控制需要一个 integer 参数时，值会自动转换。还可以通过函数 intval() 来将一个值转换成整型。 

从布尔值转换
FALSE 将产生出 0，TRUE 将产生出 1

从浮点型转换
当从浮点数转换成整数时，将向下取整。 

### Float 浮点型

```php
<?php
$a = 1.234; 
$b = 1.2e3; 
$c = 7E-10;
?>
```


NaN

某些数学运算会产生一个由常量 NAN 所代表的结果。此结果代表着一个在浮点数运算中未定义或不可表述的值。任何拿此值与其它任何值（除了 TRUE）进行的松散或严格比较的结果都是 FALSE。

由于 NAN 代表着任何不同值，不应拿 NAN 去和其它值进行比较，包括其自身，应该用 is_nan() 来检查。

### String 字符串

一个字符串 string 就是由一系列的字符组成，其中每个字符等同于一个字节。这意味着 PHP 只能支持 256 的字符集，因此不支持 Unicode

单引号字符串只能转义`\'`和`\\`,其他特殊字符的转义以及变量都不会被替换掉
双引号能够转义特殊字符,能够替换变量

heredoc
```php
<?php 
$str = <<<EOD
Example of string
spanning multiple lines
using heredoc syntax.
EOD;
```

nowdoc

```php
<?php
$str = <<<'EOD'
Example of string
spanning multiple lines
using nowdoc syntax.
EOD;

```


字符串的变量解析

当 PHP 解析器遇到一个美元符号（$）时，它会和其它很多解析器一样，去组合尽量多的标识以形成一个合法的变量名。可以用花括号来明确变量名的界线。 
一个 array 索引或一个 object 属性也可被解析。数组索引要用方括号（]）来表示索引结束的边际，对象属性则是和上述的变量规则相同。 

花括号可以使用表达式
```php
echo "This is {$great}";
echo "This is ${great}";
```

字符串的获取与修改

```php
// 取得字符串的第三个字符
$third = $str[2];

// 取得字符串的最后一个字符
$str = 'This is still a test.';
$last = $str[strlen($str)-1]; 

// 修改字符串的最后一个字符
$str = 'Look at the sea';
$str[strlen($str)-1] = 'e';
```