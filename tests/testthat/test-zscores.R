context("zscores - anthro_zscores")

describe("anthro_zscores()", {
  it("transforms age in months to age in days", {
    res_months <- anthro_zscores(
      sex = 1L,
      age = 30,
      weight = 20,
      is_age_in_month = TRUE
    )
    res_days <- anthro_zscores(
      sex = 1L,
      age = 30 * ANTHRO_DAYS_OF_MONTH,
      weight = 20,
      is_age_in_month = FALSE
    )
    expect_equal(res_months, res_days)
  })
  it("adds bmi to the output data.frame", {
    expected_bmi <- 20 / ((100 / 100)^2)
    res <- anthro_zscores(
      sex = 1L,
      age = 30,
      weight = 20,
      lenhei = 100
    )
    expect_equal(res[["cbmi"]], expected_bmi)
  })
  it("adds adjusted lenhei to the output data.frame", {
    expected_clenhei <- c(
      100 + 0.7,
      100,
      100,
      100 - 0.7
    )
    res <- anthro_zscores(
      sex = c(1L, 1L, 1L, 1L),
      age = c(730, 800, 730, 800),
      lenhei = c(100, 100, 100, 100),
      measure = c("h", "h", "l", "l"),
      is_age_in_month = FALSE
    )
    expect_equal(res[["clenhei"]], expected_clenhei)
  })
  it("fails if is_age_months is not logical", {
    expect_error(anthro_zscores(1, is_age_in_month = "1"), "logical")
    expect_error(anthro_zscores(1, is_age_in_month = logical()), "length")
  })
  it("fails if sex is not numeric or character", {
    expect_error(anthro_zscores(sex = TRUE), "character or numeric")
    expect_error(anthro_zscores(sex = "invalid"), "not valid")
  })
  it("fails if measure has invalid values", {
    expect_error(anthro_zscores(sex = 1, measure = "X"), "measure")
  })
  it("does not compute anything if sex is NA", {
    res <- anthro_zscores(sex = NA_character_, lenhei = 50, age = 50)
    expect_equal(res[["zlen"]], NA_real_)
  })
})

test_that("length for age uses adjusted lenhei", {
  res <- anthro_zscores(sex = 1, age = 987, lenhei = 72.86, measure = "l")
  expect_equal(res[["zlen"]], -6.09)
  expect_equal(res[["flen"]], 1L)
})

test_that("accepts different values for sex", {
  age <- 987
  lenhei <- 72.86
  res1 <- anthro_zscores(sex = 1, age = age, lenhei = lenhei)
  res2 <- anthro_zscores(sex = 2, age = age, lenhei = lenhei)
  expect_equal(
    res1,
    anthro_zscores(sex = "m", age = age, lenhei = lenhei)
  )
  expect_equal(
    res2,
    anthro_zscores(sex = "f", age = age, lenhei = lenhei)
  )
})

test_that("age related indicators are now calculated if age is NA", {
  res <- anthro_zscores(sex = 1, age = NA_real_, lenhei = 72.86)
  expect_equal(NA_real_, res[["zlen"]])
})

test_that("oedema is all 'n' by default", {
  res <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l"
  )
  res2 <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, oedema = "n", measure = "l"
  )
  expect_equal(res, res2)
})

test_that("oedema n = 2 and y = 1", {
  res <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "2"
  )
  res2 <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, oedema = "n", measure = "l"
  )
  expect_equal(res, res2)
  res <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "1"
  )
  res2 <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, oedema = "y", measure = "l"
  )
  expect_equal(res, res2)
})

test_that("oedema can also be numeric", {
  res <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "2"
  )
  res2 <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "n"
  )
  expect_equal(res, res2)
  res <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "1"
  )
  res2 <- anthro_zscores(
    sex = 1, age = 100,
    lenhei = 60, weight = 7, measure = "l", oedema = "y"
  )
  expect_equal(res, res2)
})

test_that("fails if oedema is not n, N, 2, y, Y, 1, NA", {
  expect_silent(anthro_zscores(sex = 1, oedema = "n"))
  expect_silent(anthro_zscores(sex = 1, oedema = "N"))
  expect_silent(anthro_zscores(sex = 1, oedema = "y"))
  expect_silent(anthro_zscores(sex = 1, oedema = "Y"))
  expect_silent(anthro_zscores(sex = 1, oedema = 1))
  expect_silent(anthro_zscores(sex = 1, oedema = 2))
  expect_silent(anthro_zscores(sex = 1, oedema = "1"))
  expect_silent(anthro_zscores(sex = 1, oedema = "2"))
  expect_error(anthro_zscores(sex = 1, oedema = "T"))
})

test_that("fails if sex is not f, F, m, M, 1, 2, NA", {
  expect_silent(anthro_zscores(sex = 1))
  expect_silent(anthro_zscores(sex = 2))
  expect_silent(anthro_zscores(sex = "f"))
  expect_silent(anthro_zscores(sex = "F"))
  expect_silent(anthro_zscores(sex = "m"))
  expect_silent(anthro_zscores(sex = "M"))
  expect_error(anthro_zscores(sex = "T"))
})

test_that("arguments will be recycled", {
  res <- anthro_zscores(
    sex = "f",
    age = c(100, 500),
    is_age_in_month = FALSE,
    weight = 1:3 * 10,
    lenhei = 1:4 * 40,
    measure = rep.int("l", 5),
    headc = 1:6 * 10,
    armc = 1:7 * 10,
    triskin = 1:8 * 10,
    subskin = 1:9 * 10,
    oedema = rep.int("n", 10)
  )
  expect_equal(nrow(res), 10L)
})

test_that("young children with measured standing will not be adjusted", {
  res <- anthro_zscores(
    sex = 1, age = c(8, 9),
    is_age_in_month = TRUE,
    lenhei = 60,
    measure = "h"
  )
  expect_equal(res$clenhei, c(60, 60.7))
  expect_equal(res$zlen, c(-4.81, -5.02), tolerance = 0.01)
  expect_equal(res$cmeasure, c(NA_character_, "h"))
})

test_that("zcores are only computed for children younger to 60 months", {
  res <- anthro_zscores(
    sex = 1,
    age = c(59.9, 60, 60.1),
    is_age_in_month = TRUE,
    lenhei = 80,
    weight = 20,
    armc = 5,
    triskin = 3,
    subskin = 5,
    headc = 5,
    measure = "h"
  )
  expect_true(all(is.na(res[2:3, -1:-4])))
  expect_false(all(is.na(res[1, -1:-4])))
})

test_that("height measurements are used for age 24 months", {
  res <- anthro_zscores(
    sex = 2,
    age = 24,
    is_age_in_month = TRUE,
    lenhei = 77.5
  )
  expect_equivalent(res$zlen, -2.55)
})

test_that("cleaned sex variable is part of the output data.frame", {
  res <- anthro_zscores(
    sex = c(1, 2, "m", "f", NA_character_),
    age = 20,
    is_age_in_month = TRUE,
    lenhei = 60,
    weight = 20,
    measure = "h"
  )
  expect_equal(res$csex, c(1L, 2L, 1L, 2L, NA_integer_))
})

test_that("clenhei takes the measure argument into account correctly", {
  res <- anthro_zscores(
    sex = 2,
    age = 24,
    lenhei = 77.5,
    weight = 8.8,
    is_age_in_month = TRUE,
    measure = c("h", NA_character_)
  )
  expect_equal(res$clenhei, c(77.5, 77.5))
  expect_equal(res$zlen, c(-2.55, -2.55))
})
