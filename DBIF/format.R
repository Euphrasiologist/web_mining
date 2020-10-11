dbif <- readLines("./DBIF.csv")

colnames(dbif)

dbif2 <- lapply(X = dbif, function(x){
  y <- gsub(pattern = ", \\S*inae", replacement = "", x = x)
  z <- gsub("\\s*\\([^\\)]+\\)", "", x = y)
  z <- gsub(", var\\..+", "", x = z)
  z <- gsub(", ssp\\..+", "", x = z)
  z <- gsub(", forma.+", "", x = z)
  z <- gsub(", cultivated varieties", "", x=z)
  z <- gsub(",,", ",", x = z)
  z <- gsub(",)$", "", x = z)
  z <- gsub(", f\\.", "", x = z)
  z <- gsub(" [[:alpha:]]+,$", "", x = z)
  z <- gsub("Acari,calus", "Acaricalus", x = z)
  z <- gsub("Oidae,matophorus", "Oidaematophorus", x = z)
  z <- gsub("idae,i", "idaei", x = z)
  z <- gsub("vitisidae,a", "vitisidaea", x = z)
  z <- gsub(", cultivars", "", x = z)
  z <- gsub(", cultivated", "", x = z)
  z <- gsub("binae,vella", "binaevella", x = z)
  if(length(strsplit(z, ",")[[1]]) > 3 & !grepl("Not specified", z, fixed = TRUE) & !grepl("Rosaceae trees, shrubs and herbaceous plants,", z, fixed = TRUE)) z
})

dbif2[1][[1]] <- "Host, Invertebrate order, Invertebrate family, Invertebrate"

writeLines(unlist(dbif2))
