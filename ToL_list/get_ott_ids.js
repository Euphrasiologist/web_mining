#!/usr/bin/env node

const fs = require('fs')

var data;

try {
   data = require("./ott_ids.json");
} catch ( err ) {
    console.log('error', err);
}

const res = data.results
                .map(d => d.matches[0])
                .filter(d => d !== undefined) // needed if there is an error...
                .map(d => d.taxon)
                .map(d => d.ott_id)

var file = fs.createWriteStream('ott_ids.txt');
//file.on('error', function(err) { /* error handling */ });
res.forEach(function(v) { file.write(v + '\n'); });
file.end();