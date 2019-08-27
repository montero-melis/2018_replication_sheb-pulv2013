## Script to generate experimental lists from the list of target verbs

# NB: Script is written to be sourced from the Rproject in the root directory
# of the project. All paths are relative to that root! (I.e., things will not
# work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"


library(tidyverse)


# Participant IDs for which we want to generate random lists
pptIDs <- c(990:999)

# All files generated in this script go to the same folder, so save path as
# variable:
path_output <- "1908_sp13_replic_swe/psychopy_exp/stimuli/"



#  ------------------------------------------------------------------------
#  Load data and process
#  ------------------------------------------------------------------------

# Target verbs
tv <- read_csv(paste(path_output, "sw_verb_selection_1906.csv", sep = "")) %>%
  select(type = category, verb = word)
head(tv)
  
# training verbs
tr <- read_csv(paste(path_output, "items_practice.csv", sep = ""))
head(tr)

# target verbs: processing and sanity checks
tv$verb <- tolower(trimws(tv$verb))  # trim whitespaces and use lower case
sum(table(tv$verb) != 1)  # Check no repeated verbs (value has to be zero!)
table(tv$type) %% 4 == 0  # Check number of arm/leg verbs are multiples of 4 (both TRUE)

# training verbs: processing and sanity checks
tr$verb <- tolower(trimws(tr$verb))  # trim whitespaces and use lower case
sum(table(tr$verb) != 1)  # Check no repeated verbs (value has to be zero!)
nrow(tr) %% 4 == 0  # Check is a multiple of 4 (TRUE)


#  ------------------------------------------------------------------------
#  Create (pseudo-)random presentation lists of TARGETS for memory task
#  ------------------------------------------------------------------------

# A quadruple consists of a set of 4 words of the same type. In the pilot,
# quadruples will be different and random for each participant-block combination.

## function to create a new set of random items from the list

arm <- tv[tv$type == "arm", ] %>% pull(verb)
leg <- tv[tv$type == "leg", ] %>% pull(verb)

random_items <- function(a = arm, l = leg) {
  a <- sample(sample(a))
  l <- sample(sample(l))
  items <- data.frame(
    type = c(rep("arm", length(a) / 4), rep("leg", length(l) / 4)),
    rbind(matrix(a, ncol = 4), matrix(l, ncol = 4)))
  names(items)[2:5] <- paste("word", 1:4, sep = "")  # sensible names to columns
  items
}
random_items()

# Presentation of items is randomized with certain constraints:
# The sequence of items presented in a block is random "with the 
# constraint that not more than three trials of the same word category appeared
# consecutively." (Shebani & Pulvermüller, 2013:225)

# NB: I've factored out the functions into a separate script to keep this tidy.
source("Rfunctions/randomise.R")

# Function valid_seq() takes the "items" dataframe by default and shuffles the
# rows until it finds an order that obeys the above constraint. It returns the
# reordered data frame. (Note that training items can be randomised in Psychopy,
# as no constraints apply in this case, so these will not be randomised by this
# function, but directly in PsychoPy instead)

valid_seq(random_items())  # the function is wordy...

x <- valid_seq(random_items())  
x  # but it only returns the valid data frame!

# wrap into a function that applies the 2 functions in sequence and saves
# with participant ID and block number (2 lists per participant)
# NB: Probably not very efficient; 200 participants take about a minute.
gener_target_lists <- function(pptID = 997:999, ite = NULL, nbBlocks = 2) {
  for (ppt in pptID) {
    for (block in 1:nbBlocks) {
      targets <- valid_seq(random_items())
      fname_lead <- paste(path_output, "random_lists/p", ppt, "_b", block,
                          "_memory", sep = "")
      write.csv(targets, paste(fname_lead, "_targets.csv", sep = ""), 
                row.names = FALSE, fileEncoding = "UTF-8")
    }
  }
}
gener_target_lists()

# Uncomment and run following line
# gener_target_lists(pptID = pptIDs)



#  ------------------------------------------------------------------------
#  Create random presentation lists of TRAINING items for memory task
#  ------------------------------------------------------------------------

# The randomizing is simpler for training items: we need to randomly generate
# quadruples and format them correctly, but without constraints on order.
# We need three such lists per participant: initial training and one additional
# practice list per experimental block (arm/leg interference)
gener_training_lists <- function(pptID = 997:999, items = tr$verb, nbBlocks = 0:2) {
  for (ppt in pptID) {
    for (block in nbBlocks) {
      training_verbs <- sample(items)
      df <- data.frame(
        type = "training",
        matrix(training_verbs, ncol = 4))
      names(df)[2:5] <- paste("word", 1:4, sep = "")  # sensible names to columns
      fname <- paste(path_output, "random_lists/p", ppt, "_b", block,
                     "_memory_training.csv", sep = "")
      write.csv(df, fname, row.names = FALSE, fileEncoding = "UTF-8")
    }
  }
}
gener_training_lists()

# Uncomment and run following line
# gener_training_lists(pptID = pptIDs)
