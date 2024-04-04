# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain data
# for the proposal. Google Sheets are edited manually and data is then read
# from here and stored locally as CSVs.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)

# script ------------------------------------------------------------------

## tbl-01-work-packages --------------------------------------------------

## Note: Update the Google Sheet ID with your copy of the table

read_sheet("1HlkM57AwrUfKeuGh9rR6kCOW8US6i_Ft-lVVS5xCflY") |> 
  write_csv(here::here("data/tables/tbl-01-work-packages.csv"))

## tbl-02-wp-activities-research-questions.csv ------------------------------

## Note: Update the Google Sheet ID with your copy of the table

read_sheet("1KbxWuLBKi2mEWWeE935yR5bqoZskq6Joe-6-PviqXsY") |> 
  write_csv(here::here("data/tables/tbl-02-wp-activities-research-questions.csv"))


## tbl-03-eth-ord-budget-templa-----------------------------------------------

## copy/paste the final budget table into the DOCX template
## Note: Update the Google Sheet ID with your copy of the table

read_sheet("1jl2yIyX7-xsnawdO26IlJY5hcOhD0Bzg9j7yt3p47uc") |> 
  write_csv(here::here("data/tables/tbl-03-eth-ord-budget-template.csv"))

## tbl-04-budget-justification -----------------------------------------------

## copy/paste the final budget table into the DOCX template
## Note: Update the Google Sheet ID with your copy of the table

read_sheet("1DHb4j8t1yhV1AyFqCY0ZkpAUwDQT2JArBAeXgiWUmNM") |> 
  write_csv(here::here("data/tables/tbl-04-budget-justification.csv"))


## tbl-05-openwashdata-ghe-ukzn-budget -----------------------------------------------

read_sheet("1nYhnR2o7IdmRAq9JMK4fqE4bApAAN6rqKT5LEmJDUYU") |> 
  write_csv(here::here("data/tables/tbl-05-openwashdata-ghe-ukzn-budget.csv"))


