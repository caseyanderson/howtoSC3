s.boot;

/////////
// sample playback boilerplate

~buf1 = Buffer.read(s, "/Users/cta/Desktop/haiti_baptism.wav", action: { "~buf1 loaded".postln; }); // read a sample into a buffer

(
SynthDef(\playS, { | amp = 0.0, buf, rate = 1, trig = 0 |
	var env, sig;

	env = EnvGen.kr( Env.asr( 0.0, 0.95, 0.05), trig,  doneAction: 2 );
	sig = PlayBuf.ar(2, buf, rate, loop: 1) * env; // num channels needs to match Buffer (and HAS to be hard coded)
	Out.ar(0, sig * amp);
}).add;
)

Synth(\playS, [\amp, 0.5, \buf, ~buf1, \trig, 1 ]); // play once, dont loop
Synth(\playS, [\amp, 0.5, \buf, ~buf1, \rate, 0.5, \trig, 1 ]); // play once half speed


/////////
// load every sample in a directory (folder) into its own Buffer, make an Array called ~buffers to store each Buffer

(
~loadSamplesAll = ({ | dir |
	var thePath, bufList;

	// make the bufList
	bufList = List.new(0);

	// get the full path name for the directory
	thePath = PathName.new(dir.asString);

	//read each file into a new buffer and add each Buffer to bufList
	thePath.filesDo{ |file|

		bufList.add( Buffer.readChannel(s, file.fullPath, channels: 0 ) );

	};

// convert bufList to an array called ~buffers
~buffers = bufList.asArray;

});
)

~loadSamplesAll.value("/Users/cta/Desktop/samples");

// check to make sure we have the samples
~buffers.size;

// test it out

SynthDef(\playM, { | amp = 0.0, buf, trig = 0 |
	var env, sig;

	env = EnvGen.kr( Env.asr( 0.0, 0.95, 0.05), trig,  doneAction: 2 );
	sig = PlayBuf.ar(1, buf, BufRateScale.kr( buf ), loop: 0) * env;
	Out.ar(0, Pan2.ar(sig * amp, 0.0));
}).add;

// randomly select a sample to play from ~buffers
Synth.new(\playM, [\amp, 0.5, \buf, ~buffers[rrand(0, (~buffers.size - 1))], \trig, 1]);


/////////
// randomly play samples in random order for their entire duration

SynthDef(\playM, { | amp = 0.0, buf, len, loop = 0, trig = 1 |
	var env, sig;

	env = EnvGen.kr( Env.linen( 0.0, len, 0.01), trig,  doneAction: 2 );
	sig = PlayBuf.ar(1, buf, BufRateScale.kr( buf ), loop: 0) * env;
	Out.ar(0, Pan2.ar(sig * amp, 0.0));
}).add;

~sample_player = Pbind(
	\instrument, \playM,
	\amp, 0.9,
	\buf, Pxrand(~buffers, inf),
	\len, Pfunc { |e|
		var dur;
		dur = e[\buf].duration;
		dur.postln;
	},
	\delta, Pkey(\len)
);

~playMe = ~sample_player.play;
~playMe.stop;

/////////
// randomly play a short duration of a randomly selected sample for a fixed duration

SynthDef(\play, { | amp = 0.0, buf, len = 5.0, start = 0, trig = 1 |
	var env, sig;

	env = EnvGen.kr( Env.linen( 0.0, len - 0.01, 0.01), trig,  doneAction: 2 );
	sig = PlayBuf.ar(1, buf, BufRateScale.kr( buf ), startPos: (start * BufFrames.kr(buf)), loop: 1) * env;
	Out.ar(0, Pan2.ar(sig, 0.0));
}).add;

~sample_player = Pbind(
	\instrument, \play,
	\amp, 0.9,
	\buf, Pxrand(~buffers, inf),
	\len, 5,
	\start, Pwhite(0.0, 1.0, inf),
	\delta, Pkey(\len)
);

~playMe = ~sample_player.play;
~playMe.stop;

