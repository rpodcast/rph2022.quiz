#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import firebase
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  # set up reactive values
  start_app <- reactiveVal(runif(1))
  start_time <- reactiveVal(Sys.time())
  auth_method <- reactiveVal()
  
  #f <- FirebaseSocial$new()
  f <- firebase::FirebaseUI$
    new()$ # instantiate
    set_providers( # define providers
      email = TRUE,
      google = TRUE,
      github = TRUE
    )

  
  if (golem::app_prod()) {
    showModal(
      modalDialog(
        title = "Login",
        firebase::firebaseUIContainer(),
        # actionButton("google", "Google", icon = icon("google"), class = "btn-danger"),
        # actionButton("github", "GitHub", icon = icon("github")),
        # actionButton("email", "Email"),
        footer = NULL
      )
    )
    f$launch()
  }
  
  # observeEvent(input$google, {
  #   auth_method("google")
  #   f$launch_google()
  # })
  # 
  # observeEvent(input$github, {
  #   auth_method("github")
  #   f$launch_github()
  # })
  # 
  # observe({
  #   f$req_sign_in()
  #   removeModal()
  # })
  
  observeEvent(f$req_sign_in(), removeModal(session))
  
  output$logged_in_ui <- renderUI({
    f$req_sign_in()
    # if (golem::app_prod()) {
    #   req(auth_method())
    #   browser()
    #   f$req_sign_in()
    # }
    ui_secret()
  })
  

}
