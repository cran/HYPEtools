% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functioncollection_export.R
\name{WriteBasinOutput}
\alias{WriteBasinOutput}
\title{Write a basin output '[SUBID].txt' file}
\usage{
WriteBasinOutput(x, filename, dt.format = "\%Y-\%m-\%d")
}
\arguments{
\item{x}{The object to be written, a dataframe with \code{hypeunit} attribute, as an object returned from \code{\link{ReadBasinOutput}}.}

\item{filename}{A character string naming a file to write to. Windows users: Note that
Paths are separated by '/', not '\\'.}

\item{dt.format}{Date-time \code{format} string as in \code{\link{strptime}}. Incomplete format strings for monthly
and annual values allowed, e.g. '\\\%Y'.}
}
\value{
No return value, called for file export.
}
\description{
Function to export a basin output file from R.
}
\details{
\code{WriteBasinOutput} exports a dataframe with headers and formatting options adjusted to match HYPE's basin output files.
}
\examples{
te <- ReadBasinOutput(filename = system.file("demo_model", "results", "0003587.txt", 
                      package = "HYPEtools"))
WriteBasinOutput(x = te, filename = tempfile())

}
