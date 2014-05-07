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

/**
 * @module buffer
 */

var util = require("util");
var abTools = engine.binding("arraybuffer");

/**
 * A raw data buffer.
 *
 * There are three constructors:
 * - `("string","utf8")` Creates a buffer with given string in optionally given encoding.
 * - `([5,10])` Creates a buffer with length 2, with given data.
 * - `(5)` Creates a buffer with length 5.
 *
 * @constructor
 * @param {Number} subject - Size of the array
 *
 * @param {Array} subject - Array of octets.
 *
 * @param {String} subject - String to put in the buffer.
 * @param {String} [encoding=utf8] - String encoding.
 */
function Buffer(subject, encoding) {
	if(util.isNumber(subject)) {
		this.length = subject > 0 ? subject >>> 0 : 0;
		var array = new ArrayBuffer(this.length);
	} else if(util.isString(subject)) {
		encoding = encoding || "utf8";
		var array = abTools.arrayBufferFromString(subject,encoding);
	} else if(util.isArray(subject)) {
		this.length = +subject.length > 0 ? Math.floor(+subject.length) : 0;

		var array = new ArrayBuffer(this.length);
		var view = new DataView(array);
		for(var i = 0; i < this.length; ++i)
			view.setUint8(i, subject[i]);
	} else if(util.amd_isArrayBuffer(subject)) {
		this.length = subject.length;
		var array = subject;
	} else
		throw new TypeError("Buffer() arguments must start with number, buffer, array or string.");

	var view = new DataView(array);

	/**
	 * Get the internal ArrayBuffer.
	 *
	 * @return {ArrayBuffer}
	 */
	this._getArrayBuffer = function () {
		return array;
	};

	/**
	 * Convert the data to a string.
	 *
	 * @param {String} [encoding=utf8] - String encoding.
	 * @param {Number} [start=0] - Offset to start at.
	 * @param {Number} [start=buffer.length] - End of the string.
	 * @return {String} String of the buffer.
	 */
	this.toString = function (encoding, start, end) {
		start = start >>> 0;
		end = util.isUndefined(end) || end == Infinity ? this.length : end >>> 0;

		encoding = encoding || "utf8";
		if(start < 0)
			start = 0;
		if(end > this.length)
			end = this.length;
		if(end <= start)
			return "";

		return abTools.stringFromArrayBuffer(array, encoding, start, end);
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
	 * @param {Number} [sourceEnd=buffer.length-sourceStart] - End of slice to copy from.
	 * @return {Number} Number of bytes copied.
	 */
	this.copy = function(targetBuffer, targetStart, sourceStart, sourceEnd) {
		if(!util.isBuffer(targetBuffer))
			throw new TypeError("First argument of Buffer.copy() must be a Buffer.");

		targetStart = targetStart >>> 0;
		sourceStart = sourceStart >>> 0;
		sourceEnd = sourceEnd || this.length - sourceStart;
		var targetLength = targetBuffer.length;

		if(targetStart < 0 || targetStart > targetLength)
			throw new RangeError("targetStart is out of range.");
		if(sourceStart < 0 || sourceStart > this.length)
			throw new RangeError("sourceStart is out of range.");
		if(sourceEnd > this.length)
			throw new RangeError("sourceEnd is out of range.");

		if(targetStart >= targetLength || sourceStart >= sourceEnd)
			return 0;

		if(sourceEnd - sourceStart > targetLength - targetStart)
			sourceEnd = targetLength - targetStart + sourceStart;

		return abTools.copy(array,sourceStart,sourceEnd,
							targetBuffer._getArrayBuffer(),targetStart);
	};

	/**
	 * Create a new buffer with the slice of this buffer.
	 *
	 * @param {Number} [start=0] - Start of the buffer.
	 * @param {Number} [end=length-offset] - End of the buffer.
	 * @return {Buffer} Buffer with the slice.
	 */
	this.slice = function(start,end) {
		var slicedArray = array.slice(start >>> 0, end);
		return new Buffer(slicedArray);
	};
	
	/**
	 * Fill (a part of) the buffer with specified value.
	 *
	 * @param value - Value to fill with.
	 * @param {Number} [offset=0] - Offset to start the filling.
	 * @param {Number} [end=length-offset] - End of the filling.
	 */
	this.fill = function(value, offset, end) {
		offset = offset >>> 0;
		end = end || this.length - offset;
		
		if(end > this.length)
			throw new RangeError("Range must be within buffer.");
		
		for(var i = offset; i < end; ++i)
			view.setUint8(i, value);
	};

	/**
	 * Read an unsigned 8bit numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint8 = function(offset) {
		if(offset < 0 || offset > this.length-1)
			throw new RangeError("Offset must be within buffer range.");
		return view.getUint8(offset);
	};

	/**
	 * Read an unsigned 16 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint16LE = function(offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.getUint16(offset,true);
	};

	/**
	 * Read an unsigned 16 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint16BE = function(offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.getUint16(offset,false);
	};

	/**
	 * Read an unsigned 32 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint32LE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getUint32(offset,true);
	};

	/**
	 * Read an unsigned 32 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readUint32BE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getUint32(offset,false);
	};

	/**
	 * Read a signed 8bit numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt8 = function(offset) {
		if(offset < 0 || offset > this.length-1)
			throw new RangeError("Offset must be within buffer range.");
		return view.getInt8(offset);
	};

	/**
	 * Read a signed 16 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt16LE = function(offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.getInt16(offset,true);
	};

	/**
	 * Read a signed 16 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt16BE = function(offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.getInt16(offset,false);
	};

	/**
	 * Read a signed 32 bit least endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt32LE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getInt32(offset,true);
	};

	/**
	 * Read a signed 32 bit big endian numeric value from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readInt32BE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getInt32(offset,false);
	};

	/**
	 * Read a 32 bit least endian float from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readFloatLE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getFloat32(offset,true);
	};

	/**
	 * Read a 32 bit big endian float from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readFloatBE = function(offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.getFloat32(offset,false);
	};

	/**
	 * Read a 64 bit least endian double from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readDoubleLE = function(offset) {
		if(offset < 0 || offset > this.length-8)
			throw new RangeError("Offset must be within buffer range.");
		return view.getFloat64(offset,true);
	};

	/**
	 * Read a 64 bit big endian double from the buffer.
	 *
	 * @param {Number} offset - Offset to read at.
	 * @return {Number} The value.
	 */
	this.readDoubleBE = function(offset) {
		if(offset < 0 || offset > this.length-8)
			throw new RangeError("Offset must be within buffer range.");
		return view.getFloat64(offset,false);
	};

	/**
	 * Write an unsigned 8bit numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint8 = function(value, offset) {
		if(offset < 0 || offset > this.length-1)
			throw new RangeError("Offset must be within buffer range.");
		return view.setUint8(offset, value);
	};

	/**
	 * Write an unsigned 16 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint16LE = function(value, offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.setUint16(offset, value, true);
	};

	/**
	 * Write an unsigned 16 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint16BE = function(value, offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.setUint16(offset, value, false);
	};

	/**
	 * Write an unsigned 32 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint32LE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setUint32(offset, value, true);
	};

	/**
	 * Write an unsigned 32 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeUint32BE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setUint32(offset, value, false);
	};

	/**
	 * Write a signed 8bit numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt8 = function(value, offset) {
		if(offset < 0 || offset > this.length-1)
			throw new RangeError("Offset must be within buffer range.");
		return view.setInt8(offset, value);
	};

	/**
	 * Write a signed 16 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt16LE = function(value, offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.setInt16(offset, value, true);
	};

	/**
	 * Write a signed 16 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt16BE = function(value, offset) {
		if(offset < 0 || offset > this.length-2)
			throw new RangeError("Offset must be within buffer range.");
		return view.setInt16(offset, value, false);
	};

	/**
	 * Write a signed 32 bit least endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt32LE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setInt32(offset, value, true);
	};

	/**
	 * Write a signed 32 bit big endian numeric value to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeInt32BE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setInt32(offset, value, false);
	};

	/**
	 * Write a 32 bit least endian float to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeFloatLE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setFloat32(offset, value, true);
	};

	/**
	 * Write a 32 bit big endian float to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeFloatBE = function(value, offset) {
		if(offset < 0 || offset > this.length-4)
			throw new RangeError("Offset must be within buffer range.");
		return view.setFloat32(offset, value, false);
	};

	/**
	 * Write a 64 bit least endian double to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeDoubleLE = function(value, offset) {
		if(offset < 0 || offset > this.length-8)
			throw new RangeError("Offset must be within buffer range.");
		return view.setFloat64(offset, value, true);
	};

	/**
	 * Write a 64 bit big endian double to the buffer.
	 *
	 * @param {Number} value - Value to write.
	 * @param {Number} offset - Offset to write to.
	 */
	this.writeDoubleBE = function(value, offset) {
		if(offset < 0 || offset > this.length-8)
			throw new RangeError("Offset must be within buffer range.");
		return view.setFloat64(offset, value, false);
	};
}

/**
 * Concatenate multiple buffers into a new buffer.
 *
 * If the length of the new buffer is not enough for all the data,
 * the data is cut.
 *
 * If the list has length 0, an empty buffer is returned. If the
 * list has length 1, the first item is returned. Otherwise, a
 * new buffer is created.
 *
 * If length of all the buffers is known, provide the length for
 * performance.
 *
 * @param {Array<Buffer>} list - List of buffers.
 * @param {Number} [length] - Length of the new buffer.
 */
Buffer.concat = function(list, length) {
	var length = 0;

	if(!util.isArray(list))
		throw new TypeError("Buffer.concat() argument must start with an array.");

	if(list.length === 0)
		return new Buffer(0);
	else if (list.length === 1)
		return list[0];

	if(util.isUndefined(length)) {
		for(var i = 0; i < list.length; ++i)
			length += list[i].length;
	} else
		length = length >>> 0;

	var buffer = new Buffer(length);
	var position = 0;

	for(var i = 0; i < list.length; ++i) {
		list[i].copy(buffer, position);
		position += list[i].length;
	}

	return buffer;
};

module.exports = Buffer;
