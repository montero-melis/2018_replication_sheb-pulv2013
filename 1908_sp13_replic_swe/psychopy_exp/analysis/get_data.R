## Script to obtain the data that will go into the analysis.

# It involves the following steps:
# - Select the relevant participants (e.g., first 60, 72, ...)
# - Extract the design matrix for those participants
# - Merge with the transcription data to obtain accuracy score per trial
# - Exclude invalid trials or whole participants
# - Save data set to disk
# NB: Most of these steps will call custom functions saved in a separate
# script for clarity.


library("tidyverse")

# load custom functions:
source("1908_sp13_replic_swe/psychopy_exp/analysis/myfunctions/extract_info_fncs.R")


# Extract design matrix for relevant participants -------------------------

# Parse all data files from participants that are not obviously invalid:
fnames <- parse_all_datafiles()
head(fnames)

# Select the first 60 (they are ordered by DateTime)
fnames_60 <- fnames %>% head(60) %>% pull(filename)
fnames_60

# Extract participants' design matrices
data60 <- map(fnames_60, extract_design_matrix) %>%
  bind_rows()
head(data60)

# Verify that this contains exactly 26 x 4 = 104 trials per participant-block
data60 %>%
  group_by(ID_unique, block) %>%
  count() %>%
  filter(n != 104)
# Good! (Empty tibble means all have 104)


# Process transcriptions --------------------------------------------------

# load file with RA transcriptions and process them with prepare_transcriptions()
transcr <- read_tsv("1908_sp13_replic_swe/psychopy_exp/transcriptions.tsv") %>%
  prepare_transcriptions()
head(transcr)

# Sanity checks - are all trials for all participants transcribed? Quick check:
# to see if we have equal amount of transcriptions for every block:
transcr %>%
  group_by(block) %>%
  count()
# No. Let's look at which participants are the affected ones (perhaps they 
# haven't been fully transcribed yet)
transcr %>%
  group_by(ID_unique) %>%
  count() %>%
  filter(n != 26 * 3)
# These are not a problem: 9 is excluded and 60 not ready yet


# Merge transcriptions into data file -------------------------------------

# Check whether all trials in the data file have been transcribed
data60_trials <- with(data60, unique(paste(ID_unique, block, trial_block, sep = "_")))
transcr_trials <- with(transcr, paste(ID_unique, block, trial_block, sep = "_"))
sum(! data60_trials %in% transcr_trials)  # Yes! (0 missing transcriptions)

# Merge
data60_full <- left_join(data60, transcr)
head(data60_full)

# We can check that there are no missing values among descriptions
# NB: An empty description is an empty string (""), while a missing description
# is NA.
sum(is.na(data60_full$transcription))

# Any participants that don't have 312 observations at this point?
data60_full %>%
  group_by(ID_unique) %>%
  count() %>%
  filter(n != 26 * 3 * 4)
# No!


# Score each trial --------------------------------------------------------

# compute the score by checking if the verb in a trial is in transcr_list
data60_scored <- data60_full %>%
  mutate(error = map2_dbl(verb, transcr_list, ~ ! .x %in% .y))
data60_scored


# Exclusion based on paradiddles ------------------------------------------

# load list of trials to be excluded:
parad_excl <- read_csv("1908_sp13_replic_swe/psychopy_exp/analysis/excluded_trials_bc_of_paradiddle.csv")
head(parad_excl)

# Number of trials to be excluded (each excluded trial removes 4 observations)
# But note that this is an upper bound because it includes all participants,
# not just the first 60 or the transcribed ones, etc.
nrow(parad_excl)

# Exclude trials
parad_excl_trials <- with(parad_excl, 
                          paste(ID_unique, block, trial_block, sep = "_"))
data60_scored_trials <- with(data60_scored, 
                           paste(ID_unique, block, trial_block, sep = "_"))
# number of excluded observations (recall: 1 trial = 4 observations)
sum(data60_scored_trials %in% parad_excl_trials)  # these are the number of
# keep only trials that are not in the to-be-excluded list
data60_scored <- data60_scored[! data60_scored_trials %in% parad_excl_trials, ]


# Manual exclusion for individual cases -----------------------------------

# There is for now no trial to be excluded manually. This would be needed if
# trials needed to be excluded because of notes taking by the RA during data
# collection, such as participants starting a trial before a beep.

# Check handedness
ppts <- read_csv("1908_sp13_replic_swe/psychopy_exp/participant_data.csv") %>%
  select(c(1, 13))
names(ppts)[2] <- "handedness"
table(ppts$handedness)
# Non right-handed participants
ppts %>%
  filter(handedness != "Högerhänt")


# Save to disk ------------------------------------------------------------

data60_scored %>%
  select(-transcr_list) %>%
  rename(word_type = trial_type) %>%
  write_csv("1908_sp13_replic_swe/psychopy_exp/analysis/data60.csv")
