test_that("calc_mean works correctly", {
  expect_equal(calc_mean(c(1,2,3)), 2)
  expect_error(calc_mean("a"))
  expect_true(is.na(calc_mean(numeric(0))))
})
test_that("calc_median works correctly", {
  expect_equal(calc_median(c(1,2,3)), 2)
  expect_error(calc_median("a"))
  expect_true(is.na(calc_median(numeric(0))))
})
test_that("calc_mode works correctly", {
  expect_equal(calc_mode(c(1,2,3)), 2)
  expect_error(calc_mode("a"))
  expect_true(is.na(calc_mode(numeric(0))))
})
test_that("calc_q1 works correctly", {
  expect_equal(calc_q1(c(1,2,3)), 2)
  expect_error(calc_q1("a"))
  expect_true(is.na(calc_q1(numeric(0))))
})
test_that("calc_q3 works correctly", {
  expect_equal(calc_q3(c(1,2,3)), 2)
  expect_error(calc_q3("a"))
  expect_true(is.na(calc_q3(numeric(0))))
})
test_that("calc_iqr works correctly", {
  expect_equal(calc_iqr(c(1,2,3)), 2)
  expect_error(calc_iqr("a"))
  expect_true(is.na(calc_iqr(numeric(0))))
})