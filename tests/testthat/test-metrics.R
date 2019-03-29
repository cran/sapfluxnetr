context("metrics")

# data
data('ARG_TRE', package = 'sapfluxnetr')
data('ARG_MAZ', package = 'sapfluxnetr')
data('AUS_CAN_ST2_MIX', package = 'sapfluxnetr')
data('sfn_metadata_ex', package = 'sapfluxnetr')
multi_sfn <- sfn_data_multi(ARG_TRE, ARG_MAZ, AUS_CAN_ST2_MIX)

#### summarise_by_period tests ####
test_that('summarise_by_period function example works', {

  library(dplyr)

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = '7 days',
      .funs = dplyr::funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n())
    ),
    'tbl_time'
  )

  expect_s3_class(
    summarise_by_period(
      data = get_env_data(ARG_TRE),
      period = '7 days',
      .funs = dplyr::funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n())
    ),
    'tbl_time'
  )

  test_expr <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = '7 days',
    .funs = dplyr::funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n())
  )

  expect_match(
    names(test_expr),
    regexp = '_mean', all = FALSE
  )

  expect_match(
    names(test_expr),
    regexp = '_sd', all = FALSE
  )

  expect_match(
    names(test_expr),
    regexp = '_n', all = FALSE
  )

})

test_that('summarise_by_period dots work as intended', {

  # there are no tests based on values as the tests are intended to be data
  # agnostic

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = 'daily',
      .funs = dplyr::funs(mean, sd),
      na.rm = TRUE, # for summarise
      side = "start" # for collapse_index
    ),
    'tbl_time'
  )

  test_expr <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(mean, sd),
    na.rm = TRUE, # for summarise
    side = "start" # for collapse_index
  )

  expect_match(names(test_expr), regexp = '_mean', all = FALSE)
  expect_match(names(test_expr), regexp = '_sd', all = FALSE)

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = 'daily',
      .funs = dplyr::funs(mean, sd),
      na.rm = TRUE, # for summarise
      side = "start", # for collapse_index
      clean = TRUE # for collapse_index
    ),
    'tbl_time'
  )

  test_expr2 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(mean, sd),
    na.rm = TRUE, # for summarise
    side = "start", # for collapse_index
    clean = TRUE # for collapse_index
  )

  expect_match(names(test_expr2), regexp = '_mean', all = FALSE)
  expect_match(names(test_expr2), regexp = '_sd', all = FALSE)

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = 'daily',
      .funs = dplyr::funs(mean, sd),
      side = "start" # for collapse_index
    ),
    'tbl_time'
  )

  test_expr3 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(mean, sd),
    side = "start" # for collapse_index
  )

  expect_match(names(test_expr3), regexp = '_mean', all = FALSE)
  expect_match(names(test_expr3), regexp = '_sd', all = FALSE)

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = 'daily',
      .funs = dplyr::funs(mean, sd),
      side = "start", # for collapse_index
      clean = TRUE # for collapse_index
    ),
    'tbl_time'
  )

  test_expr4 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(mean, sd),
    side = "start", # for collapse_index
    clean = TRUE # for collapse_index
  )

  expect_match(names(test_expr4), regexp = '_mean', all = FALSE)
  expect_match(names(test_expr4), regexp = '_sd', all = FALSE)

  expect_s3_class(
    summarise_by_period(
      data = get_sapf_data(ARG_TRE),
      period = 'daily',
      .funs = dplyr::funs(mean, sd),
      na.rm = TRUE # for summarise
    ),
    'tbl_time'
  )

  test_expr5 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(mean, sd),
    na.rm = TRUE # for summarise
  )

  expect_match(names(test_expr5), regexp = '_mean', all = FALSE)

  expect_match(names(test_expr5), regexp = '_sd', all = FALSE)

  test_expr6 <- summarise_by_period(
    data = get_env_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(
      mean(., na.rm = TRUE), sd(., na.rm = TRUE), centroid = diurnal_centroid(.)
    )
  )

  expect_failure(
    expect_match(names(test_expr6), regexp = '_centroid', all = FALSE)
  )

  test_expr7 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(
      mean(., na.rm = TRUE), sd(., na.rm = TRUE), centroid = diurnal_centroid(.)
    )
  )

  expect_match(names(test_expr7), regexp = '_centroid', all = FALSE)
  
  test_expr8 <- summarise_by_period(
    data = get_sapf_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(
      mean(., na.rm = TRUE), sd(., na.rm = TRUE),
      accumulated = .accumulated_posix_aware(., na.rm = TRUE)
    )
  )
  
  expect_false('sapflow_accumulated' %in% names(test_expr8))
  
  test_expr9 <- summarise_by_period(
    data = get_env_data(ARG_TRE),
    period = 'daily',
    .funs = dplyr::funs(
      mean(., na.rm = TRUE), sd(., na.rm = TRUE),
      accumulated = .accumulated_posix_aware(., na.rm = TRUE)
    )
  )
  
  expect_match(names(test_expr9), regexp = 'precip_accumulated', all = FALSE)
  expect_false('ta_accumulated' %in% names(test_expr9))

})

