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

## Additive Synthesis

Additive Synthesis is a general term that refers to the technique of playing more than one sound simultaneously to create a more complex sound. This is also typically referred to as "summing" signals.

*For Example*

```python3
{ SinOsc.ar( 440, 0.0, 0.5 ) + PinkNoise.ar( 0.1 ) + Crackle.ar( 1.5, 0.4 ) + LFTri.ar( 200, 0.0, 0.2 )}.play;
```

Be careful with `Crackle`, it explodes easily (and this especially sucks if you are monitoring SC via headphones).
