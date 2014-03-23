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

/**************************************************************************************************
 ***** System
 **************************************************************************************************/

function GetVersion() {
	return System.version;
}

function GetVersionString() {
	return System.versionString();
}

function Abort(msg) {
	System.abort(msg);
}

function Exit() {
	System.exit();
}

function RestartGame() {
	System.restart();
}

function GarbageCollect() {
	System.Debug.garbageCollect();
}

function EvaluateSystemScript(script) {
	include(script);
}

function EvaluateScript(script) {
	include(script);
}

function RequireSystemScript(script) {
	require(script);
}

function RequireScript(script) {
	require(script);
}

function GetTime() {
	return System.milliseconds();
}

/**************************************************************************************************
 ***** Game
 **************************************************************************************************/

function Game() {
	this.name = "current";
	this.author = "Unknown";
	this.description = "";
	this.directory = "/";
}

function GetGameList() {
	var g = new Game();
	return [g];
}

function ExecuteGame() {
	// Only 1 game is allowed to run, and it is the current game.
	// Just restart (which is essentially loading the game).
	Game.restart();
}

/**************************************************************************************************
 ***** Screen
 **************************************************************************************************/

function GetScreenWidth() {
	return Screen.width();
}

function GetScreenHeight() {
	return Screen.height();
}

function Rectangle(x,y,w,h,c) {
	Screen.drawRect(x,y,w,h,c);
}

function FilledRectangle(x,y,w,h,c) {
	Screen.drawFilledRect(x,y,w,h,c);
}

function GradientRectangle(x,y,w,h,c1,c2,c3,c4) {
	Screen.drawFilledRect(x,y,w,h,c1,c2,c3,c4);
}

// TODO

function FlipScreen() {
	Screen.flip();
}

/**************************************************************************************************
 ***** Input: Gamepad
 **************************************************************************************************/

function GetNumJoysticks() {
	return Input.gamepads.length;
}

function GetNumJoystickButtons(js) {
	return Input.gamepads[js].buttons.length;
}

function GetNumJoystickAxes(js) {
	return Input.gamepads[js].axes.length;
}

function GetTalkActivationButton() {
	// TODO: what gamepad?
}

function SetTalkActivationButton(button) {
	// TODO: what gamepad?
}

function IsJoystickButtonPressed(js,button) {
	return Input.gamepads[js].isButtonPressed(button);
}

function GetJoystickAxis(js,axis) {
	return Input.gamepads[js].getAxis(axis);
}

var JOYSTICK_AXIS_X = Input.Gamepad.AXIS_X;
var JOYSTICK_AXIS_Y = Input.Gamepad.AXIS_Y;
var JOYSTICK_AXIS_Z = 2;
var JOYSTICK_AXIS_R = 3;

/**************************************************************************************************
 ***** Input: Keyboard
 **************************************************************************************************/

function GetPlayerKey(player,key) {
	var config = Input.Config.players[player];

	switch(key) {
		case PLAYER_KEY_MENU: return config.menu;
		case PLAYER_KEY_UP: return config.up;
		case PLAYER_KEY_DOWN: return config.down;
		case PLAYER_KEY_LEFT: return config.left;
		case PLAYER_KEY_RIGHT: return config.right;
		case PLAYER_KEY_A: return config.a;
		case PLAYER_KEY_B: return config.b;
		case PLAYER_KEY_X: return config.x;
		case PLAYER_KEY_Y: return config.y;
		default:
			return undefined;
	};

	return undefined;
}

var PLAYER_1 = 0;
var PLAYER_2 = 1;
var PLAYER_3 = 2;
var PLAYER_4 = 3;

var PLAYER_KEY_MENU = 0;
var PLAYER_KEY_UP = 1;
var PLAYER_KEY_DOWN = 2;
var PLAYER_KEY_LEFT = 3;
var PLAYER_KEY_RIGHT = 4;
var PLAYER_KEY_A = 5;
var PLAYER_KEY_B = 6;
var PLAYER_KEY_X = 7;
var PLAYER_KEY_Y = 8;

function AreKeysLeft() {
	// Folded into GetKey(): if no keys left, returns KEY_NONE;
	// This might break code and result in infinite loops.
	return true;
}

function GetKey() {
	return Input.Keyboard.getKey();
}

function IsAnyKeyPressed() {
	return Input.Keyboard.IsKeyPressed();
}

function IsKeyPressed(key) {
	return Input.Keyboard.isKeyPressed(key);
}

