
library(yaml)
library(googlesheets4)
library(tidyverse)

# read data ---------------------------------------------------------------

read_sheet("1Yz85CRRoenpnpT2PnUeIhiXgLuLzymu-LKiRP3eWRsk") |> 
    select(name:repo_name, title:public_link, data_package, status = starts_with("status ")) |> 
    filter(status == "reviewed") |> 
    write_csv(here::here("pages/academy/graduates/data/tbl-06-capstone-projects-completed.csv"))

graduates <- read_csv(here::here("pages/academy/graduates/data/tbl-06-capstone-projects-completed.csv")) |> 
    select(name, surname, github_username, title, published, public_link, data_package)

graduates_tidy <- graduates |> 
    mutate(author = case_when(
        is.na(surname) == TRUE ~ " - ",
        TRUE ~ paste(name, surname)
    )) |> 
    mutate(data_package = case_when(
        is.na(data_package) == TRUE ~ "open data in GitHub repository",
        TRUE ~ data_package
    )) |> 
    mutate(github_username = paste0("[", github_username, "]", "(https://github.com/", github_username, ")")) |> 
    mutate(public_link = case_when(
        published == "private" ~ "project report is set to private on GitHub",
        TRUE ~ public_link
    )) |> 
    select(-name, -surname)

# functions

df_to_yaml <- function(df, output_file) {
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

df_to_yaml(graduates_tidy, here::here("pages/academy/graduates/data/graduates.yml"))
