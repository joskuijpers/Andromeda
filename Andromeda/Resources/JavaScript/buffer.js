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

var util = require("util");

function Buffer(subject, encoding) {
	if(util.isNumber(subject))
		this.length = subject > 0 ? subject >>> 0 : 0;
	else if(util.isString(subject))
		this.length = Buffer.byteLength(subject, encoding = encoding || "utf8");
	else if(util.isObject(subject))
		this.length = +subject.length > 0 ? Math.floor(+subject.length) : 0;
	else
		throw new TypeError("Buffer() arguments must start with number, buffer, array or string.");

	// TODO max length check
	
	var array = new ArrayBuffer(this.length);

	this.toString = function (encoding, start, end) {	
	};
	
	this.toJSON = function () {
	};
	
	this.write = function(string, offset, length, encoding) {	
	};

	this.copy = function(targetBuffer, targetStart, sourceStart, sourceEnd) {	
	};

	this.slice = function(start,end) {	
	};
	
	this.fill = function(value, offset, end) {	
	};
}

Buffer.concat = function(list, length) {
	var length = 0;

	if(!util.isArray(list))
		throw new TypeError("Buffer.concat() argument must start with an array.");

	if(util.isUndefined(length)) {
		for(var i = 0; i < list.length; ++i)
			length += list[i].length;
	} else
		length = length >>> 0;

	if(list.length === 0)
		return new Buffer(0);
	else if (list.length === 1)
		return list[0];

	var buffer = new Buffer(length);
	var position = 0;

	for(var i = 0; i < list.length; ++i) {
		list[i].copy(buffer, position);
		position += list[i].length;
	}

	return buffer;
};

module.exports = Buffer;

/**
 * Get the number of bytes in a string using the given encoding.
 *
 * @param {String} string - The string to get the length of.
 * @param {String} encoding - The encoding name.
 * @return {Number} The number of bytes in the string.
 */
Buffer.byteLength = function(string, encoding) {
	switch(encoding) {
		case "ascii":
		case "binary":
		case "raw":
			return string.length;
		case "utf8":
			return string.length;
		case "ucs2":
		case "utf16":
		case "utf16le":
		case "utf16be":
			return string.length * 2;
		case "hex":
			return string.length >>> 1;
		default:
			break;
	}
	return undefined;
};