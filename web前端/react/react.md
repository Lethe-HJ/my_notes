# react

## 介绍react

ReactJS是由Facebook在2013年5月推出的一款JS前端开源框架,推出式主打特点式函数式编程风格。值得一说的是，到目前为止ReactJS是世界上使用人数最多的前端框架,它拥有全球最健全的文档和社区体系。我们这里学习的是React Fiber版本，也就是React16这个版本

## react的安装

[下载安装node](http://nodejs.cn/)

`npm config set registry https://registry.npm.taobao.org`  设置成淘宝npm
`npm install -g create-react-app` 安装官方脚手架
`create-react-app test1` 初始化

执行`cd test1`和`npm start` 就能在localhost:3000看到默认的react页面

## 项目目录介绍

### 根目录

`README.md`: 这个文件主要作用就是对项目的说明
`package.json`: 这个文件是webpack配置和项目包管理文件，项目中依赖的第三方包（包的版本）和一些常用命令配置都在这个里边进行配置
`package-lock.json`: 锁定安装时的版本号，并且需要上传到git，以保证其他人再npm install 时大家的依赖能保证一致。
`gitignore`: 这个是git的选择性上传的配置文件，比如一会要介绍的node_modules文件夹，就需要配置不上传。
`node_modules`: 这个文件夹就是我们项目的依赖包
`public`: 公共文件，里边有公用模板和图标等一些东西。
`src`: 主要代码编写文件夹

### public

这个文件都是一些项目使用的公共文件
`favicon.ico`: 这个是网站或者说项目的图标，一般在浏览器标签页的左上角显示。
`index.html`: 首页的模板文件，我们可以试着改动一下，就能看到结果。
`mainifest.json`: 移动端配置文件，这个会在以后的课程中详细讲解。

### src

这个目录里边放的是我们编写的代码
`index.js`: 这个就是项目的入口文件
`index.css`: 这个是index.js里的CSS文件。
`app.js`: 这个文件相当于一个方法模块，也是一个简单的模块化编程。
`serviceWorker.js`: 这个是用于写移动端开发的，PWA必须用到这个文件，有了这个文件，就相当于有了离线浏览的功能。

## hello world

删除src下面所有代码，新建index.js

```js
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
ReactDOM.render(<App />,document.getElementById('root'))
```

新建App.js

```js
import React, { Component } from "react";

class App extends Component{
    render(){
        return (
            <div>hello world</div>
        );
    }
}
export default App;
```

## JSX

```js
<ul className="my-list">
    <li>JSPang.com</li>
    <li>I love React</li>
</ul>

// 上述代码相当于

var child1 = React.createElement('li', null, 'JSPang.com');
var child2 = React.createElement('li', null, 'I love React');
var root = React.createElement('ul', { className: 'my-list' }, child1, child2);
```

## 基本语法

App.js

```js
import React, { Component } from "react";
import logo from "./logo.svg"

class App extends Component{
    render(){
        const name = "hujin";
        const jsx = <p>hahaha</p>
        function hi(name){
            return "hi " + name
        }
        return (
            <div>
                <h1>hello {name}</h1>
                <h1>{hi(name)}</h1>
                <img src={logo} style={{width:"100px"}}></img>
                {jsx}
            </div>
        );
    }
}
export default App;
```

## 组件

在src下新建components文件夹
新建CompType.js文件

```js
import React from "react"

//函数类型的组件
export function Welcome1(props){
    return <div>Welcome1, {props.name}</div>;
}

//基于类的组件
export class Welcome2 extends React.Component {
    render(){
        return <div>Welcome2, {this.props.name}</div>;
    }
}
```

React要求必须在一个组件的最外层进行包裹,
但是在做Flex布局的时候外层不能有包裹元素,
这时我们可以使用`<Fragment>`标签,需要先进行引入
如下所示:

```js
import React,{Component,Fragment } from 'react'

class Xiaojiejie extends Component{
    render(){
        return  (
            <Fragment>
               <div><input /> <button> 增加服务 </button></div>
               <ul>
                   <li>头部按摩</li>
               </ul>
            </Fragment>
        )
    }
}
export default Xiaojiejie

```

在App.js中添加

```js
{/* 组件 */}
<Welcome1 name="hujin"></Welcome1>
<Welcome2 name="hujin"></Welcome2>
```

###　组件的状态变化

在components文件夹下新建Clock.js文件

```js
import React, { Component } from 'react'

export default class Clock extends Component {
    //状态固定名字
    // state = {
    //     date: new Date()
    // }

    constructor(props){
      super(props) //调用父类的构造函数，固定写法
      this.state={
        date: new Date()
      }
    }

    componentDidMount(){
        this.timer = setInterval(() => {
            this.setState({
                date: new Date()
            })
        }, 1000);
    }

    componentWillUnmount(){
        clearInterval(this.timer);
    }

    render(){
        return (
            <div>
                {this.state.date.toLocaleTimeString()}
            </div>
        )
    }
}

```

在App.js中加入

```js
import Clock from './components/Clock';

// ...

{/* state状态变化 */}
<Clock></Clock>

```

可以看到不断变化的时钟

修改状态还可以这样,这样多次修改状态值依然生效

```js
this.setState(prevState => {
    return {
        counter: preState.counter + 1
    }
}))

// 或者这样
// this.setState({
//     counter:  1
//   }
// ))


```

### 条件渲染

```js
{this.props.title && <h1>{this.props.title}</h1>}
```

### 列表渲染

```js
<ul>
    {this.state.goods.map(good => <li key={good.id}>{good.text}</li>)}
</ul>
```

### 事件

```js
<button onClick={this.addList.bind(this)}> 增加服务 </button>
```

```js
//增加服务的按钮响应方法
addList(){
    this.setState({
        list:[...this.state.list,this.state.inputValue]
    })
}
```

```js
<ul>
  {
    this.state.list.map((item,index)=>{
        return (
            <li
                key={index+item}
                onClick={this.deleteItem.bind(this,index)}
            >
            {/* 正确注释的写法 */}
                {item}
            </li>
        )
    })
  }
</ul>  
```

在components文件夹下新建CartSample.js文件

```js
import React, { Component } from "react";

export default class CartSample extends Component {
  //   状态初始化一般放在构造器中
  constructor(props) {
    super(props);

    this.state = {
      goods: [
        { id: 1, text: "hhhhh" },
        { id: 2, text: "heiheihei" }
      ],
      text: "",
      cart: []
    };

    this.addGood = this.addGood.bind(this);
    //原生函数写法的this默认指向调用该函数的元素对象(在这里指button),
    //所以需要在constructor中绑定到当前CartSample对象
  }

  //回调函数声明为箭头函数
  textChange = e => {
    //箭头函数中的this默认指向当前对象(CartSample)
    this.setState({ text: e.target.value });
  };

  addGood() {
    this.setState(prevState => {
      return {
        goods: [//将原值和新值一起赋给goods
          ...prevState.goods,//需要把原值解包
          {
            id: prevState.goods.length + 1,
            text: prevState.text
          }
        ]
      };
    });
  }

  //   加购函数
  addToCart = good => {
    // 创建新购物车
    const newCart = [...this.state.cart];
    const idx = newCart.findIndex(c => c.id === good.id);
    const item = newCart[idx];
    if (item) {
      newCart.splice(idx, 1, { ...item, count: item.count + 1 });
    } else {
      newCart.push({ ...good, count: 1 });
    }
    // 更新
    this.setState({ cart: newCart });
  };

  //   处理数量更新
  add = good => {
    // 创建新购物车
    const newCart = [...this.state.cart];
    const idx = newCart.findIndex(c => c.id === good.id);
    const item = newCart[idx];
    newCart.splice(idx, 1, { ...item, count: item.count + 1 });

    // 更新
    this.setState({ cart: newCart });
  };

  minus = good => {
    // 创建新购物车
    const newCart = [...this.state.cart];
    const idx = newCart.findIndex(c => c.id === good.id);
    const item = newCart[idx];

    newCart.splice(idx, 1, { ...item, count: item.count - 1 });

    // 更新
    this.setState({ cart: newCart });
  };

  render() {
    //   const title = this.props.title ? <h1>this.props.title</h1> : null;
    return (
      <div>
        <ul>
          {this.state.goods.map(good => (
            <li key={good.id}>
              {good.text}
              <button onClick={() => this.addToCart(good)}>加购</button>
            </li>
          ))}
        </ul>

        <div>
          <input
            type="text"
            value={this.state.text}
            onChange={this.textChange}
          />
          <button onClick={this.addGood}>添加商品</button>
        </div>

        {/* 购物车 */}
        <Cart data={this.state.cart} minus={this.minus} add={this.add} />
      </div>
    );
  }
}

function Cart({ data, minus, add }) {
  return (
    <table>
      <tbody>
        {data.map(d => (
          <tr key={d.id}>
            <td>{d.text}</td>
            <td>
              <button onClick={() => minus(d)}>-</button>
              {d.count}
              <button onClick={() => add(d)}>+</button>
            </td>
            {/* <td>{d.price*d.count}</td> */}
          </tr>
        ))}
      </tbody>
    </table>
  );
}

```

## 父子组件传值

### 父组件向子组件传值

```js
<XiaojiejieItem content={item} />
```

```js
import React, { Component } from 'react'; //imrc
class XiaojiejieItem  extends Component { //cc

    render() {
        return (
            <div>{this.props.content}</div>
         );
    }
}

export default XiaojiejieItem;
```

注意:父组件传递过来的属性只能读,不能写(单向数据流)

### 子组件使用父组件的方法

```js
<ul>
  {
    this.state.list.map((item,index)=>{
      return (
        <XiaojiejieItem 
        key={index+item}  
        content={item}
        index={index}
        //关键代码-------------------start
        deleteItem={this.deleteItem.bind(this)}
        //关键代码-------------------end
        />
      )
    })
  }
</ul>
```

在子组件里就可以直接调用

```js
handleClick(){
    this.props.deleteItem(this.props.index)
}
```

## PropTypes

```js
import React, { Component } from 'react'; //imrc
import PropTypes from 'prop-types'

class XiaojiejieItem  extends Component { //cc

   constructor(props){
       super(props)
       this.handleClick=this.handleClick.bind(this)
   }

    render() { 
        return ( 
            <div onClick={this.handleClick}>
                {this.props.content}
            </div>
        );
    }

    handleClick(){

        this.props.deleteItem(this.props.index)
    }

}
 //--------------主要代码--------start
XiaojiejieItem.propTypes={
    content:PropTypes.string,
    deleteItem:PropTypes.func,
    index:PropTypes.number
}
 //--------------主要代码--------end
export default XiaojiejieItem;
```

必传值
avname:PropTypes.string.isRequired

默认值
XiaojiejieItem.defaultProps = {
    name:'666'
}

## ref

```js
<input
  id="jspang"
  className="input"
  value={this.state.inputValue}
  onChange={this.inputChange.bind(this)}
  //关键代码——----------start
  ref={(input)=>{this.input=input}}
  //关键代码------------end
  />
```

```js
inputChange(){
  this.setState({
    inputValue:this.input.value
  })
}
```

## 生命周期

Initialization:初始化阶段。
Mounting: 挂载阶段。
Updation: 更新阶段。
Unmounting: 销毁阶段

### Mounting阶段

Mounting阶段叫挂载阶段，伴随着整个虚拟DOM的生成，它里边有三个小的生命周期函数，分别是：

`componentWillMount` : 在组件即将被挂载到页面的时刻执行。
`render`: 页面state或props发生变化时执行。
`componentDidMount` : 组件挂载完成时被执行。

### Updation阶段

`shouldComponentUpdate`
函数会在组件更新之前，自动被执行
它要求返回一个布尔类型的结果，必须有返回值
如果你返回了false，这组件就不会进行更新了

`componentWillUpdate`
在组件更新之前，但shouldComponenUpdate之后被执行。但是如果shouldComponentUpdate返回false，这个函数就不会被执行了。

`componentDidUpdate`
在组件更新之后执行，它是组件更新的最后一个环节

`componentWillReceiveProps`
子组件接收props时执行
子组件接收到父组件传递过来的参数，父组件render函数重新被执行，这个生命周期就会被执行。
也就是说这个组件第一次存在于Dom中，函数是不会被执行的;
如果已经存在于Dom中，函数才会被执行

### Unmount阶段

`componentWillUnmount`
组件从页面中删除的时候执行

### 利用生命周期优化代码

```js
shouldComponentUpdate(nextProps,nextState){
  if(nextProps.content !== this.props.content){
      return true
  }else{
      return false
  }
}
```


## 一些坑

react 中的标签中的style class名应该为`className`
使用`dangerouslySetInnerHTML`可以解析HTML字符串
label标签的for在react中应该为htmlfor
setState是一个异步函数,但是setState方法提供了一个回调函数

```js
addList(){
    this.setState({
        list:[...this.state.list,this.state.inputValue],
        inputValue:''
        //关键代码--------------start
    },()=>{
        console.log(this.ul.querySelectorAll('div').length)
    })
    //关键代码--------------end
}
```

## 按需加载 与 ant design

`npm install antd --save`

```js
import React, { Component } from 'react'
import Button from 'antd/lib/button'  //普通用法
import 'antd/dist/antd.css'
export default class AntdTest extends Component {
  render() {
    return (
      <div>
        <Button type="primary">按钮</Button>
      </div>
    )
  }
}


```

### 配置按需加载

安装react-app-rewired取代react-scripts，可以扩展webpack的配置 ，类似vue.config.js
`npm install react-app-rewired@2.0.2-next.0 babel-plugin-import --save`

新建 config-overrides.js文件

```js
const { injectBabelPlugin } = require("react-app-rewired");
module.exports = function override(config, env) {
  config = injectBabelPlugin(
    // 在默认配置基础上注入
    // 插件名，插件配置
    ["import", { libraryName: "antd", libraryDirectory: "es", style: "css" }],
    config
  );

  config = injectBabelPlugin(
    ["@babel/plugin-proposal-decorators", { legacy: true }],
    config
  );

  return config;
};
```

将 package.json中的Script进行修改

```js
"scripts": {
    "start": "react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test",
    "eject": "react-app-rewired eject"
  },

```

重新 `npm start` 即可使修改生效

前面的代码换成

```js
import React, { Component } from 'react'
import {Button} from 'antd' // 按需加载的用法

export default class AntdTest extends Component {
  render() {
    return (
      <div>
        <Button type="primary">按钮</Button>
      </div>
    )
  }
}

```

### PureComponent

通常render函数会执行过多的次数, 可以用shouldComponentUpdate返回false来阻止不必要的render

```js
class Comment extends React.Component{

  shouldComponentUpdate(nextProps){
      if (nextProps.data.body === this.props.data.body &&
        nextProps.data.author === this.props.data.author) {
          return false;
      }
      return true;
  }

  render() {
    console.log("render comment");

    return (
      <div>
        <p>{this.props.body}</p>
        <p> --- {this.props.author}</p>
      </div>
    );
  }
}

```

PureComponent定制了shouldComponentUpdate后的Component（浅比较）

```js
class Comp extends React.PureComponent {}
```

只能进行浅比较,尽量避免深层次的变量传递

### React.memo

React v16.6.0 之后的版本，可以使用 React.memo 让函数式的组件也有PureComponent的功能

```js
const Joke = React.memo(() => (
  <div>
    {this.props.value || 'loading...' }
  </div>
  )
)

```

### 高阶组件和链式调用

```js
import React, { Component } from "react";

function Kaikeba(props) {
  return (
    <div>
      {props.stage}-{props.name}
    </div>
  );
}

const withkaikeba = Comp => {
  // 获取name, name可能来自于接口或其他手段
  const name = "高阶组件";
  console.log('withKaikeba');
  //return prorps => <Comp {...props} name={name} />;

  return class extends React.Component{//匿名类
    componentDidMount(){
      console.log('do something');
    }
    render(){
      return <Comp {...this.props} name={name} />;
    }
  };
};

const withLog = Comp => {
  console.log(Comp.name + "渲染了");
  return props => <Comp {...props} ></Comp>
}

const NewKaikeba = withKaikeba(Kaikeba)
const NewKaikeba1 = withLog(withKaikeba(withLog(Kaikeba)));

export default class Hoc extends Component {
  render() {
    return (
      <div>
        <NewKaikeba stage="React" />
        <NewKaikeba1 stage="React" />
      </div>
    )
  }
}

```

### 装饰器

ES7装饰器可用于简化高阶组件写法
`npm install --save-dev babel-plugin-transform-decorators-legacy`

修改package.js,加入如下config设置后 重启

```js
config = injectBabelPlugin( ['@babel/plugin-proposal-decorators', { "legacy": true }], config, )
```

```js
//将上面的Kaikeba函数改为class,并且将withLog,withKaikeba函数的定义放在前面

@withLog
@withKaikeba
@withLog
class Kaikeba extends Component {
  render() {
    return (
      <div>
        {this.props.stage}-{this.props.name}
      </div>
    );
  }
}

//装饰器的执行顺序从上至下 相当于 const Kaikeba = withLog(withKaikeba(withLog(Kaikeba)));
//后续 只需要调用 <Kaikeba stage="React" />
```

## 复合

```js
//Dialog 作为容器不关心内容和逻辑
function Dialog(props) {
  return (
    <div style={{ border: `4px solid ${props.color || "blue"}`}}>
      {props.children}
      <div className="footer">{props.footer}</div>
    </div>
  );
}

//WelcomeDialog 通过复合提供内容
function WelcomeDialog(props){
  return (
    <Dialog {...props}>
      <h1>欢迎光临</h1>
      <p>感谢使用react</p>
    </Dialog>
  );
}

const Api = {
  getUser(){
    return { name: "jerry", age: 20 };
  }
}

function Fetcher(props) {
  const user = Api[props.name]();
  return props.children(user)
}

function Filter({children, type}){
  return (
    <div>
      {React.Children.map(children, child =>{
        if (child.type !== type){
          return;
        }
        return child;
      })}
    </div>
  );
}

function RadioGroup(props){
  return (
    <div>
      {React.Children.map(props.children, child =>{
        return React.cloneElement(child, {name: props.name});
      })}
    </div>
  );
}

function Radio({children, ...rest}){
  return (
    <label>
      <input type="radio" {...rest} />
      {children}
    </label>
  );
}

export default function(){
  const footer = <button onClick={() => alert("确定!")}>确定</button>
  return (
    <div>
      <WelcomeDialog color="green" footer={footer} />
    </div>
    <Fetcher name="getUser">
      {({ name, age }) => (
        <p>
          {name}-{age}
        </p>
      )

      }
    </Fetcher>
    <Filter type="p">
      <h1>react</h1>
      <p>react很不错</p>
      <h1>vue</h1>
      <p>vue很不错</p>
    </Filter>
    <radioGroup name="mvvm">
      <Radio value="vue">vue</Radio>
      <Radio value="react">react</Radio>
      <Radio value="angular">angular</Radio>
    </radioGroup>
  )

}
```

## Hook 钩子

Hook是React16.8的新特性,它可以让你在不编写class的情况下使用state以及其他的React特性

Hook的特点:

+ 使你在无需修改组件结构的情况下复用状态逻辑

+ 可将组件中相互关联的部分拆分成更小的函数,复杂组件将变得更容易理解

+ 更简洁,更易理解的代码

准备工作
  升级react, react-dom
  `npm i react react-dom -S`

### State Hook 状态钩子

```js
import React, { useState } from "react";
export default function HooksTest() {
  // useState(initialState)，接收初始状态，返回一个状态变量和其更新函数
  const [count, setCount] = useState(0);
  const [age] = useState(20)
  const [fruit, setFruit] = useState('banama')
  const [fruits, setFruits] = useState(['banama', 'apple'])//fruits = ['banama', 'apple']
  return (
    <div>
      <p>点击了{count}次</p>
      <button onClick={() => setCount(count + 1)}>点击</button>
      <p>年龄:{age}</p>
      <p>选择的水果:{fruit}</p>
      <p>
        <input type="text" value={input} onChange={e=>setInput(e.target.value)}>
        <button onClick={()=>setFruits([...fruits, input])}>
          新增水果
        </button>
      </p>
      <ul>
        {fruit.map( f=>(<li key={f} onClick={()=>setFruit(f)}>{f}</li>) )}
      </ul>
      </p>
    </div>
  );
}

```

### Effect Hook 副作用钩子

useEffect 就是一个Effect Hook, 给函数组件增加了操作副作用的能力, 它跟class组件中的componentDidmount, componentDidUpdate 和 componentWillunmount具有相同的用途,只不过被合并成了一个API

```js
import React, { useEffect } from "react";
export default function HooksTest() {
  //副作用钩子会在每次渲染时都执行
  useEffect(() => { // Update the document title using the browser API
    document.title = `您点击了 ${count} 次`;
  });

  //如果只打算执行一次,传递第二个参数为[]
  //相当于componentDidMount
  useEffect(() => {
    // Update the document title using the browser API
    console.log("api调用");
  }, []);

  //在count变化时执行
  //第二个参数是依赖数组
  useEffect(() => { // Update the document title using the browser API
    document.title = `您点击了 ${count} 次`;
  }, [count]);
}
```

### 自定义钩子

自定义钩子hook是一个函数,名称用use开头,函数内部可以调用其他钩子

```js
function useAge(){
  const [age, setAge] = useState(0);
  useEffect(()=>{
    setTimeout(()=>{
      setAge(20);
    }, 2000);
    });
    return age;
}

//使用
const age = useAge();
<p>年龄 {age? age: 'loading...'}</p>
```

### 其他Hook

`useContext`, `useReducer`, `useCallback`, `useMemo`

## 上下文 Context

```js
import React, {useContext} from 'react'

const {Provider, Consumer} = React.createContext();

//使用consumer
function Child(prop){
  return (
    <div>Child:{prop.foo}</div>
  )
}

//使用钩子 useContext
fcuntion Child2(prop){
  const ctx = useContext(MyContext);
  return <div>Child2:{ctx.foo}</div>
}

//使用 contextType
class Child3 extends React.Component{
    static contextType = MyContext;
    render(){
      return <div>Child3: {this.context.foo}</div>
    }
}

export default function ContextTest(){
  return (
    <div>
      <Provider value={foo:'bar'}>
      {/* 使用方法一: Consumer*/}
        <Consumer>
          {value => <Child {...value} />}
        </Consumer>

      {/*使用方法二: useContext*/}
        <Child2 />

      {/*使用方法三: contextType*/}
        <Child3 />
      </Provider>
    </div>
  )
}

```

## 表单

```js
import React from "react";
import { Input, Button } from "antd";

// 创建一个高阶组件：扩展现有表单，事件处理、数据收集、校验
function kFormCreate(Comp) {//实际传过来的是KForm
  return class extends React.Component {
    constructor(props) {
      super(props);

      this.options = {};
      this.state = {};
    }

    handleChange = e => {
      const { name, value } = e.target;//解构出触发onChange事件的目标的name与当前value
      console.log(name, value);

      //更新state值并检验
      //[name]这样写 字段名会变成name name的值 不加[]的话 字段名会变成name
      //   确保值发生变化再校验
      this.setState({ [name]: value }, () => {//状态设置完成之后 执行回调函数
        this.validateField(name);
      });
    };

    // 单项校验
    validateField = field => {
      // 1. 获取校验规则
      const rules = this.options[field].rules;
      // 任意一项失败则返回false
      const ret = !rules.some(rule => {
        if (rule.required) {
          if (!this.state[field]) {
            //校验失败
            this.setState({
              [field + "Message"]: rule.message
            });
            return true;
          }
        }
      });

      if (ret) { // 校验成功
        this.setState({
          [field + "Message"]: ""
        });
      }
      return ret;
    };

    // 校验所有字段
    validate = cb => {
      const rets = Object.keys(this.options).map(field =>
        this.validateField(field)
      );

      const ret = rets.every(v => v == true);//全部项都是true,ret才是true,否则是false
      cb(ret, this.state);
    };

    // 创建input包装器
    getFieldDec = (field, option) => {
      // 保存当前输入项配置
      this.options[field] = option;
      return InputComp => (
        <div>
          {React.cloneElement(InputComp, {
            name: field,
            value: this.state[field] || "",
            onChange: this.handleChange
          })}
          {/* 校验错误信息 */}
          {this.state[field+'Message'] && (
              <p style={{color:'red'}}>{this.state[field+'Message']}</p>
          )}
        </div>
      );
    };

    render() {
      return <Comp getFieldDec={this.getFieldDec} validate={this.validate} />;
    }
  };
}

//相当于KForm = kFormCreate(KForm)
@kFormCreate
class KForm extends React.Component {
  onSubmit = () => {
    console.log("submit");
    // 校验所有项
    this.props.validate((isValid, data) => {
      if (isValid) {
        //提交登录
        console.log("登录：", data);
        // 后续登录逻辑
      } else {
        alert("校验失败");
      }
    });
  };

  render() {
    const { getFieldDec } = this.props;
    return (
      <div>
        {getFieldDec("uname", {
          rules: [{ required: true, message: "用户名必填" }]
        })(<Input />)}

        {getFieldDec("pwd", {
          rules: [{ required: true, message: "密码必填" }]
        })(<Input type="password" />)}

        <Button onClick={this.onSubmit}>登录</Button>
      </div>
    );
  }
}

export default KForm;//这里的KForm已经是被装饰过了的


```

## redux

`npm i redux -S`

ReduxTest.js

```js
import React from "react";
import { connect } from "react-redux";

const mapStateToProps = state => ({ num: state });
const mapDispatchToProps = {
  add: () => ({type: "add"}),
  minus: () => ({type: "minus"})
};

//函数写法
function ReduxTest({ num, add, minus }) {
  return (
    <div>
      <p>{num}</p>
      <div>
        <button onClick={minus}>-</button>
        <button onClick={add}>+</button>
      </div>
    </div>
  );
}
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ReduxTest);
/////////////////////////////


// 装饰器写法
@connect(
  mapStateToProps,
  mapDispatchToProps
)
class ReduxTest extends React.Component {
  render() {
    const { num, minus, add, asyncAdd } = this.props;
    return (
      <div>
        <p>{num}</p>
        <div>
          <button onClick={minus}>-</button>
          <button onClick={add}>+</button>
          <button onClick={asyncAdd}>AsyncAdd</button>
        </div>
      </div>
    );
  }
}
export default ReduxTest;


```

## redux-thunk

`npm install redux-thunk --save`
`npm install redux-logger --save`

component/ReduxTest.js

```js
import React from "react";
// import store from "../store";
import { connect } from "react-redux";
import { add, minus, asyncAdd } from "../store/count.redux";

const mapStateToProps = state => ({ num: state.counter });
const mapDispatchToProps = { add, minus, asyncAdd };
// function ReduxTest({ num, add, minus }) {
//   return (
//     <div>
//       <p>{num}</p>
//       <div>
//         <button onClick={minus}>-</button>
//         <button onClick={add}>+</button>
//       </div>
//     </div>
//   );
// }
// export default connect(
//   mapStateToProps,
//   mapDispatchToProps
// )(ReduxTest);

// 装饰器写法
@connect(
  mapStateToProps,
  mapDispatchToProps
)
class ReduxTest extends React.Component {
  render() {
    const { num, minus, add, asyncAdd } = this.props;
    return (
      <div>
        <p>{num}</p>
        <div>
          <button onClick={minus}>-</button>
          <button onClick={add}>+</button>
          <button onClick={asyncAdd}>AsyncAdd</button>
        </div>
      </div>
    );
  }
}
export default ReduxTest;
```

store/index.js

```js
import { createStore, applyMiddleware, combineReducers } from "redux";
import logger from "redux-logger";
import thunk from "redux-thunk";
import { counterReducer } from "./count.redux";
import { user } from "./user.redux";

const store = createStore(
  combineReducers({ counter: counterReducer, user }),
  applyMiddleware(logger, thunk)
);

export default store;
```

store/count.redux.js

```js
export const counterReducer = (state = 0, action) => {
  switch (action.type) {
    case "add":
      return state + 1;
    case "minus":
      return state - 1;
    default:
      return state;
  }
};

// action creator
export const add = () => ({ type: "add" });
export const minus = () => ({ type: "minus" });
export const asyncAdd = () => dispatch => {
  //   做异步操作
  setTimeout(() => {
    dispatch({ type: "add" });
  }, 1500);
};
```

## react-router

```js
import React from "react";
import { BrowserRouter, Link, Route, Switch, Redirect } from "react-router-dom";
import { connect } from "react-redux";
import { login } from "../store/user.redux";

function Home(params) {
  return (
    <div>
      <h3>课程列表</h3>
      <ul>
        <li>
          <Link to="/detail/web">Web架构师</Link>
        </li>
        <li>
          <Link to="/detail/python">Python架构师</Link>
        </li>
      </ul>
    </div>
  );
}

// 当前用户信息
function About(params) {
  return (
    <div>
      <h3>个人中心</h3>
      <div>
        <Link to="/about/me">个人信息</Link>
        <Link to="/about/order">订单查询</Link>
      </div>
      <Switch>
        <Route path="/about/me" component={() => <div>Me</div>} />
        <Route path="/about/order" component={() => <div>order</div>} />
        <Redirect to="/about/me" />
      </Switch>
    </div>
  );
}
function NoMatch({ location }) {
  return <div>404, {location.pathname}不存在</div>;
}
// 传递进来路由器对象
function Detail(props) {
  // 1.history: 导航指令
  // 2.match: 获取参数信息
  // 3.location: 当前url信息
  console.log(props);

  return (
    <div>
      当前课程：{props.match.params.course}
      <button onClick={props.history.goBack}>后退</button>
    </div>
  );
}

const LoginProtectArg = state => ({ isLogin: state.user.isLogin });

const LoginOrNot = ({ component: Comp, isLogin, ...rest }) => {
    // 做认证
    // render:根据条件动态渲染组件
    let login_arg = {
        pathname: "/login",
        state: { redirect: props.location.pathname }
    }
    return (
        <Route {...rest} render={props =>
          isLogin ? (<Comp />) : (<Redirect to={ login_arg } />)
        }/>//没登陆就跳到/login 登陆了就重定向到Comp组件
    );
  };

// 路由守卫
// 用法：<PrivateRoute component={About} path="/about" ...>
const PrivateRoute = connect(LoginProtectArg)(LoginOrNot);

const LoginArg = state => ({
    isLogin: state.user.isLogin,
    loading: state.user.loading
    });

const LoginHtml = ({ location, isLogin, login, loading }) {
    const redirect = location.state.redirect || "/";//默认跳转路由为/
    return isLogin ? <Redirect to={redirect} /> : (
        <div>
        <p>用户登录</p>
        <hr />
        <button onClick={login} disabled={loading}>
            {loading ? "登录中..." : "登录"}
        </button>
        </div>
    );
}

// 登录组件
const Login = connect(LoginArg, { login })(LoginHtml);

export default function RouteSample() {
  return (
    <div>
      <BrowserRouter>
        <div>
          {/* 导航链接 */}
          <div>
            <Link to="/">首页</Link>
            <Link to="/about">关于</Link>
          </div>
            {/* 路由配置：路由即组件 */}
          {/* 路由匹配默认是包容性质 */}
          <Switch>
            <Route exact path="/" component={Home} />
            <Route path="/detail/:course" component= {Detail} />
            <PrivateRoute path="/about" component={About} />
            <Route path="/login" component={Login} />
            {/* 404：没有path，必然匹配 */}
            <Route component={NoMatch} />
          </Switch>
        </div>
      </BrowserRouter>
    </div>
  );
}
```

```js
const initial = {
  isLogin: false,
  loading: false
};

export const user = (state = initial, action) => {
  switch (action.type) {
    case "requestLogin":
      return {
        isLogin: false,
        loading: true
      };
    case "login":
      return {
        isLogin: true,
        loading: false
      };
    default:
      return state;
  }
};

// action creator
export const login = () => dispatch => {
  dispatch({ type: "requestLogin" });
  //   做异步操作
  setTimeout(() => {
    dispatch({ type: "login" });
  }, 2000);
};
```

## 动画

```css
.show{ opacity: 1; transition:all 1.5s ease-in;}
.hide{opacity: 0; transition:all 1.5s ease-in;}

```

```css
.show{ animation:show-item 2s ease-in forwards; }
.hide{ animation:hide-item 2s ease-in forwards; }

@keyframes hide-item{
    0% {
        opacity:1;
        color:yellow;
    }
    50%{
        opacity: 0.5 ;
        color:red;
    }
    100%{
        opacity:0;
        color: green;
    }
}

@keyframes show-item{
    0% {
        opacity:0;
        color:yellow;
    }
    50%{
        opacity: 0.5 ;
        color:red;
    }
    100%{
        opacity:1;
        color: green;
    }
}
```

### react-transition-group

`npm install react-transition-group --save`

```js
import { CSSTransition } from 'react-transition-group'
render() {
  return (
    <div>
      <CSSTransition 
        in={this.state.isShow}   //用于判断是否出现的状态
        timeout={2000}           //动画持续时间
        classNames="boss-text"   //className值，防止重复
        unmountOnExit // 元素退场时，自动把DOM也删除
      >
        <div>BOSS级人物-孙悟空</div>
      </CSSTransition>
      <div><button onClick={this.toToggole}>召唤Boss</button></div>
    </div>
    );
}

.input {border:3px solid #ae7000}

.boss-text-enter{
    opacity: 0;
}
.boss-text-enter-active{
    opacity: 1;
    transition: opacity 2000ms;

}
.boss-text-enter-done{
    opacity: 1;
}
.boss-text-exit{
    opacity: 1;
}
.boss-text-exit-active{
    opacity: 0;
    transition: opacity 2000ms;

}
.boss-text-exit-done{
    opacity: 0;
}
```

+ xxx-enter: 进入（入场）前的CSS样式；
+ xxx-enter-active:进入动画直到完成时之前的CSS样式;
+ xxx-enter-done:进入完成时的CSS样式;
+ xxx-exit:退出（出场）前的CSS样式;
+ xxx-exit-active:退出动画知道完成时之前的的CSS样式。
+ xxx-exit-done:退出完成时的CSS样式。

```js
import {CSSTransition , TransitionGroup} from 'react-transition-group'

<ul ref={(ul)=>{this.ul=ul}}>
  <TransitionGroup>
  {
    this.state.list.map((item,index)=>{
      return (
        <XiaojiejieItem
        key={index+item}  
        content={item}
        index={index}
        deleteItem={this.deleteItem.bind(this)}
        />
      )
    })
  }
  </TransitionGroup>
</ul>
```

```js
<ul ref={(ul)=>{this.ul=ul}}>
  <TransitionGroup>
  {
    this.state.list.map((item,index)=>{
      return (
        <CSSTransition
          timeout={1000}
          classNames='boss-text'
          unmountOnExit
          appear={true}
          key={index+item}  
        >
          <XiaojiejieItem
          content={item}
          index={index}
          deleteItem={this.deleteItem.bind(this)}
          />
        </CSSTransition>
      )
    })
  }
  </TransitionGroup>
</ul>  
<Boss />
</Fragment>
```