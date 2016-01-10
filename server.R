# Program: Server file of Shiny project to pull stock tickers from Yahoo Finance
# Author: Dan Stair
# Date: November 2015

library(shiny)
library(quantmod)
library(xts)
library(dygraphs)
library(magrittr)
library(plyr)
library(RColorBrewer)

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
    weeklyReturns <- reactive({
      weekly_returns <- cbind(weeklyReturn(stockOne()), weeklyReturn(stockTwo()))
      names(weekly_returns)[names(weekly_returns)=="weekly.returns"] <- paste(input$stock1, "Returns")
      names(weekly_returns)[names(weekly_returns)=="weekly.returns.1"] <- paste(input$stock2, "Returns")
      return(weekly_returns)
    })
    
    FFInput <- reactive({
      stock_one <- stockOne()
      stock_two <- stockTwo()
      lwr <- pmin(stock_one, stock_two)
      upr <- pmax(stock_one, stock_two)
      ff_input <- cbind(stock_one, lwr, upr)
      names(ff_input)[names(ff_input)==(paste(input$stock1, ".Close.1", sep=""))] <- "Undervaluation"
      names(ff_input)[names(ff_input)==(paste(input$stock1, ".Close", sep=""))] <- "Stock Price"
      names(ff_input)[names(ff_input)==(paste(input$stock1, ".Close.2", sep=""))] <- "Overvaluation"
      return(ff_input)
    })

    
    # Chart stock prices!
    output$dygraph_price <- renderDygraph({
      dygraph(FFInput(),
              xlab="Date",
              main=paste("Discrepancies Between", input$stock1, "Price and", "Fama French Model Output"),
              group = "stockcharts") %>%
              dyOptions(fillGraph = TRUE, colors = c("green", "black", "red"), fillAlpha = (1.0) )%>%
              dyAxis("x", drawGrid = TRUE) %>%
              dyAxis("y", label = paste(input$stock1, "Closing Price, USD")) %>%
              dyRangeSelector(strokeColor = "black", fillColor = "black")
    })

    #Chart rates of return for each stock
    output$dygraph_corr <- renderDygraph({
      dygraph(FFInput(),
              ylab="Weekly Return",
              xlab="Date",
              main=paste("Contribution to Price", input$stock1, ",", input$dateRange[1], "to", input$dateRange[2]),
              group = "stockcharts") %>%
        dyAxis("x", drawGrid = TRUE) %>%
        dyAxis("y", valueRange = c(-12, 12), label = paste(input$stock1, "and", input$stock2, "Returns")) %>%
        dyRangeSelector(strokeColor = "black", fillColor = "black") 
    })
  }
)