
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

### CPI table

``` r
library(visitalaneysluverds)
#> Downloading CPI data from Statistics Iceland and making available to internal functions. This happens once per session.
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

### Performing CPI adjustments

The package offers use of the function `cpi_convert()` to convert prices
to a common CPI standard.

``` r
price <- c(1, 2, 3, 4, 5)
date <- as.Date(c("2020-01-01", "2019-01-01", "2018-01-01", "2017-01-01", "2016-01-01"))
d <- data.frame(
    date = date,
    price = price
)

d$price_2020_01_01 <- vnv_convert(d$price, d$date, convert_date = as.Date("2020-01-01"))

d
#>         date price price_2020_01_01
#> 1 2020-01-01     1         1.000000
#> 2 2019-01-01     2         2.033766
#> 3 2018-01-01     3         3.154432
#> 4 2017-01-01     4         4.305155
#> 5 2016-01-01     5         5.484473
```

The function `vnv_convert()` works because the package downloads CPI
data from Statistics Iceland once per session and makes it available to
internal functions, allowing the user to use the most recent CPI data to
compare prices if needed.
