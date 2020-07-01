## vue cli 搭建vue2.0项目

安装cnpm

`npm install -g cnpm --registry=https://registry.npm.taobao.org`

安装vue

`cnpm install vue`

安装vue-cli

`cnpm install --global vue-cli`

创建一个基于 webpack 模板的新项目

`vue init webpack my-project`

安装项目所需要的依赖

`cd my-project`

`cnpm install`

运行项目

`cnpm run dev`



## 全局引入axios

main.js

```js
// 引入axios
import axios from 'axios';
// 挂载到vue原型链上
Vue.prototype.axios = axios;
```



在任意组件，直接使用 **this.axios**



## 引入element-ui



`npm i element-ui -S`

在 main.js中

```js
//...
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

//...
Vue.use(ElementUI);
//...
```