#### data_coverage tests ####
test_that('data_coverage works as intended', {

  data_0 <- rep(NA, 24)
  data_25 <- rep(c(1, NA, NA, NA), 6)
  data_50 <- rep(c(1, 2, NA, NA), 6)
  data_75 <- rep(c(1, 2, 3, NA), 6)
  data_100 <- rep(1:4, 6)

  # works for doubles
  expect_equal(data_coverage(data_0, 60, 1440), 0)
  expect_equal(data_coverage(data_25, 60, 1440), 25)
  expect_equal(data_coverage(data_50, 60, 1440), 50)
  expect_equal(data_coverage(data_75, 60, 1440), 75)
  expect_equal(data_coverage(data_100, 60, 1440), 100)

  # works for characters
  expect_equal(data_coverage(as.character(data_0), 60, 1440), 0)
  expect_equal(data_coverage(as.character(data_25), 60, 1440), 25)
  expect_equal(data_coverage(as.character(data_50), 60, 1440), 50)
  expect_equal(data_coverage(as.character(data_75), 60, 1440), 75)
  expect_equal(data_coverage(as.character(data_100), 60, 1440), 100)

})

#### .period_to_minutes tests ####
test_that('helper .period_to_minutes works with tibbletime periods', {
  expect_equal(sapfluxnetr:::.period_to_minutes('daily'), 1440)
  expect_equal(sapfluxnetr:::.period_to_minutes('1 day'), 1440)
  expect_equal(sapfluxnetr:::.period_to_minutes('monthly'), 43830)
  expect_equal(sapfluxnetr:::.period_to_minutes('1 year'), 525960)
})

test_that('.period_to_minutes works with custom POSIXct periods', {
  
  timestamp_vec <- get_timestamp(ARG_MAZ)
  period_vec <- c(timestamp_vec[49], timestamp_vec[73], timestamp_vec[193])
  timestep_val <- 60
  
  expect_equal(
    length(
      sapfluxnetr:::.period_to_minutes(period_vec, timestamp_vec, timestep_val)
    ),
    length(timestamp_vec)
  )
  expect_equal(
    length(
      unique(
        sapfluxnetr:::.period_to_minutes(period_vec, timestamp_vec, timestep_val)
      )
    ),
    4
  )
  
})

#### diurnal_centroid tests ####
test_that('diurnal_centroid function works with even data', {

  variable <- rep(1, 48)
  variable_2 <- rep(1000, 48)

  expect_true(is.numeric(diurnal_centroid(variable)))
  expect_equal(diurnal_centroid(variable), 12.25)
  expect_equal(diurnal_centroid(variable_2), 12.25)
  expect_identical(diurnal_centroid(variable), diurnal_centroid(variable_2))

  variable_3 <- rep(1, 24)
  variable_4 <- rep(1000, 24)

  expect_equal(diurnal_centroid(variable_3), 12.5)
  expect_equal(diurnal_centroid(variable_4), 12.5)
  expect_identical(diurnal_centroid(variable_3), diurnal_centroid(variable_4))

})

