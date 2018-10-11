## Simulate Poisson-distributed data

library(mvtnorm)
library(lme4)
library(ggplot2)


#  ------------------------------------------------------------------------
#  1) Load made up data (same shape as original)
#  ------------------------------------------------------------------------

# Made up data that has exactly same shape as the original. The actual power
# simulations will be done with the original data set
#mydata <- read.csv("power-analysis/madeup_data.csv")
mydata <- read.csv("madeup_data.csv")
head(mydata)
# write.csv(mydata[,-c(4:5)], file = "power-analysis/madeup_data.csv", row.names = FALSE)

# plot
pd <- position_dodge(0.2)
p <- ggplot(mydata, aes(x = Movement, y = nbErrors, colour = WordType)) +
  stat_summary(fun.data = "mean_cl_boot", position = pd) +
  stat_summary(fun.y=mean, geom="line", aes(group = WordType), position = pd)
p
# Notice the actual spread between subjects
p + geom_jitter(height = 0, width = .2, alpha = .5)


#  ------------------------------------------------------------------------
#  2) Fit Poisson GLMM
#  ------------------------------------------------------------------------

# Contrast coding
contrasts(mydata$Movement) <- contr.sum(2)
colnames(contrasts(mydata$Movement)) <- "arms_vs_legs"
contrasts(mydata$Movement)
contrasts(mydata$WordType) <- contr.sum(2)
colnames(contrasts(mydata$WordType)) <- "armW_vs_legW"
contrasts(mydata$WordType)

# Poisson GLMM
glmm_poi <- glmer(nbErrors ~ 1 + Movement * WordType + (1 + Movement * WordType | Subject),
                  data = mydata, family = "poisson",
                  control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=100000)))
summary(glmm_poi)  # interaction comes out significant as in original


#  ------------------------------------------------------------------------
#  3) Extract parameter estimates + uncertainty from the model -- CORRECT? (Q1)
#  ------------------------------------------------------------------------

# Fixed effect means
(my_fixef_means <- coef(summary(glmm_poi))[, 1])
# Covariance of fixed effects estimates
(my_fixef_sigma <- as.matrix(vcov(glmm_poi)))
# Covariance of random by-subject adjustments (mean is zero)
(my_ranef_sigma <- matrix(unclass(VarCorr(glmm_poi))$Subject, ncol = 4))


#  ------------------------------------------------------------------------
#  4) The function -- makes sense? (Q2)
#  ------------------------------------------------------------------------

# Simulate Poisson-distributed data for the current design
simulate_poisson <- function (
  N = 3,  # Number of participants
  fixef_means  = my_fixef_means,  # vector of mean estimates for fixed effects
  fixef_sigma  = my_fixef_sigma,  # covariance matrix for fixed effects estimates
  ranef_sigma  = my_ranef_sigma,   # covariance matrix for random effects (by-subject only)
  print_each_step = TRUE  # print output at each step to unveil inner workings
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
