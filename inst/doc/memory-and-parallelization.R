## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----memory_all, eval=FALSE---------------------------------------------------
#  library(sapfluxnetr)
#  
#  # This will need at least 5GB of memory during the process
#  folder <- 'RData/plant'
#  sfn_metadata <- read_sfn_metadata(folder)
#  
#  daily_results <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c("Temperate forest", 'Woodland/Shrubland'),
#      sites = sites, metadata = sfn_metadata
#    ) %>%
#    read_sfn_data(folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  
#  # Important to save, this way you will have access to the object in the future
#  save(daily_results, file = 'daily_results.RData')

## ----memory_steps, eval = FALSE-----------------------------------------------
#  library(sapfluxnetr)
#  
#  folder <- 'RData/plant'
#  metadata <- read_sfn_metadata(folder)
#  sites <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c("Temperate forest", 'Woodland/Shrubland'),
#      sites = sites, metadata = sfn_metadata
#    )
#  
#  daily_results_1 <- read_sfn_data(sites[1:30], folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  daily_results_2 <- read_sfn_data(sites[31:60], folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  daily_results_3 <- read_sfn_data(sites[61:90], folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  daily_results_4 <- read_sfn_data(sites[91:110], folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  
#  daily_results_steps <- bind_rows(
#    daily_results_1, daily_results_2,
#    daily_results_3, daily_results_4
#  )
#  
#  rm(daily_results_1, daily_results_2, daily_results_3, daily_results_4)
#  save(daily_results_steps, file = 'daily_results_steps.RData')

## ----parallelizations, eval = FALSE-------------------------------------------
#  # loading future package
#  library(future)
#  
#  # setting the plan
#  plan('multiprocess')
#  
#  # metrics!!
#  daily_results_parallel <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c("Temperate forest", 'Woodland/Shrubland'),
#      sites = sites, metadata = sfn_metadata
#    ) %>%
#    read_sfn_data(folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  
#  # Important to save, this way you will have access to the object in the future
#  save(daily_results_parallel, file = 'daily_results_parallel.RData')

## ----max_limit, eval = FALSE--------------------------------------------------
#  # future library
#  library(future)
#  
#  # plan sequential, not really needed, as it is the default, but for the sake of
#  # clarity
#  plant('sequential')
#  
#  # up the limit to 1GB, this in bytes is 1014*1024^2
#  options('future.globals.maxSize' = 1014*1024^2)
#  
#  # do the metrics
#  daily_results_limit <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c("Temperate forest", 'Woodland/Shrubland'),
#      sites = sites, metadata = sfn_metadata
#    ) %>%
#    read_sfn_data(folder) %>%
#    daily_metrics(tidy = TRUE, metadata = sfn_metadata)
#  
#  # Important to save, this way you will have access to the object in the future
#  save(daily_results_limit, file = 'daily_results_limit.RData')

