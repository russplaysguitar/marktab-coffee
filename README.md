# marktab-coffee
[![Build Status](https://travis-ci.org/russplaysguitar/marktab-coffee.png)](https://travis-ci.org/russplaysguitar/marktab-coffee)

### Overview
A [Marktab](https://github.com/cknadler/marktab) parser written in CoffeeScript. See the original Marktab project here: [cknadler/marktab](https://github.com/cknadler/marktab).

### What is Marktab?

Marktab is a concise guitar tab syntax in the spirit of Markdown created by [cknadler](https://github.com/cknadler/). 

### Usage

Basic usage (written in CoffeeScript):

    # initialize marktab-coffee
    marktab = new Marktab

    # input some marktabs
    marktab.parse "6:3 5 5:2 3 5 4:2 4 5 3:2 4 5 2:3 5 1:2 3 5"
    
    # generate tabs
    tabs = marktab.generateTab
    
Output:

	e|----------------------------------------2--3--5--|
	B|----------------------------------3--5-----------|
	G|-------------------------2--4--5-----------------|
	D|----------------2--4--5--------------------------|
	A|-------2--3--5-----------------------------------|
	E|-3--5--------------------------------------------|

See the specs in the `tests` directory for more examples.

### Demo
[View the in-browser demo](http://russplaysguitar.github.com/marktab-coffee/)

### Syntax

Basic Marktab syntax is simply: `string:fret`. For example, `6:5` equates to a note on the 5th fret of the 6th string. 

See the full syntax specificaton here: [cknadler's marktab grammer page](https://github.com/cknadler/marktab/blob/master/docs/grammar.md)

### Dependencies

Marktab-coffee's only dependency is [Underscore.js](http://underscorejs.org/) >= 1.4.2

### Installation

Marktab-coffee runs in a web browser (or in a headless browser such as [phantomjs](http://phantomjs.org/)). There are a few ways that you can "install" it. 

Installation options:

a. Include coffee-script.js and underscore.js before you include marktab-coffee. Simple.

b. Use `npm install` to install the grunt.js dependencies, then run `grunt` to compile and run tests. Great for TDD.

c. Use the command-line CoffeeScript compiler to compile marktab-coffee to Javascript, then include underscore.js on the page before marktab.js. Should perform better than dynamically compiling the CoffeeScript.

### Tests
Tests must be run from a web server context, not a file:// url. Alternatively, you may use [gruntjs](http://gruntjs.com/) to compile and run the tests using the `grunt` command.