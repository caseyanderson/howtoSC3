
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

## SynthDefs & Envelopes

SC has an optimized way of taking in information about `UGens` and their interconnections: `SynthDef`s. A `SynthDef` tells the server how to generate audio and translates that information to byte code.

More specifically, a `SynthDef` is the blueprint that defines a particular instance of a playing `Synth`.

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

The resulting signal is written to a `Bus` (in this case, our speakers) in the `Out.ar` line, which also converts our `Mono` signal to `Stereo`. Note: I reuse the above general structure for all sustaining sounds unless something special/unusual is needed.

To hear the `\sin` we need to create and play an instance of it, which we accomplish using `Synth`. In order to turn this instance of `\sin` off in the future we store it to the variable `x`. After running the `Synth` line we can turn the envelope on by setting the `\trig` argument to `1`. Later we can turn our synth off by setting `\trig` to `0`.


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

The primary difference between the `sustaining` and `deterministic` synth can be seen in the `env` lines. Here we use a different `Env`: `.linen`. Take a moment to compare the two `Env` (`.asr` and `.linen`) by highlighting `Env` and looking it up in the the Help `<Command+D>`.

`.linen` creates Envelopes in a trapezoidal shape. In order to calculate this shape, `.linen` needs information regarding the duration, in seconds, of each segment of its shape. One commonly refers to each segment of the shape as `attack time` (segment 1), `sustain time` (segment 2), and `release time` (segment 3). In other words, if we want our `Synth` to play for 10 seconds we would want to set each of our segments such that the total time adds up to `10`. In the above Synth we accomplish this by using super tiny numbers for `attack` and `release` and setting `sus` to 10.

The benefit here is that the envelope (and associated `Synth`) will clean itself up after it is `done` (this is set by `doneAction: 2` in the `SynthDef`), so we could run the `Synth` line repeatedly to create, for example, 5 instances of `\sin` each with a total duration of (approximately) 10 seconds. Note: I reuse the above general structure for all deterministic sounds unless something special/unusual is needed.

## GUI

SC has a pretty powerful set of Graphical User Interface tools. The most basic, and important, element is `Window`, which a programmer can use to define a rectangular area on the screen capable of displaying other `GUI` elements (hereafter referred to as `Views`).

To start, below is a simple test synth (`\sin`) we will use throughout this discussion. Add `\sin` to the library and then create an instance of it stored at the global variable `x` (`~x`):

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
```

To begin we need to create an instance of `Window`, a task which typically requires the following:

1. name the `Window`
2. give it a location and size (typically with `Rect`)
3. save it to a global variable (`~window` so we can reference it elsewhere)

*For Example*

`~window = Window.new("mixer", Rect(0, 0, 500, 300));`

In the above we define a `Window` named "mixer" and, using `Rect`, gave it a dimension of `500x300` pixels.

Next let's add a label to our `GUI`, follow along:

```python3
~label1 = StaticText(~window, Rect( 10, 10, 100, 50));
~label1.align = \center;
~label1.background = Color.gray(0.15);
~label1.stringColor = Color.white;
~label1.string = "vol";
```

In the above we created a `StaticText` object, which is a view capable of displaying non-editable text. Note that I have stored it to the global variable `~label1`, which provides a hint at its function to anyone reading the code. After creating an instance of `StaticText` we execute four methods on that instance (`~label1`) in an effort to style the label in the manner we want. The function of each `method` is self-explanatory, but if you would like to read the formal SC explanation for each I encourage you to look up `StaticText` in the SC docs [here](http://doc.sccode.org/Classes/StaticText.html).

We still cannot see our `~window`, though. In order to create the `~window` simply execute `~window.front;`. Do so now and you should see a window that looks like this:

![](/assets/mixer-window.png)


Typically one uses a `GUI` to inform users regarding possible interactions. Let's add volume (or amplitude) with the `Knob` view by running the following:

```python3
~knob1 = Knob.new(~window, Rect(10, 65, 100, 100));
~knob1.action_{ |knob|
	knob.value.postln;
};
```

`~window` should now look something like this:

![](/assets/mixer-window-volume.png)

In the code above we create a new instance of `Knob` (with `Knob.new`), assign it to our `GUI` `~window`, and use `Rect` to give it both a location and size in `~window`. We also use the method `.action` to print the value of the `Knob` to the `post` window. `.action` typically connects a view with some other part of SC, like the `post` window or an active `Synth`. Without `.action` we would not know what value the `Knob` has. Try moving the knob around and viewing its value/position in the `post` window.

Okay so here is a bit of an annoying aspect of SC: if we print `GUI` values to the `post` window we are going to have to click back and forth between moving the `Knob` and checking its value in the `post`, as clicking on `~window` makes the `post` window disappear. While this is annoying we can use the `NumberBox` view as a work-around. Follow along:

```python3

// first we update our knob code

~knob1 = Knob.new(~window, Rect(10, 65, 100, 100));
~knob1.action_{ |knob|
	~numBox1.value_(knob.value);
};

// volume level numerical display

~numBox1 = NumberBox(~window, Rect(10, 170, 100, 50));
~numBox1.align = \center;
~numBox1.clipLo = 0.0;
~numBox1.clipHi = 1.0;
```

Running the code above updates our `~window`, which should now look like:

![](/assets/mixer-window-volume-numbox.png)

So now we can see the numerical value of the `Knob` on the `GUI`, hooray!

We still arent actually controllng our running Synth, though. Run the code below to connect the `Knob` to `\sin`, create and add a toggle button (using the `Button` view to `gate` our Synth on/off), and connect the `Button` to our Synth:
connect the `GUI` view `knob` to our `SynthDef`

```python 3
// volume control

~knob1 = Knob.new(~window, Rect(10, 65, 100, 100));
~knob1.action_{ |knob|
	~x.set(\amp, knob.value);
	~numBox1.value_(knob.value); // gui updates numberbox
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
```

Which should result in the following change to `~window`:

![](/assets/mixer-window-volume-numbox-trig-sin.png)

Try turning the Synth on/off and changing its volume by interacting with the `GUI`.

## Example GUI

