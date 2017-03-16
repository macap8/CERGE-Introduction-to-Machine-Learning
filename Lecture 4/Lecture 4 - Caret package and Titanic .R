library(caret)
library(mlbench)
data(Sonar)
set.seed(107) # Make results repeatable

trainIdxs <- createDataPartition(y=Sonar$Class,
                               # the response variable is needed, 
                               p = 0.75, 
                               # proportion for training
                               list = FALSE)

train <- Sonar[trainIdxs,]
test <- Sonar[-trainIdxs,]

plsFit <- train(Class ~ .,
                data = train,
                method = "pls",
                ## Center and scale the predictors for the training
                  ## set and all future samples.
                  preProc = c("center", "scale"))

## TUNE LENGTH?
plsFit <- train(Class ~ .,
                data = train,
                method = "pls",
                tuneLength = 15,
                preProc = c("center", "scale"))


## Cross validation
ctrl <- trainControl(method = "repeatedcv", repeats = 3)
plsFit <- train(Class ~ .,
                data = train,
                method = "pls",
                tuneLength = 15,
                trControl = ctrl,
                preProc = c("center", "scale"))



## Customize metrics and return outputs
set.seed(123)
ctrl <- trainControl(method = "repeatedcv",
                     repeats = 3,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

plsFit <- train(Class ~ .,
                  data = train,
                  method = "pls",
                  tuneLength = 15,
                  trControl = ctrl,
                  metric = "ROC",
                  preProc = c("center", "scale"))

plsFit
plot(plsFit)

## Computing labels and class probabilities

plsClasses <- predict(plsFit, newdata = test)
str(plsClasses)

plsProbs <- predict(plsFit, newdata = test, type = "prob")
head(plsProbs)


### SPECIFICITY: 

### SENSITIVITY: true positive rate, recall, detection probability

### ACCURACY: (TP + TN) /(ALL)

### AUC / ROC: FPR vs TPR

### Gini: 2*AUC-1
