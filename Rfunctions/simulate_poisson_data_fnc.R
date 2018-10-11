# Function to simulate Poisson-distributed data for the current design
# It is called/sourced from the script power-analysis_pilot_natives_poisson.R
# (in folder "1810_replication-natives_analysis/power-analysis/")

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
