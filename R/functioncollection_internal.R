
#--------------------------------------------------------------------------------------------------------------------------------------
#   Collection of internal helper functions, which are not exported from the package's namespace. Herein:
#
#     - .CheckcharLengthDf()
#     - .FindUpstrSbd()
#     - .CreateLabelsFromBreaks()
#     - .Scalebar()
#     - .NorthArrow()
#     - .FillWeek()
#     - .makeTransparent()
#     - .ExtractHeader()
#     - .StatSfCoordinates()
#     - .geom_sf_label_variants()
#     - .geom_sf_text_repel()
#     - 
#
#--------------------------------------------------------------------------------------------------------------------------------------




#--------------------------------------------------------------------------------------------------------------------------------------
# .CheckCharLengthDf
#--------------------------------------------------------------------------------------------------------------------------------------

## internal function to test if string columns elements are longer than a number of characters
# x: a dataframe to be tested
# maxChar: maximum number of characters
.CheckCharLengthDf <- function (x, maxChar) {
  
  # which columns are of type factor or character (strings)
  facts <- sapply(x, function(z) {is.factor(z)})
  chars <- sapply(x, function(z) {is.character(z)})
  lf <- length(which(facts))
  lc <- length(which(chars))
  
  # select and convert factor columns to a character matrix, if factors exist
  if (lf > 0) {
    facmat <- apply(as.matrix(x[, facts]), 2, as.character)
    # test if the longest string in any column is longer than maxChar characters, return with warning
    if (max(apply(facmat, 2, function (z) max(nchar(encodeString(z), allowNA = TRUE)))) > maxChar) {
      warning(paste("String with more than", maxChar, "characters in exported data detected. This will lead to an error in HYPE."))
    }
  }
  # select and convert character columns to a character matrix, if characters exist
  if (lc > 0) {
    chamat <- as.matrix(x[, chars])
    # test if the longest string in any column is longer than maxChar characters, return with warning
    te <- apply(chamat, 2, function (z) {max(nchar(encodeString(z), allowNA = TRUE), na.rm = TRUE)})
    if (any(te > maxChar)) {
      warning(paste0("String with more than ", maxChar, " characters in detected in column(s): ", paste(names(te[te > maxChar]), collapse = ","), ". This is not HYPE-comform."))
    }  
  }
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .FindUpstrSbd
#--------------------------------------------------------------------------------------------------------------------------------------


# internal function to create upstream subid list, used in DirectUpstreamSubids with 'lapply' on all subids in gd
# sbd: subid for which upstreams are searched
# dtf: df data frame which contains columns subid, maindown, branchid, mainpart, maxqmain, minqmain, maxqbranch
.FindUpstrSbd <- function(sbd, dtf) {
  # look for subid in maindown and branchid columns, concatenate positions
  mup <- dtf[which(dtf[,2] == sbd), c(1, 4, 5, 6)]
  bup <- dtf[which(dtf[,3] == sbd), c(1, 4, 7)]
  
  ## calculations of a main or branch upstream characteristics conditional on that upstreams exist
  if (nrow(mup) == 0 & nrow(bup) == 0) {
    # no upstreams exist, return an integer of length 0
    return(list(subid = sbd, upstr.df = integer()))
  }
  else {
    # if either or both main and branch upstreams exist, update to fraction of flow coming down, and the optional maximum flow
    if (nrow(mup) != 0) {
      mup <- data.frame(upstream = mup[,1], is.main = TRUE, fraction = ifelse(is.na(mup[,2]), 1, mup[,2]), llim = ifelse(is.na(mup[,3]), 0, mup[,3]), ulim = ifelse(is.na(mup[,3]), Inf, mup[,3]))
    }
    if (nrow(bup) != 0) {
      bup <- data.frame(upstream = bup[,1], is.main = FALSE, fraction = 1 - bup[,2], llim = 0, ulim = ifelse(is.na(bup[,3]), Inf, bup[,3]))
    }
    # combine the two and return result
    res <- rbind(mup, bup)
    return(list(subid = sbd, upstr.df = res))
  }
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .CreateLabelsFromBreaks
#--------------------------------------------------------------------------------------------------------------------------------------


# Internal function to make pretty label expressions from a given vector of breakpoints, which is used to convert 
# a continuous scale to a discrete one. Used for map plot function legends => not any longer, but function kept for future ref.
# breaks: vector of breakpoints
.CreateLabelsFromBreaks <- function(breaks) {
  # create first element as an expression which uses the value given in breaks
  lab.legend <- as.expression(bquote("" < .(round(breaks[2], 2))))
  # create following elements analoguously
  for (i in 2:(length(breaks)-2)) {
    lab.legend[i] <- as.expression(bquote("" >= .(round(breaks[i], 2)) - .(round(breaks[i+1], 2))))
  }
  # create the last element
  lab.legend[length(breaks)-1] <- as.expression(bquote("" >= .(round(breaks[length(breaks)-1], 2))))
  
  return(lab.legend)
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .Scalebar
#--------------------------------------------------------------------------------------------------------------------------------------


# Internal function to add a distance scalebar to a projected map.
# Code adapted from function Scalebar() in package SDMTools by Jeremy VanDerWal jjvanderwal@gmail.com. 
# x:        the x-axis position for the lower left corner of the bar
# y:        the y-axis position for the lower left corner of the bar
# distance: the distance for which the scale bar should represent
# unit:     the units to report as the scaling
# scale:    the scaling factor to rescale the distance to a different unit.
#           e.g., if your map is in m and want the scalebar to be in km, use a scale of 0.01
#t.cex:     the scaling of the font size to be used for the scalebar

#' @importFrom graphics rect text segments

.Scalebar <- function (x, y, distance, unit = "km", scale = 1, t.cex = 0.8) {
  xvals <- distance * c(0, 0.25, 0.5, 0.75, 1) + x
  yvals <- c(0, distance/c(30, 20, 10)) + y
  cols <- c("black", "white", "black", "white")
  for (i in 1:4) rect(xvals[i], yvals[1], xvals[i + 1], yvals[2], col = cols[i])
  for (i in 1:5) segments(xvals[i], yvals[2], xvals[i], yvals[3])
  labels <- c((xvals[c(1, 3)] - xvals[1]) * scale, paste((xvals[5] - xvals[1]) * scale, unit))
  labels <- c((xvals[c(1, 3, 5)] - xvals[1]) * scale, unit)
  text(c(xvals[c(1, 3, 5)], xvals[5] + diff(xvals[1:2])*.8), yvals[4], labels = labels, adj = c(0.5, 0.2), cex = t.cex)
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .NorthArrow
#--------------------------------------------------------------------------------------------------------------------------------------


# Internal function to add a North arrow to a map plot.
# Code adapted from function north.arrow in package GISTools Chris Brunsdon <christopher.brunsdon@nuim.ie>.
# xb:      The x-centre (in map units) of the arrow base.
# yb:      The y-centre (in map units) of the arrow base.
# len:     A scaling length (in map units) for arrow dimensioning.
# lab:     Label to appear under the arrow
# cex.lab: Scale factor for the label for the arrow.
# tcol:    The colour of the label text.
# ...:     Other graphical parameters passed to the drawing of the arrow.

#' @importFrom graphics polygon text strheight

.NorthArrow <- function (xb, yb, len, lab = "N", cex.lab = 1, tcol = "black", ...) {
  sx <- len * .5
  sy <- len
  arrow.x <- c(-1, 1, 1, 2, 0, -2, -1, -1)
  arrow.y <- c(0, 0, 2, 2, 4, 2, 2, 0)
  polygon(xb + arrow.x * sx, yb + arrow.y * sy, ...)
  text(xb, yb - strheight(lab, cex = cex.lab) * .9, lab, cex = cex.lab, adj = 0.4, 
       col = tcol)
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .FillWeek
#--------------------------------------------------------------------------------------------------------------------------------------


# Internal function to fill weekly averages written on last day of the week in a daily time series into preceeding NAs
# used in AnnualRegime()
.FillWeek <- function(y) {
  # reverse y
  y <- rev(y)
  # positions of non-NA values
  ind <- which(!is.na(y))
  # repeat the original values each 7 times, except for the last
  y <- rep(y[ind], times = c(rep(7, times = length(ind) - 1), 1))
  # reverse to original order again
  y <- rev(y)
  return(y)
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .makeTransparent
#--------------------------------------------------------------------------------------------------------------------------------------


# internal function to calculate transparent colors for variation polygon
# from: http://stackoverflow.com/questions/8047668/transparent-equivalent-of-given-color

#' @importFrom grDevices col2rgb rgb

.makeTransparent <- function(someColor, alpha=60) {
  newColor <- col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red = curcoldata[1], green = curcoldata[2], blue = curcoldata[3], alpha = alpha, maxColorValue = 255)})
}




#--------------------------------------------------------------------------------------------------------------------------------------
# .ExtractHeader
#--------------------------------------------------------------------------------------------------------------------------------------


# internal function to extract key-value pairs from metadata header row of HYPE result files
.ExtractHeader <- function(x) {
  
  # clip comment characters and separate key-value pairs
  te <- strsplit(substr(x, 4, nchar(x) - 1), split = "; ")[[1]]
  
  # split key-value pairs into named list
  te <- lapply(te, function(x) strsplit(x, split = "=")[[1]])
  res <- lapply(te, function(x) x[2])
  names(res) <- tolower(lapply(te, function(x) x[1]) )
}

#--------------------------------------------------------------------------------------------------------------------------------------
# .geom_sf_text_repel
#--------------------------------------------------------------------------------------------------------------------------------------

# Internal functions to plot text on geom_sf objects so that the text does not overlap
# Reference: https://github.com/yutannihilation/ggsflabel

.StatSfCoordinates <- ggplot2::ggproto(
  "StatSfCoordinates", ggplot2::Stat,
  compute_group = function(data, scales, fun.geometry) {
    points_sfc <- fun.geometry(data$geometry)
    coordinates <- sf::st_coordinates(points_sfc)
    data <- cbind(data, coordinates)
    
    data
  },
  
  default_aes = ggplot2::aes(x = stat(X), y = stat(Y)),
  required_aes = c("geometry")
)

.geom_sf_label_variants <- function(mapping = NULL,
                                   data = NULL,
                                   fun.geometry,
                                   geom_fun,
                                   ...) {
  if (is.null(mapping$geometry)) {
    # geometry_col <- attr(data, "sf_column") %||% "geometry"
    geometry_col <- attr(data, "sf_column")
    if(is.null(geometry_col)){geometry_col <- "geometry"}
    mapping$geometry <- as.name(geometry_col)
  }
  
  geom_fun(
    mapping = mapping,
    data = data,
    stat = .StatSfCoordinates,
    fun.geometry = fun.geometry,
    ...
  )
}

.geom_sf_text_repel <- function(mapping = NULL,
                               data = NULL,
                               fun.geometry = sf::st_point_on_surface,
                               ...) {
  .geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggrepel::geom_text_repel,
    ...
  )
}

#--------------------------------------------------------------------------------------------------------------------------------------
# .annotation_north_arrow
#--------------------------------------------------------------------------------------------------------------------------------------

# Internal functions to plot north arrow in ggplots
# - Adapted from ggspatial package which was set for archival by CRAN on 2023-08-25 due to unaddressed check problems

.annotation_north_arrow <- function(mapping = NULL, data = NULL, ...,
                                   height = unit(1.5, "cm"), width = unit(1.5, "cm"),
                                   pad_x = unit(0.25, "cm"), pad_y = unit(0.25, "cm"),
                                   rotation = NULL, style = north_arrow_orienteering) {
  
  if(is.null(data)) {
    data <- data.frame(x = NA)
  }
  
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = ggplot2::StatIdentity,
    geom = GeomNorthArrow,
    position = ggplot2::PositionIdentity,
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      ...,
      height = height,
      width = width,
      pad_x = pad_x,
      pad_y = pad_y,
      rotation = rotation,
      style = style
    )
  )
}

