library(data.table)
library(stringi)
# manually deleted "thumbed" quotes in csv
data <- fread("~/Documents/web_mining/TIDR/daff_register_cont.csv", header = TRUE)
colnames(data)[2] <- "division"
# fix dates
data[, date := as.Date(gsub("pre", "", date, fixed = TRUE), format = "%Y")]

# check dates
hist(data$date, breaks = 200)
# filter out synonyms
Table(data, "synonym")
data[, .(.N), by = .(synonym)][order(-N)]
data <- data[synonym == "none" | synonym == ""]
# presumably only want the division (without subdiv)
# if there is an "or", remove, or blank remove, or zero remove
data[, .(.N), by = .(division)][order(-N)]
# first clean
data[, division := gsub(pattern = "[:space:]{0-2}\\(.*", "", data$division)]
data[, division := gsub(pattern = "a|b|\\?| \\\\| W|Y| ", "", data$division)]
data <- data[!grepl("or", division)]
data[, division := as.numeric(division)]
data <- data[!is.na(division)]
data <- data[division != 0]

data[, .(.N), by = .(division)][order(-N)]


# corolla filtering
data[, .(.N), by = .(perianth)][order(-N)]
data[, perianth := gsub(pattern = "\\?", "", data$perianth)]
data <- data[!grepl("or", perianth)]
data <- data[perianth != ""]

data[, .(.N), by = .(corona)][order(-N)]
data[, corona := gsub(pattern = "\\?", "", data$corona)]
data <- data[!grepl("or", corona)]
data <- data[corona != ""]

# parents
data[, .(.N), by = .(pollen_parent)][order(-N)][1:100]

fwrite(file = "./clean_daff_register.csv", x = data)


data[perianth == "WWY"]

####
data[, .(.N), by = .(pollen_parent)][order(-N)][pollen_parent != ""][1:10]
data[, .(.N), by = .(seed_parent)][order(-N)][seed_parent != ""][1:10]
data[, .(.N), by = .(perianth)][order(-N)][perianth != ""][1:10]
data[, .(.N), by = .(corona)][order(-N)][corona != ""][1:10]


table(gsub(pattern = ".*2n=", replacement = "", x = data[grepl(pattern = "2n=", x = description, fixed = TRUE)]$description))
sapply(strsplit(data[grepl(pattern = "2n=", x = description, fixed = TRUE)]$description, "2n="), "[", 2)

test <- stringi::stri_extract(str = data[grepl(pattern = "2n=", x = description, fixed = TRUE)]$description, regex = "2n=.{1,5}")
hist(as.numeric(gsub("2n=", "", test)), breaks = 50)