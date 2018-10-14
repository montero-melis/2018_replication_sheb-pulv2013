# Function to fit models to differently parametrized simulations and save to disk
# It is sourced from the script power-analysis_pilot_natives_poisson.R in folder
# "1810_replication-natives_analysis/power-analysis/"

# The idea of this function is taken from D Kleinschmidt's LSA13 slides.
# Because the parameters I'm passing to the function are not just numbers
# but also vectors (of mean estimates) and potentially could be matrices
# (e.g., covariance matrices), I'm putting things in a list and then use a
# wrapper function that loops through this list of parameters and calls the
# relevant functions to achieve:
# Simulate data (under parameter setting) --> Fit model --> Save to disk

# Additionally, this function takes some parameters to make it easy to repeat
# this process on different occasions and appending new simulations to old 
# ones, thus saving time and making the simulation runs flexible:
# The default (fitAnew = FALSE) will first retrieve saved simulations from
# disk, then add new ones, and finally save them all to disk.

# The first version, fit_many_poisson(), used save() and load(); the 2nd
# version, fit_many_poisson2() (see below), uses readRDS() and saveRDS(),
# which is preferable

# Function to fit models to data generated from list of different parameters
fit_many_poisson <- function(
  parameterList = NULL,  # list of manipulated parameters in the simulations
  nbSims = 1,  # number of simulations for each parameter setting
  fitAnew = FALSE,   # see above
  loadOnly = FALSE,  # don't run new simulations, only load from disk
  output_folder = path_out,  # assumes this is defined in the script
  saved_obj_name = "my_poisson_simulations.RData",
  print_each_step = FALSE,  # for use with myprint() function
  save_to_disk = TRUE
  ) {
  
  # How much time does it take? Start the watch...
  ptm <- proc.time()
  
  # For use below to avoid typos
  path_to_saved_obj <- file.path(path_out, saved_obj_name)

  # myprint function to print intermediate objects
  myprint <- function(x) {
    if (print_each_step) { 
      cat("\n"); print(paste("This is ", deparse(substitute(x)))); cat("\n")
      print(x)}}

  # First check if there is a saved .RData object with simulations
  stored_simulations <- saved_obj_name %in% list.files(path_out)  # logical

  print("about to load...")
  # If loadOnly it will not run new simulations, just load existing ones 
  if (loadOnly) {
    if (! stored_simulations) stop("There is no saved object on disk!")
    load(path_to_saved_obj)
    return(my_poisson_simulations)  # works only if it's the name of saved object!
  } else if ( (! fitAnew) & stored_simulations) {
    load(path_to_saved_obj)
    df <- my_poisson_simulations
  } else {  # NB: if fitAnew = TRUE, it will delete any stored simulations!
    df <- data.frame(Sim = NULL, fm = NULL, N = NULL, effect_size = NULL)
  }
  print("Now loaded! Ready to run simulations...")
  
  # Now run the simulations
  for (effectsize_name in names(parameterList$my_effectsize)) {  # keep track of name
    curr_fixef_means <- parameterList$my_effectsize[[effectsize_name]]
    myprint(effectsize_name)
    for (curr_N in parameterList$my_N) {
      myprint(curr_N)
      # fit models to data sets generated under current parametrization 
      result <- fit_poi_glmm(
        poisson_sims(
          n_sims = nbSims,
          N = curr_N,
          fixef_means = curr_fixef_means
          )
        )
      # myprint(result)
      # Keep track of the parameters under which the data were generated
      result$N <- curr_N
      result$effect_size <- effectsize_name
      # Add info about System time to allow us to simulate on different
      # occasions and append the data
      result$DateTime <- Sys.time()
      df <- rbind(df, result)
    }
  }
  # save to disk
  print("ready to save to disk")
  my_poisson_simulations <- df
  if (save_to_disk) save(my_poisson_simulations, file = file.path(path_out, "my_poisson_simulations.RData"))
  print("OK! Saved to disk.")

  print(paste("This is how long it took with", nbSims, "simulation(s):"))
  print(proc.time() - ptm)
  
  my_poisson_simulations  # and return result to save as object in global environment
}


# Virtually same function as above, only this one uses readRDS() and saveRDS()
# rather than save() and load(). For reference about the advantages in the 
# current context, see:
# https://www.fromthebottomoftheheap.net/2012/04/01/saving-and-loading-r-objects/

# Function to fit models to data generated from list of different parameters
fit_many_poisson2 <- function(
  parameterList = NULL,  # list of manipulated parameters in the simulations
  nbSims = 1,  # number of simulations for each parameter setting
  fitAnew = FALSE,   # see above
  loadOnly = FALSE,  # don't run new simulations, only load from disk
  output_folder = path_out,  # assumes path_out defined in script; crashes otherwise
  saved_obj_name = "my_poisson_simulations_fixed-interaction.rds",
  print_each_step = TRUE,  # for use with myprint() function
  save_to_disk = TRUE
  ) {
  
  # How much time does it take? Start the watch...
  ptm <- proc.time()
  
  # For use below to avoid typos
  path_to_saved_obj <- file.path(path_out, saved_obj_name)

  # myprint function to print intermediate objects
  myprint <- function(x) {
    if (print_each_step) { 
      cat("\n"); print(paste("This is ", deparse(substitute(x)))); cat("\n")
      print(x)}}

  # First check if there is a saved object with simulations
  stored_simulations <- saved_obj_name %in% list.files(path_out)  # logical

  print("about to load...")
  # If loadOnly it will not run new simulations, just load existing ones 
  if (loadOnly) {
    if (! stored_simulations) stop("There is no saved object on disk!")
    df_sims <- readRDS(path_to_saved_obj)
    return(df_sims)  # works only if it's the name of saved object!
  } else if ( (! fitAnew) & stored_simulations) {
    df_sims <- readRDS(path_to_saved_obj)
  } else {  # NB: if fitAnew = TRUE, it will delete any stored simulations!
    df_sims <- data.frame(Sim = NULL, fm = NULL, N = NULL, effect_size = NULL)
  }
  print("Now loaded! Ready to run simulations...")
  
  # Now run the simulations
  for (effectsize_name in names(parameterList$my_effectsize)) {  # keep track of name
    curr_fixef_means <- parameterList$my_effectsize[[effectsize_name]]
    myprint(effectsize_name)
    for (curr_N in parameterList$my_N) {
      myprint(curr_N)
      # fit models to data sets generated under current parametrization 
      result <- fit_poi_glmm(
        poisson_sims(
          n_sims = nbSims,
          N = curr_N,
          fixef_means = curr_fixef_means
          )
        )
      # myprint(result)
      # Keep track of the parameters under which the data were generated
      result$N <- curr_N
      result$effect_size <- effectsize_name
      # Add info about System time to allow us to simulate on different
      # occasions and append the data
      result$DateTime <- Sys.time()
      df_sims <- rbind(df_sims, result)
    }
  }
  # save to disk
  print("ready to save to disk")
  if (save_to_disk) saveRDS(df_sims, file = path_to_saved_obj)
  print("OK! Saved to disk.")

  print(paste("This is how long it took with", nbSims, "simulation(s):"))
  print(proc.time() - ptm)
  
  df_sims  # and return result to save as object in global environment
}
