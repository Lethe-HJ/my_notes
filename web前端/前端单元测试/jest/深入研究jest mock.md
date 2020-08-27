##　mock module



### `jest.genMockFromModule(moduleName)`

这个方法会将给定模块自动mock

#### `auto mock`



+ 函数： 创建一个新的mock function,没有正式的参数，被调用时返回undefined。 async函数也是一样。
+ 类: 创建新类， 维护原始类的接口， mock所有成员函数和属性
+ 对象: 创建一个深拷贝的对象，维护所有的键， 它们的值会被auto mock
+ 数组: 创建空数组，忽略原始值。
+ 原始数据类型： 创建与模块原始的属性具有相同原始值的属性



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

### `jest.mock`

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



## Mock Function

模拟函数也被称为'间谍', 它可以让你能监视到到其它代码对这个函数的调用信息。而不是仅仅测试它的输出。

### `jest.fn(implementation)`

返回一个新的mock function。

```js
const mockFn = jest.fn();
mockFn();
expect(mockFn).toHaveBeenCalled();

// With a mock implementation:
const returnsTrue = jest.fn(() => true);
console.log(returnsTrue()); // true;

```

你可以为它提供具体实现

```js
const mockFn = jest.fn((haha)=>{
  return haha + 'world'
})
```

如果没有提供具体实现，那么它将是一个类似这样的函数`function(){}`

[jest.fn的Api](./mock Function.md)



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





```js
import { shallowMount, createLocalVue } from '@vue/test-utils';
import Switch from '@/views/watch/resource_usage/Switch.vue';
import ElementUI from 'element-ui';
import * as Api from '@/api/watch/Switch';

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

const dataWrap = (data) => {
  return Promise.resolve(data);
};

describe('Switch.vue', () => {
  it.skip('test get request', (done) => {
    jest.spyOn(Api, 'getThroughputTopN').mockResolvedValue(dataWrap(data1));
    jest.spyOn(Api, 'getSwitchList').mockResolvedValue(dataWrap(data2));
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



### `mockFn.mockImplementation(fn)`

接受一个函数作为mockFn的实现，当mockFn被调用时，会使用这个实现。

`jest.fn(implementation)`是这个api更加简便的形式。

```js
const mockFn = jest.fn().mockImplementation(scalar => 42 + scalar);
// or: jest.fn(scalar => 42 + scalar);

const a = mockFn(0);
const b = mockFn(1);

a === 42; // true
b === 43; // true

mockFn.mock.calls[0][0] === 0; // true
mockFn.mock.calls[1][0] === 1; // true
```



```js
// SomeClass.js
module.exports = class SomeClass {
  m(a, b) {}
};

// OtherModule.test.js
jest.mock('./SomeClass'); // this happens automatically with automocking
const SomeClass = require('./SomeClass');
const mMock = jest.fn();
SomeClass.mockImplementation(() => {
  return {
    m: mMock,
  };
});

const some = new SomeClass();
some.m('a', 'b');
console.log('Calls to m: ', mMock.mock.calls);

```



### `mockFn.mockImplementationOnce(fn)`

与`mockFn.mockImplementation(fn)`不一样的是这个api被使用一次，就会将实现回归到原来的状态。

```js
const myMockFn = jest
  .fn()
  .mockImplementationOnce(cb => cb(null, true))
  .mockImplementationOnce(cb => cb(null, false));

myMockFn((err, val) => console.log(val)); // true

myMockFn((err, val) => console.log(val)); // false
```



### `mockFn.mockReturnValue(value)`

模拟返回值

```js
const mock = jest.fn();
mock.mockReturnValue(42);
mock(); // 42
mock.mockReturnValue(43);
mock(); // 43
```



### `mockFn.mockResolvedValue(value)`

这个api是下面这种写法的语法糖

```js
jest.fn().mockImplementation(() => Promise.resolve(value));
```

```js
test('async test', async () => {
  const asyncMock = jest.fn().mockResolvedValue(43);

  await asyncMock(); // 43
});

