修改响应式数据

```js
Vue.set(vm.items, indexOfItem, newValue)

vm.$set(vm.items, indexOfItem, newValue)

// 参数一表示要处理的数组名称
// 参数二表示要处理的数组的索引
// 参数三表示要处理的数组的值
```

注意:通过直接赋值的方式,无法响应式地修改数据

使用了上述set方法后,直接赋值会有响应式更新

## vue调试工具

谷歌浏览器应用商店 安装Vue.js devtools
