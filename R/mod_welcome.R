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
        h2("R/Pharma 2022 Quiz Time!"),
        p("Ready to test your R knowledge? See how well you know the R package ecosystem on CRAN with this fun quiz!"),
        p("Authenticate with your existing Google, GitHub, or Microsoft account to be included in the leaderboard for bragging rights (and perhaps a prize)!")
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
