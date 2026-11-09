# get_aerosol_tau checks lat and lon

    Code
      get_aerosol_tau(lat = 95, lon = -120, month = 6)
    Condition
      Error in `get_aerosol_tau()`:
      ! lat must be a numeric value between -90 and 90

---

    Code
      get_aerosol_tau(lat = "a", lon = -120, month = 6)
    Condition
      Error in `get_aerosol_tau()`:
      ! lat must be a numeric value between -90 and 90

---

    Code
      get_aerosol_tau(lat = 49, lon = -200, month = 6)
    Condition
      Error in `get_aerosol_tau()`:
      ! lon must be a numeric value between -180 and 180

---

    Code
      get_aerosol_tau(lat = 49, lon = "a", month = 6)
    Condition
      Error in `get_aerosol_tau()`:
      ! lon must be a numeric value between -180 and 180

