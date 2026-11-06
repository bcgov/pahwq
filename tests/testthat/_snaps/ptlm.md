# phototoxic_benchmark works

    Code
      round(phototoxic_benchmark(590, narc_bench = 450), 2)
    Output
      [1] 20.41

---

    Code
      round(phototoxic_benchmark(590, pac = "Benzo(a)pyrene"), 2)
    Output
      [1] 0.12

---

    Code
      round(phototoxic_benchmark(590, pac = "Benzo(a)pyrene", narc_bench = 450), 2)
    Output
      [1] 20.41

---

    Code
      phototoxic_benchmark(590)
    Condition
      Error:
      ! You must provide a valid 'pac' or supply your own narc_bench value

---

    Code
      phototoxic_benchmark(590, pac = "foo")
    Condition
      Error:
      ! You have supplied an invalid PAC

---

    Code
      phototoxic_benchmark(structure(data.frame(), class = c("tuv_results",
        "data.frame")), narc_bench = 450)
    Condition
      Error:
      ! You must provide `pac` when `x` is a `tuv_results` data frame, as its absorption spectrum is needed to calculate Pabs

# narcotic_benchmark works

    Code
      round(narcotic_benchmark("C1-Chrysenes"), 2)
    Output
      [1] 2.63

---

    Code
      round(narcotic_benchmark("fluorene"), 2)
    Output
      [1] 120.51

# p_abs() errors on TUV wavelengths that aren't whole numbers

    Code
      p_abs(run(111), "Anthracene")
    Condition
      Error:
      ! Pabs can't be calculated because some TUV wavelengths aren't whole numbers, so have no absorption spectrum. Choose `wvl_steps` so that they are; the default gives one step per nm.

# p_abs() errors with a single time step

    Code
      p_abs(res, "Anthracene")
    Condition
      Error:
      ! Pabs can't be calculated from a single time step. Set `tsteps` to at least 2.

# The whole shebang works

    Code
      round(phototoxic_benchmark(pabs, pac = "Anthracene"), 2)
    Output
      [1] 2.15

# Setting o3_tc explicitly overrides the internal lookup

    Code
      round(phototoxic_benchmark(pabs, narc_bench = 450), 2)
    Output
      [1] 15.05

# Setting Kd_ref and Kd_wvl works

    Code
      round(phototoxic_benchmark(pabs, narc_bench = 450), 2)
    Output
      [1] 28.89

# The whole shebang works with a chemical using surrogates

    Code
      round(phototoxic_benchmark(pabs, pac = "C1 Pyrenes"), 2)
    Output
      [1] 0.25

---

    Code
      round(phototoxic_benchmark(pabs, pac = "C3 Naphthalenes"), 2)
    Output
      [1] 10.54

# report_surrogate() names all surrogates

    Code
      report_surrogate("c3-naphthalenes")
    Message
      No measured absorption spectrum for C3-Naphthalenes. Using the spectrum of 1,6,7-Trimethylnaphthalene as a surrogate.
    Code
      report_surrogate("c1-pyrenes")
    Message
      No measured absorption spectrum for C1-Fluoranthenes/Pyrenes. Using the mean of the spectra of Fluoranthene and 1-Methylpyrene as a surrogate.
    Code
      report_surrogate("c2-benzopyrenes")
    Message
      No measured absorption spectrum for C2-Benzofluoranthenes/Benzopyrenes. Using the mean of the spectra of Benzo(a)pyrene, Benzo(e)pyrene, Benzo(b)fluoranthene and Benzo(k)fluoranthene as a surrogate.

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
      round(phototoxic_cwqg(590, pac = "Benzo(a)pyrene"), 2)
    Output
      [1] 0.01

---

    Code
      round(phototoxic_cwqg(590, pac = "Benzo(a)pyrene", narc_bench = 450), 2)
    Output
      [1] 1.76

---

    Code
      phototoxic_cwqg(590)
    Condition
      Error:
      ! You must provide a valid 'pac' or supply your own narc_bench value

---

    Code
      phototoxic_cwqg(590, pac = "foo")
    Condition
      Error:
      ! You have supplied an invalid PAC

# phototoxic_cwqg works with tuv results

    Code
      round(phototoxic_cwqg(res, "Anthracene"), 3)
    Output
      [1] 0.185

# phototoxic_cwqg works with tuv results (Added chemicals to nlc50, #53); 

    Code
      round(phototoxic_cwqg(res, "retene"), 3)
    Output
      [1] 0.045

# acr must be a single positive number

    Code
      phototoxic_cwqg(590, pac = "Anthracene", acr = -1)
    Condition
      Error:
      ! acr must be a single positive number

