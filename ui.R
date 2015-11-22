# Program: UI file of Shiny project to pull stock tickers from Yahoo Finance
# Author: Dan Stair
# Date: November 2015

library(shiny)
library(quantmod)
library(TTR)
library(dygraphs)

shinyUI(pageWithSidebar(
  headerPanel("A Simple Comparison of Tech Stocks"),
  sidebarPanel(
      h3("Please select stocks to compare!"),
      br(),
      textInput(inputId="stock1", label = "Pick a first stock:", value = "AMZN"),
      textInput(inputId="stock2", label = "Pick a second stock:", value = "GOOG"),
      
      dateRangeInput("dateRange", "Please input a date range between 1/2/2008 and 11/20/2015.",
                     start = "2015-01-02",
                     end = "2015-11-20",
                     min = "2008-01-02",
                     max = "2015-11-20"),
      br(),
      h4("The fine print / detailed instructions:"),
      br(),
      h4("Any ticker in Yahoo Finance should work, but this app was tested
         using MSFT, AMZN, AAPL, and GSPC (S&P 500)"),
      br(),
      h4("The date range you input will generate a call to download data from Yahoo Finance."),
      br(),
      h4("You can also zoom in on the chart interactively using the slider below the chart.
         This is instantaneous as it does not generate any external calls")
  ),
  mainPanel(
      dygraphOutput("dygraph_price"),
      textOutput('errors')
  )
))