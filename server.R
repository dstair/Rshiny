library(shiny)
library(plyr)
library(quantmod)
library(xts)
library(dygraphs)
library(magrittr)

getSymbols(c('MSFT', 'GOOG', 'AMZN', 'FB', 'GSPC'),src='yahoo')
msft_open <- MSFT[,c("MSFT.Open", "MSFT.Close")]

shinyServer(
   function(input, output) {
       x <- reactive({})
       output$text1 <- renderText({as.numeric(input$text1)+100  })
       output$text2 <- renderText({as.numeric(input$text1)+100 + 
                                   as.numeric(input$text2)})
       output$dygraph <- renderDygraph({
         dygraph(msft_open[as.numeric(input$text1):as.numeric(input$text2),],
                 ylab="Open", 
                 main="Microsoft Opening Stock Prices") %>%
                 dyAxis("x", drawGrid = FALSE)
       })
       output$dateRangeText <- renderText({
         paste("testing date range structure", input$dateRange[1], as.character(input$dateRange[2]))
       })

   }
)