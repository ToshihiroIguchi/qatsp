#Reading various codes
source("Akita_tspdata.R")
source("qatsp_apps.R")
source("shiny_qatsp_apps.R")


server <- function(input, output, session) {

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
                 value = 0.99, min = 0, max = 1, step = 0.005)
  })


  observeEvent(input$submit, {

    csv_x <- Akita$latitude
    csv_y <- Akita$longitude

    result <- reactive({qatsp(x = Akita$latitude, y = Akita$longitude,
                              beta  = input$beta,
                              trotter = input$trotter,
                              ann_para = input$ann_para,
                              ann_step = input$ann_step,
                              mc_step = input$mc_step,
                              reduc = input$reduc)})

    output$route <- renderPlot({route(result())})

    output$plot <- renderPlot({plot(result())})

    output$sum <- renderPrint({summary(result())})


  })
}




