
exports.add = function(a,b) {
	return a+b;
}

exports.concat = function(a,b) {
	return a+""+b;
}

function Test() {
	this.key = "value";
}
exports.Test = Test;
