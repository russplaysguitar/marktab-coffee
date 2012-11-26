#!/usr/bin/env node

/**
 * Module dependencies.
 */

var program = require('commander');
var fs = require('fs');
var m = require('./bin/js/marktab');

var marktab = new m.Marktab();

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

if (program.args.length === 0) {
  process.stderr.write('Error: No filename specified.\n');
  process.exit(1);
}
