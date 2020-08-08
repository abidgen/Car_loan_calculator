#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
shinyUI(navbarPage( title = "Auto Loan Calculator",
                    tabPanel("App",
                             sidebarLayout(
                                 sidebarPanel(
                                     condition = "input.tabs==1",
                                     h3("Total Price"),
                                     numericInputIcon("auto_price", "Auto Price", value = 25000.00,min = 0, icon = list( icon("dollar",NULL)) ),
                                     numericInputIcon("loan_term", "Loan Term", value = 60,min = 0, icon = list(NULL, "Months") ),
                                     numericInputIcon("interest_rate", "Yearly Interest Rate", value = 3.5,min = 0, icon = list(NULL, icon("percent")) ),
                                     numericInputIcon("down_payment", "Down Payment", value = 5000,min = 0, icon = list( icon("dollar",NULL)) ),
                                     numericInputIcon("trade_in_value", "Trade-in Value", value = 2500,min = 0, icon = list(icon("dollar",NULL)) ),
                                     numericInputIcon("sales_tax_rate", "Sales Tax Rate", value = 7,min=0, icon = list(NULL, icon("percent")) ),
                                     numericInputIcon("other_fees", "Title, Registration and Other Fees", value = 300,min = 0, icon = list(NULL, icon("dollar")) ),
                                     checkboxInput("include_fee", "Include all fees in loan"),
                                     submitButton("Calculate")
                                 ),
                                 mainPanel(
                                     fluidRow(
                                         column(
                                             6,
                                             h5("Total Loan Amount:"),
                                             h5("Sales Tax:"),
                                             h5("Upfront Payment:"),
                                             HTML("<br/>"),
                                             h5("Total of 60 Loan Payments:"),
                                             h5("Total Loan Interest:"),
                                             h5("Total Cost (price, interest, tax, fees):"),
                                             HTML("<br/>"),
                                             h4("Monthly Payment:")
                                         ),
                                         column(
                                             6, 
                                             h5(textOutput("total_loan_amount")),
                                             h5(textOutput("sales_tax")),
                                             h5(textOutput("upfront_payment")),
                                             HTML("<br/>"),
                                             h5(textOutput("total_payment")),
                                             h5(textOutput("total_interest_payment")),
                                             h5(textOutput("total_cost")),
                                             HTML("<br/>"),
                                             h4(textOutput("monthly_payment"))
                                         )
                                     )
                                 )
                                 
                             )
                             ),
                    tabPanel("Documentation",
                             mainPanel(
                                 h3("Auto loan Calculator"),
                                 h4("This app calculates monthly payment for auto loans based on the following variables,"),
                                 tags$li(tags$span("Auto Price")),
                                 tags$li(tags$span("Loan Term")),
                                 tags$li(tags$span("Yearly Interest Rate")),
                                 tags$li(tags$span("Down Payment")),
                                 tags$li(tags$span("Trade-in Value")),
                                 tags$li(tags$span("Sales Tax Rate")),
                                 tags$li(tags$span("Title, Registration and Other Fees")),
                                 HTML("<br/>"),
                                 h3("Intructions"),
                                 h4("Please enter values for each variables in the designated section. Values for all variables should be provided, leaving black cells in the side-bar will generate error message. After you are done with inputting values, hit submit button to get the results."),
                                 h4("There is also option to include all fees in the laon, in that case just check the 'Include all fees in loan' box and hit submit button.")
                                 
                                 
                             )
                    )
  
))
