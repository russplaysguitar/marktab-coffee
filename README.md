# marktab-coffee
[![Build Status](https://travis-ci.org/russplaysguitar/marktab-coffee.png)](https://travis-ci.org/russplaysguitar/marktab-coffee)

### Overview
A [MarkTab](https://github.com/cknadler/marktab) parser written in CoffeeScript. 

Not 100% functional yet.

Note: This is a different parser implementation than the [original](https://github.com/cknadler/marktab).

### What is Marktab?

Marktab is a concise guitar tab syntax in the spirit of Markdown, originally concieved by [cknadler](https://github.com/cknadler/).

### Installation

Marktab-coffee runs in a web browser (or in a headless browser such as [phantomjs](http://phantomjs.org/)). 

### Usage

In CoffeeScript...

    # initialize marktab-coffee
    marktab = new Marktab

    # input some marktabs
    marktab.parse "3:5 4:5 7 5 3:5 4:5 7 5"
    
    # generate tabs
    tabs = marktab.generateTab
    
    # output:
    e|-----------------|
	B|-----------------|
	G|-5-------5-------|
	D|---5-7-5---5-7-5-|
	A|-----------------|
	E|-----------------|

    
    
See the specs in the `tests` directory for more examples.

### Tests
Tests must be run from a web server context, not a file:// url. Alternatively, you may use [gruntjs](http://gruntjs.com/) to compile and run the tests using the `grunt` command.