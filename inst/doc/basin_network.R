## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  fig.width = 7.1,
  fig.height = 6
)

## ----setup, message=FALSE-----------------------------------------------------
# Load Packages
library(HYPEtools)
library(sf)

# Get Path to HYPEtools Model Example Files
model_path <- system.file("demo_model", package = "HYPEtools")

# Import HYPE Model Files
gd <- ReadGeoData(file.path(model_path, "GeoData.txt"))
gcl <- ReadGeoClass(file.path(model_path, "GeoClass.txt"))

## ----contributing-------------------------------------------------------------
# Select subid for which you want to find the upstream subids
Qobs.sbd <- 3587

# Get a list of all subids contributing to the outlet of the catchment
ups.sbd <- AllUpstreamSubids(subid = Qobs.sbd, gd = gd)
ups.sbd

## ----routing, message=FALSE---------------------------------------------------
# import subbasin polygons
map.subid <- st_read(file.path(model_path, "gis", "Nytorp_map.gpkg"))

# Generate map
# PlotSubbasinRouting(map = map.subid, map.subid.column = 25, gd = gd)

