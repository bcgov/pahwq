test_that("pb_multi works", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- pb_multi(tuv_results, pahs)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 6)

  expect_equal(res$pah, tolower(pahs))
  expect_equal(
    res$narcotic_benchmark,
    vapply(pahs, narcotic_benchmark, FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$narcotic_cwqg,
    vapply(pahs, narcotic_cwqg, FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$pabs,
    vapply(pahs, \(x) p_abs(tuv_results, x), FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$phototoxic_benchmark,
    vapply(pahs, \(x) phototoxic_benchmark(tuv_results, x), FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$phototoxic_cwqg,
    unname(vapply(pahs, \(x) phototoxic_cwqg(tuv_results, x), FUN.VALUE = numeric(1)))
  )
})

test_that("pb_multi passes on arguments appropriately", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- pb_multi(tuv_results, pahs)

  # time_muliplier - passed to Pabs
  res2 <- pb_multi(tuv_results, pahs, time_multiplier = 1)
  expect_equal(res2$pabs * 2, res$pabs)
  expect_equal(res2$narcotic_benchmark, res$narcotic_benchmark)
  expect_true(all(res2$phototoxic_benchmark > res$phototoxic_benchmark))
})

test_that("pb_multi errors correctly", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )

  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  expect_snapshot(pb_multi(5, pahs), error = TRUE)
  expect_snapshot(pb_multi(tuv_results, c(pahs, "foo")), error = TRUE)
})
