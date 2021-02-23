library(shiny)

# If you want to see what HTML code this creates, copy this
# fluidPage() function to the console and run it there.
# You can even mix low-level HTML with high-level Shiny
# code in your app.
ui <- fluidPage( # layout function
  selectInput("dataset", label = "Dataset", 
              choices = ls("package:datasets")),
  verbatimTextOutput("summary"),  # displays code
  tableOutput("table")            # displays table
)

server <- function(input, output, session) {
  
  # create the dataset reactive expression.
  # The expression is only evaluated once - 
  # then cached for further use.
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- renderPrint({ # renderPrint paired with 
                                  # verbatimTextOutput to display
                                  # statistical summary of 
                                  # fixed-width text
    summary(dataset()) # call the reactive expression like a function
  })
  
  output$table <- renderTable({ # renderTable paired with tableOutput
                                # to display input data in a table
    dataset() # call the reactive expression like a function
  })
}

shinyApp(ui, server)