/*
how to sc3

day 2

SynthDefs and Envelopes

*/

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
s.scope;


// Deterministic Synth

SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, sus = 1, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.linen( 0.001, sus, 0.001 ), trig, doneAction: 2 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;


Synth( \sin, [ \amp, 0.5, \freq, 400, \trig, 1]);
