# -*- coding: utf-8 -*-
"""
Created on Wed Jan 12 14:11:37 2022

@author: roosp
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statistics as stats
import statsmodels.api as sm


def OLSregression(X, y):
    n = len(y)
    meanY = stats.mean(y)
    meanX = stats.mean(X)
    Xy = X * y
    sumXy = sum(Xy)
    
    beta1hat = (((1/n)*sumXy) - meanX*meanY)/(sum((X-meanX)**2)/n)
    beta0hat = meanY - beta1hat*meanX
    
    return beta0hat, beta1hat

def multiOLSregression(X,y):
    X = sm.add_constant(X)
    Xtrans = np.transpose(X)
    XtransXinf = np.linalg.inv(Xtrans@X)
    betahat = XtransXinf@Xtrans@y
    return betahat
 
def multiOLSreg(X,Y):
    
    X = sm.add_constant(X)
    mod = sm.OLS(Y, X)
    res = mod.fit()
    beta0hat, beta1hat, beta2hat = res.params
    print(res.summary())
    return beta0hat, beta1hat, beta2hat
    
def expend(expendA, expendB, expendAB, expendAtimesB, voteA, voteB):
  expendboth = expendAB.merge(expendAtimesB.rename("exoendAtimesB"), left_index=True, right_index=True)
  
  beta0hatA, beta1hatA = OLSregression(expendA, voteA)
  beta0hatB, beta1hatB = OLSregression(expendB, voteB)
  print('the beta0 and beta1 in the OLS regression from expendA and voteA are:', beta0hatA, beta1hatA)
  print('the beta0 and beta1 in the OLS regression from expendB and voteB are:', beta0hatB, beta1hatB)

  votehatA = beta0hatA + beta1hatA*expendA
  votehatB = beta0hatB + beta1hatB*expendB
  
  betahatAB = multiOLSregression(expendAB,voteA)
  beta0hatAB, beta1hatAB, beta2hatAB = betahatAB
  voteABhat = beta0hatAB + beta1hatAB*expendA+ beta2hatAB*expendB
  print('the beta0, beta1 and beta2 in the OLS regression from expendA and expendB and voteA are:', beta0hatAB, beta1hatAB, beta2hatAB)
  
  betahat_interaction = multiOLSregression(expendboth, voteA)
  beta0hat_inter, beta1hat_inter, beta2hat_inter, beta3hat_inter = betahat_interaction
  votehat_inter = beta0hat_inter + beta1hat_inter*expendA+ beta2hat_inter*expendB + beta3hat_inter*expendAtimesB
  print('the beta0, beta1, beta2 and beta3 in the OLS regression from expendA and expendB and voteA with interachtion are:', beta0hat_inter, beta1hat_inter, beta2hat_inter, beta3hat_inter)

  plt.scatter(expendA, voteA)
  plt.scatter(expendB, voteB)
  plt.plot(expendA, votehatA)
  plt.plot(expendB, votehatB)
  plt.xlabel("expend")
  plt.ylabel("vote")
  plt.legend(["OLSexpendA","OLSexpendB"])
  plt.show()


  fig = plt.figure()
  ax = fig.add_subplot(projection='3d')
  ax.scatter(expendA, expendB, voteA, 'b')
  ax.plot(expendA, expendB, voteABhat, 'g')
  ax.plot(expendA, expendB, votehat_inter, 'r')
  ax.set_xlabel("expendA")
  ax.set_ylabel("expendB")
  ax.set_zlabel("voteA")
  plt.legend(["OLS whithout interaction", "OLS with interaction", "true points, expendA,B and voteA"])
  plt.show()

def share(shareA, shareB, voteA, voteB):
  
  beta0hatAshare, beta1hatAshare = OLSregression(shareA, voteA)
  beta0hatBshare, beta1hatBshare = OLSregression(shareB, voteB)
  print('the beta0 and beta1 in the OLS regression from shareA and voteA are:', beta0hatAshare, beta1hatAshare)
  print('the beta0 and beta1 in the OLS regression from shareB and voteB are:', beta0hatAshare, beta1hatAshare)
  votehatAshare = beta0hatAshare + beta1hatAshare*shareA
  votehatBshare= beta0hatBshare + beta1hatBshare*shareB
  
  
  
  plt.scatter(shareA, voteA)
  plt.scatter(shareB, voteB)
  plt.plot(shareA, votehatAshare)
  plt.plot(shareB, votehatBshare)
  plt.legend(["OLSshareA", "OLSshareB"])
  plt.xlabel("share")
  plt.ylabel("vote")
  plt.show()
 
    
def main():
  data3a = pd.read_excel (r'data3a.xls', names=["state", "district","democA","voteA",
                                                "expendA","expendB","prtystrA","lexpendA", "lexpendB", "shareA"])
  
  print(data3a[["expendA", "expendB", "voteA", "shareA"]].describe())
  
  expendA = data3a["expendA"]
  expendB = data3a["expendB"]
  expendAB = data3a[["expendA", "expendB"]]
  expendAtimesB = expendA*expendB
    
  voteA = data3a["voteA"]
  voteB = 100 - data3a["voteA"]
  shareA = data3a["shareA"]
  shareB = 100 - data3a["shareA"]
  
  expend(expendA, expendB, expendAB, expendAtimesB, voteA, voteB)
  share(shareA, shareB, voteA, voteB)
  


###########################################################
### call main
if __name__ == "__main__":
    main()
