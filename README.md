# Environmental monitoring and data analysis

Coursework for the Environmental Monitoring and Data Analysis course. Author: Sage Tellew (tower set 29: AU-Ctr, CN-Dan, CR-Fsc, DE-Tha, US-MBP).

## Block 4: Data summary of five flux towers

**Data needed before rendering**

- The five FLUXNET zips in `data/raw`, downloaded with `scripts/get_my_towers.R` (set `my_student <- "29"`).
- The half-hourly data read by `scripts/read_HH.R` and saved as `data/processed/hh_all.rds`. If that file is missing, the report rebuilds it from the zips.

**Render the report**

```bash
quarto render reports/block4_data_summary.qmd
```

## Block 5: Are my tower years warmer and drier than the 1970-2000 normal?

**Data needed before rendering**

- The Block 4 data above.
- The two Block 5 downloads in `data/external` (run each script once from the project folder, with `my_student <- "29"` set in `scripts/block5/block5_sites.R`):

```bash
Rscript scripts/block5/02_worldclim.R
Rscript scripts/block5/04_soilgrids.R
```

**Render the report**

```bash
quarto render reports/block5_question.qmd
```

R packages used: dplyr, readr, tidyr, ggplot2 (reports), plus terra and geodata (WorldClim script). `data/` is in `.gitignore` and is not part of the repository.

## Cluster hello (Block 2)

"Bootstraps a synthetic GPP series and prints a 95% interval."

- Bootstrapping: randomly resampling the data (with replacement).
- Synthetic GPP series: a simulated timeline of gross primary production (how much carbon plants absorb).
- 95% confidence interval: significance level alpha = 0.05.
- So the script resamples the GPP series many times to estimate how uncertain a summary statistic (such as the mean) is, and reports a 95% interval for it.

Treat -9999 as missing before monthly means.

Run:

```bash
Rscript scripts/cluster_hello.R 200
```

## Files

- `scripts/`: the analysis code
- `reports/`: the Quarto reports
- `jobs/`: Slurm job scripts
- `docs/`: notes and templates