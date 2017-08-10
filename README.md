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
``
MIT License

Copyright (c) 2017 Toshihiro Iguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
``

### Auther
Toshihiro Iguchi

