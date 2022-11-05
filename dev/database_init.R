library(DBI)
library(RPostgres)

# docker container postgres db
con <- DBI::dbConnect(
  RPostgres::Postgres(),
  host = "quizpostgresdb",
  dbname = "postgres",
  port = 5432,
  user = "postgres",
  password = "shiny"
)