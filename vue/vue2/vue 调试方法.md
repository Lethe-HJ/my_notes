在可以从 VS Code 调试你的 Vue 组件之前，你需要更新 webpack 配置以构建 source  map。做了这件事之后，我们的调试器就有机会将一个被压缩的文件中的代码对应回其源文件相应的位置。这会确保你可以在一个应用中调试，即便你的资源已经被 webpack 优化过了也没关系。

打开 `config/index.js` 并找到 `devtool` property。将其更新为：

如果你使用的是 Vue CLI 2，请设置并更新 `config/index.js` 内的 `devtool` property：

```
devtool: 'source-map',
```

如果你使用的是 Vue CLI 3，请设置并更新 `vue.config.js` 内的 `devtool` property：

```js
module.exports = {
  configureWebpack: {
    devtool: 'source-map'
  }
}
```

launch.json

```js
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "launch",
      "name": "vuejs: chrome",
      "url": "http://localhost:8080",
      "webRoot": "${workspaceFolder}/src",
      "breakOnLoad": true,
      "sourceMapPathOverrides": {
        "webpack:///src/*": "${webRoot}/*"
      }
    },
    {
      "type": "firefox",
      "request": "launch",
      "name": "vuejs: firefox",
      "url": "http://localhost:8080",
      "webRoot": "${workspaceFolder}/src",
      "pathMappings": [{ "url": "webpack:///src/", "path": "${webRoot}/" }]
    }
  ]
}
```

运行项目

`npm run serve`

打开vscode的debug