
## css

### 行内样式

```html
<p style="width:200px;height:100px;"></p>
```

### 内部样式表

```html
<head>
    <style>
        th {
            color:"blue";
        }
    </style>
</head>

```

### 外部样式表

```html
<head>
    <link href="CSS文件的路径" type="text/CSS" rel="stylesheet" />
</head>

```

```css
h3 {
	color: deeppink;
    font-size: 20px;    
}
h2 {
	color: deeppink;
    font-size: 20px;    
}
```


### 选择器

```
span 标签选择器
.CLASS_NAME 类选择器
#ID id选择器
* 通配符选择器
一个标签的class中可以有多个类名，用空格分开，多个类名之间冲突的样式与CSS样式书写的上下顺序有关，后面的覆盖前面的
```

特殊用法 多类名
```html
<div class="pink fontWeight font20">亚瑟</div>
```

后代选择器
div p
选中div里面所有的p 后代选择器用空格隔开

子代选择器
div > p
选中div的儿子p 子代选择器用>号分隔

交集选择器
div.red  选中div标签中类名为red的

并集选择器
div,p,span 选中div p span三种标签

伪类选择器
:link 未访问的链接
:visited 访问过的链接
:hover 鼠标移到链接上
:active 鼠标点击链接时
`a:visited{color:grey;}`

### 样式

### 字体样式

`font-size`字号大小
em 相对于当前对象内文本的字体尺寸
px 像素,最常用
示例 `font-size:10px;`
网页普遍使用14px+
尽量使用偶数字号

`font-family`字体
`font-family:"微软雅黑"`

| 字体名称    | 英文名称        | Unicode 编码         |
| ----------- | --------------- | -------------------- |
| 宋体        | SimSun          | \5B8B\4F53           |
| 新宋体      | NSimSun         | \65B0\5B8B\4F53      |
| 黑体        | SimHei          | \9ED1\4F53           |
| 微软雅黑    | Microsoft YaHei | \5FAE\8F6F\96C5\9ED1 |
| 楷体_GB2312 | KaiTi_GB2312    | \6977\4F53_GB2312    |
| 隶书        | LiSu            | \96B6\4E66           |
| 幼园        | YouYuan         | \5E7C\5706           |
| 华文细黑    | STXihei         | \534E\6587\7EC6\9ED1 |
| 细明体      | MingLiU         | \7EC6\660E\4F53      |
| 新细明体    | PMingLiU        | \65B0\7EC6\660E\4F53 |



`font-weight`字体粗细
normal:正常
bold:加粗
`font-weight: normal/400 || bold/700`

`font-style`字体风格
normal:正常
italic:倾斜
`font-style: normal || italic`

字体样式连写
`font: font-style font-weight font-size/line-height font-family;`
不需要的属性值可以省略,但必须保留font-size和font-family
`font: 12px "微软雅黑"`


`line-height`行高
`line-height:20px`
一般情况下,行距比字号大8像素就可以了
行高给盒子高度,就能使文字垂直居中对齐  

`text-align`内容水平对齐方式
left左对齐 默认值
right右对齐
center居中对齐 还能使行内块元素水平居中

`text-indent`首行缩进
`text-indent:2em`缩进两个字

color:red;
color:#FF0000;
color:rgb(255,0,0);
color:rgb(100%,0%,0%);


text-decoration: none || underline || line-throught
none: 无装饰
underline: 下划线
line-throught: 删除线

特殊文本格式标签
em i 倾斜
strong b 加粗
u ins 下划线
s del 删除线


### 页面布局

#### 块级元素

块级元素独占一行或多行
常见的块级元素有h1~h6,p,div,ul,ol,li等
p标签内不能放块级元素
高度，宽度、外边距以及内边距都可以控制
宽度默认是容器（父级宽度）的100%
是一个容器及盒子，里面可以放行内或者块级元素

#### 行内元素

靠自身的内容来支撑结构,一般不可以设置宽度 高度 对齐等属性,常用于控制页面中文本的样式.
和相邻元素在一行上,高宽无效,可以设置水平方向的.padding,marging,默认宽度就是它本身内容的宽度.
行内元素只能容纳文本或其他行内元素(a标签特殊).
常见的行内元素有a,strong,b,em,i,del,s,ins,u,span
相邻行内元素在一行上，一行可以显示多个。
默认宽度就是它本身内容的宽度

