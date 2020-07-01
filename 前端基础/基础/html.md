## 表格

```html
<table width="500" border="1" align="center">
    <caption>个人信息表</caption><!-- caption是标题 -->
    <thead>
        <tr>
            <th>姓名</th><!-- th是表头 -->
            <th>性别</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>hujin</td>
            <td>男</td>
        </tr>
    </tbody>
</table>
```
表格的属性
`width="100"` 表格宽度
`hight="80"`  表格高度
`border="1"` 边框粗细
`align="center"` 表格水平居中对齐 作用于tr的话会使tr中的内容居中对齐
`cellspacing="2"` 单元格与表格边框之间的距离
`cellpadding="2"` 单元格与单元格内容之间的距离
`rowspan="2"` 跨行合并单元格 作用于td
`colspan="2"` 跨列合并单元格 作用于td
一般我们使用表格的时候设置 border cellspacing cellpadding都为0

### input

```html
文本输入框<input id ="username" type="text" />
密码输入框<input id ="passwd" type="password" />
单选框 男<input type="radio" name="sex" />
单选框 女<input type="radio" name="sex" />
复选框 js<input type="checkbox" name="program" />
复选框 ts<input type="checkbox" name="program" />
普通按钮 <input type="button" value="注册">
普通提交按钮 <input type="submit" value="提交">
图片提交按钮 <input type="image" value="提交" src="btn.png" />
重置按钮 <input type="reset" value="重置" />
文件域<input type="file" value="上传文件" />
```

### label标签

```html
<label for="username">用户名<input id ="username" type="text" /></label>

```

### textarea控件

```html
<textarea cols="20" rows="10">默认文本内容</textarea>
```

`cols="20"`每行中的字符数
`rows="10"`显示的行数

### select下拉菜单

```html
<select >
    <option value="1" seleted="selected">北京</option>
    <option value="2">天津
     </option>
</select>

```

### form表单

```html
<form action="url地址" method="提交方式" name="表单名称">
    帐号<input id ="username" type="text" />
    密码<input id ="passwd" type="password" />
    <input type="submit" value="提交">
</form>

```

