## ---
## title: "Getting and Cleaning Data Course Project"
## author: "Andre Morato"
## date: "5 de abril de 2017"
## output: html_document
## ---

## ```{r setup, include=FALSE}
## knitr::opts_chunk$set(echo = TRUE)
## ```

## Getting data

## The following code will download the data and unzip the file.

## ```{r}

## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./acelerometers.zip")
## unzip("acelerometers.zip", exdir = ".")

## ```

## Obtaining the train set and test set

## The following code will extract the train set and test set.

## It will obtain other informations like the features list, the activitives list and labels.

## ```{r}

library(dplyr)

## Features list
features<-read.table("./UCI HAR Dataset/features.txt")
## head(features)
## dim(features)

## Activity labels
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
## print(activity_labels)

## Train set
train<-read.table("./UCI HAR Dataset/train/X_train.txt")
## dim(train)
## Rename the variables for its descriptions
names(train)<-features[,2]

## Train set activities and subjects
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
## table(ytrain)
## Changing the number of activity for its description
activity_train<-mutate(ytrain, V1 = activity_labels$V2[ytrain$V1])
## table(activity_train)
## Rename the variable activity
names(activity_train)<-"activity"

strain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
## table(strain)
## Rename the variable subjec
names(strain)<-"subject"

## Merging train set, train activity and train subject
train<-cbind(train, activity_train, strain)
## str(train)
## dim(train)

## Test set
test<-read.table("./UCI HAR Dataset/test/X_test.txt")
## dim(test)
## Rename the variables for its descriptions
names(test)<-features[,2]

## Test set activities and subjects
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
## table(ytest)
## Changing the number of activity for its description
activity_test<-mutate(ytest, V1 = activity_labels$V2[ytest$V1])
## table(activity_test)
## Rename the variable activity
names(activity_test)<-"activity"

stest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
## table(stest)
## Rename the variable subjec
names(stest)<-"subject"

## Merging test set, test activity and test subject
test<-cbind(test, activity_test, stest)
## str(test)
## dim(test)

## ```


## Cleaning the data

## In this section we will execute the activities asked.

### Merging train and test set

## The train set and test set will be merged. Also, the variables will be renamed.

## ```{r}

dataset<-rbind(train,test)
## dim(dataset)

## ```


### Extracting only the mean and standard deviation for each measurement

## First we will find among all features the ones that evaluate mean and standard deviation of each measurement.

## ```{r}

## Mean subset among features
mean_subsets<-grep("mean\\()", features$V2)
## print(mean_subsets)
## head(features[mean_subsets,])

## Standar deviation subset among features
sd_subsets<-grep("std\\()", features$V2)
## print(sd_subsets)
## head(features[sd_subsets,])

## ```

## Now, the complete dataset will be subseted and will remain with only mean and standard variation measurements.

## ```{r}

dataset_sub<-cbind(dataset[,mean_subsets], dataset[,sd_subsets], dataset[, 562:563])
## dim(dataset_sub)
## str(dataset_sub)
## head(dataset_sub)

## ```


## New data set based in this one created

## The final task is to create a new dataset with means of all measurements grouped by subject and activity.

## ```{r}

newdataset<-dataset_sub %>%
  group_by(activity, subject) %>%
    summarise_all(mean)

## str(newdataset)
## dim(newdataset)

## Write the final tidy data
write.table(newdataset, "tidydata.txt", row.name=FALSE)

## ```