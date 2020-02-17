
let input = [
    [false, false, false, false, false, false, false, false],
    [true, false, false, false, true, true, false, true],
    [true, true, false, false, true, true, false, true],
    [false, false, false, false, false, false, false, false],
]

let time_li = [];
let arr = [];
input.forEach((item, index_day) => {
    // item.forEach((item,index,arr)=>{})
    let expect_li = [];
    let prev = false;//表示前一个的值
    let cur_index = -1;//表示expect_li数组中最后一个元素的索引
    item.forEach((item, index) => {
        if (!prev && item) {//false/none-> true 
            expect_li.push([index_day + 1, index + 16, 1]);//记录日期,开始时间,持续时间为1
            cur_index++;//索引+1
            prev = true;//记录当前的值
        }
        else if (prev && item) {//true -> true
            // expect_li[cur_index][2]++;//持续时间+1
            // expect_li[cur_index].charAt(2)++;//持续时间+1
            var str = expect_li[cur_index];
            var num = Number(str.charAt(str.length - 1))
            num++;
            // console.log(typeof(Number(str.charAt(str.length-1))))
        }
        else if (prev && !item) {//true -> false/none
            prev = false;//记录当前的值
        }
        // console.log("prev=", prev, "expect_li = ", expect_li);
    })
    if (expect_li.length !== 0) {
        time_li.push(expect_li);
    }
})
// [true, true, false, false, true, true, false, true],

console.log(time_li);