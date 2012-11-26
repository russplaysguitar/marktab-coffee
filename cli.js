#!/usr/bin/env node

// dependencies
var program = require('commander');
var fs = require('fs');
var CoffeeScript = require('coffee-script');

// get marktab.coffee from file and evaluate it
var mt_coffee = fs.readFileSync('src/marktab.coffee', 'utf-8');
var Marktab = CoffeeScript.eval(mt_coffee);

// instantiate marktab
var marktab = new Marktab();

// command-line handling via commander.js
program
  .version('0.0.1')
  .command('*')
  .action(function(filename){
    // console.log('Loading: ' + filename);
    var data = fs.readFileSync(filename, 'utf-8');
    // console.log(data);
    marktab.parse(data);
    console.log(marktab.generateTab());    
  });
program.parse(process.argv);

// handle missing filename
if (program.args.length === 0) {
  process.stderr.write('Error: No filename specified.\n');
  process.exit(1);
}
