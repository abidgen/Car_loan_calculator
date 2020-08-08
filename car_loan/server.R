#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

sa_tax <- function(price, trade_in, tax){
    return((price-trade_in)*tax/100)
}


up_payment <- function(down_pay, tax, other){
    return(down_pay + tax +other)
}

loan_wo_fee <- function(price, down_pay, trade_in){
    return(price - down_pay - trade_in)
}

loan_w_fee <- function(price, down_pay, trade_in, tax, other){
    return(price - down_pay - trade_in + tax + other)
}

int_m <- function(int){
    return(int/(12*100))
}


monthly_pay <- function(loan, time, int){
    return(loan*(int*((1+int)^time))/(((1+int)^time )- 1))
}

total_pay <- function(monthly_pay, time){
    return(monthly_pay * time)
}

total_int <- function(total_pay, loan ){
    return(total_pay - loan)
}

total_cos <- function(price,total_int, tax, other){
    return(price+total_int+tax+other)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    

    
    sales_tax <- reactive({
        
        
        sa_tax(input$auto_price, input$trade_in_value, input$sales_tax_rate )
       
    })
    
    upfront_payment <- reactive({
        validate(
            need(input$down_payment, 'Please enter a numeric value for "Down Payment"'),
            need(input$other_fees, 'Please enter a numeric value for all fields')
        )
        if (input$include_fee){
            up_payment(input$down_payment, sales_tax(), input$other_fees)
        } else{
            input$down_payment
        }
    })
    
    total_loan_amount <- reactive({
        validate(
            need(input$auto_price, 'Please enter a numeric value for all fields'),
            need(input$down_payment, 'Please enter a numeric value for "Down Payment"'),
            need(input$trade_in_value, 'Please enter a numeric value for all fields'),
            need(input$other_fees, 'Please enter a numeric value for all fields'),
            need((input$auto_price+input$other_fees-input$down_payment - input$trade_in_value)>0,
                 "No Loan needed !!!")
            
        )
        if (input$include_fee){
            loan_wo_fee(input$auto_price,input$down_payment,input$trade_in_value)
        } else{
            loan_w_fee(input$auto_price,input$down_payment,input$trade_in_value, sales_tax(), input$other_fees)
        }
    })
    
    int_monthly <- reactive({
        validate(
            need(input$interest_rate, 'Please enter a numeric value for all fields')
        )
        int_m(input$interest_rate)
    })
    
    monthly_payment <- reactive({
        monthly_pay(total_loan_amount(), input$loan_term, int_monthly())
    })
    
    total_payment <- reactive({
        validate(
            need(input$loan_term, 'Please enter a numeric value for all fields')
        )
        total_pay(monthly_payment(), input$loan_term)
    })
    
    total_interest_payment <- reactive({
        total_int(total_payment(), total_loan_amount())
    })
    
    total_cost <- reactive({
        validate(
            need(input$auto_price, 'Please enter a numeric value for all fields'),
            need(input$other_fees, 'Please enter a numeric value for all fields')
        )
        total_cos(input$auto_price, total_interest_payment(), sales_tax(), input$other_fees )
    })
    
    
    
    output$total_loan_amount <- renderText(paste("$",round(total_loan_amount(),2)))
    output$sales_tax <- renderText(paste("$",round(sales_tax(),2)))
    output$upfront_payment <- renderText(paste("$",round(upfront_payment(),2)))
    output$total_payment <- renderText(paste("$",round(total_payment(),2)))
    output$total_interest_payment <- renderText(paste("$",round(total_interest_payment(),2)))
    output$total_cost <- renderText(paste("$",round(total_cost(),2)))
    output$monthly_payment <- renderText(paste("$",round(monthly_payment(),2)))
})
