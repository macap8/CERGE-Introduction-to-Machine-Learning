rm(list=ls())
setwd("~/Disk Google/Repositories/CERGE-Introduction-to-Machine-Learning/Lecture 3")
getwd()

auto <- read.table("Auto.data", header = T, na.strings = "?")
fix(auto)

head(auto)

auto <- na.omit(auto)

# Predict milage pre gallon as a function of the other car attributes

plot(auto$cylinders, auto$mpg)

# If the data is "attached", then you can reference directly to col names
attach(auto)

plot(cylinders, mpg)

unique(cylinders)
typeof(cylinders)

cylinders <- as.factor(cylinders)

plot(cylinders, mpg)
identify(cylinders, mpg, name)

hist(mpg)
hist(mpg, breaks = 20)

pairs(auto)
pairs(~mpg + displacement + horsepower)

# First assumptio: Let's see the linear model

lm.fit <- lm(mpg ~ horsepower)
names(lm.fit)

lm.fit$coefficients
lm.fit$residuals

plot(horsepower, mpg)
abline(lm.fit, col = "red")
  
plot(lm.fit)
  
# 
par(mfrow = c(2,2))
plot(lm.fit)

lm.fit2 <- lm(mpg ~ horsepower + I(horsepower^2))
lm.fit2$coefficients

lm.fit2 <- lm(mpg ~ horsepower + I(horsepower^2) + weight*cylinders)
lm.fit2$coefficients

#ANOVA tests (analysis of variance)
anova(lm.fit, lm.fit2)

auto <- auto[, -9]

lm.fit3 <- lm(mpg ~ ., data = auto)
summary(lm.fit3)














  
  
  
)







