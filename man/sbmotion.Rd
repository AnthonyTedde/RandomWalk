% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sbmotion.R
\name{sbmotion}
\alias{sbmotion}
\title{A constructor of Sampled Brownian Motion}
\usage{
sbmotion(time_to_maturity = 4, seed = 1, scale = 100)
}
\arguments{
\item{time_to_maturity}{Maximum time up to the Brownian Motion evolves}

\item{seed}{With same seed, 2 exeriments will(would, in fact not yet the
case when the param scale is different) give the same output. It therefore
provides reproducibles experiments.}

\item{scale}{It defines the time partition between each unit of time. For
instance if the scale is 100, the time step [0,1] will be cut in 100 parts.}
}
\value{
\code{sbmotion()} outputs a \bold{data.frame} containing the whole
  range of time period and the value of the corresponding Brownian Motion at
  that time.
}
\description{
It generates a unique Sampled Brownian Motion along with the
  appropriate time period. The time period goes from 0 up to T (0:
  time_to_maturity).
}
\examples{
# Generate a 150 steps Brownian Motion
sbmotion(steps = 150)

# Generate a Brownian Motion from time 0 up to 4 with each unit time interval
# cut off in 100 parts [0, 0.01, 0.02, ..., 1, 1.01, 1.02, ..., 4]
bm <- sbmotion(time_to_maturity = 4, scale = 100)

# Use the accessor to get values:
# The following give the value for brownian motion at time 2.01
RandomWalk::get_values(bm, 2.01)


}
\references{
[1] Brownian Motion, Stochastic Calculus for Finance,
  Steven e. Shreve, 2004, pp 93-97
}
