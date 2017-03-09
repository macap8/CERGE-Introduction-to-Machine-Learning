rm(list=ls())

boston <- read.csv("boston.csv")
fix(boston)

# Find a good model for medv

pairs(boston)

