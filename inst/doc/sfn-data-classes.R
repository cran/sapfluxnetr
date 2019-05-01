## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----show----------------------------------------------------------------
library(sapfluxnetr)
data('ARG_TRE', package = 'sapfluxnetr')
ARG_TRE

## ----get_methods---------------------------------------------------------
get_sapf_data(ARG_TRE, solar = FALSE)
get_sapf_data(ARG_TRE, solar = TRUE)
get_env_data(ARG_TRE) # solar default is FALSE
get_sapf_flags(ARG_TRE) # solar default is FALSE
get_env_flags(ARG_TRE) # solar default is FALSE
get_si_code(ARG_TRE)
get_timestamp(ARG_TRE)[1:10]
get_solar_timestamp(ARG_TRE)[1:10]
get_site_md(ARG_TRE)
get_stand_md(ARG_TRE)
get_species_md(ARG_TRE)
get_plant_md(ARG_TRE)
get_env_md(ARG_TRE)

## ----assignation---------------------------------------------------------
# extraction and modification
foo_site_md <- get_site_md(ARG_TRE)
foo_site_md[['si_biome']]
foo_site_md[['si_biome']] <- 'Temperate forest'
# assignation
get_site_md(ARG_TRE) <- foo_site_md
# check it worked
get_site_md(ARG_TRE)[['si_biome']]

## ----sfn_plot, fig.width=6-----------------------------------------------
library(ggplot2)

sfn_plot(ARG_TRE, type = 'env') +
  facet_wrap(~ Variable, ncol = 3, scales = 'free_y') +
  theme(legend.position = 'none')

sfn_plot(ARG_TRE, formula_env = ~ vpd) +
  theme(legend.position = 'none')

## ----sfn_filter----------------------------------------------------------
library(lubridate)
library(dplyr)

# get only the values for november
sfn_filter(ARG_TRE, month(TIMESTAMP) == 11)

## ----sfn_mutate----------------------------------------------------------
# transform ws from m/s to km/h
foo_mutated <- sfn_mutate(ARG_TRE, ws = ws * 3600/1000)
get_env_data(foo_mutated)[['ws']][1:10]

## ----sfn_mutate_at-------------------------------------------------------
foo_mutated_2 <- sfn_mutate_at(
  ARG_TRE,
  vars(one_of(names(get_sapf_data(ARG_TRE)[,-1]))),
  list(~ case_when(
    ws > 25 ~ NA_real_,
    TRUE ~ .
  ))
)

# see the difference between ARG_TRE and foo_mutated_2
get_sapf_data(ARG_TRE)
get_sapf_data(foo_mutated_2)

## ----metrics-------------------------------------------------------------
foo_daily <- daily_metrics(ARG_TRE)
foo_daily[['sapf']][['sapf_gen']]

## ----show_multi----------------------------------------------------------
# creating a sfn_data_multi object
data(ARG_MAZ, package = 'sapfluxnetr')
data(AUS_CAN_ST2_MIX, package = 'sapfluxnetr')
multi_sfn <- sfn_data_multi(ARG_TRE, ARG_MAZ, AUS_CAN_ST2_MIX)

# show method
multi_sfn

## ----get_multi-----------------------------------------------------------
# get sapflow data
get_sapf_data(multi_sfn)
# get plant metadata
get_plant_md(multi_sfn)
# with metadata, we can collapse
get_plant_md(multi_sfn, collapse = TRUE)

## ----plot_multi, fig.show='hold', fig.width=3.4--------------------------
multi_plot <- sfn_plot(multi_sfn, formula = ~ vpd)
multi_plot[['ARG_TRE']] + theme(legend.position = 'none')
multi_plot[['AUS_CAN_ST2_MIX']] + theme(legend.position = 'none')

## ----sfn_filter_multi----------------------------------------------------
multi_filtered <- sfn_filter(multi_sfn, month(TIMESTAMP) == 11)
get_timestamp(multi_filtered[['AUS_CAN_ST2_MIX']])[1:10]

## ----sfn_mutate_multi----------------------------------------------------
multi_mutated <- sfn_mutate(multi_sfn, ws = ws * 3600/1000)
get_env_data(multi_mutated[['AUS_CAN_ST2_MIX']])[['ws']][1:10]

## ----sfn_mutate_at_multi-------------------------------------------------
vars_to_not_mutate <- c(
  "TIMESTAMP", "ta", "rh", "vpd", "sw_in", "ws",
  "precip", "swc_shallow", "ppfd_in", "ext_rad"
)

multi_mutated_2 <- sfn_mutate_at(
  multi_sfn,
  vars(-one_of(vars_to_not_mutate)),
  list(~ case_when(
    ws > 25 ~ NA_real_,
    TRUE ~ .
  ))
)

multi_mutated_2[['ARG_TRE']]

## ----metrics_multi-------------------------------------------------------
multi_metrics <- daily_metrics(multi_sfn)
multi_metrics[['ARG_TRE']][['sapf']]

