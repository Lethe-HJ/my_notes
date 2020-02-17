# css学习

## 行内样式(内联样式)

语法：`<any style="样式声明"></any>`  any:任意标签

```html

<div style="color:red;background-color:yellow">
```

内联样式在项目中，很少使用。
学习和测试的时候用  
原因：1.内联样式不能重用
      2.内联样式优先级最高

## 内部样式

在网页头部中，添加一对`<style></style>`标签
在style标签定义此网页所有的样式

```html
<style>
   选择器{样式属性：值；样式属性：值；........}
</style>
```

选择器：就是一个条件，符合这个条件元素，可以应用这个样式

项目中使用内部样式较少，学习和测试使用较多
内部样式的重用不能在其他html页面中生效

## 外部样式

单独创建一个css文件，编写样式
在html页面的head中使用link，引入这个外部样式

```html
<link rel="stylesheet" href="css文件的url">
```

注意：rel="stylesheet"必须写，不然无效

此种方式，是开发中使用最多方式。

## CSS的特性

### 继承性

大部分的css效果，是可以被子元素继承的
必须是父子结构，子继承父

### 层叠性

可以为一个元素定义多个样式规则
多个规则中样式属性不冲突时，可以同时应用到当前元素上

### 优先级

如果对一个元素的多个样式声明，发生冲突时，按照样式规则的优先级去应用
默认优先级：由高到低
1.内联样式(行内样式)
2.内部样式和外部样式，就近原则
3.浏览器默认样式

## 调整优先级

!important规则
放在属性值后面，与值之间有一个空格
作用，调整样式显示的优先级

内联样式不可以写!important
!important优先级，比内联样式高

## 选择器

### 通用选择器

*{样式声明}
由于*的效率低下，项目中很少使用通用选择器
唯一使用的场合*{margin:0;padding:0}所有元素内外边距清0

### 标签选择器

页面中所有对应的元素，都应用这个样式
设置页面中某种元素的默认样式
元素名称{样式声明}
如: p{}   div{}

### ID选择器，专属定制

```xml
<any id="hello"></any>

#hello{
    样式声明
}
```

这种写法仅仅对页面上一个标签生效
一般id选择器在项目中很少单独使用。
通常会作为子代选择器或者后代选择器的一部分

## 类选择器

```xml
<any class="类名"></any>
```

.类名{样式声明}
作用：定义页面上某个或者某类元素的样式
class属性来引用类名

## 类选择器的特殊用法

### 1.多类选择器

让元素引用多个类名，这些类的样式都会作用到当前元素上

```xml
<div class="text-danger bg-warning font-24">d</div>
```

### 2.分类选择器

元素选择器+类选择器{}
div.text-danger{ }div元素有text-danger类,才能应用这个样式
 类选择器+类选择器{}
.font-24.text-danger{ }
元素，必须有font-24类和text-danger，才能应用此样式
作用：1.更精确的确定使用样式的元素
      2.增加选择器的权值

### 群组选择器

将多个选择器放在一起定义公共的样式
语法：选择器1,选择器2,......{公共样式声明}
ex: #content,div,.mycolor,p.text{color:red}
相当于#content{color:red}
div {color:red}
p.text {color:red}
.mycolor {color:red}

### 后代选择器

通过元素的后代关系匹配元素
后代：一级嵌套或者多级嵌套
语法：`选择器1  选择器2  选择器3........{}`

`#content p span{color:red;}`  
id为content的元素，内部不管隔着多少代，有一个p元素
p元素内部，不管隔着多少代，有一个span.这个span就符合要求

子代选择器
通过元素的子代关系匹配元素
子代：一级嵌套，直接的儿子
`选择器1>选择器2>....{}`

子代选择器和后代选择器可以混写
`#content p>span{background-color:yellow;}`

### 伪类选择器

匹配同一个元素，不同的状态下的样式
所有的伪类选择器都是这样开头的  选择器:
1.链接伪类
  a标签，没有访问的状态
  a:link{color:red;}
  a标签，被访问过之后的状态
  a:visited{color:black;}
2.动态伪类
  :hover 鼠标悬停在元素上时，元素的样式
  :active 匹配元素被激活时的状态
  :focus 匹配元素获取焦点时的状态

### 选择器的权值

