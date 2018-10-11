## Simulate Poisson-distributed data and fit models to gauge power

library("mvtnorm")
library("lme4")
library("ggplot2")
library("plyr")
library("dplyr")


#  ------------------------------------------------------------------------
#  Check folder structure and create paths for input/output
#  ------------------------------------------------------------------------

# NB: Script is written to be sourced from the Rproject in the root directory
# of the git project. All paths are relative to that root! (I.e., things will
# not work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"

# path to the raw data files to be processed
path_in <- "1810_replication-natives_analysis/power-analysis"
if (! dir.exists(path_in)) stop("Path to input folder doesn't exist!")

# Create output folder if it doesn't yet exist
path_out <- file.path(path_in, "simulations")
if (! dir.exists(path_out)) dir.create(path_out)


#  ------------------------------------------------------------------------
#  Load coefficient and parameter estimates from model fit to original data
#  ------------------------------------------------------------------------

# Shebani, the first author of the original study, shared the original data set
# but I agreed not to further share it. Here I load a list with the fixed effects
# coefficient estimates and the random effect parameters of a Poisson GLMM
# fit to the original data. The model was specified as
# 
# glmm_poi <- glmer(nbErrors ~ 1 + Movement * WordType + (1 + Movement * WordType | Subject),
#                   data = original_dataset, family = "poisson",
#                   control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=100000)))
# 
# The output of the model was:
# 
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
# Subject (Intercept)                               2.134e-01 0.461946               
# Movementarms_vs_legs                      3.090e-02 0.175788 0.25          
# WordTypearmW_vs_legW                      1.573e-03 0.039658 0.79 0.79     
# Movementarms_vs_legs:WordTypearmW_vs_legW 4.366e-05 0.006608 0.86 0.70 0.99
# Number of obs: 60, groups:  Subject, 15
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                                2.619681   0.125145  20.933   <2e-16 ***
#   Movementarms_vs_legs                       0.005052   0.058905   0.086   0.9317    
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
# 
# Note the interaction (critical effect) is significant also in this analysis.

# Load model estimates from R-object saved to disk:
(load(file.path(path_in, "orig_data_model_estimates.RData")))
orig_data_model_coefficient_estimates

# Fixed effect means
(my_fixef_means <- orig_data_model_coefficient_estimates[["fixef_means"]])
# Covariance of fixed effects estimates
(my_fixef_sigma <- orig_data_model_coefficient_estimates[["fixef_sigma"]])
# Covariance of random by-subject adjustments (mean is zero)
(my_ranef_sigma <- orig_data_model_coefficient_estimates[["ranef_sigma"]])


#  ------------------------------------------------------------------------
#  Function to simulate Poi-distributed data under model estimates + uncertainty
#  ------------------------------------------------------------------------

