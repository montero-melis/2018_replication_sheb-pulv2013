## NB: This is the old script I used for the first submission, when there were
## only two conditions (Arm-/Leg-interference). I created a new script for 2nd
## round bc we added control condition, but I keep this script for reference.

## Script to generate experimental lists from the list of target verbs

# NB: Script is written to be sourced from the Rproject in the root directory
# of the project. All paths are relative to that root! (I.e., things will not
# work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"


library(tidyverse)

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
#  Create 3 (pseudo-)random presentation lists of TARGETS for memory task
#  ------------------------------------------------------------------------

# An item consists of a quadruple of words, i.e. a set of 4 words of the same 
# type. Since there are 52 arm and 52 leg words, we can form 26 unique items
# (13 arm items and 13 leg items).
# We will create 3 sets of items, i.e. 3 different groupings of the target words
# into items. We call each of these sets an item List (Lists A, B and C).
# Each participant will see 2 of these lists, one per block, which makes for
# 3 different combinations ({A,B},{A,C},{B,C}). In addition, they can see them
# in two orders, e.g. for {A,B}: A-B, B-A. Finally, participants can do the
# interference tasks (hand/feet paradiddle) in two orders: hands-feet or feet-hands.
# This means we want to create stimulus lists that are multiples of
# 12 = 3 (List identity) x 2 (List order) x 2 (condition order).
# The specific order in which the items are shown will be randomized between
# participants, with the constraint explained below.

## function to create a new set of random items, i.e. an item list

random_items <- function(df = tv) {
  # Put arm and leg words into a vector
  a <- df[df$type == "arm", ] %>% pull(verb)
  l <- df[df$type == "leg", ] %>% pull(verb)
  # randomize the two vectors
  a <- sample(sample(a))
  l <- sample(sample(l))
  # Put into data frame
  items <- data.frame(
    type = c(rep("arm", length(a) / 4), rep("leg", length(l) / 4)),
    rbind(matrix(a, ncol = 4), matrix(l, ncol = 4)))
  names(items)[2:5] <- paste("word", 1:4, sep = "")  # sensible names to columns
  items
}
random_items()

set.seed(752200)
listA <- random_items()
set.seed(565286)
listB <- random_items()
set.seed(362578)
listC <- random_items()


#  ------------------------------------------------------------------------
#  Save target stimuli files for each participant and block
#  ------------------------------------------------------------------------

# NB: These are the files that will be read from the PsychoPy script

# Which list a participant sees in which block (1, 2) and whether that block is
# a arms/legs interference block is counterbalanced across participants.
# However, the *order* of the items within a block is randomized, with certain
# constraints: sequence of items within a block is random "with the  constraint
# that not more than three trials of the same word category appeared
# consecutively." (Shebani & Pulvermüller, 2013:225)

# The function that does this is valid_seq(), but I've factored it out into a
# separate script to keep things tidy here.
source("Rfunctions/randomise.R")  # see source code for details

# Function valid_seq() takes the items List dataframe by default and shuffles the
# rows until it finds an order that obeys the above constraint. It returns the
# reordered data frame. (Note that training items can be randomised in Psychopy,
# as no constraints apply in this case, so these will not be randomised by this
# function, but directly in PsychoPy instead)

valid_seq(random_items())  # the function is wordy...

x <- valid_seq(random_items())  
x  # but it only returns the valid data frame!


# To generate the final lists that a participant will see we use the following
# function. It makes sure that list identity (A,B,C), list order, and task order
# is counterbalanced (participant number should be a multiple of 12!).
# It then randomizes the items within a block and saves the final list to file.
gener_target_lists <- function(pptID = 997:999) {
  
  # Check participant IDs for counterbalancing purposes
  if (length(pptID) %% 12 != 0) {
    warning("For a balanced design, N has to be a multiple of 12, but it isn't!")
  }
  if (pptID[1] %% 100 != 1) {
    warning("Participants ID should start with 101, 201, etc.")
  }
  
  # Create a table that keeps track of the exact list assigned to a participant:
  nr <- 2 * length(pptID)  # number of rows in table (2 per participant)
  overview <- tibble::tibble(
    id         = rep(pptID, each = 2),
    list_seq   = rep(c("AB", "BA", "AC", "CA", "BC", "CB"),
                     each = 4, length.out = nr),
    task_order = rep(c("arms-legs", "legs-arms"), each = 2, length.out = nr),
    block      = rep(c(1, 2), length.out = nr),
    list       = NA,
    task       = rep(c("arms", "legs", "legs", "arms"), length.out = nr)
  )
  # Fix list shown per block (a bit messy but didn't know how else to do this):
  overview$list <- pmap(overview %>% select(list_seq, block),
                        function(list_seq, block) { substr(list_seq, block, block) }
  ) %>% unlist
  
  # Now we have to create a separate stimulus file for each participant-block,
  # after randomizing the items
  list2file <- function(id, block, list) {
    curr_list <- get(paste("list", list, sep = ""))  # select list for this block
    curr_list <- valid_seq(curr_list)  # randomize item order with constraints
    # save to file with appropriate name
    write_csv(curr_list,
              paste(path_output, "random_lists/p_", id, "_b", block, "_targets.csv",
                    sep = ""))
  }
  # Execute function for each row (this will save the individual files)
  pmap(overview %>% select(id, block, list), list2file)
  
  # Save the overview file
  write_csv(overview, paste(path_output, "random_lists/list_assignment.csv", sep = ""))
}

# As an example:
gener_target_lists(901)

# Participants IDs for which to create lists
pptIDs <- c(1 : 120, 990 : 1001)

# Generate the real lists
set.seed(5724619)
gener_target_lists(pptIDs)



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
      fname <- paste(path_output, "random_lists/p_", ppt, "_b", block,
                     "_training.csv", sep = "")
      write_csv(df, fname)
    }
  }
}
# gener_training_lists()

# Uncomment and run following line
set.seed(447778441)
gener_training_lists(pptID = pptIDs)
