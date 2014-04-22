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

// 12. The "test" module provides a "run" method that runs unit tests and
//     catalogs their results. The "run" method must return the total number
//     of failures, suitable for use as a process exit status code. The idiom
//     for a self-running test module program would be:
//      if (module === require.main)
//        require("test").run(exports);

// 13. run must accept any Object, usually a unit test module's exports.
//     "run" will scan the object for all functions and object properties that
//     have names that begin with but are not equal to "test", and other
//     properties for specific flags. Sub-objects with names that start with
//     but are not equal to "test" will be run as sub-tests.
//
//     A future version of this specification may add a mechanism for changing
//     the mode of test functions from fail-fast (where failed assertions throw)
//     to fail-slow (where failed assertions just log/print) via a logger
//     argument or similar, but in the interim, this is implementation specific.

// 14. Test names may be any String that begins with "test", not necessarily
//     respecting a case convention.

exports.run = function (tests) {
	var failures = 0;
	var total = 0;

	for(var key in tests) {
		if(!util.isString(key) || !key.startsWith("test", false))
			continue;

		++total;

		try {
			tests[key].call();
			console.log("Test Case '" + key + "' passed.");
		} catch(e) {
			++failures;
			console.log("Test Case '" + key + "' failed. " + e.name + ": " + e.message);
		}
	}

	console.log("Executed " + total + " tests, with " + failures + " failure" 
		+ (failures == 1 ? "" : "s") + ".");
};

String.prototype.startsWith = function (searchString, casesensitive) {
	if(this.length <= searchString.length)
		return false;

	var sliced = this.substr(0, searchString.length);
	if(!casesensitive) {
		searchString = searchString.toLowerCase();
		sliced = sliced.toLowerCase();
	}

	return sliced == searchString;
}
