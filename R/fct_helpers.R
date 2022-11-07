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