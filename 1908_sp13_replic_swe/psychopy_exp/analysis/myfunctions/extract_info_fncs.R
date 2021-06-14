## Set of functions used to extract information from datafiles ()either those
## generated in Psychopy or our own transcription files)


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


# Function to extract the target words for each selected trial.
# It is designed to be used with pmap, with the output of extract_fileinfo()
# as input (each row specifies the function parameters). For pmap(), see
# http://zevross.com/blog/2019/06/11/the-power-of-three-purrr-poseful-iteration-in-r-with-map-pmap-and-imap/
extract_trial_selection <- function(basefile, ID, block, trial) {
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
