#
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Central Limit Theorem Demonstration"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("distribution_selector", label = ("Distribution"), 
                  # most of them are commented out because they need extra parameters to be set, which is not implemented yet.
                  choices = list(#"beta",
                    #"binomial",
                    #"Cauchy",
                    #"chi-squared",
                    "exponential",
                    #"F",
                    #"gamma",
                    #"geometric",
                    #"hypergeometric",
                    "log-normal",
                    #"multinomial",
                    #"negative binomial",
                    "normal",
                    #"Poisson",
                    #"Student's t",
                    "uniform"
                    #"Weibull"
                  ), 
                  selected = "normal"),
      
      sliderInput("obervations_slider", label = ("Observations"), min = 100, 
                  max = 100000, value = 100000, step = 1000),
      
      uiOutput("input_samplesize_slider"),
      
      uiOutput("input_samples_slider"),
      
      sliderInput("bin_width_source_slider", label = ("Bin Width Source Plot"), min = 0.01, 
                  max = 1, value = 0.1, step = 0.01),
      sliderInput("bin_width_sample_slider", label = ("Bin Width Sample Plot"), min = 0.01, 
                  max = 1, value = 0.01, step = 0.01),
      
      helpText("Information: This shiny application demonstrates the", a("central limit theorem.",                                                                         href = "https://en.wikipedia.org/wiki/Central_limit_theorem")),
      
      helpText("It basicly states, that if you take any distibution and take samples of that distibution, then the means of that many samples form a normal distribution. Also the mean of that new normal distribution approximates the mean of the source distribution. Also the standard deviation of the source distribution is approximated by the standrad deviation of the sample distribution devided by the square root of the size of the samples taken."),
      
      helpText("In this application, you can select the type and size of the source distribution and how many samples of which size should be taken from that source distribution for the distribution of sample means.
 It then plots the histogramms and means for each distribution. Compare for example the normal distibution and the uniform distribution. You will see that both times the distibution of sample means looks like a normal distribution, allthough the source distributions are very different.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distributionplot"),
      plotOutput("samplemeansplot"),
      tableOutput("meansdtable")
    )
  )
))