# Simulate Poisson-distributed data for the current design
simulate_poisson <- function (
  N = 3,  # Number of participants
  fixef_means  = my_fixef_means,  # vector of mean estimates for fixed effects
  fixef_sigma  = my_fixef_sigma,  # covariance matrix for fixed effects estimates
  ranef_sigma  = my_ranef_sigma,   # covariance matrix for random effects (by-subject only)
  print_each_step = FALSE  # print output at each step to unveil inner workings
  ) {
  
  myprint <- function(x) {
    if (print_each_step) { 
      cat("\n"); print(paste("This is ", deparse(substitute(x)))); cat("\n")
      print(x)}}
  
  # 0) create design matrix X for experiment
  myfactors <- data.frame(Movement = factor(rep(c("arms", "legs"), each = 2)),
                          WordType = factor(c("arm-word", "leg-word")))
  contrasts(myfactors$Movement) <- contr.sum(2)
  contrasts(myfactors$WordType) <- contr.sum(2)
  X <- model.matrix(~ 1 + Movement * WordType, myfactors)
  myprint(X)
  
  # 1) Fixed effects for current simulation
  fixef <- rmvnorm(n = 1,  # One simulation
                   mean = fixef_means,  # The mean of fixed effects
                   sigma = fixef_sigma) # covariance of fixed effects
  myprint(fixef)
  
  # 2) By-subject adjustments (multivariate normal with mean zero)
  # Each matrix row gives subject adjustments for betas of the 4 predictors in X
  sbj_adjust <- rmvnorm(n = N,
                        mean = rep(0, ncol(ranef_sigma)),
                        sigma = ranef_sigma)
  myprint(sbj_adjust)
  
  # 3) Obtain by-subject coefficients by combining steps 1 and 2
  sbj_coef <- sbj_adjust + rep(fixef, each = nrow(sbj_adjust))
  myprint(sbj_coef)
  
  # 4) Simulate the by-subject cell means *in link space* by multiplying model
  # matrix X and subject coefficients. Each column corresponds to multiplying
  # a row of X by a (transposed) row-vector of sbj_coef, and thus give us the 
  # expected cell means for a given subject (4 values per subject).
  cell_means_link <- X %*% t(sbj_coef)
  myprint(cell_means_link)
  
  # 5) Arrange back into data frame using the initial myfactors
  df <- data.frame(
    Subject = rep(1:N, each = nrow(cell_means_link)),
    myfactors,
    logLambdas = as.vector(cell_means_link))  # works bc values read columnwise
  myprint(df)
  
  # 6) Values in response space
  # 6a) The link function in Poisson regression is log, so convert back
  df$lambdas <- exp(df$logLambdas)
  # 6b) This gave us the *lambda* parameter of the Poisson distribution,
  # but we want to simulate an actual error count
  df$nbErrors <- rpois(nrow(df), lambda = df$lambdas)

  df
}

simulate_poisson()
simulate_poisson(print_each_step = FALSE)
simulate_poisson(print_each_step = TRUE)


#  ------------------------------------------------------------------------
#  Function to plot simulated data
#  ------------------------------------------------------------------------

plot_sim <- function(sim_data = NULL, show_indiv_data = TRUE) {
  pd <- position_dodge(0.2)
  p <- ggplot(sim_data, aes(x = Movement, y = nbErrors, colour = WordType)) +
    stat_summary(fun.data = "mean_cl_boot", position = pd) +
    stat_summary(fun.y=mean, geom="line", aes(group = WordType), position = pd)
  if (show_indiv_data) p <- p + geom_jitter(height = 0, width = .2, alpha = .5)
  p
}

plot_sim(simulate_poisson(print_each_step = F))
plot_sim(simulate_poisson(N = 15, print_each_step = F))
plot_sim(simulate_poisson(N = 30, print_each_step = F))
sim45 <- simulate_poisson(N = 45, print_each_step = F)
plot_sim(sim45, show_indiv_data = F)
plot_sim(sim45, show_indiv_data = T)

# Completely extreme fixed effect means
plot_sim(simulate_poisson(N = 15, fixef_means = c(6,-.05,.05,1)))


#  ------------------------------------------------------------------------
#  Function to simulate many data sets
#  ------------------------------------------------------------------------

poisson_sims <- function(n_sims = 1, ...) {
  out <- rdply(n_sims, simulate_poisson(...)) %>% rename(Sim = .n)
  out
}
(x <- poisson_sims(n_sims = 3))
# With three-dots syntax we can pass arguments to simulate_poisson() function
(x <- poisson_sims(n_sims = 3, N = 20, fixef_means = c(6,-.05,.05,1)))
rm(x)

#  ------------------------------------------------------------------------
#  Function to fit models on simulated data sets
#  ------------------------------------------------------------------------

# function that fits the model on each simulation (Sim) of a simulated data set
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
(fit_poi_glmm(poisson_sims(n_sims = 3)))


#  ------------------------------------------------------------------------
#  Function to fit models on differently paremtrized simulations and save to disk
#  ------------------------------------------------------------------------

