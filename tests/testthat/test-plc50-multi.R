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
  pacs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- pb_multi(tuv_results, pacs)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 7)

  expect_equal(res$pac_id, tolower(pacs))
  expect_equal(res$pac_name, match_pac(pacs))
  expect_equal(
    res$narcotic_benchmark,
    vapply(pacs, narcotic_benchmark, FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$narcotic_cwqg,
    vapply(pacs, narcotic_cwqg, FUN.VALUE = numeric(1), USE.NAMES = FALSE)
  )
  expect_equal(
    res$pabs,
    vapply(
      pacs,
      \(x) p_abs(tuv_results, x),
      FUN.VALUE = numeric(1),
      USE.NAMES = FALSE
    )
  )
  expect_equal(
    res$phototoxic_benchmark,
    vapply(
      pacs,
      \(x) phototoxic_benchmark(tuv_results, x),
      FUN.VALUE = numeric(1),
      USE.NAMES = FALSE
    )
  )
  expect_equal(
    res$phototoxic_cwqg,
    unname(vapply(
      pacs,
      \(x) phototoxic_cwqg(tuv_results, x),
      FUN.VALUE = numeric(1)
    ))
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
  pacs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- pb_multi(tuv_results, pacs)

  # time_muliplier - passed to Pabs
  res2 <- pb_multi(tuv_results, pacs, time_multiplier = 1)
  expect_equal(res2$pabs * 2, res$pabs)
  expect_equal(res2$narcotic_benchmark, res$narcotic_benchmark)
  expect_true(all(res2$phototoxic_benchmark > res$phototoxic_benchmark))
})

test_that("pb_multi uses acr", {
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
  pacs <- c("Anthracene", "benzo(a)pyrene")
  res <- pb_multi(tuv_results, pacs)
  res2 <- pb_multi(tuv_results, pacs, acr = 5)

  expect_equal(res2$phototoxic_benchmark, res$phototoxic_benchmark)
  expect_equal(res2$phototoxic_cwqg, res$phototoxic_benchmark / 5)
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

  pacs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  expect_snapshot(pb_multi(5, pacs), error = TRUE)
  expect_snapshot(pb_multi(tuv_results, c(pacs, "foo")), error = TRUE)
})
