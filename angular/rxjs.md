# Rxjs

## 介绍

RxJS是ReactiveX编程理念的JavaScript版本。ReactiveX来自微软，它是一种针对异步数据流的编程。简单来说，它将一切数据，包括HTTP请求，DOM事件或者普通数据等包装成流的形式，然后用强大丰富的操作符对流进行处理，使你能以同步编程的方式处理异步数据，并组合不同的操作符来轻松优雅的实现你所需要的功能

RxJS是一种针对异步数据流编程工具，或者叫响应式扩展编程；可不管如何解释RxJS其目标就是异步编程，Angular引入RxJS为了就是让异步可控、更简单。RxJS里面提供了很多模块。这里我们主要给大家讲RxJS里面最常用的Observable和fromEvent。

## RxJS处理异步

```js
import { Observable } from'rxjs';
let stream = new Observable(observer=>{
  setTimeout(()=>{
    observer.next('observabletimeout');
    },2000);
  });
stream.subscribe(value=>console.log(value));
```

## unsubscribe取消订阅

Rxjs可以通过unsubscribe()可以撤回subscribe的动作

```js
let stream = new Observable(observer=>{
  let timeout = setTimeout(()=>{
    clearTimeout(timeout);
    observer.next('observabletimeout');
  },2000);
});

let disposable = stream.subscribe(value=>console.log(value));
setTimeout(()=>{
  //取消执行
  disposable.unsubscribe();
},1000);
```

## Rxjs订阅后多次执行

```ts
let stream = new Observable<number>(observer=>{
  let count = 0;
  setInterval(()=>{
    observer.next(count++);
  },1000);
});

stream.subscribe(value=>console.log("Observable>"+value));
```

## pipe filter map

```js
import { Observable } from 'rxjs';
import { map,filter } from 'rxjs/operators';
let stream = new Observable<any>(observer=>{
  let count = 0;
  setInterval(()=>{
    observer.next(count++);
  },1000);
});

stream.pipe(
  filter(val => val % 2 == 0)
)
.subscribe(value => console.log("filter>"+value));

stream.pipe(
  filter(val => val % 2 == 0),
  map(value => {
    return value*value
  })
)
.subscribe(value => console.log("map>"+value));
```

## Rxjs延迟执行

```js
import { Observable,fromEvent } from 'rxjs';
import { map,filter,throttleTime } from 'rxjs/operators';
var button = document.querySelector('button');
fromEvent(button,'click').pipe(
  throttleTime(1000)
)
.subscribe(()=>console.log(`Clicked`));
```
