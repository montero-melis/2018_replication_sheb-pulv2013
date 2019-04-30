## Check out the words normed in Vinson & Vigliocco (2008, BRM) and select a
## subset as fillers for our own norming study.

library(dplyr)

vv <- read.table("1809_norming_analysis/vinson-vigliocco_2008_norms_word_categories.txt",
                 sep = "\t", header = TRUE)
head(vv)
str(vv)

# different semantic categories of words:
levels(vv$semantic)
with(vv, table(type, semantic))

# Check out some candidates
vv %>% filter(semantic == "communication")
vv %>% filter(semantic == "change-state")
vv %>% filter(semantic == "misc.artifact")


## Way to go about:
# 1) Exclude nouns (actionN and object)
# 2) Exclude semantic categories that are too close to our arm/leg verbs
# 3) Remove individual that don't fit (e.g., still arm/leg related)
# 4) Save to disk and translate them to Swedish
# 5) Choose 40 among that list
levels(vv$type)
sel <- vv %>% 
  filter(type == "actionV") %>%
  filter(semantic %in% c("body-sense", "communication", "exchange", 
                         "light-emission", "noise", "noise-animal",
                         "not_in_original_study")) %>%
  filter(! word %in% c("ACHE", "TOUCH",
                       "CHAT", "GREET", "WRITE", 
                       "ACQUIRE", "BORROW", "BUY", "EXCHANGE", "GET", "GIVE",
                       "LEND", "LOAN", "PAY", "RECEIVE", "SELL", "TAKE",
                       "BURN", "FLAME",
                       "SNAP")) %>%
  arrange(semantic, word) %>%
  rename(semantic_category = semantic)

sel

write.csv(sel %>% select(-ID), "1809_norming_analysis/vinson-vigliocco_2008_filler-selection.txt",
          row.names = FALSE)
