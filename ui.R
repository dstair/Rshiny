library(shiny)
library(quantmod)
library(TTR)
library(dygraphs)

shinyUI(pageWithSidebar(
  headerPanel("Hello Shiny!"),
  sidebarPanel(
      h3("Please enter two tickers to compare:"),
      h4("Your options are MSFT, FB, AMZN, GOOG, or GSPC (S&P 500)"),
      textInput(inputId="text1", label = "Pick a first stock:"),
      textInput(inputId="text2", label = "Pick a second comparison stock:"),
      dateRangeInput("dateRange", "Please input a date between 1/2/2008 and 11/20/2015.\
                     Note: weekends and holidays are NOT valid start/end dates!",
                     start = "2014-01-02",
                     end = "2015-11-20",
                     min = "2008-01-02",
                     max = "2015-11-20")
  ),
  mainPanel(
      h3("These are the results:"),
      p('Output text1'),
      textOutput('text1'),
      p('Output text2'),
      verbatimTextOutput('text2'),
      p('Output text3'),
      verbatimTextOutput('text3'),
      p('Output text4'),
      verbatimTextOutput('text4'),
      dygraphOutput("dygraph"),
      verbatimTextOutput("dateRangeText")
  )
))