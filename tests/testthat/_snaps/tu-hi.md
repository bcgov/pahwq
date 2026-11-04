# tu_hi_calc() divides by each guideline, sums and prints

    Code
      res
    Output
      
      Toxic units and hazard indexes for the sample.
      PACs: 3 (2 with a concentration above 0)
      
       tu_narcotic tu_phototoxic hi_narcotic hi_phototoxic
               1.5           0.6        0.75         0.375
      
      Results for individual PACs are in `attr(x, "pacs")`.

# tu_hi() checks its inputs

    Code
      tu_hi(data.frame(), data.frame())
    Condition
      Error:
      ! `tuv_results` must be an object of type 'tuv_results'.
    Code
      tu_hi(list(), tuv_results)
    Condition
      Error:
      ! `concentrations` must be a data frame.
    Code
      tu_hi(data.frame(pac = "pyrene"), tuv_results)
    Condition
      Error:
      ! `concentrations` is missing columns: concentration_ug_L
    Code
      tu_hi(data.frame(pac = 1, concentration_ug_L = 1), tuv_results)
    Condition
      Error:
      ! `concentrations$pac` must be a character column with no missing values.
    Code
      tu_hi(data.frame(pac = "pyrene", concentration_ug_L = "1"), tuv_results)
    Condition
      Error:
      ! `concentrations$concentration_ug_L` must be numeric.
    Code
      tu_hi(data.frame(pac = "pyrene", concentration_ug_L = -1), tuv_results)
    Condition
      Error:
      ! `concentrations$concentration_ug_L` must be zero or greater and finite.
    Code
      suppressWarnings(tu_hi(data.frame(pac = "not a pac", concentration_ug_L = 1),
      tuv_results))
    Condition
      Error:
      ! `concentrations` must contain at least one known PAC.
    Code
      tu_hi(data.frame(pac = c("C1-Phenanthrenes/Anthracenes", "c1-anthracenes"),
      concentration_ug_L = 1), tuv_results)
    Condition
      Error:
      ! `concentrations` must have one row per PAC. Repeated: C1-Phenanthrenes/Anthracenes

# tu_hi() matches names and uses guidelines from the TUV results

    Code
      res <- suppressMessages(tu_hi(concentrations, tuv_results, 1))
    Condition
      Warning:
      Dropping PACs that aren't recognised: not a pac

