#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_quiz_df <- function(prod = golem::app_prod()) {
  if (prod) {
    #TODO: add call to pinboard
    quiz_df <- readRDS("dev/quiz_df.rds")
  } else {
    quiz_df <- readRDS("dev/quiz_df.rds")
  }
  return(quiz_df)
}