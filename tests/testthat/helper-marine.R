# The first sf reprojection and date conversion set environment variables,
# which the state inspector flags
invisible(as.Date("2024-01-01"))
invisible(sf::st_transform(sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326), 3979))

marine_pt <- function(area) {
  poly <- marine_kd_polygons[marine_kd_polygons$area == area, ]
  pt <- sf::st_transform(sf::st_point_on_surface(sf::st_geometry(poly)), 4326)
  c(lat = sf::st_coordinates(pt)[[2]], lon = sf::st_coordinates(pt)[[1]])
}
