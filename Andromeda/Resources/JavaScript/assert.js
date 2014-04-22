/*
 * Copyright (c) 2014 Jos Kuijpers. All rights reserved.
 *
 * http://wiki.commonjs.org/wiki/Unit_Testing/1.0
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

// 1. The assert module provides functions that throw AssertionError's
//    when particular conditions are not met. The assert module must
//    conform to the following interface.

var assert = module.exports = ok;

// 2. The AssertionError is defined in assert.
//     new assert.AssertionError({message: message, actual: actual,
//     expected: expected})
//     assert.AssertionError instanceof Error
assert.AssertionError = function AssertionError(options) {
	this.name = "AssertionError";
	this.actual = options.actual;
	this.expected = options.expected;
	this.operator = options.operator;
	if(options.message)
		this.message = options.message
	else {
		this.message = JSON.stringify(this.actual) + ' ' + this.operator + ' '
			+ JSON.stringify(this.expected);
	}
	Error.captureStackTrace(this, options.stackStartFunction || fail);
};
util.inherits(assert.AssertionError, Error);

// 3. All of the following functions must throw an AssertionError when a
//    corresponding condition is not met, with a message that may be undefined
//    if not provided. All assertion methods provide both the actual and
//    expected values to the assertion error for display purposes.

function fail(actual, expected, message, operator, stackStartFunction) {
	throw new assert.AssertionError({
		actual: actual,
		expected: expected,
		message: message,
		operator: operator,
		stackStartFunction: stackStartFunction
	});
}

// 4. Pure assertion tests whether a value is truthy, as determined by !!guard.
//     assert.ok(guard, message_opt);
//    This statement is equivalent to assert.equal(guard, true, message_opt);.
//    To test strictly for the value true, use assert.strictEqual(guard, true,
//     message_opt);.
function ok(guard, message) {
	if(!guard)
		fail(guard, true, message, '==', assert.ok);
}
assert.ok = ok;

// 5. The equality assertion tests shallow, coercive equality with ==.
//     assert.equal(actual, expected, message_opt);
assert.equal = function (actual, expected, message) {
	if(actual != expected)
		fail(actual, expected, message, '==', assert.equal);
}

// 6. The non-equality assertion tests for whether two objects are not equal
//    with !=
//     assert.notEqual(actual, expected, message_opt);
assert.notEqual = function (actual, expected, message) {
	if(actual == expected)
		fail(actual, expected, message, '!=', assert.notEqual);
}

// 7. The equivalence assertion tests a deep equality relation.
//       assert.deepEqual(actual, expected, message_opt);
assert.deepEqual = function (actual, expected, message) {
	if(!_deepEqual(actual, expected))
		fail(actual, expected, message, 'deepEqual', assert.deepEqual);
};

// 8. The non-equivalence assertion tests for any deep inequality.
//     assert.notDeepEqual(actual, expected, message_opt);
assert.notDeepEqual = function (actual, expected, message) {
	if(_deepEqual(actual, expected))
		fail(actual, expected, message, 'notDeepEqual', assert.notDeepEqual);
};

function _deepEqual(actual, expected) {
	// 7.1. All identical values are equivalent, as determined by ===.
	if(actual === expected)
		return true;

	if(util.isBuffer(actual) && util.isBuffer(expected)) {

	}

	// 7.2. If the expected value is a Date object, the actual value is equivalent
	//      if it is also a Date object that refers to the same time.
	if(util.isDate(actual) && util.isDate(expected))
		return actual.getTime() === expected.getTime();

	if(util.isRegExp(actual) && util.isRegExp(expected)) {
		return actual.source === expected.source &&
			actual.global === expected.global &&
			actual.multiline === expected.multiline &&
			actual.lastIndex === expected.lastIndex &&
			actual.ignoreCase === expected.ignoreCase;
	}

	// 7.3. Other pairs that do not both pass typeof value == "object", equivalence
	//      is determined by ==.
	if(!util.isObject(actual) && !util.isObject(expected))
		return actual == expected;

	// 7.4. For all other Object pairs, including Array objects, equivalence is
	//      determined by having the same number of owned properties (as verified
	//      with Object.prototype.hasOwnProperty.call), the same set of keys
	//      (although not necessarily the same order), equivalent values for every
	//      corresponding key, and an identical "prototype" property. Note: this
	//      accounts for both named and indexed properties on Arrays.
	return objEquiv(actual, expected);
}

/*
 * From node.js lib/buffer.js
 * @license MIT
 */
function isArguments(object) {
	return Object.prototype.toString.call(object) == '[object Arguments]';
}

/*
 * From node.js lib/buffer.js
 * @license MIT
 */
function objEquiv(a, b) {
	if(util.isNullOrUndefined(a) || util.isNullOrUndefined(b))
		return false;
	// an identical 'prototype' property.
	if(a.prototype !== b.prototype) return false;
	//~~~I've managed to break Object.keys through screwy arguments passing.
	//   Converting to array solves the problem.
	var aIsArgs = isArguments(a),
		bIsArgs = isArguments(b);
	if((aIsArgs && !bIsArgs) || (!aIsArgs && bIsArgs))
		return false;
	if(aIsArgs) {
		a = pSlice.call(a);
		b = pSlice.call(b);
		return _deepEqual(a, b);
	}
	try {
		var ka = Object.keys(a),
			kb = Object.keys(b),
			key, i;
	} catch(e) { //happens when one is a string literal and the other isn't
		return false;
	}
	// having the same number of owned properties (keys incorporates
	// hasOwnProperty)
	if(ka.length != kb.length)
		return false;
	//the same set of keys (although not necessarily the same order),
	ka.sort();
	kb.sort();
	//~~~cheap key test
	for(i = ka.length - 1; i >= 0; i--) {
		if(ka[i] != kb[i])
			return false;
	}
	//equivalent values for every corresponding key, and
	//~~~possibly expensive deep test
	for(i = ka.length - 1; i >= 0; i--) {
		key = ka[i];
		if(!_deepEqual(a[key], b[key])) return false;
	}
	return true;
}


// 9. The strict equality assertion tests strict equality, as determined by ===.
//     assert.strictEqual(actual, expected, message_opt);
assert.strictEqual = function (actual, expected, message) {
	if(actual !== expected)
		fail(actual, expected, message, '===', assert.strictEqual);
};

// 10. The strict non-equality assertion tests for strict inequality, as determined by !==.
//      assert.notStrictEqual(actual, expected, message_opt);
assert.notStrictEqual = function (actual, expected, message) {
	if(actual === expected)
		fail(actual, expected, message, '!==', assert.notStrictEqual);
};

// 11. Expected to throw an error:
//      assert.throws(block, Error_opt, message_opt);
assert.throws = function throws(block, error, message) {
	var caught;

	try {
		block();
	} catch(e) {
		caught = e;
	}

	if(!caught)
		fail(caught, error, "Missing expected exception " + message, assert.throws);

	if(error && !(caught instanceof error || error.call({}, caught) === true))
		throw caught;
};
