```js
let prevScrollTop = 0; // 记录上一次滚动的值
const Fun = () => {
        const queue = this.scrollHistory;
        let value = 1; // 默认在中间
        if (prevScrollTop === elem.scrollTop) {
          // 上一个与这一个相等 说明不是在中间
          value = elem.scrollTop === 0 ? 0 : 2; // 顶部是0 底部是2
        }
        queue.push(value);
        prevScrollTop = elem.scrollTop;
        if (queue.length < 8) return; // 队列未满 直接返回
        // 队列满了
        if (queue.length > 8) queue.shift(); // 队列溢出 出队
        const queueStr = this.scrollHistory.join('');
        console.log(queueStr);
        if (queueStr === '10000000') {
          // 从中间往上滚到顶 继续滚动7下
          this.upwardLoad = true;
        }
        if (queueStr === '12222222') {
          // 从中间往下滚到底 继续滚动7下
          this.downwardLoad = true;
        }
      };
      if (elem.addEventListener) {
        elem.addEventListener('DOMMouseScroll', Fun, false);
      } // FireFox
      elem.onmousewheel = Fun; // IE/Opera/Chrome
```