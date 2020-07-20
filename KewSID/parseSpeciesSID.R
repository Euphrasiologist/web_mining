library(data.table)

# mimic readLines
SID <- fread(text = "./speciesSIDAll.txt", sep = NULL)

#remove blank lines
SID <- SID[`Seed Information Database` != ""]

# change to factor for next step
SID[, `Seed Information Database` := as.factor(`Seed Information Database`)]
# which lines contain new record, as we split on that
indexes <- which(SID$`Seed Information Database` %in% "NEW RECORD")

# the lengths of each of the records
xxx <- indexes - c(0, indexes)
xxx <- xxx[-length(xxx)]
# add these to the data table
SID[, factor := as.factor(c(rep(1:length(xxx), xxx)))]
# split on the factor to isolate each record in a list
splitSID <- split(SID, SID$factor)
# change the resulting data back to character vector, otherwise there's over a million factor levels
splitSID <- lapply(splitSID, function(x) as.character(x$`Seed Information Database`))

# the main function which ID's the rows which contain the data of interest
# then extracts the information and puts into a new data table, which is 
# bound at the end. Takes a minute or so, and generates > 50,000 species records
# I omitted the morphological data because I couldn't be bothered...

applyParse <- lapply(splitSID, function(test){
# parse rows
# global
Order <- grep("^APG Order: ", test)
Family <- grep("^APG Family: ", test)
KFamily <- grep("^Kew Family: ", test)
Genus <- grep("^Genus: ", test)
Species <- grep("^Species Epithet: ", test)
Author <- grep("^Species Author: ", test)
Synonyms <- grep("^Synonymns: ", test)
LifeForm <- grep("^Form: ", test)
SubspRank <- grep("^Subspecies Rank: ", test)
SubspEpithet <- grep("^Subspecies Epiphet: ", test)

# storage behaviours, any others?
StorageBehaviour <- grep("^Storage Behaviour: ", test)
StorageConditions <- grep("^Storage Conditions: ", test)
SpeciesDistribution <- grep("^Species Distribution: ", test)

AverageSeedWeight <- grep("^Average 1000 Seed Weight\\(g\\): ", test)
# ignore details of component seed weights
# will have multiple matches
PercentGermination <- grep("[0-9]* % germination \\(seeds sown: [0-9]*\\); ", test)

# dispersal
# maybe best to grep "^Seed Dispersal$" then, it's the next row
SeedDisp <- grep("^Seed Dispersal$", test) + 1
# oil content
OilContent <- grep("^Average of Oil Content \\(%\\): ", test)
# protein content
ProteinContent <- grep("^Average of Protein Content \\(%\\):", test)

## might add at some point...

# seed morphological data
# fruit data
#FruitSizeLength <- grep("^Fruit size length \\(mm\\):", test)
#FruitSizeWidth <- grep("^Fruit size width \\(mm\\):", test)
#FruitSizeThick <- grep("^Fruit size thick \\(mm\\):", test)
#FruitType <- grep("^Fruit type: ", test)
#Diaspore <- grep("^Diaspore: ", test)
#Protection <- grep("^Mechanical protection of seed: ", test)
#Dehiscent <- grep("^Fruit dehiscent: ", test)

# diaspore data
#DiasporeLength <- grep("^Diaspore size length \\(mm\\): ", test)
#DiasporeThick <- grep("^Diaspore size thickness \\(mm\\): ", test)
#DiasporeWidth <- grep("^Diaspore size width \\(mm\\): ", test)
#DiasporeSize <- grep("^Remarks on diaspore size: ", test)
#DiasporeColour <- grep("^Diaspore colour: ", test)
#DiasporeShape <- grep("^Diaspore shape: ", test)
#DiasporeSurface <- grep("^Diaspore surface: ", test)
#DiasporeDispersal <- grep("^Dispersal aids: ", test)

# internal morphology

#SeedConfig <- grep("^Seed configuration: ", test)
#EmbryoType <- grep("^Embryo type: ", test)
#EmbryoSize <- grep("^Relative size embryo: ", test)
#Perisperm <- grep("^Perisperm present: ", test)
#EndospermRuminate <- grep("^Endosperm ruminate: ", test)
#EmbryoColour <- grep("^Embryo colour: ", test)

## Salt tolerance line contains:
# plant type, Max dS/m: , Photosynthetic Pathway: 
SaltTolandPhot <- grep("^Plant Type: ", test)

# turn into data table > csv
data.table(Order = gsub("APG Order: " ,"", test[Order]),
           Family = gsub("APG Family: " ,"", test[Family]),
           KewFamily = gsub("Kew Family: " ,"", test[KFamily]),
           Genus = gsub("Genus: " ,"", test[Genus]),
           Species = gsub("Species Epithet: " ,"", test[Species]),
           Author = gsub("Species Author: " ,"", test[Author]),
           Synonyms = gsub("Synonymns: " ,"", test[Synonyms]),
           LifeForm = gsub("Form: " ,"", test[LifeForm]),
           SubspRank = gsub("Subspecies Rank: " ,"", test[SubspRank]),
           SubspEpithet = gsub("Subspecies Epiphet: ", "", test[SubspEpithet]),
           StorageBehaviour = gsub("Storage Behaviour: ", "", test[StorageBehaviour]),
           StorageConditions = gsub("Storage Conditions: ", "", test[StorageConditions]),
           SpeciesDistribution = gsub("Species Distribution: ", "", test[SpeciesDistribution]),
           AverageSeedWeight = gsub("Average 1000 Seed Weight\\(g\\): ", "", test[AverageSeedWeight]),
           # a mean of all measurements, loss of info of seed number, and number of tests & conditions etc...
           PercentGermination = mean(as.numeric(stringi::stri_extract(str = test[PercentGermination], regex = "^[0-9]*"))),
           # for now, just get the first word of first line, there may be multiple methods of dispersal...
           SeedDisp = gsub(";.*", "", test[SeedDisp]),
           OilContent = gsub("Average of Oil Content \\(%\\): ", "", test[OilContent]),
           ProteinContent = gsub("Average of Protein Content \\(%\\): ", "", test[ProteinContent]),
           PlantType = gsub("Plant Type: ", "", stringi::stri_extract(str = test[SaltTolandPhot], regex = "^Plant Type: [[:alpha:]]+")),
           MaxdSm = gsub("Max dS/m: ", "", stringi::stri_extract(str = test[SaltTolandPhot], regex = "Max dS/m: [[:alpha:]]+")),
           PhotosyntheticPathway = gsub("Photosynthetic Pathway: ", "", stringi::stri_extract(str = test[SaltTolandPhot], regex = "Photosynthetic Pathway: [[:alnum:]]*"))
           )
})

applyParse2 <- rbindlist(applyParse)

fwrite(applyParse2, file = "./scrapedSIDdata.csv")
