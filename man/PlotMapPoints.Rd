% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_PlotMapPoints.R
\name{PlotMapPoints}
\alias{PlotMapPoints}
\title{Plot function for mapped point information}
\usage{
PlotMapPoints(
  x,
  sites,
  sites.subid.column = 1,
  sites.groups = NULL,
  bg = NULL,
  bg.label.column = 1,
  map.type = "default",
  map.adj = 0,
  plot.legend = TRUE,
  legend.pos = "bottomright",
  legend.title = NULL,
  legend.outer = FALSE,
  legend.inset = c(0, 0),
  legend.signif = 2,
  col = NULL,
  col.breaks = NULL,
  plot.scale = TRUE,
  plot.arrow = TRUE,
  pt.cex = 1,
  par.cex = 1,
  par.mar = rep(0, 4) + 0.1,
  pch = 21,
  lwd = 0.8,
  add = FALSE,
  graphics.off = TRUE,
  radius = 5,
  weight = 0.15,
  opacity = 0.75,
  fillOpacity = 0.5,
  na.color = "#808080",
  bg.weight = 0.15,
  bg.opacity = 0.75,
  bg.fillColor = "#e5e5e5",
  bg.fillOpacity = 0.75,
  plot.label = FALSE,
  noHide = FALSE,
  textOnly = FALSE,
  font.size = 10,
  plot.bg.label = NULL,
  file = "",
  vwidth = 1424,
  vheight = 1000,
  html.name = ""
)
}
\arguments{
\item{x}{Information to plot, typically model performances from imported HYPE 'subassX.txt' files. Data frame object
with two columns, first column containing SUBIDs and second column containing model results to plot. See details.}

\item{sites}{A \code{SpatialPointsDataFrame} or \code{sf} object. Typically an imported outlet point vector point file. Import of vector points
requires additional packages, e.g. \code{\link[sf:st_read]{sf::st_read()}}.}

\item{sites.subid.column}{Integer, column index in the \code{sites} 'data' \code{\link{slot}} holding SUBIDs (sub-catchment IDs).}

\item{sites.groups}{Named list providing groups of SUBIDs to allow toggling of point groups in Leaflet maps. Default \code{NULL} will produce maps without
point groups. List names represent the names of the groups to plot, and list values represent the SUBIDs within the group.
Example: \code{sites.groups = list("GROUP 1" = c(1, 2, 3), "GROUP 2" = c(4, 5, 6))}.}

\item{bg}{A \code{SpatialPolygonsDataFrame} or \code{sf} object to plot in the background. Typically an imported sub-basin vector polygon file.
For default maps with several background layers, use \code{add = TRUE} and plot background layer(s) first.}

\item{bg.label.column}{Integer, column index in the \code{bg} 'data' \code{\link{slot}} holding labels (e.g. SUBIDs) to use for plotting.}

\item{map.type}{Map type keyword string. Choose either \code{"default"} for the default static plots or \code{"leaflet"} for interactive Leaflet maps.}

\item{map.adj}{Numeric, map adjustment in direction where it is smaller than the plot window. A value of \code{0} means left-justified
or bottom-justified, \code{0.5} (the default) means centered, and \code{1} means right-justified or top-justified. Only used for default maps.}

\item{plot.legend}{Logical, plot a legend along with the map. Uses function \code{\link{legend}} for default maps.}

\item{legend.pos}{Legend, scale, and north arrow position, keyword string. For static plots, one of: \code{"left"}, \code{"topleft"}, \code{"topright"},
\code{"right"}, \code{"bottomright"}, \code{"bottomleft"}. For interactive Leaflet maps, one of: \code{"topleft"}, \code{"topright"}, \code{"bottomright"}, \code{"bottomleft"}.}

\item{legend.title}{Character string or mathematical expression. An optional title for the legend. If none is provided here, the name of the second column in \code{x}
is used as legend title string.}

\item{legend.outer}{Logical. If \code{TRUE}, outer break point values will be plotted in legend. Only used for default maps.}

\item{legend.inset}{Numeric, inset distance(s) from the margins as a fraction of the plot region for legend, scale and north arrow.
See \code{\link{legend}} and details below. Only used for default maps.}

\item{legend.signif}{Integer, number of significant digits to display in legend labels.}

\item{col}{Colors to use on the map. One of the following: \itemize{
\item \code{NULL}, to use a default purple-red-yellow-blue color ramp, best used with \code{col.breaks = NULL}.
\item A color ramp palette function, e.g. as returned from a call to \code{\link{colorRampPalette}}
\item A vector of colors. This can be a character vector of R's built-in color names or hexadecimal strings as returned by
\code{\link{rgb}}, or an integer vector of current \code{\link{palette}} indices.
}}

\item{col.breaks}{A numeric vector, specifying break points for discretisation of model result values into classes. Class boundaries will be
interpreted as right-closed, i.e upper boundaries included in class. Lowest class boundary included in lowest class as well.
Meaningful results require the lowest and uppermost breaks to bracket all model result values, otherwise there will be
unclassified white spots on the map plot. If \code{NULL} (the default), \code{col.breaks} covers a range from 0 to 1
with 9 intervals, and an additional interval for negative values. This is suitable for e.g. NSE performances.}

\item{plot.scale}{Logical, plot a scale bar below legend (i.e. position defined by legend position). NOTE: works only with
projected maps based on meter units, not geographical projections}

\item{plot.arrow}{Logical, plot a North arrow below legend for default maps (i.e. position defined by legend position).}

\item{pt.cex}{Numeric, plot point size expansion factor, works on top of \code{par.cex}.}

\item{par.cex}{Numeric, character expansion factor. See description of \code{cex} in \code{\link{par}}. Only used for default maps.}

\item{par.mar}{Plot margins as in \code{\link{par}} argument \code{mar}. Defaults to a nearly margin-less plot.
In standard use cases of this function, plot margins do not need to be changed. Only used for default maps.}

\item{pch, lwd}{Integer, plotting symbol and line width. See \code{\link{points}}. Only used for default maps.}

\item{add}{Logical, default \code{FALSE}. If \code{TRUE}, add to existing plot. In that case \code{map.adj} has no effect. Only used for default maps.}

\item{graphics.off}{Logical, default \code{TRUE}. If \code{TRUE}, HYPEtools will turn off any existing plotting devices before generating a map. Set this to \code{FALSE} when
adding default maps to a plotting device. See \code{\link{graphics.off}}.}

\item{radius}{Numeric, radius of markers in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addCircleMarkers()}}.}