GeomNorthArrow <- ggplot2::ggproto(
  "GeomNorthArrow",
  ggplot2::Geom,
  
  extra_params = "",
  
  handle_na = function(data, params) {
    data
  },
  
  default_aes = ggplot2::aes(
    which_north = "grid",
    location = "bl"
  ),
  
  draw_panel = function(data, panel_params, coordinates,
                        height = unit(1.5, "cm"), width = unit(1.5, "cm"),
                        pad_x = unit(0.25, "cm"), pad_y = unit(0.25, "cm"),
                        rotation = NULL, style = north_arrow_orienteering) {
    
    which_north <- data$which_north[1]
    location <- data$location[1]
    
    stopifnot(
      grid::is.unit(height), length(height) == 1,
      grid::is.unit(width), length(width) == 1,
      grid::is.unit(pad_x), length(pad_x) == 1,
      grid::is.unit(pad_y), length(pad_y) == 1,
      is_grob_like(style) || is_grob_like(style())
    )
    
    if(is.null(rotation)) {
      rotation <- 0 # degrees anticlockwise
      
      if((which_north == "true") && inherits(coordinates, "CoordSf")) {
        # calculate bearing from centre of map to the north pole?
        bounds <- c(
          l = unname(panel_params$x_range[1]),
          r = unname(panel_params$x_range[2]),
          b = unname(panel_params$y_range[1]),
          t = unname(panel_params$y_range[2])
        )
        
        rotation <- -1 * true_north(
          x = bounds[substr(location, 2, 2)],
          y = bounds[substr(location, 1, 1)],
          crs = sf::st_crs(panel_params$crs)
        )
      } else if(which_north == "true") {
        warning("True north is not meaningful without coord_sf()")
      }
    }
    
    # north arrow grob in npc coordinates
    if(is_grob_like(style)) {
      sub_grob <- style
    } else if(is.function(style)) {
      if("text_angle" %in% names(formals(style))) {
        sub_grob <- style(text_angle = -rotation)
      } else {
        sub_grob <- style()
      }
    } else {
      stop("Invalid 'style' argument")
    }
    
    # position of origin (centre of arrow) based on padding, width, height
    adj_x <- as.numeric(grepl("r", location))
    adj_y <- as.numeric(grepl("t", location))
    origin_x <- unit(adj_x, "npc") + (0.5 - adj_x) * 2 * (pad_x + 0.5 * width)
    origin_y <- unit(adj_y, "npc") + (0.5 - adj_y) * 2 * (pad_y + 0.5 * height)
    
    # gtree with a custom viewport
    grid::gTree(
      children = grid::gList(sub_grob),
      vp = grid::viewport(
        x = origin_x,
        y = origin_y,
        height = height,
        width = width,
        angle = rotation
      )
    )
  }
)

