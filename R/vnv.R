#' Fetch monthly consumer price index from Statistics Iceland
#'
#' @param date_unity A date variable of length one at which the CPI takes the value 1. The default is the previous month. Possible values are dates between 1988-05-01 and the month preceding the current month. The input will be converted to the first of its month to match the CPI release date.
#' @param include_housing A boolean to decide whether to include housing in the CPI
#'
#' @return A tibble with two columns denoting the date and the CPI at that date
#' @export
#'
#' @examples
#' d <- vnv()
#' d <- vnv(include_housing = FALSE)
#' my_date <- as.Date("2014-01-15")
#' d <- vnv(date_unity = my_date)
vnv <- function(date_unity = NULL, include_housing = TRUE) {
    # After package loading this is used to prepare CPI data from the package environment as a tibble

    if (is.null(date_unity)) {
        date_unity <- lubridate::today()
        date_unity <- lubridate::floor_date(date_unity, "month")
        lubridate::month(date_unity) <- lubridate::month(date_unity) - 1
    }


    cpi <- if (include_housing) cpi_housing else cpi_no_housing

    cpi <- cpi / cpi[names(cpi) == as.character(date_unity)]


    out <- tibble::tibble(
        date = lubridate::as_date(names(cpi)),
        cpi = unname(cpi)
    )



    out

}

#' Fetch yearly price index from Statistics Iceland
#'
#' @param year_unity An integer variable of length one at which the CPI takes the value 1. The default is the current year. Possible values are years between 1988 and the current year.
#' @param include_housing A boolean to decide whether to include housing in the CPI
#'
#' @return A tibble with two columns denoting the year and the mean CPI at that year
#' @export
#'
#' @examples
#' d <- vnv_yearly()
#' d <- vnv_yearly(include_housing = FALSE)
#' my_year <- 2015
#' d <- vnv_yearly(year_unity = my_year)
vnv_yearly <- function(year_unity = NULL, include_housing = TRUE) {
    # After package loading this is used to prepare CPI data from the package environment as a tibble

    if (is.null(year_unity)) {
        year_unity <- lubridate::year(lubridate::today())
    }

    cpi <- if (include_housing) cpi_housing_yearly else cpi_no_housing_yearly

    cpi <- cpi / cpi[names(cpi) == as.character(year_unity)]

    out <- tibble::tibble(
        year = as.integer(names(cpi)),
        cpi = unname(cpi)
    )

    out
}

# This function is run once per session upon loading the package with library(), require() or using visitalaneysluverds::
.vnv_onLoad <- function(include_housing = TRUE) {
    visitala <- if (include_housing) "CPI" else "CPILH"
    # Create the query using unicode characters for Icelandic letters
    my_query <- list(
        c("*"),
        c(visitala),
        c("index")
    )
    names(my_query) <- c(paste0("M", "\u00E1", "nu", "\u00F0", "ur"),
                         paste0("V", "\u00ED", "sitala"),
                         paste0("Li", "\u00F0", "ur"))

    out <- pxweb::pxweb_get(
        url ="https://px.hagstofa.is:443/pxis/api/v1/is/Efnahagur/visitolur/1_vnv/1_vnv/VIS01000.px",
        query = my_query,
        verbose = FALSE
    ) |>
        as.data.frame() |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        tidyr::separate(manudur, into = c("ar", "manudur"), sep = "M", convert = T) |>
        dplyr::mutate(manudur = stringr::str_pad(manudur, width = 2, side = "left", pad = "0"),
                      date = paste0(ar, "-", manudur, "-01") |> lubridate::ymd(),
                      visitala_neysluverds = visitala_neysluverds / 100) |>
        dplyr::select(date, cpi = visitala_neysluverds)

    return(out)


}
