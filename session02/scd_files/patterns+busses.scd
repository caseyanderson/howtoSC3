s.options.memSize = 2097152;
s.boot;


// the busses

(

~window; ~b1; ~b2; ~b3; ~h1; ~h2; ~h3; ~s1; ~s2; ~s3; ~sfund; // set up global variables

// make the control busses
~vol1 = Bus.control(s, 1).set(0.0);
~vol2 = Bus.control(s, 1).set(0.0);
~vol3 = Bus.control(s, 1).set(0.0);
~fund = Bus.control(s, 1).set(400);


)


// the GUI

(
// make the gui window
~window = Window.new("noon to midnight", Rect(0,0,600,640))
    .onClose_({
	// these are performed when the window is closed (its like a shutdown thing)
	~sinPatternPlayer.stop;
	~formantPatternPlayer1.stop;
	~formantPatternPlayer2.stop;
	~pinkPatternPlayer.stop;
});


// instrument 1 (every instrument has the same control structure)
// an on/off button
~b1 = Button(~window, Rect( 10, 10, 50, 50))
		.states_([ // there are two states for this button
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
// the action to perform when the button value is or is not 1 (pressed)
.action_({ arg butt;
	if( butt.value == 1,
		{ ~sinPatternPlayer = ~sinPattern.play;
		"SIN PLAYING".postln;
		},
		{ ~sinPatternPlayer.stop;
		"SIN STOPPED".postln;
		}
	);
});

// a number box, this is used like a label here
~h1 = NumberBox(~window, Rect(10, 10 + 60, 50, 50));
~h1.align = \center;
~h1.value = 0;

// a volume slider
~s1 = Slider.new(~window, Rect(65, 10, 50, 200))
.action_({ |slider|
	~vol1.set(slider.value); // connect the slider position to the vol1 control bus...i.e. this controls volume
});


// instrument 2, note the repetition of the above here
~b2 = Button(~window, Rect( 10, 220, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])

.action_({ arg butt;
	if( butt.value == 1,
		{ ~formantPatternPlayer1 = ~formantPattern1.play;
		"FORMANT PLAYING".postln;
		},
		{ ~formantPatternPlayer1.stop;
		"FORMANT STOPPED".postln;
		}
	);
});

~h2 = NumberBox(~window, Rect(10, 220 + 60, 50, 50));
~h2.align = \center;
~h2.value = 1;

~s2 = Slider.new(~window, Rect(65, 220, 50, 200))
.action_({ |slider|
	~vol2.set(slider.value);
});


// instrument 3, again, this is basically the same
~b3 = Button(~window, Rect( 10, 430, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])

.action_({ arg butt;
	if( butt.value == 1,
		{ ~formantPatternPlayer2 = ~formantPattern2.play;
		"THIRD PLAYING".postln;
		},
		{ ~formantPatternPlayer2.stop;
		"THIRD STOPPED".postln;
		}
	);
});

~h3 = NumberBox(~window, Rect(10, 430 + 60, 50, 50));
~h3.align = \center;
~h3.value = 2;

~s3 = Slider.new(~window, Rect(65, 430, 50, 200))
.action_({ |slider|
	~vol3.set(slider.value);
});

// sets fundamental, i.e. all synths will play a partial of the same fundamental
~sfund = Slider.new(~window, Rect(365, 10, 50, 200))
.action_({ |slider|
	var map;

	map = (slider.value.linlin(0.0, 1.0, 50.0, 500.0));
	~fund.set(map);
	map.postln;
});

~window.front;

)


// the synths

(

SynthDef(\sin, { | amp = 0.0, end = 2, freq = 300, len = 2, max = 0.7, maxdelay = 1, min = 0.2, start = 1, trig = 1 |
	var env, line, sig;

	env = EnvGen.kr( Env.perc( len * 0.25, len * 0.75 ), trig, doneAction: 2 );
	line = Line.kr( start, end, len, doneAction: 2 );
	sig = SinOsc.ar(freq * DelayN.kr(line, maxdelay, Rand(min, max)), 0.0, amp) * env;
	Out.ar( 0, Pan2.ar( sig * 0.25) );
}).add;


SynthDef(\formant, { | amp = 0.0, end = 2, freq = 300, len = 2, max = 0.7, maxdelay = 1, min = 0.2, start = 1, trig = 1 |
	var env, clean, line, sig;

	env = EnvGen.kr( Env.perc( len * 0.25, len * 0.75 ), trig, doneAction: 2 );
	line = XLine.kr( start, end, len, doneAction: 2 );
	sig = Formant.ar(freq * DelayN.kr(line, maxdelay, Rand(min, max)), DelayN.kr(line, maxdelay, Rand(min, max)), DelayN.kr(line, maxdelay, Rand(min, max)), amp) * env;
	clean = HPF.ar(sig, 50); // should probably be a compressor
	Out.ar( 0, Pan2.ar( clean ) );
}).add;


)

// the patterns
// these control the synths

(
~sinPattern = Pbind(
	\instrument, \sin, // the synth that the pattern plays
	\freq, ~fund.asMap, // connect this parameter to the value of ~fund control bus
	\start, Prand([2,3,5,7,11,13], inf), // randomly pick a number from the array
	\end, Prand([2,3,5,7,11,13], inf), // basically the same
	\len, Pwhite(20, 50, inf), // randomly pick a number between 20 and 50
	\amp, ~vol1.asMap, // connect the amp parameter to the vol1 control bus
	\dur, (Pkey(\len) + 2) // the duration of one pass through the pattern, here with two extra seconds so there will always be two seconds between playback instances
);

// the next two patterns are basically the same
~formantPattern1 = Pbind(
	\instrument, \formant,
	\freq, ~fund.asMap,
	\start, Prand([2,3,5,7,11,13,17], inf),
	\end, Prand([2,3,5,7,11,13,17], inf),
	\len, Pwhite(20, 50, inf),
	\amp, ~vol2.asMap,
	\dur, (Pkey(\len) + 2)
);

~formantPattern2 = Pbind(
	\instrument, \formant,
	\freq, ~fund.asMap,
	\start, Prand([2,3,5,7,11,13,17], inf),
	\end, Prand([2,3,5,7,11,13,17], inf),
	\len, Pwhite(20, 50, inf),
	\amp, ~vol3.asMap,
	\dur, (Pkey(\len) + 2)
);


)