// sample playback boilerplate

~buf1 = Buffer.read(s, "", action: { "~buf1 loaded".postln; }); // read a sample into a buffer

SynthDef(\play, { | amp = 0.0, buf, trig = 0 |
		var env, sig;

		env = EnvGen.kr( Env.asr( 0.0, 0.95, 0.05), trig,  doneAction: 0 );
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 0) * env; // num channels needs to match (and HAS to be hard coded)
		Out.ar(0, sig);
}).add;


// load every sample in a directory (folder) into its own Buffer, make an Array called ~buffers to store each Buffer

loadSamplesAll = ({ | dir |
	var thePath, bufList;

	// make the bufList
	bufList = List.new(0);

	// get the full path name for the directory
	thePath = PathName.new(dir.asString);

	//read each file into a new buffer and add each Buffer to bufList
	thePath.filesDo{ |file|

		bufList.add( Buffer.readChannel(s, file.fullPath, channels: 0 ) ); // this is a hack to eliminate accidental stereo buffers

	};

// convert bufList to an array called ~buffers
~buffers = bufList.asArray;

});

loadSamplesAll.value("/Users/cta/Desktop/samples");

// check to make sure we have the samples
~buffers;