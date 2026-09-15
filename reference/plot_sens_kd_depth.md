# Make a heatmap of the sensitivity analysis performed by [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)

Make a heatmap of the sensitivity analysis performed by
[`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)

## Usage

``` r
plot_sens_kd_depth(x, interactive = FALSE, ...)
```

## Arguments

- x:

  A data.frame, the output of
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)

- interactive:

  Whether to make the plot interactive

- ...:

  parameters passed on to
  [`ggiraph::girafe()`](https://davidgohel.github.io/ggiraph/reference/girafe.html)
  to control the interactive plot if `interactive = TRUE`.

## Value

a `ggplot2` object if `interactive = FALSE`, a `girafe` interactive plot
object if `interactive = TRUE`

## Examples

``` r
if (FALSE) { # \dontrun{
out <- sens_kd_depth(
  "Anthracene",
  lat = 52,
  lon = -113,
  DOC = 3:8,
  depth_m = c(0.25, 0.5, 0.75, 1),
  date = c("2023-07-01", "2023-08-01")
)

plot_sens_kd_depth(out)

out2 <- sens_kd_depth(
  "benzo(a)pyrene",
  lat = 57,
  lon = -120,
  Kd_ref = seq(10, 50, by = 10),
  depth_m = c(0.25, 0.5, 0.75, 1),
  date = c("2023-07-01", "2023-08-01")
)

plot_sens_kd_depth(out2, interactive = TRUE)
} # }
```