#### 行内块元素

常见的行内块元素有img,input,td
和相邻行内元素（行内块）在一行上,但是之间会有空白缝隙。一行可以显示多个
默认宽度就是它本身内容的宽度。
高度，行高、外边距以及内边距都可以控制。


#### 显示模式转换

`display:inline;`
inline 行内模式
block 块级模式
inline-block 行内块模式

### css权重

|            类型             | 权重  |
| :-------------------------: | :---: |
|         ! important         | 无穷  |
|          行间样式           | 1000  |
|             id              |  100  |
| class/属性选择器/伪类:hover |  10   |
|   标签选择器/伪元素:after   |   1   |
|           通配符            |   0   |

```html
01. *{}                         ====》0
02. li{}                        ====》1(一个元素)
03. li:first-line{}             ====》2(一个元素，一个伪元素)
04. ul li {}                    ====》2（两个元素）
05. ul ol+li{}                  ====》3（三个元素）
06. h1+ *[rel=up] {}            ====》11（一个属性选择器，一个元素）
07. ul ol li.red{}              ====》13（一个类，三个元素）
08. li.red.level{}              ====》21（两个类，一个元素）
09. style=""                    ====》1000(一个行内样式)
10. p {}                        ====》1（一个元素）
11. div p {}                    ====》2（两个元素）
12. .sith {}                    ====》10（一个类）
13. div p.sith{}                ====》12（一个类，两个元素）
14. #sith{}                     ====》100（一个ID选择器）
15. body #darkside .sith p {}   ====》112(1+100+10+1,一个Id选择器，一个类，两个元素)
```

### 背景

`background-image: url(imges/bg.png);`

`background-repeat: repeat | no-repeat | repeat-x | repeat-y;`

`background-position: center top;`
`background-position: center center;`
只跟方位名称 不区分顺序

`background-position: 50px 12px;`
x方向50px y方向12px
`background-position: 50px center;`
跟px 第一个是x方向,第二个是y方向

`background-attachment: fixed`背景图像固定
`background-attachment: scroll`背景图像是随对象内容滚动

`background: #000 url(images/sm.jpg) no-repeat fixed center top;`
背景颜色 背景图片地址 背景平铺 背景滚动 背景位置

背景透明
`background: rgba(0,0,0,0.5)`黑色半透明

#### CSS的特性

+ 层叠性
样式冲突，遵循的原则是就近原则那个样式离着结构近，就执行那个样式。

+ 继承性
子标签会继承父标签的某些样式，如文本颜色和字号。
想要设置一个可继承的属性，只需将它应用于父元素即可。
恰当地使用继承可以简化代码，降低CSS样式的复杂性。比如有很多子级孩子都需要某个样式，可以给父级指定一个，这些孩子继承过来就好了。
子元素可以继承父元素的样式（**text-，font-，line-这些元素开头的可以继承，以及color属性**）

+ 优先级 

| 标签选择器             | 计算权重公式 |
| ---------------------- | ------------ |
| 继承或者 *             | 0,0,0,0      |
| 每个元素（标签选择器） | 0,0,0,1      |
| 每个类，伪类           | 0,0,1,0      |
| 每个ID                 | 0,1,0,0      |
| 每个行内样式 style=""  | 1,0,0,0      |
| 每个!important  重要的 | ∞ 无穷大     |

值从左到右，左面的最大，一级大于一级，数位之间没有进制，级别之间不可超越

 div ul  li   ------>      0,0,0,3
- .nav ul li   ------>      0,0,1,2
- a:hover      -----—>   0,0,1,1
- .nav a       ------>      0,0,1,1

数位之间没有进制 比如说： 0,0,0,5 + 0,0,0,5 =0,0,0,10 而不是 0,0, 1, 0， 所以不会存在10个div能赶上一个类选择器的情况。


### 盒子模型

#### 边框

border:border-width || border-style || border-color

