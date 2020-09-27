#!/usr/bin/env node

const $ = require('cheerio');
const fs = require('fs')

const html = fs.readFile("./ukmoths@1.html", 'utf8', function(err, html) {
  if(err) console.log('error', err);

  // HELPER FUNCTIONS
  // get the slice index of an array
  function getSliceIndex(array) {
    const chunks = [];
  
    for (var i = 0; i < array.length; i++) {
      if (array[i] === true) {
        chunks.push(i);
      }
    }
    return chunks;
  }
  // create the nested array where each family is in its own array
function sliceArray(array, sliceIndexArray) {
  var res = [],
    temp;
  // loop through index
  for (var i = 0; i < sliceIndexArray.length; i++) {
    temp = array.slice(sliceIndexArray[i], sliceIndexArray[i + 1]);
    res.push(temp);
  }
  return res;
}
function nestArray(array) {
  // arrays to push families and subfamilies into
  var fam_arr = [],
    subfam_arr = [];

  // go through the array
  // if there are subfamilies
  for (let i = 0; i < array.length; i++) {
    if (array[i][0].includes("inae")) {
      subfam_arr.push(array[i][0]);
      subfam_arr.push(array[i + 1]);
    }
  }
  // get the family, loop probs unneccesary
  for (let i = 0; i < array.length; i++) {
    if (array[i][0].includes("idae")) {
      fam_arr.push(array[i][0]);
    } else if (fam_arr.length) {
      subfam_arr.push(array[i]);
    }
  }
  // https://stackoverflow.com/questions/8495687/split-array-into-chunks
  var subfam_arri = subfam_arr.reduce((resultArray, item, index) => {
    const chunkIndex = Math.floor(index / 2);

    if (!resultArray[chunkIndex]) {
      resultArray[chunkIndex] = []; // start a new chunk
    }

    resultArray[chunkIndex].push(item);

    return resultArray;
  }, []);

  return fam_arr.concat(subfam_arri);
}
  
  // get the species list class length to check it's correct
  // join the entire species list into a giant string
    const text_string =  $('.specieslist', html).contents().map(function() {
      return $(this).text()+' ';
  }).get().join('')

// split the long text string on families and subfamilies
const family_split = new RegExp("([A-Z]{1}[a-z]*idae|[A-Z]{1}[a-z]*inae)");
const split_text_string = text_string
  .split(family_split)
  .filter(d => d !== " ");

// now the hard work begins.
// remove spaces at beginning and end of string
const arr = split_text_string
  .map(d => d.replace(/^ /, ""))
  .map(d => d.replace(/ $/, ""));

// split the species on ID's and species
// this removes ID's and keeps common names.
const regex1 = new RegExp("[0-9]*\\.[0-9]* BF[0-9]*");
// split strings on regex to get names
const arr2 = arr.map(d =>
  d.split(regex1).filter(d => (d !== " ") & (d !== ""))
);

// remove ^b(space), ^a(space), ^(space), (space)$, (space)Appendix(space)A(space)$
// TODO: might need more tidying here
const arr3 = arr2
  .map(d => d.map(d => d.replace(/^ /, "")))
  .map(d => d.map(d => d.replace(/^ /, "")))
  .map(d => d.map(d => d.replace(/^a /, "")))
  .map(d => d.map(d => d.replace(/^b /, "")))
  .map(d => d.map(d => d.replace(/^c /, "")))
  .map(d => d.map(d => d.replace(/ $/, "")))
  .map(d => d.map(d => d.replace(/ Appendix A$/, "")))
  .filter(d => d.length > 0);

// boolean array of length arr.length, which tells us where the families are
const test_arr1 = arr3.map(d => d.map(d => d.endsWith("idae")));
const test_arr = test_arr1.map(d => d.every(val => val === true));

// call the function on the test array to get the indices
const test_arr_m = getSliceIndex(test_arr);

// create the nested array where each family is in its own array
const familyArray = sliceArray(arr3, test_arr_m);

// call nestArray to create a nested array of:
// family -> subfamily -> species
const familyArrayNest = familyArray.map(d => nestArray(d));

// clean up the array, and remove the migrant species (after row 71)
const UKMothList = familyArrayNest
  .map(d => d.filter((d, i) => Array.isArray(d[0]) || i === 0))
  .slice(0, 71);

// turn array to object for ease of downstream processing
var famsubfamsp = [];
for (let i = 0; i < UKMothList.length; i++) {
  for (let j = 1; j < UKMothList[i].length; j++) {
    famsubfamsp.push({
      family: UKMothList[i][0],
      subfamily: UKMothList[i][j][0][0].endsWith("inae")
        ? UKMothList[i][j][0].toString()
        : "-",
      species:
        UKMothList[i].length === 2
          ? UKMothList[i][j].length === 2
            ? UKMothList[i][j][1]
            : UKMothList[i][j][0]
          : UKMothList[i][j][1]
    });
  }
}

// prepare the final data frame
var finaldata = [];

// small function to match a unique family
// to family in the dataset to merge species
function matchFamily(currentFamily) {
  var species = [];
  for (var i = 0; i < famsubfamsp.length; i++) {
    if (famsubfamsp[i].family === currentFamily) {
      species.push(famsubfamsp[i].species);
    }
  }
  return species;
}

var families = [...new Set(famsubfamsp.map(item => item.family))];

for (let i = 0; i < families.length; i++) {
  finaldata.push({
    family: families[i],
    species: matchFamily(families[i])
  });
}

for (let i = 0; i < finaldata.length; i++) {
  if (i < 50) {
    finaldata[i].type = "Micro";
  } else {
    finaldata[i].type = "Macro";
  }
}

fs.writeFile('UKMoths.json', JSON.stringify(finaldata), function(err, result) {
  if(err) console.log('error', err)
})

});

