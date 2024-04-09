# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain
# the course data. Each table is read and stored locally as a CSV.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)

# script ------------------------------------------------------------------

## PLOS Webinar

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

## WASHWeb webinar

sheet_washweb <- "https://docs.google.com/spreadsheets/d/1tTCgtxKsFZwvrmYysr34fnDyVtzuWS9BXjuwbENg3bM/edit#gid=0"

tbl_washweb <- googlesheets4::read_sheet(ss = sheet_washweb) |>
    select(-duration) |> 
    mutate(speaker_1 = case_when(
        is.na(speaker_1) == FALSE ~ paste0("[", speaker_1, "](", speaker_link_1, "/)"),
        TRUE ~ " "
    )) |> 
    mutate(speaker_2 = case_when(
        is.na(speaker_2) == FALSE ~ paste0("/ [", speaker_2, "](", speaker_link_2, "/)"),
        TRUE ~ " "
    )) |>
    mutate(affiliation = paste0("[", affiliation, "](", affiliation_link, "/)")) |>
    mutate(affiliation_2 = case_when(
        is.na(affiliation_2) == FALSE ~ paste0("/ [", affiliation_2, "](", speaker_link_2, "/)"),
        TRUE ~ " "
    )) |>
    mutate(start_time = as.character(start_time)) |>
    mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(end_time = as.character(end_time)) |>
    mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(time = paste(start_time, end_time, sep = " - ")) |> 
    unite(col = "speaker", c(speaker_1, speaker_2), sep = " ") |> 
    unite(col = "affiliation", c(affiliation, affiliation_2), sep = " ")


tbl_washweb |> 
    write_csv(here::here("pages/events/2024-04-04-webinar-washweb/data/tbl-05-washweb-webinar-agenda.csv"))

## Workshop

sheet_workshop <- "https://docs.google.com/spreadsheets/d/1d4I9TDNfxwIdRoe-T6FnJ6m3cpEC3V7u75Ne7B4fYKw/edit#gid=0"

googlesheets4::read_sheet(ss = sheet_workshop, range = "Sheet1!A1:G16") |> 
    bind_rows(googlesheets4::read_sheet(ss = sheet_workshop, range = "Sheet1!A19:G27")) |>  
    select(-duration) |> 
    mutate(start_time = as.character(start_time)) |>
    mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(end_time = as.character(end_time)) |>
    mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
    mutate(time = paste(start_time, end_time, sep = " - ")) |>  
    select(-...6) |> 
    write_csv(here::here("pages/events/2024-08-09-workshop-washweb/data/tbl-09-workshop-ghe-washweb.csv"))




