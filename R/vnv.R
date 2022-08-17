vnv <- function() {
    pxweb::pxweb_get(
        url ="https://px.hagstofa.is:443/pxis/api/v1/is/Efnahagur/visitolur/1_vnv/1_vnv/VIS01000.px",
        query = list(
            "Mánuður" = c("*"),
            "Vísitala"  = c("CPI"),
            "Liður" = c("index")
        ),
        verbose = FALSE
    ) |>
        as.data.frame() |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        tidyr::separate(manudur, into = c("ar", "manudur"), sep = "M", convert = T) |>
        dplyr::mutate(manudur = stringr::str_pad(manudur, width = 2, side = "left", pad = "0"),
                      date = stringr::str_c(ar, "-", manudur, "-01") |> lubridate::ymd()) |>
        dplyr::select(-manudur, -ar, -visitala, -lidur)
}
