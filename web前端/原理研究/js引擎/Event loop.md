### 事件循环

js引擎是单线程的，为了防止主线程阻塞，`Event loop`的方案应运而生。

`Event loop`包含`Browsing Context`和`Worker`两类,二者的运行时相互独立的。

### 任务队列

根据规范，事件循环是通过任务队列的机制来进行协调的。一个 `Event loop` 中，可以有一个或者多个任务队列(task  queue)，一个任务队列便是一系列有序任务(task)的集合；每个任务都有一个任务源(task source)，源自同一个任务源的 task  必须放到同一个任务队列，从不同源来的则被添加到不同队列。`setTimeout`, `Promise`  等API便是任务源，而进入任务队列的是他们指定的具体执行任务。

在事件循环中，每进行一次循环操作称为 tick，每一次 tick 的任务处理模型是比较复杂的，但关键步骤如下：

- 在此次 tick 中选择最先进入队列的任务(oldest task)，如果有则执行(一次)
- 检查是否存在 Microtasks，如果存在则不停地执行，直至清空 Microtasks Queue
- 更新 render
- 主线程重复执行上述步骤

在上述tick的基础上需要了解几点：

- JS分为同步任务和异步任务
- 同步任务都在主线程上执行，形成一个执行栈
- 主线程之外，事件触发线程管理着一个任务队列，只要异步任务有了运行结果，就在任务队列之中放置一个事件。
- 一旦执行栈中的所有同步任务执行完毕（此时JS引擎空闲），系统就会读取任务队列，将可运行的异步任务添加到可执行栈中，开始执行。

![图片描述](Event loop.assets/bV31Xm)

![img](Event loop.assets/1053223-20180831162152579-2034514663.png)

### 宏任务

(macro)task，可以理解是每次执行栈执行的代码就是一个宏任务（包括每次从事件队列中获取一个事件回调并放到执行栈中执行）。

浏览器为了能够使得JS内部(macro)task与DOM任务能够有序的执行，会在一个(macro)task执行结束后，在下一个(macro)task 执行开始前，对页面进行重新渲染，流程如下：

```
(macro)task->渲染->(macro)task->...
```

##### 宏任务包含：

```
script(整体代码)
setTimeout
setInterval
I/O
UI交互事件
postMessage
MessageChannel
setImmediate(Node.js 环境)
```

### 微任务

`microtask`,可以理解是在当前 task 执行结束后立即执行的任务。也就是说，在当前task任务后，下一个task之前，在渲染之前。

所以它的响应速度相比setTimeout（setTimeout是task）会更快，因为无需等渲染。也就是说，在某一个macrotask执行完后，就会将在它执行期间产生的所有microtask都执行完毕（在渲染前）。

##### 微任务包含：

```
Promise.then
Object.observe
MutaionObserver
process.nextTick(Node.js 环境)
```

### 运行机制

在事件循环中，每进行一次循环操作称为 tick，每一次 tick 的任务处理模型是比较复杂的，但关键步骤如下：

- 执行一个宏任务（栈中没有就从事件队列中获取）
- 执行过程中如果遇到微任务，就将它添加到微任务的任务队列中
- 宏任务执行完毕后，立即执行当前微任务队列中的所有微任务（依次执行）
- 当前宏任务执行完毕，开始检查渲染，然后GUI线程接管渲染
- 渲染完毕后，JS线程继续接管，开始下一个宏任务（从事件队列中获取）

如图：

![图片描述](Event loop.assets/bVbpsFp)

### 例子

```js
setTimeout(() => {
    //执行后 回调一个宏事件
    console.log('内层宏事件3')
}, 0)
console.log('外层宏事件1');

new Promise((resolve) => {
    console.log('外层宏事件2');
    resolve()
}).then(() => {
    console.log('微事件1');
}).then(()=>{
    console.log('微事件2')
})
```

我们看看打印结果

```
外层宏事件1
外层宏事件2
微事件1
微事件2
内层宏事件3
```

• 首先浏览器执行js进入第一个宏任务进入主线程, 遇到 **setTimeout** 分发到宏任务Event Queue中

• 遇到 **console.log()** 直接执行 输出 外层宏事件1

• 遇到 Promise， new Promise 直接执行 输出 外层宏事件2

• 执行then 被分发到微任务Event Queue中``

•第一轮宏任务执行结束，开始执行微任务 打印 '微事件1' '微事件2'

•第一轮微任务执行完毕，执行第二轮宏事件，打印setTimeout里面内容'内层宏事件3'



```js
//主线程直接执行
console.log('1');
//丢到宏事件队列中
setTimeout(function() {
    console.log('2');
    process.nextTick(function() {
        console.log('3');
    })
    new Promise(function(resolve) {
        console.log('4');
        resolve();
    }).then(function() {
        console.log('5')
    })
})
//微事件1
process.nextTick(function() {
    console.log('6');
})
//主线程直接执行
new Promise(function(resolve) {
    console.log('7');
    resolve();
}).then(function() {
    //微事件2
    console.log('8')
})
//丢到宏事件队列中
setTimeout(function() {
    console.log('9');
    process.nextTick(function() {
        console.log('10');
    })
    new Promise(function(resolve) {
        console.log('11');
        resolve();
    }).then(function() {
        console.log('12')
    })
})
```

• 首先浏览器执行js进入第一个宏任务进入主线程, 直接打印console.log('1')

• 遇到 **setTimeout** 分发到宏任务Event Queue中

• 遇到 process.nextTick 丢到微任务Event Queue中

• 遇到 Promise， new Promise 直接执行 输出 console.log('7');

• 执行then 被分发到微任务Event Queue中``

•第一轮宏任务执行结束，开始执行微任务 打印 6,8

•第一轮微任务执行完毕，执行第二轮宏事件，执行setTimeout

•先执行主线程宏任务，在执行微任务，打印'2,4,3,5'

•在执行第二个setTimeout,同理打印 ‘9,11,10,12’

•整段代码，共进行了三次事件循环，完整的输出为

1，7，6，8，2，4，3，5，9，11，10，12。

```js
for(var i=0;i<10;i++){
  setTimeout(function(){
      console.log(i)
  },2)
}

for(var i=0;i<10;i++){
  setTimeout(function(){
      console.log(i)
  }(),2)
}

for(var i=0;i<10;i++){
	function haha(i){
  	setTimeout(function(){
    	console.log(i)
    },0)
	}
  haha(i);
}

```

