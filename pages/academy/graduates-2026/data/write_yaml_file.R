
library(yaml)
library(tidyverse)

# source functions --------------------------------------------------------

source(here::here("R/df_to_yaml.R"))

# read data ---------------------------------------------------------------

graduates <- read_csv(here::here("pages/academy/graduates-2026/data/tbl-capstone-projects-completed-2026.csv"))

graduates_tidy <- graduates |>
    mutate(github_username = paste0("[", github_username, "]", "(https://github.com/", github_username, ")")) |>
    mutate(public_link = case_when(
        github_username == "[rayprinz99](https://github.com/rayprinz99)" ~ "project report is set to private on GitHub",
        TRUE ~ paste0("<", public_link, ">")
    )) |>
    arrange(author)

# write yaml file ---------------------------------------------------------

df_to_yaml(graduates_tidy, here::here("pages/academy/graduates-2026/data/graduates-2026.yml"))
