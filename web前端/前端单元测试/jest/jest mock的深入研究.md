# 深入研究 jest mock

jest对象会自动出现在每一个测试文件的作用域里，不需要去额外引入和定义

## Mock Moudule

[文档地址](https://jestjs.io/docs/en/24.x/jest-object)

### `jest.disableAutomock()`

这个方法被调用后，就会使用模块的原始实现，而不是auto mock后的实现

### `jest.enableAutomock()`

这个方法被调用后，就会使用模块auto mock后的实现

### `jest.genMockFromModule(moduleName)`

这个方法会将给定模块自动mock

#### 自动mock的行为

函数： 创建一个新的mock function,没有正式的参数，被调用时返回undefined。 async函数也是一样。
类: 创建新类， 维护原始类的接口， mock所有成员函数和属性
对象: 创建一个深拷贝的对象，维护所有的键， 它们的值会被mock
数组: 创建空数组，忽略原始值。
原始数据类型： 创建与模块原始的属性具有相同原始值的属性

Example:

```js
// utils.js
export default {
  authorize: () => {
    return 'token';
  },
  isAuthorized: secret => secret === 'wizard',
};
```

```js
// __tests__/genMockFromModule.test.js
const utils = jest.genMockFromModule('../utils').default;
utils.isAuthorized = jest.fn(secret => secret === 'not wizard');

test('implementation created by jest.genMockFromModule', () => {
  expect(utils.authorize.mock).toBeTruthy();
  expect(utils.isAuthorized('not wizard')).toEqual(true);
});
```

> *注意* 只有使用mock后的模块才会使用mock后的实现，在mock之前的模块将使用原始实现。

```js
// Api.js
import axios from 'axios';

export default {
  getData(reqData) {
    return axios.get({
      url: '/haha',
      params: reqData,
    });
  },
  postData(reqData) {
    return axios.post({
      url: '/haha',
      params: reqData,
    });
  },
};

```

```js
import Api from './Api';

// 模拟axios模块
const axios = jest.genMockFromModule('axios');

// 使用mock后的axios封装一个请求函数
const getData = () => axios.get('/test');

it('use genMockFromModule', async () => {
  const data = { haha: '666' };
  axios.get = jest.fn(() => Promise.resolve(data));
  // mockImplementation写法效果一样
  // axios.get.mockImplementation(() => Promise.resolve(data));
  expect(await axios.get('/test')).toEqual(data);
  expect(await getData()).toEqual(data);

  try {
    await Api.postData(data);
  } catch (e) {
    expect(e).toEqual(new Error('Network Error'));
  }
  expect.assertions(3);
});

```

> **结果**：第三个test捕获并断言到了`Network Error`，控制台console.error输出
> `Error: connect ECONNREFUSED 127.0.0.1:80`，即这个test中并没有使用mock出
> 来的 `axios.get` 而是发了真实的`axios`请求.
> **结论**：在test块中模块只有在test块中显式调用才会使用mock后的实现。

## `jest.mock`

```js
import axios from 'axios';
import Api from './Api';

// 模拟axios模块
jest.mock('axios');

// 使用mock后的axios封装一个请求函数
const getData = () => axios.get('/test');

it('use jest.mock', async () => {
  const data = { haha: '666' };
  axios.get = jest.fn(() => Promise.resolve(data));
  // mockImplementation写法效果一样
  // axios.get.mockImplementation(() => Promise.resolve(data));
  expect(await axios.get('/test')).toEqual(data);
  expect(await getData()).toEqual(data);
  expect(await Api.getData(data)).toEqual(data);

  axios.create = jest.fn(() => axios);
  expect(await Api.getReqBaseIns(data)).toEqual(data);
});

```

与genMockFromModule不同的是，jest.mock可以mock外部导入的模块


## Mock Function

### `jest.spyOn`
