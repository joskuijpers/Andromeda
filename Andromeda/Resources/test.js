console.log("Hello World!");

var test = require("test_module");
console.log(test.add(4,4));

Input.Keyboard.on("keydown",function(key) {
  console.log("Pressed key "+key);
 });

Input.Mouse.Wheel.on("scroll",function(x,y) {
					 if(x > 1.0)
						console.log("Scroll horizontal "+x);
					 if(y > 1.0)
						console.log("Scroll vertical "+y);
					 });