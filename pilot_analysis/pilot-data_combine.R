## Process and combine individual participant data

# This script takes the pilot data after coding and combines it into single
# data files for each task, saving it to disk after some processing. 
# Tasks: 1. Memory task, 2. Verb ratings, 3. Verb understanding.


library(dplyr)  # for left_join

#  ------------------------------------------------------------------------
#  Functions
#  ------------------------------------------------------------------------

## Copy-pasted and slightly modified from script "pilot-data_preprocess.R"

# gets name of data files in "mypath" that contain "expname" in their name
get_data_filenames <- function(expname = NULL, mypath = "pilot_analysis/data_coding") {
  myfiles <- list.files(mypath)
  # match only csv files for the right experiment
  mymatch <- paste(".*", expname, ".*\\.csv", sep ="")
  myfiles <- myfiles[grep(mymatch, myfiles)]  
  # Exclude files that start with "TOCODE"
  myfiles <- myfiles[grep("^(?!TOCODE)", myfiles, perl = TRUE)]   
  myfiles
}
# example:
get_data_filenames("sheb_replic_pilot")
length(get_data_filenames("sheb_replic_pilot"))


## FUN that reads individual data files and combines them into single file
## after some processing

# (NB: Perhaps this could be done more economically using the lapply function,
# see https://www.youtube.com/watch?v=8MVgYu0y-E4, but I don't know if it would
# allow for the processing of individual files inside the for-loop, probably not.)

combine_files <- function(file_list = NULL, sep_default = ";", 
                          mypath = "pilot_analysis/data_coding/") {
  df <- data.frame()
  for (f in file_list) {
    curr_f <- paste(mypath, f, sep = "")
    curr_df <- read.csv(curr_f, sep = sep_default, fileEncoding = "UTF-8")
    # if there is a coder column, apply coder's initials (in 1st row) to all rows
    if ("coder" %in% names(curr_df)) curr_df$coder <- curr_df$coder[1]
    # append current df to all previous
    df <- rbind(df, curr_df)
  }
  # some processing is done here but depends on the task, so use IF statements!
  # Block and trial numbers should start at 1 (not zero)
  if ("block" %in% names(df)) df$block <- df$block + 1
  if ("trial" %in% names(df)) df$trial <- df$trial + 1
  # score (at trial level) is 1 iff all four words are reproduced in correct order
  if ("word4" %in% names(df)) {  # this check is sufficient
    m <- as.matrix(df[, c("w1", "w2", "w3", "w4")])
    df$score <- as.numeric(apply(m, 1, sum) == 4)
    }
  df
}


#  ------------------------------------------------------------------------
#  Memory task
#  ------------------------------------------------------------------------

## Read individual data files and combine into a single file after some processing
mem <- combine_files(get_data_filenames("sheb_replic_pilot"))
head(mem)
tail(mem)
str(mem)

length(unique(mem$participant))  # number of participants


## Process

# Participants 900 & 901 carried out 6 blocks (with additional word_duration 
# settings of 250 and 350 ms)
table(mem[mem$participant %in% c(900, 901), "word_duration"])
# We remove the blocks corresponding to word_duration = 0.25 or 0.35
sum(mem$word_duration %in% c(.25, .35))  # 112 observations from 2 participants
mem <- mem[! mem$word_duration %in% c(.25, .35), ]
# We also want to adjust block number so that they lie between 1 and 4 (for
# comparability). This removes all traces of these participants being "different".
unique(mem[mem$participant %in% c(900, 901), c("participant", "block", "word_duration")])
# I solve this almost manually:
# ppt 900
mem[mem$participant == 900, 3:7]  # before
mem[with(mem, participant == 900 & block %in% 2:4), "block"] <- -1 + mem[with(mem, participant == 900 & block %in% 2:4), "block"]
mem[with(mem, participant == 900 & block %in% 6), "block"] <- -2 + mem[with(mem, participant == 900 & block %in% 6), "block"]
mem[mem$participant == 900, 3:7]  # after
# ppt 901
mem[mem$participant == 901, 3:7]  # before
mem[with(mem, participant == 901 & block %in% 3:5), "block"] <- -1 + mem[with(mem, participant == 901 & block %in% 3:5), "block"]
mem[mem$participant == 901, 3:7]  # after

# check everything looks right
unique(mem[mem$participant %in% c(900, 901), c("participant", "block", "word_duration")])
table(mem$word_duration)  # Only our 4 word_durations left in the data

# Files whose "comment" column is completely empty gets this column filled with NAs
head(mem[is.na(mem$comment),])
# replace them by empty characters instead
mem[is.na(mem$comment), "comment"] <- ""


# Trials where all individual words were remembered, yet there is an error?
correct4but_error <- which(with(mem, score == 1 & error != ""))
mem[correct4but_error, ]
# All but one case involve shifts/transpositions -- we will treat them all as 
# errors at the item level
mem$score[correct4but_error] <- 0
rm(correct4but_error)
# And viceversa?
mem[with(mem, score == 0 & error == ""), ]  # these I corrected manually

# What comments are there?
mem$comment[mem$comment != ""]
# Some of them warrant removing the data rows, for example if ppts repeated
# words silently or if the recording is unclear; I remove these observations
# using regex that match those comments
myregex <- "(SILENTLY|UNCLEAR|NOT CLEAR|before the beep|MUMBLES)"
mymatch <- grepl(myregex, mem$comment)
sum(mymatch)  # 20 matches
mem$comment[mymatch]
mem[mymatch,]
# remove those data rows
mem <- mem[!mymatch,]
rm(myregex, mymatch)

