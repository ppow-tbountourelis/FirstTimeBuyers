library(rpart)
library(plotROC)
library(pROC)
library(InformationValue)
library(concordance)
set.seed = 1
library(MASS)
setwd("~/Projects/Second Purchase Prediction")
data <- read.csv("mart_prediction.csv")

###
table(data$OUTCOME_2)

input_ones  <- data[which(data$OUTCOME_2 == 1), ]  # all 1's
input_zeros <- data[which(data$OUTCOME_2 == 0), ]  # all 1's

set.seed(100)  # for repeatability of samples
input_ones_training_rows <- sample(1:nrow(input_ones), 0.3*nrow(input_ones))  # 1's for training
input_zeros_training_rows <- sample(1:nrow(input_zeros), 0.3*nrow(input_ones))  # 0's for training. Pick as many 0's as 1's

training_ones <- input_ones[input_ones_training_rows, ]  
training_zeros <- input_zeros[input_zeros_training_rows, ]
trainingData <- rbind(training_ones, training_zeros)  # row bind the 1's and 0's 

# Create Test Data
test_ones <- input_ones[-input_ones_training_rows, ]
test_zeros <- input_zeros[-input_zeros_training_rows, ]
testData <- rbind(test_ones, test_zeros)  # row bind the 1's and 0's 

###

model <- glm(OUTCOME_2 ~ NEW_CHANNEL 
                       + QUARTER
                       + PRODUCT_REV 
                       + IS_DEPT_ELECTRONICS
                       + IS_DEPT_COMPUTERS
                       + IS_DEPT_FURNITURE
                       + IS_DEPT_BABY_AND_KIDS
                       + IS_DEPT_JEWELRY
                       + IS_DEPT_TELEVISION
                       + IS_DEPT_ELSE
                       + PROFILEDESC
             , 
             family=binomial(link='logit'), 
             data=trainingData
             )

summary(model)
anv <- anova(model, test="Chisq")


### Predict
predicted <- plogis(predict(model, testData)) 
roc(testData$OUTCOME_2, predicted)
plot(sort(predicted))



threshold <- optimalCutoff(testData$OUTCOME_2[1:10000], predicted[1:10000])
threshold
1 - misClassError(testData$OUTCOME_2, predicted, threshold = 0.17)
table(testData$OUTCOME_2)[2] / sum(table(testData$OUTCOME_2))



sensitivity(testData$OUTCOME_2, predicted, threshold = threshold)
specificity(testData$OUTCOME_2, predicted, threshold = threshold)
confusionMatrix(testData$OUTCOME_2, predicted)


Concordance(testData$OUTCOME_2, predicted)
plotROC(testData$OUTCOME_2, predicted)

i <- predicted <= 0.3 | predicted >= 0.7
testData_v2 <- testData[i,]
predicted_v2 <- predicted[i]
roc(testData_v2$OUTCOME_2, predicted_v2)
