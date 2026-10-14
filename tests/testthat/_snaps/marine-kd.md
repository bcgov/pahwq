# nearby points use the nearest area with a message

    Code
      res <- marine_kd_model(49, -123.2, "2024-06-21")
    Message
      Location is outside the marine Kd model areas; using the nearest area (Strait_of_Georgia_Turbid at 0.2 km).

# max_dist_km sets the tolerance for the nearest area

    Code
      marine_kd_area(49, -123.2, max_dist_km = 0.1)
    Condition
      Error:
      ! The location (lat = 49, lon = -123.2) is not within 0.1 km of an area with a marine Kd model. It may be on land or outside Canadian waters.

# distant points error

    Code
      marine_kd_model(45, -40, "2024-06-21")
    Condition
      Error:
      ! The location (lat = 45, lon = -40) is not within 25 km of an area with a marine Kd model. It may be on land or outside Canadian waters.

---

    Code
      marine_kd_model(45, -100, "2024-06-21")
    Condition
      Error:
      ! The location (lat = 45, lon = -100) is not within 25 km of an area with a marine Kd model. It may be on land or outside Canadian waters.

# marine_kd_model() errors on invalid inputs

    Code
      marine_kd_model(49, -125)
    Condition
      Error:
      ! date must be specified

---

    Code
      marine_kd_model(NA, -125, "2024-06-21")
    Condition
      Error:
      ! `lat` and `lon` must be non-missing numeric vectors of the same length

---

    Code
      marine_kd_model(49, -125, "2024-06-21", Kd_wvl = "a")
    Condition
      Error:
      ! `Kd_wvl` must be a single number

