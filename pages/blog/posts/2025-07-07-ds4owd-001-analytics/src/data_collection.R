# this script loads all the data related to the first iteration of the course
# Data science for open WASH data from a PostgreSQL database and Google Sheets.
# Permissions are required for accessing both data sources.

library(DBI)
library(googlesheets4)

source("country_detect.R")

# See https://github.com/r-lib/keyring?tab=readme-ov-file#readme and
# ?keyring::key_set for securely managing credentials

db_user <- keyring::key_list("ds4owd-DB")[1,2]
db_pwd <- keyring::key_get("ds4owd-DB", db_user)

# open database connection
con <- dbConnect(
  RPostgres::Postgres(),
  host = "id-hdb-psgr-ct39.ethz.ch",
  port = 5432,
  user = db_user,
  password = db_pwd,
  dbname = "openwashdata"
)

# check table names
#dbListTables(con)

# check field names of a specific table
#dbListFields(con, "publishing_metadata")

# get tables in R environment

pre_survey <- dbGetQuery(con, "SELECT * FROM presurvey")

post_survey <- dbGetQuery(con, "SELECT * FROM postsurvey")

course_participation <- dbGetQuery(con, "SELECT * FROM course_participation")

positcloud_usage <- dbGetQuery(con, "SELECT * FROM pscloud")

published_datasets <- dbGetQuery(con, "SELECT * FROM publishing_metadata")

visits_country <- dbGetQuery(con, 'SELECT * FROM "ds4owd-001_country_data"')

visits_ts <- dbGetQuery(con, 'SELECT * FROM "ds4owd-001_timeseries_data"')

location <- dbGetQuery(con, "SELECT * FROM locations")

# close database connection
dbDisconnect(con)

# read full registration data from Google Sheets
registration <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/11hw0nR7C5XoRVRw2sVwoG6xSz6BP2q5qM4t7zZyvGUA/edit?gid=2049186152#gid=2049186152")

registration_colnames <- c("timestamp",
                           "github_username",
                           "orcid",
                           "email",
                           "programming_experience",
                           "r_experience",
                           "programming_task",
                           "data_storage",
                           "llm_usage",
                           "organisation_type",
                           "time_barrier",
                           "supervisor_barrier",
                           "internet_barrier",
                           "electricity_barrier",
                           "computer_barrier",
                           "expectations",
                           "participation_country",
                           "wash_connection",
                           "dataset_identification",
                           "code_of_conduct",
                           "data_privacy",
                           "comments")

registration <- registration |> 
  set_names(registration_colnames) |> 
  mutate(country = country_detect(participation_country),
         country_ISO3 = country_detect(participation_country, to = "ISO3"),
         organisation_type = if_else(str_detect(string = organisation_type, 
                                                pattern = "NGO"),
                                     "NGO",
                                     organisation_type))