# Error coding should follow instructions in document
# team_instructions/data-coding_workflow.md (under "Types of errors")
table(mem$error)
# Replace "0" (zero) with "O"
mem$error <- gsub("0", "O", mem$error)

# create column that contains types of errors explicitly written out:
mem$error_expl <- mem$error
mem$error_expl <- gsub("O", "Omission", mem$error_expl)
mem$error_expl <- gsub("R", "Replacement", mem$error_expl)
mem$error_expl <- gsub("S", "Shift", mem$error_expl)
mem$error_expl <- gsub("A", "Addition", mem$error_expl)
mem$error_expl <- gsub(",", ", ", mem$error_expl)

# For plotting and analyses, express word_duration in ms rather than seconds
mem$word_duration <- mem$word_duration * 1000
mem$SOA <- mem$SOA * 1000


## Save a wide version (1 trial per row) and a long version (1 verb per row) to disk

## wide format
write.csv(mem, "pilot_analysis/data_pilot_memory-task_wide.csv", 
          row.names = FALSE, fileEncoding = "UTF-8")

## long format

# I've used the answer in this thread:
# https://stackoverflow.com/questions/23945350/reshaping-wide-to-long-with-multiple-values-columns
# But I don't get everything in the syntax, e.g. in toy example below, why do
# the arguments to varying need to be passed in that order for the mapping to
# be correct? (so the w1, w2 etc. columns are passed before word1, word2, etc.)

# Toy example for illustration
mytest <- mem[1:4, c(7,10:17)]
mytest

# this comes out right
reshape(mytest, direction = 'long',
        varying = paste(c("w", "word"), rep(1:4, each = 2), sep = ""),
        timevar = 'wordInTrial',
        times = 1:4,
        v.names = c('verb', 'correct'),
        idvar = c('trial')
)
# but here the mapping of the 'verb' and 'correct' columns is wrong -- why??
reshape(mytest, direction = 'long',
        varying = paste(c("word", "w"), rep(1:4, each = 2), sep = ""),
        timevar = 'wordInTrial',
        times = 1:4,
        v.names = c('verb', 'correct'),
        idvar = c('trial')
)

# Anyway, here I apply it to the whole data set:
head(mem)
mem_long <- reshape(mem[, c(3:8, 10:17)],
                    direction = 'long',
                    varying = paste(c("w", "word"), rep(1:4, each = 2), sep = ""),
                    timevar = 'wordInTrial',
                    times = 1:4,
                    v.names = c('verb', 'correct'),
                    idvar = c('participant', 'block', 'trial'))
# reorder rows in a more sensible format (follows the order of wide format)
mem_long <- mem_long[with(mem_long, order(participant, block, trial, wordInTrial)), ]
head(mem_long)
tail(mem_long)

# save to disk
write.csv(mem_long, "pilot_analysis/data_pilot_memory-task_long.csv", 
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Verb bias task
#  ------------------------------------------------------------------------

## Read individual data files and combine into a single file after some processing

get_data_filenames("verb_rating")  # individual file names
length(get_data_filenames("verb_rating"))  # number of data files

bias <- combine_files(get_data_filenames("verb_rating"), sep_default = ",")
head(bias)
tail(bias)
str(bias)
length(unique(bias$participant))  # number of participants

# change the verbs to lower case (as in other data files):
bias$verb <- tolower(bias$verb)

# add a column for the category we had in mind for each verb:
verb_categ <- unique(mem_long[, c("type", "verb")])
verb_categ$verb <- as.character(verb_categ$verb)
bias <- left_join(bias, verb_categ)

# rearrange columns
bias <- bias[, c(1:5, 8, 6:7)]
bias <- bias[, c("expName", "date", "participant", "trial", "verb", "type",
                 "rated_category", "rating")]

head(bias)

# save to disk
write.csv(bias, "pilot_analysis/data_verb-bias.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Verb comprehension task
#  ------------------------------------------------------------------------

## There were two versions of this task:

# 1) a multiple choice version
get_data_filenames("multiple-choice")  # individual file names
length(get_data_filenames("multiple-choice"))  # 11 participants did this version

# 2) a free translation version
get_data_filenames("oral-input")  # individual file names
length(get_data_filenames("oral-input"))  # 6 participants did this version


## 1) Multiple choice version
multi <- combine_files(get_data_filenames("multiple-choice"), sep_default = ",")
head(multi)
tail(multi)
str(multi)
length(unique(multi$participant))  # number of participants

# change the verbs to lower case (as in other data files):
multi$verb <- tolower(multi$verb)

# save to disk
write.csv(multi, "pilot_analysis/data_verb-understanding_multiple-choice.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


# 2) Free translation version
transl <- combine_files(get_data_filenames("oral-input"), sep_default = ";")
head(transl)
tail(transl)
str(transl)
length(unique(transl$participant))  # number of participants

# change the verbs to lower case (as in other data files):
transl$verb <- tolower(transl$verb)

# save to disk
write.csv(transl, "pilot_analysis/data_verb-understanding_free-translation.csv",
          row.names = FALSE, fileEncoding = "UTF-8")
