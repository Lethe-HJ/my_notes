
### chunk 分块
```
_.chunk(array, [size=1])
// 将数组（array）拆分成多个 size 长度的区块，并将这些区块组成一个新数组。 如果array 无法被分割成全部等长的
区块，那么最后剩余的元素将组成一个区块。

参数
array (Array): 需要处理的数组
[size=1] (number): 每个数组区块的长度
返回
(Array): 返回一个包含拆分区块的新数组（注：相当于一个二维数组）。
```

例子

```js
_.chunk(['a', 'b', 'c', 'd'], 2);
// => [['a', 'b'], ['c', 'd']]
 
_.chunk(['a', 'b', 'c', 'd'], 3);
// => [['a', 'b', 'c'], ['d']]
```

### 压缩 compact
```
_.compact(array)
创建一个新数组，包含原数组中所有的非假值元素。例如false, null,0, "", undefined, 和 NaN 都是被认为是“假值”。

参数
array (Array): 待处理的数组
返回值
(Array): 返回过滤掉假值的新数组。
```

例子

```js
_.compact([0, 1, false, 2, '', 3]);
// => [1, 2, 3]
```

### concat 连接

```
_.concat(array, [values])
创建一个新数组，将array与任何数组 或 值连接在一起。

参数
array (Array): 被连接的数组。
[values] (...*): 连接的值。
返回值
(Array): 返回连接后的新数组。
```

例子

```js
var array = [1];
var other = _.concat(array, 2, [3], [[4]]);
 
console.log(other);
// => [1, 2, 3, [4]]
 
console.log(array);
// => [1]
```

### difference 差异

```
_.difference(array, [values])
创建一个具有唯一array值的数组，每个值不包含在其他给定的数组中。（注：即创建一个新数组，这个数组中的值，
为第一个数字（array 参数）排除了给定数组中的值。）该方法使用SameValueZero做相等比较。结果值的顺序是
由第一个数组中的顺序确定。

注意: 不像_.pullAll，这个方法会返回一个新数组。

参数
array (Array): 要检查的数组。
[values] (...Array): 排除的值。
返回值
(Array): 返回一个过滤值后的新数组。
```

例子

```js
_.difference([3, 2, 1], [4, 2]);
// => [3, 1]
```

### differenceBy 差异(迭代器)

```
_.differenceBy(array, [values], [iteratee=_.identity])#
这个方法类似_.difference ，除了它接受一个 iteratee （注：迭代器）， 调用array 和 values 中的每个元
素以产生比较的标准。 结果值是从第一数组中选择。iteratee 会调用一个参数：(value)。（注：首先使用迭代器分
别迭代array 和 values中的每个元素，返回的值作为比较值）。

参数
array (Array): 要检查的数组。
[values] (...Array): 排除的值。
[iteratee=_.identity] (Array|Function|Object|string): iteratee 调用每个元素。
返回值
(Array): 返回一个过滤值后的新数组。
```

例子
```js
_.differenceBy([3.1, 2.2, 1.3], [4.4, 2.5], Math.floor);
// => [3.1, 1.3]
 
// The `_.property` iteratee shorthand.
_.differenceBy([{ 'x': 2 }, { 'x': 1 }], [{ 'x': 1 }], 'x');
// => [{ 'x': 2 }]
```

### differenceWith 差异(比较器)

```
_.differenceWith(array, [values], [comparator])#
这个方法类似_.difference ，除了它接受一个 comparator （注：比较器），它调用比较array，values中的元
素。 结果值是从第一数组中选择。comparator 调用参数有两个：(arrVal, othVal)。

参数
array (Array): 要检查的数组。
[values] (...Array): 排除的值。
[comparator] (Function): comparator 调用每个元素。
返回值
(Array): 返回一个过滤值后的新数组。
```

例子

```js
var objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }];
 
_.differenceWith(objects, [{ 'x': 1, 'y': 2 }], _.isEqual);
// => [{ 'x': 2, 'y': 1 }]
```

### drop 去除左边切片

```
_.drop(array, [n=1])#
创建一个切片数组，去除array前面的n个元素。（n默认值为1。）

参数
array (Array): 要查询的数组。
[n=1] (number): 要去除的元素个数。
返回值
(Array): 返回array剩余切片。
```

例子

```js
_.drop([1, 2, 3]);
// => [2, 3]
 
_.drop([1, 2, 3], 2);
// => [3]
 
_.drop([1, 2, 3], 5);
// => []
 
_.drop([1, 2, 3], 0);
// => [1, 2, 3]
```


###　dropRight 去除右边切片

```
_.dropRight(array, [n=1])#
创建一个切片数组，去除array尾部的n个元素。（n默认值为1。）

参数
array (Array): 要查询的数组。
[n=1] (number): 要去除的元素个数。
返回值
(Array): 返回array剩余切片。
```

例子

```js
_.dropRight([1, 2, 3]);
// => [1, 2]
 
_.dropRight([1, 2, 3], 2);
// => [1]
 
_.dropRight([1, 2, 3], 5);
// => []
 
_.dropRight([1, 2, 3], 0);
// => [1, 2, 3]
```

### dropRightWhile　去除右边当...

```
_.dropRightWhile(array, [predicate=_.identity])#
创建一个切片数组，去除array中从 predicate 返回假值开始到尾部的部分(左开右闭)。predicate 会传入3个参数： (value, index, array)。

参数
array (Array): 要查询的数组。
[predicate=_.identity] (Function): 这个函数会在每一次迭代调用。
返回值
(Array): 返回array剩余切片。
```

例子

```js
var users = [
  { 'user': 'barney',  'active': true },
  { 'user': 'fred',    'active': false },
  { 'user': 'pebbles', 'active': false }
];
 
_.dropRightWhile(users, function(o) { return !o.active; });
// => objects for ['barney']
 
// The `_.matches` iteratee shorthand.
_.dropRightWhile(users, { 'user': 'pebbles', 'active': false });
// => objects for ['barney', 'fred']
 
// The `_.matchesProperty` iteratee shorthand.
_.dropRightWhile(users, ['active', false]);
// => objects for ['barney']
 
// The `_.property` iteratee shorthand.
_.dropRightWhile(users, 'active');
// => objects for ['barney', 'fred', 'pebbles']
```

###　dropWhile 去除左边当...

```
_.dropWhile(array, [predicate=_.identity])#
创建一个切片数组，去除array中从起点开始到 predicate 返回假值结束部分(左闭右开)。predicate 会传入3个参数： (value, index, array)。

参数
array (Array): 要查询的数组。
[predicate=_.identity] (Function): 这个函数会在每一次迭代调用。
返回值
(Array): 返回array剩余切片。
```

例子

```js
var users = [
  { 'user': 'barney',  'active': false },
  { 'user': 'fred',    'active': false },
  { 'user': 'pebbles', 'active': true }
];
 
_.dropWhile(users, function(o) { return !o.active; });
// => objects for ['pebbles']
 
// The `_.matches` iteratee shorthand.
_.dropWhile(users, { 'user': 'barney', 'active': false });
// => objects for ['fred', 'pebbles']
 
// The `_.matchesProperty` iteratee shorthand.
_.dropWhile(users, ['active', false]);
// => objects for ['pebbles']
 
// The `_.property` iteratee shorthand.
_.dropWhile(users, 'active');
// => objects for ['barney', 'fred', 'pebbles']
```


