
library(yaml)
library(googlesheets4)
library(tidyverse)

# source functions --------------------------------------------------------

source(here::here("R/df_to_yaml.R"))

# read data ---------------------------------------------------------------

read_sheet("https://docs.google.com/spreadsheets/d/1CZJuDshsUv6A-N-2fwzMElndG8Oig3N8PSv4h5lmefU/edit?gid=0#gid=0") |> 
    write_csv(here::here("pages/events/events_data/tbl-11-openwashdata-events.csv"))

events <- read_csv(here::here("pages/events/events_data/tbl-11-openwashdata-events.csv")) |> 
    mutate(date = lubridate::as_date(date))

# functions

df_to_yaml(events, here::here("pages/events/events_data/events.yml"))
