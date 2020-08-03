# dom

## HTMLCollection

HTMLCollection 接口表示一个包含了元素（元素顺序为文档流中的顺序）的通用集合（generic collection），还提供了用来从该集合中选择元素的方法和属性。

HTML DOM 中的 HTMLCollection 是即时更新的（live）；当其所包含的文档结构发生改变时，它会自动更新。

### 属性

HTMLCollection.length 只读
返回集合当中子元素的数目。

### 方法

`HTMLCollection.item()`
根据给定的索引（从0开始），返回具体的节点。如果索引超出了范围，则返回 null。
`HTMLCollection.namedItem()`
根据 Id 返回指定节点，或者作为备用，根据字符串所表示的 name 属性来匹配。根据 name 匹配只能作为最后的依赖，并且只有当被引用的元素支持 name 属性时才能被匹配。如果不存在符合给定 name 的节点，则返回 null。

例如，假定在文档中有一个 `<form>` 元素，且它的 id 是 "myForm"：

```js
var elem1, elem2;

// document.forms 是一个 HTMLCollection

elem1 = document.forms[0];
elem2 = document.forms.item(0);

alert(elem1 === elem2); // 显示 "true"

elem1 = document.forms["myForm"];
elem2 = document.forms.namedItem("myForm");
```

## 获取元素

### getElementById

```js
var element = document.getElementById(id);
```

+ id是大小写敏感的字符串，代表了所要查找的元素的唯一ID.
+ element是一个匹配到 ID 的 DOM Element 对象。如果当前文档中拥有特定ID的元素不存在则返回null.

### getElementsByClassName

```js
var elements = document.getElementsByClassName(names) // or:
var elements = rootElement.getElementsByClassName(names)
```

+ elements 是一个实时集合`HTMLCollection`，包含了找到的所有元素。
+ names 是一个字符串，表示要匹配的类名列表；类名通过空格分隔
+ getElementsByClassName 可以在任何元素上调用，不仅仅是 document。 调用这个方法的元素将作为本次查找的根元素.

```js
var testElements = document.getElementsByClassName('test')
var testDivs = Array.prototype.filter.call(testElements, function(testElement){
    return testElement.nodeName === 'DIV'
});
```

### getElementsByName

```js
elements = document.getElementsByName(name)
```

elements 是一个实时更新的 NodeList 集合
name 是元素的 name 属性的值

### getElementsByTagName

```js
var elements = element.getElementsByTagName(tagName) // or:
elements = document.getElementsByTagName(name)
```

+ elements 搜索到的元素的动态HTML集合HTMLCollection，它们的顺序是在子树中出现的顺序。 如果没有搜索到元素则这个集合为空
+ element 搜索从element开始。请注意只有element的后代元素会被搜索，不包括元素自己
+ tagName 要查找的限定名。 字符 "*" 代表所有元素。 考虑到兼容XHTML，应该使用小写

### getElementsByTagNameNS

```js
var elements = element.getElementsByTagNameNS(namespaceURI, localName)
var elements = document.getElementsByTagNameNS(namespaceURI, localName)
```

+ elements 是匹配元素的动态HTML元素集合HTMLCollection，其顺序为遍历树时匹配元素出现的先后。
+ element 是查找的起始结点，查找范围为该元素的后代，并且不包含该元素自身。
+ namespaceURI 是所要查询的元素的命名空间URL (参考 Node.namespaceURI). 举个例子，如果你想查找的是XHTML元素，你应该使用XHTML的命名空间URL
+ localName 是所要查询的元素的名称。其中特殊字符 "*" 代表所有元素 

```js
var table = document.getElementById("forecast-table");
var cells = table.getElementsByTagNameNS("http://www.w3.org/1999/xhtml", "td");
```

### querySelector

返回与指定的选择器组匹配的元素的后代的第一个元素。
匹配是使用深度优先先序遍历，从文档标记中的第一个元素开始，并按子节点的顺序依次遍历。

```js
element = baseElement.querySelector(selectors); \\ or:
element = document.querySelector(selectors);
```

+ element 和 baseElement 是 element 对象.
+ selectors 是一个CSS选择器字符串( selectors )

selectors
一组用来匹配Element baseElement后代元素的选择器selectors；必须是合法的css选择器，否则会引起语法错误。返回匹配指定选择器的第一个元素。

返回值
基础元素（baseElement）的子元素中满足指定选择器组的第一个元素。匹配过程会对整个结构进行，包括基础元素和他的后代元素的集合以外的元素，也就是说，选择器首先会应用到整个文档，而不是基础元素，来创建一个可能有匹配元素的初始列表。然后从结果元素中检查它们是否是基础元素的后代元素。第一个匹配的元素将会被querySelector()方法返回。

如果没有找到匹配项，返回值为null。

异常
SyntaxError
指定的选择器无效

在这个例子中，会返回HTML文档里第一个没有type属性或者有值为“text/css”的type属性的`<style>`元素:

```js
let el = document.body.querySelector("style[type='text/css'], style:not([type])");****
```

## 获取和设置属性

### getattribute

getAttribute() 返回元素上一个指定的属性值。如果指定的属性不存在，则返回  null 或 "" （空字符串）

```js
let attribute = element.getAttribute(attributeName);
```

+ attribute 是一个包含 attributeName 属性值的字符串。
+ attributeName 是你想要获取的属性值的属性名称。

### setAttribute

设置指定元素上的某个属性值。如果属性已经存在，则更新该值；否则，使用指定的名称和值添加一个新的属性。

```js
element.setAttribute(name, value);
```

尽管对于不存在的属性，getAttribute() 返回 null，你还是应该使用 removeAttribute() 代替 elt.setAttribute(attr, null) 来删除属性。

```js
var b = document.querySelector("button")
b.setAttribute("name", "helloButton")
```
