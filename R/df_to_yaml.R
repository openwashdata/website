#' Convert a data frame to YAML format and write to a file
#'
#' This function takes a data frame and converts it to YAML format, with each row
#' represented as a separate YAML entry. The resulting YAML is then written to
#' the specified output file.
#'
#' @param df A data frame to be converted to YAML format.
#' @param output_file A character string specifying the path and name of the
#'   output YAML file.
#'
#' @return None. The function writes the YAML content to the specified file and
#'   prints a success message to the console.
#'
#' @details
#' The function performs the following steps:
#' 1. Converts each row of the input data frame to a YAML string.
#' 2. Adds proper indentation and a dash (-) to each YAML entry.
#' 3. Combines all YAML entries with an empty line between each.
#' 4. Writes the resulting YAML string to the specified output file.
#'
#' @examples
#' # Create a sample data frame
#' df <- data.frame(
#'   name = c("Alice", "Bob"),
#'   age = c(30, 35),
#'   birthdate = as.Date(c("1990-01-01", "1985-05-15"))
#' )
#'
#' # Convert to YAML and write to a file
#' df_to_yaml(df, "output.yaml")
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom yaml as.yaml
df_to_yaml <- function(df, output_file) {
    # Convert date columns to character to prevent conversion to numeric
    date_columns <- sapply(df, inherits, "Date")
    df[date_columns] <- lapply(df[date_columns], as.character)
    
    # Convert each row to a YAML string with proper indentation
    yaml_entries <- df %>%
        split(1:nrow(.)) %>%
        lapply(function(row) {
            yaml_string <- as.yaml(as.list(row), indent = 2, indent.mapping.sequence = TRUE)
            # Add dash to the first line and indent the rest
            yaml_lines <- strsplit(yaml_string, "\n")[[1]]
            paste0("- ", yaml_lines[1], "\n  ", paste(yaml_lines[-1], collapse = "\n  "))
        })
    
    # Combine the YAML strings with an empty line between each entry
    yaml_string <- paste(yaml_entries, collapse = "\n\n")
    
    # Write to file
    writeLines(yaml_string, output_file)
    
    cat("YAML file created successfully:", output_file, "\n")
}
