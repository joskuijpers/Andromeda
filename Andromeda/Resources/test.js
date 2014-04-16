console.log("Hello World!");

console.log("module",module,"exports",exports,"filename",__filename,"dirname",__dirname,"require",require);

var test = require("test_module");
console.log(test.add(4,4));

var Game = {};
Game.init = function() {
	console.log();
}

Game.loop = function() {
}
