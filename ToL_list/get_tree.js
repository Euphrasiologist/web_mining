#!/usr/bin/env node

const fs = require('fs')

var data;

try {
   data = require("./newick.json");
} catch ( err ) {
    console.log('error', err);
}

const res = data.newick

fs.writeFile("./tree.newick", res, function(err) {
    if(err) {
        return console.log(err);
    }
    console.log("The file was saved!");
}); 
