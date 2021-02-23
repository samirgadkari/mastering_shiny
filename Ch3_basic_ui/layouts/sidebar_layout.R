# This is an example of the sidebar layout where we have
# two panels next to each other.
library(shiny)
library(shinythemes)

# fluidPage uses Bootstrap: https://getbootstrap.com/
ui <- fluidPage(
    theme = shinytheme("flatly"),
    titlePanel("Central limit theorem"),
    
    # sidebarLayout() tells rendering engine to put panels side-by-side.
    # sidebarLayout is built on top of a more flexible
    # multi-row layout where the fluidPage() contains multiple
    # fluidRow()s which contain columns().
    # The first argument to columns() is the width, and the widths
    # must add up to 12.
    sidebarLayout( 
        sidebarPanel(
            numericInput("m", "Number of samples:", 2, min = 1, max = 100)
        ),
        mainPanel(
            plotOutput("hist")
        )
    )
)

server <- function(input, output, session) {
    output$hist <- renderPlot({
        means <- replicate(1e4, mean(runif(input$m)))
        
        hist(means, breaks = 20, axes = FALSE, ylab = NULL)
        axis(4)
        mtext("Frequency", side = 4, line = 2)
        axis(1)
        mtext("value", side = 1, line = 2)
    }, res = 96, width = 400)
}

shinyApp(ui, server)

# Other places to get pre-built code for Shiny:
# https://github.com/nanxstats/awesome-shiny-extensions