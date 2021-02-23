library(shiny)
library(lubridate)
library(reactable)

# First argument for all inputs is the input ID. It must be unique !!
# Second parameter usually is label - the text that the user sees.
# Third parameter is the default value
# Always set the first 2 arguments (inputID, label) by position.
# All other arguments should be set by name.
#
# Here is the whirlwind tour of inputs:
# textInput(): User can type a single line text
# passwordInput(): entering passwords
# textAreaInput(): Use can type more than one line of text
# textAreaInput("story", "Tell me about yourself", rows = 3)
#
# Use validate() to ensure text has certain properties
#
# numericInput(): constrained text box with numeric input
# 
# sliderInput("num2", "Number two", value = 50, min = 0, max = 100):
#   single slider
#
# sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100)
#   range slider with two ends
#
# Sliders are very customizable:
# https://shiny.rstudio.com/articles/sliders.html
#
# dateInput(), dateRangeInput(): Single date/Range of dates
# dateInput("dob", "When were you born?"),
# dateRangeInput("holiday", "When do you want to go on vacation next?")
# These provide:
#   calendar picker
#   datesdisabled
#   daysofweekdisabled
# 
# selectInput("state", "What's your favourite state?", state.name),
#   multiple = TRUE: to select multiple values
#   Use server-side select options if you have a large number of them:
#   https://shiny.rstudio.com/articles/selectize.html#server-side-selectize
#
# radioButtons("animal", "What's your favourite animal?", animals)
#   radioButtons can be given choiceNames (list of strings to show user),
#   and choiceValues (list of corresponding values - one of which is
#   returned to the App).
#
# checkboxInput("cleanup", "Clean up?", value = TRUE)
#   User gets a single checkbox. If value = TRUE, it is already
#   selected. Don't use value, if you want it not to be selected.
# checkboxGroupInput("animal", "What animals do you like?", animals)
#   Can select multiple values using checkboxes
#
# fileInput("upload", NULL)
#   Select file to upload
#
# actionLink
#   Link to take action. 
# actionButton("drink", "Drink me!", icon = icon("cocktail"))
#   Button with icon (if you provide it).
#   Customize button with:
#     class = one of "btn-primary", "btn-success", "btn-info", 
#       "btn-warning", or "btn-danger". 
#       You can also change the size with "btn-lg", "btn-sm", "btn-xs".
#       ex. class = "btn-lg btn-success". Other options at:
#       http://bootstrapdocs.com/v3.3.6/docs/css/#buttons
# Both of these are paired with observeEvent() or eventReactive()
# in the server.
ui <- fluidPage(
  textInput("your name", "", placeholder = "Your name"),
  sliderInput("slider input", "When should we deliver?",
              value = ymd(20200917),
              min = ymd(20200915), max = ymd(20200923),
              step = dhours(6), timeFormat = "%F"),
  
  # This groups list output into regions given by the mane
  # of the list object (ex. East Coast).
  selectInput("state", "Choose a state:",
              list(`East Coast` = list("NY", "NJ", "CT"),
                   `West Coast` = list("WA", "OR", "CA"),
                   `Midwest` = list("MN", "WI", "IA"))
  ),
  sliderInput("slideranimation", "Animated Slider",
              value = 0, min = 0, max = 100, step = 5,
              animate = TRUE),
  
  # The user can type in any value into the numeric input.
  # If the user presses the up/down arrow keys, the value
  # in the box will be increased/decreased by the amount
  # given in the step value.
  numericInput("number", "Select a value", value = 150, 
               min = 0, max = 1000, step = 50),
  
  # textOutput() outputs the text as a string 
  # inside a <div> or <span>
  textOutput("text"),
  
  # verbatimTextOutput() outputs the text as code (as-is) with
  # any carraige-returns showing up in the output.
  # It does this by embedding the text in a <pre>.
  verbatimTextOutput("code"),
  
  # tableOutput() and renderTable() render a static table of data, 
  # showing all the data at once.
  # dataTableOutput() and renderDataTable() render a dynamic table, 
  # showing a fixed number of rows along with controls to change 
  # which rows are visible.
  # For greater control over dataTableOutput(), look at:
  #   https://glin.github.io/reactable/index.html
  tableOutput("static"),
  dataTableOutput("dynamic"),
 
  # plotOutput() takes up the full width of the container,
  # and will be 400 pixels high by default. width and height
  # arguments change that. Always use res = 96, so your
  # Shiny plots match those in RStudio.
  # Plots can act as inputs too (using click, dblclick, hover
  # arguments). ex. click = "plot_click" creates reactive input
  # input$plot_click to use for user interactions.
  plotOutput("plot", height = "300px", width = "700px"),
  
  # downloadButton() or downloadLink() for user downloads
  
  dataTableOutput("table"),
  reactableOutput("table2"), # Using reactable library
)

server <- function(input, output, session) {
  
  # The {} are only required in render functions if you
  # have more than one line. You should not do much computation
  # in render functions, so {} are not usually required.
  # renderText(): combines the result into a text string.
  #   Usually works with textOutput()
  # renderPrint(): just like printing on the console.
  #   Usually paired with verbatimTextOutput()
  #
  # output$text <- renderText({
  #   "Hello friend!"
  # })
  # output$code <- renderPrint({
  #   summary(1:10)
  # })
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
  
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, 
                                    options = list(pageLength = 5))
  
  output$plot <- renderPlot(plot(1:5), res = 96)
  
  # Remove all searching, ordering, etc. so we only see
  # the plain datatable.
  output$table <- renderDataTable(mtcars,
                                  options = list(ordering = FALSE,
                                                 searching = FALSE))
  
  # Render using reactable library. This is really useful.
  # The default tables don't show all columns, reactable allows
  # horizontal scrolling to see all columns. Check it out at:
  # https://glin.github.io/reactable/articles/examples.html#basic-usage
  # and https://glin.github.io/reactable/
  output$table2 <- renderReactable(reactable(mtcars))
}

shinyApp(ui, server)