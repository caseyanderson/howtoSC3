### FFT

The Fast Fourier Transform (often abbreviated as FFT) is an important technique in computer music. It provides an efficient way to transform between teh time domain (amplitude-time waveforms) and the frequency domain (spectrum, or the phase and energy of component frequencies).

### FFT in SC

SC has a variety of `UGens` which are used to operate on FFT data. Most of them are prepended with `PV`, or `Phase Vocoder`. An abstract model for processing FFT data in SC looks like this: `input -> FFT -> PV_UGen1 ... PV_UGenN... -> IFFT -> output`.

Or, more specifically:

```python3
// does nothing, just represents the signal flow for an input

~b = Buffer.alloc(s,1024);

~x = (
{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in); // The FFT object takes two inputs: a data Buffer and an input signal
	[IFFT(chain),in]; // note that we did not process the signal in the previous line, therefore the input and output will sound identical

};
)

~x.play;
~b.free; // frees the FFT buffer
```

Below we process the input with a `Phase Vocoder Ugen`:

```python3
// processes input with PV_BrickWall

~b = Buffer.alloc(s,1024);

~x = (
	{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in);
	chain = PV_BrickWall(chain, Line.kr(-1,1,10)); // Line.kr will sweep from -1 to 1 in 10 seconds
	Pan2.ar(IFFT(chain),0.0); // Pan2 takes a Mono signal and spreads it across the Stereo field. Here we set the signal to "center" i.e. 0.0
	};
)

~x.play; // creates an instance of the synth and plays it
~b.free; // frees the FFT buffer
```

### PV_MagFreeze + GUI

```python3
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
```
