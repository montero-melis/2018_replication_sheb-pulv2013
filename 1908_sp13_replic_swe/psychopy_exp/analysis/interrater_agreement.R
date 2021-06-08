## Compute inter-rater agreement based on 5% of data from 60 participants.

library("tidyverse")

pi <- read_tsv("1908_sp13_replic_swe/psychopy_exp/transcription_petrus.tsv") %>%
  arrange(filename)
mb <- read_tsv("1908_sp13_replic_swe/psychopy_exp/transcription_MB.tsv") %>%
  arrange(filename)

head(pi)
head(mb)

# Have the same files been transcribed?
sum(! pi$filename %in% mb$filename)
sum(! mb$filename %in% pi$filename)
# Yes!


# Extract information -----------------------------------------------------

# Function to extract information from transcribed file names
extract_fileinfo <- function(fname) {
  mypattern <- "^(\\d+)(_.*)_block_(\\d).*_(\\d+)\\.wav"
  tibble(
    basefile = gsub(mypattern, "\\1\\2", fname),
    ID    = as.numeric(gsub(mypattern, "\\1", fname)),
    block = as.numeric(gsub(mypattern, "\\3", fname)),
    trial = as.numeric(gsub(mypattern, "\\4", fname))
  )
}
f_info <- extract_fileinfo(pi$filename)
# shows which trials have been transcribed and associated base files
head(f_info)


# function to extract the target words for each selected trial
extract_trials <- function(basefile, ID, block, trial) {
  path2folder <- "1908_sp13_replic_swe/psychopy_exp/data/"
  df <- read_csv(paste0(path2folder, basefile, ".csv"))
  df %>%
    # select appropriate trial
    filter(
      block.thisN == block - 1,
      word_presentation.thisN == trial
      ) %>%
    # include identifying info provided as arguments
    mutate(participant = ID, block = block, trial = trial) %>%
    # extract relevant info from the csv file
    select(
      participant, block, block_type = BlockType, word1:word4, trial, 
      trial_type = type
      ) %>%
    # convert to long format, 1 row per word in a trial (i.e., 4 rows per trial)
    pivot_longer(word1:word4, names_to = "word", values_to = "verb") %>%
    mutate(word = gsub("word(\\d)", "\\1", word))
}
# pmap() allows us to apply a function taking each row as arguments, see
# http://zevross.com/blog/2019/06/11/the-power-of-three-purrr-poseful-iteration-in-r-with-map-pmap-and-imap/
targets <- pmap(f_info, extract_trials) %>%
  bind_rows()
# NB: warnings are caused by an empty column in csv files

head(targets)
tail(targets)


# arrange the transcriptions in more convenient format: for each trial,
# associate a character string that contains the transcribed words
clean_transcriptions <- function(df, transcriber) {
  df <- df %>%
    mutate(transcr = str_split(transcription, " ")) %>%
  select(participant, block, trial, transcr)
  names(df)[names(df) == "transcr"] <- paste0("transcr_", transcriber)
  df
}
petrus <- clean_transcriptions(pi, "petrus")
manne <- clean_transcriptions(mb, "manne")

head(petrus)
head(manne)
# the last column is a list of strings of variable length
head(petrus$transcr_petrus)


# Compute inter-rater agreement -------------------------------------------

# First, join all the information into a single data frame
targets <- targets %>%
  left_join(petrus) %>%
  left_join(manne)
head(targets)

# convenience function used below
check_transcription <- function(target, transcr) {
  target %in% transcr
}

# compute the agreement
agreement <- targets %>%
  mutate(
    Petrus = map2_dbl(verb, transcr_petrus, check_transcription),
    Manne  = map2_dbl(verb, transcr_manne, check_transcription)
  ) %>%
  mutate(agreement = ifelse(Petrus == Manne, 1, 0))

# for sanity, check the first rows to verify that everything looks good:
for (row in 1:40) {
  print(paste("TARGET: ", agreement$verb[row]))
  print(targets[row, "transcr_petrus"][[1]])
  print(targets[row, "transcr_manne"][[1]])
  cat("\n\n")
}

# for sanity, check the disagreements...
for (row in which(agreement$agreement == 0)) {
  print(paste("TARGET: ", agreement$verb[row]))
  print(targets[row, "transcr_petrus"][[1]])
  print(targets[row, "transcr_manne"][[1]])
  cat("\n\n")
}

# Total agreement in percentage
round(100 * with(agreement, sum(agreement) / length(agreement)), 2)
