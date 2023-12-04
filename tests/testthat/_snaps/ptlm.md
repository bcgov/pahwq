# plc_50 works

    Code
      plc_50(590)
    Condition
      Error:
      ! You must provide a valid 'pah' or supply your own NLC50 value

---

    Code
      plc_50(590, pah = "foo")
    Condition
      Error:
      ! You have supplied an invalid chemical

