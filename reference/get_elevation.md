# Get elevation for a lon/lat pair

Look up elevation for a point location using Natural Resource Canada's
Elevation API:
https://natural-resources.canada.ca/science-and-data/science-and-research/earth-sciences/geography/topographic-information/web-services/elevation-api/17328,
and if outside of Canada, using the USGS Elevation Point Query Service:
https://epqs.nationalmap.gov/v1/docs

## Usage

``` r
get_elevation(lon, lat)
```

## Arguments

- lon:

  Longitude: number between -140 and -53

- lat:

  Latitude: number 41 and 84

## Value

Elevation, in m

## Examples

``` r
get_elevation(-115, 53)
#> [1] 933
```
