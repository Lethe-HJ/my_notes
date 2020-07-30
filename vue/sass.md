# sass

## CSS 功能拓展

### 嵌套规则 (Nested Rules)

Sass 允许将一套 CSS 样式嵌套进另一套样式中，内层的样式将它外层的选择器作为父选择器，例如：

```scss
#main p {
  color: #00ff00;
  width: 97%;

  .redbox {
    background-color: #ff0000;
    color: #000000;
  }
}
```

### 父选择器 &

在嵌套 CSS 规则时，有时也需要直接使用嵌套外层的父选择器，例如，当给某个元素设定 hover 样式时

```scss
a {
  font-weight: bold;
  text-decoration: none;
  &:hover { text-decoration: underline; }
}
```

& 可以作为选择器的第一个字符，其后可以跟随后缀生成复合的选择器，例如

```scss
#main {
  color: black;
  &-sidebar { border: 1px solid; }
}
```

### 属性嵌套

有些 CSS 属性遵循相同的命名空间 (namespace)，比如 font-family, font-size, font-weight 都以 font 作为属性的命名空间。为了便于管理这样的属性，同时也为了避免了重复输入，Sass 允许将属性嵌套在命名空间中

```scss
.funky {
  font: {
    family: fantasy;
    size: 30em;
    weight: bold;
  }
}
```

命名空间也可以包含自己的属性值，例如：

```js
.funky {
  font: 20px/24px {
    family: fantasy;
    weight: bold;
  }
}
```

编译为

```js
.funky {
  font: 20px/24px;
    font-family: fantasy;
    font-weight: bold;
}
```

## SassScript

```scss
$width: 5em;
#main {
  width: $width;
}
```

变量支持块级作用域，嵌套规则内定义的变量只能在嵌套规则内使用（局部变量），不在嵌套规则内定义的变量则可在任何地方使用（全局变量）。将局部变量转换为全局变量可以添加 !global 声明：

```scss
#main {
  $width: 5em !global;
  width: $width;
}

#sidebar {
  width: $width;
}
```

### 数据类型

+ 数字，1, 2, 13, 10px
+ 字符串，有引号字符串与无引号字符串，"foo", 'bar', baz
+ 颜色，blue, #04a3f9, rgba(255,0,0,0.5)
+ 布尔型，true, false
+ 空值，null
+ 数组 (list)，用空格或逗号作分隔符，1.5em 1em 0 2em, Helvetica, Arial, sans-serif
+ maps, 相当于 JavaScript 的 object，(key1: value1, key2: value2)

`#{}` (interpolation) 时，有引号字符串将被编译为无引号字符串

### 数组

数组本身没有太多功能，但 Sass list functions 赋予了数组更多新功能：nth 函数可以直接访问数组中的某一项；join 函数可以将多个数组连接在一起；append 函数可以在数组中添加新值；而 @each 指令能够遍历数组中的每一项。

数组中可以包含子数组，比如 1px 2px, 5px 6px 是包含 1px 2px 与 5px 6px 两个数组的数组。如果内外两层数组使用相同的分隔方式，需要用圆括号包裹内层，所以也可以写成 (1px 2px) (5px 6px)

如果数组中包含空数组或空值，编译时将被清除，比如 1px 2px () 3px 或 1px 2px null 3px。

### map

Maps可视为键值对的集合。 和Lists不同Maps必须被圆括号包围，键值对被逗号分割 。`map-get`函数用于查找键值，`map-merge`函数用于map和新加的键值融合，`@each`命令可添加样式到一个map中的每个键值对。 Maps可用于任何Lists可用的地方，在List函数中 Map会被自动转换为List ， 如 (key1: value1, key2: value2)会被List函数转换为 key1 value1, key2 value2

#### 除法运算

`/`在 CSS 中通常起到分隔数字的用途，SassScript 作为 CSS 语言的拓展当然也支持这个功能，同时也赋予了 / 除法运算的功能。也就是说，如果 / 在 SassScript 中把两个数字分隔，编译后的 CSS 文件中也是同样的作用。

以下三种情况 / 将被视为除法运算符号：

+ 如果值，或值的一部分，是变量或者函数的返回值
+ 如果值被圆括号包裹
+ 如果值是算数表达式的一部分

```scss
p {
  font: 10px/8px;             // Plain CSS, no division
  $width: 1000px;
  width: $width/2;            // Uses a variable, does division
  width: round(1.5)/2;        // Uses a function, does division
  height: (500px/2);          // Uses parentheses, does division
  margin-left: 5px + 8px/2px; // Uses +, does division
}
```

编译为

