# Observers allow you to:
#   - save file to a network drive
#   - send data to a web API
#   - update a database
#   - print a debugging message to the console
library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  
  output$greeting <- renderText(string())
  
  # Every time the name is updated, a "Greeting performed"
  # message is sent to the console.
  # You don't assign the result of observerEvent() to a variable.
  # You can't refer to it from other reactive consumers.
  observeEvent(input$name, {      # 1st arg: dependency expression
    message("Greeting performed") # 2nd arg: handler expression
  })
}

shinyApp(ui, server)