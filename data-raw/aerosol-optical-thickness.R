library(rvest)
library(dplyr)

dir <- file.path("data-raw", "aerosols")
dir.create(dir, showWarnings = FALSE)

base_url <- "https://gacp.giss.nasa.gov/data/time_ser"

file_tables <- read_html(base_url) |>
  html_table() |>
  bind_rows()

if (!setequal(file_tables$File, list.files(dir))) {

  urls <- file.path(base_url, file_tables$File)

  lapply(urls, \(x) {
    localfile <- file.path(dir, basename(x))
    download.file(x, localfile)
  })
}

files <- list.files(dir, pattern = "tau\\.ascii\\.gz", full.names = TRUE)

# Get the year and month of the data from the first row
arrnames <- vapply(files, \(x) {
  f <- gzfile(x)
  readLines(f, n = 1L)
}, FUN.VALUE = "")

mat_list <- lapply(files, \(x) {
  f <- gzfile(x)
  # get the 180x360 matrix of values
  d <- as.matrix(read.delim(f, sep = "", header = FALSE, skip = 1))
  # row names based on latitude bands. We reverse labels to N is positive numbers
  rownames(d) <- rev(levels(cut(seq(-90, 90), breaks = 180, dig.lab = 2)))
  # West are negative longitude
  colnames(d) <- levels(cut(seq(-180, 180), breaks = 360, dig.lab = 2))
  # NA are encoded as -1
  d[d < 0] <- NA
  d
})

# Make the names of each 'layer' the year and month, then make 3D array,
# where the third dimension is year and month
names(mat_list) <- arrnames
arr <- simplify2array(mat_list)

saveRDS(arr, "data-raw/aerosol-thickness.RDS", compress = "xz")

# lat <- 48.5
# lon <- -128.6
# yearmonth <- "2000 06"
# latrow <- nrow(arr) - findInterval(lat, seq(-90, 90, length.out = 181), all.inside = TRUE) + 1
# loncol <- findInterval(lon, seq(-180, 180, length.out = 361), all.inside = TRUE)
#
# arr[latrow, loncol, yearmonth, drop = FALSE]

## Only include files from the 2000's, hopefully more representative of modern conditions
mat_list_2000s <- mat_list[grepl("^20", names(mat_list))]

# Set the names of the list elements to just the month component so
# we can aggregate by month
months <- vapply(strsplit(names(mat_list_2000s), " "), `[`, 2, FUN.VALUE = "")
names(mat_list_2000s) <- months

# Take monthly mean
arr_list_by_month <- lapply(unique(names(mat_list_2000s)), \(x) {
  # Get all list elements of that month
  y <- mat_list_2000s[names(mat_list_2000s) == x]

  # 'stack' all instances of that month, and take the mean of each cell
  y <- simplify2array(y)
  apply(y, c(1,2), mean, na.rm = TRUE)
})

# reapply names and stack, finally end up with 180x360x12 array (lat/long/month)
names(arr_list_by_month) <- unique(names(mat_list_2000s))
aerosol <- simplify2array(arr_list_by_month)

# lat <- 48.5
# lon <- -128.6
# month <- "06"
# latrow <- nrow(aerosol) - findInterval(lat, seq(-90, 90, length.out = 181), all.inside = TRUE) + 1
# loncol <- findInterval(lon, seq(-180, 180, length.out = 361), all.inside = TRUE)
#
# aerosol[latrow, loncol, month, drop = FALSE]