权值：标识当前选择器的重要程度，权值越大，优先级越高
!important   >1000
内联样式     1000
id选择器     100
类选择器      10
元素选择器     1
*通用选择器    0
继承的样式    无
权值的特点
1.当一个选择器中含有多个选择器时，需要将所有的选择器权值进行相加，然后比较，权值大的优先显示
2.权值相同，就近原则
3.群组选择器的权值，单独各算各的，不能相加
4.样式后面追加!important直接获取最高优先级
  内联样式不能加!important
5.选择器的权值计算，结果不会超过自己的最大数量级
(1000个1相加，也不会大于10)

##　尺寸和边框

尺寸属性
作用，设置元素的宽高
属性：
width: 设置宽
height:设置高

max-width 最大宽度
min-width 最小宽度
max-height 最大高度
min-height 最小高度
使用场合，响应式布局

取值：以px为单位的数字
      父元素尺寸的%百分比

尺寸的单位
1.px像素
2.in英寸  1in=2.54cm
3.pt 磅值，多用于修饰字体大小粗细  1pt=1/72in
4.cm
5.mm
6.% 父元素的百分之多少
7.em 是相对于父元素数值的单位
8.rem 是相对html标签数值的单位

## 页面中允许设置尺寸的元素
  
  块级元素
    所有的块级元素都可以设置尺寸
    如果块级元素不设置宽，宽度占父元素100%。
    如果块级元素不设置高，高度靠内容撑开，没有内容，就没有高
  行内元素
    行内元素设置宽高无效，
    行内元素宽高，是靠内容撑开
    但是，自带宽高属性的行内元素，可以设置尺寸
  table
    table自带宽高属性，可以设置宽高
  行内块
    input
    行内块可以设置宽高

## 溢出处理

当内容较大，元素区域较小，就会发生溢出效果
默认是纵向溢出
属性 `overflow`
取值 1.`visible` 默认值，溢出部分可见
     2.`hidden` 溢出部分隐藏
     3.`scroll` 不管是否溢出，都添加滚动条。
              不溢出的时候，滚动条不能拖动
     4.`auto` 自动，溢出的时候，溢出的方向有滚动条。
            不溢出的时候，没有
控制滚动条的方向
    `overflow-x/overflow-y`

如何让内容横向溢出
  需要在宽度比较小的容器内部，添加一个宽度较大的元素盛放内容
  在父容器上写`overflow:auto`。就可以做到横向溢出

## 颜色

合法颜色值
1.颜色的英文单词(red,blue,yellow,pink,purple......)
2.#rrggbb
  #000000---黑  #ffffff---白   #ff0000---红
  #00ff00---绿   #0000ff---蓝
3.#aabbcc---->#abc
  #000 #fff  #f00  #0f0  #00f  #666
4.`rgb(0~255,0~255,0~255)`  
  `rgb(255,0,0)`
5.`rgba(r,g,b,alpha)`  alpha透明度  0~1  1不透明，0透明
  `rgba(255,0,0,0.5)`
4.边框
  `border:width style color;`
  `width:边框的宽度`，取值以`px`为单位的数字
  `style:边框的样式` 取值：`solid`实线
                        `dotted` 点状虚线
                        `dashed` 线状虚线
                        `double` 双实线
  `color：边框的颜色` 取值 合法的颜色值/`transparent`(透明)
  最简方式 `border:style;`
  取消边框 `border:0;`  或者 `border:none;`

  只设置某一条边的3个属性
    `border-top：width style color;`
    `border-right`
    `border-bottom`
    `border-left`

### 单属性定义

border-width:3px;
border-style:solid;
border-color:#f00;
border:3px solid #f00;

单边单属性
border-top-width:
border-top-style:
border-top-color:

5.边框的倒角(圆角)
将直角设置成倒角，圆角
border-radius：
取值：以px为单位数字
      %
50%就是个圆  

单角设置
border-top-left-radius
border-top-right-radius
border-bottom-left-radius
border-bottom-right-radius

6.边框阴影
box-shadow

取值：h-shadow v-shadow blur spread color  inset;
h-shadow:水平方向的阴影偏移量
      +：往右移动， -：往左移动
v-shadow:垂直方向的阴影偏移量
      +：往下       -：往上
blur：阴影模糊距离，越大越模糊
      无负值
spread：阴影尺寸，在基础阴影上扩出来的大小
      负值，尺寸变小
color:阴影颜色
inset:向内扩撒阴影

7.轮廓
轮廓指的是边框的边框，绘制于边框外的线条
outline:width style color;
outline:none;或者outline:0 去除 轮廓

## 框模型---盒子模型

