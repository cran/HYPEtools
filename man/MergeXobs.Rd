% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_MergeXobs.R
\name{MergeXobs}
\alias{MergeXobs}
\title{Merge two Xobs data frames}
\usage{
MergeXobs(x, y, comment = "")
}
\arguments{
\item{x, y}{Data frames of class \code{\link{HypeXobs}}, including additional attributes \code{comment},
\code{variable}, \code{subid}, and \code{timestep}, typically imported using \code{\link{ReadXobs}}.
For details on attribute format, see the class description. Class attribute not formally necessary.}

\item{comment}{Character string, will be added to the result as attribute \code{comment}. If empty,
comment attributes from \code{x} and \code{y} will be merged to new comment string.}
}
\value{
\code{MergeXobs} returns a data frame with attributes for Xobs data.
}
\description{
Function to merge two Xobs data frames, with handling of overlapping time periods and time periods gaps
as well as merging of common columns.
}
\details{
\code{MergeXobs} handles time steps of different lengths (e.g. daily, hourly), but requires identical time
step lengths from both inputs data frames. The functions expects data frames of class \code{\link{HypeXobs}}
or data frames with comparable structure and will throw a warning if the class attribute is missing.

In case of common columns (identical observation variable and SUBID combinations in \code{x} and \code{y}),
values from columns in \code{x} will take precedence, and values from \code{y} will only be added if
\code{x} values are missing
}
\examples{
# Import dummy data, add new observations to second Xobs table
te1 <- ReadXobs(filename = system.file("demo_model", "Xobs.txt", package = "HYPEtools"))
te2 <- ReadXobs(filename = system.file("demo_model", "Xobs.txt", package = "HYPEtools"))
te2$WSTR_40541[1:10] <- runif(n = 10, 50, 100)
MergeXobs(x = te1, y = te2)

}
