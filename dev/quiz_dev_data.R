# create list object of random questions that mimic structure of real quiz data
library(dplyr)
library(tidyr)
library(pins)

# define development version of quiz items
quiz_items <- list(
  list(
    quiz = 1,
    qid = 1,
    question_text = "What is the color of the sky?",
    type = "choice",
    choices_value = c("blue", "cyan", "green", "red"),
    choices_text = c("Blue, of course", "Maybe Cyan", "Green like money", "Crimson red"),
    answer = "blue",
    answer_text = "The sky is blue!"
  ),
  list(
    quiz = 1,
    qid = 2,
    question_text = "How many licks does it take to get to the center of a Tootsie Pop?",
    type = "number",
    answer = 20,
    answer_text = "The correct answer is 20. Otherwise the world may never know."
  ),
  list(
    quiz = 1,
    qid = 3,
    question_text = "Who is the head of the table in WWE?",
    type = "text",
    answer = "Roman Reigns",
    answer_text = "He is also the tribal chief: Roman Reigns!"
  )
)

saveRDS(quiz_items, file = "dev/quiz_items.rds")

# convert to tidy data frame for use with Pins later
quiz_df <- tibble::tibble(quiz_items) %>%
  unnest_wider(quiz_items)

saveRDS(quiz_df, file = "dev/quiz_df.rds")

# send to a pinboard in a local directory
board_dev <- board_folder("dev/board_local")
board_dev %>%
  pin_write(quiz_items, "quiz_items")

board_dev %>%
  pin_write(quiz_df, "quiz_df")

# define production version of quiz items
# load from dev/prototyping/quiz1_items.rds
quiz_items_prd <- readRDS("dev/prototyping/quiz1_items.rds")

quiz_df_prd <- tibble::tibble(quiz_items_prd) %>%
  unnest_wider(quiz_items_prd)

# save to a pinboard in custom rstudio connect server
board_rsconnect <- board_rsconnect(auth = "envvar")

board_rsconnect %>%
  pin_write(quiz_items_prd, "quiz_items")

board_rsconnect %>%
  pin_write(quiz_df_prd, "quiz_df")