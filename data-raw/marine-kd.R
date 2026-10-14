# Marine Kd models and ecoregion polygons (ECCC, 2026).
# Requires sf and rmapshaper (rmapshaper is not a package dependency).
library(sf)

kd_dir <- "data-raw/marine-kd"
shp_dir <- file.path(tempdir(), "marine-kd-shp")
unzip(
  file.path(kd_dir, "Kd_TurbidClearEcoregions_20260706.zip"),
  exdir = shp_dir
)

# Polygons are stored in EPSG:3979 (planar), because the source geometries are
# not valid under s2. At keep = 0.1, 0.3% of random points inside the original
# polygons land in a different area or none (386 KB compressed).
old_s2 <- sf_use_s2(FALSE)
marine_kd_polygons <- list.files(shp_dir, "\\.shp$", full.names = TRUE) |>
  sf::read_sf() |>
  sf::st_make_valid() |>
  sf::st_transform(3979) |>
  sf::st_make_valid() |>
  rmapshaper::ms_simplify(keep = 0.1, keep_shapes = TRUE) |>
  sf::st_make_valid()
sf_use_s2(old_s2)

stopifnot(all(sf::st_is_valid(marine_kd_polygons)))

parse_area <- function(x) {
  water_type <- tolower(sub(".*_(Clear|Turbid)$", "\\1", x))
  ecoregion <- gsub("_", " ", sub("_(Clear|Turbid)$", "", x))
  data.frame(
    area = x,
    ecoregion = ecoregion,
    water_type = water_type
  )
}

area_meta <- parse_area(marine_kd_polygons$NAME)

marine_kd_polygons <- sf::st_sf(
  area_meta,
  geometry = sf::st_geometry(marine_kd_polygons)
)

marine_kd_models <- readr::read_csv(
  file.path(kd_dir, "Kd_ModelData_20260706.csv"),
  col_types = readr::cols_only(
    NAME = readr::col_character(),
    SEASON = readr::col_character(),
    SLOPE = readr::col_double(),
    Y_INTERCEPT = readr::col_double(),
    R2 = readr::col_double(),
    NODATA_FL = readr::col_logical(),
    PEAK_FL = readr::col_logical(),
    VPFAREA_FL = readr::col_logical(),
    VPFTIME_FL = readr::col_logical(),
    POS_PX_ARE = readr::col_double(),
    TOT_PX_ARE = readr::col_double(),
    POS_PX_TIM = readr::col_double(),
    TOT_PX_TIM = readr::col_double()
  )
) |>
  dplyr::rename_with(\(x) gsub("(_fl)$|(^y_)", "", tolower(x))) |>
  dplyr::rename(
    area = name,
    vpf_area = vpfarea,
    vpf_time = vpftime,
    px_pos_area = pos_px_are,
    px_tot_area = tot_px_are,
    px_pos_time = pos_px_tim,
    px_tot_time = tot_px_tim
  ) |>
  dplyr::mutate(season = tolower(season)) |>
  dplyr::left_join(area_meta, by = c("area" = "area")) |>
  dplyr::select(
    area,
    ecoregion,
    water_type,
    season,
    dplyr::everything()
  )

stopifnot(
  nrow(marine_kd_models) == 84,
  !anyDuplicated(marine_kd_models[c("area", "season")]),
  setequal(unique(marine_kd_models$area), marine_kd_polygons$area),
  nrow(marine_kd_polygons) == 21,
  all(is.na(marine_kd_models$slope) == marine_kd_models$nodata)
)
