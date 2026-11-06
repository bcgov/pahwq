# pacwq 0.8.1

- `p_abs()` and functions that use it, such as `phototoxic_benchmark()`, now give an error when the TUV wavelengths aren't whole numbers, as happens with most values of `wvl_steps` other than the default. These wavelengths have no absorption spectrum and were silently dropped, which understated Pabs (by about 90% for anthracene with `wvl_steps = 111`).
- `p_abs()` and functions that use it now give an error for TUV results with one time step (`tsteps = 1`), rather than returning `-Inf`.
- `plot_sens_kd_depth()` now compares the narcotic and phototoxic benchmarks of each square when greying out squares with no phototoxic effect. It was dividing by the mean of the whole column, so the wrong squares could be greyed out.
- `run_tuv()` and `tuv()` now give an error if the TUV program can't be run or fails, and `run_tuv()` deletes output from earlier runs before starting. Previously `tuv()` could return the results of an earlier run after a failure, with the parameters of the new one.

# pacwq 0.8.0

- The guideline tables in `inst/doc-guideline-lookup/` have new column names (`chemical` is now `pac_name`, and the guideline columns are now `short_term_narcotic_guideline`, `long_term_narcotic_guideline`, `short_term_phototoxic_guideline` and `long_term_phototoxic_guideline`), and now have one row per PAC, so homologue groups are no longer split by parent. Regenerating the tables also changed 23 freshwater values by one unit in the last significant figure (at most 0.53%), and no marine values. Homologue groups now use their group name, and four single-PAC names changed (e.g., `Benzo(Ghi)Perylene` is now `Benzo(g,h,i)perylene`). `match_pac()` recognises all of the old names.
- `narcotic_benchmark()`, `narcotic_cwqg()`, `p_abs()`, `p_abs_single()`, `pb_multi()`, `phototoxic_benchmark()`, `phototoxic_cwqg()` and `sens_kd_depth()` now accept a `pac_name` as well as a `pac_id`, so homologue group names such as "C1-Phenanthrenes/Anthracenes" work. A group name uses its first parent, and the parents of a group have identical properties and spectra.
- `narcotic_benchmark()` and `narcotic_cwqg()`: the `chemical` argument is now `pac`.
- `pac_list()`: the `chemical` and `pac` columns are now `pac_id` and `pac_name`. The `pac_id` is the unique ID, and the `pac_name` is the display name, which homologue groups share across their parents.
- `pb_multi()` and `sens_kd_depth()`: the `pac` column is now `pac_id`, and there is a new `pac_name` column, which matches the guideline tables.
- `phototoxic_benchmark()`: gives a clear error if `pac` is missing when `x` is a `tuv_results` data frame, even if `narc_bench` is supplied.
- `plot_sens_kd_depth()` titles and the message about surrogate absorption spectra now use PAC names from `pac_name` rather than IDs.
- `tu_hi()`: the `pac` column of the `"pacs"` attribute is now `pac_name`. The `pac` column of `concentrations` is unchanged.

# pacwq 0.7.0

- The package is now called pacwq (previously pahwq): use `library(pacwq)`, and set the `pacwq.tuv_data_dir` option instead of `pahwq.tuv_data_dir`. TUV files are now stored in the `pacwq` user data directory, so any existing `pahwq` directory can be deleted. The GitHub repository is still `bcgov/pahwq`, so installation with `pak::pak("bcgov/pahwq")` and the website URL are unchanged.
- Documentation and error messages now use "polycyclic aromatic compounds (PACs)" instead of "polycyclic aromatic hydrocarbons (PAHs)".
- The guideline tables in `inst/doc-guideline-lookup/` are now `PAC-DOC_freshwater-guidelines.csv` and `PAC_marine-guidelines.csv`.
- `p_abs()`, `p_abs_single()`, `pb_multi()`, `phototoxic_benchmark()`, `phototoxic_cwqg()` and `sens_kd_depth()`: the `pah` argument is now `pac` (`pahs` is now `pacs` in `pb_multi()`), and the `pah` column returned by `pb_multi()` and `sens_kd_depth()` is now `pac`. This is a breaking change for code that uses the old names.

# pahwq 0.6.1

- `phototoxic_cwqg()`, `pb_multi()` and `tu_hi()` have a new `acr` argument for the acute-to-chronic ratio. It defaults to 11.6, so results don't change.

# pahwq 0.6.0

