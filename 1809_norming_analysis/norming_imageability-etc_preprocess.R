## This script pre-processes the data for verb norms collected for the Shebani
## & Pulvermüller (2013) replication

# The three tasks were:
# 1) Imageability; 2) arousal; 3) valence.
# All used a 7-point scale.
# The data were collected by Margareta Majchrowska in May 2019.


library("dplyr")
library("readr")
library("tidyr")


# Load and check out ------------------------------------------------------

# raw data -- note that the output from google forms is completely wide
d_raw <- read_csv("1809_norming_analysis/data_verb-norming_swe_raw_google-docs.csv")
head(d_raw)

# change name of last column
names(d_raw)[ncol(d_raw)]
names(d_raw)[grep("kommentarer", names(d_raw))] <- "Comment"
names(d_raw)[ncol(d_raw)]

# Add a Subject ID column
d_raw$SubjID <- seq_len(nrow(d_raw))

# Description of the raw data:
# - There is data from 25 subjects, each in one row
# - The roughly 160 verbs each appear three times (once per task)
# - There were two empty columns separating the verbs from each task.



# Save participant (meta) data --------------------------------------------

# Extract the metadata (everything but word ratings) and save to file
d_meta <- d_raw %>% 
  select(SubjID, TimeDate, Age, Sex, SwedishStatus, Comment)
d_meta
# # save to disk
# write_csv(d_meta, "1809_norming_analysis/190523_verb-norming_participant-data.csv")



# Exclude participants? ---------------------------------------------------

# Do we need to remove data from participants who indicated Swedish wasn't their
# native language?
table(d_meta$SwedishStatus)  # No, all indicated they were native (3 multilinguals)



# From wide to long format ------------------------------------------------

# Transform the actual data to long format; keep only relevant columns
names(d_raw)
# see http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/
d <- d_raw %>% select(SubjID, everything(), -Age, -TimeDate, -Sex, -SwedishStatus,
                      -Comment) %>%
  gather(Word, Rating, be : strutta_2)
head(d)



# Add task information ----------------------------------------------------

# We need to divide the words by task:
unique(d$Word)
d$Task <- NA
d$Task[grep("[^12]$", d$Word)] <- "imageability"
d$Task[grep("_1$", d$Word)]    <- "arousal"
d$Task[grep("_2$", d$Word)]    <- "valence"

head(d)
tail(d)

# Now remove the trailing "_1" and "_2" from Word
d$Word <- sub("_[12]", "", d$Word)



# Sanity checks -----------------------------------------------------------

# Check that each word appears the same number of times in each task
with(d, table(Word, Task))
# Looks good, but remove the "meaningless" words (coming from empty columns):
d <- d[! d$Word %in% c("X165", "X326"), ]
# Check again
sum(with(d, table(Word, Task)) != 25)  # good: 25 occurrences of each word/task!

# All tasks should have the same number of observations (verb ratings)
table(d$Task)
unique(d$Task)  # No NAs: each row has been assigned a Task

# How many unique words?
length(unique(d$Word))  # 160 looks good



# Save to disk ------------------------------------------------------------

write_csv(d, "1809_norming_analysis/data_verb-norming_swe_ratings.csv")
