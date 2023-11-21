library(rvest)
library(dplyr)

base_url <- "https://gacp.giss.nasa.gov/data/time_ser"

file_tables <- read_html(base_url) |>
  html_table() |>
  bind_rows()

urls <- file.path(base_url, file_tables$File)

# urls <- c(
#   "https://gacp.giss.nasa.gov/data/time_ser/0001.tau.ascii.gz",
#   "https://gacp.giss.nasa.gov/data/time_ser/0002.tau.ascii.gz"
# )

dir <- withr::local_tempdir("files")

files <- lapply(urls, \(x) {
  localfile <- file.path(dir, basename(x))
  download.file(x, localfile)
  localfile
})

files <- files[!grepl("README", files)]

# Get the year and month of the data from the first row
arrnames <- vapply(files, \(x) {
  f <- gzfile(x)
  readLines(f, n = 1L)
}, FUN.VALUE = character(1))

mats <- lapply(files, \(x) {
  f <- gzfile(x)

  # get the 180x360 matrix of values
  d <- as.matrix(read.delim(f, sep = "", header = FALSE, skip = 1))

  rownames(d) <- levels(cut(seq(90, -90), breaks = 180, dig.lab = 2))
  colnames(d) <- levels(cut(seq(180, -180), breaks = 360, dig.lab = 2))

  # NA are encoded as -1
  d[d < 0] <- NA
  d
})

arr <- simplify2array(mats)
dimnames(arr)[[3]] <- arrnames

saveRDS(arr, "data-raw/aerosol-thickness.RDS", compress = "xz")
