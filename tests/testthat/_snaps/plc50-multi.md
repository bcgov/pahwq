# plc50_multi errors correctly

    Code
      plc50_multi(5, pahs)
    Condition
      Error:
      ! `tuv_res` must be an object of type 'tuv_results'.

---

    Code
      plc50_multi(tuv_results, c(pahs, "foo"))
    Condition
      Error:
      ! You have included invalid PAH names.

