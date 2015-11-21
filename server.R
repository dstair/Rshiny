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
    x <- reactive({
      if (is.null(MSFT[input$dateRange[1]])) {
       output$text4 <- renderText("Did you pick a start or end date with no trading?")
      }
      })
    
      output$text1 <- renderText({as.numeric(input$text1)+100  })
      output$text2 <- renderText(as.character(input$dateRange[1]))
      output$text3 <- renderText(MSFT[input$dateRange[1], which.i=TRUE])

      # Chart it!
      output$dygraph <- renderDygraph({
        dygraph(msft_open[MSFT[as.character(input$dateRange[1]), which.i=TRUE]:MSFT[as.character(input$dateRange[2]), which.i=TRUE],],
                ylab="Open", 
                main="Microsoft Stock Prices") %>%
                dyAxis("x", drawGrid = FALSE)
      })
      output$dateRangeText <- renderText({
        paste("testing date range structure", input$dateRange[1], input$dateRange[2])
      })

   }
)