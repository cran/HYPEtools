% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functioncollection_HypeSubidChecks.R
\name{HypeSubidChecks}
\alias{HypeSubidChecks}
\alias{IsHeadwater}
\alias{IsOutlet}
\alias{IsRegulated}
\title{Check HYPE SUBID properties}
\usage{
IsHeadwater(subid, gd)

IsOutlet(subid, gd)

IsRegulated(subid, gd, dd = NULL, ld = NULL)
}
\arguments{
\item{subid}{Numeric, vector of SUBIDs to be queried}

\item{gd}{\code{\link{HypeGeoData}} or base data frame with columns \code{SUBID} and \code{MAINDOWN}, typically an imported
\href{http://hype.smhi.net//wiki/doku.php?id=start:hype_file_reference:geodata.txt}{GeoData.txt} file.}

\item{dd}{Data frame, typically an imported
\href{http://hype.smhi.net//wiki/doku.php?id=start:hype_file_reference:damdata.txt}{DamData.txt} file. Defaults
to \code{NULL}. \code{dd} or \code{ld} has to be provided in \code{IsRegulated}.}

\item{ld}{Data frame, typically an imported
\href{http://hype.smhi.net//wiki/doku.php?id=start:hype_file_reference:lakedata.txt}{LakeData.txt} file. Defaults
to \code{NULL}. \code{dd} or \code{ld} has to be provided in \code{IsRegulated}.}
}
\value{
The functions return a logical vector of the same length as \code{subid}, with \code{NA} values for all SUBIDs which do not exist
in \code{gd}.
}
\description{
Quickly query vectors of HYPE sub-basin IDs (SUBID) for various properties.
}
\details{
These are convenience functions to query subbasin properties. Some functions can be inefficient if applied to many or all
subbasins of a HYPE model setup and more efficient functions may exist in HYPEtools, see links in \emph{See also} section below or browse
the package index.
}
\examples{
te <- ReadGeoData(filename = system.file("demo_model", "GeoData.txt", package = "HYPEtools"))
IsHeadwater(subid = 40556, gd = te)
IsHeadwater(subid = te$SUBID, gd = te)

}
\seealso{
\code{\link[=AllUpstreamSubids]{AllUpstreamSubids()}}; \code{\link[=AllDownstreamSubids]{AllDownstreamSubids()}}; \code{\link[=OutletSubids]{OutletSubids()}}; \code{\link[=OutletIds]{OutletIds()}}
}
