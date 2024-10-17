# plc50 works

    Code
      plc50(590)
    Condition
      Error:
      ! You must provide a valid 'pah' or supply your own NLC50 value

---

    Code
      plc50(590, pah = "foo")
    Condition
      Error:
      ! You have supplied an invalid chemical

# The whole shebang works

    Code
      round(pabs, 3)
    Output
      [1] 1141.859

---

    Code
      round(plc50(pabs, pah = "Anthracene"), 2)
    Output
      [1] 1.45

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
      round(plc50(pabs, NLC50 = 450), 2)
    Output
      [1] 11.17

# Setting Kd_ref and Kd_wvl works

    Code
      round(pabs, 2)
    Output
      [1] 273.99

---

    Code
      round(plc50(pabs, NLC50 = 450), 2)
    Output
      [1] 20.11

# The whole shebang works with a chemical using surrogates

    Code
      round(pabs, 3)
    Output
      [1] 791.87

---

    Code
      round(plc50(pabs, pah = "C1 Pyrenes"), 2)
    Output
      [1] 0.29

---

    Code
      round(pabs, 3)
    Output
      [1] 2.335

---

    Code
      round(plc50(pabs, pah = "C3 Naphthalenes"), 2)
    Output
      [1] 6.44

