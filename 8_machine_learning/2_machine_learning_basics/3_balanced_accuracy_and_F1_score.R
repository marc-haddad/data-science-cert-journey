

# Balanced Accuracy: the avg of specificity and sensitivity; A metric that is generally preferred to accuracy 

# B/c speci. and sens. are rates, it is more appropriate to compute the harmonic avg of speci. and sens.:
# F1_score = 1 / (1/2 * (1/recall + 1/precision)), also written as:
# F1_score = 2 * precision * recall / (precision + recall)


# Diff. situations require diff. considerations of what to pay particular importance to.
# Ex: For airplane safety, it is more important to maximize sensitivity over specificity.
#     Failing to predict a plane will malfunction before it crashes (FN) is a much more costly error than grounding a plane that is in perfect condition (FP)
# Ex: In a capital murder case, it is more important to maximize specificity over sensitivity.
#     Incorrectly predicting the guiltiness of an innocent person (FP) is much more costly than letting an actual murderer go (FN)

# The F1 score can be altered to weigh sens. and speci. differently depending on the issue
# We do this by defining Beta as how much more important sens. is than speci.
# weighted_F1_score = 1 / ( (Beta^2/(1+Beta^2)*1/recall) + (1/(1+Beta^2)*1/precision) )

# F_meas() in caret computes the above summary, w/ Beta defaulting to 1


# Prediction algorithm rebuild, maximizing F score instead of overall accuracy:
cutoff = seq(61, 70)
F_1 = map_dbl(cutoff, function(x) {
  y_hat = ifelse(train_set$height > x, "Male", "Female") %>% 
    factor(levels = levels(test_set$sex))
  F_meas(data = y_hat, reference = factor(train_set$sex))
})
cutoff
df = data.frame(cutoff, F_1)
df %>% ggplot(aes(cutoff, F_1)) + geom_point() + geom_line()
max(F_1) # 0.614
best_cutoff = cutoff[which.max(F_1)]
best_cutoff # 66 (was 64 when maximizing for accuracy)

y_hat = ifelse(test_set$height > best_cutoff, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))
confusionMatrix(data = y_hat, reference = test_set$sex)
 
# Confusion Matrix and Statistics
# 
#         Reference
# Prediction Female Male
# Female     81   67
# Male       38  339
# 
# Accuracy : 0.8           
# 95% CI : (0.763, 0.833)
# No Information Rate : 0.773         
# P-Value [Acc > NIR] : 0.07819       
# 
# Kappa : 0.475         
# 
# Mcnemar's Test P-Value : 0.00629       
#                                         
#             Sensitivity : 0.681         
#             Specificity : 0.835         
#          Pos Pred Value : 0.547         
#          Neg Pred Value : 0.899         
#              Prevalence : 0.227         
#          Detection Rate : 0.154         
#    Detection Prevalence : 0.282         
#       Balanced Accuracy : 0.758         
#                                         
#        'Positive' Class : Female     

# By maximizing by F score our sens. and speci. are much more balanced than before

# Conclusion: This is my first ML algorithm; 
# It takes height as a predictor, and predicts that those w/ heights below 66 inches are going to be female.



# Addendum:
# Having a high sens. and speci. is not always the best choice,
# particularly when prevalence is close to either 0 or 1
# Ex: A Dr. specializes in rare disease. Wants to develop an algorithm to predict who has the disease.
#     An algorithm w/ high sens. means that: If patiant has disease, algorithm likely to predict correctly.
#     When given the data by Dr., you find the Pr(Y_hat = 1) = 0.5
# 
# In this case, it would be better to instead focus on speci. (i.e precision is more important than sensi.)
# Pr(Y = 1 | Y_hat = 1) is what is important.
# 
# Using Bayes' theorem for formula:
# Pr(Y = 1 | Y_hat = 1) = Pr(Y_hat = 1 | Y = 1) * Pr(Y = 1) / Pr(Y_hat = 1)

# Dr. knows that disease prevalence is 5 in 1000 (i.e Pr(Y = 1) = 0.0005)
# And remember: Y_hat from the dataset was 0.5. Therefore:
# Pr(Y = 1) / Pr(Y_hat = 1) = 0.0005 / 0.5 = 0.01

# Given that the calculated val above is going to be multiplied by a decimal,
# we can conclude that our precision is going to be < 0.01 and that our algorithm is shit.

