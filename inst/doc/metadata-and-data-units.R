## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----describe_md_variable------------------------------------------------
library(sapfluxnetr)
describe_md_variable('si_elev')
describe_md_variable('st_age')

## ----md_vars_table, echo=FALSE, results='asis'---------------------------
suppressMessages(library(dplyr))
library(magrittr)
site_md_table <- sapfluxnetr:::.metadata_architecture() %>%
  magrittr::extract2(., 'site_md') %>%
  purrr::map_dfr(magrittr::extract, c('description', 'type', 'units')) %>%
  dplyr::mutate(
    variable = sapfluxnetr:::.metadata_architecture() %>%
      magrittr::extract2(., 'site_md') %>%
      names()
  ) %>%
  select(variable, everything())

stand_md_table <- sapfluxnetr:::.metadata_architecture() %>%
  magrittr::extract2(., 'stand_md') %>%
  purrr::map_dfr(magrittr::extract, c('description', 'type', 'units')) %>%
  dplyr::mutate(
    variable = sapfluxnetr:::.metadata_architecture() %>%
      magrittr::extract2(., 'stand_md') %>%
      names()
  ) %>%
  select(variable, everything())

species_md_table <- sapfluxnetr:::.metadata_architecture() %>%
  magrittr::extract2(., 'species_md') %>%
  purrr::map_dfr(magrittr::extract, c('description', 'type', 'units')) %>%
  dplyr::mutate(
    variable = sapfluxnetr:::.metadata_architecture() %>%
      magrittr::extract2(., 'species_md') %>%
      names()
  ) %>%
  select(variable, everything())

plant_md_table <- sapfluxnetr:::.metadata_architecture() %>%
  magrittr::extract2(., 'plant_md') %>%
  purrr::map_dfr(magrittr::extract, c('description', 'type', 'units')) %>%
  dplyr::mutate(
    variable = sapfluxnetr:::.metadata_architecture() %>%
      magrittr::extract2(., 'plant_md') %>%
      names()
  ) %>%
  select(variable, everything())

env_md_table <- sapfluxnetr:::.metadata_architecture() %>%
  magrittr::extract2(., 'env_md') %>%
  purrr::map_dfr(magrittr::extract, c('description', 'type', 'units')) %>%
  dplyr::mutate(
    variable = sapfluxnetr:::.metadata_architecture() %>%
      magrittr::extract2(., 'env_md') %>%
      names()
  ) %>%
  select(variable, everything())

bind_rows(
  site_md_table, stand_md_table, species_md_table, plant_md_table, env_md_table
) %>%
  xtable::xtable(align = c('lcccc')) %>%
  print(type = 'html')

## ----environmetal_vars_table, echo=FALSE, results='asis'-----------------
tibble::tibble(
  Variable = c(
    'env_ta', 'env_rh', 'env_vpd', 'env_sw_in', 'env_ppfd', 'env_netrad',
    'env_ws', 'env_precip', 'env_swc_shallow', 'env_swc_deep'
  ),
  Description = c(
    'Air temperature', 'Air relative humidity',
    'Vapour pressure deficit', 'Shortwave incoming radiation',
    'Incoming photosynthetic photon flux density',
    'Net radiation', 'Wind speed', 'Precipitation',
    'Shallow soil water content',
    'Deep soil water content'
  ),
  Units = c(
    'ºC', '%', 'kPa', 'W m-2', 'micromols m-2 s-1', 'W m-2', 'm s-1', 'mm timestep-1',
    'cm3 cm-3', 'cm3 cm-3'
  )
) %>%
  xtable::xtable(align = c('lccc')) %>%
  print(type = 'html')

## ----TIMESTAMP_var-------------------------------------------------------
library(dplyr)
library(lubridate)

# timezone provided by contributor
get_env_md(ARG_TRE) %>% pull(env_time_zone)

# timezone in the TIMESTAMP
get_timestamp(ARG_TRE) %>% tz()

## ----solar_TIMESTAMP-----------------------------------------------------
get_solar_timestamp(ARG_TRE) %>% tz()

