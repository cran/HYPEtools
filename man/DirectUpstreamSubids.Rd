% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_DirectUpstreamSubids.R
\name{DirectUpstreamSubids}
\alias{DirectUpstreamSubids}
\title{Find Direct Upstream SUBIDs, with Flow Fractions}
\usage{
DirectUpstreamSubids(subid = NULL, gd, bd = NULL)
}
\arguments{
\item{subid}{Integer, SUBID of a target sub-catchment (must exist in \code{gd}), defaults to
\code{NULL}. If non-\code{NULL}, \code{DirectUpstreamSubids}
returns the direct upstream SUBIDs for this sub-catchment, otherwise for all sub-catchments in \code{gd}.}

\item{gd}{Data frame, typically an imported 'GeoData.txt' file. Mandatory argument. See 'Details'.}

\item{bd}{Data frame, typically an imported 'BranchData.txt' file. Optional argument, defaults to
an empty placeholder. See 'Details'.}
}
\value{
\code{DirectUpstreamSubids} always returns a \link{list}. If argument \code{subid} is non-\code{NULL}, a list with two elements is returned:
\code{subid} contains an integer giving the target SUBID and \code{upstr.df} contains a data frame with columns
\code{upstream} (upstream SUBID), \code{is.main} (logical, \code{TRUE} if it is a MAINDOWN connection),
\code{fraction} (fraction of flow going into the target SUBID), and \code{llim} and \code{ulim} giving upper and lower flow boundaries which
optionally limit flow into the target SUBID.

If no specific SUBID was provided, \code{DirectUpstreamSubids} returns a list with upstream information for all SUBIDs in argument
\code{gd}, each list element containing the list described above, i.e. with an integer element (SUBID) and a data frame element
(upstream connections).
}
\description{
Function to find \bold{direct} upstream SUBIDs including flow fractions for MAINDOWN/BRANCHDOWN splits for a single
sub-catchment or all sub-catchments in a GeoData-like data frame.
}
\details{
\code{DirectUpstreamSubids} identifies \bold{direct} upstream SUBIDs for a user-provided target SUBID or
for all SUBIDs given in a data frame \code{gd}, typically an imported GeoData file.

A sub-catchment in HYPE can have several upstream sub-catchments. If there are more than one upstream sub-catchments,
the downstream sub-catchment is a confluence. HYPE stores these connections in the GeoData file, in downstream direction,
given as downstream SUBID in column 'MAINDOWN'. Bifurcations, i.e. splits in downstream direction, are also possible to model in HYPE.
These additional downstream connections are provided in the BranchData file, together with flow fractions to each downstream SUBID.

Formally, \code{gd} can be any data frame which contains columns 'SUBID' and 'MAINDOWN' (not case-sensitive), and \code{bd} any
data frame which contains three columns: 'BRANCHID', 'SOURCEID', and 'MAINPART', and optionally columns 'MAXQMAIN', 'MINQMAIN', 'MAXQBRANCH'.
Typically, these are HYPE data files
imported through \code{\link{ReadGeoData}} and \code{\link{ReadBranchData}}. See HYPE documentation for further details on connections
Between SUBIDs in the model.
}
\examples{
te <- ReadGeoData(filename = system.file("demo_model", "GeoData.txt", package = "HYPEtools"))
DirectUpstreamSubids(subid = 3594, gd = te)

}
\seealso{
\code{\link{AllUpstreamSubids}}, which returns all upstream SUBIDs, i.e. the full upstream network up to the headwaters, for a given SUBID.
}
