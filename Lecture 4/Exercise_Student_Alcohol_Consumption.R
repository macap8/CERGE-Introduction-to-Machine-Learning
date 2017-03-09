# The data set is from:
# http://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION


df <- read.csv("student-mat.csv", sep=";")
head(df)

# Create an additional column high_alcohol to replace Walc and Dalc
df$high_alcohol <- (df$Dalc*2+df$Walc+5)
df$high_alcohol <- ifelse(df$high_alcohol>3, 1,0)
df$Dalc <- NULL
df$Walc <- NULL


model <- glm(high_alcohol ~.,family=binomial(link='logit'),data=df)
summary(model)
