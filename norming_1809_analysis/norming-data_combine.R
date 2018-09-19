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

# Normed English verbs
verbs_en <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_eng_sept2019_detailed.csv",
                     fileEncoding = "UTF-8")
head(verbs_en)
# simplify - keep only relevant columns and rename if necessary
verbs_en <- verbs_en %>%
  select(verb_category = word_category, verb = word, cognate_bin = cognate_Swe_bin,
         cognate = cognate_Swe_which, in_orig = in_original_study_S.P)
head(verbs_en)

# Normed Swedish verbs
verbs_sw <- read.csv("exp-scripts_psychopy/norming_1809/verbs_norming_swe_sept2019_detailed.csv",
                     fileEncoding = "UTF-8") %>% 
  rename(verb_category = word_category, cognate_bin = cognate, verb = word)

head(verbs_sw)


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

# TO DO:
# - Include info about order L1swe/L2eng


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
write.csv(bias_en, "norming_1809_analysis/data_verb-bias_L2eng.csv",
          row.names = FALSE, fileEncoding = "UTF-8")



#  ------------------------------------------------------------------------
#  Verb bias/norming task - Swedish
#  ------------------------------------------------------------------------

# TO DO:
# - Include info about order L1swe/L2eng


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
bias_sw$expName <- "verb_norming_L2eng_sept"  # keep track of 2 occasions of data collection
bias_sw$verb <- tolower(bias_sw$verb)  # verbs to lower case

# add a column for the category we had in mind for each verb:
verbs_en$verb <- as.character(verbs_en$verb)
bias_sw <- left_join(bias_sw, verbs_en %>% select(verb_category, verb))

# Some verbs were used in the June norming but not in Sept...
index_verbs_in_june_butnot_sept <- ! unique(bias_sw_june$verb) %in% bias_sw$verb
sum(index_verbs_in_june_butnot_sept)
verbs_in_june_butnot_sept <- unique(bias_sw$verb)[index_verbs_in_june_butnot_sept]
verbs_in_june_butnot_sept
# ... and viceversa
index_verbs_in_sept_butnot_june <- ! unique(bias_sw$verb) %in% bias_sw_june$verb
sum(index_verbs_in_sept_butnot_june)
verbs_in_sept_butnot_june <- unique(bias_sw$verb)[index_verbs_in_sept_butnot_june]
verbs_in_sept_butnot_june
# we will want to include this info in final data frame
verb_norms_collected <- data.frame(
  verb = unique(c(bias_sw$verb, bias_sw_june$ver)),
  verb_normed = "june+sept",
  stringsAsFactors = FALSE)
verb_norms_collected[verb_norms_collected$verb %in% verbs_in_june_butnot_sept, "verb_normed"] <- "june"
verb_norms_collected[verb_norms_collected$verb %in% verbs_in_sept_butnot_june, "verb_normed"] <- "sept"
verb_norms_collected <- verb_norms_collected[with(verb_norms_collected, order(verb_normed, verb)), ]
verb_norms_collected

# combine norms from June and Sept, rearranging/renaming some columns
bias_sw_comb <- rbind(
  bias_sw %>% select(expName:verb, category = verb_category, rated_category, rating),
  bias_sw_june %>% select(expName:verb, category = type, rated_category, rating)
)

# include verb-level info about when it was normed
bias_sw_comb <- left_join(bias_sw_comb, verb_norms_collected)

head(bias_sw_comb)

