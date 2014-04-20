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

	var vmBinding = process.binding("vm");
	var fsBinding = process.binding("fs");

	/// JavaScript entry point of Andromeda
	function start() {

		// Load and execute the main module.
		Module.runMain("test");
	}

	/// Run code in the current context.
	// This breaks L8Framework because This is then changed into the global
	// and is not bound to the Process class anymore...
	//var runInThisContext = process.runInThisContext;

	////////////////////////////////////////
	/// Modules
	////////////////////////////////////////

	/// A module class
	function Module(id, parent) {
		this.filename = null;
		this.id = id;
		this.parent = parent;
		this.exports = {};
		this._process = process;

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

	/// Load this module by compiling it.
	Module.prototype.load = function(filename) {
		//assert(!this.loaded);
		this.filename = filename;

		var content = fsBinding.readFile(filename,"utf8");
		this._compile(content,filename);

		this.loaded = true;
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

	/// Compiles the contents of a module
	Module.prototype._compile = function(content, filename) {
		var self = this;

		function require(query) {
			return self.require(query);
		}

		require.resolve = function(query) {
			return Module._resolveQuery(query, self);
		};

		var dirname = "TODO";
		var wrapped = Module.wrap(content);
		var compiled = vmBinding.runInThisContext(wrapped, {"filename":filename});

		// Supply our wrapped require function.
		var args = [self.exports, require, self, filename, dirname];
		return compiled.apply(self.exports, args);
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
		var filename = Module._resolveQuery(query, parent);
		if(!filename)
			throw new Error("Can't find module '"+query+"'");

		return filename;
	};

	/// Resolve the query
	Module._resolveQuery = function(query, parent) {
			return query+".js"; // TODO
	};

	// After loading all code, start!
	start();
});
