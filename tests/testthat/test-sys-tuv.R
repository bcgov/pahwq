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
      elev_m = 342,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE
    ))
  )
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21"
  )
  expect_true(file.exists(file.path(dir, "AQUA", "inp_aq")))
})

test_that("set_tuv_aq_params() works with marine", {
  dir <- local_tuv_dir()
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.15085,
      lon = -125.91427,
      elev_m = 0,
      aq_env = "marine",
      date = "2023-06-21",
      write = FALSE
    ))
  )
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.15085,
    lon = -125.91427,
    elev_m = 0,
    aq_env = "marine",
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

test_that("depth_m defaults to 1 cm", {
  local_tuv_dir()
  opts <- set_tuv_aq_params(
    lat = 49.6,
    lon = -119.6,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    write = FALSE
  )
  expect_match(opts[2], "^0.01 ")
})

test_that("set_tuv_aq_params validates depth_m", {
  local_tuv_dir()
  expect_snapshot(
    set_tuv_aq_params(depth_m = 0, DOC = 5, date = "2023-06-21"),
    error = TRUE
  )
})

test_that("Sk defaults to 0.018 in freshwater and can be set", {
  local_tuv_dir()
  args <- list(
    lat = 49.6,
    lon = -119.6,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    write = FALSE
  )
  expect_match(do.call(set_tuv_aq_params, args)[1], "^\\S+ 0.018 305 ")
  expect_match(
    do.call(set_tuv_aq_params, c(args, Sk = 0.02))[1],
    "^\\S+ 0.02 305 "
  )
})

test_that("set_tuv_aq_params validates Sk", {
  local_tuv_dir()
  expect_snapshot(
    set_tuv_aq_params(DOC = 5, date = "2023-06-21", Sk = -0.01),
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
      elev_m = 342,
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
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  expect_true(file.exists(file.path(dir, "AQUA", "out_irrad_y")))
})

test_that("get_tuv_results works", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
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

test_that("get_tuv_results works with marine", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.15085,
    lon = -125.91427,
    elev_m = 0,
    aq_env = "marine",
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "tuv_results")
  expect_s3_class(res, "data.frame")
  expect_type(attr(res, "inp_aq"), "character")

  # Get the parameters used for the model run
  expect_type(tuv_run_params(res), "character")
  expect_contains(
    names(tuv_run_params(res)),
    c("marine area", "ecoregion", "water type", "season")
  )
  expect_identical(
    tuv_run_params(res)[["marine area"]],
    "Southern_Shelf_Turbid"
  )

  kd_model <- attr(res, "kd_model")
  model <- marine_kd_model(49.15085, -125.91427, "2023-06-21")
  expect_s3_class(kd_model, "data.frame")
  expect_equal(
    kd_model,
    model[names(kd_model)],
    tolerance = 1e-5,
    ignore_attr = "row.names"
  )
})

test_that("the marine kd_model records overrides and isn't wrapped", {
  dir <- local_tuv_dir()
  withr::local_options(width = 20)
  pt <- marine_pt("Newfoundland-Labrador_Shelves_Turbid")
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = pt[["lat"]],
    lon = pt[["lon"]],
    elev_m = 0,
    aq_env = "marine",
    date = "2023-06-21",
    Kd_ref = 2,
    Kd_wvl = 400,
    Sk = 0.01
  )
  kd_model <- read_kd_model(dir)
  expect_equal(kd_model$ecoregion, "Newfoundland-Labrador Shelves")
  expect_equal(kd_model$area, "Newfoundland-Labrador_Shelves_Turbid")
  expect_equal(kd_model$Kd_ref, 2)
  expect_equal(kd_model$Kd_wvl, 400)
  expect_equal(kd_model$Sk, 0.01)
  expect_equal(kd_model$nodata, FALSE)
})

test_that("marine requires lat and lon", {
  local_tuv_dir()
  expect_snapshot(
    set_tuv_aq_params(depth_m = 1, aq_env = "marine", date = "2023-06-21"),
    error = TRUE
  )
})

test_that("set_tuv_aq_params errors on NA date", {
  local_tuv_dir()
  expect_snapshot(
    set_tuv_aq_params(depth_m = 1, DOC = 5, date = NA),
    error = TRUE
  )
})

test_that("correct combinations of Kd_ref, Kd_wvl, DOC, marine", {
  dir <- local_tuv_dir()
  # DOC only is tested above

  # Kd_ref only (ok, ref_wvl will be 305)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_m = 342,
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
      elev_m = 342,
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
      elev_m = 342,
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
      elev_m = 342,
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
      elev_m = 342,
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
      elev_m = 342,
      Kd_wvl = 280,
      date = "2023-06-21",
      write = FALSE
    )),
    error = TRUE
  )
  # Marine with DOC (error)
  expect_snapshot(
    print(set_tuv_aq_params(
      depth_m = 0.25,
      lat = 49.15085,
      lon = -125.91427,
      elev_m = 0,
      DOC = 5,
      aq_env = "marine",
      date = "2023-06-21",
      write = FALSE
    )),
    error = TRUE
  )
})