\item{weight}{Numeric, weight of marker outlines in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addCircleMarkers()}}.}

\item{opacity}{Numeric, opacity of marker outlines in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addCircleMarkers()}}.}

\item{fillOpacity}{Numeric, opacity of markers in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addCircleMarkers()}}.}

\item{na.color}{Character string of color to use to symbolize markers in Leaflet maps which correspond to \code{NA} values.}

\item{bg.weight}{Numeric, weight of \code{bg} subbasin outlines in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addPolygons()}}.}

\item{bg.opacity}{Numeric, opacity of \code{bg} subbasin outlines in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addPolygons()}}.}

\item{bg.fillColor}{Character string of color to use to symbolize \code{bg} subbasin polygons in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addPolygons()}}.}

\item{bg.fillOpacity}{Numeric, opacity of \code{bg} subbasin polygons in Leaflet maps. See \code{\link[leaflet:map-layers]{leaflet::addPolygons()}}.}

\item{plot.label}{Logical, if \code{TRUE}, then labels will be displayed in Leaflet maps when the cursor hovers over markers. See \code{\link[leaflet:map-layers]{leaflet::addCircleMarkers()}}.}

\item{noHide}{Logical, set to \code{TRUE} to always display marker labels in Leaflet maps. See \code{\link[leaflet:map-options]{leaflet::labelOptions()}}.}

