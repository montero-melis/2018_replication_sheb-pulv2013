## Obtain by-item variability estimates from our pilot data.

# For the simulation-based power analysis in our Cortex submission we need
# by-item variability estimates. The original data from SP13 consists of
# aggregate data (aggregated over items). Therefore we take these estimates
# from the pilot data which only consisted of the control condition of the
# memory task in SP13.

library("tidyverse")
library("lme4")


# load data file for memory task (in long format)
meml <- read_csv("1806_pilot_analysis/data_pilot_memory-task_long.csv")
meml$participant <- factor(meml$participant)
head(meml)



# Logistic mixed model analysis -------------------------------------------

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