#### min_time/max_time tests ####
test_that('min_time and max_time functions work as intended', {

  x <- c(1:50, 49:1)
  time <- seq.POSIXt(as.POSIXct(Sys.Date()), by = 'day', length.out = 99)

  expect_s3_class(max_time(x, time), 'POSIXct')
  expect_equal(max_time(x, time), time[50])
  expect_s3_class(min_time(x, time), 'POSIXct')
  expect_equal(min_time(x, time), time[1])

})

test_that('max and min_time functions return NA when all values are NA', {

  x <- rep(NA, 99)
  time <- seq.POSIXt(as.POSIXct(Sys.Date()), by = 'day', length.out = 99)

  expect_true(is.na(min_time(x, time)))
  expect_true(is.na(max_time(x, time)))

})

#### sfn_metrics tests ####
test_that('sfn_metrics for general metrics works', {

  library(dplyr)

  test_expr <- sfn_metrics(
    ARG_TRE,
    period = '7 days',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = FALSE,
    interval = 'general'
  )

  test_expr2 <- sfn_metrics(
    multi_sfn,
    period = '7 days',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = FALSE,
    interval = 'general'
  )

  # test sfn_data
  expect_true(is.list(test_expr))
  expect_identical(names(test_expr), c('sapf', 'env'))
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr[['env']], 'tbl')

  # test sfn_data_multi
  expect_true(is.list(test_expr2))
  expect_identical(names(test_expr2), c('ARG_TRE', 'ARG_MAZ', 'AUS_CAN_ST2_MIX'))
  expect_s3_class(test_expr2[['ARG_MAZ']][['sapf']], 'tbl')
  expect_s3_class(test_expr2[['ARG_MAZ']][['env']], 'tbl')

  # sfn_data and sfn_data_multi returns the same results for the same sites
  expect_equal(test_expr[['sapf']], test_expr2[['ARG_TRE']][['sapf']])
  expect_equal(test_expr[['env']], test_expr2[['ARG_TRE']][['env']])

})

test_that('sfn_metrics for predawn metrics works', {

  library(dplyr)

  test_expr <- sfn_metrics(
    ARG_TRE,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'predawn', int_start = 4, int_end = 6
  )

  test_expr2 <- sfn_metrics(
    multi_sfn,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'predawn', int_start = 4, int_end = 6
  )

  # test sfn_data
  expect_true(is.list(test_expr))
  expect_identical(names(test_expr), c('sapf', 'env'))
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_true(all(stringr::str_detect(names(test_expr[['sapf']]), '_pd')))
  expect_true(all(stringr::str_detect(names(test_expr[['env']]), '_pd')))

  # test sfn_data_multi
  expect_true(is.list(test_expr2))
  expect_identical(names(test_expr2), c('ARG_TRE', 'ARG_MAZ', 'AUS_CAN_ST2_MIX'))
  expect_s3_class(test_expr2[['ARG_MAZ']][['sapf']], 'tbl')
  expect_s3_class(test_expr2[['ARG_MAZ']][['env']], 'tbl')
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['sapf']]), '_pd'))
  )
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['env']]), '_pd'))
  )

  # sfn_data and sfn_data_multi returns the same results for the same sites
  expect_equal(test_expr[['sapf']], test_expr2[['ARG_TRE']][['sapf']])
  expect_equal(test_expr[['env']], test_expr2[['ARG_TRE']][['env']])

})

test_that('sfn_metrics for midday metrics works', {

  library(dplyr)

  test_expr <- sfn_metrics(
    ARG_TRE,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'midday', int_start = 11, int_end = 13
  )

  test_expr2 <- sfn_metrics(
    multi_sfn,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'midday', int_start = 11, int_end = 13
  )

  # test sfn_data
  expect_true(is.list(test_expr))
  expect_identical(names(test_expr), c('sapf', 'env'))
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_true(all(stringr::str_detect(names(test_expr[['sapf']]), '_md')))
  expect_true(all(stringr::str_detect(names(test_expr[['env']]), '_md')))

  # test sfn_data_multi
  expect_true(is.list(test_expr2))
  expect_identical(names(test_expr2), c('ARG_TRE', 'ARG_MAZ', 'AUS_CAN_ST2_MIX'))
  expect_s3_class(test_expr2[['ARG_MAZ']][['sapf']], 'tbl')
  expect_s3_class(test_expr2[['ARG_MAZ']][['env']], 'tbl')
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['sapf']]), '_md'))
  )
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['env']]), '_md'))
  )

  # sfn_data and sfn_data_multi returns the same results for the same sites
  expect_equal(test_expr[['sapf']], test_expr2[['ARG_TRE']][['sapf']])
  expect_equal(test_expr[['env']], test_expr2[['ARG_TRE']][['env']])

})

