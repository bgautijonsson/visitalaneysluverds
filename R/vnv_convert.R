#' Convert prices to a common level using icelandic CPI
#'
#' To allow users to use the most recent CPI as a base, the first time this function is used the CPI is
#' downloaded from Statistics Iceland and added to the package environment. Then a helper function called
#' vnv_convert.fun is defined and also added to the package environment.
#'
#' This means that the CPI timeseries is only downloaded the first time this function is run -hopefully-.
#'
#' @param obs_value Numeric vector. The price or value you want to convert
#' @param obs_date Date vector/integer vector, same length as obs_value. The date/year at which the price/value is recorded
#' @param date_unity Date/integer variable. The date/year at which you want the CPI to be equal to 1 i.e. the price date/year. If nothing is input the default value is the most recent CPI release date/year.
#' @param include_housing Boolean variable. Whether to use CPI with housing included or not when adjusting for CPI.
#'
#' @return Returns a numeric vector of length equal to the length of obs_value
#' @export
#'
#' @examples
#' price <- c(1, 2, 3, 4, 5)
#' date = as.Date(c("2020-01-01", "2019-01-01", "2018-01-01", "2017-01-01", "2016-01-01"))
#' price_2020 <- vnv_convert(obs_value = price, obs_date = date, date_unity = as.Date("2020-01-01"))
vnv_convert <- function(obs_value, obs_date, date_unity = NULL, include_housing = TRUE) {

    if (all(class(obs_date) == "Date")) {
        out <- .vnv_date_unity(obs_value, obs_date, date_unity, include_housing)
    } else if (all(class(obs_date) %in% c("numeric", "integer"))) {
        out <- .vnv_convert_year(obs_value, obs_date, date_unity, include_housing)
    }

    return(out)

}


#' Helper function to perform CPI adjustment on monthly price data
#'
#' @param obs_value Numeric vector. The price or value you want to convert
#' @param obs_date Date vector, same length as obs_value. The date at which the price/value is recorded
#' @param date_unity Date variable. The date at which you want the CPI to be equal to 1 i.e. the price date. If nothing is input the default value is the most recent CPI release date.
#' @param include_housing Boolean variable. Whether to use CPI with housing included or not when adjusting for CPI.
#'
#' @return Returns a numeric vector of length equal to the length of obs_value
.vnv_date_unity <- function(obs_value, obs_date, date_unity, include_housing = TRUE) {

    if (is.null(date_unity)) {
        date_unity <- lubridate::today()
        date_unity <- lubridate::floor_date(date_unity, "month")
        lubridate::month(date_unity) <- lubridate::month(date_unity) - 1
    }

    obs_date <- lubridate::floor_date(obs_date, "month")


    cpi <- if (include_housing) cpi_housing else cpi_no_housing

    out <- obs_value / (cpi[as.character(obs_date)] / cpi[as.character(date_unity)])

    return(out)

}


#' Helper function to perform CPI adjustment on yearly price data
#'
#' @param obs_value Numeric vector. The price or value you want to convert
#' @param obs_date Integer vector, same length as obs_value. The year at which the price/value is recorded
#' @param date_unity Integer variable. The year at which you want the CPI to be equal to 1 i.e. the price year. If nothing is input the default value is the most recent CPI release year.
#' @param include_housing Boolean variable. Whether to use CPI with housing included or not when adjusting for CPI.
#'
#' @return Returns a numeric vector of length equal to the length of obs_value
.vnv_convert_year <- function(obs_value, obs_date, date_unity, include_housing = TRUE) {
    if (is.null(date_unity)) {
        date_unity <- lubridate::year(lubridate::today())
    }


    cpi <- if (include_housing) cpi_housing_yearly else cpi_no_housing_yearly

    out <- obs_value / (cpi[as.character(obs_date)] / cpi[as.character(date_unity)])

    return(out)

}


