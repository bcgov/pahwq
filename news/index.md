# Changelog

## pacwq 0.9.0

- [`plot_sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/plot_sens_kd_depth.md)
  now uses the short-term guideline names instead of “benchmark” in its
  title, legend, caption and tooltips, and the typo in the caption is
  fixed. It now requires the new column names from
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md).
  Interactive plots now wrap the title and caption instead of running
  off the plot, and the legend title is wrapped in all plots.
- [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md):
  the `narcotic_benchmark` and `phototoxic_benchmark` columns are now
  `short_term_narcotic_guideline` and `short_term_phototoxic_guideline`,
  which match the guideline tables. This is a breaking change for code
  that uses the old names.

## pacwq 0.8.1

- [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md) and
  functions that use it, such as
  [`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md),
  now give an error when the TUV wavelengths aren’t whole numbers, as
  happens with most values of `wvl_steps` other than the default. These
  wavelengths have no absorption spectrum and were silently dropped,
  which understated Pabs (by about 90% for anthracene with
  `wvl_steps = 111`).
- [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md) and
  functions that use it now give an error for TUV results with one time
  step (`tsteps = 1`), rather than returning `-Inf`.
- [`plot_sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/plot_sens_kd_depth.md)
  now compares the narcotic and phototoxic benchmarks of each square
  when greying out squares with no phototoxic effect. It was dividing by
  the mean of the whole column, so the wrong squares could be greyed
  out.
- [`run_tuv()`](https://bcgov.github.io/pahwq/reference/run_tuv.md) and
  [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) now give an
  error if the TUV program can’t be run or fails, and
  [`run_tuv()`](https://bcgov.github.io/pahwq/reference/run_tuv.md)
  deletes output from earlier runs before starting. Previously
  [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) could return
  the results of an earlier run after a failure, with the parameters of
  the new one.

## pacwq 0.8.0

- The guideline tables in `inst/doc-guideline-lookup/` have new column
  names (`chemical` is now `pac_name`, and the guideline columns are now
  `short_term_narcotic_guideline`, `long_term_narcotic_guideline`,
  `short_term_phototoxic_guideline` and
  `long_term_phototoxic_guideline`), and now have one row per PAC, so
  homologue groups are no longer split by parent. Regenerating the
  tables also changed 23 freshwater values by one unit in the last
  significant figure (at most 0.53%), and no marine values. Homologue
  groups now use their group name, and four single-PAC names changed
  (e.g., `Benzo(Ghi)Perylene` is now `Benzo(g,h,i)perylene`).
  [`match_pac()`](https://bcgov.github.io/pahwq/reference/match_pac.md)
  recognises all of the old names.
- [`narcotic_benchmark()`](https://bcgov.github.io/pahwq/reference/narcotic_benchmark.md),
  [`narcotic_cwqg()`](https://bcgov.github.io/pahwq/reference/narcotic_cwqg.md),
  [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md),
  [`p_abs_single()`](https://bcgov.github.io/pahwq/reference/p_abs_single.md),
  [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md),
  [`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md),
  [`phototoxic_cwqg()`](https://bcgov.github.io/pahwq/reference/phototoxic_cwqg.md)
  and
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)
  now accept a `pac_name` as well as a `pac_id`, so homologue group
  names such as “C1-Phenanthrenes/Anthracenes” work. A group name uses
  its first parent, and the parents of a group have identical properties
  and spectra.
- [`narcotic_benchmark()`](https://bcgov.github.io/pahwq/reference/narcotic_benchmark.md)
  and
  [`narcotic_cwqg()`](https://bcgov.github.io/pahwq/reference/narcotic_cwqg.md):
  the `chemical` argument is now `pac`.
- [`pac_list()`](https://bcgov.github.io/pahwq/reference/pac_list.md):
  the `chemical` and `pac` columns are now `pac_id` and `pac_name`. The
  `pac_id` is the unique ID, and the `pac_name` is the display name,
  which homologue groups share across their parents.
- [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md)
  and
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md):
  the `pac` column is now `pac_id`, and there is a new `pac_name`
  column, which matches the guideline tables.
- [`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md):
  gives a clear error if `pac` is missing when `x` is a `tuv_results`
  data frame, even if `narc_bench` is supplied.
- [`plot_sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/plot_sens_kd_depth.md)
  titles and the message about surrogate absorption spectra now use PAC
  names from `pac_name` rather than IDs.
- [`tu_hi()`](https://bcgov.github.io/pahwq/reference/tu_hi.md): the
  `pac` column of the `"pacs"` attribute is now `pac_name`. The `pac`
  column of `concentrations` is unchanged.

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
