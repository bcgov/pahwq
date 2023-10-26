# Run this file to get the TUV source code from the TUV directory before compiling.

dir <- "~/dev/TUV/V5.4"

files <- list.files(dir)
dirs <- list.dirs(dir, recursive = FALSE, full.names = FALSE)

files <- setdiff(files, c(dirs, "tuv", "tuv.exe", "tuvlog.txt"))

file.copy(file.path(dir, files), "src", overwrite = TRUE)
file.copy("src/Makefile", "src/Makefile.win", overwrite = TRUE)
