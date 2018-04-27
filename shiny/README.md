## Quantum annealing for traveling salesman problem
Quantum annealing for traveling salesman problem executed in R language.
It can be operated on the browser.

### Launch web application
You can install from R console.
Install related packages with the following command.

    install.packages("shiny")

If shiny is installed, it can be started from R console with the following command.
    
    shiny::runGitHub("qatsp", "ToshihiroIguchi", subdir = "shiny/")

### Host
Host the Shiny application from GitHub in a private network.
Enter the following command in R console.

    #Port specification
    port <- 1573

    #Acquire private address information
    ipconfig.dat <- system("ipconfig", intern = TRUE)
    ipv4.dat <- ipconfig.dat[grep("IPv4", ipconfig.dat)][1]
    ip <- gsub(".*? ([[:digit:]])", "\\1", ipv4.dat)

    #Host the Shiny application from GitHub
    shiny::runGitHub("qatsp", "ToshihiroIguchi", subdir = "shiny/", launch.browser = FALSE, port = port, host = ip)

If you are in the private network, you can also launch the Shiny application by entering the URL following `Listing on` to the browser.

