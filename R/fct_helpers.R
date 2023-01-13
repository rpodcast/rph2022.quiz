#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @import dplyr
#' @import pins
#' @noRd
load_quiz_df <- function(prod = golem::app_prod()) {
  if (prod) {
    board <- board_rsconnect(auth = "envvar")
    quiz_df <- pin_read(board, "rpodcast/quiz_df")
  } else {
    board <- board_folder("dev/board_local")
    quiz_df <- pin_read(board, "quiz_df")
  }
  return(quiz_df)
}

get_user_info <- function(prod = golem::app_prod(), firebase_list = NULL) {
  if (prod) {
    # obtain user information from firebase list produced by f$get_signed_in()
    uid <- firebase_list$response$uid
    display_name <- firebase_list$response$displayName
    email <- firebase_list$response$email
  } else {
    uid <- uuid::UUIDgenerate(output = "string")
    display_name <- randomNames::randomNames(n = 1, name.order = "first.last", name.sep = " ")
    email <- paste0(display_name, "@this_is_not_real.com")
  }
  return(
    list(
      uid = uid,
      display_name = display_name,
      email = email
    )
  )
}

db_con <- function(prod = golem::app_prod(), table_name = "rphquiz") {
  # create empty table with default columns
  df <- tibble::tibble(
    quiz = integer(),
    qid = integer(),
    question_index = integer(),
    question_text = character(),
    answer = character(),
    uid = character(),
    display_name = character(),
    email = character()
  )
  
  if (prod) {
    con <- pool::dbPool(
      drv = RPostgres::Postgres(),
      dbname = "postgres",
      host = Sys.getenv("PG_HOST"),
      port = Sys.getenv("PG_PORT"),
      password = Sys.getenv("PG_PASSWORD"),
      user = Sys.getenv("PG_USER")
    )
  } else {
    con <- DBI::dbConnect(
      RSQLite::SQLite(),
      dbname = ":memory:"
    )
  }
  
  # create table if not present already
  if (!table_name %in% DBI::dbListTables(con)) {
    DBI::dbCreateTable(con, table_name, df)
  }
  
  return(con)
}

quiz_sub_exists <- function(con, uid, table_name = "rphquiz", prod = golem::app_prod()) {
  # if table does not exist or has 0 rows, then no submissions yet
  if (!table_name %in% DBI::dbListTables(con)) return(FALSE)
  
  # grab existing uid entries
  exist_sql <- "SELECT DISTINCT uid FROM rphquiz;"
  exist_uids <- DBI::dbGetQuery(con, exist_sql)$uid
  if (length(exist_uids) < 1) return(FALSE)
  uid %in% exist_uids
}