# markdown-coffee
[![Build Status](https://travis-ci.org/russplaysguitar/marktab-coffee.png)](https://travis-ci.org/russplaysguitar/marktab-coffee)

### Overview
A [MarkTab](https://github.com/cknadler/marktab) parser written in CoffeeScript. Note: This is a different parser implementation than the original.

Not currently functional.

### Tests
Tests must be run from a web server context, not a file:// url.

### Concept
Converts marktab to json in this format:

	{
		1:[],
		2:[],
		3:[],
		4:[],
		5:[],
		6:[]
	}

Then generates tab from the json.