test_that("tu_hi_calc() divides by each guideline, sums and prints", {
  guidelines <- data.frame(
    narcotic_benchmark = c(2, 10, 1),
    narcotic_cwqg = c(4, 20, 1),
    pabs = c(1, 2, 1),
    phototoxic_benchmark = c(5, 25, 1),
    phototoxic_cwqg = c(8, 40, 1)
  )

  res <- tu_hi_calc(c("a", "b", "c"), c(1, 10, NA), guidelines)

  expect_equal(attr(res, "pacs")$tu_narcotic, c(0.5, 1, 0))
  expect_equal(res$tu_narcotic, 1.5)
  expect_equal(res$tu_phototoxic, 0.6)
  expect_equal(res$hi_narcotic, 0.75)
  expect_equal(res$hi_phototoxic, 0.375)
  expect_snapshot(res)
})

test_that("tu_hi() checks its inputs", {
  tuv_results <- structure(data.frame(), class = c("tuv_results", "data.frame"))

  expect_snapshot(error = TRUE, {
    tu_hi(data.frame(), data.frame())
    tu_hi(list(), tuv_results)
    tu_hi(data.frame(pac = "pyrene"), tuv_results)
    tu_hi(data.frame(pac = 1, concentration_ug_L = 1), tuv_results)
    tu_hi(data.frame(pac = "pyrene", concentration_ug_L = "1"), tuv_results)
    tu_hi(data.frame(pac = "pyrene", concentration_ug_L = -1), tuv_results)
    tu_hi(data.frame(pac = "not a pac", concentration_ug_L = 1), tuv_results) |>
      suppressWarnings()
    tu_hi(
      data.frame(
        pac = c("C1-Phenanthrenes/Anthracenes", "c1-anthracenes"),
        concentration_ug_L = 1
      ),
      tuv_results
    )
  })
})

test_that("tu_hi() matches names and uses guidelines from the TUV results", {
  local_tuv_dir()
  tuv_results <- tuv(
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  concentrations <- data.frame(
    pac = c("Benzo[a]pyrene", "C1-Phenanthrenes/Anthracenes", "not a pac"),
    concentration_ug_L = c(0.5, 2, 1)
  )

  expect_snapshot(
    res <- suppressMessages(tu_hi(concentrations, tuv_results, 1))
  )

  guidelines <- suppressMessages(
    pb_multi(tuv_results, c("benzo(a)pyrene", "c1-phenanthrenes"), 1)
  )

  expect_equal(
    attr(res, "pacs")$pac,
    c("Benzo(a)pyrene", "C1-Phenanthrenes/Anthracenes")
  )
  expect_equal(
    res$tu_phototoxic,
    sum(c(0.5, 2) / guidelines$phototoxic_benchmark)
  )
})

test_that("tu_hi uses acr", {
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
  concentrations <- data.frame(pac = "Anthracene", concentration_ug_L = 1)

  res <- tu_hi(concentrations, tuv_results)
  res2 <- tu_hi(concentrations, tuv_results, acr = default_acr() * 2)

  expect_equal(res2$tu_phototoxic, res$tu_phototoxic)
  expect_equal(res2$hi_phototoxic, res$hi_phototoxic * 2)
})
