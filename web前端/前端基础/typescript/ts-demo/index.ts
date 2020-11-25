function log(message) {
    return function() {
        console.log(message);
    }
}
console.log('before class');
@log('class Bar')
class Bar {
    @log('class method bar');
    bar() {}
    @log('class getter alice');
    get alice() {}
    @log('class property bob');
    bob = 1;
}
console.log('after class');
let bar = {
    @log('object method bar');
    bar() {}
};