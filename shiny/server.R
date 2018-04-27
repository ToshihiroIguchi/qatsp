#CUI版のqatsp読み込み
source(file.path("../R","qatsp.R"))

#shiny用の関数準備
source("shiny_qatsp.R")



server <- function(input, output, session) {
  observeEvent(input$file, {

    csv_file <- reactive(read.csv(input$file$datapath))
    output$table <- renderTable({(csv_file())})

    output$colname1 <- renderUI({
      selectInput("x", "x-axes", get.numeric.name(csv_file()))
    })
    output$colname2 <- renderUI({
      selectInput("y", "y-axes", get.numeric.name(csv_file()))
    })



    #Inverse Temperature : 50
    #beta  = 50,
    output$beta <- renderUI({
      numericInput("beta", label = "Inverse Temperature",value = 50, min = 0)
    })

    #Trotter Dimension : 10
    #trotter = 10,
    output$trotter <- renderUI({
      numericInput("trotter", label = "Trotter Dimension",value = 10, min = 1)
    })

    #Initial annealing parameter : 1
    #ann_para = 1,
    output$ann_para <- renderUI({
      numericInput("ann_para", label = "Initial annealing parameter",value = 1, min = 0)
    })


    #Annealing step : 500
    #ann_step = 500,
    output$ann_step <- renderUI({
      numericInput("ann_step", label = "Annealing step", value = 500, min = 1)
    })

    #Monte Carlo step : 5000
    #mc_step = 5000,
    output$mc_step <- renderUI({
      numericInput("mc_step", label = "Monte Carlo step", value = 5000, min = 1)
    })

    #An attenuation factor of the annealing parameter : 0.99
    #reduc = 0.99,
    output$reduc <- renderUI({
      numericInput("reduc", label = "An attenuation factor of the annealing parameter",
                  value = 0.99, min = 0, max = 1)
    })
  })

  observeEvent(input$submit, {
    csv_file <- reactive({read.csv(input$file$datapath)})

    csv_x <- reactive({csv_file()[input$x]})
    csv_y <- reactive({csv_file()[input$y]})

    result <- reactive({qatsp(x = csv_x()[, 1], y = csv_y()[, 1])})

    output$route <- renderPlot({route(result())})

    output$plot <- renderPlot({plot(result())})

    output$sum <- renderPrint({summary(result())})


  })
}




