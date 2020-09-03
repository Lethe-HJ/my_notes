## 如何模拟

为什么要模拟？
因为有些模块，我们无法在单元测试中直接使用，比如`axios`、 `echarts`等。这个时候我们就需要在测试文件中模拟这些模块的内部实现，返回值等等。在不需要实际运行环境的情况下，达到单元测试的目的。


###　`模拟Module`

#### `jest.genMockFromModule(moduleName)`

这个方法会将给定模块自动mock，自动mock的行为如下:

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

#### `jest.mock`

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

### `jest.requireActual`

```js
// createUser.js
import fetch from 'node-fetch';

export const createUser = async () => {
  const response = await fetch('http://website.com/users', {method: 'POST'});
  const userId = await response.text();
  return userId;
};
```

```js
import fetch from 'node-fetch';
import {createUser} from './createUser';

jest.mock('node-fetch');
const {Response} = jest.requireActual('node-fetch');

test('createUser calls fetch with the right args and returns the user id', async () => {
  fetch.mockReturnValue(Promise.resolve(new Response('4')));

  const userId = await createUser();

  expect(fetch).toHaveBeenCalledTimes(1);
  expect(fetch).toHaveBeenCalledWith('http://website.com/users', {
    method: 'POST',
  });
  expect(userId).toBe('4');
});

```


### `模拟Function`

模拟函数也被称为'间谍', 它可以让你能监视到到其它代码对这个函数的调用信息。而不是仅仅测试它的输出。

#### `jest.fn(implementation)`

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



#### `jest.spyOn(object, methodName)`

创建一个jest.fn的模拟函数, 它会跟踪`objetc[methodName]`的调用，返回一个jest模拟函数。

它是`jest.fn`的语法糖，它与普通的mock方式不同的是`spyOn`会创建与原始实现一致的实现。

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

这样直接mock api封装的返回值，很方便，但测试无法覆盖到封装的api文件中。因此建议这样



```js
import httpRequest from '@/http/http.request.js'
const anxisGet = jest.spyOn(httpRequest.instance, 'get')

//使用时
anxisGet.mockResolvedValueOnce(data1).mockResolvedValueOnce(data2);
```



#### `mockFn.mockImplementation(fn)`

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



#### `mockFn.mockImplementationOnce(fn)`

与`mockFn.mockImplementation(fn)`不一样的是这个api被使用一次，就会将实现回归到原来的状态。

```js
const myMockFn = jest
  .fn()
  .mockImplementationOnce(cb => cb(null, true))
  .mockImplementationOnce(cb => cb(null, false));

myMockFn((err, val) => console.log(val)); // true

myMockFn((err, val) => console.log(val)); // false
```



#### `mockFn.mockReturnValue(value)`

模拟返回值

```js
const mock = jest.fn();
mock.mockReturnValue(42);
mock(); // 42
mock.mockReturnValue(43);
mock(); // 43
```



#### `mockFn.mockResolvedValue(value)`

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



#### `mockFn.mockRejectedValue(value)`

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



### `模拟Timer`

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

#### ` jest.runAllTimers()`


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

#### `jest.runOnlyPendingTimers()`

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

#### `jeste. advancertimersbytime (msToRun)`

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



###  `模拟ES6 Class`



```js
// sound-player-consumer.js
import SoundPlayer from './sound-player';

export default class SoundPlayerConsumer {
  static players = [];

  static closeAllSoundPlayer(){
    SoundPlayerConsumer.players = [];
  }
  
  constructor(favor) {
    this.favor = favor;
    this.soundPlayer = new SoundPlayer();
    SoundPlayerConsumer.players.push(this.soundPlayer)
  }

  playSomethingCool() {
    const coolSoundFileName = 'song.mp3';
    this.soundPlayer.playSoundFile(coolSoundFileName);
  }
}
```



```js
import SoundPlayer from './sound-player';
import SoundPlayerConsumer from './sound-player-consumer';
jest.mock('./sound-player'); // SoundPlayer is now a mock constructor

beforeEach(() => {
  // Clear all instances and calls to constructor and all methods:
  SoundPlayer.mockClear();
});

it('We can check if the consumer called the class constructor', () => {
  const soundPlayerConsumer = new SoundPlayerConsumer();
  expect(SoundPlayer).toHaveBeenCalledTimes(1);
});

it('We can check if the consumer called a method on the class instance', () => {
  // Show that mockClear() is working:
  expect(SoundPlayer).not.toHaveBeenCalled();

  const soundPlayerConsumer = new SoundPlayerConsumer();
  // Constructor should have been called again:
  expect(SoundPlayer).toHaveBeenCalledTimes(1);

  const coolSoundFileName = 'song.mp3';
  soundPlayerConsumer.playSomethingCool();

  // mock.instances is available with automatic mocks:
  const mockSoundPlayerInstance = SoundPlayer.mock.instances[0];
  const mockPlaySoundFile = mockSoundPlayerInstance.playSoundFile;
  expect(mockPlaySoundFile.mock.calls[0][0]).toEqual(coolSoundFileName);
  // Equivalent to above check:
  expect(mockPlaySoundFile).toHaveBeenCalledWith(coolSoundFileName);
  expect(mockPlaySoundFile).toHaveBeenCalledTimes(1);
});

```

