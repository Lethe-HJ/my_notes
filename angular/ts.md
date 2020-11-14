<<<<<<< HEAD:web前端/angular.js/ts.md
# ts

安装typescript
`npm install -g cnpm --registry=https//registry.npm.taobao.org`
`cnpm install -g typescript`
tsc -v 验证
=======
# 安装typescript

`npm install -g cnpm --registry=https//registry.npm.taobao.org`
`cnpm install -g typescript`
`tsc -v` 验证
>>>>>>> a6a7dfa91c08cc3f2b7436ebabbff89371ddef5f:web前端/前端基础/typescript/入门.md

编译ts成es5
tsc index.ts

TypeScript 编译的时候即使报错了，还是会生成编译结果
如果要在报错的时候终止 js 文件的生成，可以在 tsconfig.json 中配置 noEmitOnError 

## 原始数据类型

JavaScript 的类型分为两种：原始数据类型（Primitive data types）和对象类型（Object types）

原始数据类型包括：布尔值、数值、字符串、null、undefined 以及 ES6 中的新类型 Symbol。

### 布尔值

```ts
// 布尔类型boolean
var flag:boolean = true

// 注意，使用构造函数 Boolean 创造的对象不是布尔值 new Boolean() 返回的是一个 Boolean 对象
let createdByNewBoolean: boolean = new Boolean(1);

// 直接调用 Boolean 也可以返回一个 boolean 类型：
let createdByBoolean: boolean = Boolean(1);
```

在 TypeScript 中，boolean 是 JavaScript 中的基本类型，而 Boolean 是 JavaScript 中的构造函数。其他基本类型（除了 null 和 undefined）也一样

### 数值

```ts
let decLiteral: number = 6;
let hexLiteral: number = 0xf00d;
// ES6 中的二进制表示法
let binaryLiteral: number = 0b1010;
// ES6 中的八进制表示法
let octalLiteral: number = 0o744;
let notANumber: number = NaN;
let infinityNumber: number = Infinity;
```

编译结果

```js
var decLiteral = 6;
var hexLiteral = 0xf00d;
// ES6 中的二进制表示法
var binaryLiteral = 10;
// ES6 中的八进制表示法
var octalLiteral = 484;
var notANumber = NaN;
var infinityNumber = Infinity;
```

其中 0b1010 和 0o744 是 ES6 中的二进制和八进制表示法，它们会被编译为十进制数字。

### 字符串

使用 string 定义字符串类型：

```ts
let myName: string = 'Tom';
let myAge: number = 25;

// 模板字符串
let sentence: string = `Hello, my name is ${myName}.
I'll be ${myAge + 1} years old next month.`;
```

编译结果：

```js
var myName = 'Tom';
var myAge = 25;
// 模板字符串
var sentence = "Hello, my name is " + myName + ".
I'll be " + (myAge + 1) + " years old next month.";
```

其中 ` 用来定义 ES6 中的模板字符串，${expr} 用来在模板字符串中嵌入表达式。

### 空值

JavaScript 没有空值（Void）的概念，在 TypeScript 中，可以用 void 表示没有任何返回值的函数：

```ts
function alertName(): void {
    alert('My name is Tom');
}
```

声明一个 void 类型的变量没有什么用，因为你只能将它赋值为 undefined 和 null：

```ts
let unusable: void = undefined;
```

### Null 和 Undefined

在 TypeScript 中，可以使用 null 和 undefined 来定义这两个原始数据类型：

```ts
let u: undefined = undefined;
let n: null = null;
```

与 void 的区别是，undefined 和 null 是所有类型的子类型。也就是说 undefined 类型的变量，可以赋值给 number 类型的变量：

```ts
// 这样不会报错
let num: number = undefined;

// 这样也不会报错
let u: undefined;
let num: number = u;
```

而 void 类型的变量不能赋值给 number 类型的变量：

```ts
let u: void;
let num: number = u;

// Type 'void' is not assignable to type 'number'.
```

## 任意值

任意值（Any）用来表示允许赋值为任意类型。
如果是一个普通类型，在赋值过程中改变类型是不被允许的：

```ts
let myFavoriteNumber: string = 'seven';
myFavoriteNumber = 7;

// index.ts(2,1): error TS2322: Type 'number' is not assignable to type 'string'.
```

但如果是 any 类型，则允许被赋值为任意类型。

