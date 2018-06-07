## Create stimuli lists for the pilot. We will use all potential target verbs.

# NB: Script is written to be sourced from the Rproject in the root directory
# of the project. All paths are relative to that root! (I.e., things will not
# work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"


#  ------------------------------------------------------------------------
#  Create conditions file
#  ------------------------------------------------------------------------

# variables to be manipulated within subjects and between blocks:
# In order to change as little as possible from the original, we will only
# manipulate the time of presentation of each word only (word_duration),
# but we will leave the blank after each word fixed (400ms as in S&P2013).
# The variable SOA is the sum of the two and is needed for the PsychoPy
# script.
# Regarding the choice of values for word_duration, these are loosely based
# on the range of values reviewed in Molinaro et al. 2011, Cortex).
block_conditions <- data.frame(word_duration = c(0.1, seq(.2, .4, .05)),
                               follow_blank = 0.4)
block_conditions$SOA <- with(block_conditions, word_duration + follow_blank)
block_conditions
write.csv(block_conditions, 
          file = "exp-scripts_psychopy/pilot/conditions_block_pilot.csv",
          row.names = FALSE)

#  ------------------------------------------------------------------------
#  Load list of all potential verbs (tv for target verbs)
#  ------------------------------------------------------------------------

tv <- read.csv("exp-scripts_psychopy/pilot/target-verbs_all-potential.csv",
                stringsAsFactors = FALSE)
head(tv)
str(tv)

# simplify and transparent names
tv <- tv[, c("word_category", "word")]
names(tv) <- c("type", "verb")
head(tv)

# target verbs: processing and sanity checks
tv$verb <- tolower(trimws(tv$verb))  # trim whitespaces and use lower case
sum(table(tv$verb) != 1)  # Check no repeated verbs (value has to be zero!)
table(tv$type) %% 4 == 0  # Check number of arm/leg verbs are multiples of 4 (both TRUE)
table(tv$type)  # I need to remove one arm-word
tv <- tv[! tv$verb == "pluck", ]  # pluck is a difficult and infrequent verb
table(tv$type) %% 4 == 0  # Check number of arm/leg verbs are multiples of 4 (both TRUE)


#  ------------------------------------------------------------------------
#  Create (pseudo-)random presentation lists
#  ------------------------------------------------------------------------

# An item consists of a set of 4 words of the same type. In the pilot, items
# will be different and random for each participant-block combination.
# Analyses will focus on both block accuracy and per-word accuracy.

## function to create a new set of random items from the list

arm <- tv[tv$type == "arm", "verb"]
leg <- tv[tv$type == "leg", "verb"]

random_items <- function(a = arm, l = leg) {
  a <- sample(sample(a))
  l <- sample(sample(l))
  items <- data.frame(
    # item = seq.int (length(c(a, l)) / 4),
    type = c(rep("arm", length(a)/4), rep("leg", length(l) / 4)),
    rbind(matrix(a, ncol = 4), matrix(l, ncol = 4)))
  names(items)[2:5] <- paste("word", 1:4, sep = "")  # sensible names to columns
  items
}
random_items()

# In the pilot, presentation of items is randomized with certain constraints:
# The sequence of items presented in a block is random "with the 
# constraint that not more than three trials of the same word category appeared
# consecutively." (Shebani & Pulvermüller, 2013:225)

# NB: I've factored out the functions into a separate script to keep this tidy.
source("Rfunctions/randomise.R")

# Function valid_seq() takes the "items" dataframe by default and shuffles the
# rows until it finds an order that works. It returns the reordered data frame.
# (Note that training items can be randomised in Psychopy, as no constraints apply,
# so these will not be randomised by this function)

valid_seq(random_items())  # the function is wordy...

x <- valid_seq(random_items())  
x  # but it only returns the valid data frame!

# wrap into a function that applies the 2 functions in sequence and saves
# with participant ID and block number (4 lists per participant)
# NB: Probably not very efficient; 200 participants take about a minute.
gener_pilot_lists <- function(pptID = 997:999, ite = NULL, 
                              nbBlocks = nrow(block_conditions)) {
  for (ppt in pptID) {
    for (block in 1:nbBlocks) {
      targets <- valid_seq(random_items())
      fname_lead <- paste("exp-scripts_psychopy/stimuli/presentation_lists_pilot/p",
                          ppt, "_b", block, "_pilot", sep = "")
      write.csv(targets, paste(fname_lead, "_targets.csv", sep = ""), row.names = FALSE)
    }
  }
}
gener_pilot_lists()

# Uncomment and run following line
# gener_pilot_lists(pptID = 900:999)

