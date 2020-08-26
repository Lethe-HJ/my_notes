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
且jest会将`jest.mock`提升到代码块的顶部。

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

### `jest.unmock(moduleName)`

这个API告诉jest不要从`require()`中返回指定模块的模拟版本，而是使用真实实现。
**用途**：你希望直接测试这个模块的时候。

### `jest.doMock(moduleName, factory, options)`

jest.mock 会自动提升至代码块顶部，使用jest.doMock则不会

import 命令会有提升行为，会提升至文件顶部，因此我们需要使用`require`或`import`函数来动态导入

**使用场景**: 在一个测试文件中需要多次模拟某个模块时

```js
beforeEach(() => {
  jest.resetModules();
});

test('moduleName 1', () => {
  jest.doMock('../moduleName', () => {
    return jest.fn(() => 1);
  });
  const moduleName = require('../moduleName');
  expect(moduleName()).toEqual(1);
});

test('moduleName 2', () => {
  jest.doMock('../moduleName', () => {
    return jest.fn(() => 2);
  });
  const moduleName = require('../moduleName');
  expect(moduleName()).toEqual(2);
});

test('moduleName 3', () => {
  jest.doMock('../moduleName', () => {
    return {
      __esModule: true,
      default: 'default1',
      foo: 'foo1',
    };
  });
  return import('../moduleName').then(moduleName => {
    expect(moduleName.default).toEqual('default1');
    expect(moduleName.foo).toEqual('foo1');
  });
});
```

### `jest.dontMock(moduleName)`

和`jest.mock`一样，`jest.unmock` 也会自动提升至代码块顶部
而`jest.dontMock`不会有这样的行为

### `jest.setMock(moduleName, moduleExports)`

显式地提供模块系统应该为指定模块返回的模拟对象
一般我们不会去用这个API，因为jest.mock的第二个参数也能达到这个定制的效果

### `jest.requireActual(moduleName)`

返回真实模块，而非模拟后的模块，绕过模块是否应该接收模拟实现的检查

```js
jest.mock('../myModule', () => {
  // Require the original module to not be mocked...
  const originalModule = jest.requireActual(moduleName);

  return {
    __esModule: true, // Use it when dealing with esModules
    ...originalModule,
    getRandom: jest.fn().mockReturnValue(10),
  };
});

const getRandom = require('../myModule').getRandom;

getRandom(); // Always returns 10
```

### `jest.requireMock(moduleName)`

返回模拟后的模块而不是实际模块，绕过模块是否应该使用实际实现的检查

### `jest.resetModules()`

重置模块的注册表（所有所需模块的缓存），用于隔离不同test之间的状态，避免相互影响

```js
beforeEach(() => {
  jest.resetModules();
});

test('works', () => {
  const sum = require('../sum');
});

test('works too', () => {
  const sum = require('../sum');
  // sum is a different copy of the sum module from the previous test.
});
```

### `jest.isolateModules(fn)`

isolatemodules (fn)比jest.resetModules()更进一步，它为在回调函数中加载的模块创建一个沙箱注册表。
这对于为每个测试隔离特定模块非常有用，这样本地模块状态在测试之间就不会冲突。

```js
let myModule;
jest.isolateModules(() => {
  myModule = require('myModule');
});

const otherCopyOfMyModule = require('myModule');

```

## Mock Function

### `jest.fn(implementation)`

返回一个新的mock function， 你可以为它提供具体实现

```js
const mockFn = jest.fn();
mockFn();
expect(mockFn).toHaveBeenCalled();

// With a mock implementation:
const returnsTrue = jest.fn(() => true);
console.log(returnsTrue()); // true;

```

### `jest.isMockFunction(fn)`

返回布尔值，给定的函数是否是模拟函数

### `jest.spyOn(object, methodName)`

创建一个类似于jest.fn的模拟函数, 它会跟踪`objetc[methodName]`的调用，返回一个jest模拟函数

`jest.spyOn` 会调用`spied`方法,你可以通过以下方式修改这一行为

```js
jest.spyOn(object, methodName).mockImplementation(() => customImplementation)
// or
object[methodName] = jest.fn(() => customImplementation);
```

```js
const video = {
  play() {
    return true;
  },
  _volume: false,
  // it's a setter!
  set volume(value) {
    this._volume = value;
  },
  get volume() {
    return this._volume;
  },
};

module.exports = video;
```


```js
const video = require('./video');

test('plays video', () => {
  const spy = jest.spyOn(video, 'play');
  const isPlaying = video.play();

  expect(spy).toHaveBeenCalled();
  expect(isPlaying).toBe(true);

  spy.mockRestore();
});

test('plays video', () => {
  const spy = jest.spyOn(video, 'volume', 'set'); // volume set方法
  audio.volume = 100;

  expect(spy).toHaveBeenCalled();
  expect(audio.volume).toBe(100);

  spy.mockRestore();
});
```

### `jest.clearAllMocks()`

清空 所以mocks的 `mock.calls` 和 `mock.instances` 属性，相当于在每一个被mocked的函数上调用了`.mockClear()`方法

### `jest.restoreAllMocks()`

恢复所有mocks为原始值， 相当于在每一个函数上调用了`.mockRestore()`方法，但是这个方法仅仅对由`jest.spyOn`创建的mock
有效，其它的mock需要使用`.mockRestore()`手动恢复



## Mock timers



### jest.useFakeTimers()

使用假定时器



### jest.useRealTimers()

使用真实的定时器



### jest.runAllTicks()

耗尽队列中的宏任务



### jest.advanceTimersByTime(msToRun)

队列中的所有定时器都将向前推进指定时间