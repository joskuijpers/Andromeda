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

"use strict";

var fs = process.binding("fs");
var path = process.binding("path");
var hashing = process.binding("hashing");

/**
 * @section File System
 */

exports.list = function (path) {
	return fs.list(path);
};

exports.createDirectory = function (path) {
	if(mkdir(path))
		return new exports.Directory(path);
	return false;
};

exports.remove = function (path) {
	return fs.remove(path);
};

exports.rename = function (path, newPath) {
	return fs.rename(path, newPath);
};

exports.exists = function (path) {
	return fs.exists(path);
};

exports.md5 = function (path) {
	return hashing.fileHash(path, "md5");
};

exports.sha1 = function (path) {
	return hashing.fileHash(path, "sha1");
};

exports.sha256 = function (path) {
	return hashing.fileHash(path, "sha256");
};

/**
 * @section Directory
 */

function Directory(path) {
	this.path = path;

	// TODO define property path as readonly

	this.list = function () {
		return fs.list(this.path);
	};

	this.rename = function (path) {
		if(fs.rename(this.path, path)) {
			this.path = path;
			return true;
		}
		return false;
	};

	this.remove = function () {
		return fs.remove(this.path);
	};
}
exports.Directory = Directory;

/**
 * @section File
 */

function File(path) {
	this.path = path;
	var map = {};
	var hasBeenWritten = false;
	if(fs.exists(path)) {
		load(path);
		this.hasBeenWritten = true;
	}

	Object.defineProperty(this, "length", {
		get: function () {
			return Object.keys(map)
				.length;
		},
		enumerable: true
	});

	/**
	 * Private Functions
	 */

	function load() {
		var data = fs.readFile(this.path);
		console.log("Found data '" + data + "'");
		// TODO
	}

	// Transform the map to a savable string.
	function _toString() {
		var data = "";

		for(var key in map)
			data += key + "=" + map[key] + "\n";

		console.log("data", data);

		return data;
	}

	/**
	 * Public Functions
	 */

	this.save = function () {
		var data = _toString();

		if(fs.writeFile(this.path, data, "utf8")) {
			hasBeenWritten = true;
			return true;
		}
		return false;
	};

	this.md5 = function () {
		return hashing.dataHash(_toString(), "md5");
	};

	this.sha1 = function () {
		return hashing.dataHash(_toString(), "sha1");
	};

	this.sha256 = function () {
		return hashing.dataHash(_toString(), "sha256");
	};

	this.rename = function (path) {
		if(!hasBeenWritten) {
			this.path = path;
			return;
		}

		if(fs.rename(this.path, path)) {
			this.path = path;
			return true;
		}

		return false;
	};

	this.remove = function () {
		if(fs.remove(this.path)) {
			this.path = "";
			map = {};
			return true;
		}
		return false;
	};
}
exports.File = File;

/**
 * @section RawFile
 */