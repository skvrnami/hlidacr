
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hlidacr

<!-- badges: start -->

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
#>  $ Total  : int 28
#>  $ Page   : int 1
#>  $ Results:'data.frame': 28 obs. of  16 variables:

head(datasets$Results[,1:2], 5)
#>                       id                               name
#> 1               ministri                           Ministři
#> 2      ministry-invoices            Faktury ministerstev ČR
#> 3        rozhodnuti-uohs                    Rozhodnutí UOHS
#> 4         prijemcidotaci                    Příjemci dotací
#> 5 publicchargingstations Seznam veřejných dobíjecích stanic
```
