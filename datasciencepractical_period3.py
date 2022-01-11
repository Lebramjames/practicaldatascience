import numpy as np
import pandas as pd
import scipy as sc
import math 
import matplotlib.pyplot as plt


#Notes Columns:
"""
  1. state                    state postal code
  2. district                 congressional district
  3. democA                   =1 if A is democrat
  4. voteA                    percent vote for A
  5. expendA                  campaign expends. by A, $1000s
  6. expendB                  campaign expends. by B, $1000s
  7. prtystrA                 % vote for president
  8. lexpendA                 log(expendA)
  9. lexpendB                 log(expendB)
 10. shareA                   100*(expendA/(expendA+expendB))
"""

#Question 1:
"""

1. you wonder whether you should take just the expenditures of A into account or 
2. rather a measure of how much the political party spends relative to the other. 

Would it be possible to include both? Or would this lead to a problem of collinearity?

"""



def descriptives(data, title, xlabel, ylabel):
    #histogram
    data.plot(kind = 'hist', alpha=0.6, bins=15, grid=True, title = title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.show()
    
    #descriptive statistics
    print(data.describe())
    
    return


def lnregression(data):
    train_data = data[:-20]
    test_data = data[-20:]
    
    print('Test:', test_data)
    print('Train: ', train_data)
    
    
    


def main():
    
    #reading data: 
    dataColumns = ['state','district', 'democA', 'voteA', 'expendA', 'expendB', 'prtystrA', 'lexpendA', 'lexpendB', 'shareA']
    df = pd.read_excel(r'C:\Users\bramg\Documents\data3a.xls', header=None, names=dataColumns)
   
    #descriptive
    #descriptives(df.iloc[:,4:6],'Histogram Expenditure A and B', 'Amount Spended', 'Quantity')
    
    
    vX = df.iloc[:,5].values.reshape(1,-1)
    lnregression(vX)



if __name__ =='__main__':
    main()
    
