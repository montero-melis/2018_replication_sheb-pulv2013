## Script to generate experimental lists from the list of target verbs.

# NB:
# 1) This is the new script for our resubmission to Cortex. We now include 3
# conditions (Arm-/Leg-interference and control).
# 2) Script is written to be sourced from the Rproject in the root directory
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
  for(loop in 1 : mult36) {
    
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
  colnames(m) <- paste("B", c(1:3), sep = "")
  m
}
assign_cond_list()
assign_cond_list(mult36 = 2)


#  ------------------------------------------------------------------------
#  Generate the assignment list
#  ------------------------------------------------------------------------

# Actual assignment
set.seed(11131127)
listcond_assignment <- assign_cond_list(
  conds = c("arm_", "control_", "leg_"),
  mult36 = 10
  )

# Convert to tibble / dataframe with subject IDs:
list_cond <- as_tibble(listcond_assignment) %>%
  # NB: I want to generate lists for participant IDs in the 900s for testing
  mutate(id = c(1 : (nrow(listcond_assignment) - 36), (999 - 35) : 999))
list_cond

# wide format to save to disk (I'm ashamed of this repetition in the code)
list_cond_w <- list_cond %>%
  mutate(
    condition = paste(
      gsub("([a-z]*)_([1-3])", "\\1", B1),
      gsub("([a-z]*)_([1-3])", "\\1", B2),
      gsub("([a-z]*)_([1-3])", "\\1", B3),
      sep = "-"
      ),
    list = paste(
      gsub("([a-z]*)_([1-3])", "\\2", B1),
      gsub("([a-z]*)_([1-3])", "\\2", B2),
      gsub("([a-z]*)_([1-3])", "\\2", B3),
      sep = "-"
      )
    ) %>%
  select(id : list)
list_cond_w
# Add one column that specifies the file that PsychoPy needs to read to assign
# the right order of conditions to a participant:
filenames <- tibble(
  condition = unique(list_cond_w$condition)
  ) %>%
  mutate(
    condit_order_file = paste("block_order_", condition, ".csv", sep = "")
  ) %>% 
  arrange(condition)
filenames

list_cond_w <- left_join(list_cond_w, filenames)
list_cond_w

# save to disk
write_csv(list_cond_w, paste(path_output, "random_lists/cond-list_assignment_wide.csv", sep = ""))

# Long format:
list_cond_l <- gather(list_cond, block, cond, B1:B3) %>%
  mutate(
    block = sub("B?([0-9])", "\\1", block),
    condition = sub("(.*)_([0-9])", "\\1", cond),
    list = sub("(.*)_([0-9])", "\\2", cond)
    ) %>%
  select(-cond) %>%
  arrange(id, block)
list_cond_l
write_csv(list_cond_l, paste(path_output, "random_lists/cond-list_assignment_long.csv", sep = ""))


#  ------------------------------------------------------------------------
#  Create condition-order lists and save to disk
#  ------------------------------------------------------------------------

# Create the actual condition order files to be loaded by Psychopy:
conds <- read_csv("1908_sp13_replic_swe/psychopy_exp/block_conditions_0.csv")
conds

# List the row ids as read from cond corresponding to the conditions in each
# row of filenames
filenames <- filenames %>%
  mutate(
    row_ids = c(
      list(c(1,2,3)),
      list(c(1,3,2)),
      list(c(2,1,3)),
      list(c(2,3,1)),
      list(c(3,1,2)),
      list(c(3,2,1))
    )
  )
filenames
filenames$row_ids

save_condfiles <- function (
  condition, condit_order_file, row_ids, df_cond = conds, ...
  ) {
  cond_file <- df_cond[row_ids,]
  print(condition)
  print(cond_file)
  write_csv(
    cond_file,
    path = paste("1908_sp13_replic_swe/psychopy_exp/", condit_order_file, sep = "")
  )
}
pmap(filenames, save_condfiles)


#  ------------------------------------------------------------------------
#  Check counterbalancing (sanity check)
#  ------------------------------------------------------------------------

