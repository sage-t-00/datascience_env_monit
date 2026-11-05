# Cluster hello

"Bootstraps a synthetic GPP series and prints a 95% interval."
What does this mean?
Bootstrapping: Randomly resampling the data
Synthetic GPP series: A simulated timeline of data for the gross primary production of plants (measuring how much carbon they are absorbing)
95% confidence interval, significance level alpha = 0.05
So it means we are randomly resampling the GPP data to create hypothetical future scenarios, where we can predict what will happen in the future within a 95% confidence interval

## Run
Rscript scripts/cluster_hello.R 200

## Files
scripts/  the analysis code
jobs/     Slurm job scripts
docs/     notes and templates

## Author
Sage Tellew
