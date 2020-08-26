# TDD

## TDD的开发流程 (Red-Green Development)

Test Diver Development

1.编写测试用例
2.运行测试
3.编写代码
4.优化代码
5.重复上述步骤

### 优势

1.长期减少回归bug
2.代码质量更好(组织可维护性)
3.测试覆盖率高
4.错误测试代码不容易出现

## vue jest

### 安装与配置

`npm install @vue/cli@3.8.4 -g`

`vue create toDoList`

`npm run test:unit`

### 测试dom

```js
it('renders props.msg when passed', () => {
  const root = document.createElement('div')
  root.className = 'root'
  document.body.appendChild(root)
  new Vue({
    render: h => h(HelloWorld, {
      props: {
        msg: 'dell lee'
      }
    })
  }).$mount('.root')
  expect(document.getElementByClassName('hello').length).toBe(1)
})
```

```js
it('renders props.msg when passed', () => {
  const msg = 'dell lee'
  const wrapper = shallowMount(HelloWorld, {
    propsData: { msg }
  })
  expect(wrapper.text()).toMatch(msg)
  expect(wrapper.find('.mm')).toMatch(msg)
  expect(wrapper.findAll('.mm').length).toBe(1)
  wrapper.setProps({ msg: 'hello'})
  expect(wrapper.props('msg')).toEqual('hello')
})
```

shallowMount浅渲染，不会去渲染子组件，只会占位
mount会渲染子组件

### 快照测试

```js
it('组件渲染正常', () => {
  const wrapper = shallowMount(HelloWorld, {
    propsData: { msg: 'dell lee' }
  })
  expect(wrapper).toMatchSnapshot()
})

```

## react环境中配置jest

`npm install create-react-app@3.0.1 -g`

`create-react-app jest-react`

`git add .`

`git commit -m ".."`

`npm run eject`

根目录下新建`jest.config.js`
把package.json中的内容取出来放到jest.config.js中

```js
module.exports = {
  //...
}

```

## Enzyme的配置及使用