## Create stimuli lists for the norming task (pilot). We will use all potential
## target verbs. We need to randomize the order in which the correct Swedish
## translation and the two distractors are shown for each verb.

# NB: Script is written to be sourced from the Rproject in the root directory
# of the project. All paths are relative to that root! (I.e., things will not
# work if script is called from the folder where it is actually located.)

getwd()  # should be "[whatever...]/2018_replication_sheb-pulv2013"


#  ------------------------------------------------------------------------
#  Load list of all verbs to be normed and format as required for PsychoPy exp
#  ------------------------------------------------------------------------

verbs <- read.csv("exp-scripts_psychopy/stimuli/verbs_norming-task.csv",
                  fileEncoding = "UTF-8", stringsAsFactors = FALSE)
head(verbs)
str(verbs)

# processing and sanity checks
verbs[2:4] <- lapply(verbs[2:4], tolower)
verbs[2:4] <- lapply(verbs[2:4], trimws)
sum(table(verbs$item) != 1)  # Check no repeated verbs (value has to be zero!)

# load file that shows the target format needed for the psychopy experiment
target_format <- read.csv("exp-scripts_psychopy/pilot/verbs_test.csv",
                          fileEncoding = "UTF-8", stringsAsFactors = FALSE)
head(target_format)

# format 'verbs' like 'target_format'
names(verbs)[c(1,3,4)] <- names(target_format)[c(1,3,4)]
verbs <- cbind(verbs, data.frame(corrAns = NA, w1 = NA, w2 = NA, w3 = NA))
# check
head(target_format)
head(verbs)


#  ------------------------------------------------------------------------
#  Shuffle order of Swedish alternatives for translation task & save to disk
#  ------------------------------------------------------------------------

# Function to shuffle the order of the 3 Swedish words for the forced-choice
# translation task (target and two distractors); corrAns keeps track of which
# of the three is the correct one (target).

shuffle_norm_verbs <- function(df = verbs) {
  nb_items <- nrow(df)  # number of target verbs
  # read the 3 Swedish words row by row and save as vector
  shuffle <- as.vector(t(as.matrix(df[, 2:4])))
  # index the position directly before every group of 3 words
  item_index <- 3 * (0 : (length(shuffle) - 1)) %/% 3  # using the quotient
  reshuffle <- replicate(nb_items, sample(3))  # reshuffle 1:3 nb_items times
  myindex <- item_index + as.vector(reshuffle)  # reshuffle the words in vector format
  shuffled <- matrix(shuffle[myindex], ncol = 3, byrow = TRUE)  # back to matrix form
  df[, 6:8] <- shuffled
  # to keep track of where the target is, we keep track of where the 1's are
  correctAnswer <- which(reshuffle == 1) %% 3  # using the remainder
  correctAnswer[correctAnswer == 0] <- 3  # when remainder is 0, correct answer is the 3rd word
  df$corrAns <- correctAnswer
  df
}
shuffle_norm_verbs()


# wrap into a function to save with participant ID
gener_norming_lists <- function(pptID = 997:999) {
  for (ppt in pptID) {
    norm_verbs <- shuffle_norm_verbs()
    filename <- paste("exp-scripts_psychopy/stimuli/presentation_lists_pilot/p",
                      ppt, "_norming.csv", sep = "")
    write.csv(norm_verbs, filename, row.names = FALSE, fileEncoding = "UTF-8")
  }
}
gener_norming_lists()

# Uncomment and run following line
# gener_norming_lists(pptID = 900:999)



