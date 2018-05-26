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

# NB: I've factored out the functions into a separate script to keep this tidy.
source("Rfunctions/randomise.R")

## Level 1 - words within items

# function works with target as well as training items
shuffle_words(items)
shuffle_words(train)

## Level 2 - items within blocks

# Function takes the "items" dataframe by default and shuffles the rows until
# it finds an order that works. It returns the reordered data frame.
# (Note that training items can be randomised in Psychopy, as no constraints apply)

valid_seq()  # the function is wordy...
x <- valid_seq()  
x  # but it only returns the valid data frame!

