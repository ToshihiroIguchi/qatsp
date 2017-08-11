\name{qatsp}
\alias{qatsp}
\title{Quantum annealing for traveling salesman problem}
\usage{
qatsp(x, y, beta  = 50, trotter = 10, ann_para = 1, ann_step = 500, mc_step = 5000, reduc = 0.99, trace = TRUE, route = FALSE)
}

\arguments{
\item{x, y}{
The x, y coordinates of the city the salesman visits.
}
\item{beta}{
Inverse Temperature.
}
\item{trotter}{
Trotta dimension.
Trotter dimension is added by mapping from quantum model to classic model.
}
\item{ann_para}{
Initial value of annealing parameter.
}
\item{ann_step}{
Annealing step.
}
\item{mc_step}{
Monte Carlo step.
}
\item{reduc}{
An attenuation factor of the annealing parameter
}

}


\description{
The Traveling Salesman Problem (TSP) is a combination of a set of cities and a distance between each two cities to find the one with the smallest total distance traveled by a tour traveling around all cities just once and returning to the departure place It is an optimization problem.
This problem belongs to the class of NP difficulties in computational complexity theory.

Quantum annealing is a metaheuristic for finding the global minimum of a given objective function over a given set of candidate solutions, by a process using quantum fluctuations.

The qatsp package simulates quantum annealing in the R language and can approximate the traveling salesman problem.
Quantum Monte Carlo method is used for simulation of quantum annealing.
}

\examples{

set.seed(108)
result <- qatsp(x = Akita[,1], y= Akita[,2])
route(result)
plot(result)

}
