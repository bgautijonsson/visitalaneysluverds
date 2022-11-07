.onLoad <- function(libname, pkgname) {
    packageStartupMessage("Downloading CPI data from Statistics Iceland and making available to internal functions. This happens once per session.")

    vnv_dat <- .vnv_onLoad()
    cpi_housing <- vnv_dat$cpi
    names(cpi_housing) <- vnv_dat$date

    vnv_dat$year <- lubridate::year(vnv_dat$date)
    vnv_dat_yearly <- dplyr::summarise(
        dplyr::group_by(
            vnv_dat,
            year
        ),
        cpi = mean(cpi)
    )

    cpi_housing_yearly <- vnv_dat_yearly$cpi
    names(cpi_housing_yearly) <- vnv_dat_yearly$year



    vnv_dat <- .vnv_onLoad(include_housing = FALSE)
    cpi_no_housing <- vnv_dat$cpi
    names(cpi_no_housing) <- vnv_dat$date

    vnv_dat$year <- lubridate::year(vnv_dat$date)
    vnv_dat_yearly <- dplyr::summarise(
        dplyr::group_by(
            vnv_dat,
            year
        ),
        cpi = mean(cpi)
    )

    cpi_no_housing_yearly <- vnv_dat_yearly$cpi
    names(cpi_no_housing_yearly) <- vnv_dat_yearly$year



    assign("cpi_housing", cpi_housing, envir = topenv())
    assign("cpi_no_housing", cpi_no_housing, envir = topenv())
    assign("cpi_housing_yearly", cpi_housing_yearly, envir = topenv())
    assign("cpi_no_housing_yearly", cpi_no_housing_yearly, envir = topenv())

}
