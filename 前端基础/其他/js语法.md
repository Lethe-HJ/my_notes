HTML 定义了网页的内容
CSS 描述了网页的布局
JavaScript 网页的行为

直接写入 HTML 输出流
document.write("<h1>这是一个标题</h1>");

对事件的反应
<button type="button" onclick="alert('欢迎!')">点我!</button>

改变 HTML 内容
x=document.getElementById("demo");  //查找元素
x.innerHTML="Hello JavaScript";    //改变内容


ECMAScript 版本
2015	ECMAScript 6	添加类和模块
2016	ECMAScript 7	增加指数运算符 (**) 增加 Array.prototype.includes

HTML 中的脚本必须位于 <script> 与 </script> 标签之间。
脚本可被放置在 HTML 页面的 <body> 和 <head> 部分中。
脚本也可以放在外部<script src="myScript.js"></script>

## 输出

使用 window.alert() 弹出警告框。
使用 document.write() 方法将内容写到 HTML 文档中。
使用 innerHTML 写入到 HTML 元素。
使用 console.log() 写入到浏览器的控制台。

## JavaScript 字符集
JavaScript 使用 Unicode 字符集。

对代码行进行折行
document.write("你好 \
世界!");
不过，不能像这样折行：
document.write \
("你好世界!");

## 变量声明
您可以在一条语句中声明很多变量。该语句以 var 开头，并使用逗号分隔变量即可：
var lastname="Doe", age=30, job="carpenter";

声明也可横跨多行：

var lastname="Doe",
age=30,
job="carpenter";
一条语句中声明的多个不可以赋同一个值:
var x,y,z=1;
x,y 为 undefined， z 为 1。

未使用值来声明的变量，其值实际上是 undefined

如果重新声明 JavaScript 变量，该变量的值不会丢失：

在以下两条语句执行后，变量 carname 的值依然是 "Volvo"：
var carname="Volvo";
var carname;

如果您把值赋给尚未声明的变量，该变量将被自动作为 window 的一个属性。
如果变量在函数内没有声明（没有使用 var 关键字），该变量为全局变量

typeof 操作符 检测变量的数据类型
```js
typeof "John"
```

null
在 JavaScript 中 null 表示 "什么都没有"。
null是一个只有一个值的特殊类型。表示一个空对象引用。
```js
var person = null;           // 值为 null(空), 但类型为对象
var person = undefined;     // 值为 undefined, 类型为 undefined
```

undefined
在 JavaScript 中, undefined 是一个没有设置值的变量。
typeof 一个没有值的变量会返回 undefined。 

null 和 undefined 的值相等，但类型不等：

null的使用场景
null——表示一个变量将来可能指向一个对象。
一般用于主动释放指向对象的引用

## 类型转换

constructor 属性返回所有 JavaScript 变量的构造函数。

```js
"John".constructor                 // 返回函数 String()  { [native code] }
```

可以使用 constructor 属性来查看对象是否为数组 (包含字符串 "Array"):
```js
function isArray(myArray) {
    return myArray.constructor.toString().indexOf("Array") > -1;
} 
```

全局方法 String() 可以将数字转换为字符串。
该方法可用于任何类型的数字，字母，变量，表达式：
```js
String(x)
```

Number 方法 toString() 也是有同样的效果。
```js
(123).toString()
```

toExponential() 	把对象的值转换为指数计数法。
toFixed() 	把数字转换为字符串，结果的小数点后有指定位数的数字。
toPrecision() 	把数字格式化为指定的长度。


## 数组Array

### 声明

```js
//方式一
var cars=["Saab","Volvo","BMW"];

//方式二
var cars=new Array();
cars[0]="Saab";

//方式三
var cars=new Array("Saab","Volvo","BMW");

//方式四
var cars=new Array(3).fill("ss");

```

属性
constructor	返回创建数组对象的原型函数。
length	设置或返回数组元素的个数。
prototype	允许你向数组对象添加属性或方法。

方法
concat()	连接两个或更多的数组，并返回结果。
copyWithin()	从数组的指定位置拷贝元素到数组的另一个指定位置中。
entries()	返回数组的可迭代对象。
every()	检测数值元素的每个元素是否都符合条件。
fill()	使用一个固定值来填充数组。
filter()	检测数值元素，并返回符合条件所有元素的数组。
find()	返回符合传入测试（函数）条件的数组元素。
findIndex()	返回符合传入测试（函数）条件的数组元素索引。
forEach()	数组每个元素都执行一次回调函数。
from()	通过给定的对象中创建一个数组。
includes()	判断一个数组是否包含一个指定的值。
indexOf()	搜索数组中的元素，并返回它所在的位置。
isArray()	判断对象是否为数组。
join()	把数组的所有元素放入一个字符串。
keys()	返回数组的可迭代对象，包含原始数组的键(key)。
lastIndexOf()	搜索数组中的元素，并返回它最后出现的位置。
map()	通过指定函数处理数组的每个元素，并返回处理后的数组。
pop()	删除数组的最后一个元素并返回删除的元素。
push()	向数组的末尾添加一个或更多元素，并返回新的长度。
reduce()	将数组元素计算为一个值（从左到右）。
reduceRight()	将数组元素计算为一个值（从右到左）。
reverse()	反转数组的元素顺序。
shift()	删除并返回数组的第一个元素。
slice()	选取数组的的一部分，并返回一个新数组。
some()	检测数组元素中是否有元素符合指定条件。
sort()	对数组的元素进行排序。
splice()	从数组中添加或删除元素。
toString()	把数组转换为字符串，并返回结果。
unshift()	向数组的开头添加一个或更多元素，并返回新的长度。
valueOf()	返回数组对象的原始值。



