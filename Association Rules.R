library(ElemStatLearn)
library(MASS)
BosDF<- data.frame(Boston)
names(BosDF)
head(BosDF)
install.packages("arules")
library("arules")
library("ggpubr")

graphics.off()

x11()
par(mfrow=c(2,3))
h1 <- hist(Boston$crim,breaks=25,xlim=c(0,90))
h2 <-hist(Boston$zn)
h3 <-hist(Boston$indus)
h4 <-hist(Boston$nox)
h5 <-hist(Boston$chas)
h6<-hist(Boston$rm)

x11()
par(mfrow=c(2,2))
hist(Boston$age)
hist(Boston$dis)
hist(Boston$rad)
hist(Boston$tax)

x11()
par(mfrow=c(2,2))
hist(Boston$ptratio)
hist(Boston$black)
hist(Boston$lstat)
hist(Boston$medv)


BosDF[["chas"]] <- NULL

# Deal with ordered variables 
BosDF[["crim"]] <- ordered(cut(BosDF[["crim"]], c(0,10, 20, 89)), labels = c("Low","Medium", "High"))

BosDF[["age"]] <- ordered(cut(BosDF[["age"]], c(0,25,55,80, 100)), labels = c("Young", "Middle-aged", "Senior", "Elderly"))

BosDF[["nox"]] <- ordered(cut(BosDF[["nox"]], c(0,0.4,0.6,0.9)), labels = c("Low", "Medium", "High"))

BosDF[["rm"]] <- ordered(cut(BosDF[["rm"]], c(0,4,6,9)), labels = c("Small", "Medium", "Large"))

BosDF[["ptratio"]] <- ordered(cut(BosDF[["ptratio"]], c(0,15,19,22)), labels = c("Low", "Medium", "High"))

BosDF[["dis"]] <- ordered(cut(BosDF[["dis"]], c(0,3,6,13)), labels = c("Close", "Near", "Far"))

BosDF[["rad"]] <- ordered(cut(BosDF[["rad"]], c(0,9,25)), labels = c("Accessible", "Not Accessible"))

BosDF[["tax"]] <- ordered(cut(BosDF[["tax"]], c(0,250,400,725)), labels = c("Low","Medium","High"))

BosDF[["zn"]] <- ordered(cut(BosDF[["zn"]], c(-1,30,70,101)), labels = c("Small","Medium","Large"))

BosDF[["indus"]] <- ordered(cut(BosDF[["indus"]], c(0,7,15,30)), labels = c("Small","Medium","Large"))

BosDF[["black"]] <- ordered(cut(BosDF[["black"]], c(0,200,400)), labels = c("Low","High"))

BosDF[["lstat"]] <- ordered(cut(BosDF[["lstat"]], c(0,15,25,40)), labels = c("Low","Medium","High"))

BosDF[["medv"]] <- ordered(cut(BosDF[["medv"]], c(0,15,25,40)), labels = c("Low","Medium","High"))


#Convert to a binary incidence matrix
BosTrans <- as(BosDF, "transactions")

summary(BosTrans)

x11()
i <- itemFrequencyPlot(BosTrans, support = 0.1, cex.names = 0.8)

# Apply the apriori algorithm
rules  <- apriori(BosTrans, parameter = list(support = 0.05, confidence = 0.6))

# Take a closer look at the different rules
summary(rules)

rulesLowcrim <- subset(rules, subset = rhs %in% "crim=Low" & lift>1)
rulesLowcrim

rulesClosedis <- subset(rules, subset = rhs %in% "dis=Close" & lift>1.2)
rulesClosedis

inspect(head(sort(rulesLowcrim, by = "confidence"), n = 3))
inspect(head(sort(rulesClosedis, by = "confidence"), n = 3))

inspect(head(sort(rulesLowcrim, by = "lift"), n = 3))
inspect(head(sort(rulesClosedis, by = "lift"), n = 5))

rulesLowcrimndis <- subset(rules, rhs %ain% "crim=Low","dis=close")
rulesLowcrimndis

inspect(head(sort(rulesLowcrimndis, by = "confidence"), n = 3))
inspect(head(sort(rulesLowcrimndis, by='lift'),n=3))


#############Q-d######################

rulesLowptratio <- subset(rules, subset = rhs %in% "ptratio=Low" & lift>1)
rulesLowptratio

inspect(head(sort(rulesLowptratio, by = "confidence"), n = 3))
inspect(head(sort(rulesLowptratio, by = "lift"), n = 3))


### Regression Model ###########
set.seed(21)

indexes = sample(1:nrow(Boston), size=0.2*nrow(Boston))

test = Boston[indexes,]
train = Boston[-indexes,]


lineartest <- lm(ptratio~.,test)
summary(lineartest)

trainmodel = predict.lm(lineartest, newdata = train)

errorpredictedinlm = mean((test$ptratio - trainmodel)^2)

errorpredictedinlm

scatter.smooth(Boston$ptratio,Boston$rad)
scatter.smooth(Boston$ptratio,Boston$zn)
scatter.smooth(Boston$ptratio,Boston$nox)
scatter.smooth(Boston$ptratio,Boston$lstat)
scatter.smooth(Boston$ptratio,Boston$black)
