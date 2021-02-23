library(shiny)

ui <- fluidPage(
    # You can pick up a theme from https://bootswatch.com/ or
    # create a theme using the bslib package: 
    # https://rstudio.github.io/bslib/
    # To create a theme, use ex:
    # bslib::bs_theme(  bg = "#0b3d91", 
    # fg = "white",
    # )
    # and then pass this theme to
    # bslib::bs_theme_preview(theme) to run an app that will
    # show you what the theme looks like.
    # You can even do this from the console.
    # Theming your app is a great way to make your app look good.
    theme = bslib::bs_theme(bootswatch = "darkly"),
    
    # When you find there is no way to contain all of your elements,
    # use tabsets.
    # tabsetPanel() creates a container for any number of tabPanels().
    # Each tabPanel can have as many elements as can fit on a page.
    tabsetPanel(
        id = "tabset", # An ID that becomes an input accessible in
                       # the server using input$tabset.
        tabPanel("Import data", 
                 fileInput("file", "Data", buttonLabel = "Upload..."),
                 textInput("delim", "Delimiter (leave blank to guess)", ""),
                 numericInput("skip", "Rows to skip", 0, min = 0),
                 numericInput("rows", "Rows to preview", 10, min = 1)
        ),
        tabPanel("Set parameters"),
        tabPanel("Visualise results")
    )
)

server <- function(input, output, session) {
    
}

shinyApp(ui, server)