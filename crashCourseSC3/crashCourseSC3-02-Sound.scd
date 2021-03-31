/*

SuperCollider 3.0 Crash Course

Casey Anderson, 2021

Download SuperCollider from here: https://supercollider.github.io/download

*/


// PT. 2: Making & Controlling Sounds

// UGENS

// Play a sound with a UGen and .play!

{ SinOsc.ar(440, 0.0, 0.5) }.play;

// Check the UGen docs for argument name options, we can rewrite the above

{ | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;




// .set

// If we store the SinOsc from above in a variable like x


x = { | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;

// we can control it using the .set method of Synth

x.set(\freq, 200);
x.set(\freq, 300);

/*
One can .set any argument declared as part of the function once the Synth is running, and can even make changes to multiple arguments simultaneously like
*/

x.set(\freq, 300, \amp, 0.2 );

// To clear the `Synth` from the server one can simply `.free` it

x.free;




// SYNTHDEFS

// Sustaining Synth

SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

x = Synth( \sin, [ \freq, 400, \amp, 0.5]);

x.set(\trig, 1);
x.set(\trig, 0 );


// Deterministic Synth

SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, sus = 1, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.linen( 0.001, sus, 0.001 ), trig, doneAction: 2 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;


Synth( \sin, [ \amp, 0.5, \freq, 400, \trig, 1]);

