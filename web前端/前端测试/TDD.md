# TDD

## TDD的开发流程 (Red-Green Development)

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

### react环境中配置jest

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