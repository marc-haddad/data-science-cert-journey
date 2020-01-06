> *“The most common reason for not being able to build perfect
> \[predictive\] algorithms is that it is impossible”* -Dr. Rafa
> Irizarry

Observations with the same observed values for predictors may not be the
same (e.g. female with height 66 in., and male with height 66 in.; same
height, different category).

However, we can assume that the observations have the same probability
of being one category or another (e.g. 40% chance of having 66 in.
female, 60% chance of having 66 in. male).

Mathematically represented as:

(*X*<sub>1</sub> = *x*<sub>1</sub>, *X*<sub>2</sub> = *x*<sub>2</sub>, ..., *X*<sub>*p*</sub> = *x*<sub>*p*</sub>)

for **observed values**
(*x*<sub>1</sub>, ..., *x*<sub>*p*</sub>)
 of **covariates**
(*X*<sub>1</sub>, ..., *X*<sub>*p*</sub>)
.

We denote the conditional probabilities of each class
*k*
:

*P**r*(*Y* = *k* | *X*<sub>1</sub> = *x*<sub>1</sub>, *X*<sub>2</sub> = *x*<sub>2</sub>, ..., *X*<sub>*p*</sub> = *x*<sub>*p*</sub>)
  
for
*k* = (1, ..., *K*)
.

We use bold letters to write out all the predictors like this:

**X** = (*X*<sub>1</sub>, ..., *X*<sub>*p*</sub>)
 and  
**x** = (*x*<sub>1</sub>, ..., *x*<sub>*p*</sub>)
.

The conditional probability of being in class
*k*
 is:

*p*<sub>*k*</sub>(**x**) = Pr (*Y* = *k* | **X** = **x**)
 for
*k* = (1, ..., *K*)
.

For any set of predictors
**X**
 we will predict the class
*k*
 with the largest probability among
*p*<sub>1</sub>(*x*), *p*<sub>2</sub>(*x*), ..., *p*<sub>*K*</sub>(*x*)
  
Which can be written as:

*Ŷ* = max<sub>*k*</sub>*p*<sub>*k*</sub>(**x**)

However, we can’t compute the above equation because we don’t know the
*p*<sub>*k*</sub>
 of
**x**
’s. This exemplifies the main challenge of Machine Learning: Estimating
these conditional probabilities.

The better our algorithm estimates
$$\\hat{p\_k}(\\mathbf{x})$$

the better our predictor
$$\\hat{Y}=\\max\_k \\hat{p\_k}(\\mathbf{x})$$

The quality of our prediction will depend on two things:

1.  How close the maximum probability
    max<sub>*k*</sub>*p*<sub>*k*</sub>(**x**)
     is to 1

2.  How close our estimate of the probabilities 
    $$\\hat{p\_k}(\\mathbf{x})$$
     are to the actual probabilities
    *p*<sub>*k*</sub>(**x**)

Because item 1 is determined by the nature of each problem, our best
option is to use item 2 to best estimate conditional probabilities.

Though it is our approach here, we must keep in mind that maximizing
probability is not always optimal in practice. Our approach depends on
context. **Sensitivity** and **Specificity** may differ in importance in
different contexts. But having a good estimate of conditional
probabilities is more often than not sufficient when building an optimal
prediction model due to the fact that we can control both sensitivity
and specificity.
