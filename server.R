#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  distributionInput <- reactive({
    switch(input$distribution_selector,
           "beta" = rbeta,
           "binomial" = rbinom,
           "Cauchy" = rcauchy,
           "chi-squared" = rchisq,
           "exponential" = rexp,
           "F" = rf,
           "gamma" = rgamma,
           "geometric" = rgeom,
           "hypergeometric" = rhyper,
           "log-normal" = rlnorm,
           "multinomial" = rmultinom,
           "negative binomial" = rnbinom,
           "normal" = rnorm,
           "Poisson" = rpois,
           "Student's t" = rt,
           "uniform" = runif,
           "Weibull" = rweibull
           )
  })
  
  #slider "sample size" depending on input values of the observations slider
  output$input_samplesize_slider <- renderUI({
    sliderInput("input_samplesize_slider", "Sample Size", min=10, max=input$obervations_slider / 100, value=100, step = 10)
  })
  
  #slider "number of samples" depending on input values of the observations slider
  output$input_samples_slider <- renderUI({
    sliderInput("input_samples_slider", "Number of samples", min=1, max= floor(input$obervations_slider / input$input_samplesize_slider) , value=1000, step = 100)
  })
  
  #source dataset
  distributiondata <- reactive({
    data.frame(observation = distributionInput()(n = input$obervations_slider))
  })
  
  #sample dataset
  sampledistribution <- reactive({
    sampledata <- NULL
    for(i in 1:input$input_samples_slider){
      sample <- sample(input$obervations_slider, input$input_samplesize_slider)
      sampledata <- rbind(sampledata, distributiondata()[sample,])
    }
    data.frame(means = rowMeans(sampledata))
  })
  
  #distribution plot
  output$distributionplot <- renderPlot({
    ggplot(data = distributiondata(), aes(x = observation)) +
      geom_histogram(binwidth = input$bin_width_source_slider, col = "black") +
      geom_vline(xintercept = mean(distributiondata()$observation), col = "red") +
      labs(title = "Source Distribution", x = "Observations (Mean in red)")
  })
  
  #sample means plot
  output$samplemeansplot <- renderPlot({
    ggplot(data = sampledistribution(), aes(x = means)) +
      geom_histogram(binwidth = input$bin_width_sample_slider, col = "black") +
      geom_vline(xintercept = mean(sampledistribution()$means), col = "red") +
      labs(title = "Sample Means Distribution", x = "Sample Means (Mean in red)")
   })
  
  #mean and standard deviation table
  output$meansdtable <- renderTable({
    mean_source <- mean(distributiondata()$observation)
    mean_samples <- mean(sampledistribution()$means)
    sd_source <- sd(distributiondata()$observation)
    sd_samples <- sd(sampledistribution()$means * sqrt(input$input_samplesize_slider))
    
    data.frame(Description = c("Mean of Source Distribution", "Mean of Sample Means Distribution", "Standard Deviation of Source Distribution", "Standard Deviation of Sample Means Distribution * Square Root of Sample Size"), Value = c(mean_source, mean_samples, sd_source, sd_samples))
    
  })
})
