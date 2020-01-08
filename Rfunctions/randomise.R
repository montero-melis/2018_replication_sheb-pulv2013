## Functions used to randomise item presentation 
##(sourced from "exp-scripts_psychopy/stimuli/create_experimental_lists.R")

# Presentation of items is randomized at two levels and with certain constraints:
# Level 1: In each block, the order of the 4 words that form an item is shuffled.
# (this means the item has the same words, but in different orders between blocks.)
# Level 2: The sequence of items presented in a block is random "with the 
# constraint that not more than three trials of the same word category appeared
# consecutively." (Shebani & Pulvermüller, 2013:225)


## Level 1 - words within items
# NB [20-01-07]: This function is not used for our study submitted to Cortex!
# Instead we have three lists and the words within a quadruple is fixed.

# function to shuffle the order of the 4 words in each item
shuffle_words <- function(df) {
  # check the provided df has the expected format
  if(sum(names(df)[3:6] != paste("word", 1:4, sep = ""))) {
    stop("I'm expecting something else; check the input!")
  }
  # read the words row by row and save as vector
  shuffle <- as.vector(t(as.matrix(df[, 3:6])))
  nb_items <- length(shuffle) / 4  # number of items
  # index the position directly before the first word of each item
  item_index <- 4 * (0 : (length(shuffle) - 1)) %/% 4
  reshuffle <- replicate(nb_items, sample(4))  # reshuffle 1:4 nb_items times
  myindex <- item_index + as.vector(reshuffle)
  shuffled <- matrix(shuffle[myindex], ncol = 4, byrow = TRUE)
  df[, 3:6] <- shuffled
  df
}


## Level 2 - items within blocks

# Function to randomize items in a block (but not more than 3 items of the same
# category in a row) -- kinda brute force approach (quicker than conditional checking?)

# It takes the items dataframe and shuffles the rows until it finds an order
# that works. It returns the reordered data frame.
# (A wordy function, but I had to do massive debugging, so I prefer being super clear)
valid_seq <- function(df = items) {
  found_valid <- FALSE  # terminate the while loop when found_valid
  while_counter <- 0  # counts through while loop
  nb_items <- nrow(df)  # number of items for convenience
  while (! found_valid) {
    while_counter <- while_counter + 1
    print(paste("Okay, we have tried", while_counter, "time(s)"))
    df <- df[sample(seq.int(nb_items)),]  # shuffle the items
    categ_seq <- df$type  # extract sequence of item category (e.g., arm-arm-leg-...)
    counter <- 1  # counts number of same-category items repeated in a row
    valid_items <- 1  # counts number of items so far that don't violate constraint
    curr_val <- categ_seq[1]  # last value looped through
    for (i in 2:length(categ_seq)) {
      if (categ_seq[i] != curr_val) {  # if category different from previous trial
        curr_val <- categ_seq[i]  # update
        counter  <- 1  # reset
      } else {  # it's the same category as previous trial
        if (counter == 3) {  # We have violated the constraint
          print(paste("Failure! see for yourself: I'm breaking after row", valid_items))
          print(df)  # print the failure
          break  # the important statement
        }
        counter <- counter + 1
      }
      valid_items <- valid_items + 1
    }
    # We may be here bc we're through or bc we've failed (and broken)
    if (valid_items == nb_items) found_valid <- TRUE  # are all items valid? otherwise back to while loop
  }
  # eventually it will find an order that works and output it
  print("Success! Judge for yourself...")
  df
}
