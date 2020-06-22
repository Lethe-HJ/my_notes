## 介绍js

### js的功能
-  网页特效
-  服务端开发(Node.js)
-  桌面程序(Electron)
-  App(Cordova) 
-  控制硬件-物联网(Ruff)
-  游戏开发(cocos2d-js)

### js引擎
浏览器本身并不会执行JS代码，而是通过内置 JavaScript 引擎(解释器) 来执行 JS 代码 。JS 引擎执行代码时逐行解释每一句源码（转换为机器语言），然后由计算机去执行，所以 JavaScript 语言归为脚本语言，会逐行解释执行。

### ECMAScript

​ECMAScript 是由ECMA 国际（ 原欧洲计算机制造商协会）进行标准化的一门编程语言，这种语言在万维网上应用广泛，它往往被称为 JavaScript或 JScript，但实际上后两者是 ECMAScript 语言的实现和扩展。

ECMAScript：规定了JS的编程语法和基础核心知识，是所有浏览器厂商共同遵守的一套JS语法工业标准。

### js官方文档MDN

https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/JavaScript_technologies_overview

### DOM——文档对象模型

文档对象模型（DocumentObject Model，简称DOM），是W3C组织推荐的处理可扩展标记语言的标准编程接口。通过 DOM 提供的接口可以对页面上的各种元素进行操作（大小、位置、颜色等）

### BOM——浏览器对象模型

浏览器对象模型(Browser Object Model，简称BOM) 是指浏览器对象模型，它提供了独立于内容的、可以与浏览器窗口进行互动的对象结构。通过BOM可以操作浏览器窗口，比如弹出框、控制浏览器跳转、获取分辨率等。


### js细碎知识

prompt(info)     | 浏览器弹出输入框，用户可以输入

变量命名 首字母小写 驼峰命名 

最大值：Number.MAX_VALUE，这个值为： 1.7976931348623157e+308
最小值：Number.MIN_VALUE，这个值为：5e-32

#### Infinity
Infinity ，代表无穷大，大于任何数值
-Infinity ，代表无穷小，小于任何数值
NaN，代表一个非数值

#### isNaN

判断一个变量是不是非数字类型 是的话返回true 否则false
isNaN(变量名);

#### undefined和null
一个声明后没有被赋值的变量会有一个默认值undefined
一个声明变量给 null 值，里面存的值为null

#### typeof
typeof 可用来获取检测变量的数据类型 

```js
  var num = 18;
  console.log(typeof num) // 结果 number      
```

#### 字面量
​
字面量是在源代码中一个固定值的表示法，通俗来说，就是字面量表示如何表达这个值。
数字字面量：8, 9, 10
字符串字面量："大前端"


#### 类型转换

布尔值
  - 代表空、否定的值会被转换为 false  ，如 ''、0、NaN、null、undefined  
  - 其余值都会被转换为 true


#### 编译与解释

-  翻译器翻译的方式有两种：一个是编译，另外一个是解释。两种方式之间的区别在于翻译的时间点不同
-  编译器是在代码执行之前进行编译，生成中间代码文件
-  解释器是在运行时进行及时解释，并立即执行(当编译器以解释方式运行的时候，也称之为解释器)

#### 预解析

预解析：在当前作用域下, JS 代码执行之前，浏览器会默认把带有 var 和 function 声明的变量在内存中进行提
前声明或者定义。

预解析也叫做变量、函数提升。 变量提升（变量预解析）： 变量的声明会被提升到当前作用域的最上面，变量的赋值不会提升。
函数提升： 函数的声明会被提升到当前作用域的最上面，但是不会调用函数


#### 函数表达式声明函数问题

```js

fn(); 
var fn = function() {
  console.log('想不到吧'); 
}
```

函数表达式创建函数，会执行变量提升，此时接收函数的变量名无法正确的调用：

结果：报错提示 ”fn is not a function" 解释：该段代码执行之前，会做变量声明提升，fn在提升之后的值是undefined；而fn调用是在fn被赋值为函数体之 前，此时fn的值是undefined，所以无法正确调用

