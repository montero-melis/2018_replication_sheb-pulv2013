## Power analysis: Simulate Poisson-distributed data, fit models and extract
## model estimate for effect of interest

## CHECK OUT (Zach Burchill's suggestions):
# Simulations and nested dataframes
# https://jofrhwld.github.io/blog/2016/05/01/many_models.html
# purrr::map()
# https://jennybc.github.io/purrr-tutorial/index.html
# General workflow and good practice (by D Kleinschmidt):
# http://www.davekleinschmidt.com/r-packages/



library("mvtnorm")
library("lme4")
library("ggplot2")
library("plyr")
library("dplyr")
library("purrr")


#  ------------------------------------------------------------------------
#  Check folder structure and create paths for input/output
#  ------------------------------------------------------------------------

# NB: Script is written to be sourced from the Rproject in the root directory
# of the git project. All paths are relative to that root! (I.e., things will
# not work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"

# path to the raw data files to be processed
path_in <- "1812_pre-reg_replication/power-analysis"
if (! dir.exists(path_in)) stop("Path to input folder doesn't exist!")

# Create output folder if it doesn't yet exist
path_out <- file.path(path_in, "simulations")
if (! dir.exists(path_out)) dir.create(path_out)


#  ------------------------------------------------------------------------
#  Load coefficient and other parameter estimates from model fit to original data
#  ------------------------------------------------------------------------

# Shebani, the first author of the original study, shared the original data set
# but I agreed not to further share it. Here I load a list with the fixed effects
# coefficient estimates and the random effect parameters of a Poisson GLMM
# fit to the original data. 

# Contrast coding was used for both factors, as follows:
# 
# > contrasts(d_crit$Movement)
# arms_vs_legs
# arms            1
# legs           -1
# > contrasts(d_crit$WordType)
# armW_vs_legW
# arm-word            1
# leg-word           -1

# The model was specified as:
# 
# glmm_poi <- glmer(nbErrors ~ 1 + Movement * WordType + (1 + Movement * WordType | Subject),
#                   data = original_dataset, family = "poisson",
#                   control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=100000)))

# The output of the model was:

# > summary(glmm_poi)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: poisson  ( log )
# Formula: nbErrors ~ 1 + Movement * WordType + (1 + Movement * WordType |      Subject)
# Data: d_crit
# Control: glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e+05))
# 
# AIC      BIC   logLik deviance df.resid 
# 397.1    426.4   -184.5    369.1       46 
# 
# Scaled residuals: 
#   Min       1Q   Median       3Q      Max 
# -1.68516 -0.46864  0.06156  0.43853  1.45481 
# 
# Random effects:
#   Groups  Name                                      Variance  Std.Dev. Corr          
# Subject (Intercept)                               2.134e-01   0.461946               
# Movementarms_vs_legs                              3.090e-02   0.175788 0.25          
# WordTypearmW_vs_legW                              1.573e-03   0.039658 0.79 0.79     
# Movementarms_vs_legs:WordTypearmW_vs_legW         4.366e-05   0.006608 0.86 0.70 0.99
# Number of obs: 60, groups:  Subject, 15
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                                2.619681   0.125145  20.933   <2e-16 ***
# Movementarms_vs_legs                       0.005052   0.058905   0.086   0.9317    
# WordTypearmW_vs_legW                      -0.043961   0.038500  -1.142   0.2535    
# Movementarms_vs_legs:WordTypearmW_vs_legW  0.087994   0.037113   2.371   0.0177 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr) Mvmn__ WTW__W
# Mvmntrms_v_ 0.187               
# WrdTyprW__W 0.219  0.118        
# Mv__:WTW__W 0.016  0.063  0.015

# Note the interaction Movementarms_vs_legs:WordTypearmW_vs_legW (critical
# effect) is significant also in this analysis.


# Load model estimates from R-object saved to disk:
(load(file.path(path_in, "orig_data_model_estimates.RData")))
# Ecce! It's a list of 3 elements:
# 1) Estimates of fixed effects coefficients
# 2) Covariance matrix of the fixed effects
# 3) Covariance matrix of by-subject random effects
orig_data_model_coefficient_estimates

## Save components 1 and 3 as separate objects 
# (I won't use 2 - fixef_sigma, see email correspondence with F Jaeger on
# 2019-01-11, "Re: power analysis for replication study: dealing with 
# simulation parameters for which I don't have estimates")

# Fixed effect means
(my_fixef_means <- orig_data_model_coefficient_estimates[["fixef_means"]])
# Covariance of random by-subject adjustments (mean is zero)
(my_ranef_sigma <- orig_data_model_coefficient_estimates[["ranef_sigma"]])


