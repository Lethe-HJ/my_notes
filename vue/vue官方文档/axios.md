# axios

axios是一个基于Promise用域浏览器和node.js的http客户端

它具有以下特征

+ 支持浏览器和node.js
+ 支持promise
+ 能拦截请求和响应
+ 自动转换JSON数据

`node install axios`

## 引入

`import axios from 'axios'`

## axios API

可以通过向 axios 传递相关配置来创建请求

### axios(config)

```js
// 发送 POST 请求
axios({
  method: 'post',
  url: '/user/12345',
  data: {
    firstName: 'Fred',
    lastName: 'Flintstone'
  }
}) // 返回promise

// 发送get请求
axios({
  method:'get',
  url:'http://bit.ly/2mTM3nY',
  responseType:'stream'
})
```

### axios(url[, config])

```js
// 发送 GET 请求（默认的方法）
axios('/user/12345');
```

## 请求方法的别名

为方便起见，为所有支持的请求方法提供了别名

`axios.request(config)`

`axios.get(url[, config])`

`axios.delete(url[, config])`

`axios.head(url[, config])`

`axios.options(url[, config])`

`axios.post(url[, data[, config]])`

`axios.put(url[, data[, config]])`

`axios.patch(url[, data[, config]])`

## 并发

处理并发请求的助手函数

`axios.all(iterable)`

`axios.spread(callback)`

创建实例

可以使用自定义配置新建一个 axios 实例

`axios.create([config])`

```js
const instance = axios.create({
  baseURL: 'https://some-domain.com/api/',
  timeout: 1000,
  headers: {'X-Custom-Header': 'foobar'}
});
```

实例方法

以下是可用的实例方法。指定的配置将与实例的配置合并。

`axiosInstance.request(config)`

`axiosInstance.get(url[, config])`

`axiosInstance.delete(url[, config])`

`axiosInstance.head(url[, config])`

`axiosInstance.options(url[, config])`

`axiosInstance.post(url[, data[, config]])`

`axiosInstance.put(url[, data[, config]])`

`axiosInstance.patch(url[, data[, config]])`

```js
function getUserAccount() {
  return axios.get('/user/12345');
}

function getUserPermissions() {
  return axios.get('/user/12345/permissions');
}

axios.all([getUserAccount(), getUserPermissions()])
  .then(axios.spread(function (acct, perms) {
    // 两个请求现在都执行完成
  }));

```