```scss
p {
  font: 10px/8px;
  width: 500px;
  height: 250px;
  margin-left: 9px;
  }
```

如果需要使用变量，同时又要确保 / 不做除法运算而是完整地编译到 CSS 文件中，只需要用 #{} 插值语句将变量包裹。

```scss
p {
  $font-size: 12px;
  $line-height: 30px;
  font: #{$font-size}/#{$line-height};
}
```

编译为

```scss
p {
  font: 12px/30px;
  }
```

### 颜色值运算

颜色值的运算是分段计算进行的，也就是分别计算红色，绿色，以及蓝色的值：

```scss
p {
  color: #010203 + #040506; // color: #050709;
  color: #010203 * 2; // color: #020406;
  color: rgba(255, 0, 0, 0.75) + rgba(0, 255, 0, 0.75); // color: rgba(255, 255, 0, 0.75);

  $translucent-red: rgba(255, 0, 0, 0.5);
  color: opacify($translucent-red, 0.3); // color: rgba(255, 0, 0, 0.8);
  background-color: transparentize($translucent-red, 0.25); // background-color: rgba(255, 0, 0, 0.25);

  // IE 滤镜
  $green: #00ff00;
  div {
  filter: progid:DXImageTransform.Microsoft.gradient(enabled='false', startColorstr='#{ie-hex-str($green)}', endColorstr='#{ie-hex-str($translucent-red)}');
}

}
```

IE 滤镜要求所有的颜色值包含 alpha 层，而且格式必须固定 #AABBCCDD，使用 ie_hex_str 函数可以很容易地将颜色转化为 IE 滤镜要求的格式。

```scss
$translucent-red: rgba(255, 0, 0, 0.5);
$green: #00ff00;
div {
  filter: progid:DXImageTransform.Microsoft.gradient(enabled='false', startColorstr='#{ie-hex-str($green)}', endColorstr='#{ie-hex-str($translucent-red)}'); // filter: progid:DXImageTransform.Microsoft.gradient(enabled='false', startColorstr=#FF00FF00, endColorstr=#80FF0000);
}
```

### 字符串运算

```scss
p {
  cursor: e + -resize; // cursor: e-resize;
  content: "Foo " + Bar; // content: "Foo Bar";
  font-family: sans- + "serif"; // font-family: sans-serif;
  margin: 3px + 4px auto; // margin: 7px auto;
  content: "I ate #{5 + 10} pies!"; // content: "I ate 15 pies!";
  content: "I ate #{$value} pies!"; // content: "I ate pies!";
}

```

### 圆括号

圆括号可以用来影响运算的顺序：

```scss
p {
  width: 1em + (2em * 3); // width: 7em;
}
```

### 函数

SassScript 定义了多种函数，有些甚至可以通过普通的 CSS 语句调用：

```scss
p {
  color: hsl(0, 100%, 50%); // color: #ff0000;
}
```

#### 关键词参数

Sass 函数允许使用关键词参数 (keyword arguments)，上面的例子也可以写成：

```scss
p {
  color: hsl($hue: 0, $saturation: 100%, $lightness: 50%);
}
```

虽然不够简明，但是阅读起来会更方便。关键词参数给函数提供了更灵活的接口，以及容易调用的参数。关键词参数可以打乱顺序使用，如果使用默认值也可以省缺，另外，参数名被视为变量名，下划线、短横线可以互换使用

### 插值语句 #{}

```scss
$name: foo;
$attr: border;
p.#{$name} { // p.foo
  #{$attr}-color: blue; // border-color: blue;
}
```

```scss
p {
  $font-size: 12px;
  $line-height: 30px;
  font: #{$font-size}/#{$line-height}; // font: 12px/30px;
}
```

### & 符

```scss
.foo.bar .baz.bang, .bip.qux {
  $selector: &; // ((".foo.bar" ".baz.bang"), ".bip.qux")
}
```

```scss
@mixin does-parent-exist {
  @if & {
    &:hover {
      color: red;
    }
  } @else {
    a {
      color: red;
    }
  }
}
```

### !default

可以在变量的结尾添加 !default 给一个未通过 !default 声明赋值的变量赋值

```scss
$content: "First content";
$content: "Second content?" !default;
$new_content: "First time reference" !default;

#main {
  content: $content; // content: "First content";
  new-content: $new_content; // new-content: "First time reference";
}

// 变量是 null 空值时将视为未被 !default 赋值。

$content: null;
$content: "Non-null content" !default;

#main {
  content: $content; // content: "Non-null content";
}
```

### @import

