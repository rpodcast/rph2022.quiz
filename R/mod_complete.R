#' complete UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_complete_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        h2("All done!"),
        p("Here is a recap of the answers you provided. If you wish to change any of them now, click the button corresponding to the question in the table below", style = "font-size: 20px;"),
        mod_qtable_ui(ns("qtable_1")),
        actionButton(
          inputId = ns("qsubmit"),
          label = "Submit",
          icon = icon("check"),
          class = "btn-success"
        )
      )
    )
  )
}
    
#' complete Server Functions
#'
#' @noRd 
mod_complete_server <- function(id, answers_res){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    question_click_res <- mod_qtable_server("qtable_1", answers_res)
    
    question_click <- reactive({
      question_click_res()
    })
    
    observeEvent(input$qsubmit, {
      if (golem::app_dev()) whereami::cat_where(whereami::whereami())
      answers_res1 <- purrr::map(answers_res, ~{ tmp <- .x()})
      
      shinyWidgets::show_alert(
        title = "Yes!",
        text = glue::glue("Thank you! Your answers have been submitted"),
        type = "success"
      )
    })
    
    question_click
 
  })
}
    
## To be copied in the UI
# mod_complete_ui("complete_1")
    
## To be copied in the server
# mod_complete_server("complete_1")
