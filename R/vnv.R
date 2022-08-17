#' Fetch consumer price index from Statistics Iceland
#'
#' @param date_unity A date variable of length one at which the CPI takes the value 1. Possible values are the first of each month from 1988-05-01 to the month preceding the current month.
#' @param include_housing A boolean to decide whether to include housing in the CPI
#'
#' @return A tibble with two columns denoting the date and the CPI at that date
#' @export
#'
#' @examples
#' d <- vnv()
#' d <- vnv(include_housing = FALSE)
#' my_date <- as.Date("2014-01-01")
#' d <- vnv(date_unity = my_date)
vnv <- function(date_unity = NULL, include_housing = TRUE) {
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

    if (is.null(date_unity)) {
        return(out)
    } else {
        out <- out |>
            dplyr::mutate(cpi = cpi / cpi[date == date_unity])

        return(out)
    }
}
