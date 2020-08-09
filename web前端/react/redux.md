# redux

## Redux介绍

Redux是一个用来管理管理数据状态和UI状态的JavaScript应用工具。
随着JavaScript单页应用（SPA）开发日趋复杂，JavaScript需要管
理比任何时候都要多的state（状态），Redux就是降低管理难度的

![text](./img/2020-08-08-11-43-09的屏幕截图.png)

![text](./img/2020-08-08-11-43-09的屏幕截图.png)

## 安装redux

`npm install --save redux`

store

```js
//store/index.js
import { createStore } from 'redux' // 引入createStore方法
import reducer from './reducer'
const store = createStore(reducer, window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()) // 创建数据存储仓库
// 上述第二个参数是用于Redux Dev Tools调试
export default store //暴露出去
```

reducer

```js
//store/reducer.js
const defaultState = {
  inputValue : 'Write Something',
  list:[
      '早上4点起床，锻炼身体',
      '中午下班游泳一小时'
  ]
}  //默认数据
export default (state = defaultState,action)=>{
  if(action.type === 'changeInput'){
    let newState = JSON.parse(JSON.stringify(state)) //深度拷贝state
    newState.inputValue = action.value
    return newState
  }
  if(action.type === 'addItem' ){ //根据type值，编写业务逻辑
    let newState = JSON.parse(JSON.stringify(state))
    newState.list.push(newState.inputValue)  //push新的内容到列表中去
    newState.inputValue = ''
    return newState
  }
  return state
}
```

## 操作store值

```js
// TodoList.js
import React, { Component } from 'react';
import 'antd/dist/antd.css'
import { Input , Button , List } from 'antd'
import store from './store'

class TodoList extends Component {
  constructor(props){
    super(props)
    this.state=store.getState();
    this.changeInputValue= this.changeInputValue.bind(this)
    this.storeChange = this.storeChange.bind(this)  //转变this指向
    this.clickBtn = this.clickBtn.bind(this)
    store.subscribe(this.storeChange) //订阅Redux的状态
  }
  render() {
    return ( 
      <div style={{margin:'10px'}}>
        <div>
          <Input
            placeholder={this.state.inputValue}
            style={{ width:'250px', marginRight:'10px'}}
            onChange={this.changeInputValue}
          />
          <Button type="primary" onClick={this.clickBtn}>增加</Button>
        </div>
        <div style={{margin:'10px',width:'300px'}}>
          <List
            bordered
            dataSource={this.state.list}
            renderItem={item=>(<List.Item>{item}</List.Item>)}
          />
        </div>
      </div>
    );
  }
  
  changeInputValue(e){
    const action ={
      type:'changeInput',
      value:e.target.value
    }
    store.dispatch(action)
  }
  
  storeChange(){
    this.setState(store.getState())
  }

  clickBtn(){
    const action = { type:'addItem'}
    store.dispatch(action)
  }
}
export default TodoList;
```

store只是一个仓库，它并没有管理能力，它会把接收到的action自动转发给Reducer

reducer中
state: 指的是原始仓库里的状态
action: 指的是action新传递的状态

## 优化结构

我们优化一下代码结构
先把action的type拆出去

```js
//actionTypes.js
export const  CHANGE_INPUT = 'changeInput'
export const  ADD_ITEM = 'addItem'
export const  DELETE_ITEM = 'deleteItem'
```

再把action拆出去

```js
// actionCreator.js
import { CHANGE_INPUT , ADD_ITEM , DELETE_ITEM } from './actionTypes'

export const changeInputAction = value => ({
  type: CHANGE_INPUT,
  value: value
})

export const addItemAction = () => ({ type: ADD_ITEM })

export const deleteItemAction = index => ({
  type: DELETE_ITEM,
  index
})
```

```js
// TodoList.js
import React, { Component } from 'react';
import 'antd/dist/antd.css'
import { Input , Button , List } from 'antd'
import store from './store'
import { changeInputAction, addItemAction, deleteItemAction } from './store/actionCreators' 

class TodoList extends Component {
  constructor(props){
    super(props)
    this.state=store.getState();
    this.changeInputValue= this.changeInputValue.bind(this)
    this.storeChange = this.storeChange.bind(this)  //转变this指向
    this.clickBtn = this.clickBtn.bind(this)
    store.subscribe(this.storeChange) //订阅Redux的状态
  }
  render() {
    return (
      <div style={{margin:'10px'}}>
        <div>
          <Input
            placeholder={this.state.inputValue}
            style={{ width:'250px', marginRight:'10px'}}
            onChange={this.changeInputValue}
          />
          <Button type="primary" onClick={this.clickBtn}>增加</Button>
        </div>
        <div style={{margin:'10px',width:'300px'}}>
          <List
            bordered
            dataSource={this.state.list}
            renderItem={(item, index)=>(<List.Item onClick={this.deleteItem.bind(this, index)}>{item}</List.Item>)}
          />
        </div>
      </div>
    );
  }
  
  changeInputValue(e){
    store.dispatch(changeInputAction(e.target.value))
  }
  
  clickBtn(){
    store.dispatch(addItemAction())
  }

  deleteItem (index) {
    store.dispatch(deleteItemAction(index))
  }

  storeChange(){
    this.setState(store.getState())
  }
}
export default TodoList;
```

注意: reducer必须是纯函数

Store必须是唯一的
只有store能改变自己的内容，Reducer不能改变

## 拆分UI

```js
// TodoList
import React, { Component } from 'react';
import 'antd/dist/antd.css'
import { Input , Button , List } from 'antd'
class TodoListUi extends Component {

  render() {
    return (
      <div style={{margin:'10px'}}>
        <div>
          <Input  
            style={{ width:'250px', marginRight:'10px'}}
            onChange={this.props.changeInputValue}
            value={this.props.inputValue}
          />
          <Button
            type="primary"
            onClick={this.props.clickBtn}
          >增加</Button>
        </div>
        <div style={{margin:'10px',width:'300px'}}>
          <List
            bordered
            dataSource={this.props.list}
            renderItem={(item,index)=>(<List.Item onClick={(index)=>{this.props.deleteItem(index)}}>{item}</List.Item>)}
          />
        </div>
      </div>
    );
  }
}

export default TodoListUi;
```