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
stack <- rast(sds(files[1:(length(files) - 1)])) # The last file is corrupted
# missing values encoded as 99999
stack[stack > 99000] <- NA
# extract year-month from file names
names(stack) <- sub(".+([-0-9]{7}).FLOAT", "\\1", names(stack))

# Set time component to yearmonths, then aggregate by month
time(stack, tstep = "yearmonths") <- as.Date(paste0(names(stack), "-01"))
stack_by_month <- tapp(stack, "months", mean, na.rm = TRUE, cores = 12)
# plot(stack_by_month)

# Aggregate to one degree resolution
stack_by_month_one_degree <- aggregate(stack_by_month, fact = 10, fun = "mean", na.rm = TRUE)
# plot(stack_by_month_one_degree)

# save to regular R array, 180x360x12
d <- as.array(stack_by_month_one_degree)
# row names based on latitude bands. We reverse labels to N is positive numbers
rownames(d) <- rev(levels(cut(seq(-90, 90), breaks = 180, dig.lab = 2)))
# West are negative longitude
colnames(d) <- levels(cut(seq(-180, 180), breaks = 360, dig.lab = 2))
# Month names padded with zeros to width 2
dimnames(d)[[3]] <- sprintf("%02s", gsub("m_", "", names(stack_by_month_one_degree)))

## plot one to visualize the coverage. Need to reverse and transpose the matrix
## since R draws matrix image from bottom left instead of top left
image(t(apply(d[,,5], 2, rev)))

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
