## Obtain by-item variability estimates from our pilot data.

# For the simulation-based power analysis in our Cortex submission we need
# by-item variability estimates. The original data from SP13 consists of
# aggregate data (aggregated over items). Therefore we take these estimates
# from the pilot data which only consisted of the control condition of the
# memory task in SP13.

library("tidyverse")
library("lme4")
library("brms")


# load data file for memory task (in long format)
meml <- read_csv("1806_pilot_analysis/data_pilot_memory-task_long.csv")
meml$participant <- factor(meml$participant)
head(meml)



# Prepare data for model fitting ------------------------------------------

# The dependent variable is binary ('correct').
# The predictor variables are:
# - 'word_duration' in ms
# - 'block' (1, 2, 3, 4)
# - 'type' (arm or leg verb)
# - 'wordInTrial'

# Use contrast coding for factor 'type':
meml$type <- factor(meml$type)
contrasts(meml$type) <- contr.sum(2)
contrasts(meml$type)
# Centre the other predictors:
meml$block <- as.vector(scale(meml$block, scale = FALSE))
meml$wordInTrial <- as.vector(scale(meml$wordInTrial, scale = FALSE))

head(meml)


# Logistic mixed model analysis with lme4 ---------------------------------

# Model with all the data
fm_all_data <- glmer(
  correct ~ block + word_duration + type + wordInTrial +  (1 | participant) + (1 | verb),
  data = meml,
  family = 'binomial'
  )
summary(fm_all_data)

# Model of only the data with the word_duration we will use (word_duration = 100 ms)
fm_100 <- glmer(
  correct ~ block + type + wordInTrial +  (1 | participant) + (1 | verb),
  data = meml %>% filter(word_duration == 100),
  family = 'binomial'
)
summary(fm_100)

# The estimates are in the same ballpark but the latter model has larger variance:
VarCorr(fm_all_data)
VarCorr(fm_100)
# So we take the latter estimate, the more conservative one.

# Note that the by-participant estimate is very close to what we obtain from
# our re-analysis of the SP13 data (SD = 0.66), which is reassuring!



# Bayesian logistic mixed model analysis with brms ------------------------

# Is the by-item variability we get from an lme4 model comparable to what we
# obtain from a brms model?

# See which priors can be specified for this model and what defaults there are?

get_prior(
  correct ~ block + type + wordInTrial +  (1 | participant) + (1 | verb),
  data = meml %>% filter(word_duration == 100),
  family = "bernoulli"
)

# Specify weakly informative priors $N(0,\sigma^2 = 4)$ for population-level
# fixed effects:
myprior <- set_prior("normal(0, 2)", class = "b")  
# NB: In Stan a normal distribution is specified with sigma (*not* sigma^2), see
# https://mc-stan.org/docs/2_18/functions-reference/normal-distribution.html
# and
# https://stackoverflow.com/questions/52893379/stan-in-r-standard-deviation-or-variance-in-normal-distribution

bfm_100 <- brm(
  correct ~ block + type + wordInTrial +  (1 | participant) + (1 | verb),
  data = meml %>% filter(word_duration == 100),
  family = 'bernoulli',
  prior = myprior,
  iter = 10000, warmup = 1000, chains = 4  # https://discourse.mc-stan.org/t/bayes-factor-using-brms/4469/3
  )
summary(bfm_100)
# The mean estimates for by-item random intercepts are very similar (SDs):
# lme4: 0.61
# brms: 0.65
