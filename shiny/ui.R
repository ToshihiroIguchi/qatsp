library(shiny)

shinyUI(
  fluidPage(
    titlePanel("Quantum annealing for traveling salesman problem"),
    sidebarLayout(
      sidebarPanel(
        fileInput("file", "Choose CSV File",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
        ),
        tags$hr(),

        htmlOutput("colname1"),
        htmlOutput("colname2"),

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
        tabsetPanel(type = "tabs",
                    tabPanel("Route", plotOutput("route")),
                    tabPanel("Step",
                             plotOutput("plot"),
                             verbatimTextOutput("sum")),
                    tabPanel("Table", tableOutput("table"))


        )
      )
    )
  )
)
