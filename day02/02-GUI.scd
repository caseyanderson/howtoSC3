/*
how to sc3

day 2

A Basic GUI

*/

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
