library(ape)
x <- read.tree(file = "./tree.newick")
ape::write.tree(phy = ape::compute.brlen(x), file = "./tree_brlen.newick")