## 对象

JavaScript 中的对象分为3种：**自定义对象 、内置对象、 浏览器对象**

### 创建对象

利用字面量创建对象

```js
var star = 
{ 
  name : 'pink', 
  age : 18, 
  sex : '男', 
  sayHi : function(){ 
    alert('大家好啊~'); 
  } 
};
console.log(star.name) // 调用名字属性
console.log(star['name']) // 调用名字属性
star.sayHi();
```

利用 new Object 创建对象

```js
var andy = new Obect();
andy.name = 'pink';
andy.age = 18;
andy.sex = '男';
andy.sayHi = function(){
    alert('大家好啊~');
}
```

利用构造函数创建对象

```js
function 构造函数名(形参1,形参2,形参3) {
      this.属性名1 = 参数1;
      this.属性名2 = 参数2;
      this.属性名3 = 参数3;
      this.方法名 = 函数体;
}

var obj = new 构造函数名(实参1，实参2，实参3)
```

1.   构造函数约定**首字母大写**。
2.   函数内的属性和方法前面需要添加 **this** ，表示当前对象的属性和方法。
3.   构造函数中**不需要 return 返回结果**。
4.   当我们创建对象的时候，**必须用 new 来调用构造函数**。

遍历对象


```js
for (var k in obj) {
    console.log(k);      // 这里的 k 是属性名
    console.log(obj[k]); // 这里的 obj[k] 是属性值
}
```


### Math对象

​		Math 对象不是构造函数，它具有数学常数和函数的属性和方法。跟数学相关的运算（求绝对值，取整、最大值等）可以使用 Math 中的成员。

| 属性、方法名          | 功能                                         |
| --------------------- | -------------------------------------------- |
| Math.PI               | 圆周率                                       |
| Math.floor()          | 向下取整                                     |
| Math.ceil()           | 向上取整                                     |
| Math.round()          | 四舍五入版 就近取整   注意 -3.5   结果是  -3 |
| Math.abs()            | 绝对值                                       |
| Math.max()/Math.min() | 求最大和最小值                               |
| Math.random()         | 获取范围在[0,1)内的随机值                    |

​	注意：上面的方法使用时必须带括号

​	**获取指定范围内的随机整数**：

```js
function getRandom(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min; 
}
```

### 日期对象

​	 	Date 对象和 Math 对象不一样，Date是一个构造函数，所以使用时需要实例化后才能使用其中具体方法和属性。Date 实例用来处理日期和时间

- 使用Date实例化日期对象

  - 获取当前时间必须实例化：

  ```js
  var now = new Date();
  ```

  - 获取指定时间的日期对象

  ```js
  var future = new Date('2019/5/1');
  ```

  注意：如果创建实例时并未传入参数，则得到的日期对象是当前时间对应的日期对象

- 使用Date实例的方法和属性	
- 通过Date实例获取总毫米数

  - 总毫秒数的含义

    ​	基于1970年1月1日（世界标准时间）起的毫秒数

  - 获取总毫秒数

    ```js
    // 实例化Date对象
    var now = new Date();
    // 1. 用于获取对象的原始值
    console.log(date.valueOf())	
    console.log(date.getTime())	
    // 2. 简单写可以这么做
    var now = + new Date();			
    // 3. HTML5中提供的方法，有兼容性问题
    var now = Date.now();
    ```

### 数组对象


```js
var arr1 = [1,"test",true];

var arr2 = new Array();
var arr3 = new Array(2);//长度为2
var arr4 = new Array(2，3，4);//元素为2，3，4


console.log(arr1 instanceof Array);//判断是否是数组
console.log(Array.isArray(arr));//判断是否是数组
```

增

push() 在末尾添加一个或多个元素，并返回添加后的数组长度 
unshift() 在开头添加一个或多个元素，并返回添加hi有的数组长度
pop() 删除数组末尾的一个元素，并返回该元素
shift() 删除数组开头的一个元素，并返回该元素
indexOf() 返回给定元素的第一次出现的索引，不存在时返回-1
lastIndexOf() 返回给定元素的第一次出现的索引，不存在时返回-1
toString() 返回一个字符串 由数组转换而成（逗号分隔每一项）
join(",") 返回一个由特定分隔符（这里是,）与数组的每一项拼接而成的字符串
concat() 返回一个新数组 由两个原始数组拼接而成
slice(begin,end) 返回从数组中截取的子数组
splice() 删除数组中特定的子数组

