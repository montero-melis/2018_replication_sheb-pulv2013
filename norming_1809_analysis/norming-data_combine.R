## Process and combine individual participant data

# This script takes the norming data after coding and combines it into single
# data files for each task, saving it to disk after some processing. 
# Tasks:
# 1. Verb ratings Swedish (L1),
# 2. Verb ratings English (L2), 
# 3. Verb understanding English (L2).


library(dplyr)  # for left_join, pipe operator ("%>%"), etc


#  ------------------------------------------------------------------------
#  Data files
#  ------------------------------------------------------------------------

## Normed English verbs
verbs_en <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_eng_sept2019_detailed.csv",
                     fileEncoding = "UTF-8")
head(verbs_en)
# simplify - keep only relevant columns and rename if necessary
verbs_en <- verbs_en %>%
  select(verb_category = word_category, verb = word, cognate_bin = cognate_Swe_bin,
         cognate = cognate_Swe_which, in_orig = in_original_study_S.P)
head(verbs_en)

## Normed Swedish verbs
verbs_sw <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_swe_sept2019_detailed.csv",
                     fileEncoding = "UTF-8") %>% 
  rename(verb_category = word_category, cognate_bin = cognate, verb = word)

head(verbs_sw)

## Participant info
ppt <- read.csv("norming_1809_analysis/data_coding/participant_info.csv",
                fileEncoding = "UTF-8")
# clarify order of tasks
ppt <- ppt %>% mutate(
  lang_order = ifelse(eng_swe_first == "eng", "English-Swedish", "Swedish-English"),
  Sex = ifelse(Sex == "f", "female", "male"),
  eng_swe_first = NULL)

head(ppt)
str(ppt)

