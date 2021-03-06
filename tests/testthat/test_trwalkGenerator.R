library(testthat)
library(RandomWalk)
source("randomwalk.R", chdir = T)

#' @name rw10 - contains all values taken by the random walk - and their according
#' probabilities - at time period 10. It is worth to mention that the index used
#' to get the period 10 is indeed 11. because unlike the indices used in theory
#' (from 0 up to T), R force to use indices that go from (1 up to T + 1) in order
#' to cover the same time period.
rw10 <- rw[[length(rw)]]

#' @name saledrw - Same as variable rw expect that the increments and time
#' period has been scaled.
#' The one step increments has been scaled by 1/sart(scale)
#' The time period goes from 0 to timeT. With each unit of the time cutting in
#' #scale number of portion.
scaledrw <- RandomWalk::trwalkGenerator(time_to_maturity = timeT,
                                        scale = divider,
                                        full = T)

#' @name scaledrw1 - contains all values taken by the random walk - and their according
#' probabilities - at time period 10 with scale = divider.
scaledrw1 <- scaledrw[[1 + 1]][, 'Mt']

# Define expectation and STD var.----------------------------

#' @name expectedX - Expected value taken by the random variable @name rw10
#' @name expectedXSquared - E[rw10^2]
#' @name variance - Variance of the random variable @name rw10
expectedX <- sum(rw10[, 'Mt'] * rw10[, 'Pr'])
expectedXSquared <- sum(rw10[, 'Mt'] ^ 2 * rw10[, 'Pr'])
variance <- expectedXSquared - expectedX ^2

# Define conditional expectation ----------------------------

# The following declaration will serve to compute the martingale properties of
# the symmetric random walk.
# The expectation will be computed for time l at time k, with:  k < l.
# The following equality should be shown by the test case:
# E[Ml | Fk] = Mk
# 1. Fix the time periods:
# TODO: Study the case in fixing the following time periods at random.
#' @name l - Point in time fixed to get value for computing the expectation
#' @name k - Point in time fixed to observe the only possible values to come.
#' @name p - Probability to get a head when tossing coin.
l <- 5 + 1 # +1 due to index that begin to 1 instead of 0 as in theory
k <- 2 + 1
p <- 0.5

# 2. Define the expected value (Mk), The probability and the random values
#' @name Mk - Random wolk possible states at time k
#' @name Ml - Random wolk possible states at time l. With l > k
#' @name uptovalue - Limit period up to one can look at to get some insight
#'                   into the range of value taken by the random walk. When th
#'                   point of view is placed at time k.
Mk <- rw[[k]]
Ml <- rw[[l]]
uptoValue <- l - k + 1

#' @name fi - Discrete version of the STD NORM PDF
#' The distribution of the radom walk as n -> inf is indeed the STD NORM one.
fi <- outer(1:uptoValue,
            1:uptoValue,
            FUN = function(i, j){choose((j-1), (j-i)) * p^(j-1)})

# Computation of an array of conditional expectation:
anonymous <- function(i){
  M <- Ml[i:(i + uptoValue -1), 'Mt']
  sum(M * fi[, 4])
}
#' @EMlk - Expecation of the random variable rw[[l]] looking from time period k
EMlk <- sapply(1:nrow(Mk), anonymous)

# TEST CASE ----------------------------

# TODO The following case with the idea to create such a "getter" function
# to get the correct value of a random walk according to the time period
# I want it to provide.
test_that("Theoretical random walk has <<scale>> attribute", {
  expect_true(is.element('scale', names(attributes(rw))))
  expect_true(is.element('scale', names(attributes(scaledrw))))
})

test_that("Theoretical random walk has the right value for <<scale>> attribute", {
  expect_equal(attributes(rw)$scale, 1)
  expect_equal(attributes(scaledrw)$scale, divider)
})

test_that("Expected value is zero", {
  expect_equal(expectedX, 0)
})

test_that("Variance value is equal to time_to_maturity", {
  expect_equal(variance, timeT)
})

test_that("scaled RW increment against good multiplier", {
  expect_equal(scaledrw1, c(1/sqrt(divider), (-1) * 1/sqrt(divider)))
})

test_that("the range of possible value is correct", {
  expect_equal(rw[[5]]$Mt, seq(4, -4, by = -2))
})

test_that("# transaction period according to scale", {
  expect_equal(length(scaledrw), (divider * timeT) + 1)
})

test_that("martingal property of the symmetric random walk", {
  expect_equal(EMlk, Mk[, 'Mt'])
})

test_that("the right classes are set for theoretical randomwalk object", {
  expect_equal(class(rw_fullT), c('theoretical_randomwalk', class(list())))
  expect_equal(class(rw_fullF), c('theoretical_randomwalk', class(data.frame())))
})

test_that("full TRUE of FALSE argument return the same last period", {
  trw_full <- trwalkGenerator(full = T)
  trw_notfull <- trwalkGenerator(full = F)
  expect_equal(trw_full[[length(trw_full)]], trw_notfull)

  trw_full <- trwalkGenerator(scale = 2, full = T)
  trw_notfull <- trwalkGenerator(scale = 2, full = F)
  expect_equal(trw_full[[length(trw_full)]], trw_notfull)
})
