# pahwq (development version)

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