true_north <- function(x, y, crs, delta_crs = 0.1, delta_lat = 0.1) {
  
  pt_crs <- sf::st_sfc(sf::st_point(c(x, y)), crs = crs)
  pt_crs_coords <- as.data.frame(sf::st_coordinates(pt_crs))
  
  pt_latlon <- sf::st_transform(pt_crs, crs = 4326)
  pt_latlon_coords <- as.data.frame(sf::st_coordinates(pt_latlon))
  
  
  # point directly grid north of x, y
  pt_grid_north <- sf::st_sfc(sf::st_point(c(x, y + delta_crs)), crs = crs)
  pt_grid_north_coords <- as.data.frame(sf::st_coordinates(pt_grid_north))
  
  # point directly true north of x, y
  pt_true_north <- sf::st_transform(
    sf::st_sfc(
      sf::st_point(c(pt_latlon_coords$X, pt_latlon_coords$Y + delta_lat)),
      crs = 4326
    ),
    crs = crs
  )
  pt_true_north_coords <- as.data.frame(sf::st_coordinates(pt_true_north))
  
  a <- c(
    x = pt_true_north_coords$X - pt_crs_coords$X,
    y = pt_true_north_coords$Y - pt_crs_coords$Y
  )
  
  b <- c(
    x = pt_grid_north_coords$X - pt_crs_coords$X,
    y = pt_grid_north_coords$Y - pt_crs_coords$Y
  )
  
  theta <- acos( sum(a*b) / ( sqrt(sum(a * a)) * sqrt(sum(b * b)) ) )
  
  # use sign of cross product to indicate + or - rotation
  cross_product <- a[1]*b[2] - a[2]*b[1]
  
  # return in degrees
  rot_degrees <- theta * 180 / pi * sign(cross_product)[1]
  
  rot_degrees
}

