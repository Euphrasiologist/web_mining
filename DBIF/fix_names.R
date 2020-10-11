suppressMessages(library(data.table))
suppressMessages(library(Taxonstand))

dbif <- suppressWarnings(fread("./DBIF2.csv", header = TRUE))

# taxonstand takes a loooong time... so I've saved the files locally.

#plant_names <- Taxonstand::TPL(splist = unique(dbif$Host), silent = FALSE)
#fwrite(x = plant_names, file = "./plant_names.csv")
plant_names <- fread("./plant_names.csv")

plant_names2 <- data.table(Host = unique(dbif$Host),
           PLHost = paste(plant_names$New.Genus, plant_names$New.Species))

# import DToL angiosperm list
DToL <- fread("./DToL_Angiosperms.csv")[,.(Stace = Species_name_Stace4, Family)]
# remove empty rows
DToL <- DToL[!apply(DToL == "", 1, all),]
# standardise the names between data sets.
# again, saved locally to save the repeat of taxonstand lookups.

#stand_names <- Taxonstand::TPL(splist = DToL$Stace, silent = FALSE)
#fwrite(x = stand_names, file = "./stand_names.csv")
stand_names <- fread("./stand_names.csv")

stand_names2 <- data.table(PLSpecies = paste(stand_names$New.Genus, stand_names$New.Species), Family = stand_names$Family)

# filter plant_names2 to those only in stand_names2
plant_names3 <- plant_names2[PLHost %in% stand_names2$PLSpecies]
plant_names3 <- stand_names2[plant_names3, on = .(PLSpecies = PLHost)]
# and merge with original dataset, and reorder accordingly
final <- unique(dbif[plant_names3, on = .(Host)][,.(PLSpecies, 
                                    PLFamily = Family, 
                                    Order = `Invertebrate order`,
                                    Family = `Invertebrate family`,
                                    Invertebrate)])

# add genera
final[, `:=`(PLGenus = gsub(" .*", "", PLSpecies),
             Genus = gsub(" .*", "", Invertebrate))]

final <- final[, .(PLFamily, PLGenus, PLSpecies, Order, Family, Genus, Invertebrate)]

fwrite(x = final, file = "", sep = ",")

#final[,.(.N), by = .(PLSpecies)][order(-N)]
#unique(final[,-c("Invertebrate", "PLSpecies")])[,.(.N), by = .(PLFamily)][order(-N)]
