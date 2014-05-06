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

	/**
	 * Convert the data to a string.
	 *
	 * @param {String} [encoding=utf8] - String encoding.
	 * @param {Number} [start=0] - Offset to start at.
	 * @param {Number} [start=buffer.length] - End of the string.
	 * @return {String} String of the buffer.
	 */
	this.toString = function (encoding, start, end) {	
	};
	
	/**
	 * Get a JSON representation of the buffer, usable with Buffer(Array).
	 *
	 * (new Buffer("test")).toJSON() == [116,101,115,116]
	 *
	 * @return {Array} Array of byte elements.
	 */
	this.toJSON = function () {
	};
	
	/**
	 * Write a string to the buffer.
	 *
	 * @param {String} string - The data to be written.
	 * @param {Number} [offset=0] - The offset to start writing at.
	 * @param {Number} [length=buffer.length-offset] - Length of the data to be written.
	 * @param {String} [encoding=utf8] - Encoding of the string.
	 */
	this.write = function(string, offset, length, encoding) {	
	};

	/**
	 * Copy data between buffers.
	 *
	 * @param {Buffer} targetBuffer - Buffer to copy to.
	 * @param {Number} [targetStart=0] - Position to copy to.
	 * @param {Number} [sourceStart=0] - Position to copy from.
	 * @Param {Number} [sourceEnd=buffer.length-sourceStart] - End of slice to copy from.
	 */
	this.copy = function(targetBuffer, targetStart, sourceStart, sourceEnd) {	
	};

	/**
	 * Create a new buffer with the slice of this buffer.
	 *
	 * @param {Number} [start=0] - Start of the buffer.
	 * @param {Number} [end=length-offset] - End of the buffer.
	 * @return {Buffer} Buffer with the slice.
	 */
	this.slice = function(start,end) {	
	};
	
	/**
	 * Fill (a part of) the buffer with specified value.
	 *
	 * @param value - Value to fill with.
	 * @param {Number} [offset=0] - Offset to start the filling.
	 * @param {Number} [end=length-offset] - End of the filling.
	 */
	this.fill = function(value, offset, end) {	
	};

	/**
	 * Read an unsigned 8bit numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint8 = function(offset) {
	};

	/**
	 * Read an unsigned 16 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint16LE = function(offset) {
	};

	/**
	 * Read an unsigned 16 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint16BE = function(offset) {
	};

	/**
	 * Read an unsigned 32 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint32LE = function(offset) {
	};

	/**
	 * Read an unsigned 32 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint32BE = function(offset) {
	};

	/**
	 * Read a signed 8bit numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt8 = function(offset) {
	};

	/**
	 * Read a signed 16 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt16LE = function(offset) {
	};

	/**
	 * Read a signed 16 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt16BE = function(offset) {
	};

	/**
	 * Read a signed 32 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt32LE = function(offset) {
	};

	/**
	 * Read a signed 32 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt32BE = function(offset) {
	};

	/**
	 * Read a 32 bit least endian float from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readFloatLE = function(offset) {
	};

	/**
	 * Read a 32 bit big endian float from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readFloatBE = function(offset) {
	};

	/**
	 * Read a 64 bit least endian double from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readDoubleLE = function(offset) {
	};

	/**
	 * Read a 64 bit big endian double from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readDoubleBE = function(offset) {
	};

	/**
	 * Write an unsigned 8bit numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint8 = function(value, offset) {
	};

	/**
	 * Write an unsigned 16 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint16LE = function(value, offset) {
	};

	/**
	 * Write an unsigned 16 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint16BE = function(value, offset) {
	};

	/**
	 * Write an unsigned 32 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint32LE = function(value, offset) {
	};

	/**
	 * Write an unsigned 32 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint32BE = function(value, offset) {
	};

	/**
	 * Write a signed 8bit numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt8 = function(value, offset) {
	};

	/**
	 * Write a signed 16 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt16LE = function(value, offset) {
	};

	/**
	 * Write a signed 16 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt16BE = function(value, offset) {
	};

	/**
	 * Write a signed 32 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt32LE = function(value, offset) {
	};

	/**
	 * Write a signed 32 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt32BE = function(value, offset) {
	};

	/**
	 * Write a 32 bit least endian float to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeFloatLE = function(value, offset) {
	};

	/**
	 * Write a 32 bit big endian float to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeFloatBE = function(value, offset) {
	};

	/**
	 * Write a 64 bit least endian double to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeDoubleLE = function(value, offset) {
	};

	/**
	 * Write a 64 bit big endian double to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeDoubleBE = function(value, offset) {
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