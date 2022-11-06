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
    
    observeEvent(input$qsubmit, {
      if (golem::app_dev()) whereami::cat_where(whereami::whereami())
      answers_res1 <- purrr::map(answers_res, ~{ tmp <- .x()})
      
      shinyWidgets::show_alert(
        title = "Yes!",
        text = glue::glue("Thank you! Your answers have been submitted"),
        type = "success"
      )
    })
 
  })
}
    
## To be copied in the UI
# mod_complete_ui("complete_1")
    
## To be copied in the server
# mod_complete_server("complete_1")