# save to disk
write.csv(ppt, "norming_1809_analysis/participant_info.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Functions
#  ------------------------------------------------------------------------

## Copy-pasted and slightly modified from script "pilot-data_preprocess.R"

# gets name of data files in "mypath" that contain "expname" in their name
get_data_filenames <- function(expname = NULL, 
                               mypath = "norming_1809_analysis/data_coding/") {
  myfiles <- list.files(mypath)
  # match only csv files for the right experiment
  mymatch <- paste(".*", expname, ".*\\.csv", sep ="")
  myfiles <- myfiles[grep(mymatch, myfiles)]  
  # Exclude files that start with "TOCODE" or "CODING")
  myfiles <- myfiles[grep("^(?!(TOCODE|CODING))", myfiles, perl = TRUE)]   
  myfiles
}
# example:
get_data_filenames("rating_L1swe")
get_data_filenames("rating_L2eng")
get_data_filenames("oral_transl")
length(get_data_filenames("oral_transl"))


## FUN that reads individual data files and combines them into single file
## after some processing

# (NB: Perhaps this could be done more economically using the lapply function,
# see https://www.youtube.com/watch?v=8MVgYu0y-E4, but I don't know if it would
# allow for the processing of individual files inside the for-loop, probably not.)

combine_files <- function(file_list = NULL, sep_default = ";", 
                          mypath = "norming_1809_analysis/data_coding/") {
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
#  Verb bias/norming task - English
#  ------------------------------------------------------------------------

## Read individual data files and combine into single file after processing

# verb norms collected in June 2018
bias_en_june <- read.csv("pilot_analysis/data_verb-bias.csv", stringsAsFactors = FALSE)
bias_en_june$expName <- "verb_norming_L2eng_june"

# verb norms collected in Sept 2018
get_data_filenames("verb_rating_L2eng")  # individual file names
length(get_data_filenames("verb_rating_L2eng"))  # number of data files
bias_en <- combine_files(get_data_filenames("verb_rating_L2eng"), sep_default = ",")

# sanity checks
head(bias_en)
str(bias_en)
length(unique(bias_en$participant))  # number of participants = 12?
table(bias_en$participant)  # equal number of observations per participant?

# some processing
bias_en$expName <- "verb_norming_L2eng_sept"  # keep track of 2 occasions of data collection
bias_en$verb <- tolower(bias_en$verb)  # verbs to lower case

# add a column for the category we had in mind for each verb:
verbs_en$verb <- as.character(verbs_en$verb)
bias_en <- left_join(bias_en, verbs_en %>% select(verb_category, verb))

# Some verbs were used in the June norming but not in Sept...
index_verbs_in_june_butnot_sept <- ! unique(bias_en_june$verb) %in% bias_en$verb
sum(index_verbs_in_june_butnot_sept)
verbs_in_june_butnot_sept <- unique(bias_en$verb)[index_verbs_in_june_butnot_sept]
verbs_in_june_butnot_sept
# ... and viceversa
index_verbs_in_sept_butnot_june <- ! unique(bias_en$verb) %in% bias_en_june$verb
sum(index_verbs_in_sept_butnot_june)
verbs_in_sept_butnot_june <- unique(bias_en$verb)[index_verbs_in_sept_butnot_june]
verbs_in_sept_butnot_june
# we will want to include this info in final data frame
verb_norms_collected <- data.frame(
  verb = unique(c(bias_en$verb, bias_en_june$ver)),
  verb_normed = "june+sept",
  stringsAsFactors = FALSE)
verb_norms_collected[verb_norms_collected$verb %in% verbs_in_june_butnot_sept, "verb_normed"] <- "june"
verb_norms_collected[verb_norms_collected$verb %in% verbs_in_sept_butnot_june, "verb_normed"] <- "sept"
verb_norms_collected <- verb_norms_collected[with(verb_norms_collected, order(verb_normed, verb)), ]
verb_norms_collected

# combine norms from June and Sept, rearranging/renaming some columns
bias_en_comb <- rbind(
  bias_en %>% select(expName:verb, category = verb_category, rated_category, rating),
  bias_en_june %>% select(expName:verb, category = type, rated_category, rating)
)

# include verb-level info about when it was normed
bias_en_comb <- left_join(bias_en_comb, verb_norms_collected)

head(bias_en_comb)

# save to disk
write.csv(bias_en_comb, "norming_1809_analysis/data_verb-bias_L2eng.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Verb bias/norming task - Swedish
#  ------------------------------------------------------------------------

## Read individual data files and combine into single file after processing

# verb norms collected in Sept 2018
get_data_filenames("verb_rating_L1swe")  # individual file names
length(get_data_filenames("verb_rating_L1swe"))  # number of data files

bias_sw <- combine_files(get_data_filenames("verb_rating_L1swe"), sep_default = ",")

# sanity checks
head(bias_sw)
str(bias_sw)
length(unique(bias_sw$participant))  # number of participants = 12?
table(bias_sw$participant)  # equal number of observations per participant?

# some processing
bias_sw$expName <- "verb_norming_L1swe"
bias_sw$verb <- tolower(bias_sw$verb)  # verbs to lower case
# Due to an oversight, there are two different labels for each of the two
# levels of rated_category; fix this
levels(bias_sw$rated_category)
bias_sw$rated_category <- ifelse(grepl("Arm", bias_sw$rated_category), "Arm", "Leg")

# add a column for the category we had in mind for each verb:
verbs_sw$verb <- as.character(verbs_sw$verb)
bias_sw <- left_join(bias_sw, verbs_sw %>% select(verb_category, verb))


# Rearrange/rename some columns
bias_sw <- bias_sw %>%
  select(expName:verb, category = verb_category, rated_category, rating)

head(bias_sw)
head(bias_en_comb)  # the two should look the same except for last column

# save to disk
write.csv(bias_sw, "norming_1809_analysis/data_verb-bias_L1swe.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


#  ------------------------------------------------------------------------
#  Verb comprehension task
#  ------------------------------------------------------------------------

## Create file for scoring translations as rigth or wrong

# Participants orally provided their Swedish translation of English verbs:
get_data_filenames("oral_translat")  # individual file names
length(get_data_filenames("oral_translat"))  # nb of (coded!) participants

transl <- combine_files(get_data_filenames("oral_translat"), sep_default = ";")
# change the verbs to lower case (as in other data files):
transl$verb <- tolower(transl$verb)
# Empty comments or translation_details should appear as empty, not as NAs
# (Inconsistency is caused by some participants not having any comment)
transl$comment[is.na(transl$comment)] <- ""
transl$translation_details[is.na(transl$translation_details)] <- ""

# check out
head(transl)
str(transl)
length(unique(transl$participant))  # number of participants

# take all the unique translations and save to disk
transl_unique <- unique(transl[, c("verb", "translation_simple", "translation_details", "comment")])
# Add columns for scoring
transl_unique$score <- ""
transl_unique$score_comment <- ""
transl_unique$coder <- ""

head(transl_unique)

# reorder rows (for ease of scoring) and save to disk:
transl_unique <- transl_unique %>% 
  arrange(verb, translation_simple, translation_details)
# Save to disk
write.csv(transl_unique,
          "norming_1809_analysis/data_coding/eng-swe_translation_key_DO-NOT-SCORE-HERE.csv",
          row.names = FALSE, fileEncoding = "UTF-8")


#####################################################################
# Do the scoring manually and assess inter-rater agreement (separate script!)
#####################################################################

# TO DO:

# Load the final scoring of unique responses (after resolving disagreements
# between raters), see script <script-name>


# Add this info to the full data file
# transl_scored <- left_join(transl, transl_key)


# As above, add columns for verb category and other verb info:
# transl_scored <- left_join(transl_scored, verbs_en)



# # save to disk
# write.csv(transl_scored, "norming_1809_analysis/data_verb-understanding_free-translation.csv",
#           row.names = FALSE, fileEncoding = "UTF-8")