# The idea of this function is taken from D Kleinschmidt's LSA13 slides;
# check them out for the use of mdply with a data frame of parameters that serve
# as input to simulate_data() function. Unfortunately, I haven't been able to
# figure out how to pass whole vetors or matrices (covariance matrices) as 
# parameters in a dataframe, so I'm putting things in a list and then using a
# wrapper function that loops through this list of parameters.

# Additionally, this function takes some parameters to make it the default
# to firs retrieve saved simulations from disk and then append new ones to
# those. This makes it possible to run simulations on different occasions, 
# which is good bc they take time.
 
# Function to fit models to data generated from list of different parameters
fit_many_pois <- function(parameterList = NULL, nbSims = 1, 
                          fitAnew = FALSE, loadOnly = FALSE, 
                          output_folder = path_out,
                          saved_obj_name = "my_poisson_simulations.RData") {
  # how long does it take?
  ptm <- proc.time()
  
  path_to_saved_obj <- file.path(path_out, saved_obj_name)
  
  # If loadOnly (default) it will not run new simulations, just load existing ones 
  if (loadOnly) {
    load(path_to_saved_obj)
    return(my_poisson_simulations)  # only works if it's the name of saved object!
  }
  # Otherwise...
  # check first if there is a saved .RData object with simulations; if so, load it
  stored_simulations <- saved_obj_name %in% list.files(path_out)

  # if fitAnew = F (default) it will append new simulations to loaded from disk
  if ( (! fitAnew) & stored_simulations) {
    load(path_to_saved_obj)
    df <- my_poisson_simulations
  } else {  # NB: if fitAnew = TRUE, it will delete any stored simulations
    df <- data.frame(Sim = NULL, fm = NULL, N = NULL, effect_size = NULL)
  }
  
  # Now run the simulations
  for (effectsize_name in names(parameterList$my_effectsize)) {  # keep track of name
    curr_fixef_means <- parameterList$my_effectsize[[effectsize_name]]
    # print(curr_fixef_means)
    for (curr_N in parameterList$my_N) {
      # print(curr_N)
      # fit models to data sets generated under current parametrization 
      result <- fit_poi_glmm(
        poisson_sims(
          n_sims = nbSims,
          N = curr_N,
          fixef_means = curr_fixef_means
          )
        )
      # print(result)
      # Keep track of the parameters under which the data were generated
      result$N <- curr_N
      result$effect_size <- effectsize_name
      # Add info about System time to allow us to simulate on different
      # occasions and append the data
      result$DateTime <- Sys.time()
      df <- rbind(df, result)
    }
  }
  # save to disk
  my_poisson_simulations <- df
  save(my_poisson_simulations, file = file.path(path_out, "my_poisson_simulations.RData"))

  print(paste("This is how long it took with", nbSims, "simulation(s):"))
  print(proc.time() - ptm)
  
  my_poisson_simulations  # and return result to save as object in global environment
}


# Vary the effect sizes of the parameter of interest
my_fixef_means
vary_effectsize <- function(factor = NULL, orig = my_fixef_means) {
  orig[4] <- orig[4] * factor
  orig
}
(orig_effsize <- vary_effectsize(1))
(orig_effsize.75 <- vary_effectsize(.75))
(orig_effsize.5 <- vary_effectsize(.5))
(orig_effsize.25 <- vary_effectsize(.25))
(orig_effsize.0 <- vary_effectsize(0))

# Run the function with a given set of parameters, looping over different N’s and sigmas.
# *list* of parameters
(params <- list(
  my_effectsize = list(
    "orig" = orig_effsize,
    "orig.75" = orig_effsize.75,
    "orig.5" = orig_effsize.5,
    "orig.25" = orig_effsize.25,
    "orig.0" = orig_effsize.0),
  my_N = seq(15, 60, 15)))

# run
my_poisson_simulations <- fit_many_pois(params, nbSims = 250, loadOnly = F, fitAnew = F)

head(my_poisson_simulations)
tail(my_poisson_simulations)
nrow(my_poisson_simulations)
