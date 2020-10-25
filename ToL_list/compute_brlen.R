library(ape); library(phytools)
x <- read.tree(file = "./tree.newick")
tree <- ape::read.tree(file = "~/OneDrive - University of Edinburgh/web_mining/ToL_list/tree.newick")
tree <- ape::compute.brlen(tree)
tree <- phytools::force.ultrametric(tree, method = "extend")
write.tree(tree, "~/OneDrive - University of Edinburgh/web_mining/ToL_list/tree_brlen.newick")