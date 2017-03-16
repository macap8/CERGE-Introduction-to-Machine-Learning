library(ROCR)
library(caret)
library(dplyr)
library(Amelia)
#install.packages("e1071")

# Load 'naively', then see how it looks like
df <- read.csv('train.csv')
fix(df)



# Load the raw training data and replace missing values with NA
df <- read.csv('train.csv',header=T,na.strings=c(""))

# Output the number of missing values for each column
sapply(df,function(x) sum(is.na(x)))

# Quick check for how many different values for each feature
sapply(df, function(x) length(unique(x)))

# A visual way to check for missing data
# install.packages("Amelia") 
# Library for dealing with missing values: 
# imputation is done by bootstraping (sampling with replacement) and then expectation maximization
# Named in honor of Amelia Erhart


missmap(df, main = "Missing values vs observed")

# Subsetting the data
exclude_cols <- c("Cabin", "PassengerId", "Name", "Ticket")
data <- df %>% select(-one_of(exclude_cols)) 
head(data)


# Substitute the missing values with the average value
data$Age[is.na(data$Age)] <- mean(data$Age,na.rm=T)

# R should automatically code Embarked as a factor(). A factor is R's way of dealing with
# categorical variables
is.factor(data$Sex)         # Returns TRUE
is.factor(data$Embarked)    # Returns TRUE

# Check categorical variables encoding for better understanding of the fitted model
contrasts(data$Sex)
contrasts(data$Embarked)

# Remove rows (Embarked) with NAs
data <- data[!is.na(data$Embarked),]
rownames(data) <- NULL

# Train test splitting
set.seed(1)
idxs <- sample(1:nrow(data), size = 0.8*nrow(data))
train <- data[idxs,]
test <- data[-idxs,]

# Model fitting
model <- glm(Survived ~.,family=binomial(link='logit'),data=train)
summary(model)


#-------------------------------------------------------------------------------
# MEASURING THE PREDICTIVE ABILITY OF THE MODEL

# If prob > 0.5 then 1, else 0. Threshold can be set for better results
fitted.results <- predict(model,newdata=test[,1:ncol(test)],type='response')
head(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)

misClasificError <- mean(fitted.results != test$Survived)
print(paste('Accuracy',1-misClasificError))

# Confusion matrix
confusionMatrix(data=fitted.results, reference=test$Survived)


# ROC and AUC
p <- predict(model, newdata=test[,1:ncol(test)], type="response")
pr <- prediction(p, test$Survived)
# TPR = sensitivity, FPR=specificity
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

# Accuracy vs cutoff value
acc <-  performance(pr, "acc")

ac.val <-  max(unlist(acc@y.values))
th = unlist(acc@x.values)[unlist(acc@y.values) == ac.val]

plot(acc)
abline(v=th, col='grey', lty=2)



### USING CARET

## ----, eval = FALSE------------------------------------------------------
## install.packages("caret", dependencies = TRUE)
## install.packages("randomForest")

## ----, warning = FALSE, message = FALSE----------------------------------
library(caret)
library(randomForest)

## ----, eval = FALSE------------------------------------------------------
## setwd("FILE PATH TO DIRECTORY")

## ----, eval = FALSE------------------------------------------------------
## setwd("~/Desktop/Titanic/")

## ------------------------------------------------------------------------
trainSet <- read.table("train.csv", sep = ",", header = TRUE)

## ------------------------------------------------------------------------
head(trainSet)


## ------------------------------------------------------------------------
table(trainSet[,c("Survived", "Pclass")])

## ----, warning = FALSE, message = FALSE----------------------------------
# Comparing Age and Survived: The boxplots are very similar between Age
# for survivors and those who died. 
library(dplyr)
library(ggplot2)

trainSet$Survived <- as.factor(trainSet$Survived)
trainSet %>% ggplot(aes(Survived, Age)) + geom_boxplot()

# Comparing Age and Fare: The boxplots are much different between 
# Fare for survivors and those who died.
trainSet %>% ggplot(aes(Survived, Fare)) + geom_boxplot()

# Also, there are no NA's. Include this variable.
summary(trainSet$Fare)


# Set a random seed (so you will get the same results as me)
set.seed(42)
# Train the model using a "random forest" algorithm
model <- train(Survived ~ Pclass + Sex + SibSp +   
                 Embarked + Parch + Fare, # Survived is a function of the variables we decided to include
               data = trainSet, # Use the trainSet dataframe as the training data
               method = "rf",# Use the "random forest" algorithm
               trControl = trainControl(method = "cv", # Use cross-validation
                                        number = 5) # Use 5 folds for cross-validation
)

## ------------------------------------------------------------------------
model
