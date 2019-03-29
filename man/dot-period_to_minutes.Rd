% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{.period_to_minutes}
\alias{.period_to_minutes}
\title{transform period as in tibbletime period argument in minutes}
\usage{
.period_to_minutes(period, timestamp, timestep)
}
\arguments{
\item{period}{character indicating the period to summarise or POSIX vector
with the boundaries for irregular periods}

\item{timestamp}{timestamp vector obtained from data}

\item{timestep}{numeric with the timestep in minutes, obtained from metadata}
}
\value{
An integer with the period value in minutes
}
\description{
helper for data_coverage
}
\details{
This function uses tibbletime and lubirdate functions to convert the period
supplied into minutes to calculate the expected timesteps in the coverage
calculation.
}
\examples{

# daily period, expected 1440 minutes
sapfluxnetr:::.period_to_minutes('daily')

# the same, but with other specification
sapfluxnetr:::.period_to_minutes('1 day')
}
\keyword{internal}