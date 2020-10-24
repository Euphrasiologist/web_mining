library(data.table)
data <- fread("./data.txt")
data[, `:=`(`Repeat %` = as.numeric(`Repeat %`), `Heterozygosity %` = as.numeric(`Heterozygosity %`))]
final <- unique(data[!is.na(`Repeat %`) & `Repeat %` > 0 & `Heterozygosity %` > 0])
fwrite(final, "./clean_data.csv")