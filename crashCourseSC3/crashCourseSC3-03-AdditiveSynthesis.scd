/*

SuperCollider 3.0 Crash Course

Casey Anderson, 2021

Download SuperCollider from here: https://supercollider.github.io/download

*/

// PT. 3: GUIs & Additive Synthesis

// THE GUI

(
var label, number, trig, vol, volNum, windowWidth = 125, windowHeight = 250;

~window = Window.new("instrument", Rect(
	Window.screenBounds.width/2 - (windowWidth/2),
    Window.screenBounds.height/2 - (windowHeight/2),
    windowWidth,
    windowHeight
));

// label
label = StaticText(~window, Rect(10, 10, 100, 25));
label.string = "vol"; // short for volume
label.align = \center;
label.background = Color.gray(0.15);
label.stringColor = Color.white;

// knob (controls volume)
vol = Knob.new(~window, Rect(10, 50, 100, 100));
vol.mode_(\vert);
vol.action_{|knob|
	// knob.value.postln;
	volNum.value_(knob.value);
};


// number box (displays knob value)
volNum = NumberBox(~window, Rect(10, 160, 100, 25));
volNum.align = \center;
volNum.clipLo = 0.0;
volNum.clipHi = 1.0;


// button (starts our sound)
trig = Button(~window, Rect(10, 195, 100, 50));
trig.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.red]
]);

trig.action_({|butt|
	butt.value.postln;
});

~window.front;
)

// An Example Sustaining Synth

SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

x = Synth( \sin, [ \freq, 400, \amp, 0.5 ]);

x.set(\trig, 1); // turn on
x.set(\trig, 0); // turn off

/* Follow along as I show you how to

1. connect the GUI to the Synth
2. Use the Mix UGen to experiment with Additive Synthesis, or the technique of using simpler sounds together to create a more complex sound