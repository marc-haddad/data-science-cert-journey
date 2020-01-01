library(caret)
library(dslabs)
library(tidyverse)
# Continues from 1_caret_pckg...

# Confusion Matrix tabulates each combo of prediction and actual val
table(predicted = y_hat, actual = test_set$sex)

#     predicted  actual
# Female     50   27
# Male       69  379

# Computing accuracy separately for each sex:
test_set %>% 
  mutate(y_hat = y_hat) %>% 
  group_by(sex) %>% 
  summarize(accuracy = mean(y_hat == sex))
# A tibble: 2 x 2
# sex    accuracy
# <fct>     <dbl>
# Female    0.420
# Male      0.933

# As the above shows, too many females were predicted to be male

# How can our overall accuracy be so high then? Prevalance.
# There are much more males in the datasets than females.
prev = mean(y == "Male")
prev # 77.3% of dataset is male

# This is a prob in ML b/c if your dataset is biased, then the developed algorithm will be biased as well
# This is why we look at other metrics when assessing an ML algorithm

# Metrics that are robust to prevalance are all derived from the confusion matrix

# Sensitivity and specificity must be studied separately
# Sens. and speci. are defined w/ a binary outcome
# When outcomes are categorical we can get these metrics for a specific category
# When measuring outcomes from a specific category
# we can represent positive outcomes as Y = 1, and negative as Y = 0

# Sensitivity is defined as the ability of an algorithm to predict a positive outcome when the actual outcome is positive. 
# When Y = 1, Y_hat = 1 

# An algorithm that calls everything positive (Y_hat always = 1 no matter what)
# Y_hat has perfect sensitivity, which isn't enough to evaluate an outcome. Thus, we need specificity.

# Specificity is the ability of an algorithm to NOT predict the positive (i.e. expected outcome Y_hat is 0 when actual outcome Y is 0):
# When Y = 0, Y_hat = 0

# High sens.: Y = 1 => Y_hat = 1 (note: fat arrow means "implies")

# High speci.: Y = 0 => Y_hat = 0

# Another way to define high speci.: proportion of positive predictions that are actually positive.
# Y_hat = 1 => Y = 1 (note how the Y's are reversed from the above def. of high speci.)


# We name the 4 entries of the confusion matrix:
c("Actually +", "Actually -")
c("Predicted +", "Predicted -")
conf_names = matrix(c("True Positives(TP)", "False Negatives(FN)", "False Positives(FP)", "True Negatives(TN)"), nrow = 2, ncol = 2)
rownames(conf_names) = c("Predicted +", "Predicted -")
colnames(conf_names) = c("Actually +", "Actually -")
conf_names

#                 Actually+             Actually-           
# Predicted+  "True Positives(TP)"  "False Positives(FP)"
# Predicted-  "False Negatives(FN)" "True Negatives(TN)" 

# Note: The above plot took WAY TOO MUCH TIME to get to print correctly... Good heavens...
# Better method I just discovered: table(y_hat, y) ... f my life

# Sensitivity = TP / (TP + FN)
# Sens. is the proportion of correctly called Positives divided by total num of actual Positives (which includes False Negatives)
# The above ratio is also known as the True Positive Rate (TPR) or Recall

# Specificity = TN / (TN + FP)
# Speci. is the proportion of correctly called Negatives divided by total num of actual Negatives (which includes False Positives)
# The above ratio is also known as the True Negative Rate (TNR)

# However, as mentioned earlier, there is a second way to calc Speci.
# Specificity = TP / (TP + FP)
# Speci. is the proportion of correctly called Positives divided by total num of PREDICTED Positives (which includes False Positives)
# The above ratio is reffered to as Positive Predictive Value (PPV), or simply as Precision

# Note that precision depends on the prevalance, b/c higher prevalance implies you can get higher precision even when guessing


# Here is a handy chart (oh God, not again...):
A_MEASURE_OF = c("Sensitivity", "Specificity1", "Specificity2")
NAME_1 = c("True Positive Rate(TPR)", "True Negative Rate(TNR)", "Positive Predictive Value(PPV)")
NAME_2 = c("Recall", "1 minus False Positive Rate(1-FPR)", "Precision")
DEFINITION = c("TP/(TP+FN)", "TN/(TN+FP)", "TP/(TP+FP)")
PROBABILITY_REP = c("Pr(Y_hat=1|Y=1)", "Pr(Y_hat=0|Y=0)", "Pr(Y=1|Y_hat=1)")
data.frame(A_MEASURE_OF, NAME_1, NAME_2, DEFINITION, PROBABILITY_REP)

# A_MEASURE_OF                         NAME_1        NAME_2   DEFINITION   PROBABILITY_REP
# Sensitivity           True Positive Rate(TPR)      Recall   TP/(TP+FN)   Pr(Y_hat=1|Y=1)
# Specificity1          True Negative Rate(TNR)     (1-FPR)   TN/(TN+FP)   Pr(Y_hat=0|Y=0)
# Specificity2   Positive Predictive Value(PPV)   Precision   TP/(TP+FP)   Pr(Y=1|Y_hat=1)


# confusionMatrix() computes all of the above once we define what a positive is
# The func expects factors as inputs w/ the first one being the positive outcome Y = 1
confusionMatrix(data = y_hat, reference = test_set$sex)

# Confusion Matrix and Statistics
# 
#            Reference
# Prediction Female Male
# Female     50   27
# Male       69  379
# 
# Accuracy : 0.817         
# 95% CI : (0.781, 0.849)
# No Information Rate : 0.773         
# P-Value [Acc > NIR] : 0.00835       
# 
# Kappa : 0.404         
# 
# Mcnemar's Test P-Value : 2.86e-05      
#                                         
#             Sensitivity : 0.4202        
#             Specificity : 0.9335        
#          Pos Pred Value : 0.6494        
#          Neg Pred Value : 0.8460        
#              Prevalence : 0.2267        
#          Detection Rate : 0.0952        
#    Detection Prevalence : 0.1467        
#       Balanced Accuracy : 0.6768        
#                                         
#        'Positive' Class : Female 


# Notice that despite the relatively low sensitivity (0.42) our prediction accuracy is high (0.82);
# This is due to the fact that the higher number of FNs (i.e higher num of women incorrectly predicted to be men) does not negatively impair total accuracy b/c of a low prevalence of females (0.23)



