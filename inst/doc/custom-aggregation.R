## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
# libraries
library(sapfluxnetr)
library(dplyr)

### only mean and sd at a daily scale
# data
data('ARG_TRE', package = 'sapfluxnetr')

# summarising funs (built with funs function from dplyr package)
custom_funs <- funs(mean = mean(., na.rm = TRUE), std_dev = sd(., na.rm = TRUE))

# metrics
foo_simpler_metrics <- sfn_metrics(
  ARG_TRE,
  period = 'daily',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

foo_simpler_metrics[['sapf']]

## ------------------------------------------------------------------------
foo_simpler_metrics_midday <- sfn_metrics(
  ARG_TRE,
  period = 'daily',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'midday', int_start = 11, int_end = 13
)

foo_simpler_metrics_midday[['sapf']]

## ------------------------------------------------------------------------
# weekly
foo_weekly <- sfn_metrics(
  ARG_TRE,
  period = '7 days',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

foo_weekly[['env']]

## ------------------------------------------------------------------------
# custom
foo_custom <- sfn_metrics(
  ARG_TRE,
  period = as.POSIXct(
    c('2009-11-17 00:00:00', '2009-11-22 14:00:00', '2009-11-30 23:59:00'),
                      tz = 'UTC'
  ),
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)
foo_custom[['sapf']]

## ------------------------------------------------------------------------
foo_simpler_metrics_end <- sfn_metrics(
  ARG_TRE,
  period = 'daily',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general',
  side = "end"
)

foo_simpler_metrics_end[['sapf']]

## ----timestamp_coll------------------------------------------------------
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

custom_funs <- funs(max = max(., na.rm = TRUE), max_time(., TIMESTAMP_coll))

max_time_metrics <- sfn_metrics(
  ARG_TRE,
  period = 'daily',
  .funs = custom_funs,
  solar = TRUE,
  interval = 'general'
)

max_time_metrics[['sapf']]

