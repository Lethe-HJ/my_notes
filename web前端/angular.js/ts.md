# ts

安装typescript
`npm install -g cnpm --registry=https//registry.npm.taobao.org`
`cnpm install -g typescript`
tsc -v 验证

编译ts成es5
tsc index.ts

### 布尔类型boolean
```ts
var flag:boolean = true
```

### 数字类型nuumber

```ts
var a:number=123
```

### 字符串类型

```ts
var str:string="this is ts"
```

### 数组类型

```ts
let arr1:number[]=[1,2,3,4]
let arr2:Array<number>=[1,2,3,4]
let arr3:any[]=["123",2,3]
```

### 元组类型

数组类型的子类型
```ts
let arr:[string,number,boolean]=["ts", 3.14, true]

```

### 枚举类型
```ts
enum Flag {success=1,error=-1} //如果里面的success和error不赋值则默认为索引值
var f:Flag=Flag.success

enum Color{red,blue=5,orange}//分别为0,5,6

```

### 任意类型

```ts
var num:any=123;
num="1234";
```


### 其他类型never

null undefied 都是nerver的子类型
```ts
var b:null;
var a:undefied;
var c:nerver;
```


```ts
var num1:number;
console.log(num1);//报错 undefied

var num2:undefied;
console.log(num2);//输出undefied

var num3:number|undefied;
console.log(num3);//赋不赋值都不会报错
```

### void类型

空类型
说明方法无返回值

```ts
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

var run2=function(){//匿名函数
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

```ts
//es5中的类
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


ts中的类

```ts

//ts中定义类：


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