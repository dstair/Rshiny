# Program: UI file of Shiny project to pull stock tickers from Yahoo Finance
# Author: Dan Stair
# Date: November 2015

library(shiny)
library(dygraphs)

shinyUI(pageWithSidebar(
  headerPanel("A Simple Comparison of Tech Stocks"),
  sidebarPanel(
      h3("Select stocks to compare!"),
      br(),
      textInput(inputId="stock1", label = "Pick a first stock:", value = "JBLU"),
      textInput(inputId="stock2", label = "Pick a second stock:", value = "KN"),
      
      dateRangeInput("dateRange", "Please input a date range between 1/2/2008 and 11/20/2015.",
                     start = "2015-01-02",
                     end = "2015-11-20",
                     min = "2008-01-02",
                     max = "2015-11-20"),
      br(),
      strong("Explanation:"),
      br(),
      p("The Fama-French Three-Factor model is a model designed to predict whether a stock is overvalued or undervalued."),
      p("Feel free to type in a stock ticker. Any ticker in Yahoo Finance should work, but this app was tested using MSFT, AMZN, AAPL, and GSPC (S&P 500)."),
      br(),
      strong("How to interpret the output:"),
      p("1) If there is a red area on the upper graph, that means the stock is overvalued. If the line is a solid green, that means that it is undervalued, and that the actual price "),
      p("2) You can zoom in on either chart interactively using the slider below the chart,
         or by clicking on either chart and dragging and dragging horizontally to select
         a time frame. Either action is instantaneous as it does not download any additional data"),
      p("3) Have fun!")

  ),
  mainPanel(
      dygraphOutput("dygraph_price"),
      br(),
      br(),
      dygraphOutput("dygraph_corr")
  )
))