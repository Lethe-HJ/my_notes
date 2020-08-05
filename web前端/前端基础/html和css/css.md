
# css


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
