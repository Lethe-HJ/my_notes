BFS 可以看成是层序遍历。从某个结点出发，BFS 首先遍历到距离为 1 的结点，然后是距离为 2、3、4…… 的结点。
因此，BFS 可以用来求最短路径问题。BFS 先搜索到的结点，一定是距离最近的结点。

伪代码
```python
while queue 非空:
	node = queue.pop()
    for node的所有相邻结点 m:
        if m 未访问过:
            queue.push(m)
```