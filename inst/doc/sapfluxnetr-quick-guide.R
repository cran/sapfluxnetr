## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

folder <- 'resources'

## ----cran_install, eval=FALSE--------------------------------------------
#  install.packages('sapfluxnetr')

## ----github_inst, eval=FALSE---------------------------------------------
#  # if (!require(remotes)) {install.packages('remotes')}
#  remotes::install_github(
#    'sapfluxnet/sapfluxnetr', ref = 'devel',
#    build_opts = c("--no-resave-data", "--no-manual", "--build-vignettes")
#  )

## ----pkg_load------------------------------------------------------------
library(sapfluxnetr)
# if (!require(tidyverse)) {install.packages('tidyverse')}
library(tidyverse)

## ----read_and_inspect, eval=FALSE----------------------------------------
#  # read the data
#  arg_maz <- read_sfn_data('ARG_MAZ', folder = 'RData/plant')
#  
#  # see a brief summary of the site:
#  arg_maz

## ----read_internals, echo=FALSE------------------------------------------
# read the data
arg_maz <- read_sfn_data('ARG_MAZ', folder = folder)

# see a brief summary of the site:
arg_maz

## ----accesors_data-------------------------------------------------------
# sapf data with original site timestamp
arg_maz_sapf <- get_sapf_data(arg_maz, solar = FALSE)
arg_maz_sapf

# env_data with calculated aparent solar time
arg_maz_env <- get_env_data(arg_maz, solar = TRUE)
arg_maz_env

## ----accesors_md---------------------------------------------------------
arg_maz_site_md <- get_site_md(arg_maz)
arg_maz_site_md
arg_maz_stand_md <- get_stand_md(arg_maz)
arg_maz_stand_md
arg_maz_species_md <- get_species_md(arg_maz)
arg_maz_species_md
arg_maz_plant_md <- get_plant_md(arg_maz)
arg_maz_plant_md
arg_maz_env_md <- get_env_md(arg_maz)
arg_maz_env_md

## ----describe------------------------------------------------------------
# what is env_ta?
describe_md_variable('env_ta')

# or pl_species?
describe_md_variable('pl_species')

## ----get_flags-----------------------------------------------------------
arg_maz_sapf_flags <- get_sapf_flags(arg_maz, solar = TRUE)
arg_maz_sapf_flags

arg_maz_env_flags <- get_env_flags(arg_maz, solar = TRUE)
arg_maz_env_flags

## ----out_range-----------------------------------------------------------
arg_maz_env_flags %>%
  filter_all(any_vars(stringr::str_detect(., 'RANGE_WARN')))

## ----crossing_flags------------------------------------------------------
arg_maz_env_flags %>%
  filter_all(any_vars(stringr::str_detect(., 'RANGE_WARN'))) %>%
  semi_join(arg_maz_env, ., by = 'TIMESTAMP') %>%
  select(TIMESTAMP, ws)

## ----sapf_plot, fig.width=6----------------------------------------------
sfn_plot(arg_maz, type = 'sapf', solar = TRUE) +
  facet_wrap(~ Tree) + theme(legend.position = 'none')

## ----env_plot, fig.width=6, fig.height=4---------------------------------
sfn_plot(arg_maz, type = 'env', solar = TRUE) +
  facet_wrap(~ Variable, scales = 'free_y') + theme(legend.position = 'none')

## ----vpd_and_vs, fig.show='hold'-----------------------------------------
# vpd individually
sfn_plot(arg_maz, type = 'vpd', solar = TRUE)
# vpd vs sapf
sfn_plot(arg_maz, formula_env = ~vpd, solar = TRUE) +
  theme(legend.position = 'none')

## ----daily---------------------------------------------------------------
arg_maz_daily <- daily_metrics(arg_maz, solar = TRUE)

names(arg_maz_daily)
names(arg_maz_daily[['sapf']])
names(arg_maz_daily[['env']])

## ----daily_sapf_gen_q99--------------------------------------------------
arg_maz_daily[['sapf']] %>%
  select(TIMESTAMP, ends_with('q_95'))

## ----daily_sapf_md_mean--------------------------------------------------
arg_maz_daily[['env']] %>%
  select(TIMESTAMP, ends_with('mean'))

## ----metadata_database, eval = FALSE-------------------------------------
#  sfn_metadata <- read_sfn_metadata(folder = 'RData/plant', .write_cache = TRUE)

## ----metadata_database_real, echo=FALSE, warning=FALSE-------------------
# sfn_metadata <- read_sfn_metadata(folder = folder, .write_cache = TRUE)
sfn_metadata <- sapfluxnetr:::.write_metadata_cache(folder = folder, .dry = TRUE)

## ----md_db_str-----------------------------------------------------------
# access plant metadata
sfn_metadata[['plant_md']]

## ----sfn_sites_in_folder, eval=FALSE-------------------------------------
#  folder <- 'RData/plant/'
#  sites <- sfn_sites_in_folder(folder)
#  sites

## ----sfn_sites_in_folder_real, echo=FALSE--------------------------------
sites <- sfn_sites_in_folder(folder)
sites

## ----filtering_by_md, eval=FALSE-----------------------------------------
#  temperate <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c('Mediterranean', 'Temperate forest'),
#      metadata = sfn_metadata
#    )
#  
#  temperate

## ----filtering_by_md_real, echo=FALSE, warning=FALSE---------------------
temperate <- sfn_sites_in_folder(folder) %>%
  filter_sites_by_md(
    si_biome %in% c('Mediterranean', 'Temperate forest'),
    metadata = sfn_metadata
  )
temperate

## ----filters_combined, eval=FALSE----------------------------------------
#  temperate_hr <- sfn_sites_in_folder(folder) %>%
#    filter_sites_by_md(
#      si_biome %in% c('Mediterranean', 'Temperate forest'),
#      pl_sens_meth == 'HR',
#      metadata = sfn_metadata
#    )
#  
#  temperate_hr

## ----filters_combined_real, echo=FALSE, warning=FALSE--------------------
temperate_hr <- sfn_sites_in_folder(folder) %>%
  filter_sites_by_md(
    si_biome %in% c('Mediterranean', 'Temperate forest'),
    pl_sens_meth == 'HR',
    metadata = sfn_metadata
  )
temperate_hr

## ----vars_to_filter------------------------------------------------------
sfn_vars_to_filter()

# and see what values we must use for filtering by pl_sens_meth
describe_md_variable('pl_sens_meth')

## ----multi, eval=FALSE---------------------------------------------------
#  temperate_sites <- temperate %>%
#    read_sfn_data(folder = 'RData/plant')
#  temperate_sites

## ----multi_real, echo=FALSE----------------------------------------------
temperate_sites <- temperate %>%
  read_sfn_data(folder = folder)
temperate_sites

## ----mutil_site----------------------------------------------------------
temperate_sites[['AUS_CAN_ST2_MIX']]
# temperate_sites[[3]] # the same
# temperate_sites$AUS_CAN_ST2_MIX # the same

## ----multi_aggregation---------------------------------------------------
temperate_aggregated <- temperate_sites %>%
  daily_metrics()

names(temperate_aggregated)

## ----tidyfing------------------------------------------------------------
temperate_tidy <- temperate_sites %>%
  daily_metrics(tidy = TRUE, metadata = sfn_metadata)

temperate_tidy

## ----ex_1_plot, fig.width=7, fig.height=4.3------------------------------
ggplot(
  temperate_tidy,
  aes(x = vpd_mean, y = sapflow_q_95, colour = si_code, size = pl_sapw_area)
) +
  geom_point(alpha = 0.2)