### 字符串对象

```js
var str = 'andy';
var temp = new String('andy');

// 字符串的索引
console.log(str[1]);//n
```


字符串的不可变

​指的是里面的值不可变，虽然看上去可以改变内容，但其实是地址变了，内存中新开辟了一个内存空间。

当重新给字符串变量赋值的时候，变量之前保存的字符串不会被修改，依然在内存中重新给字符串赋值，会重新在内存中开辟空间，这个特点就是字符串的不可变。

由于字符串的不可变，在**大量拼接字符串**的时候会有效率问题

indexOf() 返回给定字符的第一次出现的索引，不存在时返回-1
lastIndexOf() 返回给定字符的第一次出现的索引，不存在时返回-1
charAt(index) 返回指定位置的字符
charCodeAt(index) 获取指定位置处字符的ASCII码值

concat() 连接两个或多个字符串
substr() 获取字串
slice(start, end) 从start位置开始截取到end位置之前
substring
replace()  替换
split() 


### 堆栈

**简单类型**（**基本数据类型**、**值类型**）：在存储时变量中存储的是值本身，包括string ，number，boolean，undefined，null

​**复杂数据类型（引用类型）**：在存储时变量中存储的仅仅是地址（引用），通过 new 关键字创建的对象（系统对象、自定义对象），如 Object、Array、Date等；

堆栈空间分配区别：
栈（操作系统）：由操作系统自动分配释放存放函数的参数值、局部变量的值等。其操作方式类似于数据结构中的栈；
堆（操作系统）：存储复杂类型(对象)，一般由程序员分配释放，若程序员不释放，由垃圾回收机制回收。

简单数据类型的存储方式：值类型变量的数据直接存放在变量（栈空间）中
复杂数据类型的存储方式：引用类型变量（栈空间）里存放的是地址，真正的对象实例存放在堆空间中

### 简单复杂数据类型的传参

函数的形参也可以看做是一个变量，当我们把一个值类型变量作为参数传给函数的形参时，其实是把变量在栈空间里的值复制了一份给形参，
那么在方法内部对形参做任何修改，都不会影响到的外部变量。
```js
function fn(a) {
    a++;
    console.log(a);//11 
}
var x = 10;
fn(x);
console.log(x)；//10
```

### 复杂数据类型传参

​		函数的形参也可以看做是一个变量，当我们把引用类型变量传给形参时，其实是把变量在栈空间里保存的堆地址复制给了形参，形参和实参其实保存的是同一个堆地址，所以操作的是同一个对象。

```JavaScript
function Person(name) {
    this.name = name;
}
function f1(x) { // x = p
    console.log(x.name);//刘德华   
    x.name = "张学友";
    console.log(x.name);//张学友  
}
var p = new Person("刘德华");
console.log(p.name);//刘德华   
f1(p);
console.log(p.name);//张学友  
```

## falsy

falsy 值 (虚值) 是在 Boolean 上下文中认定为 false 的值。

JavaScript 在需要用到布尔类型值的上下文中使用强制类型转换(Type Conversion )将值转换为布尔值，例如条件语句和循环语句。

在 JavaScript 中只有 7 个 falsy 值。

这意味着当 JavaScript 期望一个布尔值，并被给与下面值中的一个时，它总是会被当做 false。

false	false 关键字
0	数值 zero	
0n	当 BigInt 作为布尔值使用时, 遵从其作为数值的规则. 0n 是 falsy 值.
"", '', ``	
这是一个空字符串 (字符串的长度为零). JavaScript 中的字符串可用双引号 "", 单引号 '', 或 模板字面量 `` 定义。
null	null - 缺少值
undefined	undefined - 原始值
NaN	NaN - 非数值