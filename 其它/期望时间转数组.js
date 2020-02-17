let time = ['1,17,3', '1,47,1', '2,20,2', '2,23,1', '2,16,1', '2,18,2', '2,23,1', '3,16,2', '3,32,2', '7,47,1']

//构造二维数组
let day = new Array(32).fill(false);//先构造一维
let week = new Array(7).fill(day);//构造二维数组

//将时间点转换为true
//遍历time数组
time.forEach((item, index) => {
    let itemArr = item.split(',');//将字符串分为数组,方便去数据
    let row = itemArr[0] - 1; //二维数组行
    let col = itemArr[1] % 16;//二维数组列
    if (Math.floor(itemArr[1] / 16) == 2) {
        col = 16 + itemArr[1] % 16;
    } else if (Math.floor(itemArr[1] / 16) == 3) {
        col = 32 + itemArr[1] % 16;
    }
    tArray[row][col] = true; //改变false-true
    //判断是否 连续时间
    if (itemArr[2] > 1) {
        let item = itemArr; //找出所有连续时间
        for (let k = 0; k < item.length; k++) {
            let len = item[2];//确定长度
            for (let j = 0; j < len; j++) {
                tArray[row][col + j] = true; //从当前true-依次递增
            }
        }
    }

})
// console.log(tArray)


console.log(week);