框模型--元素在页面上实际占地空间的计算方式
默认情况，一个元素在页面的实际占地宽度
左外边距+左边框宽度+左内边距+内容区域宽度+右内边距+右边框+右外边距
实际占地高度
上外边距+上边框宽度+上内边距+内容区域高度+下内边距+下边框+下外边距

1.外边距margin
元素边框以外的距离，改变margin，元素有位移的效果
 ①语法
margin:v1; 设置4个方向的外边距
margin:v1 v2;   v1上下   v2左右
           margin:0 auto; 块级元素水平居中
           auto对垂直外边距无效
           margin:auto;
           auto只对设置了宽的块级元素生效
margin:v1 v2 v3;  v1上  v2左右  v3下
maring:v1 v2 v3 v4;  上右下左

单方向外边距设置
margin-top:
margin-right:
margin-bottom:
margin-left:

取值：1.以px为单位数字
      2.%
      3.+ margin-top ↓   margin-left →
        - margin-top ↑   margin-left ←
      4.auto 自动计算块级元素外边距，让块级元素水平居中
             auto只对设置了宽度的块级生效
             auto对下上外边距无效

2.外边距的特殊效果
外边距合并
两个垂直外边距相遇时，他们将合并成一个，值以大的为准
只能在布局设计的时候，尽量避免发生

## 框模型

行内元素的特点：
设置宽高无效，宽高根据内容自动撑开
上下垂直外边距无效。可以与其他的行内元素和行内块元素共用一行
块级元素特点：
设置宽高有效。如果不设置宽高，高按内容撑开，宽占父元素宽度的100%。上下外边距有效，独占一行.
行内块的特点：input
设置宽高有效，不设置宽高，自带默认宽高。
上下外边距有效，但是同一行修改一个行内块的垂直外边距，整行都会跟着一起改变位置。可以与其他行内元素和行内块共用一行

### 自带外边距的元素

body h1~h6 p ol ul dl pre
由于不同浏览器对默认的外边距解析可能有差别
所以一般情况下，开发之前，需要把内外边距清空
*{margin:0;padding:0}
或者通过群组选择器来写
blockquote,body,button,dd,dl,dt,fieldset,form,
h1,h2,h3,h4,h5,h6,hr,input,legend,li,ol,
p,pre,td,textarea,th,ul{margin:0;padding:0}

### 外边距溢出

在特殊情况下，为子元素设置外边距，会作用到父元素上
特殊情况：
1.父元素没有上边框
2.子元素内容区域上边与父元素内容区域上边重合的时候
(为父元素中第一个子元素设置上外边距时，这种说法不严谨)
解决方案：
1.给父元素添加上边框，弊端，影响父元素实际占地高度
2.给父元素添加上内边距，弊端，影响父元素实际占地高度
3.给父元素的一个子元素的位置添加空table元素
3.内边距
内边距的改变效果，感觉是改变了元素的大小
不会影响其它元素，但是真正改变的是本元素的占地尺寸
内边距颜色和元素背景相同
语法：
padding:v1; 设置4个方向的内边距
padding:v1 v2;  上下   左右
            padding无auto
padding:v1 v2 v3;  上  左右  下
padding:v1 v2 v3 v4;上右下左
单方向设置
padding-top
padding-right
padding-bottom
padding-left
取值，以px为单位的数字  %
      padding无auto值
4.box-sizing属性(设置元素实际占地尺寸的公式)
box-sizing:
取值：1.content-box.默认值，按照之前的盒子模型计算元素占地大小(左外+左边+左内+内容区域宽度+右内+右边+右外)
      2.border-box。设置的width和height是包含border+padding+内容区域的  整体宽高
      元素实际占地大小 
      左外+设置的width+右外
      上外+设置的height+下外
给复杂元素关系做布局时，经常使用border-box
六.背景
1.背景颜色
background-color:合法颜色值
2.背景图片
background-image:url(08.png);
使用背景图片，可以让该元素的子元素，堆叠显示在背景图片上。
而使用img标签，默认不会有堆叠效果
3.背景图片的平铺
background-repeat:
取值：repeat 默认值，平铺
      no-repeat 不平铺
      repeat-x   水平方向平铺
      repeat-y   垂直方向平铺
4.背景图片的定位
background-position:
取值：1. x  y  以px为单位的数字
      2.x% y% 百分比
      3.关键字  x:left/center/right
                y:top/center/bottom