test_that('sfn_metrics for nightly metrics works', {

  library(dplyr)

  test_expr <- sfn_metrics(
    ARG_TRE,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'night', int_start = 20, int_end = 6
  )

  test_expr2 <- sfn_metrics(
    multi_sfn,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'night', int_start = 20, int_end = 6
  )

  test_expr3 <- sfn_metrics(
    ARG_TRE,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'night', int_start = 20, int_end = 6,
    clean = FALSE
  )

  # test sfn_data
  expect_true(is.list(test_expr))
  expect_identical(names(test_expr), c('sapf', 'env'))
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_true(all(stringr::str_detect(names(test_expr[['sapf']]), '_night')))
  expect_true(all(stringr::str_detect(names(test_expr[['env']]), '_night')))

  # test sfn_data_multi
  expect_true(is.list(test_expr2))
  expect_identical(names(test_expr2), c('ARG_TRE', 'ARG_MAZ', 'AUS_CAN_ST2_MIX'))
  expect_s3_class(test_expr2[['ARG_MAZ']][['sapf']], 'tbl')
  expect_s3_class(test_expr2[['ARG_MAZ']][['env']], 'tbl')
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['sapf']]), '_night'))
  )
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['env']]), '_night'))
  )

  # sfn_data and sfn_data_multi returns the same results for the same sites
  expect_equal(test_expr[['sapf']], test_expr2[['ARG_TRE']][['sapf']])
  expect_equal(test_expr[['env']], test_expr2[['ARG_TRE']][['env']])

  # night works as expected
  sapf_night_timestamp <- test_expr[['sapf']][['TIMESTAMP_night']]
  env_night_timestamp <- test_expr[['env']][['TIMESTAMP_night']]

  good_sapf_night_first <- "2009-11-17 22:00:00"
  good_sapf_night_second <- "2009-11-18 20:00:00"
  good_sapf_night_last <- "2009-11-30 20:00:00"

  good_env_night_first <- "2009-11-17 22:00:00"
  good_env_night_second <- "2009-11-18 20:00:00"
  good_env_night_last <- "2009-11-30 20:00:00"

  expect_equal(as.character(sapf_night_timestamp[1]), good_sapf_night_first)
  expect_equal(as.character(sapf_night_timestamp[2]), good_sapf_night_second)
  expect_equal(as.character(sapf_night_timestamp[14]), good_sapf_night_last)
  expect_equal(as.character(env_night_timestamp[1]), good_env_night_first)
  expect_equal(as.character(env_night_timestamp[2]), good_env_night_second)
  expect_equal(as.character(env_night_timestamp[14]), good_env_night_last)

  # lets be sure that without clean the hours are cutted where they must be
  # cutted
  expect_identical(names(test_expr3), c('sapf', 'env'))
  expect_s3_class(test_expr3[['sapf']], 'tbl')
  expect_s3_class(test_expr3[['env']], 'tbl')

  sapf_night_timestamp_3 <- test_expr3[['sapf']][['TIMESTAMP_night']]
  env_night_timestamp_3 <- test_expr3[['env']][['TIMESTAMP_night']]

  good_sapf_night_first_3 <- "2009-11-17 22:24:58"
  good_sapf_night_second_3 <- "2009-11-18 20:24:43"
  good_sapf_night_last_3 <- "2009-11-30 20:20:48"

  good_env_night_first_3 <- "2009-11-17 22:24:58"
  good_env_night_second_3 <- "2009-11-18 20:24:43"
  good_env_night_last_3 <- "2009-11-30 20:20:48"

  expect_equal(as.character(sapf_night_timestamp_3[1]), good_sapf_night_first_3)
  expect_equal(as.character(sapf_night_timestamp_3[2]), good_sapf_night_second_3)
  expect_equal(as.character(sapf_night_timestamp_3[14]), good_sapf_night_last_3)
  expect_equal(as.character(env_night_timestamp_3[1]), good_env_night_first_3)
  expect_equal(as.character(env_night_timestamp_3[2]), good_env_night_second_3)
  expect_equal(as.character(env_night_timestamp_3[14]), good_env_night_last_3)

})