## 如何测试

### 测试普通函数

对于普通函数的单元测试，我们只需关注于其参数与返回值。
需要对普通情况以及特殊情况都做相应的测试。

```js
const fibonacci = function () {
  let memo = [0, 1];
  let fib = function (n) {
    if (!Number.isInteger(n) || n < 0) return false
    if (memo[n] == undefined) {
        memo[n] = fib(n - 2) + fib(n - 1)
    }
    return memo[n]
  }
  return fib;
}()


describe('测试fibonacci函数', ()=>{
  test('测试fibonacci数列前10项', ()=>{
    const test = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
    for(let i=0; i<10; i++){
      expect(fibonacci(i)).toBe(test[i])
    }
  })
  
  test('测试fibonacci数列不符合常理的输入', ()=>{
    const test = [-1, '1', false, true, 1.1, null, undefined, [], {}]
    test.forEach((item) => {
      expect(fibonacci(item)).toBe(false)
    })
  })
})
```


### 测试ES6的类

```js
// sound-player.js
export default class SoundPlayer {
  constructor() {
    this.foo = 'bar';
  }

  playSoundFile(fileName) {
    console.log('Playing sound file ' + fileName);
  }
}
```

```js
// sound-player-consumer.js
import SoundPlayer from './sound-player';

export default class SoundPlayerConsumer {
  constructor() {
    this.soundPlayer = new SoundPlayer();
  }

  playSomethingCool() {
    const coolSoundFileName = 'song.mp3';
    this.soundPlayer.playSoundFile(coolSoundFileName);
  }
}
```

```js
// sound-player-consumer.test.js
import SoundPlayerConsumer from './sound-player-consumer';
import SoundPlayer from './sound-player';

const mockPlaySoundFile = jest.fn();
jest.mock('./sound-player', () => {
  return jest.fn().mockImplementation(() => {
    return {playSoundFile: mockPlaySoundFile};
  });
});

beforeEach(() => {
  SoundPlayer.mockClear();
  mockPlaySoundFile.mockClear();
});

it('新建对象', () => {
  const Consumer = new SoundPlayerConsumer();
  // Ensure constructor created the object:
  expect(Consumer).toBeTruthy();
});

it('在类中实例化其它类', () => {
  const soundPlayerConsumer = new SoundPlayerConsumer();
  expect(SoundPlayer).toHaveBeenCalledTimes(1);
});

it('实例属性的初始值', () => {
  // 有指定初始值
  const favorSong = 'take me to your heart.mp3'
  const Consumer1 = new SoundPlayerConsumer(favorSong);
  expect(Consumer1.favor).toBe(favorSong);

  // 没有指定初始值时
  const Consumer2 = new SoundPlayerConsumer();
  expect(Consumer2.favor).toBe(undefined);
});

it('类的静态属性', () => {
  const Consumer = new SoundPlayerConsumer();
  expect(SoundPlayerConsumer.players[0]).toEqual(Consumer.soundPlayer);
});

it('类的静态方法', () => {
  const Consumer1 = new SoundPlayerConsumer();
  const Consumer2 = new SoundPlayerConsumer();
  SoundPlayerConsumer.closeAllSoundPlayer();
  expect(SoundPlayerConsumer.players.length).toBe(0);
});

it('跟踪类对其它类方法的调用', () => {
  const soundPlayerConsumer = new SoundPlayerConsumer();
  const coolSoundFileName = 'song.mp3';
  soundPlayerConsumer.playSomethingCool();
  expect(mockPlaySoundFile.mock.calls[0][0]).toEqual(coolSoundFileName);
});


```

### 测试组件

