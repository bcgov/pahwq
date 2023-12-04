test_that("tuv executable gets copied to the right place on load", {
  dir <- local_tuv_dir()
  expect_true(file.exists(file.path(
    dir,
    tuv_cmd()
  )))
})

test_that("set_tuv_aq_params() works with minimal specifications", {
  dir <- local_tuv_dir()
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE
    ))
  )
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  expect_true(file.exists(file.path(dir, "AQUA", "inp_aq")))
})

test_that("set_tuv_aq_params errors without required arguments", {
  local_tuv_dir()
  expect_snapshot(
    set_tuv_aq_params(),
    error = TRUE
  )
  expect_snapshot(
    set_tuv_aq_params(date = "2023-10-24"),
    error = TRUE
  )
  expect_snapshot(
    set_tuv_aq_params(date = "2023-10-24", DOC = 5),
    error = TRUE
  )
})

test_that("set_tuv_aq_params works with o3_tc and tauaer set to 'default'", {
  local_tuv_dir()
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      DOC = 5,
      date = "2023-06-21",
      o3_tc = "default",
      tauaer = "default",
      write = FALSE
    ))
  )
})

test_that("run_tuv works", {
  dir <- local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  expect_true(all(file.exists(file.path(dir, "AQUA", tuv_out_files()))))
})

test_that("get_tuv_results works", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "tuv_results")
  expect_s3_class(res, "data.frame")
  expect_type(attr(res, "inp_aq"), "character")

  # Get the parameters used for the model run
  expect_type(tuv_run_params(res), "character")
  expect_length(tuv_run_params(res), 32)
})

test_that("correct combinations of Kd_ref, Kd_wvl, DOC", {
  dir <- local_tuv_dir()
  # DOC only is tested above

  # Kd_ref only (ok, ref_wvl will be 305)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_ref = 40,
      date = "2023-06-21",
      write = FALSE
    ))
  )
  # Kd_ref + Kd_wvl
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_ref = 40,
      Kd_wvl = 280,
      date = "2023-06-21",
      write = FALSE
    ))
  )
  # Kd_wvl + DOC (Kd_wvl should be ignored, and be 305 in the params file)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_wvl = 280,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE
    ))
  )
  # Kd_ref + DOC (error)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_ref = 40,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE
    )),
    error = TRUE
  )
  # Kd_ref + Kd_wvl + DOC (error)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_ref = 40,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE
    )),
    error = TRUE
  )
  # Kd_wvl only (error)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      Kd_wvl = 280,
      date = "2023-06-21",
      write = FALSE
    )),
    error = TRUE
  )
})
