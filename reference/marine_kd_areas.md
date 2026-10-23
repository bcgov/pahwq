# Marine areas used for the light attenuation models

Marine areas used for the light attenuation models

## Usage

``` r
marine_kd_areas()
```

## Value

An `sf` data frame with one row per area (ecoregion and clear/turbid
water type), with columns `area`, `ecoregion`, `water_type`, and
`geometry`, in WGS84 (EPSG:4326). The polygons are simplified.

## Examples

``` r
marine_kd_areas()
#> Simple feature collection with 21 features and 3 fields
#> Geometry type: GEOMETRY
#> Dimension:     XY
#> Bounding box:  xmin: -141 ymin: 40.04369 xmax: -47.69796 ymax: 86.45277
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                                   area                     ecoregion water_type
#> 1             Arctic_Archipelago_Clear            Arctic Archipelago      clear
#> 2            Arctic_Archipelago_Turbid            Arctic Archipelago     turbid
#> 3                   Arctic_Basin_Clear                  Arctic Basin      clear
#> 4                Eastern_Arctic_Turbid                Eastern Arctic     turbid
#> 5                 Eastern_Arctic_Clear                Eastern Arctic      clear
#> 6        Gulf_of_Saint_Lawrence_Turbid        Gulf of Saint Lawrence     turbid
#> 7         Gulf_of_Saint_Lawrence_Clear        Gulf of Saint Lawrence      clear
#> 8             Hudson_Bay_Complex_Clear            Hudson Bay Complex      clear
#> 9            Hudson_Bay_Complex_Turbid            Hudson Bay Complex     turbid
#> 10 Newfoundland-Labrador_Shelves_Clear Newfoundland-Labrador Shelves      clear
#>                          geometry
#> 1  MULTIPOLYGON (((-120.4835 7...
#> 2  MULTIPOLYGON (((-94.41671 7...
#> 3  MULTIPOLYGON (((-136.7957 7...
#> 4  MULTIPOLYGON (((-88.02707 6...
#> 5  MULTIPOLYGON (((-85.55513 7...
#> 6  MULTIPOLYGON (((-59.81295 4...
#> 7  POLYGON ((-59.21411 47.5893...
#> 8  MULTIPOLYGON (((-65.75826 6...
#> 9  MULTIPOLYGON (((-91.96249 6...
#> 10 POLYGON ((-61.99789 57.4350...
```
