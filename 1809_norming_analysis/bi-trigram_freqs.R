## This script computes the average bigram and trigram frequencies for the
## list of potential Swedish stimuli words


# Set up workspace and load data ------------------------------------------

library(readr)
library(dplyr)
library(purrr)
library(tibble)

# file path to folder
my_path <- file.path("1809_norming_analysis", "frequency_measures")

# load the stimuli words
words <- read_tsv(file.path(my_path, "filtered_word_unigram_freqs_sv.tsv"),
                  col_names = FALSE) %>%
  rename(words = X1) %>%
  pull(words)
head(words)


# load bi-/trigram frequencies

bi_freq <- read_tsv(file.path(my_path, "filtered_letter_bigram_freqs_sv.tsv"),
                    col_names = FALSE) %>%
  rename(ngram = X1, ngram_freq = X2) %>%
  mutate(ngram_logfreq = log10(ngram_freq))
head(bi_freq)

tri_freq <- read_tsv(file.path(my_path, "filtered_letter_trigram_freqs_sv.tsv"),
                    col_names = FALSE) %>%
  rename(ngram = X1, ngram_freq = X2) %>%
  mutate(ngram_logfreq = log10(ngram_freq))
head(tri_freq)


# Decompose words into character ngrams -----------------------------------

# Function takes a string s and decomposes into its character n-grams
word2ngram <- function (s, n) {
  # the string needs to be of length at least n to build ngrams from it
  if (nchar(s) < n) {
    tibble(Word = s, ngram = NA)
  } else {
    # Prepares the input for the substr function
    tibble(
      word  = s,
      start = 1 : (nchar(s) - n + 1),
      stop  = start - 1 + n
    ) %>%
      # pmap lets you iterate through rows and use columns as arguments
      # _dfr converts the output to a dataframe
      pmap_dfr(function (word, start, stop) {
        tibble(
          Word  = word,
          ngram = substr(word, start, stop)
        )
      })
  }
}

# Apply this function to a vector of words and bind all rows into single df

bigrams  <- map(words, word2ngram, n = 2) %>% bind_rows
head(bigrams)
tail(bigrams)

trigrams <- map(words, word2ngram, n = 3) %>% bind_rows
head(trigrams)
tail(trigrams)


# Compute average ngram frequency per word and save to disk ---------------

# bigram
bigrams %>%
  left_join(bi_freq %>% select(ngram, ngram_logfreq)) %>%
  group_by(Word) %>%
  summarise(bigram_logfreq = mean(ngram_logfreq)) %>%
  write_csv(file.path(my_path, "word_bigram_freqs_sv.csv"))
  
# trigram
trigrams %>%
  left_join(tri_freq %>% select(ngram, ngram_logfreq)) %>%
  group_by(Word) %>%
  summarise(trigram_logfreq = mean(ngram_logfreq)) %>%
  write_csv(file.path(my_path, "word_trigram_freqs_sv.csv"))