```ts
let myFavoriteNumber: any = 'seven';
myFavoriteNumber = 7;

// 在任意值上访问任何属性都是允许的：

let anyThing: any = 'hello';
console.log(anyThing.myName);
console.log(anyThing.myName.firstName);

// 也允许调用任何方法：

let anyThing: any = 'Tom';
anyThing.setName('Jerry');
anyThing.setName('Jerry').sayHello();
anyThing.myName.setFirstName('Cat');
```

可以认为，声明一个变量为任意值之后，对它的任何操作，返回的内容的类型都是任意值。
未声明类型的变量§

变量如果在声明的时候，未指定其类型，那么它会被识别为任意值类型：

let something;
something = 'seven';
something = 7;

something.setName('Tom');

等价于

let something: any;
something = 'seven';
something = 7;

something.setName('Tom');


```ts
// 数组类型
let arr1:number[]=[1,2,3,4]
let arr2:Array<number>=[1,2,3,4]
let arr3:any[]=["123",2,3]

// 元组类型 数组类型的子类型
let arr:[string,number,boolean]=["ts", 3.14, true]

// 枚举类型
enum Flag {success=1,error=-1} //如果里面的success和error不赋值则默认为索引值
var f:Flag=Flag.success
enum Color{red,blue=5,orange}//分别为0,5,6

// 任意类型
var num:any=123;
num="1234";

// 其他类型never
// null undefied 都是nerver的子类型
var b:null;
var a:undefied;
var c:nerver;

// undefied
var num1:number;
console.log(num1);//报错 undefied
var num2:undefied;
console.log(num2);//输出undefied
var num3:number|undefied;
console.log(num3);//赋不赋值都不会报错

// void 空类型
// 说明方法无返回值
function run():void{
    console.log("hahah")
}
```

## 函数

### 函数的定义

```ts
//es5

function run(){
    return 'run';
}

var run2 = function(){//匿名函数
    return 'run2';
}

//ts中函数的定义

function run3:string(){
    return 'run3'
}

var run4 = function():number{//匿名函数
    return 1;
}


//ts中传参

function getInfo(name:string,age:number):string{//匿名函数类似
    return `${name} --- $${age}`
}
getInfo('zhangsan',20);

function getInfo(name:string,address:string="湖南", age?:number):string{
    //第一个是位置参数
    //第二个是默认参数
    //第三个是可选参数 可选参数必须在最后
    return `${name} --- $${age}`
}

//剩余参数 三点运算符 解包
function sum(...result:number[]):number{
    var sum=0;
    for(let i=0;i<result.length;i++){
        sum+=result[i];
    }
    return sum;
}

```

### 方法重载

es5中后面的同名方法会覆盖前面的同名方法
ts中同名方法满足参数不一样则会发生重载

```ts
//参数类型不同
function getInfo(name:string):string;
function getInfo(age:number):string;

function getInfo(str:any):any{
    if(typeof str==="string"){
        return "我叫" + str;
    }else{
        return `我${str}岁了`;
    }

}

//参数个数不同
function getInfo(name:string):string;
function getInfo(name:string, age:number):string;

function getInfo(name:any,age?:any):any{
    if(age){
        return `我叫${name},我${age}岁了`;
    }else{
        return `我叫${name};
    }

}

```

### 箭头函数 es6

```ts
//es5
setTimeout(function(){
    alert('run');
},1000);

//es6 内部this指向上下文
setTimeout(()=>{
    alert('run');
},1000);

```

### 类

// es5中的类

```ts

function Person(){
    this.name="张三";
    this.age=20;
    this.run=function(){//实例方法
        alert("run");
    }
}
//原型链上的属性会被多个实例共享, 构造函数不会
Person.prototype.sex="男";
Person.prototypework=function(){
    alert(this.name + "在工作");
}

Person.getInfo=function(){//静态方法
    alert("我是静态方法");
}
var p = new Person();
p.run();
Person.getInfo();

//Web类 继承Person类 原型链+对象冒充的组合继承模式
function Web(){
    Person.call(this);
}
var w=new Web();
w.run();//可以继承构造函数中的方法
w.Web();//报错 不能继承原型链中的方法


//Web类 继承Person类 原型链实现继承
 function Person(){
    this.name='张三';  /*属性*/
    this.age=20;
    this.run=function(){  /*实例方法*/
        alert(this.name+'在运动');
    }

}
Person.prototype.sex="男";
Person.prototype.work=function(){
        alert(this.name+'在工作');

}

function Web(){}

