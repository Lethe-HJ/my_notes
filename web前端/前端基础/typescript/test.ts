interface Person {
    name: string;
    age?: number;
    [propName: string]: string | number;
}

let tom: Person = {
    name: 'Tom',
    age: 25,
    gender: 'male',
    gender1: 'male'
};

let arr:Person[] = [
    {"name":"123",age:12}
]
console.log(arr)