```scss
// 普通导入
@import "foo.scss";
// 不带扩展名
@import "foo";
// 同时导入多个
@import "rounded-corners", "text-shadow";
// 使用url动态导入
$family: unquote("Droid+Sans");
@import url("http://fonts.googleapis.com/css?family=\#{$family}");
// @import url("http://fonts.googleapis.com/css?family=Droid+Sans");
```

### @media

```scss
.sidebar {
  width: 300px;
  @media screen and (orientation: landscape) {
    width: 500px;
  }
}
```

编译成

```scss
.sidebar {
  width: 300px;
}
@media screen and (orientation: landscape) {
  .sidebar {
    width: 500px;
  }
}
```

```scss
@media screen {
  .sidebar {
    @media (orientation: landscape) {
      width: 500px;
    }
  }
}
```

编译成

```scss
@media screen and (orientation: landscape) {
  .sidebar {
    width: 500px;
  }
}
```

### @extend

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}

a:hover {
  background-color: red;
}

.hoverlink {
  @extend a:hover; // 复杂选择器也可以被继承
}

```

#### @extend-Only 选择器

占位符选择器

```scss
#context a%extreme {
  color: blue;
  font-weight: bold;
  font-size: 2em;
}

.notice {
  @extend %extreme;
}
```

编译为

```scss
#context a.notice {
  color: blue;
  font-weight: bold;
  font-size: 2em;
}
```

## 控制指令

### @if

```scss
p {
  @if 5 < 3 {
    border: 2px dotted; // border: 1px solid;
  }
}

$type: monster;
p {
  @if $type == ocean {
    color: blue;
  } @else if $type == matador {
    color: red;
  } @else {
    color: black;
  }
}

// p {
//   color: green;
// }
```

### @for

```scss
@for $i from 1 through 2 {
  .item-#{$i} { width: 2em * $i; }
}

// .item-1 {
//   width: 2em;
// }
// .item-2 {
//   width: 4em;
// }

@for $i from 1 to 2 {
  .item-#{$i} { width: 2em * $i; }
}

// .item-1 {
//   width: 2em;
// }
```

### @each

```scss
@each $animal in puma, sea-slug, egret, salamander {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
  }
}

@each $animal, $color, $cursor in (puma, black, default),
                                  (sea-slug, blue, pointer),
                                  (egret, white, move) {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
    border: 2px solid $color;
    cursor: $cursor;
  }
}

@each $header, $size in (h1: 2em, h2: 1.5em, h3: 1.2em) {
  #{$header} {
    font-size: $size;
  }
}
```

### @while

```scss
$i: 6;
@while $i > 0 {
  .item-#{$i} { width: 2em * $i; }
  $i: $i - 2;
}
```

### @mixin

```scss
@mixin large-text {
  font: {
    family: Arial;
    size: 20px;
    weight: bold;
  }
  color: #ff0000;
}
```

```scss
@mixin clearfix {
  display: inline-block;
  &:after {
    content: ".";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
  }
  * html & { height: 1px }
}
```

### @include

使用 @include 指令引用混合样式，格式是在其后添加混合名称，以及需要的参数（可选）

```scss
.page-title {
  @include large-text;
  padding: 4px;
  margin-top: 10px;
}
```

### 参数

```scss
@mixin sexy-border($color, $width) {
  border: {
    color: $color;
    width: $width;
    style: dashed;
  }
}
p { @include sexy-border(blue, 1in); }
```

#### 关键字参数

```scss
p { @include sexy-border($color: blue); }
h1 { @include sexy-border($color: blue, $width: 2in); }
```

#### 参数变量

```scss
@mixin box-shadow($shadows...) {
  -moz-box-shadow: $shadows;
  -webkit-box-shadow: $shadows;
  box-shadow: $shadows;
}
.shadows {
  @include box-shadow(0px 4px 5px #666, 2px 6px 10px #999);
}
```

```scss
@mixin colors($text, $background, $border) {
  color: $text;
  background-color: $background;
  border-color: $border;
}
$values: #ff0000, #00ff00, #0000ff;
.primary {
  @include colors($values...);
}
```

### 向混合样式中导入内容

在引用混合样式的时候，可以先将一段代码导入到混合指令中，然后再输出混合样式，额外导入的部分将出现在 @content 标志的地方：

```scss
@mixin apply-to-ie6-only {
  * html {
    @content;
  }
}
@include apply-to-ie6-only {
  #logo {
    background-image: url(/logo.gif);
  }
}
```

### 函数指令

```scss
$grid-width: 40px;
$gutter-width: 10px;

@function grid-width($n) {
  @return $n * $grid-width + ($n - 1) * $gutter-width;
}

#sidebar { width: grid-width(5); } // or
#sidebar { width: grid-width($n: 5); }
```
