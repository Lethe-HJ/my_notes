# test

## Test.only

有多个测试用例或测试套件，只想执行其中某一个测试用例时可以用`test.only`

```js
const my = {
  name : "fynn",
  age : 27
};
let hw = ()=>"Hello World!";
test("my name",()=>{
  expect(my.name).toBe("fynn");
})
test.only("hw test",()=>{
  expect(hw()).toBe("Hello World!");
})
```

## Test.skip(name, fn)

当有多个测试用例，想跳过某个测试用例可以使用`test.skip`

## It(name,fn)

用法和test一样，不能嵌套在test中！可以嵌套在describe中
`xit` 类似与test.skip,跳过这个测试实例

## Manual Mocks

在开发时我们需要调用后台数据，可以通过创建manual mock模拟后台数据，这样使得测试更容易更快。
Manual Mocks模块应写在文件夹`__mocks__`下，`__mocks__` 文件夹应该和被mock的模块放在一起

