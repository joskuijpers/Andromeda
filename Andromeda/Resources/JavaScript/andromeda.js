/*
 * Copyright (c) 2014 Jos Kuijpers. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

(function (process) {

	/// JavaScript entry point of Andromeda
	function start() {

		// Load and execute the main module.
		Module.runMain("test");
	}
	
	/// Run code in the current context.
	// This breaks L8Framework because This is then changed into the global
	// and is not bound to the Process class anymore...
	//var runInThisContext = process.runInThisContext;

	/// A module class
	function Module(id, parent) {
		this.filename = null;
		this.id = id;
		this.parent = parent;
		this.exports = {};
	
		if(parent && parent.children) {
			parent.children.push(this);
		}
	
		this.loaded = false;
		this.children = [];
	}
	
	Module._cache = {};
	//Module._pathCache = {};
	
	/// Loading a module.
	Module.prototype.require = function(query) {
		return Module._load(query,this);	
	};
	
	/// Compiles the contents of a module
	Module.prototype._compile = function(content, filename) {
		var self = this;
		
		function require(path) {
			return self.require(path);
		}
		
		require.resolve = function(query) {
			return Module._resolveLookupPaths(query, self);	
		};
		
		var wrapped = Module.wrap(content);
		var compiled = process.runInThisContext(wrapped, {"filename":filename});
		var dirname = "TODO"; // path.dirname()
		
		// Supply our wrapped require function.
		var args = [self.exports, require, self, filename, dirname];
		return compiled.apply(self.exports, args);
	};
	
	/// Wraps a module script to create encapsulation.
	Module.wrap = function(script) {
		return Module.wrapper[0] + script + Module.wrapper[1];
	};
	
	/// The wrapper-parts.
	Module.wrapper = [
		"(function(exports, require, module, __filename, __dirname) { ",
		"\n});"
	];
	
	/// Run the main module.
	Module.runMain = function(name) {
		Module._load(name, null, true);
	};
	
	/// Load a module with given query and parent.
	/// Does resolving of paths.
	Module._load = function(query, parent, isMain) {
		var filename = Module._resolveFilename(query, parent);
		
		var module = Module._cache[filename];
		if(module)
			return module.exports;
		
		module = new Module(filename, parent);
		if(isMain) {
			process.mainModule = module;
			module.id = '.'; // WHY?
		}
		
		Module._cache[filename] = module;
		
		var hadException = true;
		try {
			module.load(filename);
			hadException = false;
		} finally {
			if(hadException)
				delete Module._cache[filename];
		}
		
		return module.exports;
	};
	
	/// Resolve a query to a filename.
	Module._resolveFilename = function(query, parent) {
		var resolve = Module._resolveLookupPaths(query, parent);
		//var id = resolve[0];
		var possiblePaths = resolve[1];
		
		var filename = Module._findPath(query, possiblePaths);
		if(!filename)
			throw new Error("Can't find module '"+query+"'");
		
		return filename;
	};
	
	/// Get possible paths for a query.
	Module._resolveLookupPaths = function(query, parent) {
		return ["myID",[query+".js"]]; // TODO
	};
	
	/// Find the actual path for a query.
	Module._findPath = function(query, possiblePaths) {
			return possiblePaths[0]; // TODO
	};
	
	/// Load this module by compiling it.
	Module.prototype.load = function(filename) {
		//assert(!this.loaded);
		this.filename = filename;
	
		
		var content = process.readFile(filename);
		this._compile(content,filename);
		
		this.loaded = true;
	};

	start();
});

/*

BINDINGS = JS <> C++
 
process.binding(class)
	looks into cache
		return cache (exports)
	else if exists
		create L8Value newObject
		install(context, newObject)
		cache
		return object (exports)
	else if natives
		set object to Map of available native modules

*/


