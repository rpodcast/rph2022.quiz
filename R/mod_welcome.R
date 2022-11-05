#' welcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_welcome_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        h2("R/Pharma 202w Quiz Time!"),
        p("Ready to test your R knowledge? See how well you know the R package ecosystem on CRAN with this fun quiz!"),
        p("If you would like to see how you stack up to others in your R knowledge, you can opt-in to authenticating with your existing Google or GitHub accounts (or set up a custom email login) to be included in the leaderboard!")
      )
    )
  )
}
    
#' welcome Server Functions
#'
#' @noRd 
mod_welcome_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}
    
## To be copied in the UI
# mod_welcome_ui("welcome_1")
    
## To be copied in the server
# mod_welcome_server("welcome_1")
