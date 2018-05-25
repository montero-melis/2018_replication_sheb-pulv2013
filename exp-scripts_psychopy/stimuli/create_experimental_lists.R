## Script to generate experimental lists from the list of target verbs

# NB: Script is written to be sourced from the Rproject in the root directory
# of the project. All paths are relative to that root! (I.e., things will not
# work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"


#  ------------------------------------------------------------------------
#  Load data and process
#  ------------------------------------------------------------------------

# Target verbs
tv <- read.csv("exp-scripts_psychopy/stimuli/target_verbs.csv",
               stringsAsFactors = FALSE)
# training verbs
tr <- read.csv("exp-scripts_psychopy/stimuli/training_verbs.csv",
               stringsAsFactors = FALSE)

# target verbs: processing and sanity checks
tv$verb <- tolower(trimws(tv$verb))  # trim whitespaces and use lower case
sum(table(tv$verb) != 1)  # Check no repeated verbs (value has to be zero!)
table(tv$type) %% 4 == 0  # Check number of arm/leg verbs are multiples of 4 (both TRUE)

# training verbs: processing and sanity checks
tr$verb <- tolower(trimws(tr$verb))  # trim whitespaces and use lower case
sum(table(tr$verb) != 1)  # Check no repeated verbs (value has to be zero!)
nrow(tr) %% 4 == 0  # Check is a multiple of 4 (TRUE)


#  ------------------------------------------------------------------------
#  Create actual items (i.e., quadruples of same-type verbs) - these are fixed!
#  ------------------------------------------------------------------------

# An item consists of a set of 4 words of the same type, independent of the
# order in which these 4 words are shown. Note that items are fixed in this
# study so as to make it possible to account for item-variability in the
# analyses.

arm <- tv[tv$type == "arm", "verb"]
leg <- tv[tv$type == "leg", "verb"]

# use seeds for randomization to ensure reproducibility
set.seed(12345)
arm <- sample(sample(arm))
set.seed(54321)
leg <- sample(sample(leg))

# Arrange as items into data frame
items <- data.frame(
  item = seq.int (length(c(arm, leg)) / 4),
  type = c(rep("arm", length(arm)/4), rep("leg", length(leg) / 4)),
  rbind(matrix(arm, ncol = 4), matrix(leg, ncol = 4)))
names(items)[3:6] <- paste("word", 1:4, sep = "")  # sensible names to columns

items

# save this list to experiment folder (used for testing only)
write.csv(items, "exp-scripts_psychopy/conditions_exp-trials_allitems_test.csv",
          row.names = FALSE)


#  ------------------------------------------------------------------------
#  Training items
#  ------------------------------------------------------------------------

tra <- tr$verb

# use seeds for randomization to ensure reproducibility
set.seed(6789)
tra <- sample(sample(tra))
tra

# Arrange as items into data frame
train <- data.frame(
  item = seq.int(length(tra)/4),
  type = "training",
  matrix(tra, ncol = 4))
names(train)[3:6] <- paste("word", 1:4, sep = "")  # sensible names to columns

train

# save this list to experiment folder
write.csv(train, "exp-scripts_psychopy/conditions_training.csv",
          row.names = FALSE)


#  ------------------------------------------------------------------------
#  Create (pseudo-)random presentation lists
#  ------------------------------------------------------------------------

# Presentation of items is randomized at two levels and with certain constraints:
# Level 1: In each block, the order of the 4 words that form an item is shuffled.
# (this means the item has the same words, but in different orders between blocks.)
# Level 2: The sequence of items presented in a block is random "with the 
# constraint that not more than three trials of the same word category appeared
# consecutively." (Shebani & Pulvermüller, 2013:225)

as.matrix(items[1:3, 3:6])
as.vector(t(as.matrix(items[1:3, 3:6])))

# function to shuffle the order of the 4 words of an item
shuffle_words <- function(df) {
  # check the provided df has the expected format
  if(sum(names(df)[3:6] != paste("word", 1:4, sep = ""))) {
    stop("I'm expecting something else; check the input!")
  }
  # read the words row by row and save as vector
  shuffle <- as.vector(t(as.matrix(df[, 3:6])))
  nb_items <- length(shuffle) / 4  # number of items
  # index the position directly before the first word of each item
  item_index <- 4 * (0 : (length(shuffle) - 1)) %/% 4
  reshuffle <- replicate(nb_items, sample(4))  # reshuffle 1:4 nb_items times
  myindex <- item_index + as.vector(reshuffle)
  shuffled <- matrix(shuffle[myindex], ncol = 4, byrow = TRUE)
  print(df)  # before
  df[, 3:6] <- shuffled
  df
}
shuffle_words(items[15:18,])

rep(sample(4), 4)

shuffle_words(items[, 6:1])
shuffle_words(items[, c(1:5, 1)])

