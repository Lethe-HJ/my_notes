# var,let,const与作用域

## let

### 代码块内有效

let是ES6新增的, let 是在代码块内有效，var 是在全局范围内有效:

```js
    for (var i = 0; i < 5; i++) {
        setTimeout(function(){
            console.log(i);
        })
    }//5 5 5 5 5

    for (let i = 0; i < 5; i++) {
        setTimeout(function(){
            console.log(i);
        })
    }//0 1 2 3 4
```

> 变量 i 是用 var 声明的，在全局范围内有效，所以全局中只有一个变量 i, 每次循环时，setTimeout 定时器里面的 i 指的是全局变量 i ，而循环里的十个 setTimeout 是在循环结束后才执行，所以此时的 i 都是 5。
> 变量 j 是用 let 声明的，当前的 j 只在本轮循环中有效，每次循环的 j 其实都是一个新的变量，所以setTimeout 定时器里面的 j 其实是不同的变量，即最后输出 01234。（若每次循环的变量 j 都是重新声明的，如何知道前一个循环的值？这是因为 JavaScript引擎内部会记住前一个循环的值）。

### 不能重复声明

let 只能声明一次 var 可以声明多次:

### 不存在变量提升

let 不存在变量提升，var 会变量提升:

```js
console.log(a);  //ReferenceError: a is not defined
let a = "apple";

console.log(b);  //undefined
var b = "banana";
```

> 变量 b 用 var 声明存在变量提升，所以当脚本开始运行的时候，b 已经存在了，但是还没有赋值，所以会输出 undefined。
> 变量 a 用 let 声明不存在变量提升，在声明变量 a 之前，a 不存在，所以会报错。

## const

const实在ES6中新增的, const 声明一个只读变量且必须初始化，声明之后不允许改变

```js
const PI = "3.1415926";
PI  // 3.1415926
```

### 暂时性死区:

```js
var PI = "a";
if(true){
  console.log(PI);  // ReferenceError: PI is not defined
  const PI = "3.1415926";
}
```

> ES6 明确规定，代码块内如果存在 let 或者 const，代码块会对这些命令声明的变量从块的开始就形成一个封闭作用域。代码块内，在声明变量 PI 之前使用它会报错。

### const 的本质

const 定义的变量并非常量，并非不可变，它定义了一个常量引用一个值。使用 const 定义的对象或者数组，其实是可变的

```js
// 创建常量对象
const car = {type:"Fiat", model:"500", color:"white"};

// 修改属性:
car.color = "red";

// 添加属性
car.owner = "Johnson";
```

但是我们不能对常量对象重新赋值：

*const 如何做到变量在声明初始化之后不允许改变的？其实 const 其实保证的不是变量的值不变，而是保证变量指向的内存地址所保存的数据不允许改动。此时，你可能已经想到，简单类型和复合类型保存值的方式是不同的。是的，对于简单类型（数值 number、字符串 string 、布尔值 boolean）,值就保存在变量指向的那个内存地址，因此 const 声明的简单类型变量等同于常量。而复杂类型（对象 object，数组 array，函数 function），变量指向的内存地址其实是保存了一个指向实际数据的指针，所以 const 只能保证指针是固定的，至于指针指向的数据结构变不变就无法控制了，所以使用 const 声明复杂类型对象时要慎重。*

## 作用域

在 ES6 之前，JavaScript 只有两种作用域： 全局变量 与 函数内的局部变量。

在函数外声明的变量作用域是全局的
在函数内部声明的变量作用域是局部的

### JavaScript 块级作用域(Block Scope)

使用var关键字声明的变量不具备块级作用域的特征, 在块外依然能够访问
ES6 可以使用 let 关键字来实现块级作用域。
let 声明的变量只在 let 命令所在的代码块 {} 内有效，在 {} 之外不能访问。

### 局部变量

在函数体内使用 var 和 let 关键字声明的变量有点类似。

它们的作用域都是 局部的:

```js
// 使用 var
function myFunction() {
    var carName = "Volvo";   // 局部作用域
}

// 使用 let
function myFunction() {
    let carName = "Volvo";   //  局部作用域
}
```

### 全局变量

在函数体外或代码块外使用 var 和 let 关键字声明的变量也有点类似。
它们的作用域都是 全局的:

```js
// 使用 var
var x = 2;       // 全局作用域

// 使用 let
let x = 2;       // 全局作用域
```

在HTML中 全局作用域是针对window对象,但使用 let 关键字声明的全局作用域变量不属于 window 对象:

```js
var carName = "Volvo";
// 可以使用 window.carName 访问变量
```

###　循环作用域

```js
var i = 5;
for (var i = 0; i < 10; i++) {
    // 一些代码...
}
// 这里输出 i 为 10
```

使用了 var 关键字，它声明的变量是全局的，包括循环体内与循环体外

```js
let i = 5;
for (let i = 0; i < 10; i++) {
    // 一些代码...
}
// 这里输出 i 为 5
```

使用 let 关键字， 它声明的变量作用域只在循环体内，循环体外的变量不受影响
