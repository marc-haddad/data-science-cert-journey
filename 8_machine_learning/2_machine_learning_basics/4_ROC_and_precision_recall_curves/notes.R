library(ggrepel)

# Earlier we compared 2 methods (guessing vs height cutoff),
# while we considered multiple approaches for height cutoff, we only tackled one approach for guessing (p = 0.5)

# To see the difference b/w diff. approaches for diff. models, we use Receiver Operating Characteristic (ROC) curve
# The ROC curve helps us graphically see the benefits of one model over the other at various levels of approach.

# ROC curve is a plot of sensitivity (TPR) vs 1 - specificity (AKA False Positive Rate (FPR))

# ROC curve for guessing method:
probs = seq(0, 1, length.out = 10)
n = length(test_index)
guessing = map_df(probs, function(p) {
  y_hat = sample(c("Male", "Female"), n, replace = TRUE, prob = c(p, 1-p)) %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Guessing",
       FPR = 1 - specificity(y_hat, test_set$sex),
       TPR = sensitivity(y_hat, test_set$sex))
})
guessing %>% qplot(FPR, TPR, data = ., xlab = "1 - Specificity", ylab = "Sensitivity")

# ROC curve for cutoff method:
cutoffs = c(50, seq(60, 75), 80)
height_cutoff = map_df(cutoffs, function(x) {
  y_hat = ifelse(test_set$height > x, "Male", "Female") %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Height cutoff",
       FPR = 1 - specificity(y_hat, test_set$sex), 
       TPR = sensitivity(y_hat, test_set$sex))
})
height_cutoff %>% qplot(FPR, TPR, data = ., xlab = "1 - Specificity", ylab = "Sensitivity")

# Plot both ROC curves and compare:
bind_rows(guessing, height_cutoff) %>% 
  ggplot(aes(FPR, TPR, color = method)) +
  geom_line() +
  geom_point() +
  xlab("1 - Specificity") +
  ylab("Sensitivity")
# The above plot shows that for all values of sens., the cutoff method has a higher speci.

# Also, it is generally helpful to label points in ROC curves
map_df(cutoffs, function(x) {
  y_hat = ifelse(test_set$height > x, "Male", "Female") %>% 
    factor(levels = c("Female", "Male")) 
    list(method = "Height cutoff",
         cutoff = x,
         FPR = 1 - specificity(y_hat, test_set$sex),
         TPR = sensitivity(y_hat, test_set$sex))
}) %>% 
  ggplot(aes(FPR, TPR, label = cutoff)) +
  geom_line() +
  geom_point() +
  geom_text_repel(nudge_x = 0.01, nudge_y = -0.01)


# ROC curve weakness: Neither methods plotted depend on prevalence
# In cases in which prevalence matters we should make a Precision-Recall plot
guessing = map_df(probs, function(p) {
  y_hat = sample(c("Male", "Female"), n, replace = TRUE, prob = c(p, 1 - p)) %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Guess",
       recall = sensitivity(y_hat, test_set$sex),
       precision = precision(y_hat, test_set$sex))
})

height_cutoff = map_df(cutoffs, function(x) {
  y_hat = ifelse(test_set$height > x, "Male", "Female") %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Height cutoff",
       recall = sensitivity(y_hat, test_set$sex),
       precision = precision(y_hat, test_set$sex))
})

# Combine recall-precision plots
bind_rows(guessing, height_cutoff) %>% 
  ggplot(aes(recall, precision, color = method)) +
  geom_point() +
  geom_line() +
  ylim(c(0, 1))




