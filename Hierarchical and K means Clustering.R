
setwd("C:\\Users\\abc\\Desktop\\SDM II\\HW2")

rm(list = ls())
load("primate.scapulae.rda")

#install.packages("cluster")
library(cluster) 

library("cluster")
require("class")
summary(primate.scapulae)

primate.scapulae$gamma[is.na(primate.scapulae$gamma)] = 59.11
mean(primate.scapulae$gamma)

dmat = dist(primate.scapulae[1:9])
dim(as.matrix(dmat))

graphics.off()

####### Finding optimum No of Clusters #########3
set.seed(123)
######## elbow method##########.
k.max <- 15
err <- sapply(1:k.max, 
              function(k){kmeans(dmat, k, nstart=50,iter.max = 15 )$tot.withinss})
err
plot(1:k.max, err,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters ",
     ylab="Total within-clusters sum of squares",
     main="Optimum No of Cluster Analysis")

#############Silhouette method #########

silhouette_score <- function(k){
  km <- kmeans(d, centers = k, nstart=25)
  ss <- silhouette(km$cluster, dist(d))
  mean(ss[, 3])
}
k <- 3:10
avg_sil <- sapply(k, silhouette_score)

x11()
plot(k, type='b', avg_sil,main="Optimum No of Cluster Analysis", xlab='Number of clusters', ylab='Silhouette Scores', frame=FALSE)

######### Performing Hierarchical Clustering #########
# Complete Linkage Method #######
hc.avg = hclust(dmat, method = "complete")

x11()
plot(hc.avg, hang = -1)

cutTree.avg =(cutree(hc.avg, k = 5))
cutTree.avg
table(cutTree.avg,primate.scapulae$classdigit)

#### Single Linkage Method #######

hc.sin = hclust(dmat, method = "single")

plot(hc.sin, hang = -1)

cutTreeDt =(cutree(hc.sin, k = 4))
cutTreeDt
table(cutTreeDt,primate.scapulae$classdigit)


# Average Linkage Method #######

hc.com = hclust(dmat, method = "average")


plot(hc.com, hang = -1)

cutTreeDtavg =(cutree(hc.com, k = 4))
cutTreeDtavg
table(cutTreeDtavg,primate.scapulae$classdigit)



#K Means


set.seed(12)
km4 = kmeans(dmat,4)

table(km4$cluster,primate.scapulae$classdigit)
