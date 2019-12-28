library(tidyverse)
library(broom)
library(HistData)
data("GaltonFamilies")
data("admissions")
set.seed(1, sample.kind = "Rounding")


# Confounders are the most likely reason for associations to be misinterpreted

# If X and Y are correl., Z would be a confounder if changes in Z resulted in changes in both X and Y

# Example: The confounding effect of HRs on the correl. b/w BBs and Rs

# It is not always possible to us linear models to account for confounders (as we have previously)


# Data from 1973 showed that more men were admitted to UC Berkeley than women (44% vs. 30% of applicants)
admissions %>% group_by(gender) %>% 
  summarize(percentage =
              round(sum(admitted * applicants) / sum(applicants), 1))

# A tibble: 2 x 2
# gender   percentage
# <chr>       <dbl>
#  men        44.5
#  women      30.3

# Indeed, the chi-squared test rejects the hypothesis that gender and admissions are independent
admissions %>% group_by(gender) %>% 
  summarize(total_admitted = round(sum(admitted / 100 * applicants)),
            not_admitted = sum(applicants) - sum(total_admitted)) %>% 
  select(-gender) %>% 
  do(tidy(chisq.test(.)))

# A tibble: 1 x 4
# statistic p.value parameter method                    
# <dbl>    <dbl>     <int>     <chr>                     
#  91.6   1.06e-21     1   Pearson's Chi-squared

# HOWEVER, looking at addmissions per major we find a paradoxical result
admissions %>% select(major, gender, admitted) %>% 
  spread(gender, admitted) %>% 
  mutate(women_minus_men = women - men)

# major  men women    women_minus_men
#   A    62    82         20
#   B    63    68          5
#   C    37    34         -3
#   D    33    35          2
#   E    28    24         -4
#   F     6     7          1

# 4 out of the 6 majors favor women
# The paradox: analyzing totals suggests a dependence b/w admissions and gender
#              but when grouped by major, the dependence seems to disappear

# This paradox occurs if an uncounted confounder is driving most of the variability

# Lets define 3 vars:
# X: 1 for men, 0 for women
# Y: 1 for admitted, 0 for rejected
# Z: selectivity of major (a proportion)

# The existance of gender bias: Pr(Y = 1 | X = 1) > Pr(Y = 1 | X = 0)
# But Z is an important confounder: Z is associated w/ Y b/c 
# the more selective the major, the lower the prob that someone is admitted to the major

# The question now is, is major selectivity (Z) associated w/ gender (X)?

# One way to check: plot % total admitted to a major vs. % of women that make up applicants
admissions %>% 
  group_by(major) %>% 
  summarize(major_selectivity = sum(admitted * applicants) / sum(applicants),
            percent_women_applicants = sum(applicants * (gender=="women")) /
              sum(applicants) * 100) %>%
  ggplot(aes(major_selectivity, percent_women_applicants, label = major)) +
  geom_text()
# There appears to be an association: Plot suggests women were more likely to apply to the 2 more selective majors E & C
# Also, the % of female applicants for the least selective majors (A & B) were far lower than male applicants to those majors (less than 30% of applicants were female)

# This plot shows % of applicants that were accepted by gender
admissions %>% 
  mutate(percent_admitted = admitted * applicants / sum(applicants)) %>% 
  ggplot(aes(gender, y = percent_admitted, fill = major)) +
  geom_bar(stat = "identity", position = "stack")
# The above plot shows that a majority of majors for men came from 2 majors A & B.
# Also lets us see that few women applied to these two majors

# This plot shows number of applicants admitted and not
admissions %>%
  mutate(yes = round(admitted/100*applicants), no = applicants - yes) %>%
  select(-applicants, -admitted) %>%
  gather(admission, number_of_students, -c("major", "gender")) %>%
  ggplot(aes(gender, number_of_students, fill = admission)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(. ~ major)

# This plot shows % admitted per major, i.e % admitted stratified by major
admissions %>% 
  ggplot(aes(major, admitted, col = gender, size = applicants)) +
  geom_point()
# W/ the above plot we see that the % admitted by major is much more even than first thought
# By stratifying by major the confounding effect of Z on Y goes away

# Mathematically, stratifying by major, calculating diff. and then avg
# we find that the percent difference is pretty small
admissions %>% group_by(gender) %>% summarize(average = mean(admitted))

# A tibble: 2 x 2
# gender average
# <chr>    <dbl>
# men       38.2
# women     41.7


# The above is an example of "Simpson's paradox"

