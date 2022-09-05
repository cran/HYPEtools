## ---- include = FALSE---------------------------------------------------------
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

## ----check--------------------------------------------------------------------
# Read Comment in GeoClass.txt
comment(gcl)

## ----soilfractions------------------------------------------------------------

# Select SUBID for which you want to summarize the upstream characteristics
Qobs.sbd <- 3587

# Upstream soil fractions in percent
sof <- as.numeric(UpstreamGroupSLCClasses(subid = Qobs.sbd, gd = gd, gc = gcl, type = "soil", progbar = FALSE)[, -1] * 100)

# Show how many classes are in each soil category
length(sof)

# Calculate how many soil classes have a value greater than 0
sum(sof != 0)

# Add names for soil categories
names(sof) <- c("Fine soil", "Coarse soil")

# Display the upstream soil percentages
sof

## ----lufractions--------------------------------------------------------------

# Select SUBID for which you want to summarize the upstream characteristics
Qobs.sbd <- 3587

# Upstream land use fractions in percent
luf <- as.numeric(UpstreamGroupSLCClasses(subid = Qobs.sbd, gd = gd, gc = gcl, type = "landuse", progbar = FALSE)[, -1] * 100)

# Show how many land use classes there are
length(luf)

# Calculate how many land use classes have a value greater than 0
sum(luf != 0)

# Add names for land use categories
names(luf) <- c("Water", "Coniferous", "Agriculture")

# Display the upstream land use percentages
luf

## ----plotfractions------------------------------------------------------------
# Plot Upstream Soil Fractions
barplot(sof, ylab = "Area (%)", names.arg = "", col = "red", ylim = c(0, 100), xlab = "Soil fraction")
mtext(text = names(sof), side = 3, at = seq(.7, by = 1.2, length.out = 5), line = -.1, padj = .5, cex = .9, las = 3, adj = 1)
mtext(Qobs.sbd, side = 1, adj = 0, font = 3)
box()

# Plot Upstream Land Use Fractions
barplot(luf, ylab = "Area (%)", names.arg = "", col = "green", ylim = c(0, 100), xlab = "Land use fraction")
mtext(text = names(luf), side = 3, at = seq(.7, by = 1.2, length.out = 8), line = -.1, padj = .5, cex = .9, las = 3, adj = 1)
mtext(Qobs.sbd, side = 1, adj = 0, font = 3)
box()

## ----summarizeupstream--------------------------------------------------------
# Get a vector of all subids in the model from GeoData
sbd <- gd$SUBID

# Summarize upstream soils
sof.all <- UpstreamGroupSLCClasses(gd = gd, gcl = gcl, type = "soil", progbar = FALSE)[, -1] * 100
sof.all <- cbind("SUBID" = sbd, sof.all)
sof.all

# Summarize upstream land use
luf.all <- UpstreamGroupSLCClasses(gd = gd, gcl = gcl, type = "landuse", progbar = FALSE)[, -1] * 100
luf.all <- cbind("SUBID" = sbd, luf.all)
luf.all

## ----summarizeindividual------------------------------------------------------
# Summarize subbasin soils
sof.sbd.all <- GroupSLCClasses(gd = gd, gcl = gcl, type = "soil", verbose = FALSE)[, -1] * 100
sof.sbd.all <- cbind("SUBID" = sbd, sof.sbd.all)
sof.sbd.all

# Summarize subbasin land use
luf.sbd.all <- GroupSLCClasses(gd = gd, gcl = gcl, type = "landuse", verbose = FALSE)[, -1] * 100
luf.sbd.all <- cbind("SUBID" = sbd, luf.sbd.all)
luf.sbd.all

