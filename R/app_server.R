#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import firebase
#' @noRd
app_server <- function(input, output, session, random_question_order = TRUE) {
  # Your application server logic
  
  # set up reactive values
  start_app <- reactiveVal()
  start_time <- reactiveVal(Sys.time())
  auth_method <- reactiveVal()
  
  if (golem::app_prod()) {
    showModal(
      modalDialog(
        title = "Login",
        firebase::firebaseUIContainer(),
        size = "xl",
        footer = NULL
      )
    )
  }
  
  if (golem::app_prod()) {
    f <- firebase::FirebaseUI$
      new()$ # instantiate
      set_providers( # define providers
        google = TRUE,
        github = TRUE,
        microsoft = TRUE
      )$
      launch()
  }
  
  if (golem::app_prod()) observeEvent(f$req_sign_in(), removeModal(session))
  
  output$logged_in_ui <- renderUI({
    if (golem::app_dev()) whereami::cat_where(whereami::whereami())
    if (golem::app_prod()) {
      f$req_sign_in()
    }
    start_app(runif(1))
    ui_secret()
  })
  
  # load quiz data
  quiz_df <- load_quiz_df()
  n_questions <- nrow(quiz_df)
  question_vec <- 1:n_questions
  
  if (random_question_order) {
    quiz_df <- dplyr::slice_sample(quiz_df, n = n_questions, replace = FALSE)
  }
  
  observeEvent(start_app(), {
    showModal(
      modalDialog(
        title = "Welcome",
        mod_welcome_ui("welcome_ui_1"),
        size = "xl",
        footer = tagList(
          actionButton("dismiss_welcome", "Start")
        ),
        easyClose = FALSE
      )
    )
  })
  
  observeEvent(input$dismiss_welcome, {
    if (!is.null(start_app())) {
      if (golem::app_dev()) whereami::cat_where(whereami::whereami())
      
      purrr::walk(question_vec, ~{
        quiz_sub <- dplyr::slice(quiz_df, .x)

        insertTab(
          inputId = "tabs",
          tabPanel(
            glue::glue("Tab {.x}"),
            mod_question_ui(
              glue::glue("question_ui_{.x}"),
              question_index = .x,
              type = quiz_sub$type,
              question_text = quiz_sub$question_text,
              choices_value = purrr::as_vector(quiz_sub$choices_value),
              choices_text = purrr::as_vector(quiz_sub$choices_text)
            ),
            value = glue::glue("qtab{.x}")
          ))
      })
      
      insertTab(
        inputId = "tabs",
        tabPanel(
          "Conclusion",
          mod_complete_ui("complete_ui_1"),
          value = "conclusion"
        )
      )
      
      # select first question tab automatically
      updateTabsetPanel(
        session = session,
        inputId = "tabs",
        selected = "qtab1"
      )
      
      # remove placeholder tab
      removeTab(
        inputId = "tabs",
        target = "hello"
      )
      
      removeModal(session)
    }

  })
  
  # execute server-side question module
  answers_res <- purrr::map(question_vec, ~{
    quiz_sub <- dplyr::slice(quiz_df, .x)
    mod_question_server(
      glue::glue("question_ui_{.x}"), 
      question_index = .x, 
      quiz = quiz_sub$quiz, 
      qid = quiz_sub$qid,
      question_text = quiz_sub$question_text)
  })
  
  question_click_res <- mod_complete_server("complete_ui_1", answers_res)
  
  observeEvent(question_click_res(), {
    if (golem::app_dev()) whereami::cat_where(whereami::whereami())
    qtab <- glue::glue("qtab{question_click_res()}")
    updateTabsetPanel(
      inputId = "tabs",
      selected = qtab
    )
  })
  
  observeEvent(input$next_button, {
    # grab current tab
    current_tab <- input$tabs
    tab_number <- as.integer(stringr::str_extract(current_tab, "\\d+"))

    if (!shiny::isTruthy(answers_res[[tab_number]]()$answer)) {
      shinyWidgets::show_alert(
        title = "Oops!",
        text = "Please select or enter an answer before you continue.",
        type = "error"
      )
      return(NULL)
    }
    
    if (tab_number == n_questions) {
      next_tab <- "conclusion"
      updateTabsetPanel(
        inputId = "tabs",
        selected = next_tab
      )
    }
    
    if (tab_number < n_questions) {
      next_tab <- glue::glue("qtab{tab_number + 1}")
      updateTabsetPanel(
        inputId = "tabs",
        selected = next_tab
      )
    }

    start_time(Sys.time())
  })
  
  observeEvent(input$prev_button, {
    # grab current tab
    current_tab <- input$tabs
    
    if (current_tab == "qtab1") {
      next_tab <- "hello"
      updateTabsetPanel(
        inputId = "tabs",
        selected = next_tab
      )
    } else {
      if (current_tab == "conclusion") {
        prev_tab <- glue::glue("qtab{n_questions - 1}")
        updateTabsetPanel(
          inputId = "tabs",
          selected = prev_tab
        )
      }
      
      if (current_tab != "hello") {
        tab_number <- as.integer(stringr::str_extract(current_tab, "\\d+"))
        prev_tab <- glue::glue("qtab{tab_number - 1}")
        updateTabsetPanel(
          inputId = "tabs",
          selected = prev_tab
        )
      }
    }
  })

}
