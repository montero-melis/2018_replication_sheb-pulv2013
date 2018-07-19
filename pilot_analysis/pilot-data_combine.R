## Process and combine individual participant data

# This script takes the pilot data after coding and combines it into single
# data files for each task, saving it to disk after some processing. 
# Tasks: 1. Memory task, 2. Verb ratings, 3. Verb understanding.


#  ------------------------------------------------------------------------
#  Functions
#  ------------------------------------------------------------------------

## Copy-pasted and slightly modified from script "pilot-data_preprocess.R"

# gets name of data files in "mypath" that contain "expname" in their name
get_data_filenames <- function(mypath = NULL, expname = NULL) {
  myfiles <- list.files(mypath)
  # match only csv files for the right experiment
  mymatch <- paste(".*", expname, ".*\\.csv", sep ="")
  myfiles <- myfiles[grep(mymatch, myfiles)]  
  # Exclude files that start with "TOCODE"
  myfiles <- myfiles[grep("^(?!TOCODE)", myfiles, perl = TRUE)]   
  myfiles
}
# example:
get_data_filenames("pilot_analysis/data_coding", "sheb_replic_pilot")
length(get_data_filenames("pilot_analysis/data_coding", "sheb_replic_pilot"))


#  ------------------------------------------------------------------------
#  Memory task
#  ------------------------------------------------------------------------

## Read individual data files and combine into a single file after some processing

# (NB: Perhaps this could be done more economically using the lapply function
# see https://www.youtube.com/watch?v=8MVgYu0y-E4 but I don't know if it would
# allow for the processing of individual files inside the for-loop, probably not.)

combine_files <- function(file_list = NULL, sep_default = ";", 
                          mypath = "pilot_analysis/data_coding/") {
  df <- data.frame()
  for (f in file_list) {
    curr_f <- paste(mypath, f, sep = "")
    curr_df <- read.csv(curr_f, sep = sep_default)
    # if there is a coder column, apply coder's initials (in 1st row) to all rows
    if ("coder" %in% names(curr_df)) curr_df$coder <- curr_df$coder[1]
    # append current df to all previous
    df <- rbind(df, curr_df)
  }
  # Block and trial numbers should start at 1 (not zero)
  df$block <- df$block + 1
  df$trial <- df$trial + 1
  # score (at trial level) is 1 iff all four words are reproduced in correct order
  m <- as.matrix(df[, c("w1", "w2", "w3", "w4")])
  df$score <- as.numeric(apply(m, 1, sum) == 4)
  df
}

mem <- combine_files(get_data_filenames("pilot_analysis/data_coding", "sheb_replic_pilot"))
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
