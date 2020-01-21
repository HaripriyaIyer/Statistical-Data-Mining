rm(list = ls())

setwd("C:\\Users\\abc\\Desktop\\SDM II\\HW3")
install.packages("BiocManager")

install.packages("gRbase")
install.packages("gRain")
install.packages("ggm")
install.packages("igraph")
install.packages("Rgraphviz")

install.packages("RBGL")

library(gRbase)
library(gRain)
library(ggm)
library(igraph)
library(Rgraphviz)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("Rgraphviz", version = "3.8")

data(cad1)
c=c('Sex','SuffHeartF','Hyperchol','Smoker','Inherit','CAD')
cancer_data_set = cad1[,c]

#### PART A
g <- list(~Sex, ~Smoker|Sex, ~SuffHeartF, ~Inherit|Smoker, ~Hyperchol|Smoker:SuffHeartF, ~CAD|Inherit:Hyperchol)
cancer_dag = dagList(g)

################## Question a) ###################
x11()
plot(cancer_dag)

dSep(as(cancer_dag,"matrix"),"Sex","Hyperchol","CAD") # False
dSep(as(cancer_dag,"matrix"),"Sex","Inherit","Smoker") # True
dSep(as(cancer_dag,"matrix"),"Sex","SuffHeartF","CAD") # False
dSep(as(cancer_dag,"matrix"),"Smoker","CAD",c("Inherit","Hyperchol")) # True
dSep(as(cancer_dag,"matrix"), "Hyperchol","Sex","Smoker") # True
dSep(as(cancer_dag,"matrix"),"SuffHeartF","Sex",c("Inherit","Hyperchol","CAD")) # False

## Specify the CPD tables
#extract CPT
cancer_cpd = extractCPT(cancer_data_set, cancer_dag)
#Compile CPT
cancer_compile_prob = compileCPT(cancer_cpd)
#Create Network
cancer_network = grain(cancer_compile_prob)

summary(cancer_network)

plot(cancer_network)

#Compile Network
cancer_network_comp = compile(cancer_network)
#Propagate Network
cancer_network_prop = propagate(cancer_network_comp)

########### Question b)
## Absorbing Information into the graph
cancer_network_absrb = setFinding(cancer_network_prop, nodes=c("Sex","Hyperchol"), states = c("Female","Yes"))

################# Evidential Reasoning
## Get Findings
getFinding(cancer_network_absrb)

# 1. Query the network based on above evidence. It returns the Marginal probability.
absorbed_m = querygrain(cancer_network_absrb, nodes = c("SuffHeartF","CAD"), type="marginal") #hf_no=0.61, cad_yes=0.60
absorbed_m
# 2. Query the network based on NO evidence. Here, we use original graph.
not_absorbed_m = querygrain(cancer_network, nodes = c("SuffHeartF","CAD"), type="marginal") #hf_no=0.7, cad_yes=0.45
not_absorbed_m
# Conclusion from 1&2: On taking the evidence into consideration, marginal probability of suffHeart decreases and cad increases.

#joint Probability
absorbed_j = querygrain(cancer_network_absrb, nodes = c("SuffHeartF","CAD"), type="joint") 
absorbed_j
not_absorbed_j = querygrain(cancer_network, nodes = c("SuffHeartF","CAD"), type="joint") 
not_absorbed_j

#Conditional Probability
absorbed_c = querygrain(cancer_network_absrb, nodes = c("SuffHeartF","CAD"), type="conditional") 
absorbed_c
not_absorbed_c = querygrain(cancer_network, nodes = c("SuffHeartF","CAD"), type="conditional") 
not_absorbed_c


############# Question c)
## Simulate data from graph that has absorbed new information
sim_data1 = simulate.grain(cancer_network_absrb , nsim = 5)
sim_data1
## Predict for Smoker and CAD based on simulated data
pred_data1 = predict.grain(cancer_network_absrb, response = c("Smoker", "CAD"), newdata= sim_set1, type="class")
pred_data1 

table(sim_data1$Smoker,pred_1$pred$Smoker )
table(sim_data1$CAD, pred_1$pred$CAD )
table(pred_1$pred)

absorbed_sim1 = querygrain(sim_data1, nodes = c("Smoker","CAD"), type="conditional") 
absorbed_sim1

############# Question d)
## Simulate 500 data from graph that has absorbed new information
sim_data2 = simulate.grain(cancer_network_absrb , nsim = 500)
save(sim_data2, file = 'Simulated_DataSet.RData')
## Predict for Smoker and CAD based on simulated data
pred_2 = predict.grain(cancer_network_absrb, response = c("Smoker", "CAD"), newdata= sim_data2, type="class")
pred_2 

# Confusion Matrix
t1 = table(sim_data2$Smoker,pred_2$pred$Smoker )
t2 = table(sim_data2$CAD, pred_2$pred$CAD )

mis_class_rate_sm = t1/500  
mis_class_rate_cad = t2/500 