- New `match_pac()` finds the PAC or PAC homologue group for each name given, as a `pac` or `chemical` name from `pac_list()` (#80).
- New `tu_hi()` calculates narcotic and phototoxic toxic units and hazard indexes for the PACs in a monitoring sample from concentrations and TUV results (#80).

# pahwq 0.5.2

- `doc_range()`: the maximum valid DOC is now 61.5 mg/L (previously 61.45 mg/L), matching the calibration range of the freshwater Kd model.
- `set_tuv_aq_params()` and `tuv()` have a new `Sk` argument for the spectral slope of Kd, which previously could only be passed through `...`.
  It defaults to 0.018 nm^-1 in freshwater and to the marine model's value in marine waters.
- `set_tuv_aq_params()` and `tuv()`: in marine waters, `elev_m` now defaults to 0 m instead of being looked up from a digital elevation model.

# pahwq 0.5.1

- `sens_kd_depth()`, `set_tuv_aq_params()` and `tuv()`: `depth_m` now defaults to 1 cm (`0.01`) for all water bodies (marine waters, lakes and rivers), and must be a single positive number.
  Previously it had no default, and leaving it out wrote an empty depth to the TUV input file (#77).

# pahwq 0.5.0

- Chemical properties for PACs now come from the EPI Suite KOWWIN log KOW values compiled by CCME, for 70 PACs and PAC homologue groups, with log KOW capped at 6.0.
  As a result, narcotic and phototoxic benchmarks and guidelines change for many PACs.
  Some PAC homologue groups now combine more than one parent (e.g., "C1-Benz(a)anthracenes/Chrysenes"), and some PACs are no longer available (naphthobenzothiophenes, triphenylene, benzo(a)fluoranthene, 2-methylnaphthalene, dibenzo(a,c)anthracene) (#71).
- Molar absorption spectra now come from the measured spectra and surrogate table compiled by CCME.
  Spectra now extend to the full measured range (up to 500 nm), and PACs without a measured spectrum use the mean of the spectra of one or more surrogates.
- Every PAC in `pac_list()` now has a spectrum (#72).
- `p_abs()` and `p_abs_single()` now name all surrogates in the message reported when a PAC has no measured spectrum (#72).
- `pac_list()` is a new function that returns the PACs and their chemical properties, optionally only those displayed in the Shiny app (#71).

# pahwq 0.4.1

- `get_tuv_results()` and `tuv()`: for marine runs, the `kd_model` attribute is now a one-row data frame, and includes the `Kd_ref`, `Kd_wvl` and `Sk` used (including overrides) and `dist_km`.
  Long values are no longer wrapped onto multiple lines.
  `tuv_run_params()` also reports the distance to the marine area, and the Kd parameter label in the TUV input file no longer says the reference wavelength is 305 nm.

# pahwq 0.4.0

- `doc_range()` and `doc_range_check()` are now exported and documented.
- Marine light attenuation now uses models by ecoregion, water type, and season, selected from the site's location and date, instead of a single fixed model.
  Where the model has no data (some Arctic areas in winter), `Kd_ref` and `Sk` must be set (#66).
- `kd_marine()` now takes `lat`, `lon`, and `date` (#66).
- `marine_kd_areas()` is a new function that returns the marine model areas as `sf` polygons (#66).
- `marine_kd_model()` is a new function that looks up the marine model for a location and date (#66).
- `set_tuv_aq_params()` and `tuv()` accept `Kd_ref`, `Kd_wvl`, and `Sk` as overrides when `aq_env = "marine"`, and warn when the marine model is based on fewer than 10% valid pixels across the area or over time (#66).
- `set_tuv_aq_params()` and `tuv()` now default to a wavelength range of 280 - 500nm (`wvl_end = 500`) for both fresh and salt water, instead of 280 - 800nm (#66).
- `tuv_run_params()` includes the marine model that was used (#66).

# pahwq 0.3.1

- `p_abs_single()` now accomodates unequal wavelength intervals.
- Default range of wavelengths expanded to 280 - 800nm.

# pahwq 0.3.0

- Rename PAH -> PAC in sensitivity analysis
- Add Triphenylene as isomer of Chrysene
- Add Indeno[1,2,3-cd]pyrene
- Generate lookup tables of representative DOC guidelines
- Add surrogate spectra

# pahwq 0.2.0

- Added properties for more chemicals so narcotic and photoxic guidelines can be calculated (#53)

# pahwq 0.1.2

- Ensure marine uses correct reference wavelength when calculating Kd(marine)

# pahwq 0.1.1

- Add narcotic and phototoxic CWQG outputs to multi-chemical results

# pahwq 0.1.0

- Initial release
