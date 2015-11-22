# Program: Server file of Shiny project to pull stock tickers from Yahoo Finance
# Author: Dan Stair
# Date: November 2015

library(shiny)
library(plyr)
library(quantmod)
library(xts)
library(dygraphs)
library(magrittr)

shinyServer(
  function(input, output) {
    checkDates <- reactive({
      validate(
        need(!is.null(MSFT[as.character(input$dateRange[1]), which.i=TRUE]),
             "Make sure to select ONLY days when the market is open!")
      )
    })

    # Pull both stocks entered and subset the return date to only contain closing price
    stockOne <- reactive({
      getSymbols(input$stock1, src = "yahoo", 
                 from = input$dateRange[1],
                 to = input$dateRange[2],
                 auto.assign = FALSE)[,c(paste(input$stock1, ".Close", sep=""))]
    })
    stockTwo <- reactive({
      getSymbols(input$stock2, src = "yahoo", 
                 from = input$dateRange[1],
                 to = input$dateRange[2],
                 auto.assign = FALSE)[,c(paste(input$stock2, ".Close", sep=""))]
    })
    
    # Display user input errors, if any
    output$errors <- renderText({checkDates()})

    # Chart it!
    output$dygraph_price <- renderDygraph({
      dygraph(cbind(stockOne(),stockTwo()),
              ylab="Closing Price", 
              xlab="Date",
              main=paste(input$stock1, "and", input$stock2, "Prices from ", input$dateRange[1], "to", input$dateRange[2])) %>%
              dyAxis("x", drawGrid = FALSE) %>%
              dyRangeSelector(strokeColor = "black", fillColor = "black")
    })
  }
)