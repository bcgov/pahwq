test_that("a point in each area maps to that area", {
  areas <- marine_kd_polygons$area
  expect_length(areas, 21)
  res <- vapply(
    areas,
    function(a) {
      pt <- marine_pt(a)
      marine_kd_area(pt[["lat"]], pt[["lon"]])$area
    },
    character(1),
    USE.NAMES = FALSE
  )
  expect_equal(res, areas)
})

test_that("known coastal points map to expected areas", {
  expect_equal(
    marine_kd_model(49.15085, -125.91427, "2024-06-21")$area,
    "Southern_Shelf_Turbid"
  )
  expect_equal(
    marine_kd_model(49.3, -123.3, "2024-06-21")$area,
    "Strait_of_Georgia_Turbid"
  )
  expect_equal(
    marine_kd_model(50.5, -129.5, "2024-06-21")$area,
    "Offshore_Pacific_Clear"
  )
})

test_that("marine_kd_model() uses 375 nm as the default reference wavelength", {
  res <- marine_kd_model(49.15085, -125.91427, "2024-06-21")
  expect_equal(res$Kd_wvl, 375)
  expect_equal(res$Kd_ref, 10^(res$intercept + res$slope * 375))
})

test_that("met_season() handles boundaries", {
  d <- as.Date(c(
    "2023-02-28",
    "2024-02-29",
    "2024-03-01",
    "2024-05-31",
    "2024-06-01",
    "2024-08-31",
    "2024-09-01",
    "2024-11-30",
    "2024-12-01",
    "2024-12-31",
    "2024-01-01"
  ))
  expect_equal(
    met_season(d),
    c(
      "winter",
      "winter",
      "spring",
      "spring",
      "summer",
      "summer",
      "fall",
      "fall",
      "winter",
      "winter",
      "winter"
    )
  )
})

test_that("nearby points use the nearest area with a message", {
  expect_snapshot(res <- marine_kd_model(49.0, -123.2, "2024-06-21"))
  expect_equal(res$area, "Strait_of_Georgia_Turbid")
  expect_gt(res$dist_km, 0)
  expect_lte(res$dist_km, 25)
})

test_that("max_dist_km sets the tolerance for the nearest area", {
  expect_snapshot(marine_kd_area(49.0, -123.2, max_dist_km = 0.1), error = TRUE)
  expect_equal(
    suppressMessages(marine_kd_area(49.0, -123.2, max_dist_km = 0.5))$area,
    "Strait_of_Georgia_Turbid"
  )
})

test_that("distant points error", {
  expect_snapshot(marine_kd_model(45, -40, "2024-06-21"), error = TRUE)
  expect_snapshot(marine_kd_model(45, -100, "2024-06-21"), error = TRUE)
})

test_that("marine_kd_model() returns NA parameters for NODATA rows", {
  pt <- marine_pt("Western_Arctic_Clear")
  res <- marine_kd_model(pt[["lat"]], pt[["lon"]], "2024-01-15")
  expect_identical(res$nodata, TRUE)
  expect_all_true(is.na(c(res$Kd_ref, res$Sk, res$slope)))
})

test_that("marine_kd_model() is vectorised", {
  res <- marine_kd_model(
    c(49.15085, 50.5),
    c(-125.91427, -129.5),
    c("2024-06-21", "2024-12-21")
  )
  expect_shape(res, nrow = 2)
  expect_equal(res$season, c("summer", "winter"))
})

test_that("marine_kd_params() gives the same curve for any Kd_wvl", {
  model <- marine_kd_models[
    marine_kd_models$area == "Southern_Shelf_Turbid" &
      marine_kd_models$season == "summer",
  ]
  wvl <- seq(280, 500, by = 20)
  curve <- function(ref) {
    p <- marine_kd_params(model, ref)
    kd_calc(p$Kd_ref, p$Kd_wvl, p$Sk, wvl, 0, digits = NULL)
  }
  expect_equal(curve(375), curve(305))
  expect_equal(curve(490), curve(305))
  expect_equal(unname(curve(305)), 10^(model$intercept + model$slope * wvl))
})

test_that("Kd(490) is plausible for all models with data", {
  m <- marine_kd_models[!marine_kd_models$nodata, ]
  kd490 <- 10^(m$intercept + m$slope * 490)
  expect_gt(min(kd490), 0.01)
  expect_lt(max(kd490), 2)
})

test_that("marine_kd_model() errors on invalid inputs", {
  expect_snapshot(marine_kd_model(49, -125), error = TRUE)
  expect_snapshot(marine_kd_model(49, -125, NA), error = TRUE)
  expect_snapshot(marine_kd_model(NA, -125, "2024-06-21"), error = TRUE)
  expect_snapshot(
    marine_kd_model(49, -125, "2024-06-21", Kd_wvl = "a"),
    error = TRUE
  )
})

test_that("marine_kd_models is complete", {
  expect_shape(marine_kd_models, nrow = 84)
  expect_setequal(marine_kd_models$area, marine_kd_polygons$area)
})

test_that("marine_kd_areas() returns sf polygons", {
  areas <- marine_kd_areas()
  expect_s3_class(areas, "sf")
  expect_equal(sf::st_crs(areas)$epsg, 4326L)
  expect_shape(areas, nrow = nrow(marine_kd_polygons))
  expect_named(areas, c("area", "ecoregion", "water_type", "geometry"))
})
