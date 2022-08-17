
<!-- README.md is generated from README.Rmd. Please edit that file -->

# visitalaneysluverds

<!-- badges: start -->
<!-- badges: end -->

The package provides an easy way to fetch the CPI from Statistics
Iceland.

## Installation

You can install the development version of visitalaneysluverds from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bgautijonsson/visitalaneysluverds")
```

## Example

``` r
library(visitalaneysluverds)
d <- vnv()

d
#> # A tibble: 411 × 2
#>    date         cpi
#>    <date>     <dbl>
#>  1 1988-05-01  1   
#>  2 1988-06-01  1.03
#>  3 1988-07-01  1.07
#>  4 1988-08-01  1.09
#>  5 1988-09-01  1.1 
#>  6 1988-10-01  1.10
#>  7 1988-11-01  1.10
#>  8 1988-12-01  1.11
#>  9 1989-01-01  1.13
#> 10 1989-02-01  1.14
#> # … with 401 more rows
#> # ℹ Use `print(n = ...)` to see more rows
```

``` r
plot(cpi ~ date, data = d, type = "l")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

You can input a date on which the CPI should be equal to 1. The date has
to be the first day of a month between 1988-05-01 and the month
preceding the current month. If no date is input the CPI is equal to 1
ni 1988-05-01

``` r
d <- vnv(date_unity = as.Date("2018-01-1"))
plot(cpi ~ date, data = d, type = "l")
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
