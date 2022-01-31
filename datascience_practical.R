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
# install.packages("SmartEDA")
# install.packages("jtools")
# install.packages("stargazer")

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
library(jtools)
library(stargazer)

##### Loading Data ##### 
colnames = c('state','district', 'democA', 'voteA', 'expendA', 'expendB', 'prtystrA', 'lexpendA', 'lexpendB', 'shareA')
colnames2 = c('state','district','democ','vote90','vote88','inexp90','chexp90','inexp88', 'chexp88','prtystr','rptchall','tenure','lawyer','linexp90','lchexp90'  ,
              'linexp88','lchexp88','incshr90','incshr88','cvote','clinexp','clchexp','cincshr','win88','win90','cwin')

data1 = read_xls('C:/Users/bramg/Desktop/DataScience_practical/data3a.xls', col_names = colnames)
data2 = read_xls('C:/Users/bramg/Desktop/DataScience_practical/data3b.xls', col_names = colnames2)

quantVariables = data1[,2:10]
logExpenditureAB = data1[,8:9]
expendAB = data1[,5:6
                 
#########                  
                 
                 
                 

##### Question 1 ######
### Expenditure A
votingExpenditure.lm = lm(formula = voteA ~ expendA, data = data1)
summ(votingExpenditure.lm)
votingExpenditure.data = data.frame(data1$voteA, data1$expendA)
pairs(votingExpenditure.data, panel=panel.smooth)

### Expenditure A/ Expenditure B
expenditureAExpenditureB.lm = lm(expendA~ expendB, data = data1)
#summary(expenditureAExpenditureB.lm)
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
cor.cor = round(cor(cor.data),2)
stargazer(cor.cor, digits=1, type='text', title = 'Correlation Matrix')




##### Question 2 ##### 

### Log vs Normal 
votingLog.lm = lm(formula = voteA ~ lexpendA, data= data1)
votingExpendA.lm = lm(formula = voteA ~ expendA, data=data1)

grid1 = matrix(c(1,2), nrow =1, ncol = 2)
layout(grid1)
plot(data1$lexpendA, data1$voteA, main = "Log Expenditure A vs Voting % A")
plot(data1$expendA, data1$voteA,  main = "Expenditure A vs Voting % A")

##### LogA, LogB --- Voting A ##### 
## Log: 
voteALogALogB.lm = lm(formula = data1$voteA ~ logExpenditureAB$lexpendA + logExpenditureAB$lexpendB)

## "Normal" 
voteAExpAExpB.lm = lm(formula = data1$voteA ~ expendAB$expendA + expendAB$expendB)

stargazer(voteALogALogB.lm, voteAExpAExpB.lm,
          type = "text", out = "fit_lm.html", omit.stat=c("LL","ser","f"), 
          align=TRUE ,no.space=TRUE)

#### All variables ####
colInterest = data1[, c('district', 'democA', 'voteA', 'expendA', 'expendB', 'prtystrA', 'lexpendA', 'lexpendB', 'shareA')]
all.lm = lm(formula = data1$voteA ~ ., data= colInterest )
narrower.data = data1[, c('prtystrA', 'shareA')]
narrower.lm = lm(formula = data1$voteA ~ ., data= narrower.data )


stargazer(all.lm, narrower.lm, votingShareA.lm,
           type = "text", out = "fit_lm.html", omit.stat=c("LL","ser","f"), 
           align=TRUE ,no.space=TRUE)

stargazer(votingLog.lm, voteALogALogB.lm, votingExpend.lm, voteAExpAExpB.lm, votingShareA.lm,
          type = "text", out = "fit_lm.html", omit.stat=c("LL","ser","f"), 
          align=TRUE ,no.space=TRUE)



##### Interaction Term ##### 
interactionTerm = data1$expendA + data1$expendB
expendAB$interactionTerm = interactionTerm

votingAInteractionTerm.lm = lm(formula = data1$voteA ~ expendAB$expendA + expendAB$expendB + expendAB$interactionTerm)
summary(votingAInteractionTerm.lm)


interactionTermLog = data1$lexpendA + data1$lexpendB
logExpenditureAB$interactionTermlog = interactionTermLog
votingAInteractionTermLog.lm = lm(formula = data1$voteA ~ logExpenditureAB$lexpendA + logExpenditureAB$lexpendB + logExpenditureAB$interactionTermlog)

summary(votingAInteractionTermLog.lm)


stargazer(votingAInteractionTermLog.lm, votingAInteractionTerm.lm,
          type = "text", out = "fit_lm.html", omit.stat=c("LL","ser","f"), 
          align=TRUE ,no.space=TRUE)

#### 



#### Density check ########

descdist(data1$shareA, discrete = FALSE)
descdist(data1$expendA, discrete = FALSE)
descdist(data1$expendB, discrete = FALSE)





