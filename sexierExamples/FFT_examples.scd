
// does nothing, just represents the processing flow

~b = Buffer.alloc(s,1024);

~x = (
	{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in);
	[IFFT(chain),in];
	};
)

~x.play;
~b.free; // frees the FFT buffer


// processes input with PV_BrickWall

~b = Buffer.alloc(s,1024);

~x = (
	{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in);
	chain = PV_BrickWall(chain, Line.kr(-1,1,10));
	Pan2.ar(IFFT(chain),0.0);
	};
)

~x.play; // creates an instance of the synth and plays it
~b.free; // frees the FFT buffer


// PV_MagFreeze + GUI

s.boot;

~fft_b1 = Buffer.alloc( s, 2048, 1, completionMessage: { "fft_b1 alloced".postln } );

(

SynthDef( \magfreeze,	{ | amp = 0.0, freq = 440, out = 0, rate = 1.0, trig = 0 |
	var chain, env, sig, finalSig;

	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
	sig = SinOsc.ar(LFNoise1.kr(5.2,250,400));
	chain = IFFT( PV_MagFreeze( FFT( ~fft_b1, sig), LFNoise0.kr(rate.linlin(0.0, 1.0, 0.0, 10.0))));
	finalSig = chain * env * amp;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

)

// run the synth
~x = Synth.new(\magfreeze, [\amp, 0.0, \trig, 0]);

(
// The GUI
~window = Window.new("controller", Rect(0, 0, 500, 300));

// volume label
~label1 = StaticText(~window, Rect( 10, 10, 100, 50));
~label1.align = \center;
~label1.background = Color.gray(0.15);
~label1.stringColor = Color.white;
~label1.string = "vol";

// volume control
~knob1 = Knob.new(~window, Rect(10, 65, 100, 100));
~knob1.action_{ |knob|
	~numBox1.value_(knob.value); // gui updates numberbox
	~x.set(\amp, knob.value);
};

// volume level numerical display
~numBox1 = NumberBox(~window, Rect(10, 170, 100, 50));
~numBox1.align = \center;
~numBox1.clipLo = 0.0;
~numBox1.clipHi = 1.0;


// rate label
~label2 = StaticText(~window, Rect( 120, 10, 100, 50));
~label2.align = \center;
~label2.background = Color.gray(0.15);
~label2.stringColor = Color.white;
~label2.string = "rate";

// rate control
~knob2 = Knob.new(~window, Rect(120, 65, 100, 100));
~knob2.action_{ |knob|
	~numBox2.value_(knob.value); // gui updates numberbox
	~x.set(\rate, knob.value);
};

// rate level numerical display
~numBox2 = NumberBox(~window, Rect(120, 170, 100, 50));
~numBox2.align = \center;
~numBox2.clipLo = 0.0;
~numBox2.clipHi = 1.0;


// turn the synth on
~trig1 = Button(~window, Rect(10, 230, 100, 50))
.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.red]
])
.action_({ arg butt;
	~x.set(\trig, butt.value);
});


// bring window to front
~window.front;

)