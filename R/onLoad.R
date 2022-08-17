# vnv_global <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
    packageStartupMessage("Downloading CPI data from Statistics Iceland and making available to internal functions. This happens once per session.")
    vnv_dat <- vnv()
    cpi_housing <- vnv_dat$cpi
    names(cpi_housing) <- vnv_dat$date

    vnv_dat <- vnv(include_housing = FALSE)
    cpi_no_housing <- vnv_dat$cpi
    names(cpi_no_housing) <- vnv_dat$date

    # vnv_global$cpi_housing <<- cpi_housing
    # vnv_global$cpi_no_housing <<- cpi_no_housing

    assign("cpi_housing", cpi_housing, envir = topenv())
    assign("cpi_no_housing", cpi_no_housing, envir = topenv())

}