```js
import { createLocalVue, mount } from '@vue/test-utils';
import ElementUI from 'element-ui';
import Vuex from 'vuex';
import * as ServersApi from '@/api/check/Servers';
// 接口模拟数据
import listData from '@tests/unit/mock/check/Servers';
import ListsNew from './ListsNew';

describe('ListsNew.vue', () => {
  let wrapper;
  let $table;
  let $tr;

  const localVue = createLocalVue();
  localVue.use(ElementUI);
  localVue.use(Vuex);

  // 模拟store
  const store = new Vuex.Store({
    state: {},
    mutations: {
      saveSwitchMac: jest.fn(),
    },
  });

  // mock ServersApi函数，返回模拟值
  jest.spyOn(ServersApi, 'getInfoAll').mockResolvedValue(listData);

  beforeEach(async () => {
    // 全局方法存根
    const $messages = {
      info: jest.fn(),
    };
    wrapper = mount(ListsNew, {
      store,
      localVue,
      mocks: {
        $messages,
      },
    });
    // 定时器模拟
    jest.useFakeTimers();
    // 获取table,tr等dom
    await wrapper.vm.$nextTick();
    // 注意el组件嵌套问题
    $table = wrapper.find('.table-wrapper .el-table__body-wrapper');
    $tr = $table.findAll('tr');
  });

  afterEach(() => {
    // 删除任何挂起的计时器
    jest.clearAllTimers();
  });

  // 测试接口数据是否处理正确
  it('test listData', async () => {
    // 请求函数执行
    await wrapper.vm.fetchHardwareInfoAll();
    const nodeIndex = wrapper.vm.nodeIndex;
    const list = wrapper.vm.list;
    // nodeIndex test
    expect(nodeIndex).toEqual([0, 1, 2, 3]);
    // list test
    expect(list).toEqual(listData.data.hardware_info);
  });

  // 测试异步请求数据渲染是否正确
  it('render table when created', async () => {
    await wrapper.vm.$nextTick();
    // 表格行数是否渲染正确
    expect($tr.length).toBe(listData.data.hardware_info.length);
    // 名称是否渲染正确
    const $tdName0 = $tr.at(0).findAll('td').at(2);
    const $tdName1 = $tr.at(1).findAll('td').at(2);
    // name字段有值时直接渲染当前内容
    expect($tdName0.text()).toContain(listData.data.hardware_info[0].name[0]);
    expect($tdName0.text()).toContain(listData.data.hardware_info[0].name[1]);
    // name字段无值时显示未定义
    expect($tdName1.text()).toContain('未定义');
  });

  // 测试定时器
  it('Whether the timer is executed correctly', () => {
    const spyFn = jest.spyOn(wrapper.vm, 'fetchHardwareInfoAll');
    // 注意定时器需清零
    wrapper.vm.refreshTimer = null;
    wrapper.vm.startDataCollecting();
    // 初始时请求函数调用1次
    expect(spyFn).toHaveBeenCalledTimes(1);

    // 注意定时器需清零
    wrapper.vm.refreshTimer = null;
    wrapper.vm.startDataCollecting();
    // 时间快进
    jest.advanceTimersByTime(10000);
    expect(spyFn).toHaveBeenCalledTimes(2);
  });

  // 状态值渲染是否正确
  it('state render', () => {
    // state值为ok
    expect(wrapper.vm.stateRender('ok')).toContain('正常');
    // state值为down
    expect(wrapper.vm.stateRender('down')).toContain('挂掉');
    // state值为nodata
    expect(wrapper.vm.stateRender('nodata')).toContain('无数据');
    // state值为空或其他值
    expect(wrapper.vm.stateRender('test')).toBeFalsy();
    expect(wrapper.vm.stateRender('')).toBeFalsy();
  });

  // 测试编辑状态table联动情况
  it('test table when it edit', async () => {
    const $trFir = $tr.at(0);
    // 获取第一行编辑按钮
    const $editBtn = $trFir.findAll('.operate-btn').at(1);
    // 编辑按钮触发点击
    $editBtn.trigger('click');

    // 注：触发了页面更新，需重新绘制，且重新获取dom
    await wrapper.vm.$nextTick();
    const $table1 = wrapper.find('.table-wrapper .el-table__body-wrapper');
    const $trFir1 = $table1.findAll('tr').at(0);
    // 当前行是否处于可编辑状态，输入框3个
    const $input = $trFir1.findAll('input[type="text"]');
    expect($input.length).toBe(3);
    // 当前行上移按钮是否处于不可编辑状态
    const $upBtn = $trFir1.find('.el-button');
    expect($upBtn.attributes('disabled')).toBeTruthy();
    // 当前行是否选中
    expect(wrapper.vm.selectedNode.length).toBe(1);
    expect(wrapper.vm.selectedNode[0]).toEqual(listData.data.hardware_info[0]);
  });

  // 测试编辑状态头部信息联动情况
  it('test confirm-group when it edit', async () => {
    const $trFir = $tr.at(0);
    // 获取第一行编辑按钮
    const $editBtn = $trFir.findAll('.operate-btn').at(1);
    // 编辑按钮触发点击
    $editBtn.trigger('click');

    // 注：触发了页面更新，需重新绘制
    await wrapper.vm.$nextTick();
    const $confirmGroup = wrapper.find('.confirm-group');
    const $dec = $confirmGroup.findAll('.dec');

    // 主机排列次序不显示
    expect($dec.at(0).html()).toContain('调整主机排列次序');
    expect($dec.at(0).attributes('style')).toContain('display: none;');

    // 主机描述定义显示
    expect($dec.at(1).html()).toContain('修改主机描述定义');
    expect($dec.at(1).attributes('style')).toBeFalsy();
  });

  // 测试第一行单个上移情况
  it('test single up for first line', () => {
    const $trFir = $tr.at(0);
    // 获取第一行上移按钮
    const $upBtn = $trFir.findAll('.operate-btn').at(0);
    // 点击上移
    $upBtn.trigger('click');
    // 第一个上移 期望不进行上移计算
    expect(wrapper.vm.list[0]).toEqual(listData.data.hardware_info[0]);
    // 直接返回message
    expect(wrapper.vm.$messages.info).toBeCalledTimes(1);
  });

  // 测试第三行单个上移情况
  it('test single up for third line', async () => {
    const $trThr = $tr.at(2);
    // 获取第三行上移按钮
    const $upBtn = $trThr.findAll('.operate-btn').at(0);
    // 点击上移
    $upBtn.trigger('click');
    // 期望已经上移至第二行
    expect(wrapper.vm.list[1]).toEqual(listData.data.hardware_info[2]);

    await wrapper.vm.$nextTick();
    // 重新获取,此时已在第二行
    const $trSec = $tr.at(1);
    const $upBtn1 = $trSec.findAll('.operate-btn').at(0);
    // 再次点击
    $upBtn1.trigger('click');
    // 期望已经上移至第一行
    expect(wrapper.vm.list[0]).toEqual(listData.data.hardware_info[2]);
  });

  // 测试批量上移按钮显示情况
  it('test multiple up button is show or hide', async () => {
    // 模拟选择
    const hardwareInfo = listData.data.hardware_info;
    const selection = [hardwareInfo[1]];
    wrapper.vm.handleSelectionChange(selection);

    await wrapper.vm.$nextTick();
    const $mulBtn = wrapper.find('.confirm-group > button');
    // 选中1个时，期望批量上移按钮不可点击
    expect($mulBtn.attributes('disabled')).toBeTruthy();

    // 选中2个
    const selection1 = [hardwareInfo[1], hardwareInfo[2]];
    wrapper.vm.handleSelectionChange(selection1);

    await wrapper.vm.$nextTick();
    const $mulBtn1 = wrapper.find('.confirm-group > button');
    // 选中2个时，期望批量上移按钮可用
    expect($mulBtn1.attributes('disabled')).toBeUndefined();
  });

  // 测试批量上移移动情况
  it('test multiple up is correct', async () => {
    // 模拟选择，选择第2个和第4个
    const hardwareInfo = listData.data.hardware_info;
    const selection = [hardwareInfo[1], hardwareInfo[3]];
    wrapper.vm.handleSelectionChange(selection);

    // 页面渲染
    await wrapper.vm.$nextTick();
    const $mulBtn = wrapper.find('.confirm-group > button');
    // 批量按钮点击
    $mulBtn.trigger('click');

    // 期望第2已经上移至第1
    expect(wrapper.vm.list[0]).toEqual(hardwareInfo[1]);
    // 第4已上移至第3
    expect(wrapper.vm.list[2]).toEqual(hardwareInfo[3]);

    // 批量按钮再次点击
    $mulBtn.trigger('click');
    // 已经移到第一了，直接返回message
    expect(wrapper.vm.$messages.info).toBeCalledTimes(1);
  });
});
```



## 如何debug

```js
// babel.config.js
module.exports = {
  presets: [
      [
          "@babel/preset-env",
          {
              targets: {
                  node: "current"
              }
          }
      ]
  ],
  plugins: ["transform-es2015-modules-commonjs"]
};


```

```js
//.vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Jest Tests",
      "type": "node",
      "request": "launch",
      "runtimeArgs": [
        "--inspect-brk",
        "${workspaceRoot}/node_modules/jest/bin/jest.js",
        "--runInBand"
      ],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "port": 9229
    }
  ]
}
```

`cnpm install --save-dev babel-jest @babel/core @babel/preset-env babel-plugin-transform-es2015-modules-commonjs`

