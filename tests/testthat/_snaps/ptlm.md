# plc50 works

    Code
      round(plc50(590, NLC50 = 450), 2)
    Output
      [1] 20.4

---

    Code
      round(plc50(590, pah = "Benzo(a)pyrene"), 2)
    Output
      [1] 0.08

---

    Code
      round(plc50(590, pah = "Benzo(a)pyrene", NLC50 = 450), 2)
    Output
      [1] 20.4

---

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
      round(plc50(pabs, pah = "Anthracene"), 2)
    Output
      [1] 2.99

# Setting o3_tc explicitly overrides the internal lookup

    Code
      round(pabs, 2)
    Output
      [1] 451.28

---

    Code
      round(plc50(pabs, NLC50 = 450), 2)
    Output
      [1] 23.05

# Setting Kd_ref and Kd_wvl works

    Code
      round(pabs, 2)
    Output
      [1] 273.99

---

    Code
      round(plc50(pabs, NLC50 = 450), 2)
    Output
      [1] 28.88

# The whole shebang works with a chemical using surrogates

    Code
      round(plc50(pabs, pah = "C1 Pyrenes"), 2)
    Output
      [1] 0.65

---

    Code
      round(plc50(pabs, pah = "C3 Naphthalenes"), 2)
    Output
      [1] 15.84

