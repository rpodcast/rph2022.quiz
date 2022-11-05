#' authentication UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_authentication_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' authentication Server Functions
#'
#' @noRd 
mod_authentication_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_authentication_ui("authentication_1")
    
## To be copied in the server
# mod_authentication_server("authentication_1")