5.背景图片的尺寸
background-size:
取值：1. x  y  以px为单位设置具体宽高
      2.x% y% 按父元素宽高比设置
      以元素的角度考虑这两个单词
      3.cover 充满，只要求元素被背景 图充满，背景图显示不全，也没关系.
      4.contain 包含，只要求元素要把背景图整个包含住，元素有空白，也没关系
6.背景图片的固定
background-attachment
取值： scroll 默认值，背景图会随着窗口滚动条滚动
       fixed 固定，背景图相对于窗口固定，窗口滚动时，背景图位置不变，但是只会在原容器内显示
7.背景的简写方式
background:
取值  color image repeat attachment position
最精简方式 background:color/image;
8.背景透明
background:rgba(0,0,0,0.8);//alpha 取值0~1
七.渐变 gradient
1.什么是渐变
渐变是指多种颜色，平缓变化的一种显示效果
2.渐变的主要因素
色标：一种颜色，以及这种颜色出现的位置
一个渐变，最少两个色标
3.渐变的分类
1.线性渐变，以直线的方式，来填充渐变色
2.径向渐变，以圆形的方式，来填充渐变色
3.重复渐变，将线性，径向渐变重复几次显示
4.线性渐变
background-image:
linear-gradient(angle,color-point1, color-point2......);
angle:表示渐变的方向
     取值  1.关键字 to top    从下往上
                   to right   从左往右
                   to bottom 从上往下
                   to left     从右往左
           2.角度  0deg  to top
                   90deg to right
                  180deg to bottom
                  270deg to left
                  可以取负值
color-point:色标  颜色 %/px
5.径向渐变
background-image:
radial-gradient(半径 at 圆心x 圆心y,color-point1,
color-point2.................)
半径 以px为单位的数字
圆心  1 x  y  以px为单位的数字
      1. x% y%
      3关键字  x left/center/right
                y top/center/bottom
color-point: 位置取值 1. %   半径的百分比%
                     2.px为单位的数字，半径失效
6.重复渐变
重复的线性渐变
background-image:
repeating-linear-gradient(to left,#000 0px,
#ff0 25px,#000 50px);
重复的径向渐变
background-image:
repeating-radial-gradient(50px at center center,
#000 0%,#0ff 25%,#000 50%);  17:07~17:23休息
7.浏览器兼容问题
如果有低版本(ie8.0以下)，想要使用渐变
chrome/safari  -webkit-
firefox         -moz-
opera          -o-
IE              -ms-
要低版本兼容渐变，需要在linear-gradient之前添加浏览器内核
background-image:
-webkit-linear-gradient()
background-image:
-moz-linear-gradient()
......
兼容低版本浏览器，线性渐变的方向，要改变写法
不写to top/to left/to bottom/to right
改成初始点 top/left/bottom/right
八.文本格式化
1.字体属性
 ①指定字号大小
font-size:
取值  px/pt/rem/em为单位的数字
 ②字体的类型
font-family

```css
table, td {
  border-collapse: collapse; /*合并相邻边框*/
}


a {
  padding: 10px;/*设置内边距为10px*/
  padding: 0 18px;/*上下0 左右18*/
  padding: 10px 20px 30px;/*上10 左右20 下30*/
  padding: 10px 20px 30px 40px;/*上10 右20 下30 左40*/
}

div {
  margin: 0 auto;/*上下0 左右auto 左右自动充满 水平居中对齐*/
  margin: auto;/*上下左右都auto 但上下auto无效 相当于 0 auto*/
  margin-left: auto;/*左边自动充满*/
  margin-top: 150px;/*上面外边距至少为150px 相邻两个盒子之间的margin会以他们其中最大的margin为准*/
  /*通过外边距实现盒子居中 盒子必须是块级元素且盒子必须指定了宽度*/
  text-align:center;/*让文字居中对齐*/
}


/*嵌套块元素垂直外边距的合并*/
/* 对于两个嵌套关系的块元素,如果父元素没有上内边距及边框,
则父元素的上边距会与子元素的上外边距发生合并,合并后的外边
距为两者中的较大者,即使父元素的上外边距为0,也会发生合并
 解决方案:
  1.可以为父元素定义1像素的边框或上内边距
  2.可以为父元素添加overflow:hidden */
div {
  border-radius: 50%; /* 圆角  当是盒子宽度与高度一样,且boder-radius是50%或宽度的一半则盒子会变成圆*/
  border-radius: 150px;
  border-radius: 10px 0;/*左上 右下角为10 右上左下角0*/

  box-shadow: 水平阴影, 垂直阴影, 模糊距离, 阴影尺寸, 阴影颜色, 内/外阴影;
}


```

