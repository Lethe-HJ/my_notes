axios是一个基于Promise用域浏览器和node.js的http客户端
它具有以下特征

+ 支持浏览器和node.js
+ 支持promise
+ 能拦截请求和响应
+ 自动转换JSON数据

`node install axios`

引入

`import axios from 'axios'`

```js
axios({
      method: "get",
      url: "https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1?id=123"
    })
      .then(response => {
        console.log(response);
      })
      .catch(error => {
        console.log(error);
      });
```

```js
axios.get("https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1", {
    params: {
        id: 123
    }
})//...

//相当于 https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1?id=123

```

### post

```js
//post传递json
axios.post("https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1", {
    name: "laohu",
    age: 12
})//...
//第二个参数是json数据

//post传递参数
const params = new URLSearchParams();
params.append('id', '123');
params.append('name', 'laohu');
axios.post("https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1", params)//...
//相当与https://www.easy-mock.com/mock/5ef094165fceee66245ba9fa/test/demo1?id=123&name=laohu  

```


## restful

get 查询
post 添加
put 修改
delete 删除


## easy-mock

www.easy-mock.com