test_that('sfn_metrics for daylight metrics works', {

  library(dplyr)

  test_expr <- sfn_metrics(
    ARG_TRE,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'daylight', int_start = 6, int_end = 20
  )

  test_expr2 <- sfn_metrics(
    multi_sfn,
    period = 'daily',
    .funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), n()),
    solar = TRUE,
    interval = 'daylight', int_start = 6, int_end = 20
  )

  # test sfn_data
  expect_true(is.list(test_expr))
  expect_identical(names(test_expr), c('sapf', 'env'))
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_true(all(stringr::str_detect(names(test_expr[['sapf']]), '_daylight')))
  expect_true(all(stringr::str_detect(names(test_expr[['env']]), '_daylight')))

  # test sfn_data_multi
  expect_true(is.list(test_expr2))
  expect_identical(names(test_expr2), c('ARG_TRE', 'ARG_MAZ', 'AUS_CAN_ST2_MIX'))
  expect_s3_class(test_expr2[['ARG_MAZ']][['sapf']], 'tbl')
  expect_s3_class(test_expr2[['ARG_MAZ']][['env']], 'tbl')
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['sapf']]), '_daylight'))
  )
  expect_true(
    all(stringr::str_detect(names(test_expr2[['ARG_MAZ']][['env']]), '_daylight'))
  )

  # sfn_data and sfn_data_multi returns the same results for the same sites
  expect_equal(test_expr[['sapf']], test_expr2[['ARG_TRE']][['sapf']])
  expect_equal(test_expr[['env']], test_expr2[['ARG_TRE']][['env']])

  # daylight works as expected
  sapf_day_timestamp <- test_expr[['sapf']][['TIMESTAMP_daylight']]
  env_day_timestamp <- test_expr[['env']][['TIMESTAMP_daylight']]

  good_sapf_day_first <- "2009-11-18"
  good_sapf_day_second <- "2009-11-19"
  good_sapf_day_last <- "2009-11-30"

  good_env_day_first <- "2009-11-18"
  good_env_day_second <- "2009-11-19"
  good_env_day_last <- "2009-11-30"

  expect_equal(as.character(sapf_day_timestamp[1]), good_sapf_day_first)
  expect_equal(as.character(sapf_day_timestamp[2]), good_sapf_day_second)
  expect_equal(as.character(sapf_day_timestamp[13]), good_sapf_day_last)
  expect_equal(as.character(env_day_timestamp[1]), good_env_day_first)
  expect_equal(as.character(env_day_timestamp[2]), good_env_day_second)
  expect_equal(as.character(env_day_timestamp[13]), good_env_day_last)

})

#### daily_metrics ####
test_that('daily metrics examples work', {
  
  test_expr <- daily_metrics(ARG_TRE)
  test_expr2 <- daily_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- daily_metrics(multi_sfn)
  test_expr4 <- daily_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)

  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')

})

test_that('monthly metrics examples work', {
  
  test_expr <- monthly_metrics(ARG_TRE)
  test_expr2 <- monthly_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- monthly_metrics(multi_sfn)
  test_expr4 <- monthly_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)
  
  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
})

test_that('nightly metrics examples work', {
  
  test_expr <- nightly_metrics(ARG_TRE)
  test_expr2 <- nightly_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- nightly_metrics(multi_sfn)
  test_expr4 <- nightly_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)
  
  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
})

test_that('daylight metrics examples work', {
  
  test_expr <- daylight_metrics(ARG_TRE)
  test_expr2 <- daylight_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- daylight_metrics(multi_sfn)
  test_expr4 <- daylight_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)
  
  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
})

