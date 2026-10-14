# pahwq (development version)

- Marine light attenuation now uses models by ecoregion, water type, and season, selected from the site's location and date, instead of a single fixed model.
  Where the model has no data (some Arctic areas in winter), `Kd_ref` and `Sk` must be set (#66).
- sf is now an imported dependency (#66).
- `kd_marine()` now takes `lat`, `lon`, and `date`, and is no longer rounded to 2 decimal places (#66).
- `marine_kd_areas()` is a new function that returns the marine model areas as `sf` polygons (#66).
- `marine_kd_model()` is a new function that looks up the marine model for a location and date (#66).
- `set_tuv_aq_params()` and `tuv()` accept `Kd_ref`, `Kd_wvl`, and `Sk` as overrides when `aq_env = "marine"`, and warn when the model fit for the area is flagged as poor (#66).
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
