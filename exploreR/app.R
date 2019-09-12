#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            uiOutput("yearO"), 
            uiOutput("selProvKabO")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"), 
           DT::dataTableOutput("mainTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    data <- readr::read_csv('http://hub.satudata.bappenas.go.id/datastore/dump/70036350-e59a-4518-823d-9ae263df4eec')

    output$yearO <- renderUI({
        sliderInput("year", 
                    "Select year", 
                    min = data$tahun %>% as.character() %>% unique() %>% min() %>% as.integer(), 
                    max = data$tahun %>% as.character() %>% unique() %>% max() %>% as.integer(), 
                    value = 2019, 
                    step = 1)
    })
    
    output$selProvKabO <- renderUI({
        if (data %>% filter(`tahun` == input$year) %>% count() > 0) {
            radioButtons("selProvKab", 
                         "", 
                         choices = c(
                             "Province" = "prov", 
                             "Regency" = "regency"
                         ))
        }
    })
    
    output$mainTable <- DT::renderDataTable({
        data %>% filter(`tahun` == input$year)
    })
    
    output$distPlot <- renderPlot({
        
        # # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # 
        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
