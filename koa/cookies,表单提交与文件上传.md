
## cookies

```js
ctx.cookies.get(name, [options])
```

获得 cookie 中名为 name 的值，options 为可选参数：

‘signed’: 如果为 true，表示请求时 cookie 需要进行签名。

```js
ctx.cookies.set(name, value, [options])
```

设置 cookie 中名为 name 的值，options 为可选参数：

signed: 是否要做签名
expires: cookie 有效期时间
path: cookie 的路径，默认为 /’
domain: cookie 的域
secure: false 表示 cookie 通过 HTTP 协议发送，true 表示 cookie 通过 HTTPS 发送。
httpOnly: true 表示 cookie 只能通过 HTTP 协议发送
注意：Koa 使用了 Express 的 cookies 模块，options 参数只是简单地直接进行传递。


## 表单处理

Web 应用离不开处理表单。本质上，表单就是 POST 方法发送到服务器的键值对。koa-body 模块可以用来从 POST 请求的数据体里面提取键值对。

看下面的 body.js 文件中的代码：

```js
const koaBody = require('koa-body'); 
const main = async function(ctx) {   
    const body = ctx.request.body;   
    if (!body.name) ctx.throw(400, '.name required');   
    ctx.body = { name: body.name }; 
}; 
app.use(koaBody());
```


## 文件上传

koa-body 模块还可以用来处理文件上传。

看下面的 file.js 文件中的代码：

```js
const os = require('os');
const path = require('path');
const koaBody = require('koa-body');
const main = async function(ctx) {
    const tmpdir = os.tmpdir();
    const filePaths = ['public/uploads'];
    const files = ctx.request.body.files || {};
    for (let key in files) {
        const file = files[key];
        const filePath = path.join(tmpdir, file.name);
        const reader = fs.createReadStream(file.path);
        const writer = fs.createWriteStream(filePath);
        reader.pipe(writer);
        filePaths.push(filePath);
    }
    ctx.body = filePaths;
};
app.use(koaBody({ multipart: true }));
```