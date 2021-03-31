/*

SuperCollider 3.0 Crash Course

Casey Anderson, 2021

Download SuperCollider from here: https://supercollider.github.io/download

*/


// PT 1: INTRO

// STARTING THE SERVER

/*

Supercollider is actually two applications: a language interpreter and one (or more) synthesis servers. All communication between the language and the server is done via OpenSoundControl

*/

/*

In order to make sound the server must be running. Type the following into a new window (Command+N makes a new window) and then hit Shift+Enter on the same line to execute the code

*/

s.boot;

/*

One can quit the server by executing the following code

*/

s.quit;

/* Boot the Server again */

s.boot;




// VARIABLES

/*

SuperCollider has variables or named places to store information

*/

x = 5;

x;

/*

Single letter variables are global by default. If we need to use more descriptive variable names we use parentheses

*/

(
var data;

data = 5;

("current data is" + data).postln;

)




// FUNCTIONS

/*

Functions in SC are denoted by curly brackets. Anything between { } is a function.

*/

f = { "hello world!".postln; };
f.value;

/*

The first line of code stores the function at f, the second line returns the value (prints the message "hello world!" to the post window) associated with the function. value is short for evaluate. If one needs to use a function .value it

*/




// ARGUMENTS

/*

Arguments allow one to pass values to a function

*/

(
f = { |a, b|
	a + b;
	};
)

f.value(5, 3);
f.value(10, 20);
f.value(10949, 109873);

/*

One can also use variables in functions

*/

(
f = { |a, b|
	var randomNumber, sum;

	randomNumber = 1.50.linrand;
	sum = a + b;
	randomNumber * sum;

};
)

f.value(5, 3);
f.value(10, 20);
f.value(10949, 109873);




// ARRAYS

/*
Data can be collected in Arrays, which have a fixed maximum size

*/
(
x = Array.fill(5, {arg i;
  i.rand});
)

/*

If we try to add a sixth item we will get an error, as the Array at x only has 5 positions

*/

x.put(5, "hello");




// LISTS

/*
SuperCollider has a separate Class for cases in which a collection must be dynamically expanded
*/

(
x = List.fill(5, {arg i;
  i.rand});
)

x.add("hello");

x;




// LOOPS

/*

Though SuperCollider has all the standard loops one would expect from a programming language, I want to highlight do loops here

*/

5.do({ arg item; item.postln }); // iterates from zero to four

x.do({ arg item; item.postln }); // prints each item from above


// to summarize, here is a little example that actually makes sound!

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