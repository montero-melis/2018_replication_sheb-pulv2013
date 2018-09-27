Notes on power analysis
=======================

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
