library(shiny)
library(quantmod)
library(TTR)
library(dygraphs)

shinyUI(pageWithSidebar(
  headerPanel("Hello Shiny!"),
  sidebarPanel(
      h3("These are the inputs:"),
      textInput(inputId="text1", label = "Pick a stock ticker to compare to the S&P 500.\
                Your options are MSFT, FB, AMZN, or GOOG"),
      textInput(inputId="text2", label = "Input Text2"),
      dateRangeInput("dateRange", "Please input a date between 1/2008 and 11/2015.\
                     Ranges < 2 years display best:",
                     start = "2008-01-01",
                     end   = "2015-11-01")
  ),
  mainPanel(
      h3("These are the results:"),
      p('Output text1'),
      textOutput('text1'),
      p('Output text2'),
      textOutput('text2'),
      dygraphOutput("dygraph"),
      verbatimTextOutput("dateRangeText")
  )
))