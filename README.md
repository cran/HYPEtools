
# HYPEtools <a href='https://github.com/rcapell/HYPEtools'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/HYPEtools)](https://CRAN.R-project.org/package=HYPEtools)
[![Conda Version](https://img.shields.io/conda/vn/conda-forge/r-hypetools.svg)](https://anaconda.org/conda-forge/r-hypetools)
[![R-CMD-check](https://github.com/rcapell/HYPEtools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rcapell/HYPEtools/actions/workflows/R-CMD-check.yaml)
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7627955.svg)](https://doi.org/10.5281/zenodo.7627955)
<!-- badges: end -->

## Summary

HYPEtools provides functions to work
with the hydrological model [HYPE](https://hypeweb.smhi.se/model-water/). HYPE
and HYPEtools are projects developed by the
[Swedish Meteorological and Hydrological Institute (SMHI)](https://www.smhi.se/en).

## License
HYPEtools is licensed under the [LGPL-3.0](https://www.gnu.org/licenses/lgpl-3.0) license.

## Changelog
See the HYPEtools changelog [here](NEWS.md).

## Installation

HYPEtools is on CRAN and can be downloaded with:
``` r
install.packages("HYPEtools")
```

If, however, you would like to install the latest development version of HYPEtools from
[GitHub](https://github.com/rcapell/HYPEtools), then you can do so with:

``` r
# install.packages("devtools")
devtools::install_github("rcapell/HYPEtools") # Install Without Vignettes
devtools::install_github("rcapell/HYPEtools", build_vignettes = T) # Install With Vignettes
```

More detailed instructions on installing the provided sources or package in
R can be found [here](https://github.com/rcapell/HYPEtools/wiki/Install-and-Update-HYPEtools-from-github).

## Vignettes

Browse HYPEtools Vignettes with:

``` r
browseVignettes("HYPEtools")
```
