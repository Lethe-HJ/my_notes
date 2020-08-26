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

class Api {
  static instance = axios.create();

  static getData(reqData) {
    return axios.get({
      url: '/haha',
      params: reqData,
    });
  }

  static postData(reqData) {
    return axios.post({
      url: '/haha',
      params: reqData,
    });
  }

  static getReqBaseIns(reqData) {
    return Api.instance.get({
      url: '/haha',
      params: reqData,
    });
  }
}

export default Api;


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

> **结果**：第三个expect捕获并断言到了`Network Error`，控制台console.error输出
> `Error: connect ECONNREFUSED 127.0.0.1:80`，即这个test中并没有使用mock出
> 来的 `axios.get` 而是发了真实的`axios`请求.
> **结论**：在test块中模块只有在test块中显式调用才会使用mock后的实现。

## `jest.mock`

`jest.mock('axios')` 会使auto mock的axios模块代替原有的axios模块

```js
jest.mock('axios', () => {
  return {
    create: jest.fn(() => mockAxios)
  }
})
```

第二个参数是一个工厂函数,它的返回值会代替原有的axios模块

```js
import mockAxios from 'axios';
import Api from './Api';

const mockData = { haha: '666' };

// 模拟axios模块
jest.mock('axios', () => {
  return {
    create: jest.fn(() => mockAxios),
    get: jest.fn(() => Promise.resolve(mockData)),
  };
});

// 使用mock后的axios封装一个请求函数
const getData = () => mockAxios.get('/test');

it('use jest.mock', async () => {
  expect(await mockAxios.get('/test')).toEqual(mockData);
  expect(await getData()).toEqual(mockData);
  expect(await Api.getData(mockData)).toEqual(mockData);
  // console.log(mockAxios.create())
  // console.log(await Api.getReqBaseIns(mockData))
  expect(await Api.getReqBaseIns(mockData)).toEqual(mockData);
});


```

真实场景下的应用

```js
import { shallowMount, createLocalVue } from '@vue/test-utils';
import mockAxios from 'axios';
import Switch from '@/views/watch/resource_usage/Switch.vue';
import ElementUI from 'element-ui';

// 模拟axios模块
jest.mock('axios', () => {
  return {
    create: jest.fn(() => mockAxios),
    get: jest.fn(() => new Promise()),
    interceptors: {
      request: { use: jest.fn(), eject: jest.fn() },
      response: { use: jest.fn(), eject: jest.fn() },
    },
  };
});
const data1 = {
  data: {
    virtual_switch_throughput_topn: {
      in: {
        n: 123,
        last_minutes: 123,
        data: [
          ['compute22', [3564, 478]],
          ['compute14', [644, 47]],
          ['compute19', [333, 1444]],
        ],
      },
      out: {
        n: 123,
        last_minutes: 123,
        data: [
          ['compute23', [3564, 478]],
          ['compute12', [644, 47]],
          ['compute29', [333, 1444]],
        ],
      },
    },
  },
  status: 200,
};
const data2 = {
  data: {
    virtual_switch_data_list: {
      sort_by: 'in',
      list: [
        {
          node_id: 'xxxx',
          hostname: 'xxx',
          num_vnet: 'xxxx',
          rate: [25, 63],
          packets: [144, 1343432],
        },
      ],
    },
  },

  status: 200,
};

describe('Switch.vue', () => {
  it.only('test get request', (done) => {
    mockAxios.get.mockResolvedValueOnce(data1).mockResolvedValueOnce(data2);
    const localVue = createLocalVue();
    localVue.use(ElementUI);
    localVue.prototype.$echarts = {
      init: (elem) => ({
        chartElem: elem,
        showLoading: (obj) => obj,
      }),
      setOption: (option) => option,
      showLoading: (obj) => obj,
    };
    const wrapper = shallowMount(Switch, {
      localVue,
    });
    setTimeout(() => {
      console.log(wrapper.vm.virtualSwitchThroughputTopn);
      console.log(wrapper.vm.virtualSwitchDataList);
      done();
    }, 2000);
  });
});

```

与genMockFromModule不同的是，jest.mock可以mock外部导入的模块


## Mock Function

### `jest.spyOn`
