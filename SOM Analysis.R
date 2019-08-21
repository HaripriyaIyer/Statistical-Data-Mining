setwd("C:\\Users\\abc\\Desktop\\SDM II\\HW2")
rm(list = ls())
#install.packages("kohonen")
library(kohonen)

cancerData <- read.csv("breast-cancer-wisconsin.data")
#options(repos = getOption("repos")["CRAN"])

cancerData <- data.frame(cancerData)
#cancerData.scaled <- cancerData[,-c(1,2)]
cancerData.scaled <- cancerData[,-c(1,11)]
#cancerData.scaled <- scale(cancerData.scaled)
cancerData.scaled <- as.numeric(unlist(cancerData.scaled))#scale(cancerData.scaled)

# fit an SOM
set.seed(123)

som_grid <- somgrid(xdim = 5, ydim = 5, topo = "hexagonal")
cancer.som <- som(cancerData.scaled, grid = som_grid, rlen = 1500)

codes <- cancer.som$codes[[1]]

x11()
plot(cancer.som, main = "Cancer Data", type = "codes")

x11()
plot(cancer.som, type = "changes", main = "Cancer Data")

x11()
plot(cancer.som, type = "mapping", main = "Cancer Data")

coolBlueHotRed <- function(n, alpha = 1){rainbow(n, end=4/6, alpha = alpha)[n:1]}

x11()
plot(cancer.som, type = "dist.neighbours", palette.name = coolBlueHotRed)

d <- dist(codes)
hc <- hclust(d)

x11()
plot(hc)

som_cluster <- cutree(hc,k=2)

# plot the SOM with the found clusters

my_pal <- c("blue", "yellow","green")
my_bhcol <- my_pal[som_cluster]

graphics.off()

x11()
plot(cancer.som, type = "mapping", col = "black", bgcol = my_bhcol)
add.cluster.boundaries(cancer.som, som_cluster)
