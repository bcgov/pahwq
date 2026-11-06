test_that("pac_list returns all 70 PACs", {
  pacs <- pac_list()
  expect_s3_class(pacs, "data.frame")
  expect_named(
    pacs,
    c("pac_id", "pac_name", "chem_class", "log_kow", "mol_weight", "app", "ref")
  )
  expect_length(unique(pacs$pac_name), 70)
  expect_equal(anyDuplicated(pacs$pac_id), 0)
  expect_in(pacs$chem_class, c("PAH", "He", "oxy-PAH"))
  expect_equal(
    pacs$pac_id[pacs$pac_name == "C1-Phenanthrenes/Anthracenes"],
    c("c1-phenanthrenes", "c1-anthracenes")
  )
})

test_that("every PAC has an absorption spectrum", {
  expect_setequal(unique(molar_absorption$pac_id), pac_list()$pac_id)
})

test_that("pac_list(app_only = TRUE) returns the 47 PACs shown in the app", {
  pacs <- pac_list()
  app_pacs <- pac_list(app_only = TRUE)
  expect_all_true(app_pacs$app)
  expect_length(unique(app_pacs$pac_name), 47)
  expect_setequal(
    sanitize_names(setdiff(pacs$pac_name, app_pacs$pac_name)),
    sanitize_names(c(
      "C2-Acenaphthenes",
      "Benzo(b)fluoranthene",
      "Benzo(j)fluoranthene",
      "Benzo(k)fluoranthene",
      "1-methylchrysene",
      "1-methylnaphthalene",
      "1-methylpyrene",
      "2,6-dimethylnaphthalene",
      "1,6,7-trimethylnaphthalene",
      "9-methylanthracene",
      "9,10-dimethylanthracene",
      "9-methylphenanthrene",
      "Benzo(a)fluorene",
      "Benzo(b)anthracene",
      "Benzothiophene",
      "C1-benzo(b)thiophenes",
      "C2-benzo(b)thiophenes",
      "C3-benzo(b)thiophenes",
      "C4-benzo(b)thiophenes",
      "Dibenzofuran",
      "Carbazole",
      "Benzanthrone",
      "Benzo(b)fluorene"
    ))
  )
})

test_that("pac_list validates app_only", {
  expect_snapshot(pac_list(app_only = NA), error = TRUE)
})

test_that("functions accept homologue group names", {
  local_tuv_dir()
  res <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  group <- "C1-Phenanthrenes/Anthracenes"
  ids <- pac_list()$pac_id[pac_list()$pac_name == group]

  for (id in ids) {
    expect_equal(narcotic_benchmark(group), narcotic_benchmark(id))
    expect_equal(narcotic_cwqg(group), narcotic_cwqg(id))
    expect_equal(p_abs(res, group), p_abs(res, id))
    expect_equal(
      phototoxic_benchmark(res, group),
      phototoxic_benchmark(res, id)
    )
    expect_equal(phototoxic_cwqg(res, group), phototoxic_cwqg(res, id))
  }

  multi <- pb_multi(res, c(group, "Anthracene"))
  expect_equal(multi$pac_id, c(ids[1], "anthracene"))
  expect_equal(multi$pac_name, c(group, "Anthracene"))
  expect_equal(multi$pabs[1], p_abs(res, ids[1]))
})

test_that("match_pac() matches PAC names and IDs", {
  expect_equal(
    match_pac(c(
      "Benzo[a]pyrene",
      "C1-Phenanthrenes/Anthracenes",
      "c1-anthracenes",
      "  Pyrene\t",
      "not a pac",
      NA
    )),
    c(
      "Benzo(a)pyrene",
      "C1-Phenanthrenes/Anthracenes",
      "C1-Phenanthrenes/Anthracenes",
      "Pyrene",
      NA,
      NA
    )
  )
  expect_snapshot(match_pac(1), error = TRUE)
})
