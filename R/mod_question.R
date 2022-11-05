#' question UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_question_ui <- function(
    id, 
    question_index = 1, 
    type = "choice",
    question_text = "Hello there?",
    choices_value = c("a", "b"),
    choices_text = c("A", "B"),
    random_order = TRUE) {
  
  ns <- NS(id)
  
  if (type == "choice") {
    if (random_order) {
      ind <- sample(1:length(choices_value), length(choices_value), replace = FALSE)
      choices_text <- choices_text[ind]
      choices_value <- choices_value[ind]
    }
    
    ui_item <- radioButtons(
      inputId = ns("qinput"),
      label = question_text,
      choiceNames = choices_text,
      choiceValues = choices_value,
      selected = character(0),
      width = "100%"
    )
  } else if (type == "text") {
    ui_item <- textInput(
      inputId = ns("qinput"),
      label = question_text,
      value = character(0),
      width = "100%"
    )
  } else if (type == "number") {
    ui_item <- numericInput(
      inputId = ns("qinput"),
      label = question_text,
      value = 0,
      width = "100%"
    )
  } else {
    stop("Unknown question type", call. = FALSE)
  }
  
  tagList(
    fluidRow(
      col_12(
        h2(glue::glue("Question {question_index}")),
        ui_item
      )
    )
  )
}
    
#' question Server Functions
#'
#' @noRd 
mod_question_server <- function(id, question_index = 1, quiz = 1, qid = 1){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    res <- reactive({
      if (is.null(input$qinput)) {
        return(NULL)
      } else {
        res <- list(
          question_index = question_index,
          quiz = quiz,
          qid = qid,
          answer = input$qinput
        )
        return(res)
      }
    })
    
    res
    
  })
}
    
## To be copied in the UI
# mod_question_ui("question_1")
    
## To be copied in the server
# mod_question_server("question_1")
