## Shebani agreed to talk on the phone or skype (2018-09-20), but she asked me
## what information I needed. Here I make up some fictitious data to exemplify.

library("ggplot2")

df <- expand.grid(
  WordType = c("Arm-related", "Leg-related"),
  Condition = c("Control", "Arm", "Leg", "Articulation"),
  Participant = 1:4)

df <- df[, ncol(df):1]
head(df,12)

# Simulate number of observations per cell
rand_unif <- runif(nrow(df))
nb_missing <- ifelse(rand_unif < 1/15, 2, ifelse(rand_unif < 1/10, 1, 0))
# assuming 24 is the total nb of trials and some are lost
df$nbValidTrials <- 24 - nb_missing

# Assume number of errors are binomially distributed
df$NbErrors <- rbinom(nrow(df), df$nbValidTrials, c(0.3, 0.3, 0.75, 0.5, 0.5, 0.75, 0.9, 0.85))

head(df,12)

# plot
ggplot(df, aes(x = Condition, y = NbErrors, colour = WordType)) +
  geom_boxplot() + 
  ylim(0,24)

# Save to disk
write.csv(df, "power-analysis/made-up_data_example_shebani.csv",
          row.names = FALSE, fileEncoding = "UTF-8")
