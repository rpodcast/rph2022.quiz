#' prevent_timeout UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_prevent_timeout_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' prevent_timeout Server Functions
#'
#' @noRd 
mod_prevent_timeout_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_prevent_timeout_ui("prevent_timeout_1")
    
## To be copied in the server
# mod_prevent_timeout_server("prevent_timeout_1")
