% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_PlotBasinOutput.R
\name{PlotBasinOutput}
\alias{PlotBasinOutput}
\title{Plot a suite of time series plots from a HYPE basin output file}
\usage{
PlotBasinOutput(
  x,
  filename,
  driver = c("default", "pdf", "png", "screen"),
  timestep = attr(x, "timestep"),
  hype.vars = "all",
  vol.err = TRUE,
  log.q = FALSE,
  start.mon = 1,
  from = 1,
  to = nrow(x),
  date.format = "",
  name = "",
  area = NULL,
  subid = attr(x, "subid"),
  gd = NULL,
  bd = NULL,
  ylab.t1 = "Conc."
)
}
\arguments{
\item{x}{Data frame, with column-wise equally-spaced time series of HYPE variables. Date-times in
\code{\link{POSIXct}} format in first column. Typically an imported basin output file from HYPE using \code{\link{ReadBasinOutput}}.
See details for HYPE output variables required for plotting.}

\item{filename}{String, file name for plotting to file device, see argument \code{driver}. \emph{No file extension!} Ignored with plotting
to screen device. \emph{Device dimensions are currently hard-coded, see Details.}}

\item{driver}{String, device driver name, one of \code{default}, \code{pdf}, \code{png}, or \code{screen}.
Defaults to \code{default}, which plots using default plotting device \code{getOption("device")}.}

\item{timestep}{Character string, timestep of \code{x}, one of \code{"month"}, \code{"week"}, \code{"day"}, or
\code{"nhour"} (n = number of hours). If not provided, an attribute \code{timestep} is required in \code{x}.}

\item{hype.vars}{Either a keyword string or a character vector of HYPE output variables. User-specified selection of HYPE variables
to plot. Default (\code{"all"}) is to plot all variables which the function knows and which are available in \code{x}. See details
for a list of known variables. Other possible keywords are \code{"hydro"} and \code{"wq"} (water quality), for which a pre-selected range of
(available) result variables is plotted. Alternatively, a character vector holding HYPE output variables to be plotted. Variables unknown
to the function will be ignored with a warning.}

\item{vol.err}{Logical, if \code{TRUE} and both observed and simulated discharge are available in \code{x}, the accumulated volume error
will be plotted.}

\item{log.q}{Logical, y-axis scaling for flow duration curve and discharge time series, set to \code{TRUE} for log-scaling.}

\item{start.mon}{Integer between 1 and 12, starting month of the hydrological year. For runoff regime plot, see also
\code{\link{AnnualRegime}}.}

\item{from, to}{Integer or date string of format \\%F, see \code{\link{strptime}}. Time period bounds for plotting . Integers are
interpreted as row indices of \code{x}.}

\item{date.format}{String format for x-axis dates/times. See \code{\link{strptime}}.}

\item{name}{Character string, name to be printed on the plot.}

\item{area}{Numeric, upstream area of sub-basin in m^2. Required for calculation of accumulated volume error. Optional argument,
either this or arguments \code{subid}, \code{gd}, and \code{bd} are required.}

\item{subid}{Integer, HYPE SUBID of a target sub-catchment (must exist in \code{gd}). Mandatory in combination with \code{gd} and
optionally \code{bd} if argument \code{area} is not defined.  If not provided, an attribute \code{subid} is required in \code{x}.
Used to calculate upstream area internally with function \code{\link{SumUpstreamArea}}. For repeated calls to \code{PlotBasinOutput}
providing \code{area} in combination with a one-off separate call to \code{\link{SumUpstreamArea}} saves computation time,
especially in basins with many upstream sub-basins.}

\item{gd}{A data frame, containing 'SUBID' and 'MAINDOWN' columns, e.g. an imported 'GeoData.txt' file. Mandatory with argument
\code{subid}, details see there.}

\item{bd}{A data frame, containing 'BRANCHID' and 'SOURCEID' columns, e.g. an imported 'BranchData.txt' file. Optional with argument
\code{subid}, details see there.}

\item{ylab.t1}{String or \code{\link{plotmath}} expression, y axis label for T1 tracer time series panel (tracer concentration units
are not prescribed in HYPE).}
}
\value{
Returns a multi-panel plot in a new graphics device.
}
\description{
Plot a standard suite of time series plots from a basin output file, typically used for model performance inspection and/or
during manual calibration
}
\details{
\code{PlotBasinOutput} plots a suite of time series along with a flow duration curve, a flow regime plot, and a selection of
goodness-of-fit measures from an imported HYPE basin output file. The function selects from a range of "known" variables, and plots
those which are available in the user-supplied basin output. It is mostly meant as a support tool during calibration, manual or
automatic, providing a quick and comprehensive overview of model dynamics in a subbasin of interest.

HYPE outputs which are known to \code{PlotBasinOutput} include:

\itemize{
\item{precipitation}
\item{air temperature}
\item{discharge}
\item{lake water level}
\item{water temperature}
\item{evapotranspiration}
\item{snow water equivalent}
\item{sub-surface storage components}
\item{nitrogen concentrations}
\item{phosphorus concentrations}
\item{organic carbon concentrations}
\item{suspended sediment concentrations}
\item{total sediment concentrations}
\item{tracer concentration}
}

Below a complete list of HYPE variables known to the function in HYPE info.txt format, ready to copy-paste into an info.txt file.
For a detailed description of the variables, see the
\href{http://hype.smhi.net//wiki/doku.php?id=start:hype_file_reference:info.txt:variables}{HYPE online documentation}.

\code{basinoutput variable upcprf upcpsf temp upepot upevap cout rout soim sm13 upsmfp snow upcprc cct2 ret2 ccin rein ccon reon cctn retn 
ccsp resp ccpp repp cctp retp wcom wstr ccss ress ccts rets cct1 ret1 ccoc reoc}

\emph{Device dimensions} are hard-coded to a width of 15 inches and height depending on the number of plotted time series. When plotting
to a screen device, a maximum height of 10 inches is enforced in order to prevent automatic resizing with slow redrawing.
\code{PlotBasinOutput} throws a warning if the plot height exceeds 10 inches, which can lead to overlapping plot elements. On screens with
less than 10 inch screen, redrawing is inhibited, which can lead to an empty plot. The recommended solution for both effects
is to plot to pdf or png file devices instead.
}
\examples{
# Source data, HYPE basin output with a number of result variables
te1 <- ReadBasinOutput(filename = system.file("demo_model",
"results","0003587.txt", package = "HYPEtools"))
te2 <- ReadGeoData(filename = system.file("demo_model",
"GeoData.txt", package = "HYPEtools"))

\dontrun{ 
# Plot selected water variables on screen device
PlotBasinOutput(x = te1, gd = te2, driver = "screen",hype.vars = c("cout", "rout", 
"snow", "upcprf", "upcpsf"))
}

}
\seealso{
\code{\link{PlotBasinSummary}}, \code{\link{PlotAnnualRegime}}, \code{\link{PlotDurationCurve}}, \code{\link{ReadBasinOutput}}
}