north_arrow_orienteering <- function(line_width = 1, line_col = "black", fill = c("white", "black"),
                                     text_col = "black", text_family = "", text_face = NULL,
                                     text_size = 10, text_angle = 0) {
  
  stopifnot(
    length(fill) == 2, is.atomic(fill),
    length(line_col) == 1, is.atomic(line_col),
    length(line_width) == 1, is.atomic(line_width),
    length(text_size) == 1, is.numeric(text_size),
    length(text_col) == 1, is.atomic(text_col),
    is.null(text_face) || (length(text_face) == 1 && is.character(text_face)),
    length(text_family) == 1, is.character(text_family)
  )
  
  arrow_x <- c(0, 0.5, 0.5, 1, 0.5, 0.5)
  arrow_y <- c(0.1, 1, 0.5, 0.1, 1, 0.5)
  arrow_id <- c(1, 1, 1, 2, 2, 2)
  text_x <- 0.5
  text_y <- 0.1
  text_label <- "N"
  text_adj <- c(0.5, 0.5)
  
  grid::gList(
    grid::polygonGrob(
      x = arrow_x,
      y = arrow_y,
      id = arrow_id,
      default.units = "npc",
      gp = grid::gpar(
        lwd = line_width,
        col = line_col,
        fill = fill
      )
    ),
    grid::textGrob(
      label = "N",
      x = text_x,
      y = text_y,
      hjust = text_adj[0],
      vjust = text_adj[1],
      rot = text_angle,
      gp = grid::gpar(
        fontfamily = text_family,
        fontface = text_face,
        fontsize = text_size + 2,
        col = text_col
      )
    )
  )
}