border-style的值
solid实线
dashed虚线
dotted点线

border:1px solid blue;

border-top: 1px solid red;
border-bottom: 1px solid red;
border-right: 1px solid red;
border-left: 1px solid red;

border:0; 去掉所有边框

border-collapse:collapse;合并相邻边框

#### 内边距

```css
a {
    height: 35px;
    background-color: #ccc;
    display: inline-block;
    line-height: 35px;
    color: #fff;
    text-decoration: none;
    /*  padding: 10px; 上下左右10*/
    /*  padding: 0px 10px; 上下0 左右10*/
    /*  padding: 0px 10px 20px; 上0 左右10 下20*/
    /*  padding: 0px 10px 20px 30px; 上0 右10 下20  左30*/
    padding-left: 10px;
    padding-right: 10px;
}
```

padding会撑开盒子

#### 盒子居中

margin: 0 auto;
上下0 左右auto
相当于
margin-left: auto;
margin-right: auto;

#### 外边距合并

垂直相邻盒子的外边距合并
嵌套元素的垂直外边距合并

使用margin定义块元素的**垂直外边距**时，可能会出现外边距的合并。

相邻块元素垂直外边距的合并

- 当上下相邻的两个块元素相遇时，如果上面的元素有下外边距margin-bottom
- 下面的元素有上外边距margin-top，则他们之间的垂直间距不是margin-bottom与margin-top之和
- **取两个值中的较大者**这种现象被称为相邻块元素垂直外边距的合并（也称外边距塌陷）。


**解决方案：尽量给只给一个盒子添加margin值**。

嵌套块元素垂直外边距的合并（塌陷）

- 对于两个嵌套关系的块元素，如果父元素没有上内边距及边框
- 父元素的上外边距会与子元素的上外边距发生合并
- 合并后的外边距为两者中的较大者

**解决方案：**

1. 可以为父元素定义上边框。
2. 可以为父元素定义上内边距
3. 可以为父元素添加overflow:hidden。


overflow: hidden;
溢出隐藏

#### 圆角

border-radius: 5px 6px 7px 8px;
左上5 右上6 右下7 左下8
border-radius: 5px 6px;
左上 右下5px  右上左下 6px
border-radius: 50%;
正方形变圆


#### 盒子阴影

box-shadow: 水平阴影 垂直阴影 模糊距离 阴影尺寸 阴影颜色 内外阴影
前两个必需
box-shadow: 5px  2px 10px rgba(0,0,0,0.4)

div:hover {
    box-shadow: 0 15px 30px rgba(0,0,0,0.1);
}

#### 浮动

normal flow 文档流 标准流

设置浮动属性 会使该元素脱离标准流 不占位置 但会影响标准流（影响下面的）
float: right/left/none;

可以使用浮动让多个div水平布局
行内块也能够让多个盒子(div)水平排列成一行，但是中间会有空白缝隙

浮动会受到父元素的限制

浮动默认让元素转换成行内块

#### 清除浮动


因为父级盒子很多情况下，不方便给高度，但是子盒子

浮动造成的bug 浮动的元素无法撑开父级

清除浮动就是把浮动的盒子圈到里面

`clear:both`

##### 额外标签法
在最后一个浮动元素后面添加
```html
<div style="clear:both"></div>
```
父级以最高的孩子的高度为高

##### 父级添加overflow
overflow: hidden|

##### 伪元素

```css
.clearfix:after {
    content: "";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
}

.clearfix {/* IE6-7 */
    *zoom: 1
}
```

#### before after双伪元素清除浮动

```css
.clearfix:after, .clearfix:after {
    content: "";
    display: table;
}

.clearfix:after {
    clear: both;
}

.clearfix {/* IE6-7 */
    *zoom: 1
}
```


#### 定位

边偏移
top
bottom
left
right

定位模式
position: static | relative | absolute | fixed

默认 static 静态定位
relative 相对定位 相对于元素本身的位置移动 但是原来的位置仍然保留
不脱离文档流 

absolute 绝对定位 如果没有父级或父级没有定位 则以浏览器当前窗口为基准点 原来的位置不保留
脱离文档流 会影响后面的同级元素

