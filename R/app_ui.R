#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import firebase
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      theme = bslib::bs_theme(
        bootswatch = "sketchy",
        base_font = bslib::font_google("Klee One"),
        heading_font = bslib::font_google("Klee One"),
        font_scale = 2
      ),
      #if (golem::app_prod()) firebaseUIContainer(),
      uiOutput("logged_in_ui")
    )
  )
}

#' @import shiny
#' @import bslib
#' @noRd
ui_secret <- function() {
  tagList(
    fluidRow(
      col_12(
        tabsetPanel(
          id = "tabs",
          type = "hidden",
          #type = "tabs",
          tabPanel(
            title = "Hello",
            h1("Hello tab"),
            value = "hello"
          )
        )
      )
    ),
    fluidRow(
      col_2(
        actionButton(
          inputId = "prev_button",
          "Back"
        )
      ),
      col_2(
        actionButton(
          inputId = "next_button",
          "Next"
        )
      )
    )
  )
  #)
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "rph2022.quiz"
    ),
    firebase::useFirebase()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
