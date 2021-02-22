## Titanic Kaggle Competition
## Author: Paul Vinod
## Obj: To formulate a model whether a passenger survived or not. 

## Initialization 
library(dplyr)
library(ggplot2)
library(caret)
library(tidyr)

library(GGally)
library(mice)


## Collection of the data from file
train_mat <- read.csv(file = "Titanic_Kaggle/train.csv", 
                      header = TRUE, 
                      fill = TRUE)
test_mat <- read.csv(file = "Titanic_Kaggle/test.csv",
                     header = TRUE)

## Summary of the collected data 
summary(train_mat)
imp <- mice(data =train_mat)
train_clean <- complete(imp)


## Exploratory Data Analysis => make the character to values. 
train_clean$Sex_factor <- factor(x = train_clean$Sex,
                                 levels = unique(train_clean$Sex),
                                 labels = c(0,1))
train_clean$Sex_factor <- as.numeric(train_clean$Sex_factor)
train_clean$Embarked_factor <- factor(x = train_clean$Embarked, 
                                      levels = unique(train_clean$Embarked), 
                                      labels = c(1:4))

train_clean$Embarked_factor <- as.numeric(train_clean$Embarked_factor)

ggcorr(train_clean)

## Parsimonious Model 
names(train_clean)
fit1 <- lm(Survived ~ Sex_factor + Embarked_factor)
summary(fit1)
fit2 <- lm(Survived ~ Sex_factor + Embarked_factor + Pclass + Fare + Parch,
           data = train_clean)
summary(fit2)


## Create Data Partition
inTrain <- createDataPartition(y = Survived,
                               p = 0.8, 
                               list = FALSE)
trainData <- train_clean[inTrain,]
tuneData <- train_clean[-inTrain,]