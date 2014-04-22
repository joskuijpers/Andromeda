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

// Prevent using an overridden toString()
function objectToString(object) {
	return Object.prototype.toString.call(object);
}

/**
 * @section Instanceof functions.
 */

exports.isArray = Array.isArray;

exports.isBoolean = function (arg) {
	return typeof arg === "boolean";
};

exports.isNull = function (arg) {
	return arg === null;
};

exports.isNullOrUndefined = function (arg) {
	return arg == null;
};

exports.isNumber = function (arg) {
	return typeof arg === "number";
};

exports.isString = function (arg) {
	return typeof arg === "string";
};

exports.isUndefined = function (arg) {
	return arg === void 0;
};

exports.isRegExp = function (arg) {
	return isObject(arg) && objectToString(arg) === "[object RegExp]";
};

function isObject(arg) {
	return typeof arg === "object" && arg !== null;
};
exports.isObject = isObject;

exports.isDate = function (arg) {
	return isObject(arg) && objectToString(arg) === "[object Date]";
};

exports.isError = function (arg) {
	return isObject(arg) && (objectToString(arg) === "[object Error]" || arg instanceof Error);
};

exports.isFunction = function (arg) {
	return typeof arg === "function";
};

exports.isBuffer = function (arg) {
	return arg instanceof Buffer;
};

exports.amd_isSymbol = function (arg) {
	return typeof arg == "symbol";
};

exports.amd_isArrayBuffer = function (arg) {
	return isObject(arg) && objectToString(arg) === "[object ArrayBuffer]";
};

/**
 * Make a function inherit from another function.
 *
 * @param {Function} constructor - The constructor that will inherit.
 * @param {Function} superConstructor - The constructor that will be inherited from.
 */
exports.inherits = function (constructor, superConstructor) {
	constructor.super_ = superConstructor;
	constructor.prototype = Object.create(superConstructor.prototype, {
		constructor: {
			value: constructor,
			enumarable: false,
			writable: true,
			configurable: true
		}
	});
};