#  ------------------------------------------------------------------------
#  Complement with parameters for which we don't have estimates
#  ------------------------------------------------------------------------

# We want to estimate power also for the effect of Language (L1 Swedish /
# L2 English) and all its interactions with the other effects. However, we
# don't have estimates for all of these new parameters, because this factor
# wasn't part of the original study. For a detailed explanation of this issue:
# See email correspondence with F Jaeger on 2019-01-11, "Re: power analysis
# for replication study: dealing with simulation parameters for which I don't
# have estimates"

# Vector of means (i.e. fixed effects estimates):
# 1) *Main effect of language*: tells us how many more errors participants will
#    make overall in their L2 vs L1. We'll let the number vary between 3 plausible
#    values: 1.25, 1.625, 2 times the L1 coefficient (i.e., the intercept in the
#    original model). Note that we expect more errors in the L2 than in the L1.
#    Different values allow us to see how ceiling effects might come on. Ceiling
#    arises because there is a maximum number of errors that we can detect given
#    the paradigm. In the last step of the simulations, when we estimate the 
#    actual counts, we will choose this max number as a cutoff point above which
#    all simulated values are just equal to that cutoff point (?censored data?)
# 2) *Movement:Language* interaction: set to zero.
# 3) *WordType:Language* interaction: set to zero.
# 4) *Movement:WordType:Language* interaction: Choose values so that the L2
#    effect is either 100%, 67%, 33% or 0% of that in the L1.


## Specifying the coefficients

# We need a little bit of algebra to specify the estimates above in a model
# where factors are contrast coded (1 / -1):






#  ------------------------------------------------------------------------
#  Simulate Poisson-distributed data under model estimates + uncertainty (functions)
#  ------------------------------------------------------------------------

# Basic function to simulate Poisson-distributed data for the current design.
# For readability, this function is sourced from a different file; check out
# the source code for the details of its inner workings.
source("Rfunctions/simulate_poisson_data_fnc.R")

# The functions take as their default arguments the means and covariances from
# the model above: my_fixef_means, my_fixef_sigma, my_ranef_sigma.
# Example output for illustration
simulate_poisson()
# Change print_each_step parameter to TRUE to see intermediately created objects:
simulate_poisson(print_each_step = TRUE)  # prints out intermediate steps


# Convenience function to plot simulated data
plot_sim <- function(sim_data = NULL, show_indiv_data = TRUE) {
  pd <- position_dodge(0.2)
  p <- ggplot(sim_data, aes(x = Movement, y = nbErrors, colour = WordType)) +
    stat_summary(fun.data = "mean_cl_boot", position = pd) +
    stat_summary(fun.y=mean, geom="line", aes(group = WordType), position = pd)
  if (show_indiv_data) p <- p + geom_jitter(height = 0, width = .2, alpha = .5)
  p
}
# Examples
plot_sim(simulate_poisson(N = 15))
sim30 <- simulate_poisson(N = 30)
plot_sim(sim30, show_indiv_data = T)  # default
plot_sim(sim30, show_indiv_data = F)


# Wrapper function to *simulate many* data sets, calling simulate_poisson()
# through plyr::rdply. The three-dots syntax allows us to pass arguments
# to simulate_poisson(), which is critical:
poisson_sims <- function(n_sims = 1, ...) {
  out <- rdply(n_sims, simulate_poisson(...)) %>% rename(Sim = .n)
  out
}
# an example
(x <- poisson_sims(n_sims = 2))
# example with extreme fixed effects, just to showcase the use of 3-dot syntax
(extreme <- poisson_sims(n_sims = 1, N = 20, fixef_means = c(6,-.05,.05,1)))
plot_sim(extreme)
rm(x, extreme)


#  ------------------------------------------------------------------------
#  Fit models on simulated data sets (functions)
#  ------------------------------------------------------------------------

# Basic function to *fit* Poisson GLMM model to each simulated (Sim) data set.
# Takes as its input the output of poisson_sims()
fit_poi_glmm <- function(sim_data = NULL) {
  # fit models using dplyr::do (https://dplyr.tidyverse.org/reference/do.html)
  fitted <- sim_data %>% group_by(Sim) %>%
    do(fm = glmer(
      nbErrors ~ 1 + Movement * WordType + (1 + Movement * WordType | Subject),
      data = ., family = "poisson", control = 
        glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=100000)))
      )
}
# For instance:
(fit_poi_glmm(poisson_sims(n_sims = 2)))


#  ------------------------------------------------------------------------
#  Define manipulated parameters for the simulations
#  ------------------------------------------------------------------------

# The parameters we want to manipulate are: 
# - effect size (as factor of the original), and
# - number of participants (N)

