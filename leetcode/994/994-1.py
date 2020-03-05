def orangesRotting(grid):
    M = len(grid)
    N = len(grid[0])
    queue = []

    count = 0  # count 表示新鲜橘子的数量
    for r in range(M):
        for c in range(N):
            if grid[r][c] == 1:
                count += 1
            elif grid[r][c] == 2:
                queue.append((r, c))

    round = 0  # round 表示腐烂的轮数，或者分钟数
    while count > 0 and len(queue) > 0:  # 还有好橘子且队列还有坏橘子
        round += 1  # 层数+1
        n = len(queue)  # 记录这一层的坏橘子数
        for i in range(n):  # 遍历完这一层的坏橘子
            r, c = queue.pop(0)  # 取出队列开头的坏橘子坐标
            if r-1 >= 0 and grid[r-1][c] == 1:  # 右邻有好橘子
                grid[r-1][c] = 2  # 好橘子变坏
                count -= 1  # 好橘子数-1
                queue.append((r-1, c))  # 新变坏的这只橘子进入坏橘子队列
            if r+1 < M and grid[r+1][c] == 1:  # 左邻有好橘子
                grid[r+1][c] = 2
                count -= 1
                queue.append((r+1, c))
            if c-1 >= 0 and grid[r][c-1] == 1:  # 下邻有好橘子
                grid[r][c-1] = 2
                count -= 1
                queue.append((r, c-1))
            if c+1 < N and grid[r][c+1] == 1:  # 上邻有好橘子
                grid[r][c+1] = 2
                count -= 1
                queue.append((r, c+1))

    if count > 0:  # 还有好橘子
        return -1
    else:  # 没有好橘子了
        return round


test = [
    ([[2, 1, 1], [1, 1, 0], [0, 1, 1]], 4),
    ([[2, 1, 1], [0, 1, 1], [1, 0, 1]], -1)
]

for (in_li, res_int) in test:
    assert orangesRotting(in_li) == res_int
