#!/usr/bin/env node

const fs = require('fs')

const ecoflora = fs.readFile("./ecoflora_phy.txt", 'utf8', function(err, ecoflora) {
    if(err) console.log('error', err);

    // get rid of no data, and references
    // split on colons and commas
    const ecoflora2 = ecoflora
            .split("\n")
            .filter(d => d !== "No data found.")
            .map(d => d.split(/:|, /))
            .filter(d => d[0] !== "Reference ")
            // get rid of
            .map(d => d.map(d => d.trim()))

    var finaldata = [];
    for (let i = 0; i < ecoflora2.length; i++) {
        finaldata.push({
        species: ecoflora2[i][1],
        family: ecoflora2[i][3],
        plant: ecoflora2[i][5],
        plantPart: ecoflora2[i][7],
        noHosts: ecoflora2[i][9],
        hostType: ecoflora2[i][11],
        impact: ecoflora2[i][13]
        });
    }

    fs.writeFile('ecoflora_phyto.json', JSON.stringify(finaldata), function(err, result) {
        if(err) console.log('error', err)
      })

})