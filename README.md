# VADataMining3PracticalWork

## Predicting Housing Median Prices:
The file BostonHousing.csv contains information on over 500 census tracts in Boston, where 
for each tract multiple variables are recorded. The last column (CAT.MEDV) was derived from 
MEDV, such that it obtains the value 1 if MEDV > 30 and 0 otherwise. Consider the goal of 
predicting the median value (MEDV) of a tract, given the information in the first 12 columns. 


### TASKS:
- Perform a k-NN prediction with all 12 predictors (ignore the CAT.MEDV column), 
trying values of k from 1 to 5. Make sure to normalize the data, and choose function knn() 
from package class rather than package FNN. To make sure R is using the class package 
(when both packages are loaded), use class::knn(). What is the best k? What does it mean?
- Predict the MEDV for a tract with the following information, using the best k:
CRIM ZN INDUS CHAS NOX RM AGE DIS RAD TAX PTRATIO LSTAT
0.2 0 7 0 0.538 6 62 4.7 4 307 21 10
- If we used the above k-NN algorithm to score the training data, what would be the 
error of the training set?
- Why is the validation data error overly optimistic compared to the error rate when 
applying this k-NN predictor to new data?
- If the purpose is to predict MEDV for several thousands of new tracts, what would be 
the disadvantage of using k-NN prediction? List the operations that the algorithm goes 
through in order to produce each prediction.

## Classification of Firewall Activities and Rule Assignment:
The file Firewall_Rule_Classification.csv contains information on over 260K firewall activities 
records. Consider the goal of predicting the rule class (Class) value, given the information in 
the first 12 columns. 

### TASKS:
- Preprocess data if/as needed (i.e. perform accordant pre-processing checks/steps 
including visualizing some views of data set). Determine how many (e.g. X) different Class 
values are there in the data set. Find X records with different Class values and remove them 
from the main data set. Save these X records for later processing.
- Perform a k-NN prediction with all 12 predictors, trying values of k from 1 to 15. Make 
sure to normalize the data, and choose function knn() from package FNN. What is the best k? 
What does it mean?
- For later determined X records (i.e. see 3.2.1.1) separately for each one predict the 
Class, using the best k (i.e. see 3.2.1.2).

Record / document all the steps (i.e. R code) you perform.