Web.prototype=new Person();   //原型链实现继承
var w=new Web();
//原型链实现继承:可以继承构造函数里面的属性和方法 也可以继承原型链上面的属性和方法
w.run();
w.work();

//原型链实现继承的问题
function Person(name,age){
    this.name=name;  /*属性*/
    this.age=age;
    this.run=function(){  /*实例方法*/
        alert(this.name+'在运动');
    }
}
Person.prototype.sex="男";
Person.prototype.work=function(){
        alert(this.name+'在工作');

}

var p=new Person('李四',20);
p.run();

function Person(name,age){
    this.name=name;  /*属性*/
    this.age=age;
    this.run=function(){  /*实例方法*/
        alert(this.name+'在运动');
    }

}
Person.prototype.sex="男";
Person.prototype.work=function(){
    alert(this.name+'在工作');

}

function Web(name,age){}

Web.prototype=new Person();

var w=new Web('赵四',20);   //实例化子类的时候没法给父类传参

w.run();

var w1=new Web('王五',22);



//原型链+对象冒充的组合继承模式
function Person(name,age){
    this.name=name;  /*属性*/
    this.age=age;
    this.run=function(){  /*实例方法*/
        alert(this.name+'在运动');
    }

}
Person.prototype.sex="男";
Person.prototype.work=function(){
    alert(this.name+'在工作');

}


function Web(name,age){
    Person.call(this,name,age);   //对象冒充继承   实例化子类可以给父类传参
}

Web.prototype=new Person();

var w=new Web('赵四',20);   //实例化子类的时候没法给父类传参

w.run();
w.work();

var w1=new Web('王五',22);



//原型链+对象冒充继承的另一种方式


function Person(name,age){
        this.name=name;  /*属性*/
        this.age=age;
        this.run=function(){  /*实例方法*/
            alert(this.name+'在运动');
        }

}
Person.prototype.sex="男";
Person.prototype.work=function(){
        alert(this.name+'在工作');

}



function Web(name,age){
    Person.call(this,name,age);   //对象冒充继承  可以继承构造函数里面的属性和方法、实例化子类可以给父类传参
}

Web.prototype=Person.prototype;

var w=new Web('赵四',20);   //实例化子类的时候没法给父类传参

w.run();
w.work();

var w1=new Web('王五',22);
```

### ts中的类

```ts
class Person{
    name:string;   //属性  前面省略了public关键词
    constructor(n:string){  //构造函数   实例化类的时候触发的方法
        this.name=n;
    }
    run():void{
        alert(this.name);
    }
}
var p=new Person('张三');

p.run()


//ts中实现继承  extends、 super
class Person{
    name:string;
    constructor(name:string){
        this.name=name;
    }
    run():string{
        return `${this.name}在运动`
    }
}

class Web extends Person{
    constructor(name:string){
        super(name);  /*初始化父类的构造函数*/
    }
}
var w=new Web('李四');
alert(w.run());



```

类里面的修饰符  typescript里面定义属性的时候给我们提供了 三种修饰符

public :公有          在当前类里面、 子类  、类外面都可以访问
protected：保护类型    在当前类里面、子类里面可以访问 ，在类外部没法访问
private ：私有         在当前类里面可以访问，子类、类外部都没法访问

属性如果不加修饰符 默认就是 公有 （public）

### 静态方法 静态属性

```js
class Person{
    name:string;   //属性  前面省略了public关键词
    static hello:string = "hello world"; // 静态属性
    static print() { // 静态方法
        console.log()
    }
    constructor(n:string){  //构造函数   实例化类的时候触发的方法
        this.name=n;
    }
    run():void{
        alert(this.name);
    }
}
```

### 抽象类和抽象方法

typescript中的抽象类：它是提供其他类继承的基类，不能直接被实例化。
用abstract关键字定义抽象类和抽象方法，抽象类中的抽 象方法不包含具体实现并且必须在派生类中实现。
abstract抽象方法只能放在抽象类里面
抽象类和抽象方法用来定义标准 。   标准：Animal 这个类要求它的子类必须包含eat方法
抽象类定义了标准:

```js
abstract class Animal{
    public name:string;
    constructor(name:string){
        this.name=name;
    }

    abstract eat():any;  //抽象方法不包含具体实现并且必须在派生类中实现。
    run(){
        console.log('其他方法可以不实现')
    }
}
```

```js
class Dog extends Animal{

    //抽象类的子类必须实现抽象类里面的抽象方法
    constructor(name:any){
        super(name)
    }
    eat(){

        console.log(this.name+'吃粮食')
    }
}
```