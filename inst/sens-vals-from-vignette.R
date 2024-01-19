library(withr)
library(knitr)
library(tidyverse)
library(glue)

tmpfile <- local_tempfile(fileext = ".R")

purl("vignettes/articles/sensitivity.Rmd", output = tmpfile)

source(tmpfile)

test_list <- ls(pattern = "_test_")

sens_analysis_results <- map(test_list, \(x) {
  df <- get(x) |>
    select(-starts_with("doc"), -tuv_res, -timing)

  nm <- names(df)[which(names(df) == "PAH") - 1]

  df |>
    mutate(test_variable = nm) |>
    rename_with(\(x) "value", .cols = matches(nm)) |>
    relocate(test_variable, .before = value) |>
    relocate(nlc50, .after = PAH)
}) |>
  bind_rows()

write_csv(
  sens_analysis_results,
  glue("inst/{Sys.Date()}_pahwq-sensitivity-analysis-results.csv")
)

surrogate_test_list <- ls(pattern = "plc50_df_")

surrogate_sens_analysis_results <- map(surrogate_test_list, \(x) {
  df <- get(x) |>
    select(-starts_with("doc"), -tuv_res, -timing, -plc_nlc_ratio) |>
    filter(grepl("[0-9]", PAH) | abs_spectra == "specific")

  df |>
    relocate(nlc50, .after = PAH)
}) |>
  bind_rows()

write_csv(
  surrogate_sens_analysis_results,
  glue("inst/{Sys.Date()}_pahwq-alk-surrogate-spectra-analysis-results.csv")
)