is_grob_like <- function(x) {
  grid::is.grob(x) || inherits(x, "gList") || inherits(x, "gTree")
}

#--------------------------------------------------------------------------------------------------------------------------------------
# .annotation_scale
#--------------------------------------------------------------------------------------------------------------------------------------

# Internal functions to plot scale bar in ggplots
# - Adapted from ggspatial package which was set for archival by CRAN on 2023-08-25 due to unaddressed check problems

.annotation_scale <- function(mapping = NULL, data = NULL,
                             ...,
                             plot_unit = NULL,
                             bar_cols = c("black", "white"),
                             line_width = 1,
                             height = unit(0.25, "cm"),
                             pad_x = unit(0.25, "cm"),
                             pad_y = unit(0.25, "cm"),
                             text_pad = unit(0.15, "cm"),
                             text_cex = 0.7,
                             text_face = NULL,
                             text_family = "",
                             tick_height = 0.6) {
  
  if(is.null(data)) {
    data <- data.frame(x = NA)
  }
  
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = ggplot2::StatIdentity,
    geom = GeomScaleBar,
    position = ggplot2::PositionIdentity,
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      ...,
      plot_unit = plot_unit,
      bar_cols = bar_cols,
      line_width = line_width,
      height = height,
      pad_x = pad_x,
      pad_y = pad_y,
      text_pad = text_pad,
      text_cex = text_cex,
      text_face = text_face,
      text_family = text_family,
      tick_height = tick_height
    )
  )
}

