library(shiny)

ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),

           # A great use-case for an actionButton() is when you want the 
           # user to initiate an action that might take a long time to run.
           # This will indicate to them not to keep clicking on the page,
           # If they do, they will not get any response. Instead all those
           # clicks will back up - to be handled after the simulation is 
           # run.
           actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

server <- function(input, output, session) {
  # You can use a reactiveTimer() here to force simulations to 
  # update every so many milliseconds. ex.
  #
  # timer <- reactiveTimer(500)
  # output$sim_data <- reactive({ 
  #   timer()                    # Note, you don't use timer() output.
  #   rpois(input$n, input$lambda1)
  # })
  # 
  freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
    df <- data.frame(
      x = c(x1, x2),
      g = c(rep("x1", length(x1)), rep("x2", length(x2)))
    )
    
    ggplot(df, aes(x, colour = g)) +
      geom_freqpoly(binwidth = binwidth, size = 1) +
      coord_cartesian(xlim = xlim)
  }
  
  # Use eventReactive() for the actionButton() without taking a
  # reactive dependency on it. This is the way to handle clicks.
  x1 <- eventReactive(input$simulate, { # 1st arg = dependency
    
    # Note that this is computed only after the input$simulate
    # dependency is met (when the user clicks the "Simulate!" button).
    # If the user changes values of lambda1, n, or lambda2,
    # nothing will be plotted due to their changes. Only on "Simulate!".
    rpois(input$n, input$lambda1)       # 2nd arg = computation
  })
  x2 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda2)
  })
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}

shinyApp(ui, server)