# Entertain different effect sizes for *interaction* estimate (parameter of 
# interest): 
my_fixef_means  # original fixed effects estimates
vary_effectsize <- function(factor = NULL, orig = my_fixef_means) {
  orig[4] <- orig[4] * factor
  orig
}
(orig_effsize <- vary_effectsize(1))
(orig_effsize.75 <- vary_effectsize(.75))
(orig_effsize.5 <- vary_effectsize(.5))
(orig_effsize.25 <- vary_effectsize(.25))
(orig_effsize.0 <- vary_effectsize(0))

# *list* of manipulated parameters
(params <- list(
  my_effectsize = list(
    "orig" = orig_effsize,
    "orig.75" = orig_effsize.75,
    "orig.5" = orig_effsize.5,
    "orig.25" = orig_effsize.25,
    "orig.0" = orig_effsize.0),
  my_N = c(seq(15, 60, 15), 50)))  # N = 15,30,45,60 + 50


#  ------------------------------------------------------------------------
#  Fit models on differently parametrized simulations and save to disk
#  ------------------------------------------------------------------------

# We want a function that fits models on differently parametrized simulations.
# Because this is time consuming, we want the result to be saved to disk and
# we want to be able to add new simulations if we run the functions on different
# occasions. Source it (see source code to understand its inner mysteries):
source("Rfunctions/fit_many_poisson_fnc.R")

############## Different ways to run the function ###############

# NB: Be careful with what you run below. The parameters are set so that
# not much harm can be done. E.g., "save_to_disk = FALSE" makes sure
# the simulations are not saved to disk. The "fitAnew = TRUE" prevents
# the function from loading the saved object (which can be large and take
# much time to load).

# Run following to add more simulations -- adjust nbSims argument
my_poisson_sims <- fit_many_poisson(
  parameterList = params, nbSims = 2,
  loadOnly = FALSE, print_each_step = TRUE,
  save_to_disk = FALSE, fitAnew = TRUE)

# To run the simulations in batches and saving back after each run
for (thisrun in 1:2) {
  print(paste("this is run:", thisrun))
  
  my_poisson_sims <- fit_many_poisson(
    parameterList = params, nbSims = 1,
    loadOnly = FALSE, 
    print_each_step = TRUE,
    save_to_disk = FALSE, fitAnew = TRUE)
  
  # how many?
  my_poisson_sims %>%
    ungroup() %>%
    group_by(N, effect_size) %>%
    summarise(nbSims = n()) %>%
    print(., n = 30)
}

# Run the following to just load existing (previously saved) simulations
# This is benign (it will fail if no file has been saved on disk)
my_poisson_sims <- fit_many_poisson(params, loadOnly = TRUE)

# check it out
head(my_poisson_sims, 22)
tail(my_poisson_sims, 30)
nrow(my_poisson_sims)
my_poisson_sims %>%
  ungroup() %>%
  group_by(N, effect_size) %>%
  summarise(nbSims = n()) %>%
  print(., n = 30)


#  ------------------------------------------------------------------------
#  Extract useful model summaries and save to disk
#  ------------------------------------------------------------------------

# The function I'm sourcing relies on the broom::tidy function. It extracts
# parameter estimates from model summaries and saves them to disk. Or it can
# just read those estimates from a data file if they were previously saved.
source("Rfunctions/load-or-extract_model-summaries.R")

# Change extract_anew to TRUE if there are new models to summarize
simul_summaries <- load_or_extract_summaries(
  extract_anew = FALSE,
  filename_load = file.path(path_out, "poisson_sim_summaries_fixed-interactions.csv"),
  filename_save = NULL,
  my_simulations = my_poisson_sims
)
head(simul_summaries)


#  ------------------------------------------------------------------------
#  Where's the power Lebowsky?
#  ------------------------------------------------------------------------

# Distribution of t-values for the different model specifications

# Keep only data rows for critical interactions
simul_summaries_interact <- simul_summaries %>% 
  filter(term == "Movementlegs:WordTypeleg-word")
simul_summaries_interact$effect_size <- factor(simul_summaries_interact$effect_size,
                                               levels = c("orig", "orig.75", "orig.5", "orig.25", "orig.0"))
# plot
simul_summaries_interact %>%
  ggplot(aes(x = statistic, colour = factor(N), linetype = factor(N))) +
  facet_wrap(~effect_size) +
  geom_density() +
  geom_vline(xintercept = 1.96)

# Compute the proportion of significant models:
simul_summaries_interact %>% 
  group_by(effect_size, N) %>%
  mutate(signif = statistic > 1.96) %>%
  summarise(Power = round(100 * sum(signif) / n(), 2),
            nbSimulations = n())
