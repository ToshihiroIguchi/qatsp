library(shiny)

shinyUI(
  fluidPage(
    titlePanel("Quantum annealing for traveling salesman problem in Akita"),
    sidebarLayout(
      sidebarPanel(

        actionButton("submit", "Analyze"),

        tags$hr(),

        htmlOutput("beta"),
        htmlOutput("trotter"),
        htmlOutput("ann_para"),
        htmlOutput("ann_step"),
        htmlOutput("mc_step"),
        htmlOutput("reduc")



      ),

      mainPanel(
        plotOutput("plot"),
        plotOutput("route"),
        verbatimTextOutput("sum")


      )
    )
  )
)
