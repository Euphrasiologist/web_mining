#!/usr/bin/env bash

# get unique names from the dataset
# ping the open tree of life API to get the "ott_ids"
# then get a newick tree from those ID's


### get the ott_ids from the open tree of life API ###

awk -F, '{print $1}' ./data.txt | tail -n +2 > ./species.txt

awk '{ print "\""$0"\""}' ./species.txt > ./quoted_species.txt

sort ./quoted_species.txt | uniq > ./sorted_quoted_species.txt

names=$(awk '{print}' ORS=', ' ./sorted_quoted_species.txt)

names2=$(echo $names | sed 's/, *$//g')

command="curl -X POST https://api.opentreeoflife.org/v3/tnrs/match_names -H \"content-type:application/json\" -d '{\"names\":[$names2]}'"

echo $command | bash > ./ott_ids.json

node get_ott_ids.js

rm ./species.txt ./quoted_species.txt ./sorted_quoted_species.txt

### generate the tree ###

# get rid of apparently empty nodes which elicit a 400 response?
# bit irritating...

awk '!/3411|819588/' ./ott_ids.txt > ./ott_test.txt

ott_ids=$(awk '{print}' ORS=', ' ./ott_test.txt)

ott_ids2=$(echo $ott_ids | sed 's/, *$//g')

tree_command="curl -X POST https://api.opentreeoflife.org/v3/tree_of_life/induced_subtree -H \"content-type:application/json\" -d '{\"ott_ids\":[$ott_ids2]}'"

echo $tree_command | bash > ./newick.json

node ./get_tree.js
