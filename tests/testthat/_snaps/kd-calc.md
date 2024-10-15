# kd_305 works at extremes of DOC

    Code
      round(kd_305(0.2), 2)
    Output
      [1] 0.51

---

    Code
      round(kd_305(10), 2)
    Output
      [1] 47

---

    Code
      round(kd_305(23), 2)
    Output
      [1] 130.7

# kd_lambda works at extremes of wavelengths

    Code
      round(kd_lambda(10, 280), 2)
    Output
        280 
      73.71 

---

    Code
      round(kd_lambda(10, 305), 2)
    Output
      305 
       47 

---

    Code
      round(kd_lambda(10, 400), 2)
    Output
      400 
      8.5 

