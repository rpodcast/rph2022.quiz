#' qtable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import reactable
mod_qtable_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactable::reactableOutput(ns("table"))
  )
}
    
#' qtable Server Functions
#'
#' @noRd 
mod_qtable_server <- function(id, answers_res){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    question_click <- reactiveVal()
    
    # reactive for table click
    observeEvent(input$goto_question, {
      question_click(input$goto_question$index)
    })
    
    # question_click <- reactive({
    #   req(input$goto_question)
    #   message(input$goto_question)
    #   input$goto_question
    # })
    
    output$table <- renderReactable({
      df <- purrr::map_df(1:length(answers_res), ~{
        tibble::tibble(
          question_index = answers_res[[.x]]()$question_index,
          question_text = answers_res[[.x]]()$question_text,
          answer = as.character(answers_res[[.x]]()$answer)
        )
      })
      
      reactable(
        df,
        columns = list(
          question_index = colDef(
            name = "",
            sortable = FALSE,
            cell = function(value, index) {
              qid <- df$question_index[index]
              htmltools::tags$button(glue::glue("Question {qid}"))
            },
            width = 120
          ),
          question_text = colDef(
            name = "Question",
            sortable = FALSE,
            width = 400
          ),
          answer = colDef(
            name = "Your Answer",
            sortable = FALSE,
            width = 150
          )
        ),
        theme = reactableTheme(
          style = list(fontSize = "16px", backgroundColor = "rgba(0,0,0,0)")
        ),
        onClick = JS(glue::glue("function(rowInfo, column) {
          // Only handle click events on the 'question_index' column
          if (column.id !== 'question_index') {
            return
          }
          
          // Send click event to Shiny which will be available in input$goto_question
          // Note that the row index starts at 0 in JavaScript, so we add 1
          if (window.Shiny) {
            Shiny.setInputValue('<<id>>', { index: rowInfo.index + 1 }, { priority: 'event' })
          }
        }", id = ns("goto_question"), .open = "<<", .close = ">>")
        )
      )
    })
    
    question_click
  })
}
    
## To be copied in the UI
# mod_qtable_ui("qtable_1")
    
## To be copied in the server
# mod_qtable_server("qtable_1")