Undefined 和 Null
Undefined 这个值表示变量不含有值。
可以通过将变量的值设置为 null 来清空变量。

## 对象

```js
//定义对象
var person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};

//可以通过以下两种方式来访问对象的属性
person.lastName;
person["lastName"];

//定义对象方法
var person = {
    firstName:"John", 
    lastName:"Doe",
    fullName:function(){
        return this.firstName + this.lastName;
    }
}

person.hello = function(){
    return "hello" + this.firstName + this.lastName;
}


```



## JavaScript 事件

onchange 	HTML 元素改变
onclick 	用户点击 HTML 元素
onmouseover 	用户在一个HTML元素上移动鼠标
onmouseout 	用户从一个HTML元素上移开鼠标
onkeydown 	用户按下键盘按键
onload 	浏览器已完成页面的加载

```html
<button onclick="displayDate()">现在的时间是?</button>
<button onclick="this.innerHTML=Date()">现在的时间是?</button>
```

## javascript 字符串

字符串可以是对象

```js
var x = "John";
var y = new String("John");
typeof x // 返回 String
typeof y // 返回 Object 
```

字符串属性
constructor 	返回创建字符串属性的函数
length 	返回字符串的长度
prototype 	允许您向对象添加属性和方法

charAt() 	返回指定索引位置的字符
charCodeAt() 	返回指定索引位置字符的 Unicode 值
concat() 	连接两个或多个字符串，返回连接后的字符串
fromCharCode() 	将 Unicode 转换为字符串
indexOf() 	返回字符串中检索指定字符第一次出现的位置
lastIndexOf() 	返回字符串中检索指定字符最后一次出现的位置
localeCompare() 	用本地特定的顺序来比较两个字符串
match() 	找到一个或多个正则表达式的匹配
replace() 	替换与正则表达式匹配的子串
search() 	检索与正则表达式相匹配的值
slice() 	提取字符串的片断，并在新的字符串中返回被提取的部分
split() 	把字符串分割为子字符串数组
substr() 	从起始索引号提取字符串中指定数目的字符
substring() 	提取字符串中两个指定的索引号之间的字符
toLocaleLowerCase() 	根据主机的语言环境把字符串转换为小写，只有几种语言（如土耳其语）具有地方特有的大小写映射
toLocaleUpperCase() 	根据主机的语言环境把字符串转换为大写，只有几种语言（如土耳其语）具有地方特有的大小写映射
toLowerCase() 	把字符串转换为小写
toString() 	返回字符串对象值
toUpperCase() 	把字符串转换为大写
trim() 	移除字符串首尾空白
valueOf() 	返回某个字符串对象的原始值


### javascript流程控制

switch
```js
switch(n)
{
    case 1:
        执行代码块 1
        break;
    case 2:
        执行代码块 2
        break;
    default:
        与 case 1 和 case 2 不同时执行的代码
}
```

普通for循环
```js

for (var i=0; i<5; i++)
{
      x=x + "该数字为 " + i + "<br>";
}

```

for/in 语句循环遍历对象的属性：

```js
var person={fname:"John",lname:"Doe",age:25}; 
 
for (x in person)  // x 为属性名
{
    txt=txt + person[x];
}
```

将日期转换为字符串

Date() 返回字符串
```js
Date()// 返回 Thu Jul 17 2014 15:38:19 GMT+0200 (W. Europe Daylight Time)
new Date()//返回日期对象
String(new Date())//将日期对象转换成字符串
(new Date()).toString()//将日期对象转换成字符串
getDate()//从 Date 对象返回一个月中的某一天 (1 ~ 31)。
getDay()//从 Date 对象返回一周中的某一天 (0 ~ 6)。
getFullYear()//从 Date 对象以四位数字返回年份。
getHours()//返回 Date 对象的小时 (0 ~ 23)。
getMilliseconds()//返回 Date 对象的毫秒(0 ~ 999)
getMinutes()//返回 Date 对象的分钟 (0 ~ 59)。
getMonth()//从 Date 对象返回月份 (0 ~ 11)。
getSeconds()//返回 Date 对象的秒数 (0 ~ 59)。
getTime()//回 1970 年 1 月 1 日至今的毫秒数。
```

将字符串转换为数字

字符串包含数字(如 "3.14") 转换为数字 (如 3.14).
空字符串转换为 0。
其他的字符串会转换为 NaN (不是个数字)。

其它
```js
parseFloat()//解析一个字符串，并返回一个浮点数。
parseInt()//解析一个字符串，并返回一个整数。
```

一元运算符 +
Operator + 可用于将变量转换为数字：
```js
var y = "5";      // y 是一个字符串
var x = + y;      // x 是一个数字 
```

将布尔值转换为数字
```js
Number(false)     // 返回 0
Number(true)      // 返回 1 
```

将日期转换为数字
```js
d = new Date();
Number(d)          // 返回 1404568027739 

//日期方法 getTime() 也有相同的效果。

d = new Date();
d.getTime()        // 返回 1404568027739
```

自动转换类型

当 JavaScript 尝试操作一个 "错误" 的数据类型时，会自动转换为 "正确" 的数据类型。

```js
5 + null    // 返回 5         null 转换为 0
"5" + null  // 返回"5null"   null 转换为 "null"
"5" + 1     // 返回 "51"      1 转换为 "1" 
"5" - 1     // 返回 4         "5" 转换为 5
```

自动转换为字符串

当你尝试输出一个对象或一个变量时 JavaScript 会自动调用变量的 toString() 方法：

## JavaScript 正则表达式


