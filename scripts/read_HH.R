library(readr)
library(dplyr)

keep <- c("TIMESTAMP_START", "TIMESTAMP_END", "TA_F", "SW_IN_F", "VPD_F", "P_F",
          "NETRAD", "G_F_MDS", "H_F_MDS", "H_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC",
          "NEE_VUT_REF", "NEE_VUT_REF_QC", "GPP_NT_VUT_REF", "RECO_NT_VUT_REF")

read_hh <- function(zip_file, exdir = "data/raw/unzipped") {
  # site ID from the file name, e.g. "AMF_CR-Fsc_FLUXNET_..." -> "CR-Fsc"
  site <- sub(".*_([A-Z]{2}-[A-Za-z0-9]+)_FLUXNET_.*", "\\1", basename(zip_file))

  hh_name <- grep("FLUXMET_HH", unzip(zip_file, list = TRUE)$Name, value = TRUE)
  hh_path <- file.path(exdir, hh_name)
  if (!file.exists(hh_path)) unzip(zip_file, files = hh_name, exdir = exdir)

  read_csv(hh_path,
           na = "-9999",
           col_select = any_of(keep),
           col_types = cols(TIMESTAMP_START = "c", TIMESTAMP_END = "c", .default = "d")) |>
    mutate(site = site,
           time = as.POSIXct(TIMESTAMP_START, format = "%Y%m%d%H%M", tz = "UTC")) |>
    relocate(site, time)
}

zips <- list.files("data/raw", pattern = "_FLUXNET_.*\\.zip$", full.names = TRUE)
hh_all <- bind_rows(lapply(zips, read_hh))

saveRDS(hh_all, "data/processed/hh_all.rds")

#There is now a file in data/processed with this binary document. Now let's turn it into a table. 

library(dplyr)
hh_all <- readRDS("data/processed/hh_all.rds")

hh_all |>
  group_by(site) |>
  summarise(rows = n(), start = min(time), end = max(time))

# A tibble: 5 × 4
 # site     rows start               end                
 # <chr>   <int> <dttm>              <dttm>             
#1 AU-Ctr 157776 2010-01-01 00:00:00 2018-12-31 23:30:00
#2 CN-Dan 175344 2011-01-01 00:00:00 2020-12-31 23:30:00
#3 CR-Fsc  70128 2015-01-01 00:00:00 2018-12-31 23:30:00
#4 DE-Tha 543504 1996-01-01 00:00:00 2026-12-31 23:30:00
#5 US-MBP 280512 2009-01-01 00:00:00 2024-12-31 23:30:00

#DE-Tha ends on 31 December 2026, but today is 20 November. The last weeks of that file can’t
# hold real measurements, so they’re probably empty rows.