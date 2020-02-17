
let input = [
    [true, true, false, false, true, true, false, true],
    [true, true, false, false, true, true, false, true],
    [true, true, false, false, true, true, false, true],
    [true, true, false, false, true, true, false, true],
]


let time_li = [];

input.forEach((item, index_day) => {
    let expect_li = [];
    let prev = false;//表示前一个的值
    let cur_index = -1;//表示expect_li数组中最后一个元素的索引
    item.forEach((item, index) => {
        if (!prev && item) {//false-> true 
            expect_li.push([index_day + 1, index + 16, 1]);//记录日期,开始时间,持续时间为1
            cur_index++;//索引+1
        }
        if (prev && item) {//true -> true
            expect_li[cur_index][2]++;//持续时间+1
        }
        prev = item;//记录当前的值
        // console.log("prev=", prev, "expect_li = ", expect_li);
    })

    //将每个期望时间数组转换成字符串形式
    if (expect_li.length !== 0) {
        expect_li.forEach(item => {
            time_li.push(item.toString());
        })
    }
})

console.log(time_li);



// ```js
// 思路
// [true, true, false, false, true, true, false, true]

// 1. prev == false && item == true  上一个为false 这一个为true
// 记录a为[1, 16, 1], 将a push入expect_li, 用cur_index跟踪这个记录a的索引, prev = item

// 2. prev == true && item == true  上一个为true 这一个为true
// 记录a中的持续时间 + 1, prev = item

// 3. prev == true && item == false  上一个为true 这一个为false
// prev = item

// 4. prev == false && item == false  上一个为false 这一个为false
// prev = item 也可以什么都不做

// ```