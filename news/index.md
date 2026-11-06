# Changelog

## pacwq 0.7.0

- The package is now called pacwq (previously pahwq): use
  [`library(pacwq)`](https://github.com/bcgov/pahwq), and set the
  `pacwq.tuv_data_dir` option instead of `pahwq.tuv_data_dir`. TUV files
  are now stored in the `pacwq` user data directory, so any existing
  `pahwq` directory can be deleted. The GitHub repository is still
  `bcgov/pahwq`, so installation with `pak::pak("bcgov/pahwq")` and the
  website URL are unchanged.
- Documentation and error messages now use “polycyclic aromatic
  compounds (PACs)” instead of “polycyclic aromatic hydrocarbons
  (PAHs)”.
- The guideline tables in `inst/doc-guideline-lookup/` are now
  `PAC-DOC_freshwater-guidelines.csv` and `PAC_marine-guidelines.csv`.
- [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md),
  [`p_abs_single()`](https://bcgov.github.io/pahwq/reference/p_abs_single.md),
  [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md),
  [`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md),
  [`phototoxic_cwqg()`](https://bcgov.github.io/pahwq/reference/phototoxic_cwqg.md)
  and
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md):
  the `pah` argument is now `pac` (`pahs` is now `pacs` in
  [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md)),
  and the `pah` column returned by
  [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md)
  and
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)
  is now `pac`. This is a breaking change for code that uses the old
  names.
