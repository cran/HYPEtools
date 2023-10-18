## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  fig.width = 7.1,
  fig.height = 6
)

## ----setup, message=FALSE-----------------------------------------------------
# Load Package
library(HYPEtools)

# Get Path to HYPEtools Model Example Files
model_path <- system.file("demo_model", package = "HYPEtools")

# Import HYPE Model Files
gd <- ReadGeoData(file.path(model_path, "GeoData.txt"))
gcl <- ReadGeoClass(file.path(model_path, "GeoClass.txt"))
prf <- ReadPar(file.path(model_path, "par.txt"), encoding = "latin1")

## ----checks-------------------------------------------------------------------
# Exaimine parameter structure
str(prf)

# Display without the comment items
prf[sapply(prf, function(x) is.numeric(x) & length(x) > 0)]

# Show values for a parameter "rrcs1" - Note it has 2 values, i.e. it is soil-dependent
prf$rrcs1

## ----updatepar----------------------------------------------------------------
# Fraction by which the original value will by multiplied
mult <- 1.5

# Display the current values (3, i.e. landuse-dependent)
prf$cmlt

# Create a new paramater list
prf.150 <- prf

# Multiply by a specified fraction and display again
prf.150$cmlt <- prf$cmlt * mult
prf.150$cmlt

## ----updateparlu--------------------------------------------------------------

# Forest is Land Use Class 2
comment(gcl)

# Specify multiplication factors
mult <- c(1, 1.5, 1)

# Create a new parameter list
prf.150.for <- prf

# Multiply values for the selected landuse by a specified fraction and display again
prf.150.for$cmlt <- prf$cmlt * mult
prf.150.for$cmlt

# See a ratio of the new vs. the original parameters
prf.150.for$cmlt / prf$cmlt

