console.log("Hello World!");


/* var net = require("net"); */
/* var server = net. */
/* var sock = new net.Socket("www.google.com",80); */
/* sock.write(); */


/**
 Default supported files
 kAudioFileAIFFType            = 'AIFF',
 kAudioFileAIFCType            = 'AIFC',
 kAudioFileWAVEType            = 'WAVE', <--
 kAudioFileSoundDesigner2Type  = 'Sd2f',
 kAudioFileNextType            = 'NeXT',
 kAudioFileMP3Type             = 'MPG3', <--
 kAudioFileMP2Type             = 'MPG2',
 kAudioFileMP1Type             = 'MPG1',
 kAudioFileAC3Type             = 'ac-3',
 kAudioFileAAC_ADTSType        = 'adts',
 kAudioFileMPEG4Type           = 'mp4f',
 kAudioFileM4AType             = 'm4af',
 kAudioFileCAFType             = 'caff',
 kAudioFile3GPType             = '3gpp',
 kAudioFile3GP2Type            = '3gp2',
 kAudioFileAMRType             = 'amrf'
*/

var myPlaylist = new Playlist("/Users/jos/Music/TESV Skyrim - The Original Soundtrack");
myPlaylist.play();

function Playlist(path) {
	this.path = path;
	var paths = [];
	var currentItem = 0;
	var currentSound = null;
	var sound = require("sound");

	var fn = function() {
		currentItem = (currentItem + 1) % paths.length;
		currentSound = new sound.Sound(paths[currentItem]);
		currentSound.on("finished",fn);
		currentSound.play();
		console.log("play",currentSound.path);
	};
	
	var relPaths = require("fs").list(path);
	for(var p in relPaths) {
		var xp = relPaths[p];
		if(xp[0] == '.')
			continue;
			
		paths.push(path+"/"+xp);
	}
	
	this.play = function() {
		if(currentSound == null) {
			currentSound = new sound.Sound(paths[currentItem]);
			currentSound.on("finished",fn);
		}
		currentSound.play();
		console.log("play",currentSound.path);
	};
	
	this.pause = function() {
		currentSound.pause();
	};
	
	this.stop = function() {
		currentSound.stop();
	};
	
	this.reset = function() {
		stop();
		currentSound.reset();
		currentItem = 0;
	};
}