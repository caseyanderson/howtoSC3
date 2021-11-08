
## Download

Go [here](https://supercollider.github.io/download.html) to download the `Current Version` of SuperCollider 3 (3.10.3 as of this writing). Once your download is complete, go ahead and install.

## About

Supercollider is actually two applications: a language interpreter and one (or more) synthesis (we often say synth for short) servers. All communication between the `lang` (short for language) and the `server` is done via [OpenSoundControl](http://opensoundcontrol.org/).

## Starting the server

In order to make sound the server must be running. Type the following into a new window (`Command+N` makes a new window) and then hit `Shift+Enter` on the same line to execute the code:

```python3
s.boot;
```

Here `s` refers to the `localhost` server on your CPU.

`s.boot;` generally results in something like this in the post window:

```python3
Booting server 'localhost' on address 127.0.0.1:57110.
Found 0 LADSPA plugins
Number of Devices: 2
   0 : "Built-in Microph"
   1 : "Built-in Output"

"Built-in Microph" Input Device
   Streams: 1
      0  channels 2

"Built-in Output" Output Device
   Streams: 1
      0  channels 2

SC_AudioDriver: sample rate = 44100.000000, driver's block size = 512
SuperCollider 3 server ready.
Requested notification messages from server 'localhost'
localhost: server process's maxLogins (1) matches with my options.
localhost: keeping clientID (0) as confirmed by server process.
Shared memory server interface initialized
```

One can quit the server by executing the following code:

```python3
s.quit;
```

## Functions

Functions in SC are denoted by curly brackets. Anything between `{ }` is a function.

*For Example*

```python3
f = { "hello world!".postln; };
f.value;
```

The first line of code stores the function at `f`, the second line returns the `value` (prints the message "hello world!" to the post window) associated with the function. `value` is short for `evaluate`. If one needs to **use** a function `.value` it.

## Arguments and Variables within Functions

Arguments allow one to pass values to a function

*For Example*

```python3
(
f = { arg a, b;
    a - b;
};
)
```

The code above stores a function at `f`. This next line evaluates the function (subtracts 3 from 5)

```python3
f.value(5, 3);
```

One can also use variables in functions

*For Example*

```python3
(
f = { arg a, b;
    var firstResult, finalResult;
    firstResult = a + b;
    finalResult = firstResult * 2;
    finalResult;
};
)
```

evaluate the function

```python3
f.value(2, 3);
```

##  Making Sound

Functions are used to make sound in SC. Execute the line below and, when you want it to stop, just type `Command+.`.

```python3
{ SinOsc.ar(440, 0, 0.2) }.play;
```

The code above plays a [Sine Wave](https://en.wikipedia.org/wiki/Sine_wave) with a frequency of 440Hz and an amplitude of 0.2 (amplitude, or what one can think of as volume, is generally kept within the range 0.0 to 1.0 in SC).

SC allows one to plot sounds like this onto a graph with `.plot`. This is useful if your sound is less deterministic than the above or if you need to check why something you are trying to do is inaudible or whatever.

*For Example*

```python3
{ SinOsc.ar(440, 0, 0.2) }.plot;
```

SC also has an oscilloscope method (`.scope`) which will display the changing waveform while playing it:

*For Example*

```python3
{ SinOsc.ar(440, 0, 0.2); }.scope;
```

While `.plot` plots the function over time, and `.scope` shows a real-time plot of the waveform, both of those methods are generally used for testing and not for performance or recording.

<br/>

## .play

`.play` tells the server to start a process. The result of that process depends on the function (code between `{}`)

*For Example*

```python3
{ SinOsc.ar(440, 0, 0.2) }.play;
```

So, `{ ... }` returns a function (which can be killed with `.stop`) while `{ ... }.play` returns a `Synth` object. `Synth` objects do not have a `.stop` method, so one must either `.free` or `.release` them in order to stop the sound.

*For Example*

```python3
x = { SinOsc.ar(440, 0, 0.2) }.play;
//lets wait a moment
x.release;
```

One can call `.scope` on the entire output of the server. Think of this like putting everything that is currently happening in SC through an oscilloscope.

*For Example*

```python3
{ [SinOsc.ar(440, 0, 0.4), LFTri.ar(220, 0.0, 0.2) ] }.play;
s.scope;
```

<br/>

## Ugens

`UGens` are objects capable of producing audio (with the `.ar`, or audio rate, class method) or control signals (with the `.kr`, or control rate, class method).

*For Example*

```python3
(
{ var ampOsc;
    ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
    SinOsc.ar(440, 0, ampOsc);
}.play;
)
```

In the above example, the `SinOsc` `UGen` is used both as control rate (to change the amplitude of the sounding `SinOsc`) and as audio rate (to actually play the `Sine` tone).

Another example that uses Mouse location (both x and y axes) for frequency and amplitude:

```python3
{ SinOsc.ar(MouseY.kr( 50, 2000), 0.0, MouseX.kr( 0.0,1.0 )); }.scope;
```

<br/>


## Controlling Synths

One can declare arguments for a function in one of two manners:

1. `arg nameofargument1, nameofargument2;`
2. `|nameofargument1, nameofargument2|`

While this may sound esoteric, it's important to understand that many aspects of Supercollider, like `arguments`, allow a programmer multiple stylistic options in terms of how they write their code.


### Arguments in UGens

There are three strategic opportunities provided by deliberate use of `arguments` in SC:

1. arguments provide helpful labels to different parts of a `UGen` (a kind of memory aid)
2. arguments set default values for a `UGen` (example: every time I run this Synth the volume starts at half its total signal strength [0.5])
3. arguments reserve a way to change a particular part of a `UGen` once it is running (example: I start my `Sine` tone playing a frequency of 440Hz but will change it to 200Hz later)

In general I think of `arguments` as things I need to control or change in `UGens` when I am using them.


### Relevant Argument Names

In order to come up with relevant `argument` names one often references the `Documentation`. Go to the help file for `SinOsc` as an example (note: to access the help you select the reserved word and hit `Command+D`) and scroll down to the section labeled `Class Methods`. It should look like this:

<br/><img src="/assets/class_methods_sinosc_docs.png" height="144" width="548">

The first argument in `SinOsc` is `frequency`, the second `phase`, and the third `mul` (short for `multiply`).

Using this information one can rewrite this:

```python3
{ SinOsc.ar(440, 0.0, 0.5) }.play;
```

to:

```python3
{ | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;
```

Note: I prefer to use `amp` instead of something like `mul` or `multiply`.


### .set

If we store the `SinOsc` from above in a variable like `x`

```python3
x = { | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;
```

we can control it using the `.set` method of `Synth`

```python3
x.set(\freq, 200);
```

One can `.set` any `argument` declared as part of the function once the Synth is running, and can even make changes to multiple `arguments` simultaneously like so:

```python3
x.set(\freq, 300, \amp, 0.2 );
```

To clear the `Synth` from the server one can simply `.free` it:

```python3
x.free;
```


## Controlling Synths

`Arguments` allow one to pass information to a function when the function is evaluated.

*For Example*
```python3
f = { arg a, b;
    a - b;
};
```

In the above function we declare two `arguments`: `a` and `b`. This enables us to pass in two values every time we evaluate the function like so:

```python3
f.value(3,2);
```

We can run the above line repeatedly with different values and expect similar results: the first argument will be subtracted by the second one.

There is a syntax shortcut for writing arguments which we can use to rewrite our function above to:

```python3
f = { | a, b|
    a - b;
};
```

So one can declare arguments for a function in one of two manners:

1. `arg nameofargument1, nameofargument2;`
2. `|nameofargument1, nameofargument2|`

While this may sound esoteric, it's important to understand that many aspects of Supercollider, like `arguments`, allow a programmer multiple stylistic options in terms of how they write their code.


### Arguments in UGens

There are three strategic opportunities provided by deliberate use of `arguments` in SC:

1. arguments provide helpful labels to different parts of a `UGen` (a kind of memory aid)
2. arguments set default values for a `UGen` (example: every time I run this Synth the volume starts at half its total signal strength [0.5])
3. arguments reserve a way to change a particular part of a `UGen` once it is running (example: I start my `Sine` tone playing a frequency of 440Hz but will change it to 200Hz later)

In general I think of `arguments` as things I need to control or change in `UGens` when I am using them.


### Relevant Argument Names

In order to come up with relevant `argument` names one often references the `Documentation`. Go to the help file for `SinOsc` as an example (note: to access the help you select the reserved word and hit `Command+D`) and scroll down to the section labeled `Class Methods`. It should look like this:

<br/><img src="/assets/class_methods_sinosc_docs.png" height="144" width="548">

The first argument in `SinOsc` is `frequency`, the second `phase`, and the third `mul` (short for `multiply`).

Using this information one can rewrite this:

```python3
{ SinOsc.ar(440, 0.0, 0.5) }.play;
```

to:

```python3
{ | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;
```

Note: I prefer to use `amp` instead of something like `mul` or `multiply`.


### .set

If we store the `SinOsc` from above in a variable like `x`

```python3
x = { | freq = 440, phase = 0.0, amp = 0.5| SinOsc.ar( freq, phase, amp) }.play;
```

we can control it using the `.set` method of `Synth`

```python3
x.set(\freq, 200);
```

One can `.set` any `argument` declared as part of the function once the Synth is running, and can even make changes to multiple `arguments` simultaneously like so:

```python3
x.set(\freq, 300, \amp, 0.2 );
```

To clear the `Synth` from the server one can simply `.free` it:

```python3
x.free;
```

## SynthDefs & Envelopes

SC has an optimized way of taking in information about `UGens` and their interconnections: `SynthDef`s. A `SynthDef` tells the server how to generate audio and translates that information to byte code.

More specifically, a `SynthDef` is the blueprint that defines a particular instance of a playing `Synth`. Or, if you prefer, a `SynthDef` is a cake recipe and a `Synth` is the cake you end up with by following the recipe.

What follows are two versions of the same instrument: one that sustains until receiving an off message and another which has a specific duration.

### Sustaining Synth

```python3
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
```

Here we define a `SynthDef` named `\sin` with a `sustaining` envelope, or an envelope that plays continuously until receiving an off message. Variables are used to organize the code into chunks: `env`, short for envelope, is the portion of our code that allows us to toggle the sound on and off; `sig`, short for signal, is the portion of our code that defines what the sound is.  Multiplying the `env` by the `sig` is what results in the "on/off" functionality above and occurs in the `finalSig` line.

The resulting signal is written to a `Bus` (in this case, our speakers) in the `Out.ar` line, which also converts our `Mono` signal to `Stereo`. We will revisit this line in the future so for now don't spend too much time paying attention to it. Note: I reuse the above general structure for all sustaining sounds unless something special/unusual is needed.

To hear the `\sin` we need to create and play an instance of it, which we accomplish using `Synth`. In order to turn this instance of `\sin` off in the future we store it to the variable `x`. After running the `Synth` line, we can turn the envelope on by setting the `\trig` argument to `1`. Later we can turn our synth off by setting `\trig` to `0`. Think of these two lines as a metaphorical toggle button for `\sin`.


### Deterministic Synth

```python3
SynthDef( \sin,	{ | amp = 0.0, freq = 440, out = 0, sus = 1, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.linen( 0.001, sus, 0.001 ), trig, doneAction: 2 );
	sig = SinOsc.ar( freq, 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;


Synth( \sin, [ \amp, 0.5, \freq, 400, \trig, 1]);

```

The primary difference between the `sustaining` and `deterministic` synth can be seen in their respective `env` lines. Here we use a different `Env`: `.linen`. Take a moment to compare the two `Env` (`.asr` and `.linen`) by highlighting `Env` and looking it up in the the Help `<Command+D>`.

`.linen` creates Envelopes in a trapezoidal shape. In order to calculate this shape, `.linen` needs information regarding the duration, in seconds, of each segment of its shape. One commonly refers to each segment of the shape as `attack time` (segment 1), `sustain time` (segment 2), and `release time` (segment 3). In other words, if we want our `Synth` to play for 10 seconds we would want to set each of our segments such that the total time adds up to `10`. In the above Synth we accomplish this by using super tiny numbers for `attack` and `release` and setting `sus` to 10.

The benefit here is that the envelope (and associated `Synth`) will clean itself up after it is `done` (this is set by `doneAction: 2` in the `SynthDef`), so we could run the `Synth` line repeatedly to create, for example, 5 instances of `\sin` each with a total duration of (approximately) 10 seconds. Note: I reuse the above general structure for all deterministic sounds unless something special/unusual is needed.
