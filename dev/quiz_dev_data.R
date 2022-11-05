# create list object of random questions that mimic structure of real quiz data

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
