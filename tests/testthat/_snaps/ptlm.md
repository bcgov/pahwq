# phototoxic_benchmark works

    Code
      round(phototoxic_benchmark(590, narc_bench = 450), 2)
    Output
      [1] 20.41

---

    Code
      round(phototoxic_benchmark(590, pah = "Benzo(a)pyrene"), 2)
    Output
      [1] 0.1

---

    Code
      round(phototoxic_benchmark(590, pah = "Benzo(a)pyrene", narc_bench = 450), 2)
    Output
      [1] 20.41

---

    Code
      phototoxic_benchmark(590)
    Condition
      Error:
      ! You must provide a valid 'pah' or supply your own narc_bench value

---

    Code
      phototoxic_benchmark(590, pah = "foo")
    Condition
      Error:
      ! You have supplied an invalid chemical

# narcotic_benchmark works

    Code
      round(narcotic_benchmark("C1-Chrysenes"), 2)
    Output
      [1] 1.75

---

    Code
      round(narcotic_benchmark("fluorene"), 2)
    Output
      [1] 120.51

# The whole shebang works

    Code
      round(pabs, 3)
    Output
      [1] 1141.859

---

    Code
      round(phototoxic_benchmark(pabs, pah = "Anthracene"), 2)
    Output
      [1] 2.15

# Specifying wavelengths for specific PAHs is not necessary

    Code
      round(pabs, 2)
    Output
      [1] 0.31

# Dibenzo[ah]anthracene (gaps in molar_absorption range)

    Code
      round(pabs, 2)
    Output
      [1] 776.22

# Setting o3_tc explicitly overrides the internal lookup

    Code
      round(pabs, 1)
    Output
      [1] 1143.7

---

    Code
      round(phototoxic_benchmark(pabs, narc_bench = 450), 2)
    Output
      [1] 15.05

# Setting Kd_ref and Kd_wvl works

    Code
      round(pabs, 2)
    Output
      [1] 273.99

---

    Code
      round(phototoxic_benchmark(pabs, narc_bench = 450), 2)
    Output
      [1] 28.89

# The whole shebang works with a chemical using surrogates

    Code
      round(pabs, 3)
    Output
      [1] 791.87

---

    Code
      round(phototoxic_benchmark(pabs, pah = "C1 Pyrenes"), 2)
    Output
      [1] 0.45

---

    Code
      round(pabs, 3)
    Output
      [1] 2.335

---

    Code
      round(phototoxic_benchmark(pabs, pah = "C3 Naphthalenes"), 2)
    Output
      [1] 11

# narcotic_cwqg works

    Code
      round(narcotic_cwqg("Anthracene"))
    Output
      [1] 9

# phototoxic_cwqg works

    Code
      round(phototoxic_cwqg(590, narc_bench = 450), 2)
    Output
      [1] 1.76

---

    Code
      round(phototoxic_cwqg(590, pah = "Benzo(a)pyrene"), 2)
    Output
      [1] 0.01

---

    Code
      round(phototoxic_cwqg(590, pah = "Benzo(a)pyrene", narc_bench = 450), 2)
    Output
      [1] 1.76

---

    Code
      phototoxic_cwqg(590)
    Condition
      Error:
      ! You must provide a valid 'pah' or supply your own narc_bench value

---

    Code
      phototoxic_cwqg(590, pah = "foo")
    Condition
      Error:
      ! You have supplied an invalid chemical

# phototoxic_cwqg works with tuv results

    Code
      round(phototoxic_cwqg(res, "Anthracene"), 3)
    Output
      [1] 0.185

# phototoxic_cwqg works with tuv results (Added chemicals to nlc50, #); 

    Code
      round(phototoxic_cwqg(res, "retene"), 3)
    Output
      [1] 0.021

