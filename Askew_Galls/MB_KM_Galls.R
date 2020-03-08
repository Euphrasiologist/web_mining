library(data.table)
library(stringi)
test <- fread(text = "./2013AskewZootaxa_KM_290120.txt", sep = "\n", header = FALSE)

# I think got to create a factor determining whether it is a gall wasp or not.
# this is the genus
test[, V2 := grepl(pattern = "^[[:upper:]]{1}[[:lower:]]* [[:upper:]]{1}[[:lower:]]*", V1)]
# there are 14 genera
table(test$V2)
# remove genera
test <- test[!test$V2,][,.(V1)]
# match rows on a regex for species of gall wasp. Upper, lower, space, lower, upper (or parenthesis and capital)
vec <- grep(pattern = "^[[:upper:]]{1}[[:lower:]]* [[:lower:]]* [[:upper:]]{1}|^[[:upper:]]{1}[[:lower:]]* [[:lower:]]* \\([[:upper:]]", x = test$V1)
length(vec) # 114 gall wasp species?

# split the list on gall wasp species
lis <- list()
for(i in 1:113){
  j <- i+1
    lis[[i]] <- test[vec[i:j][1]:(vec[i:j][2]-1)]
}
lis[113]
# in lis, first element is the gall wasp species.

# what are all the countries?
countries <- c("AD, AT, AZ, BE, BG, CH, CZ, DE, DK, DZ, ES, FI, FR, GB, GR, HR, HU, IE, IS, IT, JO, LB, MA, MD, NL, PL, PT, RO, RS, RU, SE, SI, SK, TN, TR, UA, YU")
countries <- gsub(", ", "|", countries)

countries <- stringi::stri_replace_all_regex(str = countries, pattern = "\\|", replacement = ").{8}|(?=")
countries <- paste0("(?=", countries, ").{10}")


m<-lapply(lis, function(x){
  # x refers to the data table
  # this creates the gall species and parasitoids along with metadata
  y <- dim(x)[1]
  Gall_species <- x[1]
  # Gall_species actually turns to Gall_species.V1 (..?)
  x <- x[, .(Gall_sp = Gall_species, Parasitoids = V1)]
  x <- x[-1]
  # so change names back
  setnames(x = x, old = "Gall_sp.V1", "Gall_sp")
  # next we want to split on forward slashes and take the first element
  x[, Parasitoid := gsub(" /.*", "", Parasitoids)]
  # create new column for number if recorded, then remove next bracket, then turn to numeric
  x[, Total_number := gsub(".* \\(", "", Parasitoid)][, Total_number := gsub("\\)", "", Total_number)][, Total_number := as.numeric(Total_number)]
  # clean up the parasitoid column
  x[, Parasitoid := gsub(" \\(.*", "", Parasitoid)]
  # get status/generation of gall wasp out 
  x[, Status := gsub(".*\\(", "", Gall_sp)][, Status := gsub("\\)", "", Status)]
  # lastly, get the countries out, and numbers separately
  #x[, Per_country := stri_extract_all(str = Parasitoids, regex = countries)]
  
  # split on forward slash but remove first element
  x[, Per_country := strsplit(x = Parasitoids, split = "/", fixed = TRUE)]
  # remove authority and after...
  x[, Gall_sp := gsub(" [[:upper:]].*| \\(.*", "", Gall_sp)]
})
# Per_country is a list of vectors and we want only country + number in a list
# to clean use lapply and regex
# list 113 has a duplicate column for some reason.
# m[[113]] <- m[[113]][, -"Gall_sp.Gall_sp"]
m2 <- rbindlist(m)

x <- m2$Per_country[[5]]

n <- lapply(m2$Per_country, function(x){
  # remove first element
  y <- x[-1]
  # remove references
  y2 <- gsub("\\([a-zA-Z].*", "", y)
  # remove brackets
  y3 <- gsub("\\(", "", y2)
  y4 <- gsub("\\)", "", y3)
  # replace comma
  y5 <- gsub(",", "", y4)
  # replace asterisk
  y6 <- gsub("\\*", "", y5)
  y6
}
)



#n <- lapply(m2$Per_country, function(x) {
  # sorted if country + number
  #y <- gsub(" \\([a-zA-z]*", " ", x)
  #y <- gsub("\\)", "", y)
  # now remove guff if there was no number (ü + /)
  #z <- gsub(" /.*", "", y)
  #z <- gsub(" Q\\..*", "", z)
  #z <- gsub(" ü.*", "", z)
  # remove asterisks and space at end of string
  #z <- gsub("\\*", "", z)
  #z <- gsub(" $", "", z)
  #z
#})
# replace per country with n
m2[, Per_country := sapply(n, function(x) paste(x, collapse = ","))]
# unlist


# rearrange and clean
m3 <- m2[, .(Gall_sp, Status, Parasitoid, Total_number, Per_country)]

# split the per country column
m3[, Per_country := strsplit(Per_country, ",")]

m3[grepl(pattern = "\\\\", Per_country)]
# fwrite(m3, "./MB_KM_galls.csv")

# I need this list column to be cast so each element of the list is returned as a separate row
# could either take each element out as a separate column (inefficient?)
# or label each record with unique ID and merge later
m3[, ID := 1:nrow(m3)]
# group by unique ID                                       then! merge back with data
m4 <- m3[,.(Per_country = unlist(Per_country)), by = .(ID)][m3[,-c("Per_country", "Total_number")], on=.(ID)]
# create the Total Number again (per country number)
m4[, Number := stringi::stri_extract_first_regex(str = m4$Per_country, pattern = "[[:digit:]]+")]
# fix Per_country & names
m4[, Per_country := gsub("^ ", "", Per_country)]
m4[, Country := gsub(" .*", "", m4$Per_country)]
# get Quercus out, delete everything before first Q
m4[, Tree_host := unlist(stringi::stri_extract_all(regex = "Q\\..*", str = Per_country))]
# remove per country
m4 <- m4[,-"Per_country"]

Country <- "Andorra, Austria, Azerbaijan, Belgium, Bulgaria, Switzerland, Czech Republic, Germany, Denmark, Algeria, Spain, Finland, France, United Kingdom, Greece, Croatia, Hungary, Ireland,Israel, Italy, Jordan, Lebanon, Morocco, Moldova, Netherlands, Poland, Portugal, Romania, Serbia, Russian Federation, Sweden, Slovenia, Slovakia, Tunisia, Turkey, Ukraine, Yugoslavia"
Per_country <- c("AD, AT, AZ, BE, BG, CH, CZ, DE, DK, DZ, ES, FI, FR, GB, GR, HR, HU, IE, IS, IT, JO, LB, MA, MD, NL, PL, PT, RO, RS, RU, SE, SI, SK, TN, TR, UA, YU")

country_names <- data.table(Countr = sapply(Per_country, function(x) strsplit(x, ","))[[1]],
                            Country = sapply(Country, function(x) strsplit(x, ","))[[1]])
country_names[,Country := gsub("^ ", "", Country)]
country_names[,Per_country := gsub(" ", "", Per_country)]

# final fix
m5 <- country_names[m4, on = .(Per_country)]

fwrite(m5[,.(Per_country,Country,Gall_sp,Status,Parasitoid,Number)], "./MB_KM_galls280220.csv")