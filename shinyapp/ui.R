library(shiny)
library(ggplot2)


# define UI

ui <- fluidPage(
  
  titlePanel("Easter Island: Properity or collapse?"),
  
  sidebarLayout(
    sidebarPanel(
      # range of K
      sliderInput("K","Initial Value of carrying capcity K",
                  min=0,max=20000,value=12000),
      # range of r
      sliderInput("r","Initial Value of growth rate r",
                  min=0,max=1,value=0.2)
    ),
    mainPanel(plotOutput("fig1"))
  )
)
