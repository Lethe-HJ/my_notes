# mock Function



## `mockFn.getMockName()`

返回`mockFn.mockName(value)`设置的mockName



## `mockFn.mock.calls`

返回表示mockFn函数的被调用信息的二维数组

```js
[
  ['arg1', 'arg2'],
  ['arg3', 'arg4'],
];
```

上面的数组表示总共mockFn函数被调用了两次，第一次被调用时的参数列表为`['arg1', 'arg2']`，第二次为`['arg3', 'arg4']`



## `mockFn.mock.results`

返回mockfn函数调用后的结果组成的数组

```js
[
  {
    type: 'return',
    value: 'result1',
  },
  {
    type: 'throw',
    value: {
      /* Error instance */
    },
  },
]
```

上面的数组表示mockFn函数总共被调用了两次，第一次的结果是返回字符串`'result1'`，第二次报错`{/* Error instance */}`



## `mockFn.mock.instances`

返回mockFn函数被实例化后的对象组成的数组

```js
const mockFn = jest.fn();

const a = new mockFn();
const b = new mockFn();

mockFn.mock.instances[0] === a; // true
mockFn.mock.instances[1] === b; // true
```



## `mockFn.mockClear()`

重置`mockFn.mock.calls`和`mockFn.mock.result`的信息

通常用于两个不同的`assertions`之间，清除掉上一个`assertions`



## `mockFn.mockReset()`

彻底重置mockFn，相当于重新`mockFn = jest.fn()`



## `mockFn.mockRestore()`

与`mockFn.mockReset()`不同的是这个Api会保留实现。

这个api只会对使用`jest.spyOn`创建的mockFn生效



## `mockFn.mockImplementation(fn)`

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



## `mockFn.mockImplementationOnce(fn)`

与`mockFn.mockImplementation(fn)`不一样的是这个api被使用一次，就会将实现回归到原来的状态。

```js
const myMockFn = jest
  .fn()
  .mockImplementationOnce(cb => cb(null, true))
  .mockImplementationOnce(cb => cb(null, false));

myMockFn((err, val) => console.log(val)); // true

myMockFn((err, val) => console.log(val)); // false
```



## `mockFn.mockName(value)`

给mockFn设置名字

```js
const mockFn = jest.fn().mockName('mockedFunction');
// mockFn();
expect(mockFn).toHaveBeenCalled();
expect(mockedFunction).toHaveBeenCalled()
// 上面的代码报错如下
Expected mock function "mockedFunction" to have been called, but it was not called.

```



### `mockFn.mockReturnThis()`

语法糖

```js
jest.fn(function () {
  return this;
});
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



### `mockFn.mockReturnValueOnce(value)`

只模拟一次返回值

```js
const myMockFn = jest
  .fn()
  .mockReturnValue('default')
  .mockReturnValueOnce('first call')
  .mockReturnValueOnce('second call');

// 'first call', 'second call', 'default', 'default'
console.log(myMockFn(), myMockFn(), myMockFn(), myMockFn());

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

### `mockFn.mockResolvedValueOnce(value)`

这个api是下面这种写法的语法糖

```js
jest.fn().mockImplementationOnce(() => Promise.resolve(value));
```

与`mockFn.mockResolvedValue(value)`不同的是只会被模拟一次。

```js
test('async test', async () => {
  const asyncMock = jest
    .fn()
    .mockResolvedValue('default')
    .mockResolvedValueOnce('first call')
    .mockResolvedValueOnce('second call');

  await asyncMock(); // first call
  await asyncMock(); // second call
  await asyncMock(); // default
  await asyncMock(); // default
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

### `mockFn.mockRejectedValueOnce(value)`

语法糖
```js
jest.fn().mockImplementationOnce(() => Promise.reject(value));
```

与`mockFn.mockRejectedValue(value)`一样，但只模拟一次
```js
test('async test', async () => {
  const asyncMock = jest
    .fn()
    .mockResolvedValueOnce('first call')
    .mockRejectedValueOnce(new Error('Async error'));

  await asyncMock(); // first call
  await asyncMock(); // throws "Async error"
});

```