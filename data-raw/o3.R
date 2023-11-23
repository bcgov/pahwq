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

lines <- readLines("inst/tuv_data/DATAE1/ATM/o3column.dat")
# The file is a several metadata rows, then alternating rows with a "Month x" row,
# followed by a row of 17 values.
monthrows <- grep("[M,m]onth", lines)
# remove month rows
datalines <- lines[-monthrows]
# Remove headers
datalines <- datalines[monthrows[1]:length(datalines)]
lst <- strsplit(trimws(datalines, which = "both"), "\\s+")
o3 <- do.call("rbind", lapply(lst, as.numeric))
colnames(o3) <- levels(cut(seq(-85, +85), breaks = 17, dig.lab = 2))
o3 <- as.data.frame(o3)
o3$month <- month.name

# find the latitude interval (i.e., the column) with:
# lat <- 48 # 14th column
# month <- "January" # 1st row
# latcol <- findInterval(lat, seq(-85, +85, length.out = 18), all.inside = TRUE)
# o3[o3$month == month, latcol]
#> 375.5181