```



### `mockFn.mockRejectedValue(value)`

语法糖

```js
jest.fn().mockImplementation(() => Promise.reject(value));
```

模拟返回一个rejected状态的promise

```js
test('async test', async () => {
  const asyncMock = jest.fn().mockRejectedValue(new Error('Async error'));

  await asyncMock(); // throws "Async error"
});

```



## `Mock Timer`

原生的定时器函数(如：`setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`)并不是很方便测试，因为程序需要等待相应的延时。

jest给我们提供了可以控制时间流逝的定时器


```js
// timerGame.js
'use strict';

function timerGame(callback) {
  console.log('Ready....go!');
  setTimeout(() => {
    console.log("Time's up -- stop!");
    callback && callback();
  }, 1000);
}

module.exports = timerGame;

```

### ` jest.runAllTimers()`


```js
test('calls the callback after 1 second', () => {
  const timerGame = require('../timerGame');
  const callback = jest.fn();

  timerGame(callback);

  // 在这个时间点，定时器的回调不应该被执行
  expect(callback).not.toBeCalled();

  // “快进”时间使得所有定时器回调被执行
  jest.runAllTimers();

  // 现在回调函数应该被调用了！
  expect(callback).toBeCalled();
  expect(callback).toHaveBeenCalledTimes(1);
});

```

### `jest.runOnlyPendingTimers()`

在某些场景下你可能还需要“循环定时器”——在定时器的callback函数中再次设置一个新定时器。 对于这种情况，如果将定时器一直运行下去那将陷入死循环。所以在此场景下应该使用`jest.runOnlyPendingTimers()`

```js
// infiniteTimerGame.js
'use strict';

function infiniteTimerGame(callback) {
  console.log('Ready....go!');

  setTimeout(() => {
    console.log("Time's up! 10 seconds before the next game starts...");
    callback && callback();

    // Schedule the next game in 10 seconds
    setTimeout(() => {
      infiniteTimerGame(callback);
    }, 10000);
  }, 1000);
}

module.exports = infiniteTimerGame;

```

```js
// __tests__/infiniteTimerGame-test.js
'use strict';

jest.useFakeTimers();

describe('infiniteTimerGame', () => {
  test('schedules a 10-second timer after 1 second', () => {
    const infiniteTimerGame = require('../infiniteTimerGame');
    const callback = jest.fn();

    infiniteTimerGame(callback);

    // At this point in time, there should have been a single call to
    // setTimeout to schedule the end of the game in 1 second.
    expect(setTimeout).toHaveBeenCalledTimes(1);
    expect(setTimeout).toHaveBeenLastCalledWith(expect.any(Function), 1000);

    // Fast forward and exhaust only currently pending timers
    // (but not any new timers that get created during that process)
    jest.runOnlyPendingTimers();

    // At this point, our 1-second timer should have fired it's callback
    expect(callback).toBeCalled();

    // And it should have created a new timer to start the game over in
    // 10 seconds
    expect(setTimeout).toHaveBeenCalledTimes(2);
    expect(setTimeout).toHaveBeenLastCalledWith(expect.any(Function), 10000);
  });
});

```

### `jeste. advancertimersbytime (msToRun)`

所有通过setTimeout() 或setInterval() 而处于任务队列中等待中的“宏任务”和一切其他应该在本时间片中被执行的东西都会被执行

```js
// timerGame.js
'use strict';

function timerGame(callback) {
  console.log('Ready....go!');
  setTimeout(() => {
    console.log("Time's up -- stop!");
    callback && callback();
  }, 1000);
}

module.exports = timerGame;

```

```js
it('calls the callback after 1 second via advanceTimersByTime', () => {
  const timerGame = require('../timerGame');
  const callback = jest.fn();

  timerGame(callback);

  // 在这个时间点，回调函数不应该被执行
  expect(callback).not.toBeCalled();

  // “快进”时间，使得所有定时器回调都被执行
  jest.advanceTimersByTime(1000);

  // 到这里，所有的定时器回调都应该被执行了！
  expect(callback).toBeCalled();
  expect(callback).toHaveBeenCalledTimes(1);
});

```
