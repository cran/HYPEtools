## ----include = FALSE----------------------------------------------------------
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

# Import HYPE Model Files
gd <- ReadGeoData(file.path(model_path, "GeoData.txt"))
gcl <- ReadGeoClass(file.path(model_path, "GeoClass.txt"))
bas <- ReadBasinOutput(file.path(model_path, "results/0003587.txt"))

## ----checks-------------------------------------------------------------------
# List HYPE Variable Names in Basin Ouptut File
names(bas)

# List subbasin SUBIDs in Basin Output File
subid(bas)

# Summarize Basin Output File Structure
str(bas)

## ----PlotBasinOutput----------------------------------------------------------
# Plot to screen
# PlotBasinOutput(bas, gd = gd, driver = "screen")

# Select variables
# PlotBasinOutput(bas, gd = gd, driver = "screen", hype.vars = c("cout", "rout"))

# Plot time series in R with a log scale for the flow (log.q = TRUE)
# PlotBasinOutput(bas, gd = gd, driver = "screen", log.q = TRUE, start.mon = 10, name = paste0("Subid ", attr(bas, "subid")))

## ----PlotBasinSummary---------------------------------------------------------
# PlotBasinSummary(bas, gd = gd, gcl = gcl, driver = "screen")

## ----AnnualRegime-------------------------------------------------------------
AnnualRegime(bas, ts.in = attr(bas, "timestep"), ts.out = "month", start.mon = 10)

## ----PlotAnnualRegime---------------------------------------------------------
regime <- AnnualRegime(bas[, c("DATE", "COUT", "ROUT")], ts.in = timestep(bas), ts.out = "month", start.mon = 10)

PlotAnnualRegime(regime, band = "p25p75", add.legend = TRUE, col = c(4, 2))

