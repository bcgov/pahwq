# Helpers shared by the data-raw scripts

# Add the Cx- prefix to the second chemical in combined homologue groups, e.g.
# "C1-Fluoranthenes/Pyrenes" -> "C1-Fluoranthenes/C1-Pyrenes"
prefix_groups <- function(x) {
  gsub("^(C[1-4]-)(.+)/(.+)", "\\1\\2/\\1\\3", x)
}
