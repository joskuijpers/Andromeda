console.log("Hello World!");

var test = require("test_module");
console.log(test.add(4,4));

var fs = require("fs");
console.log("fs",fs,Object.keys(fs));
var file = new fs.File("~/Desktop/test.txt");
console.log(file.path);
console.log(file.md5());