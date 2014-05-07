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
 * @module sound
 */

var binding = engine.binding("sound");
var NativeSound = binding.NativeSound;

var _sounds = [];

exports.volume = 1.0;

exports.stop = function() {
};

function Sound(path) {
	var nativeSound = new NativeSound(path);

	this.path = path;
	this.repeat = false;

	Object.defineProperty(this,"playing",{
		get: function () { return nativeSound.playing; },
		readonly: true
	});

	Object.defineProperty(this,"length",{
		value: nativeSound.length,
		readonly: true
	});
	
	Object.defineProperty(this, "position", {
		set: function (pos) { nativeSound.position = pos; },
		get: function () { return nativeSound.position; }
	});
	
	Object.defineProperty(this, "volume", {
		set: function (volume) { nativeSound.volume = volume; },
		get: function () { return nativeSound.volume; }
	});
	
	Object.defineProperty(this, "pan", {
		set: function (pan) { nativeSound.pan = pan; },
		get: function () { return nativeSound.pan; }
	});
/*
	Object.defineProperty(this, "pitch", {
		set: function (pos) { nativeSound.position = pos; },
		get: function () { return nativeSound.position; }
	});
*/
	this.pitch = 1.0;

	this.play = function() {
		nativeSound.play();
	};

	this.pause = function() {
		nativeSound.pause();
	};

	this.stop = function() {
		nativeSound.stop();
	};

	this.reset = function() {
		nativeSound.stop();
		nativeSound.position = 0.0;
	};
	
	this.on = function(event,fn) {
		nativeSound.on(event,fn);
	};
}
exports.Sound = Sound;

function SoundEffect(path, multiple) {
	/**
	 * @readonly
	 */
	this.path = path;

	/**
	 * @readonly
	 */
	this.multiple = multiple || false;
	this.volume = 1.0;
	this.pan = 0.0;
	this.pitch = 1.0;

	this.play = function() {
	};

	this.stop = function() {
	};
}
exports.SoundEffect = SoundEffect;