\item{textOnly}{Logical, set to \code{TRUE} to hide marker label background in Leaflet maps. See \code{\link[leaflet:map-options]{leaflet::labelOptions()}}.}

\item{font.size}{Numeric, font size (px) for marker labels in Leaflet maps.}

\item{plot.bg.label}{String, if \code{hover}, then labels will be displayed in Leaflet maps for \code{bg} when the cursor hovers over polygons. If \code{static}, then static
labels for \code{bg} will be displayed in Leaflet maps.}

\item{file}{Save Leaflet map to an image file by specifying the path to the desired output file using this argument. File extension must be specified. See \code{\link[mapview:mapshot]{mapview::mapshot()}}.
You may need to run \code{webshot::install_phantomjs()} the first time you save a Leaflet map to an image file. See \code{\link[webshot:install_phantomjs]{webshot::install_phantomjs()}}.}

\item{vwidth}{Numeric, width of the exported Leaflet map image in pixels. See \code{\link[webshot:webshot]{webshot::webshot()}}.}

\item{vheight}{Numeric, height of the exported Leaflet map image in pixels. See \code{\link[webshot:webshot]{webshot::webshot()}}.}

\item{html.name}{Save Leaflet map to an interactive HTML file by specifying the path to the desired output file using this argument. File extension must be specified.
See \code{\link[htmlwidgets:saveWidget]{htmlwidgets::saveWidget()}}.}
}
\value{
For default static maps, \code{PlotMapPoints} returns a plot to the currently active plot device, and invisibly an object of class
\code{SpatialPointsDataFrame} as provided in argument \code{sites}, with plotted values and color codes added as columns
in the data slot. For interactive Leaflet maps, \code{PlotMapOutput} returns
an object of class \code{leaflet}.
}
\description{
Plot mapped point information, e.g. model performances at observation sites.
}
\details{
\code{PlotMapPoints} can be used to print point information on a mapped surface. The primary target are model performance
measures as written to
\href{http://www.smhi.net/hype/wiki/doku.php?id=start:hype_file_reference:subassx.txt}{HYPE 'subassX.txt' files}, but
color scale and break point arguments are flexible enough to also be used with e.g. HYPE output variables or other data.

\code{PlotMapOutput} can return static plots or interactive Leaflet maps depending on value provided for the argument \code{map.type}.
By default, \code{PlotMapPoints} generates a margin-less figure and positions map and legend items close to the plot boundaries.
In order to move map and legend closer to each other, change the plot device width.

Legends are positioned by keyword through argument \code{legend.pos}, defaulting to the bottom right side of the map. For default maps, \code{legend.pos} and
\code{map.adj} should be chosen so that legend and map do not overlap, and the legend position can be fine-tuned using
argument \code{legend.inset}. This is particularly useful for legend titles with more than one line. For details on inset
specification for the default maps, see \code{inset} in \code{\link{legend}}.
}
\examples{
\donttest{
# Import plot data and subbasin polygons
require(sf)
te1 <- ReadSubass(filename = system.file("demo_model",
"results", "subass1.txt", package = "HYPEtools"))
te2 <- st_read(dsn = system.file("demo_model",
"gis", "Nytorp_station.gpkg", package = "HYPEtools"))
te2$SUBID <- 3587 # add station SUBID to point
te3 <- st_read(dsn = system.file("demo_model",
"gis", "Nytorp_map.gpkg", package = "HYPEtools"))
# plot NSE performance for discharge
PlotMapPoints(x = te1[, 1:2], sites = te2, sites.subid.column = 3, bg = te3)
}

}
\seealso{
\code{\link{ReadSubass}} for HYPE result import; \code{\link{ReadMapOutput}} for a similar plot function
}
