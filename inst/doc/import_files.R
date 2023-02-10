## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE
)

## ----setup, message=FALSE-----------------------------------------------------
# Load HYPEtools Package
library(HYPEtools)

# Get Path to HYPEtools Model Example Files
model_path <- system.file("demo_model", package = "HYPEtools")

# List HYPE Model Example Files
list.files(model_path)

## ----import_setup-------------------------------------------------------------
# Import Files
gd <- ReadGeoData(file.path(model_path, "GeoData.txt"))
gc <- ReadGeoClass(file.path(model_path, "GeoClass.txt"))

# Some Import Checks
summary(gd)

str(gc)

class(gd)

## ----import_discharge---------------------------------------------------------
# Import Discharge Observations
qobs <- ReadObs(file.path(model_path, "Qobs.txt"))

str(qobs)

# Get SUBIDs with observations from attribute
obsid(qobs)

## ----import_par---------------------------------------------------------------
# Import Parameter File
par <- ReadPar(file.path(model_path, "par.txt"))

str(par)

