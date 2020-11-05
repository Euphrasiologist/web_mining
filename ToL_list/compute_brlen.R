library(ape); library(phytools)
x <- read.tree(file = "./tree.newick")
tree <- ape::read.tree(file = "./tree.newick")
tree <- ape::compute.brlen(tree)
tree <- phytools::force.ultrametric(tree, method = "extend")
# drop problematic tips. 
# Bombusterrestris(indomainBacteria)ott5901391; Aporiacrataegi(speciesinNucletmycea)ott4047122
tree <- ape::drop.tip(phy = tree, tip = c("Bombusterrestris(indomainBacteria)ott5901391",
                                  "Aporiacrataegi(speciesinNucletmycea)ott4047122"))

write.tree(tree, "./tree_brlen.newick")