GeomScaleBar <- ggplot2::ggproto(
  "GeomScaleBar",
  ggplot2::Geom,
  
  extra_params = "",
  
  handle_na = function(data, params) {
    data
  },
  
  default_aes = ggplot2::aes(
    width_hint = 0.25,
    style = "bar",
    location = "bl",
    unit_category = "metric",
    text_col = "black",
    line_col = "black"
  ),
  
  draw_panel = function(self, data, panel_params, coordinates, plot_unit = NULL,
                        bar_cols = c("black", "white"),
                        line_width = 1,
                        height = unit(0.25, "cm"),
                        pad_x = unit(0.25, "cm"),
                        pad_y = unit(0.25, "cm"),
                        text_pad = unit(0.15, "cm"),
                        text_cex = 0.7,
                        text_face = NULL,
                        text_family = "",
                        tick_height = 0.6) {
    
    width_hint <- data$width_hint[1]
    style <- data$style[1]
    location = data$location[1]
    unit_category <- data$unit_category[1]
    text_col <- data$text_col[1]
    line_col <- data$line_col[1]
    
    stopifnot(
      is.null(plot_unit) || plot_unit %in% c("mi", "ft", "in", "km", "m", "cm"),
      length(unit_category) == 1, unit_category %in% c("metric", "imperial"),
      is.numeric(width_hint), length(width_hint) == 1,
      is.atomic(bar_cols),
      is.numeric(line_width), length(line_width) == 1,
      length(line_col) == 1,
      grid::is.unit(height), length(height) == 1,
      grid::is.unit(pad_x), length(pad_x) == 1,
      grid::is.unit(pad_y), length(pad_y) == 1,
      grid::is.unit(text_pad), length(text_pad) == 1,
      length(text_col) == 1,
      is.numeric(tick_height), length(tick_height) == 1
    )
    
    # ranges have to be unnamed because when given
    # xlim or ylim, these values have names that c()
    # "helpfully" appends
    if(inherits(coordinates, "CoordSf")) {
      sf_bbox <- c(
        xmin = unname(panel_params$x_range[1]),
        xmax = unname(panel_params$x_range[2]),
        ymin = unname(panel_params$y_range[1]),
        ymax = unname(panel_params$y_range[2])
      )
    } else if(coordinates$is_linear()) {
      sf_bbox <- c(
        xmin = unname(panel_params$x.range[1]),
        xmax = unname(panel_params$x.range[2]),
        ymin = unname(panel_params$y.range[1]),
        ymax = unname(panel_params$y.range[2])
      )
    } else {
      stop("Don't know how to create scalebar using ", paste(class(coordinates), collapse = "/"))
    }
    
    scalebar_params <- scalebar_params(
      sf_bbox = sf_bbox,
      plotunit = plot_unit,
      widthhint = width_hint,
      unitcategory = unit_category,
      sf_crs = panel_params$crs
    )
    
    scalebar_grobs(
      scalebar_params,
      style = style,
      location = location,
      bar_cols = bar_cols,
      line_width = line_width,
      line_col = line_col,
      height = height,
      pad_x = pad_x,
      pad_y = pad_y,
      text_pad = text_pad,
      text_cex = text_cex,
      text_col = text_col,
      text_face = text_face,
      text_family = text_family,
      tick_height = tick_height
    )
  }
)

