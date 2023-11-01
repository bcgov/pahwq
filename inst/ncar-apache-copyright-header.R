write_license_header <- function (file) {
  conn <- file(file)
  on.exit(close(conn))
  in_text <- readLines(conn)
  licence_text <- c(
    "Copyright 2023 National Center for Atmospheric Research",
    "",
    "Licensed under the Apache License, Version 2.0 (the \"License\");",
    "you may not use this file except in compliance with the License.",
    "You may obtain a copy of the License at",
    "",
    "http://www.apache.org/licenses/LICENSE-2.0",
    "",
    "Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an \"AS IS\" BASIS,",
    "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.",
    "See the License for the specific language governing permissions and limitations under the License."
  )
  licence_text <- paste("!", licence_text)

  out_text <- c(licence_text, "", in_text)
  writeLines(out_text, conn)
  invisible(TRUE)
}

files <- list.files("src", full.names = TRUE, pattern = "\\.f$")

lapply(files, write_license_header)
