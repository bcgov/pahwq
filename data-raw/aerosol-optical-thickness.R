# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

# This uses MODIS-Aqua derived aerosol optical depth. Uses data from the bulk download at https://neo.gsfc.nasa.gov/about/bulk.php.
#
# The data preparation code:
#
#   1. Downloads Aqua/MODIS global monthly geotiffs of AOD from 2012 to 2023 (256 files from https://neo.gsfc.nasa.gov/archive/geotiff.float/MYDAL2_M_AER_OD/
#   2. Aggregates the data by month over all years (2012-2023)
#   3. Downsamples to 1 degree resolution
#   4. Saves as a 3D array (180x360x12; lat, lon, month) in the package

library(rvest)
library(dplyr)
library(terra)

dir <- file.path("data-raw", "aerosols-tiff")
dir.create(dir, showWarnings = FALSE)

base_url <- "https://neo.gsfc.nasa.gov/archive/geotiff.float/MYDAL2_M_AER_OD/"

hrefs <- read_html(base_url) |>
  html_elements("a") |>
  html_attr("href")

files <- hrefs[grepl("[0-9]{4}-[0-9]{2}.FLOAT.TIFF", hrefs)]

files_need <- setdiff(files, list.files(dir))

if (length(files_need) > 0) {

  urls <- file.path(base_url, files_need)

  lapply(urls, \(x) {
    localfile <- file.path(dir, basename(x))
    download.file(x, localfile)
  })
}

files <- list.files(dir, pattern = ".FLOAT.TIFF", full.names = TRUE)

## Check one:
# r <- rast(files[1])
# r[r > 99000] <- NA
# plot(r)

# stack
stack <- files[which(file.size(files) > 0)] |> # The last file is corrupted (size 0)
  sds() |>
  rast()

# missing values encoded as 99999
stack[stack > 99000] <- NA
# extract year-month from file names
names(stack) <- sub(".+([-0-9]{7}).FLOAT", "\\1", names(stack))

# Set time component to yearmonths, then aggregate by month
time(stack, tstep = "yearmonths") <- as.Date(paste0(names(stack), "-01"))
stack_by_month <- tapp(stack, "months", mean, na.rm = TRUE, cores = 12)
# plot(stack_by_month)

# Aggregate to one degree resolution, set names, and order
stack_by_month_one_degree <- aggregate(
  stack_by_month,
  fact = 10,
  fun = "mean",
  na.rm = TRUE,
  cores = 12
)
names(stack_by_month_one_degree) <- sprintf(
  "%02s",
  gsub("m_", "", names(stack_by_month_one_degree))
)
stack_by_month_one_degree <- stack_by_month_one_degree[[
  order(names(stack_by_month_one_degree))
]]

# plot(stack_by_month_one_degree)

# save to regular R array, 180x360x12
d <- as.array(stack_by_month_one_degree)
# row names based on latitude bands. We reverse labels to N is positive numbers
rownames(d) <- seq(-90, 90) |>
  cut(breaks = 180, dig.lab = 2) |>
  levels() |>
  rev()
# West are negative longitude
colnames(d) <- seq(-180, 180) |>
  cut(breaks = 360, dig.lab = 2) |>
  levels()
# Month names padded with zeros to width 2
dimnames(d)[[3]] <- names(stack_by_month_one_degree)

## plot one to visualize the coverage. Need to reverse and transpose the matrix
## since R draws matrix image from bottom left instead of top left
image(t(apply(d[,,"05"], 2, rev)))

# final output
aerosol <- d

## Test lookup
# lat <- 49.6
# lon <- -119.6
# month <- "06"
# latrow <- nrow(aerosol) - findInterval(lat, seq(-90, 90, length.out = 181), all.inside = TRUE) + 1
# loncol <- findInterval(lon, seq(-180, 180, length.out = 361), all.inside = TRUE)
#
# aerosol[latrow, loncol, month, drop = FALSE]
