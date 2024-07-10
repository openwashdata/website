
library(yaml)
library(googlesheets4)
library(tidyverse)

# source functions --------------------------------------------------------

source(here::here("R/df_to_yaml.R"))

# read data ---------------------------------------------------------------

read_sheet("1Yz85CRRoenpnpT2PnUeIhiXgLuLzymu-LKiRP3eWRsk") |> 
    select(name:repo_name, title:public_link, data_package, status = starts_with("status ")) |> 
    filter(status == "reviewed") |> 
    write_csv(here::here("pages/academy/graduates/data/tbl-06-capstone-projects-completed.csv"))

graduates <- read_csv(here::here("pages/academy/graduates/data/tbl-06-capstone-projects-completed.csv")) |> 
    select(name, surname, profile_link, github_username, title, published, public_link, data_package)

graduates_tidy <- graduates |> 
    mutate(author = case_when(
        is.na(surname) == TRUE ~ " - ",
        TRUE ~ paste(name, surname)
    )) |> 
    mutate(author = case_when(
        is.na(profile_link) != TRUE ~ paste0("[", author, "]", "(", profile_link, ")"),
        TRUE ~ author
    )) |> 
    mutate(data_package = case_when(
        is.na(data_package) == TRUE ~ "open data in project GitHub repository",
        TRUE ~ data_package
    )) |> 
    mutate(github_username = paste0("[", github_username, "]", "(https://github.com/", github_username, ")")) |> 
    mutate(public_link = case_when(
        published == "private" ~ "project report is set to private on GitHub",
        TRUE ~ public_link
    )) |> 
    select(-name, -surname, -profile_link)

# functions


df_to_yaml(graduates_tidy, here::here("pages/academy/graduates/data/graduates.yml"))
