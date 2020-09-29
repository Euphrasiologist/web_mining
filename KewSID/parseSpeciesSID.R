library(data.table)
library(taxonlookup)
library(brranching)
library(ape)
setwd("~/OneDrive - University of Edinburgh/web_mining/KewSID/")
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

applyParse2 <- fread("./scrapedSIDdata.csv")
## OBSERVABLE VIZUALISATION

taxa <- applyParse2[, .(Genus, Species)]
taxa <- taxa[!grepl("sp\\.", Species)]
taxa <- taxa[!grepl("spp\\.", Species)]

taxa <- taxa[,.SD[sample(.N, min(1,.N))],by = Genus]

taxa[, new:=do.call(paste,.SD), .SDcols=c("Genus", "Species")]

taxa <- taxa$new

taxa <- as.data.table(taxa)

lookup_ <- lookup_table(species_list = taxa$taxa)
taxa[, Genus := gsub(" .*", "", taxa)]
taxa2 <- setDT(lookup_)[taxa, on = .(genus = Genus)]

taxa2 <- taxa2[,.SD[sample(.N, min(1,.N))], by = family]

TREE <- brranching::phylomatic(taxa = taxa2$taxa, get = 'POST')

TREE$tip.label <- gsub("_", " ", TREE$tip.label)
taxa2[, taxa := tolower(taxa)]

TREE$tip.label <- taxa2[match(TREE$tip.label, taxa2$taxa)]$family
TREE$tip.label[10] <- "Erythroxylaceae"

firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}
TREE$node.label <- firstup(TREE$node.label)

# to visualise in observable
applyParse2[, Species := paste(Genus, Species)]
observable <- applyParse2[!grepl("Harveya obtusifolia|Taphrospermum altaicum|ixiolirion_tataricum|Vahlia capensis|Cynomorium coccineum|Vahlia digyna|Holmgrenia hanburyi|Tetracarpaea tasmannica", Species)]
# NOTE: 7 taxa not matched: NA/harveya/harveya_obtusifolia, NA/taphrospermum/taphrospermum_altaicum, NA/ixiolirion/ixiolirion_tataricum, cynomoriaceae/cynomorium/cynomorium_coccineum, vahliaceae/vahlia/vahlia_digyna, NA/holmgrenia/holmgrenia_hanburyi, NA/tetracarpaea/tetracarpaea_tasmannica, ];


observable[, Family := firstup(tolower(Family))]


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

observable1 <- observable[, .(AvgSeedW = mean(as.numeric(AverageSeedWeight), na.rm = TRUE),
               AvgOilCon = mean(as.numeric(OilContent), na.rm = TRUE),
               AvgProCon = mean(as.numeric(ProteinContent), na.rm = TRUE),
               AvgPerGer = mean(as.numeric(PercentGermination), na.rm = TRUE)),
               #ModStorage = Mode(StorageBehaviour),
               #ModSeedDisp = Mode(SeedDisp)), 
           by = .(Family)]

# make sure family names match between the tree and the data
drop_these_tips <- setdiff(TREE$tip.label, observable1$Family) # in tree but not in data - remove these
TREEObs <- drop.tip(phy = TREE, tip = drop_these_tips)
write.tree(phy = compute.brlen(phy = TREEObs), file = "")


drop_these_data <- setdiff(observable1$Family, TREE$tip.label) # in data but not in tree - remove these
observable2 <- observable1[!Family %in% drop_these_data]

fwrite(observable2, file = "./observable.csv")
observable <- fread("./observable.csv")

## and dispersal data...
observable1.1 <- observable[,.(.N), by=.(Family, SeedDisp)]
observable1.2 <- observable1.1[SeedDisp %in% c("Water", "Wind", "Animal", "Unassisted")]

drop_from_dat <- setdiff(observable1.2$Family, TREE$tip.label) # not in the tree
observable1.3 <- observable1.2[!Family %in% drop_from_dat]
observable1.3[, FamN := sum(N), by = .(Family)]
observable1.3[, PropN := N/FamN]

observable1.4 <- unique(dcast(data = observable1.3, formula = Family ~ SeedDisp, value.var = c("PropN"))[observable1.3[,.(Family, FamN)], on = .(Family)])

TREEObs2 <- compute.brlen(phy = keep.tip(phy = TREE, unique(observable1.3$Family)))
write.tree(phy = TREEObs2, file = "")

# add orders...

famOrd <- setDT(lookup_table(observable[,.(Species)]$Species))
famOrd <- unique(famOrd[,.(Family = family, Order = order)])

observable1.5 <- famOrd[observable1.4, on = .(Family)]
fwrite(x = observable1.5, file = "./observable2.csv")

## new Observable visualisation

newObs <- applyParse2[,.(Family = firstup(tolower(Family)),
               Species = paste(Genus, Species),
               AvgSeedW = AverageSeedWeight,
               OilContent,
               ProteinContent)][!is.na(AvgSeedW)]