# save to disk
write.csv(bias_sw, "norming_1809_analysis/data_verb-bias_L1swe.csv",
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

# As above, add a column for the category we had in mind for each verb:
multi <- left_join(multi, verb_categ)
# Note that, as we saw above, "pluck" was used in the norming task, but not
# in the memory task:
unique(multi$verb)[! unique(multi$verb) %in% verb_categ$verb]
# and viceversa for "trek"
verb_categ$verb[! verb_categ$verb %in% unique(multi$verb)]
# Assign "pluck" to arm type
multi[multi$verb == "pluck", "type"] <- "arm"

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

# As above, add a column for the category we had in mind for each verb:
transl <- left_join(transl, verb_categ)
# Note that, as we saw above, "pluck" was used in the norming task, but not
# in the memory task:
unique(transl$verb)[! unique(transl$verb) %in% verb_categ$verb]
# and viceversa for "trek"
verb_categ$verb[! verb_categ$verb %in% unique(transl$verb)]
# Assign "pluck" to arm type
transl[transl$verb == "pluck", "type"] <- "arm"

# Look at the comments and recode where necessary (done by GMM)
transl_with_comments <- transl[transl$comment != "", -c(1:2, 5)]
# correct translations of "bash"
transl[grepl("(slå|smälla|förstöra)", transl$ppt_translation) & transl$verb == "bash", ]
transl[grepl("(slå|smälla|förstöra)", transl$ppt_translation) & transl$verb == "bash", "score"] <- 1
# correct translations of "carve"
transl[grepl("(karva|skära|rista)", transl$ppt_translation) & transl$verb == "carve", ]
transl[grepl("(karva|skära|rista)", transl$ppt_translation) & transl$verb == "carve", "score"] <- 1
# correct translations of "clutch"
transl[grepl("hålla", transl$ppt_translation) & transl$verb == "clutch", ]
transl[grepl("hålla", transl$ppt_translation) & transl$verb == "clutch", "score"] <- 1
# correct translations of "crawl"
transl[grepl("krypa", transl$ppt_translation) & transl$verb == "crawl", ]
transl[grepl("krypa", transl$ppt_translation) & transl$verb == "crawl", "score"] <- 1
# correct translations of "file"
transl[grepl("(lägga|arkivera)", transl$ppt_translation) & transl$verb == "file", ]
transl[grepl("(lägga|arkivera)", transl$ppt_translation) & transl$verb == "file", "score"] <- 1
# correct translations of "flit"
transl[grepl("snabbt", transl$ppt_translation) & transl$verb == "flit", ]
transl[grepl("snabbt", transl$ppt_translation) & transl$verb == "flit", "score"] <- 1
# grab
transl[grepl("hålla fast", transl$ppt_translation) & transl$verb == "grab", ]
transl[grepl("hålla fast", transl$ppt_translation) & transl$verb == "grab", "score"] <- 1
# grip
transl[grepl("hålla i", transl$ppt_translation) & transl$verb == "grip", ]
transl[grepl("hålla i", transl$ppt_translation) & transl$verb == "grip", "score"] <- 1
# hike
transl[grepl("gå", transl$ppt_translation) & transl$verb == "hike", ]
transl[grepl("gå", transl$ppt_translation) & transl$verb == "hike", "score"] <- 1
# hop
transl[grepl("hoppa", transl$ppt_translation) & transl$verb == "hop", ]
transl[grepl("hoppa", transl$ppt_translation) & transl$verb == "hop", "score"] <- 1
# inch
transl[grepl("närma sig l", transl$ppt_translation) & transl$verb == "inch", ]
transl[grepl("närma sig l", transl$ppt_translation) & transl$verb == "inch", "score"] <- 1
# leap
transl[grepl("(hopp|ta stort steg)", transl$ppt_translation) & transl$verb == "leap", ]
transl[grepl("(hopp|ta stort steg)", transl$ppt_translation) & transl$verb == "leap", "score"] <- 1
# "bestiga" and some other alternatives for "mount" are correct
transl[grepl("(bestiga|hoppa upp|hoppa på)", transl$ppt_translation) & transl$verb == "mount", ]
transl[grepl("(bestiga|hoppa upp|hoppa på)", transl$ppt_translation) & transl$verb == "mount", "score"] <- 1
# pace
transl[grepl("gå (runt|otåligt)", transl$ppt_translation) & transl$verb == "pace", ]
transl[grepl("gå (runt|otåligt)", transl$ppt_translation) & transl$verb == "pace", "score"] <- 1
# plod
transl[grepl("gå (slarvigt|med svårigheter)", transl$ppt_translation) & transl$verb == "plod", ]
transl[grepl("gå (slarvigt|med svårigheter)", transl$ppt_translation) & transl$verb == "plod", "score"] <- 1
# roam
transl[grepl("(vandra|dra runt)", transl$ppt_translation) & transl$verb == "roam", ]
transl[grepl("(vandra|dra runt)", transl$ppt_translation) & transl$verb == "roam", "score"] <- 1
# "rulla" should count as a correct translation of "roll"
transl[grepl("rulla", transl$ppt_translation) & transl$verb == "roll", ]
transl[grepl("rulla", transl$ppt_translation) & transl$verb == "roll", "score"] <- 1
# rub
transl[grepl("(gnida|massera)", transl$ppt_translation) & transl$verb == "rub", ]
transl[grepl("(gnida|massera)", transl$ppt_translation) & transl$verb == "rub", "score"] <- 1
# skopa for scoop is correct
transl[grepl("skopa", transl$ppt_translation) & transl$verb == "scoop", ]
transl[grepl("skopa", transl$ppt_translation) & transl$verb == "scoop", "score"] <- 1
# seize
transl[grepl("(ta tag|tillfångata)", transl$ppt_translation) & transl$verb == "seize", ]
transl[grepl("(ta tag|tillfångata)", transl$ppt_translation) & transl$verb == "seize", "score"] <- 1
# "skejta" for "skate" is correct
transl[grepl("skejta", transl$ppt_translation) & transl$verb == "skate", ]
transl[grepl("skejta", transl$ppt_translation) & transl$verb == "skate", "score"] <- 1
# "skumma" for "skim" is correct
transl[grepl("skumma", transl$ppt_translation) & transl$verb == "skim", ]
transl[grepl("skumma", transl$ppt_translation) & transl$verb == "skim", "score"] <- 1
# skip
transl[grepl("(småhoppa|hoppsa)", transl$ppt_translation) & transl$verb == "skip", ]
transl[grepl("(småhoppa|hoppsa)", transl$ppt_translation) & transl$verb == "skip", "score"] <- 1
# "slog/slå" for "slap" is ok
transl[grepl("sl", transl$ppt_translation) & transl$verb == "slap", ]
transl[grepl("sl", transl$ppt_translation) & transl$verb == "slap", "score"] <- 1
# slip
transl[grepl("snubbla", transl$ppt_translation) & transl$verb == "slip", ]
transl[grepl("snubbla", transl$ppt_translation) & transl$verb == "slip", "score"] <- 1
# slither
transl[grepl("(kräla|slingra)", transl$ppt_translation) & transl$verb == "slither", ]
transl[grepl("(kräla|slingra)", transl$ppt_translation) & transl$verb == "slither", "score"] <- 1
# snatch
transl[grepl("(ta|fånga)", transl$ppt_translation) & transl$verb == "snatch", ]
transl[grepl("(ta|fånga)", transl$ppt_translation) & transl$verb == "snatch", "score"] <- 1
# sprint
transl[grepl("(springa|sprinta)", transl$ppt_translation) & transl$verb == "sprint", ]
transl[grepl("(springa|sprinta)", transl$ppt_translation) & transl$verb == "sprint", "score"] <- 1
# stagger
transl[grepl("gå klumpigt", transl$ppt_translation) & transl$verb == "stagger", ]
transl[grepl("gå klumpigt", transl$ppt_translation) & transl$verb == "stagger", "score"] <- 1
# stray
transl[grepl("gå ifrån", transl$ppt_translation) & transl$verb == "stray", ]
transl[grepl("gå ifrån", transl$ppt_translation) & transl$verb == "stray", "score"] <- 1
# stride
transl[grepl("gå (fort|snabbt|beslutsamt)", transl$ppt_translation) & transl$verb == "stride", ]
transl[grepl("gå (fort|snabbt|beslutsamt)", transl$ppt_translation) & transl$verb == "stride", "score"] <- 1
# stroll
transl[grepl("promenera", transl$ppt_translation) & transl$verb == "stroll", ]
transl[grepl("promenera", transl$ppt_translation) & transl$verb == "stroll", "score"] <- 1
# correct transl for "strut"
transl[grepl("good news", transl$ppt_translation) & transl$verb == "strut", ]
transl[grepl("good news", transl$ppt_translation) & transl$verb == "strut", "score"] <- 1
# traipse
transl[grepl("gå försiktigt", transl$ppt_translation) & transl$verb == "traipse", ]
transl[grepl("gå försiktigt", transl$ppt_translation) & transl$verb == "traipse", "score"] <- 1
# tread
transl[grepl("går? försiktigt", transl$ppt_translation) & transl$verb == "tread", ]
transl[grepl("går? försiktigt", transl$ppt_translation) & transl$verb == "tread", "score"] <- 1
# trot
transl[grepl("galoppera", transl$ppt_translation) & transl$verb == "trot", ]
transl[grepl("galoppera", transl$ppt_translation) & transl$verb == "trot", "score"] <- 1  # preserves the leg association and overall meaning
# trudge
transl[grepl("gå", transl$ppt_translation) & transl$verb == "trudge", ]
transl[grepl("gå", transl$ppt_translation) & transl$verb == "trudge", "score"] <- 1
# twine
transl[grepl("(fläta|nysta)", transl$ppt_translation) & transl$verb == "twine", ]
transl[grepl("(fläta|nysta)", transl$ppt_translation) & transl$verb == "twine", "score"] <- 1
# wobble
transl[grepl("(stappla|pendla)", transl$ppt_translation) & transl$verb == "wobble", ]
transl[grepl("(stappla|pendla)", transl$ppt_translation) & transl$verb == "wobble", "score"] <- 1
# wrap
transl[grepl("", transl$ppt_translation) & transl$verb == "wrap", ]
transl[grepl("omge", transl$ppt_translation) & transl$verb == "wobble", "score"] <- 1


# save to disk
write.csv(transl, "pilot_analysis/data_verb-understanding_free-translation.csv",
          row.names = FALSE, fileEncoding = "UTF-8")
