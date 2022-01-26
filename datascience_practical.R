######## installing Packages ######## 

# install.packages("readxl")
# install.packages("xtable")
# install.packages("mctest")
# install.packages("goft")
# install.packages("fitdistrplus")
# install.packages("logspline")
# install.packages("flexsurv")
# install.packages("reldist")
# install.packages("dplyr")
# install.packages("tseries")
# install.packages("regclass")
# install.packages("dplyr")
# install.packages("ggpubr")
install.packages("SmartEDA")

##### Loading Libraries ##### 

library(readxl)
library(xtable)
library(mctest)
library(goft)
library(fitdistrplus)
library(logspline)
library(flexsurv)
library(reldist)
library(dplyr)
library(regclass)

##### Loading Data ##### 

colnames = c('state','district', 'democA', 'voteA', 'expendA', 'expendB', 'prtystrA', 'lexpendA', 'lexpendB', 'shareA')
colnames2 = c('state','district','democ','vote90','vote88','inexp90','chexp90','inexp88', 'chexp88','prtystr','rptchall','tenure','lawyer','linexp90','lchexp90'  ,
              'linexp88','lchexp88','incshr90','incshr88','cvote','clinexp','clchexp','cincshr','win88','win90','cwin')

data1 = read_xls('C:/Users/bramg/Desktop/DataScience_practical/data3a.xls', col_names = colnames)
data2 = read_xls('C:/Users/bramg/Desktop/DataScience_practical/data3b.xls', col_names = colnames2)

quantVariables = data1[,2:10]
logExpenditureAB = data1[,8:9]
expendAB = data1[,5:6]

##### Question 1 ######

### Expenditure A
votingExpenditure.lm = lm(formula = voteA ~ expendA, data = data1)
summary(votingExpenditure.lm)
votingExpenditure.data = data.frame(data1$voteA, data1$expendA)
pairs(votingExpenditure.data, panel=panel.smooth)

### Expenditure A/ Expenditure B
expenditureAExpenditureB.lm = lm(expendA~ expendB, data = data1)
summary(expenditureAExpenditureB.lm)
plot(data1$expendA, data1$expendB, xlab = 'Expenditure A', ylab = 'Expenditure B')

### Relative Expenditure A
votingShareA.lm = lm(formula = voteA ~ shareA, data = data1)
summary(votingShareA.lm)
votingShareA.data = data.frame(data1$voteA, data1$shareA)
pairs(votingShareA.data, panel=panel.smooth)

### Colliniearity
votingExpenditureShareA.lm = lm(formula = voteA ~ shareA + expendA, data = data1)
summary(votingExpenditureShareA.lm)
VIF(votingExpenditureShareA.lm)
votingExpenditureShareA.data = data.frame(data1$voteA, data1$shareA, data1$expendA)

cor.data = quantVariables
cor.cor = cor(cor.data)

##### Question 2 ##### 

### Log vs Normal 
votingLog.lm = lm(formula = voteA ~ lexpendA, data= data1)
summary(votingLog)

data1$l2expendA = exp(data1$expendA)
votingExpendAExp = lm(formula = voteA ~ l2expendA, data=data1)
summary(votingExpenditure.lm)

grid1 = matrix(c(1,2), nrow =1, ncol = 2)
layout(grid1)
plot(data1$lexpendA, data1$voteA, main = "Log Expenditure A vs Voting % A")
plot(data1$expendA, data1$voteA,  main = "Expenditure A vs Voting % A")


##### LogA, LogB --- Voting A ##### 
## Log: 
voteALogALogB.lm = lm(formula = data1$voteA ~ log$lexpendA + log$lexpendB)
summary(voteALogALogB.lm)

## "Normal" 
voteAExpAExpB.lm = lm(formula = data1$voteA ~ expend$expendA + expend$expendB)
summary(voteAExpAExpB.lm)


##### Interaction Term ##### 
interactionTerm = data1$expendA * data1$expendB
expendAB$interactionTerm = interactionTerm

votingAInteractionTerm.lm = lm(formula = data1$voteA ~ expendAB$expendA + expendAB$expendB + expendAB$interactionTerm)
summary(votingAInteractionTerm.lm)


interactionTermLog = data1$lexpendA * data1$lexpendB
logExpenditureAB$interactionTermlog = interactionTermLog
logExpenditureAB
votingAInteractionTermLog.lm = lm(formula = data1$voteA ~ logExpenditureAB$lexpendA + logExpenditureAB$lexpendB + logExpenditureAB$interactionTermlog)
summary(votingAInteractionTermLog.lm)


#### 

data2




