
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hlidacr

<!-- badges: start -->

[![R build
status](https://github.com/skvrnami/hlidacr/workflows/R-CMD-check/badge.svg)](https://github.com/skvrnami/hlidacr/actions)
[![codecov](https://codecov.io/gh/skvrnami/hlidacr/branch/main/graph/badge.svg?token=FWP73F1DOL)](https://codecov.io/gh/skvrnami/hlidacr)
<!-- badges: end -->

The goal of hlidacr is to provide access to the data published by
[Hlídač státu](https://www.hlidacstatu.cz/) provided by their
[API](https://www.hlidacstatu.cz/api/v2/swagger/index).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("skvrnami/hlidacr")
```

Besides the installation, you need access token for making API requests.
The access token is available
[here](https://www.hlidacstatu.cz/api/v1/Index) after the registration
at the Hlídač státu’s website.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(hlidacr)

# Authorization token
TOKEN <- Sys.getenv("HLIDAC_TOKEN")

datasets <- get_datasets(TOKEN)
str(datasets, max.level = 1)
#> List of 3
#>  $ Total  : int 35
#>  $ Page   : int 1
#>  $ Results:'data.frame': 35 obs. of  16 variables:

head(datasets$Results[,1:2], 10)
#>                          id                               name
#> 1                  ministri                           Ministři
#> 2         ministry-invoices            Faktury ministerstev ČR
#> 3           rozhodnuti-uohs                    Rozhodnutí UOHS
#> 4            prijemcidotaci                    Příjemci dotací
#> 5    publicchargingstations Seznam veřejných dobíjecích stanic
#> 6  faktury-mesto-plasy-2018           Faktury Město Plasy 2018
#> 7                   dotinfo                            DotInfo
#> 8   kvalifikovanidodavatele           Kvalifikovani dodavatele
#> 9                stav-mostu                    Stav Mostů v ČR
#> 10 seznam-politickych-stran   Seznam politických stran a hnutí
```
