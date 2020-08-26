# 配合typescript使用

`npm install -g @vue/cli`

`vue create hello-world`

选择Manually select features，选中typescript

`npm install --save-dev jest @vue/test-utils`

接下来在 package.json 里定义一个 test:unit 脚本。

```json
// package.json
{
  // ..
  "scripts": {
    // ..
    "test:unit": "jest"
  }
  // ..
}
```

`npm install --save-dev vue-jest`

在 package.json 里创建一个 jest 块：

```json
{
  // ...
  "jest": {
      "moduleFileExtensions": [
        "js",
        "ts",
        "json",
        // 告诉 Jest 处理 `*.vue` 文件
        "vue"
      ],
      "transform": {
        // 用 `vue-jest` 处理 `*.vue` 文件
        "^.+\\.tsx?$": "ts-jest"
      },
      "testURL": "http://localhost/"
    }
}
```

`npm install --save-dev ts-jest`

接下来，我们需要在 package.json 中的 jest.transform 中加入一个入口告诉 Jest 使用 ts-jest 处理 TypeScript 测试文件：

```json
{
  // ...
  "jest": {
    // ...
    "transform": {
      // ...
      // 用 `ts-jest` 处理 `*.ts` 文件
      "^.+\\.tsx?$": "ts-jest"
    }
    // ...
  }
}
```

默认情况下，Jest 将会在整个工程里递归地找到所有的 .spec.js 或 .test.js 扩展名文件。

我们需要改变 package.json 文件里的 testRegex 配置项以运行 .ts 扩展名的测试文件。

在 package.json 中添加以下 jest 字段：

```json
{
  // ...
  "jest": {
    // ...
    "testRegex": "(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$"
  }
}
```