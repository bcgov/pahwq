test_that("sens_kd_depth works with DOC", {
  local_tuv_dir()
  out <- sens_kd_depth(
    pah = "Anthracene",
    lat = 52,
    lon = -113,
    elev_m = 500,
    DOC = 5:6,
    depth_m = c(0.5, 1),
    date = c("2023-06-01", "2023-07-01")
  )

  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 8)
  expect_named(out, c("lat", "lon", "elev_m", "depth_m", "date", "DOC", "tuv_res",
                      "pah", "narcotic_benchmark", "pabs", "phototoxic_benchmark"))

  top_row_tuv <- tuv(
    lat = 52,
    lon = -113,
    elev_m = 500,
    DOC = 5,
    depth_m = 0.5,
    date = "2023-06-01"
  )
  top_row_plc <- phototoxic_benchmark(top_row_tuv, "Anthracene")
  expect_equal(out$phototoxic_benchmark[1], top_row_plc)

  bottom_row_tuv <- tuv(
    lat = 52,
    lon = -113,
    elev_m = 500,
    DOC = 6,
    depth_m = 1,
    date = "2023-07-01"
  )
  bottom_row_plc <- phototoxic_benchmark(bottom_row_tuv, "Anthracene")
  expect_equal(out$phototoxic_benchmark[8], bottom_row_plc)
})

test_that("sens_kd_depth works with Kd_ref", {
  local_tuv_dir()
  out <- sens_kd_depth(
    pah = "Anthracene",
    lat = 52,
    lon = -113,
    elev_m = 500,
    Kd_ref = 5:6,
    depth_m = c(0.5, 1),
    date = c("2023-06-01", "2023-07-01")
  )

  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 8)
  expect_named(out, c("lat", "lon", "elev_m", "depth_m", "date", "Kd_ref", "tuv_res",
                      "pah", "narcotic_benchmark", "pabs", "phototoxic_benchmark"))

  top_row_tuv <- tuv(
    lat = 52,
    lon = -113,
    elev_m = 500,
    Kd_ref = 5,
    depth_m = 0.5,
    date = "2023-06-01",
    quiet = TRUE
  )
  top_row_plc <- phototoxic_benchmark(top_row_tuv, "Anthracene")
  expect_equal(out$phototoxic_benchmark[1], top_row_plc)

  bottom_row_tuv <- tuv(
    lat = 52,
    lon = -113,
    elev_m = 500,
    Kd_ref = 6,
    depth_m = 1,
    date = "2023-07-01",
    quiet = TRUE
  )
  bottom_row_plc <- phototoxic_benchmark(bottom_row_tuv, "Anthracene")
  expect_equal(out$phototoxic_benchmark[8], bottom_row_plc)
})

test_that("plot works", {
  local_tuv_dir()
  out <- sens_kd_depth(
    pah = "Anthracene",
    lat = 52,
    lon = -113,
    elev_m = 500,
    DOC = 5:6,
    depth_m = c(0.5, 1),
    date = c("2023-06-01", "2023-07-01")
  )

  expect_s3_class(plot_sens_kd_depth(out), "ggplot")
  expect_s3_class(plot_sens_kd_depth(out, interactive = TRUE), "girafe")
})
