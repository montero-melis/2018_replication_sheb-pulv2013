## Functions used to analyze the data following our Registered Report
## (see Appendix E in https://osf.io/26fbh/)


# ensure target directory for saving figures exists
my_figs_path <- "myfigures/"
dir.create(my_figs_path)

# save ggplot with global specifications
my_ggsave <- function(
  fig_name,
  mywidth  = 4,
  myheight = 4,
  myplot = last_plot(),
  type = ".png",
  target_folder = my_figs_path
  ) {
  fname <- paste0(target_folder, fig_name, type)
  ggsave(filename = fname, plot = myplot, width = mywidth, height = myheight)
}



# Create a function that streamlines data processing and model fitting:
analysis_pipe <- function(
  df,            # expects the data frame in above format
  repBF = FALSE  # compute replication BF?
  ) {
  
  df_name <- deparse(substitute(df))  # to use for filename later
  if (repBF) { df_name <- paste(df_name, "repBF", sep = "_") }
  
  # coding scheme: contrast code factors and standardize numerical predictors
  df$block_type <- factor(df$block_type)
  contrasts(df$block_type) <- contr.sum(2)
  colnames(contrasts(df$block_type)) <- "arm_vs_leg"
  print(contrasts(df$block_type))
  
  df$word_type <- factor(df$word_type)
  contrasts(df$word_type) <- contr.sum(2)
  colnames(contrasts(df$word_type)) <- "arm_vs_leg"
  print(contrasts(df$word_type))
  
  df$trial_exp_z <- scale(df$trial_exp)
  df$word_pos_z <- scale(df$word_pos)
  df$preced_error_z <- scale(df$preced_error)
  
  # Formula of the full model:
  formula_full <- as.formula(paste(
    "error ~",  # DV
    "1 + block_type * word_type +",  # critical manipulations and interaction
    "trial_exp_z + word_pos_z + preced_error_z +",  # nuisance predictors
    "(1 + block_type * word_type | subject) + (1 + block_type | verb)"  # maximal random structure
  ))
  print(formula_full)
  # Formula of the null model (remove the population-level interaction)
  formula_null <- update(formula_full, ~ . - block_type : word_type)
  print(formula_null)
  
  # Priors:
  # As default, specify weakly informative priors: N(0,sigma^2 = 4) for
  # population-level (fixed) effects
  # NB: In Stan a normal distribution is specified with sigma (*not* sigma^2), see
  # https://mc-stan.org/docs/2_18/functions-reference/normal-distribution.html
  # and
  # https://stackoverflow.com/questions/52893379/stan-in-r-standard-deviation-or-variance-in-normal-distribution
  # Print to screen the priors that can be specified for full and null models:
  print(get_prior(formula_full, df))
  print(get_prior(formula_null, df))
  # Set weakly informative priors
  myprior <- set_prior("normal(0, 2)", class = "b")
  print("myprior:")
  print(myprior)

  # # for replication BF, use the posterior of the re-analysis as prior for interaction:
  # myprior_repBF <- c(
  #   myprior,
  #   set_prior(
  #     paste("normal(", mean_inter_post, ",", sd_inter_post, ")", sep = ""),
  #     class = "b",
  #     coef = "block_typearms_vs_legs:word_typearms_vs_legs"
  #     )
  #   )
  # print("myprior_repBF:")
  # print(myprior_repBF)

  # fit null model (without interaction):
  # NB: The prior for interaction is not defined in the null model:
  bfm_null <- brm(
    formula = formula_null,
    data = df,
    prior = myprior,
    family = "bernoulli",
    iter = 20000, warmup = 2000, chains = 4,  # https://discourse.mc-stan.org/t/bayes-factor-using-brms/4469/3
    save_all_pars = TRUE  # necessary for brms::bayes_factor() later
  )
  # Model *without* interaction
  bfm_full <- update(
    bfm_null,
    formula = formula_full,
    prior = if (repBF) { myprior_repBF } else { myprior },
    )

  # pack models and data into a list and give sensible names to each object
  out <- list(bfm_full, bfm_null, df)
  names(out) <- paste(df_name, c("bfm_full", "bfm_null", "dataset"), sep = "_")

  # save list to disk:
  saveRDS(out, file = paste("results_analysis_", df_name, ".rds", sep =""))
  
  out
}


