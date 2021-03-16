
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


## Arrays, Lists, and Dictionaries

Data can be collected in `Arrays`, which have a fixed maximum size

*For Example*

```python3
x = Array.fill(5, {arg i;
  i.rand});
```

If we try to add a *sixth* item we will get an error, as the `Array` at `x` only has 5 positions

*For Example*

```python3
x.put(5, "hello");
```

SuperCollider has a separate `Class` for cases in which a collection must be dynamically expanded

*For Example*

```python3
x = List.fill(5, {arg i;
  i.rand});

x.add("hello");

x;
```

Here is a super lazy way to use a `List` to end up with a fixed value `Array`, btw

```python3
x = List.new();
x.add(0.10.rand); // run this a bunch of times

y = x.free.array;

y; // here's our array!
```


# Loops

Though SuperCollider has all the standard loops one would expect from a programming language, I want to highlight `do` loops here

*For Example*

```python3
5.do({ arg item; item.postln }); // iterates from zero to four
```

And also

```python3
x.do({ arg item; item.postln }); // prints each item from above
```

And here is a little example with sound

```python3
/*

generate a random size list of random numbers,
make a sine tone for each of those numbers,
calculate frequency of tone from random number values

*/

(
var randomNum;

x = List.new(); // a list object

randomNum = rrand(2, 8); // get a random integer between 2 and 8

randomNum.do({ |item|
  x.add(0.10.rand); // random floats between 0 and 10
});

y = x.free.array; // get rid of the List object

y.do({ |item, test|
  var amp = 0.1, freq = 440;

  freq = freq + (freq * item);
  //  freq.postln;
  {SinOsc.ar( freq + (freq * item), 0.0, amp)}.play;

});
)
```
