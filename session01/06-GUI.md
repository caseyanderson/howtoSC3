## GUI

```python3
s.boot;

// a test synth

(

SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

)

// run the synth

~x = Synth.new(\sin, [\amp, 0.0, \trig, 0, \freq, 220]);


(

// The GUI

~window = Window.new("mixer", Rect(0, 0, 500, 300));


// label

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


// turn the synth on

~trig1 = Button(~window, Rect(10, 230, 100, 50))
.states_([
	["ON", Color.black, Color.gray],
	["OFF", Color.black, Color.red]
])
.action_({ arg butt;
	~x.set(\trig, butt.value);
});


// bring window to front

~window.front;

)
```
