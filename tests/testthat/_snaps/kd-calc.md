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

