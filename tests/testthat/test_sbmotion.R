library(testthat)
library(RandomWalk)

# will be tested some cases on brownian motion and its properties.
timeT <- 4
s <- 100
seed <- 1

bm <- sbmotion(time_to_maturity = timeT,
               seed = seed,
               scale = s)

bm2 <- sbmotion(time_to_maturity = timeT,
               seed = seed,
               scale = s)

test_that("Brownian motion has belongs to correct class", {
  expect_equal(class(bm), c('sampled_brownianmotion', class(data.frame())))
})

test_that("Brownian motion has correct size", {
  expect_equal(nrow(bm), timeT * s + 1)
})

test_that("With same seed, sampled generated brownian motion must be reproducible", {
  expect_equal(sbmotion(seed = 4), sbmotion(seed = 4))
})

##
## Use Brownian Bridge to get reproducible Brownian Motion.
## TODO: Not yet Implemented.
# test_that("With same seed but different scale, Brownian Motion should be reproducible", {
#   bm1 <- sbmotion(time_to_maturity = 4, scale = 100)
#   bm2 <- sbmotion(time_to_maturity = 4, scale = 200)
#   # Update the bm2 object such as it keeps the same generated data but
#   # fits to the bm1's timeframe.
#   bm2 <- bm2[seq(1, nrow(bm2), by = 2), ]
#   attr(bm2, "scale") <- 100
#   attr(bm2, 'row.names') <- attr(bm1, 'row.names')
#   # Test the ressemblance of the 2 (same I hope) Brownian motion
#   expect_equal(bm1, bm2)
# })
