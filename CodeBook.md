# Getting and Cleaning Data Course Project
Andre Morato  
5 de abril de 2017  


## Overview

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The train and test set have 561 measurements.

## Getting data

The following code will download the data and unzip the file.


```r
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./acelerometers.zip")
## unzip("acelerometers.zip", exdir = ".")
```

## Obtaining the train set and test set

The following code will extract the train set and test set.

It will obtain other informations like the features list, the activitives list and labels.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
## Features list
features<-read.table("./UCI HAR Dataset/features.txt")
head(features)
```

```
##   V1                V2
## 1  1 tBodyAcc-mean()-X
## 2  2 tBodyAcc-mean()-Y
## 3  3 tBodyAcc-mean()-Z
## 4  4  tBodyAcc-std()-X
## 5  5  tBodyAcc-std()-Y
## 6  6  tBodyAcc-std()-Z
```

```r
dim(features)
```

```
## [1] 561   2
```

```r
## Activity labels
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
print(activity_labels)
```

```
##   V1                 V2
## 1  1            WALKING
## 2  2   WALKING_UPSTAIRS
## 3  3 WALKING_DOWNSTAIRS
## 4  4            SITTING
## 5  5           STANDING
## 6  6             LAYING
```

```r
## Train set
train<-read.table("./UCI HAR Dataset/train/X_train.txt")
dim(train)
```

```
## [1] 7352  561
```

```r
## Rename the variables for its descriptions
names(train)<-features[,2]

## Train set activities and subjects
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
table(ytrain)
```

```
## ytrain
##    1    2    3    4    5    6 
## 1226 1073  986 1286 1374 1407
```

```r
## Changing the number of activity for its description
activity_train<-mutate(ytrain, V1 = activity_labels$V2[ytrain$V1])
table(activity_train)
```

```
## activity_train
##             LAYING            SITTING           STANDING 
##               1407               1286               1374 
##            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
##               1226                986               1073
```

```r
## Rename the variable activity
names(activity_train)<-"activity"

strain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
table(strain)
```

```
## strain
##   1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27 
## 347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 
##  28  29  30 
## 382 344 383
```

```r
## ## Rename the variable subjec
names(strain)<-"subject"

## Merging train set, train activity and train subject
train<-cbind(train, activity_train, strain)
dim(train)
```

```
## [1] 7352  563
```

```r
## Test set
test<-read.table("./UCI HAR Dataset/test/X_test.txt")
dim(test)
```

```
## [1] 2947  561
```

```r
## Rename the variables for its descriptions
names(test)<-features[,2]

## Test set activities and subjects
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
table(ytest)
```

```
## ytest
##   1   2   3   4   5   6 
## 496 471 420 491 532 537
```

```r
## Changing the number of activity for its description
activity_test<-mutate(ytest, V1 = activity_labels$V2[ytest$V1])
table(activity_test)
```

```
## activity_test
##             LAYING            SITTING           STANDING 
##                537                491                532 
##            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
##                496                420                471
```

```r
## Rename the variable activity
names(activity_test)<-"activity"

stest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
table(stest)
```

```
## stest
##   2   4   9  10  12  13  18  20  24 
## 302 317 288 294 320 327 364 354 381
```

```r
## ## Rename the variable subjec
names(stest)<-"subject"

## Merging test set, test activity and test subject
test<-cbind(test, activity_test, stest)
dim(test)
```

```
## [1] 2947  563
```


## Cleaning the data

In this section we will execute the activities asked.

### Merging train and test set

The train set and test set will be merged. Also, the variables will be renamed.


```r
dataset<-rbind(train,test)
dim(dataset)
```

```
## [1] 10299   563
```


### Extracting only the mean and standard deviation for each measurement

First we will find among all features the ones that evaluate mean and standard deviation of each measurement.


```r
## Mean subset among features
mean_subsets<-grep("mean\\()", features$V2)
print(mean_subsets)
```

```
##  [1]   1   2   3  41  42  43  81  82  83 121 122 123 161 162 163 201 214
## [18] 227 240 253 266 267 268 345 346 347 424 425 426 503 516 529 542
```

```r
head(features[mean_subsets,])
```

```
##    V1                   V2
## 1   1    tBodyAcc-mean()-X
## 2   2    tBodyAcc-mean()-Y
## 3   3    tBodyAcc-mean()-Z
## 41 41 tGravityAcc-mean()-X
## 42 42 tGravityAcc-mean()-Y
## 43 43 tGravityAcc-mean()-Z
```

```r
## Standar deviation subset among features
sd_subsets<-grep("std\\()", features$V2)
print(sd_subsets)
```

```
##  [1]   4   5   6  44  45  46  84  85  86 124 125 126 164 165 166 202 215
## [18] 228 241 254 269 270 271 348 349 350 427 428 429 504 517 530 543
```

```r
head(features[sd_subsets,])
```

```
##    V1                  V2
## 4   4    tBodyAcc-std()-X
## 5   5    tBodyAcc-std()-Y
## 6   6    tBodyAcc-std()-Z
## 44 44 tGravityAcc-std()-X
## 45 45 tGravityAcc-std()-Y
## 46 46 tGravityAcc-std()-Z
```

Now, the complete dataset will be subseted and will remain with only mean and standard variation measurements.


```r
dataset_sub<-cbind(dataset[,mean_subsets], dataset[,sd_subsets], dataset[, 562:563])
dim(dataset_sub)
```

```
## [1] 10299    68
```


## New data set based in this one created

The final task is to create a new dataset with means of all measurements grouped by subject and activity.


```r
newdataset<-dataset_sub %>%
  group_by(activity, subject) %>%
    summarise_all(mean)

dim(newdataset)
```

```
## [1] 180  68
```

```r
## Write the final tidy data
write.table(newdataset, "tidydata.txt", row.name=FALSE)
```

