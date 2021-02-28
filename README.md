
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

## Usage

The package implements functions for accessing all publicly available
API endpoints as defined in the
[documentation](https://www.hlidacstatu.cz/api/v2/swagger/index) of the
Hlídač státu API.

The data available via the API are related to:

  - funding of political parties  
  - transcriptions of parliamentary floor debates, municipal council
    debates and other bodies  
  - contracts between public institutions and private companies  
  - subsidies  
  - availability of websites operated by public institutions  
    etc.

## Example

There are two types of datasets available at the Hlídač státu API.
First, there are various collection of datasets whose list is available
using `get_datasets()`.

``` r
library(dplyr)
library(hlidacr)

# Authorization token
TOKEN <- Sys.getenv("HLIDAC_TOKEN")

datasets <- get_datasets(token = TOKEN)
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

In general, the data are usually returned in a list with 3 elements:

  - Page  
  - Total: total number of records  
  - Results: data

(Therefore, to get all the data you need to iterate over the pages by
specifying particular page of the results you want)

The data from these datasets can be obtained by `get_dataset_data`
function using dataset’s ID. For example:

``` r
ministers <- get_dataset_data("ministri", page = 1)
head(ministers$Results %>% select(resort, jmeno, strana, zacatek))
#>                                 resort            jmeno   strana
#> 1                  Ministerstvo obrany Miloslav Výborný  KDU-ČSL
#> 2     Ministerstvo životního prostředí   Richard Brabec ANO 2011
#> 3       Ministerstvo zahraničních věcí        Jan Kavan     ČSSD
#> 4           Ministerstvo spravedlnosti     Pavel Blažek      ODS
#> 5                       Předseda vlády    Jiří Paroubek     ČSSD
#> 6 Ministerstvo práce a sociálních věcí  Zdeněk Škromach     ČSSD
#>                     zacatek
#> 1 1996-07-04T00:00:00+02:00
#> 2 2018-06-27T00:00:00+02:00
#> 3 1998-07-22T00:00:00+02:00
#> 4 2012-07-03T00:00:00+02:00
#> 5 2005-04-25T00:00:00+02:00
#> 6 2004-08-04T00:00:00+02:00
```

Second, there are specific datasets that are available via specific
routes and therefore specific functions. These include datasets related
to contracts between public institutions and private companies,
subsidies, companies, persons and websites.

For example:

``` r
golf_subsidies <- search_subsidies("golf")
head(golf_subsidies$Results %>% select(IdDotace, NazevProjektu, DotaceCelkem))
#>                                       IdDotace
#> 1 dotinfo-2ebb2071-8444-40be-8560-91af6e7fefa0
#> 2                         deminimis-1000229862
#> 3       eufondy-04-06-cz-04-1-05-4-1-44-2-2970
#> 4                         deminimis-1000411828
#> 5                         deminimis-1000219471
#> 6                         deminimis-1000359004
#>                                                NazevProjektu DotaceCelkem
#> 1    GOLF CLUB U Hrádečku - podnikové vzdělávání zaměstnanců            0
#> 2               Mezinárodní golfový turnaj v extrémním golfu         5000
#> 3                                           Golf pro všechny       360555
#> 4                                           Golf pro všechny       200000
#> 5                                             Golfový turnaj        30000
#> 6 Mezinárodní golfový turnaj 112 ANNIVERSARY GOLF TOURNAMENT       150000
```

``` r
golf_contracts <- search_contracts("golf")
head(golf_contracts$Results %>% select(predmet, hodnotaBezDph))
#>                                                                                       predmet
#> 1                                               836/OSRM/2017 smlouva o dílo - adventure golf
#> 2                                      Smlouva o poskytování reklamních a propagačních služeb
#> 3                                      Smlouva o poskytování reklamních a propagačních služeb
#> 4                                      Smlouva o poskytování reklamních a propagačních služeb
#> 5                                     Smlouva o poskytování reklamních a propagačních služeb 
#> 6 Smlouva o dílo - Žižkova ul. – oprava chodníků – úsek Jilemnického – Novákova - Štefánikova
#>   hodnotaBezDph
#> 1        245000
#> 2         70000
#> 3        762000
#> 4        762000
#> 5        210000
#> 6       2205569
```

In addition, you can get the text of particular contract using
`get_contract_text` using the ID of the contract that is stored in the
column `Id` in the data.frame returned by `search_contracts`.

``` r
con_text <- get_contract_text(id = "9934567")
cat(substr(con_text[1], 1500, 2000))
#>  Smlouvy
#> 
#> 1.1. Prodávající se zavazuje, že Kupujícímu odevzdá za podmínek stanovených touto
#> Smlouvou golfový multisimulátor Visual Sports s golfovým trenažérem s poslední verzí
#> golfu E6 a herní konzolí s nabídkou her jako je fotbal, basketbal, hokej a další možnosti
#> pro využití spokojenosti dětí a laserovou střelnicí, vč. sportovního vybavení na fotbal,
#> hokej a basketbal, které jsou co do technických parametrů a svého příslušenství blíže
#> specifikovány v příloze č. 1 této Smlouvy (dále jen
```

Searching for a person is done using `search_person`. For instance:

``` r
babis <- search_person("Babiš")
head(babis)
#>      Jmeno Prijmeni            Narozeni           NameId
#> 1   Patrik    Babiš 1973-05-01T00:00:00     patrik-babis
#> 2    Pavel    Babiš 1975-02-20T00:00:00      pavel-babis
#> 3    Miloš    Babiš 1960-05-12T00:00:00      milos-babis
#> 4   Patrik    Babiš 1972-04-17T00:00:00   patrik-babis-1
#> 5   Andrej    Babiš 1954-09-02T00:00:00     andrej-babis
#> 6 Alexandr    Babic 1975-11-07T00:00:00 alexandr-babic-2
#>                   Profile TitulPred TitulPo
#> 1     /osoba/patrik-babis      <NA>    <NA>
#> 2      /osoba/pavel-babis                  
#> 3      /osoba/milos-babis                  
#> 4   /osoba/patrik-babis-1      <NA>    <NA>
#> 5     /osoba/andrej-babis      Ing.    <NA>
#> 6 /osoba/alexandr-babic-2
```

`get_person` function provides data related to a person such as their
donations to political parties, service in public and private
institutions and their social media accounts. The example below shows
Andrej Babiš’s donations to political parties.

``` r
ab <- get_person("andrej-babis")
head(ab$Sponzoring %>% arrange(desc(Castka)))
#>       Typ Organizace  Castka             DatumOd             DatumDo
#> 1 sponzor        ANO 8000000 2012-01-01T00:00:00 2012-01-01T00:00:00
#> 2 sponzor        ANO 2500000 2012-01-01T00:00:00 2012-01-01T00:00:00
#> 3 sponzor        ANO 2500000 2012-01-01T00:00:00 2012-01-01T00:00:00
#> 4 sponzor        ANO 2000000 2012-01-01T00:00:00 2012-01-01T00:00:00
#> 5 sponzor        ANO 2000000 2012-01-01T00:00:00 2012-01-01T00:00:00
#> 6 sponzor        ANO 2000000 2012-01-01T00:00:00 2012-01-01T00:00:00
```

Besides getting social media accounts for a particular person using the
`get_person` function, you can obtain social media accounts of Czech
politicians, using `get_person_social`. It returns a data.frame with a
data.frame nested in the `SocialniSite` variable. For instance:

``` r
twitter_insta <- get_person_social(types = c("Instagram", "Twitter"))
twitter_insta$SocialniSite[1]
#> [[1]]
#>        Type           Id                                    Url
#> 1   Twitter PatrikNacher       https://twitter.com/PatrikNacher
#> 2 Instagram nacherpatrik https://www.instagram.com/nacherpatrik
```
