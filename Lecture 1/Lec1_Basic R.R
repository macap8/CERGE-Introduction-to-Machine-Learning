### Basic R commands

# Create a vector. You can use "=", but " <-" is preferred
x <- c(1,1,2,3)
y <- c(5,8,11,13)

length(x)
length(y)

x+y

#Look at objects in the namespace
ls()


#Kill them all 
rm(list = ls())


## Create a matrix
X <- matrix(data = c(4,5,6,7), nrow = 2, ncol = 2)
X


## By default, populated by column, maybe by row would be better
X <- matrix(data = c(4,5,6,7), nrow = 2, ncol = 2, byrow = T)
X

# Apply function
X <- X^2
X


X <- sqrt(X)
X

# Create random variables
x <- rnorm(10)
y <- x+rnorm(10, mean = 1, sd = .1)
cor(x,y)

# Create random variables with initialization
set.seed(123)
x <- rnorm(10)
y <- x+rnorm(10, mean = 1, sd = .1)
cor(x,y)



