
library(tidyverse)
library(Lahman)
dat = Teams %>% filter(yearID %in% 1961:2001) %>% 
  mutate(HR = round(HR / G, 1),
         BB = BB / G,
         R = R / G) %>% 
  select(HR, BB, R) %>% 
  filter(HR >= 0.4 & HR <= 1.2)
# do() func is a bridge b/w Base R funcs and tidyverse library
# do() understands grouped tibbles and always returns a df (like all funcs in tidyverse)

# Using do() w/ lm()
dat %>% 
  group_by(HR) %>% 
  do(fit = lm(R ~ BB, data = .))
# # A tibble: 9 x 2
#    HR    fit   
# * <dbl> <list>
#   0.4   <lm>  
#   0.5   <lm>  
#   0.6   <lm>  
#   0.7   <lm>  
#   0.8   <lm>  
#   0.9   <lm>  
#   1     <lm>  
#   1.1   <lm>  
#   1.2   <lm> 

# The above formula returned a tibble w/ a col containing lm() objects w/in its cells
# Not very useful because we can't see the vals.

# We can write a func that returns a df so that our tibble will display and act correctly
get_slope = function(data) {
  fit = lm(R ~ BB, data = data)
  data.frame(slope = fit$coefficients[2],
             se = summary(fit)$coefficient[2, 2])
}

# Now we can use the do() func to get the expected result
dat %>% group_by(HR) %>% 
  do(get_slope(.))
# A tibble: 9 x 3
# Groups:   HR [9]
# HR    slope   se
# <dbl> <dbl>  <dbl>
# 0.4  0.734  0.208 
# 0.5  0.566  0.110 
# 0.6  0.412  0.0974
# 0.7  0.285  0.0705
# 0.8  0.365  0.0653
# 0.9  0.261  0.0754
# 1    0.511  0.0749
# 1.1  0.454  0.0855
# 1.2  0.440  0.0801



# do() also returns dfs w/ multiple rows, the rows will be concatenated appropriately
get_lse = function(data) {
  fit = lm(R ~ BB, data = data)
  data.frame(term = names(fit$coefficients),
             slope = fit$coefficients,
             se = summary(fit)$coefficient[,2])
}
dat %>% 
  group_by(HR) %>% 
  do(get_lse(.))
# A tibble: 18 x 4
# Groups:   HR [9]
#      HR    term       slope   se
#     <dbl> <fct>       <dbl>  <dbl>
# 1   0.4 (Intercept) 1.36    0.631 
# 2   0.4 BB          0.734   0.208 
# 3   0.5 (Intercept) 2.01    0.344 
# 4   0.5 BB          0.566   0.110 
# 5   0.6 (Intercept) 2.53    0.305 
# 6   0.6 BB          0.412   0.0974
# 7   0.7 (Intercept) 3.21    0.225 
# 8   0.7 BB          0.285   0.0705
# 9   0.8 (Intercept) 3.07    0.213 
# 10  0.8 BB          0.365   0.0653
# 11  0.9 (Intercept) 3.54    0.252 
# 12  0.9 BB          0.261   0.0754
# 13  1   (Intercept) 2.88    0.255 
# 14  1   BB          0.511   0.0749
# 15  1.1 (Intercept) 3.21    0.300 
# 16  1.1 BB          0.454   0.0855
# 17  1.2 (Intercept) 3.40    0.291 
# 18  1.2 BB          0.440   0.0801



# The "broom" library will help simplify the process outlined above



