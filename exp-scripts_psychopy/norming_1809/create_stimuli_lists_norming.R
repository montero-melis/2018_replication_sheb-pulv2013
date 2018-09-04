## Create stimuli lists from the more detailed lists of verbs that need to be
## normed (downloaded from Google Drive)

getwd()

#  ------------------------------------------------------------------------
#  English verbs
#  ------------------------------------------------------------------------

norming <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_eng_sept2019_detailed.csv")
head(norming)

norming_simple <- data.frame(word = toupper(as.character(norming$word)))
norming_simple$word <- trimws(norming_simple$word)
head(norming_simple)

sum(table(norming_simple$word) != 1)  # Check no repeated verbs (value has to be zero!)

write.csv(norming_simple,
          "exp-scripts_psychopy/norming_1809/verbs_norming_eng_sept2019_simple.csv", 
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Swedish verbs
#  ------------------------------------------------------------------------

norming_sw <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_swe_sept2019_detailed.csv",
                       fileEncoding = "UTF-8")
head(norming_sw)

norming_sw_simple <- data.frame(word = toupper(as.character(norming_sw$word)))
norming_sw_simple$word <- trimws(norming_sw_simple$word)
head(norming_sw_simple)

sum(table(norming_sw_simple$word) != 1)  # Check no repeated verbs (value has to be zero!)

write.csv(norming_sw_simple,
          "exp-scripts_psychopy/norming_1809/verbs_norming_swe_sept2019_simple.csv", 
          row.names = FALSE, fileEncoding = "UTF-8")
