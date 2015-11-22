# Program: Server file of Shiny project to pull stock tickers from Yahoo Finance
# Author: Dan Stair
# Date: November 2015

library(shiny)
library(plyr)
library(quantmod)
library(xts)
library(dygraphs)
library(magrittr)
library(PerformanceAnalytics)

shinyServer(
  function(input, output) {
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
    stockCorr <- reactive({
      cbind(diff(log(Cl(stockOne()))),diff(log(Cl(stockTwo()))))
    })

    # Chart stock prices!
    output$dygraph_price <- renderDygraph({
      dygraph(cbind(stockOne(),stockTwo()),
              ylab="Closing Price", 
              xlab="Date",
              main=paste("Daily Closing Price of", input$stock1, "and", input$stock2, ",", input$dateRange[1], "to", input$dateRange[2])) %>%
              dyAxis("x", drawGrid = TRUE) %>%
              dyAxis("y", label = paste(input$stock1, "Closing Price")) %>%
              dyAxis("y2", label = paste(input$stock2, "Closing Price"), independentTicks = TRUE) %>%
              dySeries(paste(input$stock2, ".Close", sep=""), axis = "y2") %>%
              dyRangeSelector(strokeColor = "black", fillColor = "black")
    })

    #Chart correlation between stocks
    output$dygraph_corr <- renderDygraph({
      dygraph(stockCorr(),
              ylab="Correlation", 
              xlab="Date",
              main=paste("Daily Correlation between", input$stock1, "and", input$stock2, ",", input$dateRange[1], "to", input$dateRange[2])) %>%
        dyAxis("x", drawGrid = FALSE) %>%
        dyAxis("y", label = paste("Correlation Between", input$stock1, input$stock2)) %>%
        dyRangeSelector(strokeColor = "black", fillColor = "black")
    })
  }
)