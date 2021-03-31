/*
how to sc3

day 2

UGens

*/

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
        