% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_PlotSimObsRegime.R
\name{PlotSimObsRegime}
\alias{PlotSimObsRegime}
\title{Plot annual regimes of simulated and observed variables}
\usage{
PlotSimObsRegime(
  x,
  sim,
  obs,
  ts.in = NULL,
  ts.out = "month",
  start.mon = 1,
  add.legend = TRUE,
  pos.legend = "topright",
  inset = 0,
  l.legend = NULL,
  log = FALSE,
  ylim = NULL,
  xlab = NULL,
  ylab = NULL,
  mar = c(3, 3, 1, 1) + 0.1
)
}
\arguments{
\item{x}{Data frame, with column-wise equally-spaced time series of HYPE variables. Date-times in
\code{\link{POSIXct}} format in first column. Typically an imported basin output file from HYPE using \code{\link{ReadBasinOutput}}.
See details for HYPE output variables required for plotting.}

\item{sim, obs}{Character string keywords, observed and simulated HYPE variable IDs to plot. Not case-sensitive, but must exist in \code{x}.
Set to \code{NULL} to omit corresponding elements in plot.}

\item{ts.in}{Character string, timestep of \code{x}, searches for an attribute \code{timestep} in \code{x} per default.
Otherwise one of \code{"month"}, \code{"week"}, \code{"day"}, or \code{"nhour"} (n = number of hours).}

\item{ts.out}{Character string, aggregation timestep for simulation results, defaults to \code{ts.in}. This timestep must be equal
to or longer than \code{ts.in}.}

\item{start.mon}{Integer between 1 and 12, starting month of the hydrological year, used to order the output.}

\item{add.legend}{Logical. If \code{TRUE}, a legend will be added to the plot.}

\item{pos.legend}{Character string keyword for legend positioning. See Details in \code{link{legend}}.}

\item{inset}{Integer, legend inset as fraction of plot region, one or two values for x and y. See \code{link{legend}}.}

\item{l.legend}{Character vector of length 2 containing variable labels for legend, first for \code{sim}, then for \code{obs}.
If non-NULL, variable labels are read from here instead of \code{sim} and \code{obs}.}

\item{log}{Logical, if \code{TRUE}, y-axis will be log-scaled.}

\item{ylim}{Numeric vector of length two, giving y-axis limits. Defaults to min-max range of all plotted data.}

\item{xlab}{Character string or \code{\link{plotmath}} expression string, x-axis label. Defaults to a string giving the
time period on which the regime is based.}

\item{ylab}{Character or \code{\link{plotmath}} expression string. Y-axis label. Defaults to a HYPE variable unit string taken from
\code{x} \code{\link{attributes}} \code{'hypeunit'}.}

\item{mar}{Numeric vector of length 4, margin specification passed to \code{\link{par}}.}
}
\value{
\code{PlotSimObsRegime} returns a plot to the currently active plot device, and invisibly a \code{\link{list}} object containing three
elements with the plotted data and variable IDs.
Element \code{obs} contains a list as returned by \code{\link{AnnualRegime}}. Element \code{obs} contains a list with two elements, a
vector \code{refdate} with x positions of box plots elements, and a list \code{reg.obs} with observations for the monthly box plot elements.
Element \code{variable} contains a named vector with HYPE variable IDs for observations and simulations. \code{sim} and \code{obs} returned
empty if corresponding function argument was \code{NULL}.
}
\description{
A combined plot for annual regimes with box plot elements for observed variables and ribbon elements
for simulated variables. Particularly designed for comparisons of sparse observations with
high-density model results, e.g. for in-stream nutrients.
}
\details{
\code{PlotSimObsRegime} combines ribbons and box plot elements. Box plot elements are composed as defaults from \code{\link{boxplot}},
i.e. boxes with 25\\% to 75\\% percentile ranges and horizontal bar at median value, whiskers extending to 1.5 times standard deviation, and
extreme values as points. Observation counts per month over the observation period are printed above the x-axis.

Aggregation time length of the simulated variable can be chosen in argument \code{ts.out}, resulting in more or less smoothed ribbons.
For the observed variable, the aggregation is fixed to months, in order to aggregate enough values for each box plot element.
}
\examples{
# Plot observed and simulated discharge
te <- ReadBasinOutput(filename = system.file("demo_model",
"results", "0003587.txt", package = "HYPEtools"))
PlotSimObsRegime(x = te, sim = "cout", obs = "rout", start.mon = 10)

}
\seealso{
\code{\link{PlotAnnualRegime}} for a more generic annual regime plot, \code{\link{AnnualRegime}} to compute annual regimes only.
}
