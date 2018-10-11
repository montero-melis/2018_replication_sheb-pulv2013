Notes on power analysis
=======================


Qs
---

- What to do about model convergence failures? (difficult to track them)
- What is a pragmatic approach?
- Generative model vs modelling mean cells?
- But how to choose the model, i.e. how to model the error data?
- I would prefer model based on binary data (per verb) bc it allows us to model
item (=verb) variability, which is not possible if we assume Normal or Poisson...
- In LRT, comparing 2 models to test the significance of an interaction, how does
one specify the random effects structure? Always with interaction if possible?


Notes
-----

Following thread might be of interest for generating overdispersed data from
a Poisson distribution:
https://stat.ethz.ch/pipermail/r-help/2002-June/022425.html


A snippet of code to generate Poisson distributed data with a mean as reported
for one of the conditions in S&P:

sim_pois <- rpois(15, 16.5)
mean(sim_pois)
sd(sim_pois)

lapply(1:5, function(x) rpois(n = 15, lambda = 16.5))
sapply(1:5, function(x) rpois(n = 15, lambda = 16.5))

apply(sapply(1:50, function(x) rpois(n = 15, lambda = 16.5)),
      2, mean)

mean(apply(sapply(1:500, function(x) rpois(n = 15, lambda = 16.5)),
      2, sd))
