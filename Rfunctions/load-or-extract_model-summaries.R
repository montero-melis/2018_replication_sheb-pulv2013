# Compile model summaries nicely formatted into a dataframe using the `broom`
# package; loads from disk or summarizes anew.

library("dplyr")
library("broom")

# To understand what the function achieves, see this concise example: 
# http://stat545.com/block023_dplyr-do.html to

load_or_extract_summaries <- function(
	extract_anew = FALSE,
	filename_load = NULL,  # NB: We'll use csv files
	filename_save = NULL,
	my_simulations  # a tibble with all the fitted models as df
	) {
  # Default is that loaded and saved files have same filename on disk
  if (is.null(filename_save)) filename_save <- filename_load
  print(filename_save)
  print(filename_load)

  # Default will be to just load the stored file (fails if no such file)
  if (! extract_anew) {
    my_fm_summaries <- read.csv(filename_load)
    return(my_fm_summaries)
  } else {  # get the summaries anew (in case there are more models)
    my_fm_summaries <- my_simulations %>% tidy(fm)
    write.csv(my_fm_summaries, file = filename_save, row.names = FALSE)
    my_fm_summaries
    }
}
