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
mod_complete_server <- function(id, answers_res, user_info, con, table_name = "rphquiz"){
  moduleServer( id, function(input, output, session){
    disconnected <- tagList(
      h1("Enjoy your break!"),
      p("The R/Pharma conference will resume in just a few minutes.")
    )
    
    sever::sever(
      html = disconnected,
      #bg_color = "rgba(0,0,0,0)",
      box = TRUE
    )
    
    ns <- session$ns
    
    question_click_res <- mod_qtable_server("qtable_1", answers_res)
    
    question_click <- reactive({
      question_click_res()
    })
    
    observeEvent(input$qsubmit, {
      if (golem::app_dev()) whereami::cat_where(whereami::whereami())
      
      # if user has already submitted their answers, leave the app
      if (quiz_sub_exists(con, uid = user_info$uid)) {
        showModal(
          modalDialog(
            title = "Repeat Entries not Allowed!",
            p(glue::glue("Hello, {user_info$display_name}! We already received your answers from an earlier submission. We will contact you at {user_info$email} with your result and if you won the quiz prizes!")),
            size = "xl",
            footer = tagList(
              actionButton(ns("app_exit"), "Close")
            ),
            easyClose = FALSE
          )
        )
      } else {
        answers_res1 <- purrr::map(answers_res, ~{ tmp <- .x()})
        # assemble tibble of user info and questions
        df <- purrr::map_df(1:length(answers_res1), ~{
          tibble::tibble(
            quiz = answers_res[[.x]]()$quiz,
            qid = answers_res[[.x]]()$qid,
            question_index = answers_res[[.x]]()$question_index,
            question_text = answers_res[[.x]]()$question_text,
            answer = as.character(answers_res[[.x]]()$answer)
          ) 
        }) 
        df$uid <- user_info$uid
        df$display_name <- user_info$display_name
        df$email <- user_info$email
        
        # write to database
        DBI::dbAppendTable(con, table_name, df)
        
        showModal(
          modalDialog(
            title = "Answers Submitted!",
            p(glue::glue("Thank you, {user_info$display_name}! Your quiz answers have been submitted for evaluation. We will contact you at {user_info$email} with your result and if you won the quiz prizes!")),
            size = "xl",
            footer = tagList(
              actionButton(ns("app_exit"), "Close")
            ),
            easyClose = FALSE
          )
        )
      }
    })
    
    observeEvent(input$app_exit, {
      removeModal(session)
      Sys.sleep(0.5)
      stopApp()
    })
    
    question_click
  })
}
    
## To be copied in the UI
# mod_complete_ui("complete_1")
    
## To be copied in the server
# mod_complete_server("complete_1")
