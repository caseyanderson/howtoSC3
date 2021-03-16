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
