% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functioncollection_Harmonized.R
\name{WriteHarmonizedSpatialDescription}
\alias{WriteHarmonizedSpatialDescription}
\title{Write a Harmonized Spatial Description File}
\usage{
WriteHarmonizedSpatialDescription(
  df,
  filename = "",
  replace.accents = FALSE,
  strip.punctuation = FALSE,
  ignore.cols = NULL,
  nThread = NULL
)
}
\arguments{
\item{df}{Data frame containing the harmonized spatial description data.}

\item{filename}{Path to and file name (including ".csv" file extension) of the Harmonized Spatial Description CSV file to export. Windows users: Note that
Paths are separated by '/', not '\\'.}

\item{replace.accents}{Logical, if \code{TRUE}, then accented characters (e.g. ä, ö, å) will be replaced with non-accented characters in all strings.
If \code{FALSE}, then strings will be left unmodified.}

\item{strip.punctuation}{Logical, if \code{TRUE}, then punctuation characters (e.g. "-", ".", ".") will be removed from all strings.
If \code{FALSE}, then strings will be left unmodified.}

\item{ignore.cols}{Vector of columns in \code{df} that should be ignored when \code{replace.accents} or \code{strip.punctuation} are set to \code{TRUE}.}

\item{nThread}{Integer, set number of threads to be used when writing file. If \code{NULL} (default), then the output of \link[data.table:openmp-utils]{data.table::getDTthreads} will be used}
}
\value{
\code{WriteSpatialDescrption} exports a CSV file if \code{filename} is specified. Otherwise, the function outputs a data frame to the console.
}
\description{
This is a convenience wrapper function to export a data frame to the required Harmonized Spatial Description File format. See the
\href{https://git.smhi.se/fouh/hypeobsmetadatatools}{HYPEObsMetadataTools documentation}.
}
\details{
\code{WriteHarmonizedSpatialDescription} is a convenience wrapper function of \code{\link[data.table]{fread}} to export harmonized spatial description data in the HYPEObsMetadataTools Harmonized Spatial Description Format.
The function checks that all required columns are present, includes options to format strings, and exports data to output CSV files with the correct encoding and formatting.
}
\examples{
df <- data.frame(
  "STATION_ID" = "A1",
  "SRC_NAME" = "Example",
  "DOWNLOAD_DATE" = "2022-10-19",
  "SRC_STATNAME" = "Station",
  "SRC_WBNAME" = "River",
  "SRC_UAREA" = NA,
  "SRC_XCOORD" = 28.11831,
  "SRC_YCOORD" = -25.83053,
  "SRC_EPSG" = 4326,
  "ADJ_XCOORD" = 28.11831,
  "ADJ_YCOORD" = -25.83053,
  "ADJ_EPSG" = 4326
)

WriteHarmonizedSpatialDescription(df)

}
