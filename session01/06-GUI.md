## GUI

SC has a pretty powerful set of Graphical User Interface tools. The most basic, and most important, element is `Window`, which a programmer can use to define a rectangular area on the screen capable of displaying other `GUI` elements (hereafter referred to as `Views`) elements (hereafter referred to as `Views`).

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
2. give it dimensions (typically with `Rect`)
3. save it to a global variable (`~window` so we can reference it elsewhere)

*For Example*
`~window = Window.new("mixer", Rect(0, 0, 500, 300));`

In the above we define a `Window` named "mixer" and, using `Rect`, gave it a dimension of `500x300` pixels.

Next let's add a label to our `GUI`:

```python3
~label1 = StaticText(~window, Rect( 10, 10, 100, 50));
~label1.align = \center;
~label1.background = Color.gray(0.15);
~label1.stringColor = Color.white;
~label1.string = "vol";
```

In the above we created a `StaticText` object, which is a view capable of displaying non-editable text. Note that I have stored it to the global variable `~label1`, which provides a hint at its function to anyone reading the code. After creating an instance of `StaticText` we execute four methods on that instance (`~label1`) in an effort to style the label in the manner we want. The function of each `method` is pretty self-explanatory, but if you would like to read the formal SC explanation for each I encourage you to look up `StaticText` in the SC docs [here](http://doc.sccode.org/Classes/StaticText.html).

We still cannot see our `~window`, though. In order to create the `~window`, and to see any changes made to it, simple execute: `~window.front;`. Do so now and you should see a window that looks like this:

![](/assets/mixer-window.png)

Typically one uses a `GUI` to inform users regarding possible interactions. Let's add volume (or amplitude) with the `Knob` view by running the following:

```python3
~knob1 = Knob.new(~window, Rect(10, 65, 100, 100));
~knob1.action_{ |knob|
	~x.set(\amp, knob.value);
};
```

`~window` should now look something like this:

![](assets/mixer-window-volume.png)

In the code above we create a new instance of `Knob` (with `Knob.new`), assign it to our `GUI` `~window`, and use `Rect` to give it both a location and size in `~window`. We also use the method `.action` to print the value of the `Knob` to the `post` window. Without this last step we would not know what value the knob has. Try moving the knob around and viewing its value / position in the post window.




connect the `GUI` view `knob` to our `SynthDef`


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
