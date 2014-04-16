



Database.Query = function(database) {
	this.database = database;
}

Database.Query.prototype.select = function(column) {
	return this;
}

Database.Query.prototype.where = function(object) {
	return this;
}

Database.Query.prototype.get = function(table) {
	console.log("Get from table "+table+" in database "+this.database);

	return {"foo":"bar","x":"y"};
}