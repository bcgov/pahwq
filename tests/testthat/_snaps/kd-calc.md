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

# kd_marine works at extremes of wavelengths

    Code
      round(kd_marine(280), 2)
    Output
       280 
      0.71 

---

    Code
      round(kd_marine(305), 2)
    Output
      305 
      0.5 

---

    Code
      round(kd_marine(400), 2)
    Output
       400 
      0.13 

