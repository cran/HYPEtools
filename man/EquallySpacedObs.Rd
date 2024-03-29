% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_EquallySpacedObs.R
\name{EquallySpacedObs}
\alias{EquallySpacedObs}
\title{Create an equally spaced time series from irregular observations}
\usage{
EquallySpacedObs(x, sort.data = TRUE, timestep, ts.col = 1)
}
\arguments{
\item{x}{A \code{data.frame}, with a date-time column in \code{\link{POSIXt}} or
\code{\link{Date}} format, and one or several columns with observed variables.}

\item{sort.data}{Logical, if \code{TRUE}, \code{x} will be sorted by date-time.}

\item{timestep}{Character string keyword, giving the target time step length. Either \code{"day"} or \code{"hour"}.}

\item{ts.col}{Integer, column index of datetime column.}
}
\value{
\code{EquallySpacedObs} returns a dataframe.
}
\description{
\code{EquallySpacedObs} creates equally spaced time series with missing observations from a data frame with irregular
observations.
}
\details{
\code{EquallySpacedObs} will preserve additional attributes present in \code{x}. If datetime column is of class
\code{\link{Date}}, there may occur problems with daylight saving time shifts. To avoid problems, use class
\code{\link{POSIXct}} and set time zone to \code{"UTC"}.
}
\examples{
te <- data.frame(date = as.POSIXct(c("2000-01-01", "2000-02-01"), tz = "gmt"), obs = c(1, 2))
EquallySpacedObs(x = te, timestep = "day")

}