scalebar_grobs <- function(
    params,
    style = c("ticks", "bar"),
    location = c("bl", "br", "tr", "tl"),
    bar_cols = c("black", "white"),
    line_width = 1,
    line_col = "black",
    height = unit(0.25, "cm"),
    pad_x = unit(0.25, "cm"),
    pad_y = unit(0.25, "cm"),
    text_pad = unit(0.15, "cm"),
    text_cex = 0.7,
    text_col = "black",
    text_face = NULL,
    text_family = "",
    tick_height = 0.6
) {
  style <- match.arg(style)
  
  location <- match.arg(location)
  
  adj_x <- as.numeric(grepl("r", location))
  adj_y <- as.numeric(grepl("t", location))
  width <- unit(params$widthnpc, "npc")
  
  origin_x <- unit(adj_x, "npc") - adj_x * width + (0.5 - adj_x) * 2 * pad_x
  origin_y <- unit(adj_y, "npc") - adj_y * height + (0.5 - adj_y) * 2 * pad_y
  text_origin_x <- unit(adj_x, "npc") + (0.5 - adj_x) * 2 * (pad_x + text_pad + width)
  text_origin_y <- unit(adj_y, "npc") + (0.5 - adj_y) * 2 * (pad_y + 0.5 * height)
  
  if(style == "bar") {
    bar_grob <- grid::rectGrob(
      x = origin_x + unit((seq_len(params$majordivs) - 1) * params$majordivnpc, "npc"),
      y = origin_y,
      width = unit(params$majordivnpc, "npc"),
      height = height,
      hjust = 0,
      vjust = 0,
      gp = grid::gpar(
        fill = rep(bar_cols, lengh.out = params$majordivs),
        col = line_col,
        lwd = line_width
      )
    )
  } else if(style == "ticks") {
    bar_grob <- grid::gList(
      grid::segmentsGrob(
        x0 = origin_x + unit((seq_len(params$majordivs + 1) - 1) * params$majordivnpc, "npc"),
        y0 = origin_y,
        x1 = origin_x + unit((seq_len(params$majordivs + 1) - 1) * params$majordivnpc, "npc"),
        y1 = origin_y + grid::unit.c(height, rep(height * tick_height, params$majordivs - 1), height),
        gp = grid::gpar(
          lwd = line_width,
          col = line_col
        )
      ),
      grid::segmentsGrob(
        x0 = origin_x,
        y0 = origin_y,
        x1 = origin_x + width,
        y1 = origin_y,
        gp = grid::gpar(
          lwd = line_width,
          col = line_col
        )
      )
    )
  } else {
    stop("not implemented")
  }
  
  grid::gList(
    bar_grob,
    grid::textGrob(
      label = params$labeltext,
      x = text_origin_x,
      y = text_origin_y,
      hjust = adj_x,
      vjust = 0.5,
      gp = grid::gpar(
        cex = text_cex,
        col = text_col,
        fontfamily = text_family,
        fontface = text_face
      )
    )
  )
}

# this is a rewritten version of prettymapr::scalebarparams()
# that uses sf projections rather than epsg codes
scalebar_params <- function(
    sf_bbox,
    plotunit = NULL,
    sf_crs = NULL,
    widthhint = 0.25,
    unitcategory = c("metric", "imperial")
) {
  # params check
  unitcategory <- match.arg(unitcategory)
  
  if(!is.null(sf_crs) && is.null(plotunit)) {
    
    point_coords <- expand.grid(
      x = c(sf_bbox["xmin"], sf_bbox["xmax"]),
      y = c(sf_bbox["ymin"], mean(c(sf_bbox["ymin"], sf_bbox["ymax"])), sf_bbox["ymax"])
    )
    latlon_coords <- sf::st_coordinates(
      sf::st_transform(
        sf::st_as_sf(point_coords, coords = c("x", "y"), crs = sf_crs),
        4326
      )
    )
    
    widthbottom <- .geodist(latlon_coords[1,], latlon_coords[2,])
    widthmiddle <- .geodist(latlon_coords[3,], latlon_coords[4,])
    widthtop <- .geodist(latlon_coords[5,], latlon_coords[6,])
    percentdiff <- (max(widthbottom, widthmiddle, widthtop) -
                      min(widthbottom, widthmiddle, widthtop)) / min(widthbottom, widthmiddle, widthtop)
    
    if(percentdiff > 0.1) {
      message("Scale on map varies by more than 10%, scale bar may be inaccurate")
    }
    
    widthm <- unname(widthmiddle)
    mperplotunit <- unname(widthmiddle/(sf_bbox["xmax"]-sf_bbox["xmin"]))
  } else {
    
    if(is.null(plotunit)) {
      message("Using plotunit = 'm'")
      plotunit <- "m"
    }
    
    plotunit <- match.arg(plotunit, choices = c("km", "m", "cm", "mi", "ft", "in"))
    
    heightm <- .tosi(sf_bbox["ymax"] - sf_bbox["ymin"], plotunit)
    widthm <- unname(.tosi(sf_bbox["xmax"] - sf_bbox["xmin"], plotunit))
    mperplotunit <- unname(.tosi(1.0, plotunit))
  }
  
  geowidthm <- unname(widthm * widthhint)
  
  if(geowidthm < 1) {
    scaleunits <- c("cm", "in")
  } else if(geowidthm < 1600) {
    scaleunits <- c("m", "ft")
  } else {
    scaleunits <- c("km", "mi")
  }
  
  #   String unit = units[unitCategory] ;
  if(unitcategory == "metric") {
    unit <- scaleunits[1]
  } else {
    unit <- scaleunits[2]
  }
  #   double widthHintU = Units.fromSI(geoWidthM, unit) ;
  widthhintu <- .fromsi(geowidthm, unit)
  #   double tenFactor = Math.floor(Math.log10(widthHintU)) ;
  tenfactor <- floor(log10(widthhintu))
  #   double widthInTens = Math.floor(widthHintU / Math.pow(10, tenFactor)) ;
  widthintens <- floor(widthhintu / (10^tenfactor))
  if(widthintens == 1) {
    widthintens <- 10
    tenfactor = tenfactor - 1 ;
  } else if(widthintens == 7) {
    widthintens <- 6
  } else if(widthintens == 9) {
    widthintens <- 8
  }
  
  if(widthintens < 6) {
    majdivtens <- 1
  } else {
    majdivtens <- 2
  }
  
  #   double widthU = widthInTens * Math.pow(10, tenFactor) ;
  widthu <- widthintens * 10^tenfactor
  #   double majorDiv = majDivTens * Math.pow(10, tenFactor) ;
  majordiv <- majdivtens * 10^tenfactor
  #   long majorDivs = Math.round(widthU / majorDiv) ;
  majordivs <- round(widthu / majordiv)
  #   double widthPx = Units.toSI(widthU, unit) / mPerPixel ;
  widthplotunit <- .tosi(widthu, unit) / mperplotunit
  #   double majorDivPx = widthPx / majorDivs ;
  majordivplotunit <- widthplotunit / majordivs
  #   this.scaleParameters = new double[] {widthU, majorDiv, widthPx, majorDivPx} ;
  params = list()
  params$plotwidthu <- .fromsi(widthm, unit)
  params$widthu <- widthu
  params$widthnpc <- params$widthu / params$plotwidthu
  params$unit <- unit
  params$majordivu <- majordiv
  params$majordivnpc <- params$majordivu / params$plotwidthu
  params$majordivs <- majordivs
  params$widthplotunit <- widthplotunit
  params$majordivplotunit <- majordivplotunit
  params$labeltext <- paste(as.integer(widthu), unit)
  params$extents <- sf_bbox
  #   this.labelText = String.valueOf(Math.round(widthU)) + " " + unit ;
  params
  
}

