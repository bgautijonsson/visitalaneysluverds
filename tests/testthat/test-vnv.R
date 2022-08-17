test_that("vnv() returns a tibble with two columns", {
  expect_equal(ncol(vnv()), 2)
})