test_that("marine elevation defaults to 0", {
  local_tuv_dir()
  local_mocked_bindings(get_elevation = function(...) stop("not called"))
  pt <- marine_pt("Newfoundland-Labrador_Shelves_Turbid")
  opts <- set_tuv_aq_params(
    lat = pt[["lat"]],
    lon = pt[["lon"]],
    aq_env = "marine",
    date = "2023-06-21",
    write = FALSE
  )
  expect_match(opts[5], "^0 ")
})

test_that("marine overrides are applied", {
  local_tuv_dir()
  args <- list(
    depth_m = 0.25,
    lat = 49.15085,
    lon = -125.91427,
    elev_m = 0,
    aq_env = "marine",
    date = "2023-06-21",
    write = FALSE
  )
  model <- marine_kd_model(49.15085, -125.91427, "2023-06-21")
  parse_kd <- function(x) as.numeric(strsplit(x[[1]], "\\s+")[[1]][1:3])

  expect_equal(
    parse_kd(do.call(set_tuv_aq_params, args)),
    c(model$Kd_ref, model$Sk, 375),
    tolerance = 1e-5
  )

  m305 <- marine_kd_model(49.15085, -125.91427, "2023-06-21", Kd_wvl = 305)
  expect_equal(
    parse_kd(do.call(set_tuv_aq_params, c(args, Kd_wvl = 305))),
    c(m305$Kd_ref, m305$Sk, 305),
    tolerance = 1e-5
  )
  expect_snapshot(do.call(set_tuv_aq_params, c(args, Kd_ref = 2)))
  expect_equal(
    parse_kd(suppressMessages(do.call(
      set_tuv_aq_params,
      c(args, Kd_ref = 2)
    ))),
    c(2, model$Sk, 375),
    tolerance = 1e-5
  )
  expect_equal(
    parse_kd(do.call(set_tuv_aq_params, c(args, Sk = 0.01))),
    c(model$Kd_ref, 0.01, 375),
    tolerance = 1e-5
  )
  expect_equal(
    parse_kd(do.call(
      set_tuv_aq_params,
      c(args, Kd_ref = 2, Kd_wvl = 400, Sk = 0.01)
    )),
    c(2, 0.01, 400)
  )
})

test_that("marine errors when model has no data unless overridden", {
  local_tuv_dir()
  pt <- marine_pt("Western_Arctic_Clear")
  args <- list(
    depth_m = 0.25,
    lat = pt[["lat"]],
    lon = pt[["lon"]],
    elev_m = 0,
    aq_env = "marine",
    date = "2023-01-15",
    write = FALSE
  )
  expect_snapshot(do.call(set_tuv_aq_params, args), error = TRUE)
  expect_snapshot(do.call(set_tuv_aq_params, c(args, Kd_ref = 1)), error = TRUE)
  expect_snapshot(
    invisible(do.call(set_tuv_aq_params, c(args, Kd_ref = 1, Sk = 0.01)))
  )
})

test_that("marine warns when the area or time flags are set", {
  local_tuv_dir()
  pt <- marine_pt("Arctic_Archipelago_Clear")
  expect_snapshot(
    invisible(set_tuv_aq_params(
      depth_m = 0.25,
      lat = pt[["lat"]],
      lon = pt[["lon"]],
      elev_m = 0,
      aq_env = "marine",
      date = "2023-04-15",
      write = FALSE
    ))
  )

  # VPFTIME only
  pt <- marine_pt("Western_Arctic_Clear")
  expect_snapshot(
    invisible(set_tuv_aq_params(
      depth_m = 0.25,
      lat = pt[["lat"]],
      lon = pt[["lon"]],
      elev_m = 0,
      aq_env = "marine",
      date = "2023-04-15",
      write = FALSE
    ))
  )
})

test_that("TUV output Kd matches the marine model", {
  local_tuv_dir()
  res <- tuv(
    depth_m = 0.25,
    lat = 49.15085,
    lon = -125.91427,
    elev_m = 0,
    aq_env = "marine",
    date = "2023-06-21",
    quiet = TRUE
  )
  # Southern_Shelf_Turbid summer; TUV reports Kd to 3 significant digits
  expected <- signif(10^(1.353683 - 0.003802664 * res$wl), 3)
  expect_equal(res$Kd_lambda, expected)
})

test_that("marine model sidecar is removed by a freshwater run", {
  dir <- local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.15085,
    lon = -125.91427,
    elev_m = 0,
    aq_env = "marine",
    date = "2023-06-21"
  )
  expect_in("pahwq_kd_model.dcf", list.files(file.path(dir, "AQUA")))
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21"
  )
  expect_disjoint("pahwq_kd_model.dcf", list.files(file.path(dir, "AQUA")))
})
