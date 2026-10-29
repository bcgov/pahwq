# List the PACs and their chemical properties

Returns the polycyclic aromatic compounds (PACs) available in the
package, with the chemical properties used to calculate narcotic
benchmarks and guidelines. Values of log KOW are from EPI Suite KOWWIN,
compiled by CCME, and are capped at 6.0.

## Usage

``` r
pac_list(app_only = FALSE)
```

## Arguments

- app_only:

  If `TRUE`, only return the PACs displayed in the Shiny app.

## Value

A data frame with columns:

- `chemical`: the chemical name, as accepted by functions such as
  [`narcotic_benchmark()`](https://bcgov.github.io/pahwq/reference/narcotic_benchmark.md)
  and [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md).

- `pac`: the PAC or PAC homologue group name.

- `chem_class`: the chemical class: `"PAH"`, `"He"` (heterocyclic
  aromatic compound), or `"oxy-PAH"`.

- `log_kow`: log KOW.

- `mol_weight`: molecular weight (g/mol).

- `app`: whether the PAC is displayed in the Shiny app.

- `ref`: the source of the values.

## Details

PAC homologue groups that combine more than one parent, such as
"C1-Phenanthrenes/Anthracenes", have one row per parent (e.g.,
`"c1-phenanthrenes"` and `"c1-anthracenes"`), with the same properties.

## Examples

``` r
pac_list()
#>                      chemical                                pac chem_class
#> 1  1,6,7-trimethylnaphthalene         1,6,7-Trimethylnaphthalene        PAH
#> 2            1-methylchrysene                   1-Methylchrysene        PAH
#> 3         1-methylnaphthalene                1-Methylnaphthalene        PAH
#> 4              1-methylpyrene                     1-Methylpyrene        PAH
#> 5     2,6-dimethylnaphthalene            2,6-Dimethylnaphthalene        PAH
#> 6     9,10-dimethylanthracene            9,10-Dimethylanthracene        PAH
#> 7          9-methylanthracene                 9-Methylanthracene        PAH
#> 8        9-methylphenanthrene               9-Methylphenanthrene        PAH
#> 9                acenaphthene                       Acenaphthene        PAH
#> 10             acenaphthylene                     Acenaphthylene        PAH
#> 11                   acridine                           Acridine         He
#> 12                 anthracene                         Anthracene        PAH
#> 13               benzanthrone                       Benzanthrone    oxy-PAH
#> 14         benzo(a)anthracene                 Benzo(a)anthracene        PAH
#> 15           benzo(a)fluorene                   Benzo(a)fluorene        PAH
#> 16             benzo(a)pyrene                     Benzo(a)pyrene        PAH
#> 17         benzo(b)anthracene                 Benzo(b)anthracene        PAH
#> 18       benzo(b)fluoranthene               Benzo(b)fluoranthene        PAH
#> 19           benzo(b)fluorene                   Benzo(b)fluorene        PAH
#> 20     benzo(bjk)fluoranthene           Benzo(b,j,k)fluoranthene        PAH
#> 21             benzo(e)pyrene                     Benzo(e)pyrene        PAH
#> 22         benzo(ghi)perylene               Benzo(g,h,i)perylene        PAH
#> 23       benzo(j)fluoranthene               Benzo(j)fluoranthene        PAH
#> 24       benzo(k)fluoranthene               Benzo(k)fluoranthene        PAH
#> 25             benzothiophene                     Benzothiophene         He
#> 26           c1-acenaphthenes                   C1-Acenaphthenes        PAH
#> 27     c1-benzo(a)anthracenes    C1-Benz(a)anthracenes/Chrysenes        PAH
#> 28               c1-chrysenes    C1-Benz(a)anthracenes/Chrysenes        PAH
#> 29      c1-benzo(b)thiophenes              C1-Benzo(b)thiophenes         He
#> 30      c1-benzofluoranthenes C1-Benzofluoranthenes/Benzopyrenes        PAH
#> 31            c1-benzopyrenes C1-Benzofluoranthenes/Benzopyrenes        PAH
#> 32       c1-dibenzothiophenes               C1-Dibenzothiophenes         He
#> 33           c1-fluoranthenes           C1-Fluoranthenes/Pyrenes        PAH
#> 34                 c1-pyrenes           C1-Fluoranthenes/Pyrenes        PAH
#> 35               c1-fluorenes                       C1-Fluorenes        PAH
#> 36            c1-naphthalenes                    C1-Naphthalenes        PAH
#> 37           c1-phenanthrenes       C1-Phenanthrenes/Anthracenes        PAH
#> 38             c1-anthracenes       C1-Phenanthrenes/Anthracenes        PAH
#> 39           c2-acenaphthenes                   C2-Acenaphthenes        PAH
#> 40     c2-benzo(a)anthracenes    C2-Benz(a)anthracenes/Chrysenes        PAH
#> 41               c2-chrysenes    C2-Benz(a)anthracenes/Chrysenes        PAH
#> 42      c2-benzo(b)thiophenes              C2-Benzo(b)thiophenes         He
#> 43      c2-benzofluoranthenes C2-Benzofluoranthenes/Benzopyrenes        PAH
#> 44            c2-benzopyrenes C2-Benzofluoranthenes/Benzopyrenes        PAH
#> 45       c2-dibenzothiophenes               C2-Dibenzothiophenes         He
#> 46           c2-fluoranthenes           C2-Fluoranthenes/Pyrenes        PAH
#> 47                 c2-pyrenes           C2-Fluoranthenes/Pyrenes        PAH
#> 48               c2-fluorenes                       C2-Fluorenes        PAH
#> 49            c2-naphthalenes                    C2-Naphthalenes        PAH
#> 50           c2-phenanthrenes       C2-Phenanthrenes/Anthracenes        PAH
#> 51             c2-anthracenes       C2-Phenanthrenes/Anthracenes        PAH
#> 52     c3-benzo(a)anthracenes    C3-Benz(a)anthracenes/Chrysenes        PAH
#> 53               c3-chrysenes    C3-Benz(a)anthracenes/Chrysenes        PAH
#> 54      c3-benzo(b)thiophenes              C3-Benzo(b)thiophenes         He
#> 55       c3-dibenzothiophenes               C3-Dibenzothiophenes         He
#> 56           c3-fluoranthenes           C3-Fluoranthenes/Pyrenes        PAH
#> 57                 c3-pyrenes           C3-Fluoranthenes/Pyrenes        PAH
#> 58               c3-fluorenes                       C3-Fluorenes        PAH
#> 59            c3-naphthalenes                    C3-Naphthalenes        PAH
#> 60           c3-phenanthrenes       C3-Phenanthrenes/Anthracenes        PAH
#> 61             c3-anthracenes       C3-Phenanthrenes/Anthracenes        PAH
#> 62     c4-benzo(a)anthracenes    C4-Benz(a)anthracenes/Chrysenes        PAH
#> 63               c4-chrysenes    C4-Benz(a)anthracenes/Chrysenes        PAH
#> 64      c4-benzo(b)thiophenes              C4-Benzo(b)thiophenes         He
#> 65       c4-dibenzothiophenes               C4-Dibenzothiophenes         He
#> 66           c4-fluoranthenes           C4-Fluoranthenes/Pyrenes        PAH
#> 67                 c4-pyrenes           C4-Fluoranthenes/Pyrenes        PAH
#> 68            c4-naphthalenes                    C4-Naphthalenes        PAH
#> 69           c4-phenanthrenes       C4-Phenanthrenes/Anthracenes        PAH
#> 70             c4-anthracenes       C4-Phenanthrenes/Anthracenes        PAH
#> 71                  carbazole                          Carbazole         He
#> 72                   chrysene                           Chrysene        PAH
#> 73      dibenzo(ah)anthracene             Dibenzo(a,h)anthracene        PAH
#> 74               dibenzofuran                       Dibenzofuran         He
#> 75           dibenzothiophene                   Dibenzothiophene         He
#> 76               fluoranthene                       Fluoranthene        PAH
#> 77                   fluorene                           Fluorene        PAH
#> 78       indeno(123-cd)pyrene           Indeno(1,2,3 - cd)pyrene        PAH
#> 79                naphthalene                        Naphthalene        PAH
#> 80                   perylene                           Perylene        PAH
#> 81               phenanthrene                       Phenanthrene        PAH
#> 82                     pyrene                             Pyrene        PAH
#> 83                  quinoline                          Quinoline         He
#> 84                     retene                             Retene        PAH
#>    log_kow mol_weight   app                               ref
#> 1     4.81   170.2300 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 2     6.00   242.3200 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 3     3.72   142.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 4     5.48   216.2800 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 5     4.26   156.2300 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 6     5.44   206.2900 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 7     4.89   192.2600 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 8     4.89   192.2600 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 9     4.15   154.2100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 10    3.94   152.2000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 11    3.32   179.2200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 12    4.35   178.2300  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 13    4.73   230.2700 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 14    5.52   228.2900  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 15    5.19   216.2800 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 16    6.00   252.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 17    5.52   228.3000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 18    6.00   252.3200 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 19    5.19   216.2800 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 20    6.00   252.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 21    6.00   252.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 22    6.00   276.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 23    6.00   252.3200 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 24    6.00   252.3200 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 25    2.99   134.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 26    4.57   168.2400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 27    6.00   242.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 28    6.00   242.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 29    3.54   148.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 30    6.00   266.3000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 31    6.00   266.3000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 32    4.71   198.2900  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 33    5.48   216.2800  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 34    5.48   216.2800  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 35    4.56   180.2500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 36    3.72   142.2000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 37    4.89   192.2600  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 38    4.89   192.2600  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 39    5.03   182.2400 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 40    6.00   256.3500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 41    6.00   256.3500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 42    4.06   162.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 43    6.00   280.3000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 44    6.00   280.3000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 45    5.23   212.3100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 46    6.00   230.3100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 47    6.00   230.3100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 48    5.08   194.2800  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 49    4.24   156.2300  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 50    5.41   206.2900  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 51    5.41   206.2900  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 52    6.00   270.3700  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 53    6.00   270.3700  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 54    4.57   176.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 55    5.75   226.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 56    6.00   244.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 57    6.00   244.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 58    5.60   208.3000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 59    4.75   170.2500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 60    5.93   220.3100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 61    5.93   220.3100  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 62    6.00   284.4000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 63    6.00   284.4000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 64    5.09   190.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 65    6.00   240.4000  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 66    6.00   258.3700  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 67    6.00   258.3700  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 68    5.27   184.2800  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 69    6.00   234.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 70    6.00   234.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 71    3.23   167.2100 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 72    5.52   228.2900  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 73    6.00   278.3500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 74    3.71   168.2000 FALSE EPI Suite KOWWIN, via CCME (2026)
#> 75    4.17   184.2600  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 76    4.93   202.2500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 77    4.02   166.2200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 78    6.00   276.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 79    3.17   128.1732  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 80    6.00   252.3200  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 81    4.35   178.2300  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 82    4.93   202.2500  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 83    2.14   129.1600  TRUE EPI Suite KOWWIN, via CCME (2026)
#> 84    6.00   234.3400  TRUE EPI Suite KOWWIN, via CCME (2026)
pac_list(app_only = TRUE)
#>                  chemical                                pac chem_class log_kow
#> 1            acenaphthene                       Acenaphthene        PAH    4.15
#> 2          acenaphthylene                     Acenaphthylene        PAH    3.94
#> 3                acridine                           Acridine         He    3.32
#> 4              anthracene                         Anthracene        PAH    4.35
#> 5      benzo(a)anthracene                 Benzo(a)anthracene        PAH    5.52
#> 6          benzo(a)pyrene                     Benzo(a)pyrene        PAH    6.00
#> 7  benzo(bjk)fluoranthene           Benzo(b,j,k)fluoranthene        PAH    6.00
#> 8          benzo(e)pyrene                     Benzo(e)pyrene        PAH    6.00
#> 9      benzo(ghi)perylene               Benzo(g,h,i)perylene        PAH    6.00
#> 10       c1-acenaphthenes                   C1-Acenaphthenes        PAH    4.57
#> 11 c1-benzo(a)anthracenes    C1-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 12           c1-chrysenes    C1-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 13  c1-benzofluoranthenes C1-Benzofluoranthenes/Benzopyrenes        PAH    6.00
#> 14        c1-benzopyrenes C1-Benzofluoranthenes/Benzopyrenes        PAH    6.00
#> 15   c1-dibenzothiophenes               C1-Dibenzothiophenes         He    4.71
#> 16       c1-fluoranthenes           C1-Fluoranthenes/Pyrenes        PAH    5.48
#> 17             c1-pyrenes           C1-Fluoranthenes/Pyrenes        PAH    5.48
#> 18           c1-fluorenes                       C1-Fluorenes        PAH    4.56
#> 19        c1-naphthalenes                    C1-Naphthalenes        PAH    3.72
#> 20       c1-phenanthrenes       C1-Phenanthrenes/Anthracenes        PAH    4.89
#> 21         c1-anthracenes       C1-Phenanthrenes/Anthracenes        PAH    4.89
#> 22 c2-benzo(a)anthracenes    C2-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 23           c2-chrysenes    C2-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 24  c2-benzofluoranthenes C2-Benzofluoranthenes/Benzopyrenes        PAH    6.00
#> 25        c2-benzopyrenes C2-Benzofluoranthenes/Benzopyrenes        PAH    6.00
#> 26   c2-dibenzothiophenes               C2-Dibenzothiophenes         He    5.23
#> 27       c2-fluoranthenes           C2-Fluoranthenes/Pyrenes        PAH    6.00
#> 28             c2-pyrenes           C2-Fluoranthenes/Pyrenes        PAH    6.00
#> 29           c2-fluorenes                       C2-Fluorenes        PAH    5.08
#> 30        c2-naphthalenes                    C2-Naphthalenes        PAH    4.24
#> 31       c2-phenanthrenes       C2-Phenanthrenes/Anthracenes        PAH    5.41
#> 32         c2-anthracenes       C2-Phenanthrenes/Anthracenes        PAH    5.41
#> 33 c3-benzo(a)anthracenes    C3-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 34           c3-chrysenes    C3-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 35   c3-dibenzothiophenes               C3-Dibenzothiophenes         He    5.75
#> 36       c3-fluoranthenes           C3-Fluoranthenes/Pyrenes        PAH    6.00
#> 37             c3-pyrenes           C3-Fluoranthenes/Pyrenes        PAH    6.00
#> 38           c3-fluorenes                       C3-Fluorenes        PAH    5.60
#> 39        c3-naphthalenes                    C3-Naphthalenes        PAH    4.75
#> 40       c3-phenanthrenes       C3-Phenanthrenes/Anthracenes        PAH    5.93
#> 41         c3-anthracenes       C3-Phenanthrenes/Anthracenes        PAH    5.93
#> 42 c4-benzo(a)anthracenes    C4-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 43           c4-chrysenes    C4-Benz(a)anthracenes/Chrysenes        PAH    6.00
#> 44   c4-dibenzothiophenes               C4-Dibenzothiophenes         He    6.00
#> 45       c4-fluoranthenes           C4-Fluoranthenes/Pyrenes        PAH    6.00
#> 46             c4-pyrenes           C4-Fluoranthenes/Pyrenes        PAH    6.00
#> 47        c4-naphthalenes                    C4-Naphthalenes        PAH    5.27
#> 48       c4-phenanthrenes       C4-Phenanthrenes/Anthracenes        PAH    6.00
#> 49         c4-anthracenes       C4-Phenanthrenes/Anthracenes        PAH    6.00
#> 50               chrysene                           Chrysene        PAH    5.52
#> 51  dibenzo(ah)anthracene             Dibenzo(a,h)anthracene        PAH    6.00
#> 52       dibenzothiophene                   Dibenzothiophene         He    4.17
#> 53           fluoranthene                       Fluoranthene        PAH    4.93
#> 54               fluorene                           Fluorene        PAH    4.02
#> 55   indeno(123-cd)pyrene           Indeno(1,2,3 - cd)pyrene        PAH    6.00
#> 56            naphthalene                        Naphthalene        PAH    3.17
#> 57               perylene                           Perylene        PAH    6.00
#> 58           phenanthrene                       Phenanthrene        PAH    4.35
#> 59                 pyrene                             Pyrene        PAH    4.93
#> 60              quinoline                          Quinoline         He    2.14
#> 61                 retene                             Retene        PAH    6.00
#>    mol_weight  app                               ref
#> 1    154.2100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 2    152.2000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 3    179.2200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 4    178.2300 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 5    228.2900 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 6    252.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 7    252.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 8    252.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 9    276.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 10   168.2400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 11   242.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 12   242.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 13   266.3000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 14   266.3000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 15   198.2900 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 16   216.2800 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 17   216.2800 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 18   180.2500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 19   142.2000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 20   192.2600 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 21   192.2600 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 22   256.3500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 23   256.3500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 24   280.3000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 25   280.3000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 26   212.3100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 27   230.3100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 28   230.3100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 29   194.2800 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 30   156.2300 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 31   206.2900 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 32   206.2900 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 33   270.3700 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 34   270.3700 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 35   226.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 36   244.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 37   244.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 38   208.3000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 39   170.2500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 40   220.3100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 41   220.3100 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 42   284.4000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 43   284.4000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 44   240.4000 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 45   258.3700 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 46   258.3700 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 47   184.2800 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 48   234.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 49   234.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 50   228.2900 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 51   278.3500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 52   184.2600 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 53   202.2500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 54   166.2200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 55   276.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 56   128.1732 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 57   252.3200 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 58   178.2300 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 59   202.2500 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 60   129.1600 TRUE EPI Suite KOWWIN, via CCME (2026)
#> 61   234.3400 TRUE EPI Suite KOWWIN, via CCME (2026)
```
