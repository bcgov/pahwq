# pb_multi errors correctly

    Code
      pb_multi(5, pacs)
    Condition
      Error:
      ! `tuv_res` must be an object of type 'tuv_results'.

---

    Code
      pb_multi(tuv_results, c(pacs, "foo"))
    Condition
      Error:
      ! You have included invalid PAC names.

