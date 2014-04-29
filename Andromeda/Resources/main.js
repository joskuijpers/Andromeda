console.log("Hello World!");


engine.on("tick",function() {
	console.log("tick!");
});
engine.trigger("tick");


var game = require("game");
console.log(game,"'",Object.keys(game),"'");

for(var x in Object.keys(game))
	console.log("key",x);

game.on("tick",function() {
	console.log("tick");
});

game.trigger("tick");
game.trigger("tick");
game.trigger("tick");

