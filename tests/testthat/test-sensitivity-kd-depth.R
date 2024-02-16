test_that("sens_kd_depth works", {
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

  top_row_tuv <- tuv(
    lat = 52,
    lon = -113,
    elev_m = 500,
    DOC = 5,
    depth_m = 0.5,
    date = "2023-06-01"
  )
  top_row_plc <- plc50(top_row_tuv, "Anthracene")
  expect_equal(out$plc50[1], top_row_plc)
})