# copy df for sanity check
sc <- list_cond_l
sc$cycle_6  <- (sc$id - 1) %/% 6
sc$cycle_36 <- (sc$id - 1) %/% 36
head(sc, 20)
tail(sc, 20)

# basic
table(sc$condition)
table(sc$list)
with(sc, table(list, condition))

# Perfect balance every cycle of 36?
# Cycle 1
sc %>%
  filter(cycle_36 == 0) %>%
  group_by(block, condition, list) %>%
  count() %>%
  print(n = 200)
# All cycles? (excluding participant IDs in the 900s - for testing only)
sc %>%
  filter(id < 900) %>%
  group_by(cycle_36, block, condition, list) %>%
  count() %>%
  print(n = 300)

# Cycles of 6
# Without considering block it's perfectly balanced
sc %>%
  filter(cycle_36 == 0) %>%
  group_by(cycle_6, condition, list) %>%
  count() %>%
  print(n = 200)
# Taking block into account it shows this harmonious pattern that balances out
# after each cycle of 36
sc %>%
  filter(cycle_36 == 0) %>%
  group_by(cycle_6, block, condition, list) %>%
  count() %>%
  print(n = 200)
# In a more visual fashion: look at how the diagonals of 4s covers all positions
by(sc[sc$cycle_36 == 0, c("block", "list")], sc[sc$cycle_36 == 0, ]$cycle_6, table)

# So yes, we conclude the design is fully balanced!


#  ------------------------------------------------------------------------
#  Save target stimuli files for each participant and block
#  ------------------------------------------------------------------------

# NB: These are the files that will be read from the PsychoPy script

# Which list a participant sees in a block and whether that block is
# an arms, legs or control block is specified in "list_cond" (previous section).
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
# function, which starts from the list_cond_l dataframe and generates text files
# with the right stimulus list correctly randomized for each block-participant.

stim_file <- function(id, block, list, ...) {  # input is a row of list_cond_l
  # Retrieve the right list and randomize its order with constraints
  curr_list <- get(paste("list", list, sep = ""))
  curr_list <- valid_seq(curr_list)
  # save to file with appropriate name
  fname <- paste(path_output, "random_lists/p_", id, "_b", block, "_targets.csv",
                 sep = "")
  write_csv(curr_list, fname)
}

# Generate the lists for all participants with a reproducible seed.
set.seed(1174688796)
pmap(list_cond_l, stim_file)


#  ------------------------------------------------------------------------
#  Create random presentation lists of TRAINING items for memory task
#  ------------------------------------------------------------------------

# The randomizing is simpler for training items: we need to randomly generate
# quadruples and format them correctly, but without constraints on order.
# We need four such lists per participant: initial training and one additional
# practice list per experimental block.
# NB: It's not efficient but hopefully we just need to do this once.

stim_file_train <- function(id, block, ...) {  # input is a row of list_cond_l
  # Retrieve the list of training verbs, randomize and arrange into df
  training_verbs <- sample(tr$verb)
  df <- data.frame(
    type = "training",
    matrix(training_verbs, ncol = 4))
  # sensible names to columns
  names(df)[2:5] <- paste("word", 1:4, sep = "")
  # save to file with appropriate name
  fname <- paste(path_output, "random_lists/p_", id, "_b", block, "_training.csv",
                 sep = "")
  write_csv(df, fname)
  # What follows is a clumsy solution to also have a list for block 0 (first training)
  if (block == 1) {
    training_verbs <- sample(training_verbs)
    df <- data.frame(
      type = "training",
      matrix(training_verbs, ncol = 4))
    # sensible names to columns
    names(df)[2:5] <- paste("word", 1:4, sep = "")
    # save to file with appropriate name
    fname <- paste(path_output, "random_lists/p_", id, "_b", 0, "_training.csv",
                   sep = "")
    write_csv(df, fname)
    
  }
}

list_cond_l[1:3, ]
pmap(list_cond_l[1:3, ], stim_file_train)

# Generate all training lists:
set.seed(447778441)
pmap(list_cond_l, stim_file_train)