.geodist <- function(lonlat1, lonlat2) {
  
  long1 <- .torad(lonlat1[1])
  lat1 <- .torad(lonlat1[2])
  long2 <- .torad(lonlat2[1])
  lat2 <- .torad(lonlat2[2])
  R <- 6371009 # Earth mean radius [m]
  delta.long <- (long2 - long1)
  delta.lat <- (lat2 - lat1)
  a <- sin(delta.lat/2)^2 + cos(lat1) * cos(lat2) * sin(delta.long/2)^2
  c <- 2 * asin(min(1,sqrt(a)))
  d = R * c
  return(d) # Distance in m
}

.torad <- function(deg) {
  deg*pi/180.0
}

.fromsi <- function(sivalue, unit) {
  if(unit == "km") {
    sivalue / 1000.0
  } else if(unit == "m") {
    sivalue
  } else if(unit =="ft") {
    sivalue * 3.28084
  } else if(unit == "mi") {
    sivalue / 1609.344051499
  } else if(unit == "in") {
    sivalue * 39.370079999999809672
  } else if(unit == "cm") {
    sivalue * 100.0
  } else {
    stop("Unrecognized unit: ", unit)
  }
}

.tosi <- function(unitvalue, unit) {
  if(unit == "km") {
    unitvalue * 1000.0
  } else if(unit == "m") {
    unitvalue
  } else if(unit =="ft") {
    unitvalue / 3.28084
  } else if(unit == "mi") {
    unitvalue * 1609.344051499
  } else if(unit == "in") {
    unitvalue / 39.370079999999809672
  } else if(unit == "cm") {
    unitvalue / 100.0
  } else {
    stop("Unrecognized unit: ", unit)
  }
}