test_that('predawn metrics examples work', {
  
  test_expr <- predawn_metrics(ARG_TRE)
  test_expr2 <- predawn_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- predawn_metrics(multi_sfn)
  test_expr4 <- predawn_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)
  
  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
})

test_that('midday metrics examples work', {
  
  test_expr <- midday_metrics(ARG_TRE)
  test_expr2 <- midday_metrics(ARG_TRE, tidy = TRUE, metadata = sfn_metadata_ex)
  test_expr3 <- midday_metrics(multi_sfn)
  test_expr4 <- midday_metrics(multi_sfn, tidy = TRUE, metadata = sfn_metadata_ex)
  
  expect_true(is.list(test_expr))
  expect_s3_class(test_expr[['env']], 'tbl')
  expect_s3_class(test_expr[['sapf']], 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_true(is.list(test_expr3))
  expect_s3_class(test_expr3[['ARG_TRE']][['env']], 'tbl')
  expect_s3_class(test_expr3[['ARG_TRE']][['sapf']], 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
})

test_that('*_metrics functions with ... work', {

  expect_true(is.list(daily_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(monthly_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(nightly_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(daylight_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(predawn_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(midday_metrics(ARG_TRE, clean = FALSE)))
  expect_true(is.list(daily_metrics(ARG_TRE, side = 'end')))
  expect_true(is.list(monthly_metrics(ARG_TRE, side = 'end')))
  expect_true(is.list(nightly_metrics(ARG_TRE, side = 'end')))
  expect_true(is.list(daylight_metrics(ARG_TRE, side = 'end')))
  expect_true(is.list(predawn_metrics(ARG_TRE, side = 'end')))
  expect_true(is.list(midday_metrics(ARG_TRE, side = 'end')))
  
  expect_s3_class(
    daily_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    monthly_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    nightly_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    daylight_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    predawn_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    midday_metrics(ARG_TRE, clean = FALSE, tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    daily_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    monthly_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    nightly_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    daylight_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    predawn_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )
  expect_s3_class(
    midday_metrics(ARG_TRE, side = 'end', tidy = TRUE, metadata = sfn_metadata_ex),
    'tbl'
  )

})

#### .fixed_metrics_funs ####
test_that('.fixed_metrics_funs works', {

  .funs <- sapfluxnetr:::.fixed_metrics_funs(probs = c(0.95), TRUE)

  expect_s3_class(.funs, 'fun_list')
  expect_identical(
    names(.funs),
    c('mean', 'sd', 'coverage', 'q_95', 'accumulated', 'centroid')
  )

  .funs_no_centroid <- sapfluxnetr:::.fixed_metrics_funs(
    probs = c(0.1), FALSE
  )

  expect_s3_class(.funs_no_centroid, 'fun_list')
  expect_identical(
    names(.funs_no_centroid),
    c('mean', 'sd', 'coverage', 'q_10', 'accumulated')
  )

})

#### metrics_tidyfier #####
test_that('metrics_tidyfier returns the expected object for single metrics', {
  
  test_expr <- metrics_tidyfier(
    daily_metrics(ARG_TRE), sfn_metadata_ex, 'general'
  )
  test_expr2 <- metrics_tidyfier(
    daily_metrics(multi_sfn), sfn_metadata_ex, 'general'
  )
  test_expr3 <- metrics_tidyfier(
    predawn_metrics(ARG_TRE), sfn_metadata_ex, 'predawn'
  )
  test_expr4 <- metrics_tidyfier(
    predawn_metrics(multi_sfn), sfn_metadata_ex, 'predawn'
  )
  
  # class
  expect_s3_class(test_expr, 'tbl')
  expect_s3_class(test_expr2, 'tbl')
  expect_s3_class(test_expr3, 'tbl')
  expect_s3_class(test_expr4, 'tbl')
  
  # is the metadata there?
  expect_true(all(sfn_vars_to_filter()[['site_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['stand_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['species_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['plant_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['env_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['site_md']] %in% names(test_expr2)))
  expect_true(all(sfn_vars_to_filter()[['stand_md']] %in% names(test_expr2)))
  expect_true(all(sfn_vars_to_filter()[['species_md']] %in% names(test_expr2)))
  expect_true(all(sfn_vars_to_filter()[['plant_md']] %in% names(test_expr2)))
  expect_true(all(sfn_vars_to_filter()[['env_md']] %in% names(test_expr2)))
  expect_true(all(sfn_vars_to_filter()[['site_md']] %in% names(test_expr3)))
  expect_true(all(sfn_vars_to_filter()[['stand_md']] %in% names(test_expr3)))
  expect_true(all(sfn_vars_to_filter()[['species_md']] %in% names(test_expr3)))
  expect_true(all(sfn_vars_to_filter()[['plant_md']] %in% names(test_expr3)))
  expect_true(all(sfn_vars_to_filter()[['env_md']] %in% names(test_expr3)))
  expect_true(all(sfn_vars_to_filter()[['site_md']] %in% names(test_expr4)))
  expect_true(all(sfn_vars_to_filter()[['stand_md']] %in% names(test_expr4)))
  expect_true(all(sfn_vars_to_filter()[['species_md']] %in% names(test_expr4)))
  expect_true(all(sfn_vars_to_filter()[['plant_md']] %in% names(test_expr4)))
  expect_true(all(sfn_vars_to_filter()[['env_md']] %in% names(test_expr4)))
  
  # is the data there
  sapflow_vars <- paste0(
    'sapflow_', names(sapfluxnetr:::.fixed_metrics_funs(c(0.95), TRUE))
  )[-5]
  
  sapflow_vars_pd <- paste0(
    'sapflow_', names(sapfluxnetr:::.fixed_metrics_funs(c(0.95), FALSE)),
    '_pd'
  )[-5]
  
  env_vars <- sapfluxnetr:::.env_vars_names() %>%
    purrr::map(
      ~ paste0(
        .x, '_', names(sapfluxnetr:::.fixed_metrics_funs(c(0.95), FALSE))
      )
    ) %>%
    purrr::flatten_chr()
  
  env_vars_pd <- sapfluxnetr:::.env_vars_names() %>%
    purrr::map(
      ~ paste0(
        .x, '_', names(sapfluxnetr:::.fixed_metrics_funs(c(0.95), FALSE)),
        '_pd'
      )
    ) %>%
    purrr::flatten_chr()
  
  expect_true(all(sapflow_vars %in% names(test_expr)))
  expect_true(any(env_vars %in% names(test_expr)))
  expect_true(all(sapflow_vars %in% names(test_expr2)))
  expect_true(any(env_vars %in% names(test_expr2)))
  expect_true(all(sapflow_vars_pd %in% names(test_expr3)))
  expect_true(any(env_vars_pd %in% names(test_expr3)))
  expect_true(all(sapflow_vars_pd %in% names(test_expr4)))
  expect_true(any(env_vars_pd %in% names(test_expr4)))
  
  # has it the rows it should?
  expect_equal(nrow(test_expr), 4*14) # trees * days
  expect_equal(nrow(test_expr3), 4*13)
  expect_equal(nrow(test_expr2), (5*13) + (4*14) + (34*372))  # trees * days
  expect_equal(nrow(test_expr4), (5*12) + (4*13) + (34*371))
  
})

test_that('metrics_tidyfier works when supplied custom metrics', {
  
  test_expr <- sfn_metrics(
    ARG_TRE, '7 days',
    dplyr::funs(mean = mean(., na.rm = TRUE)),
    solar = TRUE,
    interval = 'general'
  ) %>%
    metrics_tidyfier(sfn_metadata_ex, 'general')
  
  expect_s3_class(test_expr, 'tbl')
  
  expect_true(all(sfn_vars_to_filter()[['site_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['stand_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['species_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['plant_md']] %in% names(test_expr)))
  expect_true(all(sfn_vars_to_filter()[['env_md']] %in% names(test_expr)))
  
  sapflow_vars <- 'sapflow_mean'
  
  env_vars <- sapfluxnetr:::.env_vars_names() %>%
    purrr::map(~ paste0(.x, '_mean')) %>%
    purrr::flatten_chr()
  
  expect_true(all(sapflow_vars %in% names(test_expr)))
  expect_true(any(env_vars %in% names(test_expr)))
  
  expect_equal(nrow(test_expr), 4*3) # trees * weeks
})