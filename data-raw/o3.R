## code to prepare `o3` dataset goes here

lines <- readLines("inst/tuv_data/DATAE1/ATM/o3column.dat")
datalines <- lines[5:27][seq(1, 23, 2)]
lst <- strsplit(datalines, "\\s+")
o3 <- do.call("rbind", lapply(lst, as.numeric))[, -1]
colnames(o3) <- levels(cut(seq(-85, +85), breaks = 17, dig.lab = 2))
o3 <- as.data.frame(o3)
o3$month <- month.abb

# find the latitude interval (i.e., the column) with:
# findInterval(-86, seq(-85, +85, length.out = 18), all.inside = TRUE)

usethis::use_data(o3, internal = TRUE, overwrite = TRUE)
