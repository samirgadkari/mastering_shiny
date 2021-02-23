library(shiny)

ui <- fluidPage(
  titlePanel("Side by side layout"),
  sidebarLayout(
      sidebarPanel(plotOutput("randomvalues")),
      sidebarPanel(plotOutput("disp_mpg"))
  )
)

server <- function(input, output, session) {
  output$randomvalues <- renderPlot({
      plot(runif(50, min = 0, max = 1),
           runif(50, min = 10, max = 20),
           res = 96)
  })
  output$disp_mpg <- renderPlot({
      plot(mtcars$disp, mtcars$mpg, res = 96)
  })
}

shinyApp(ui, server)