# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain
# the course data. Each table is read and stored locally as a CSV.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)

# script ------------------------------------------------------------------


sheet <- "https://docs.google.com/spreadsheets/d/1xEmiCTq0n98fB-m8ArHjTgh55CByTgQH7rKFECY1fRc/edit#gid=0"

googlesheets4::read_sheet(ss = sheet) |>
    select(-duration) |> 
    mutate(speaker = paste0("[", speaker, "](", speaker_link, "/)")) |>
    mutate(affiliation = paste0("[", affiliation, "](", affiliation_link, "/)")) |>
    mutate(start_time = as.character(start_time)) |>
    mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(end_time = as.character(end_time)) |>
    mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(time = paste(start_time, end_time, sep = " - ")) |> 
    write_csv(here::here("pages/events/2023-01-24-webinar-data-publishing/data/tbl-07-webinar-data-sharing-agenda.csv"))
