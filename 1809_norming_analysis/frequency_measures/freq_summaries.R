## Summarize the frequency measures from the Swedish SubtLex corpus.

library("dplyr")
library("readr")  # standard read.table etc run into problems

## Total frequencies 

# words
word_all <- read_tsv(
  "1809_norming_analysis/frequency_measures/word_unigram_freqs_sv.tsv"
  )
# Btw, you don't need to specify encoding; readr guesses it:
guess_encoding("1809_norming_analysis/frequency_measures/word_unigram_freqs_sv.tsv")

# Lemmas
lemma_all <- read_tsv(
  "1809_norming_analysis/frequency_measures/lemma_unigram_freqs_sv.tsv"
)

sum(word_all$unigram_freq)
sum(lemma_all$unigram_freq)
# NB: The two numbers are not the same (I think they should if words were 
# uniquely assigned to a POS-tagged lemma). To report corpus size, I take the
# former number to be more reliable


## Filtered frequencies (i.e., only for our list of words)

word_filt <- read_tsv(
  "1809_norming_analysis/frequency_measures/filtered_word_unigram_freqs_sv.tsv",
  col_names = FALSE
  ) %>%
  rename(word = X1, freq = X2)
head(word_filt)