function GetToggleState(key) {
	return Input.Keyboard.getToggleState(key);
}

function GetKeyString(key, shift) {
	return Input.Keyboard.getKeyString(key,shift);
}

/**************************************************************************************************
 ***** Input: Mouse
 **************************************************************************************************/

function GetMouseX() {
	return Input.Mouse.x;
}

function GetMouseY() {
	return Input.Mouse.y;
}

function SetMousePosition(x,y) {
	Input.Mouse.setPosition(x,y);
}

function IsMouseButtonPressed(button) {
	return Input.Mouse.isButtonPressed(button);
}

function GetMouseWheelEvent() {
	return Input.Wheel.getEvent();
}

function GetNumMouseWheelEvents() {
	// 1 to trigger any check conditions; Will probably break code.
	return 1;
}

/**************************************************************************************************
 ***** Networking
 **************************************************************************************************/

function GetLocalAddress() {
	return Network.localAddress;
}

function GetLocalName() {
	return Network.localName;
}

function ListenOnPort(port) {
	return Network.listen(port);
}

function OpenAddress(address, port) {
	return new Network.Socket(address, port);
}

// TODO socket

/**************************************************************************************************
 ***** Map Engine
 **************************************************************************************************/

/**************************************************************************************************
 ***** Sound
 **************************************************************************************************/

/**************************************************************************************************
 ***** SoundEffect
 **************************************************************************************************/

/**************************************************************************************************
 ***** Color
 **************************************************************************************************/

function CreateColor(r,g,b,a) {
	return new Color(r,g,b,a);
}

function BlendColors(c1,c2) {
	return c1.blend(c2);
}

function BlendColorsWeighted(c1,c2,w1,w2) {
	return c1.blend(c2,w1,w2);
}

/**************************************************************************************************
 ***** Color matrix
 **************************************************************************************************/

/**************************************************************************************************
 ***** Spriteset
 **************************************************************************************************/

function LoadSpriteset(path) {
	return new Spriteset(path);
}

/**************************************************************************************************
 ***** Font
 **************************************************************************************************/

function LoadFont(path) {
	return new Font(path);
}

/**************************************************************************************************
 ***** WindowStyle
 **************************************************************************************************/

function LoadWindowStyle(path) {
	return new WindowStyle(path);
}

/**************************************************************************************************
 ***** Image
 **************************************************************************************************/

function LoadImage(filename) {
	return new Image(filename);
}

/**************************************************************************************************
 ***** Surface
 **************************************************************************************************/

/**************************************************************************************************
 ***** Animation
 **************************************************************************************************/

function LoadAnimation(path) {
	return new Animation(path);
}

/**************************************************************************************************
 ***** FileSystem
 **************************************************************************************************/

function GetDirectoryList(path) {
	var list = FileSystem.list(path);

	// TODO; remove any items not ending in /

	return list;
}

function GetFileList(path) {
	var list = FileSystem.list(path);

	// TODO; remove any items ending in /

	return list;
}

function RemoveFile(path) {
	FileSystem.remove(path);
}

function Rename(old,newItem) {
	FileSystem.rename(old,newItem);
}

function CreateDirectory(path) {
	FileSystem.CreateDirectory(path);
}

function RemoveDirectory(path) {
	 FileSystem.remove(path);
}

function HashFromFile(path) {
	return FileSystem.md5(file);
}

/**************************************************************************************************
 ***** File
 **************************************************************************************************/

function OpenFile(path) {
	return new FileSystem.File(path);
}

FileSystem.File.prototype.getNumKeys = function() {
	return this.size;
}

FileSystem.File.prototype.getKey = function() {
	return undefined;
}

/**************************************************************************************************
 ***** RawFile
 **************************************************************************************************/

function OpenRawFile(path) {
	return new FileSystem.RawFile(path);
}

FileSystem.RawFile.prototype.getSize = function() {
	return this.size;
}

FileSystem.RawFile.prototype.getPosition = function() {
	return this.position;
}

FileSystem.RawFile.prototype.setPosition = function(position) {
	this.position = position;
}

/**************************************************************************************************
 ***** Log
 **************************************************************************************************/

/**************************************************************************************************
 ***** Byte Array
 **************************************************************************************************/

function CreateByteArray(length) {
	return new ByteArray(length);
}

function CreateByteArrayFromString(string) {
	return new ByteArray(string);
}

function CreateStringFromByteArray(byte_array) {
	return byte_array.makeString();
}

function HashByteArray(byte_array) {
	return byte_array.md5hash();
}
