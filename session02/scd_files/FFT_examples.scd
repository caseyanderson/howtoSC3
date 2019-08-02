
// does nothing, just represents the processing flow

~b = Buffer.alloc(s,1024);

~x = (
	{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in);
	[IFFT(chain),in];
	};
)

~x.play;
~b.free; // frees the FFT buffer


// processes input with PV_BrickWall

~b = Buffer.alloc(s,1024);

~x = (
	{ var in, chain;

	in = WhiteNoise.ar(0.5);
	chain = FFT(~b, in);
	chain = PV_BrickWall(chain, Line.kr(-1,1,10));
	Pan2.ar(IFFT(chain),0.0);
	};
)

~x.play; // creates an instance of the synth and plays it
~b.free; // frees the FFT buffer