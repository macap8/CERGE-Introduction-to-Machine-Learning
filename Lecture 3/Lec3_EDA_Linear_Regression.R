# Loading data and performing logistic regression

Auto <- read.table("Auto.data")

# If we know in advance that the data is in csv format, we could have used read.csv

# Check how is the data being loaded
fix(Auto)


# Headers are wrong, and NA's are marked with "?"

Auto <- read.table("Auto.data", header = T, na.strings = "?")
fix(Auto)

head(Auto)
summary(Auto)

#Not too many NA's, let's get rid of them

Auto <- na.omit(Auto)

## Our goal: Predict mpg based on car attributes
plot(Auto$cylinders, Auto$mpg)

#Since I'm not loading other data frames, I can attach this data frame to type less :)
attach(Auto)

plot(cylinders, mpg)

# Mmm... looks like not that many values for cylinders
unique(cylinders)
typeof(cylinders)

# Since there are a few distinct values, makes more sense to convert them to categorical
cylinders <- as.factor(cylinders)

# On categorical variables, the default geometry is boxplots
plot(cylinders, mpg)

# make it cuter
plot(cylinders, mpg, col = "red")

plot(cylinders, mpg, col = "red", horizontal = T)
plot(cylinders, mpg, col = "red", xlab = "Cylinders", ylab = "Miles per gallon")

# Identify points on the plots.. These boxplots have a lot of outliers
plot(cylinders, mpg)
identify(cylinders, mpg, name)


# Histograms
hist(mpg)

hist(mpg, col = 2)
hist(mpg, col = 2, breaks = 15)

# Pair plots
pairs(Auto)

pairs(~ mpg + displacement + horsepower + weight + acceleration, Auto)

## Mmm... so there seems to be some relationship between mpg and horsepower

####################################################################################
##
##    Linear Regression with one variable
##
####################################################################################

lm.fit <- lm(mpg~horsepower )

#what's inside lm.fit?
names(lm.fit)

# Get the coefficients:
lm.fit$coefficients

# Calculate confidence interval for the coefficients
confint(lm.fit)

# how does the model fit the data?
plot(horsepower, mpg)
abline(lm.fit, col = "red")

# Shows different plots
plot(lm.fit)

# Divide the plotting region in 4
par(mfrow = c(2,2))
plot(lm.fit)

# There is some evidence of non-linearity from the residual plots
# How about a non-linear model using horsepower?

lm.fit2 <- lm(mpg ~ horsepower + I(horsepower^2))


# Second model is far superior
anova(lm.fit, lm.fit2)

####################################################################################
##
##    Linear Regression with multiple variables
##
####################################################################################

Auto <- Auto[,-9]

lm.fit <- lm(mpg ~ . , data = Auto)
summary(lm.fit)


lm.fit <- lm(mpg ~ weight + year , data = Auto)
summary(lm.fit)
par(mfrow = c(2,2))
plot(lm.fit)



####################################################################################
##
##    Your turn: 
##
####################################################################################

# We will work with the Boston dataset. We would like to know if the presence of 
# households with low socioeconomic value somehow affects the average housing price (medv). 

# - Fit a linear model for medv as a function of lstat
# - What happens when we consider all the variables? Which are significant?
# - Fit now a model for medv as a function of lstat... Which model performs better


