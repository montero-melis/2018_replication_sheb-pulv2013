## NB: This is the new script for our resubmission to Cortex. We now include 3
## conditions (Arm-/Leg-interference and control).

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
# Each participant will see all three lists, one per block. So there are 6
# different permutations (ABC, ACB, BAC, ...). At the same time, participants
# carry out the task in three conditions (arm, leg, control), so there are 6
# permutations here as well. All in all, there are 36 unique combinations of
# condition-list assignments.
# We want to make sure that each batch of 6 participants gets assigned all
# possible conditions -- and also that each 36 participants we have a full
# cycle of conditions-to-lists assignments.
# This is done in the functions below.
# 
# NB: The specific order in which the items are shown within a block is
# randomized with the constraint explained below.

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
list1 <- random_items()
set.seed(565286)
list2 <- random_items()
set.seed(362578)
list3 <- random_items()


#  ------------------------------------------------------------------------
#  Counterbalancing of conditions and list assignment across participants
#  ------------------------------------------------------------------------

# First, a beautiful (but intricate) recursive function to permute, found in
# https://stackoverflow.com/questions/11095992/generating-all-distinct-permutations-of-a-list-in-r
permutations <- function(n){
  if(n==1){
    return(matrix(1))
  } else {
    sp <- permutations(n-1)
    p <- nrow(sp)
    A <- matrix(nrow=n*p,ncol=n)
    for(i in 1:n){
      A[(i-1)*p+1:p,] <- cbind(i,sp+(sp>=i))
    }
    return(A)
  }
}

# E.g.:
permutations(3)
matrix(c("A", "B", "C")[permutations(3)], ncol = 3)


# We want to counterbalance the assignment of conditions and lists to
# blocks across participants in an optimal way:
# - We have 3 conditions ([A]rm, [C]ontrol, [L]eg), so there are 6 permutations
# - We also have 3 lists (1, 2, 3) -- equally 6 permutations
# - All together we have 36 ordered combinations of conditions and lists
# - Each cycle of 6 participants we want to have all possible permutations of
#   conditions (this is the most important thing to counterbalance)
# - But we also want the assignment of conditions to lists to be balanced in
#   each cycle of 6 participants.
# - And finally, in each cycle of 36 participants, everything should be balanced:
#   conditions, list-to-condition assignments and order in which lists appear.
# The code below satisfies these requirements:


# Two-step process:

# 1) Assign lists to conditions in a balanced way:
list2cond <- function(v) {
  matrix(paste(v, t(permutations(3)), sep = ""),
         ncol = 3, byrow = TRUE)
}
# Calling this function with each of the six permutations of conditions yields
# one possible balanced order. After a cycle of all six, all combinations have
# been used. E.g.:
list2cond(c("A", "B", "C"))
list2cond(c("B", "C", "A"))


# 2) Reorder condition-list pairs so that conditions are permuted. Imagine that
#    we are just permuting the conditions, disregarding the lists assigned to
#    them.

# Small function to replace a condition with a condition-list pair
replace_condlist <- function(cond, condlist) {
  # The cond vector contains ordered conditions, e.g. "A C B"
  # The condlist vector contains unordered condition-list combinations, e.g.
  # "A2 B1 C3". We replace the conditions in cond by the matching elements in
  # condlist:
  for(index in 1:length(cond)) {
    match <- condlist[grep(cond[index], condlist)]
    cond[index] <- match
  }
  cond
}
# E.g.:
replace_condlist(c("A", "C", "B"), c("B1", "C2", "A3"))
replace_condlist(c("C", "B", "A"), c("B1", "A2", "C3"))


## Bring steps 1 and 2 together in a function:

# We now create all permutations of conditions with list assignments.
# Each six condition-list assignments we shuffle the rows so that the order in
# which each batch of 6 participants are assigned conditions is not fixed.
assign_cond_list <- function(
  conds = c("A", "B", "C"),
  lists = c(1, 2, 3),
  mult36 = 1  # How many multiples of 36 participants?
) {
  
  # List that will contain the row of the matrix:
  l <- list()
  # Matrix of permutations of conditions:
  perm_conds <- matrix(conds[permutations(3)], ncol = 3)
  # Arrange the rows as two stacked latin squares to maximally balance design:
  lat_sqs <- perm_conds[c(1, 4, 5, 2, 3, 6), ]
  
  # Loop through mult36:
  for(loop in 1:mult36) {
    
    # Based on each row of lat_sqs we create a different condition-to-list assignment
    for(i in 1:nrow(lat_sqs)) {
      cond_list <- list2cond(lat_sqs[i,])
      m <- matrix(nrow = 6, ncol = 3)  # matrix for the following loop
      
      # Now we assign the right lists to the permuted conditions
      for (k in 1:nrow(cond_list)) {
        curr_row <- replace_condlist(perm_conds[k, ], cond_list[k, ])
        m[k, ] <- curr_row
      }
      # shuffle the rows of m
      shuffled_rows <- sample.int(nrow(m))
      m <- m[shuffled_rows, ]
      l[[i + (loop - 1)*nrow(lat_sqs)]] <- m
    }

  }
  m <- do.call(rbind, l)  # convert to single matrix
  m
}
assign_cond_list()
assign_cond_list(mult36 = 2)

# Actual assignment
set.seed(11131127)
assign_cond_list(
  conds = c("Arm-", "Control-", "Leg-"),
  mult36 = 8
  )



#  ------------------------------------------------------------------------
#  Save target stimuli files for each participant and block
#  ------------------------------------------------------------------------

# NB: These are the files that will be read from the PsychoPy script

# Which list a participant sees in a block and whether that block is
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
# function. It makes sure that list order and condition order are counterbalanced
# (participant numbers should be multiples of 6 - and ideally of 36!).
# It then randomizes the items within a block and saves the final list to file.
gener_target_lists <- function(pptID = 997:999) {
  
  # Check participant IDs for counterbalancing purposes
  if (length(pptID) %% 6 != 0) {
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
    # select list for this block: one of list1, list2 or list3 (in global env.)
    curr_list <- get(paste("list", list, sep = ""))
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
