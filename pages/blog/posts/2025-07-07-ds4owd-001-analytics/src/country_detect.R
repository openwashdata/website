# Helper function to detect country names from a free text column. It is based
# on the function countries::country_name with some extra steps particular to
# the nature of the data.
# The input is `x` a (vector of the type) character and `to` which accepts
# either `"name_en"` or `"ISO3"` as value. The function returns the name(s) or
# ISO code(s) of the country.

if(!require("countries")) install.packages("countries")

country_detect <- function(x, to = "name_en"){
  stopifnot(to %in% c("name_en", "ISO3"))
  x <- tolower(x)
  x <- stringr::str_replace(x, "england - ", "")
  x <- stringr::str_replace(x, "kampala", "uganda")
  cond <- str_detect(x, "/|,")
  x <- case_when(
    !cond                  ~ countries::country_name(x, to = to),
    cond & to == "name_en" ~ countries::country_name(x, to = to),
    cond & to == "ISO3"    ~ NA_character_
  ) |> 
    suppressMessages()
  return(x)
}
