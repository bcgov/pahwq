# Update to the representative guideline tables

The representative guideline tables in `inst/doc-guideline-lookup/` were regenerated with `inst/multi-doc-lookup.R`.
They were last generated before two data updates, and this update also changes the freshwater depth.

- `PAH-DOC_freshwater-guidelines.csv`: Basin Lake, Saskatchewan (52.60°N, 105.28°W, 515 m), 21 June 2024, at 63 DOC values from 0.2 to 61.5 mg/L.
- `PAH_marine-guidelines.csv`: Tofino, BC (49.15°N, 125.91°W, 0 m), 21 June 2024, with Kd from the marine models.

## What changed

1. **PAC list and log KOW (#71).** Chemical properties now come from the EPI Suite KOWWIN log KOW values compiled by CCME, with log KOW capped at 6.0.
2. **Absorption spectra (#72).** Spectra now come from the CCME measured spectra and surrogate table.
   Homologue groups use the mean of one or more surrogate spectra, and spectra extend to their full measured range (previously cut off at 411 nm).
3. **Freshwater depth.** The freshwater depth is now 1 cm (was 50 cm), the same as marine.

## Chemicals

Both tables now cover 84 chemicals (85 before), and every chemical has a value.

- Removed with the new PAC list: 2-methylnaphthalene, benzo(a)fluoranthene, dibenzo(a,c)anthracene and triphenylene.
- Added: 9,10-dimethylanthracene, benzanthrone and benzo(b,j,k)fluoranthene.

## Effect of the data updates

Comparing the marine table before and after (same site and depth), for the 81 chemicals in both:

- Narcotic guidelines rose by more than 10% for 38 chemicals, fell by more than 10% for 10, and changed by less than 10% for 33.
- Phototoxic guidelines rose by more than 10% for 39 chemicals and fell by more than 10% for 10.

  | Chemical                           | Narcotic CWQG | Phototoxic CWQG |
  | ---------------------------------- | ------------- | --------------- |
  | C4-benz(a)anthracenes/chrysenes    | +2,141%       | +2,233%         |
  | Dibenzo(a,h)anthracene             | +1,088%       | +1,003%         |
  | C3-benz(a)anthracenes/chrysenes    | +737%         | +798%           |
  | C1-benzofluoranthenes/benzopyrenes | +324%         | +420%           |
  | Benzo(g,h,i)perylene               | +363%         | +343%           |
  | C1-fluorenes                       | −34%          | −33%            |
  | C2-fluorenes                       | −43%          | −42%            |
  | C1-fluoranthenes/pyrenes           | −38%          | −50%            |
  | C2-fluoranthenes/pyrenes           | −62%          | −69%            |

Most of the change comes from the new log KOW values, not the spectra.
The Target Lipid Model's narcotic guideline is exponential in log KOW:

```
guideline = 10^(slope × log KOW + log10(HC5) + Δc) × molecular weight × 1000
```

With a slope of −0.951 (long-term guideline), each 1-unit drop in log KOW multiplies the guideline by about 8.9.
The phototoxic guidelines scale with the narcotic benchmark, so they move by the same factor, plus the smaller effect of the new spectra.

  | Chemical | Old log KOW | New log KOW | Guideline multiplied by |
  | --- | --- | --- | --- |
  | C4-chrysenes | 7.42 | 6.00 | 22.4 |
  | Dibenzo(a,h)anthracene | 7.13 | 6.00 | 11.9 |
  | C3-benz(a)anthracenes | 6.97 | 6.00 | 8.4 |
  | Benzo(a)pyrene | 6.11 | 6.00 | 1.3 |
  | C2-pyrenes | 5.56 | 6.00 | 0.38 |

- The heaviest PACs had log KOW values well above 6, so the cap lowers them by up to 1.4 units and raises their guidelines up to about 22-fold.
  The Project Team confirmed the 6.0 cap is intended (26 October 2026).
- The KOWWIN values also differ from the old values below the cap, in both directions.
  Where log KOW went up (e.g., C2-pyrenes), guidelines went down.
- The spectra changes from #72 move phototoxic guidelines by about −35% to +38% on their own at 1 cm; see `scratch/reports/guideline-comparison-72.qmd`.

## Effect of the freshwater depth change

Moving from 50 cm to 1 cm doesn't change the narcotic guidelines, which don't depend on light.
More light reaches 1 cm, so the phototoxic guidelines are lower at every DOC, by 1% to 99%.
The difference grows with DOC, because DOC attenuates UV with depth:

  | DOC (mg/L) | Median change in phototoxic CWQG |
  | ---------- | -------------------------------- |
  | 0.2        | −4%                              |
  | 1.5        | −29%                             |
  | 5.5        | −71%                             |
  | 10.5       | −86%                             |
  | 30.5       | −96%                             |
  | 61.5       | −94%                             |
