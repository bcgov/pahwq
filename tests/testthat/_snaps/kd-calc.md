# kd_305 works at extremes of DOC

    Code
      round(kd_305(0.2), 2)
    Output
      [1] 0.29

---

    Code
      round(kd_305(10), 2)
    Output
      [1] 26.26

---

    Code
      round(kd_305(61), 2)
    Output
      [1] 279.38

# kd_305 replaces when outside DOC range

    Code
      round(kd_305(0.1), 2)
    Condition
      Warning:
      DOC value supplied is less than the minimum valid DOC. Replacing with 0.2
    Output
      [1] 0.29

---

    Code
      round(kd_305(62), 2)
    Condition
      Warning:
      DOC value supplied is greater than the maximum valid DOC. Replacing with 61.45
    Output
      [1] 282.08

# kd_lambda works at extremes of wavelengths

    Code
      round(kd_lambda(10, 280), 2)
    Output
        280 
      41.18 

---

    Code
      round(kd_lambda(10, 305), 2)
    Output
        305 
      26.26 

---

    Code
      round(kd_lambda(10, 400), 2)
    Output
       400 
      4.75 

# kd_marine errors when inputs differ in length

    Code
      kd_marine(400, c(49, 50), -125, "2024-06-21")
    Condition
      Error:
      ! `lat`, `lon`, and `date` must each have length 1

# kd_marine errors with no data

    Code
      kd_marine(400, pt[["lat"]], pt[["lon"]], "2024-01-15")
    Condition
      Error:
      ! There is no marine Kd model for Western_Arctic_Clear in winter. Set `Kd_ref` and `Sk` to specify the attenuation directly.