子绝父相
子元素用绝对定位 父元素用相对定位

使用定位来使盒子居中

```css
wight: 200px;
position: absolute;
left: 50%;
margin-left: -100px;
```

fixed 固定定位 固定在窗口的特定位置 且脱离文档流 不会影响父级

绝对定位 固定定位 浮动都会将盒子隐式转换成inline-block

背景图片不会撑开盒子

#### z-index

z-index叠放次序
z-index: 1;
取值越大 显示在越上面 


#### 显示与隐藏

display:none 隐藏元素 不保留位置
display:block 显示元素

visibility:hidden 隐藏元素 保留位置
visibility:visible 显示元素


#### overflow

overflow: visible | auto | hidden | scroll 
visible 溢出可见 默认
auto 溢出了就显示滚动条
hidden 溢出隐藏
scroll 一直显示滚动条

#### vertical-align

vertical-align: top | bottom | baseline | middle
顶线 最高位置
底线 最低位置
基线 小点的字母的最低位置
中线 中间位置

vertical-align

图片底部缝隙问题
因为图片默认与文字基线对齐
将图片改成vertical-align:middle | top| bottom等等
或者 将图片改成display：block; 转换为块级元素就不会存在问题了

它只针对于行内元素或者行内块元素

#### 盒子的稳定性

我们根据稳定性来分，建议如下：

按照 优先使用度（width）其次使用内边距（padding）再次外边距（margin）。   

```
  width > padding > margin   
```

- 原因：
  - margin 会有外边距合并 还有 ie6下面margin 加倍的bug（讨厌）所以最后使用。
  - padding  会影响盒子大小， 需要进行加减计算（麻烦） 其次使用。
  - width   没有问题（嗨皮）我们经常使用宽度剩余法 高度剩余法来做。

#### css布局的三种机制

标准流

浮动
让盒子从普通流中浮起来,主要作用让多个块级盒子一行显示。

定位
将盒子定在浏览器的某一个位置


#### 鼠标样式cursor

 设置或检索在对象上移动的鼠标指针采用何种系统预定义的光标形状。

| 属性值          | 描述       |
| --------------- | ---------- |
| **default**     | 小白  默认 |
| **pointer**     | 小手       |
| **move**        | 移动       |
| **text**        | 文本       |
| **not-allowed** | 禁止       |

#### 轮廓线
轮廓线是绘制于元素周围的一条线，位于边框边缘的外围，可起到突出元素的作用。
```css
outline : outline-color ||outline-style || outline-width
```
我们平常都是
outline: 0;   或者  outline: none;

#### 拖拽文本域

实际开发中，我们文本域右下角是不可以拖拽：

```html
<textarea  style="resize: none;"></textarea>
```

#### white-space
white-space设置或检索对象内文本显示方式。通常我们使用于强制一行显示内容 

white-space:normal ；默认处理方式
white-space:nowrap ；　强制在同一行内显示所有文本，直到文本结束或者遭遇br标签对象才换行。

#### text-overflow 文字溢出

设置或检索是否使用一个省略标记（...）标示对象内文本的溢出
text-overflow : clip ；不显示省略标记（...），而是简单的裁切 
text-overflow：ellipsis ； 当对象内文本溢出时显示省略标记（...）

## css3

### `3D` 移动 `translate3d`

- `3D` 移动就是在 `2D` 移动的基础上多加了一个可以移动的方向，就是 z 轴方向
- `transform: translateX(100px)`：仅仅是在 x 轴上移动
- `transform: translateY(100px)`：仅仅是在 y 轴上移动
- `transform: translateZ(100px)`：仅仅是在 z 轴上移动
- `transform: translate3d(x, y, z)`：其中x、y、z 分别指要移动的轴的方向的距离

```css 
transform: translate3d(100px, 100px, 100px)
/* 注意：x, y, z 对应的值不能省略，不需要填写用 0 进行填充 */
```

```css
body {
  perspective: 1000px;
  /* 值越小 越立体 */
}
```
`perspecitve` 给父级进行设置，`translateZ` 给 子元素进行设置不同的大小
