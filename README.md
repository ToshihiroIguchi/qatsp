## qatsp packages
Quantum annealing for traveling salesman problem.

### Description
Using quantum annealing by the quantum Monte Carlo method, python code that solves for TSP (Traveling Salesman problem) which is a typical combination optimization problem was released by ab_t belonging to Nextremer.
We wanted to operate in R language.
Therefore, we created a package of quantum annealing that operates at R.

### Installation
You can install from R console.

If devtools is not installed on your PC, install devtools with Internet connection.

    install.packages("devtools")

Install from GitHub using devtools.
    
    library(devtools)
    install_github("ToshihiroIguchi/qatsp")

Load the qatsp package and attach it.

    library(qatsp)

### Examples
For reproducibility of results, we set random seeds.
Designate city coordinates for x and y to solve the traveling salesman problem.
The length of x and y must be the same.

    set.seed(108)
    result <- qatsp(x = Djibouti[,1], y= Djibouti[,2])

By default, `trace = TRUE`, and the transition of the shortest distance during calculation is displayed on the graph.
Optionally, by setting `route = TRUE`, the shortest route is displayed every time the shortest route is updated during calculation.

The shortest path obtained by the `route` function is displayed.

    route(result)

The transition of the shortest distance is displayed by the `plot` function.

    plot(result)


### References
http://qiita.com/ab_t/items/8d52096ad0f578aa2224

http://www.math.uwaterloo.ca/tsp/world/countries.html

### License 
MIT

### Auther
Toshihiro Iguchi

