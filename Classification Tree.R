rm(list = ls())
#install.packages('ISLR')
#install.packages("DataExplorer")
library('ISLR')
library('ElemStatLearn')
library("DataExplorer")
#install.packages("rpart.plot")
library(rpart)
library(rpart.plot)# Classification Tree with rpart
#install.packages("arules")
library("arules")

df_marketing = as.data.frame(marketing)
#??marketing

###creating dummy class values for the entire dataset
N = 8993
class = sample(c(0,1), N,replace = T)
#df_marketing["class"] = class

#### Removing NA VAlues from the dataset##############
df_marketing <- df_marketing[complete.cases(df_marketing), ]


hist(df_marketing$Income)
hist(df_marketing$Sex)
hist(df_marketing$Marital)
hist(df_marketing$Age)
hist(df_marketing$Edu)
hist(df_marketing$Occupation)
hist(df_marketing$Lived)
hist(df_marketing$Dual_Income)
hist(df_marketing$Household)
hist(df_marketing$Householdu18)
hist(df_marketing$Status)
hist(df_marketing$Home_Type)
hist(df_marketing$Ethnic)
hist(df_marketing$Language)

# Deal with ordered variables 
df_marketing[["Income"]] <- ordered(cut(df_marketing[["Income"]], c(0,1,2,3,4,5,6,7,8,9)), labels = c("< $10,000","$10,000 to $14,999", "$15,000 to $19,999", "$20,000 to $24,999", "$25,000 to $29,999","$30,000 to $39,999","$40,000 to $49,999", "$50,000 to $74,999", "$ >75,000 "))
df_marketing[["Sex"]] <- ordered(cut(df_marketing[["Sex"]], c(0,1,2)), labels = c("Male", "Female"))
df_marketing[["Marital"]] <- ordered(cut(df_marketing[["Marital"]], c(0,1,2,3,4,5)), labels = c("Married" ,"Not Married", "Divorced","Widowed","Single"))
df_marketing[["Age"]] <- ordered(cut(df_marketing[["Age"]], c(0,3,5,7)), labels = c("Young", "Middle-aged", "Senior"))
df_marketing[["Edu"]] <- ordered(cut(df_marketing[["Edu"]], c(0,1,2,3,4,5,6)), labels = c("<Grade 8", "Grades 9 to 11","High School","1 to 3 years of college","College Graduate","Graduate Study"))
df_marketing[["Occupation"]] <- ordered(cut(df_marketing[["Occupation"]], 
                                            c(0,1,2,3,4,5,6,7,8,9)), 
                                        labels = c("Professional/Managerial","Sales Worker","Factory Worker/Laborer/Driver","Clerical/Service Worker","Homemaker", "Student, HS or College","Military", "Retired", "Unemployed"))
df_marketing[["Lived"]] <- ordered(cut(df_marketing[["Lived"]], 
                                       c(0, 2, 3,4,5)), labels = c("<2 Yrs",  "2-3 Yrs",  "3-4 Yrs",">5 Yrs"))
df_marketing[["Dual_Income"]] <- ordered(cut(df_marketing[["Dual_Income"]], c(0,1,2,3)), 
                                         labels = c("Not Married", "Yes", "No"))
df_marketing[["Household"]] <- ordered(cut(df_marketing[["Household"]], 
                                           c(0,1,2,3,4,5,6,7,8,9)), labels = c("One", "Two", "Three", "Four", "Five", "Six","Seven","Eight", "Nine or more"))
df_marketing[["Householdu18"]] <- ordered(cut(df_marketing[["Householdu18"]], c(-1,0,1,2,3,4,5,6,7,8)), labels = c("None", "One", "Two", "Three", "Four", "Five", "Six","Seven","Eight"))
df_marketing[["Status"]] <- ordered(cut(df_marketing[["Status"]], c(0,1,2,3)), labels = c("Own", "Rent", "Live with Parents/Family"))
df_marketing[["Home_Type"]] <- ordered(cut(df_marketing[["Home_Type"]], c(0,1,2,3,4,5)), labels = c("House","Condominium","Apartment", "Mobile Home","Other"))
df_marketing[["Ethnic"]] <- ordered(cut(df_marketing[["Ethnic"]], c(0,1,2,3,4,5,6,7,8)),  labels = 
                                      c("American Indian","Asian", "Black","East Indian","Hispanic","Pacific Islander","White","Other"))
df_marketing[["Language"]] <- ordered(cut(df_marketing[["Language"]], c(0,1,2,3)), labels = c("English", "Spanish", "Other"))

#df_marketing[["class"]] <- ordered(cut(df_marketing[["class"]], c(-1,0,1)), labels = c("false_0", "true_1"))

############## Creating Training and Reference sets ##################
#set.seed(23)
#train <- sample(1:nrow(df_marketing), .50*nrow(df_marketing))
#df_train <- df_marketing[train,]
#df_reference_sample <- df_marketing[-train,]

df_marketing$target = 1
df_train = df_marketing
df_reference_sample = df_marketing

for(i in 1:ncol(df_reference_sample)){
  df_reference_sample[,i] = sample(df_reference_sample[,i], nrow(df_reference_sample), replace=TRUE)
}
df_reference_sample$target = 0

data_merged = rbind(df_reference_sample, df_train)

for(i in 1:ncol(data_merged)){
  data_merged[,i] = as.factor(as.character(data_merged[,i]))
}

#### Build a classification tree on train and reference dataset ########
x11()
tree_model<-rpart.control(maxdepth = 4,minsplit = 5, xval = 10, cp =0)
tree1<-rpart(target~., data = data_merged, method = "class", control = tree_model)
rpart.plot(tree1,nn=TRUE,main="Classification Tree on Full Data Set", cex.main=1.5)


#Convert to a binary incidence matrix
df_marketingTrans <- as(data_merged, "transactions")

summary(df_marketingTrans)

x11()
i <- itemFrequencyPlot(df_marketingTrans, support = 0.1, cex.names = 0.8)

# Apply the apriori algorithm
rules  <- apriori(df_marketingTrans, parameter = list(support = 0.03, confidence = 0.6))

# Take a closer look at the different rules
summary(rules)


###############
rulesclass_1 <- subset(rules, subset = rhs %in% "target=1" & lift>1.1)
rulesclass_1

inspect(head(sort(rulesclass_1, by = "confidence"), n = 4))
inspect(head(sort(rulesclass_1, by = "lift"), n = 4))

