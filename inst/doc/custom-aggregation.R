## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----custom_summ--------------------------------------------------------------
# libraries
library(sapfluxnetr)
library(dplyr)

### only mean and sd at a daily scale
# data
data('ARG_TRE', package = 'sapfluxnetr')

# summarising funs (as a list of formulas)
custom_funs <- list(mean = ~ mean(., na.rm = TRUE), std_dev = ~ sd(., na.rm = TRUE))

# metrics
foo_simpler_metrics <- sfn_metrics(
  ARG_TRE,
  period = '1 day',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

foo_simpler_metrics[['sapf']]

## ----special_intervals--------------------------------------------------------
foo_simpler_metrics_midday <- sfn_metrics(
  ARG_TRE,
  period = '1 day',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'midday', int_start = 11, int_end = 13
)

foo_simpler_metrics_midday[['sapf']]

## ----custom_aggregation-------------------------------------------------------
# weekly
foo_weekly <- sfn_metrics(
  ARG_TRE,
  period = '7 days',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

foo_weekly[['env']]

## ----custom_aggregation_2-----------------------------------------------------
foo_custom <- sfn_metrics(
  AUS_CAN_ST2_MIX,
  period = lubridate::quarter,
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general',
  with_year = TRUE # argument for lubridate::quarter
)
foo_custom['env']

## ----extra_params-------------------------------------------------------------
foo_simpler_metrics_end <- sfn_metrics(
  ARG_TRE,
  period = '1 day',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general',
  side = "end"
)

foo_simpler_metrics_end[['sapf']]

## ----timestamp_coll-----------------------------------------------------------
max_time <- function(x, time) {
  
  # x: vector of values for a day
  # time: TIMESTAMP for the day 

  # if all the values in x are NAs (a daily summmarise of no measures day for
  # example) this will return a length 0 POSIXct vector, which will crash
  # dplyr summarise step. So, check if all NA and if true return NA as POSIXct
  if(all(is.na(x))) {
    return(as.POSIXct(NA, tz = attr(time, 'tz'), origin = lubridate::origin))
  } else {
    time[which.max(x)]
  }
}

custom_funs <- list(max = ~ max(., na.rm = TRUE), ~ max_time(., TIMESTAMP_coll))

max_time_metrics <- sfn_metrics(
  ARG_TRE,
  period = '1 day',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

max_time_metrics[['sapf']]

## ----subdaily_periods---------------------------------------------------------
custom_funs <- list(max = ~ max(., na.rm = TRUE))

three_hours_agg <- sfn_metrics(
  ARG_TRE,
  period = '3 hours',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

three_hours_agg[['sapf']]

