test_that("vnv_convert() returns a vector with same length as input", {
    price <- c(1, 2, 3, 4, 5)
    date <- as.Date(c("2020-01-01", "2019-01-01", "2018-01-01", "2017-01-01", "2016-01-01"))
    price_2020_01_01 <- vnv_convert(obs_value = price, obs_date = date, convert_date = as.Date("2020-01-01"))
    expect_equal(length(price), length(price_2020_01_01))
})
