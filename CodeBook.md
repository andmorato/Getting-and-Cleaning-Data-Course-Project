# Getting and Cleaning Data Course Project
Andre Morato  
5 de abril de 2017  



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

```r
head(dataset_sub)
```

```
##   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
## 1         0.2885845       -0.02029417        -0.1329051
## 2         0.2784188       -0.01641057        -0.1235202
## 3         0.2796531       -0.01946716        -0.1134617
## 4         0.2791739       -0.02620065        -0.1232826
## 5         0.2766288       -0.01656965        -0.1153619
## 6         0.2771988       -0.01009785        -0.1051373
##   tGravityAcc-mean()-X tGravityAcc-mean()-Y tGravityAcc-mean()-Z
## 1            0.9633961           -0.1408397           0.11537494
## 2            0.9665611           -0.1415513           0.10937881
## 3            0.9668781           -0.1420098           0.10188392
## 4            0.9676152           -0.1439765           0.09985014
## 5            0.9682244           -0.1487502           0.09448590
## 6            0.9679482           -0.1482100           0.09190972
##   tBodyAccJerk-mean()-X tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z
## 1            0.07799634           0.005000803          -0.067830808
## 2            0.07400671           0.005771104           0.029376633
## 3            0.07363596           0.003104037          -0.009045631
## 4            0.07732061           0.020057642          -0.009864772
## 5            0.07344436           0.019121574           0.016779979
## 6            0.07793244           0.018684046           0.009344434
##   tBodyGyro-mean()-X tBodyGyro-mean()-Y tBodyGyro-mean()-Z
## 1       -0.006100849        -0.03136479         0.10772540
## 2       -0.016111620        -0.08389378         0.10058429
## 3       -0.031698294        -0.10233542         0.09612688
## 4       -0.043409983        -0.09138618         0.08553770
## 5       -0.033960416        -0.07470803         0.07739203
## 6       -0.028775508        -0.07039311         0.07901214
##   tBodyGyroJerk-mean()-X tBodyGyroJerk-mean()-Y tBodyGyroJerk-mean()-Z
## 1            -0.09916740            -0.05551737            -0.06198580
## 2            -0.11050283            -0.04481873            -0.05924282
## 3            -0.10848567            -0.04241031            -0.05582883
## 4            -0.09116989            -0.03633262            -0.06046466
## 5            -0.09077010            -0.03763253            -0.05828932
## 6            -0.09424758            -0.04335526            -0.04193600
##   tBodyAccMag-mean() tGravityAccMag-mean() tBodyAccJerkMag-mean()
## 1         -0.9594339            -0.9594339             -0.9933059
## 2         -0.9792892            -0.9792892             -0.9912535
## 3         -0.9837031            -0.9837031             -0.9885313
## 4         -0.9865418            -0.9865418             -0.9930780
## 5         -0.9928271            -0.9928271             -0.9934800
## 6         -0.9942950            -0.9942950             -0.9930177
##   tBodyGyroMag-mean() tBodyGyroJerkMag-mean() fBodyAcc-mean()-X
## 1          -0.9689591              -0.9942478        -0.9947832
## 2          -0.9806831              -0.9951232        -0.9974507
## 3          -0.9763171              -0.9934032        -0.9935941
## 4          -0.9820599              -0.9955022        -0.9954906
## 5          -0.9852037              -0.9958076        -0.9972859
## 6          -0.9858944              -0.9952748        -0.9966567
##   fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAccJerk-mean()-X
## 1        -0.9829841        -0.9392687            -0.9923325
## 2        -0.9768517        -0.9735227            -0.9950322
## 3        -0.9725115        -0.9833040            -0.9909937
## 4        -0.9835697        -0.9910798            -0.9944466
## 5        -0.9823010        -0.9883694            -0.9962920
## 6        -0.9869395        -0.9927386            -0.9948507
##   fBodyAccJerk-mean()-Y fBodyAccJerk-mean()-Z fBodyGyro-mean()-X
## 1            -0.9871699            -0.9896961         -0.9865744
## 2            -0.9813115            -0.9897398         -0.9773867
## 3            -0.9816423            -0.9875663         -0.9754332
## 4            -0.9887272            -0.9913542         -0.9871096
## 5            -0.9887900            -0.9906244         -0.9824465
## 6            -0.9882443            -0.9901575         -0.9848902
##   fBodyGyro-mean()-Y fBodyGyro-mean()-Z fBodyAccMag-mean()
## 1         -0.9817615         -0.9895148         -0.9521547
## 2         -0.9925300         -0.9896058         -0.9808566
## 3         -0.9937147         -0.9867557         -0.9877948
## 4         -0.9936015         -0.9871913         -0.9875187
## 5         -0.9929838         -0.9886664         -0.9935909
## 6         -0.9927862         -0.9807784         -0.9948360
##   fBodyBodyAccJerkMag-mean() fBodyBodyGyroMag-mean()
## 1                 -0.9937257              -0.9801349
## 2                 -0.9903355              -0.9882956
## 3                 -0.9892801              -0.9892548
## 4                 -0.9927689              -0.9894128
## 5                 -0.9955228              -0.9914330
## 6                 -0.9947329              -0.9905000
##   fBodyBodyGyroJerkMag-mean() tBodyAcc-std()-X tBodyAcc-std()-Y
## 1                  -0.9919904       -0.9952786       -0.9831106
## 2                  -0.9958539       -0.9982453       -0.9753002
## 3                  -0.9950305       -0.9953796       -0.9671870
## 4                  -0.9952207       -0.9960915       -0.9834027
## 5                  -0.9950928       -0.9981386       -0.9808173
## 6                  -0.9951433       -0.9973350       -0.9904868
##   tBodyAcc-std()-Z tGravityAcc-std()-X tGravityAcc-std()-Y
## 1       -0.9135264          -0.9852497          -0.9817084
## 2       -0.9603220          -0.9974113          -0.9894474
## 3       -0.9789440          -0.9995740          -0.9928658
## 4       -0.9906751          -0.9966456          -0.9813928
## 5       -0.9904816          -0.9984293          -0.9880982
## 6       -0.9954200          -0.9989793          -0.9867539
##   tGravityAcc-std()-Z tBodyAccJerk-std()-X tBodyAccJerk-std()-Y
## 1          -0.8776250           -0.9935191           -0.9883600
## 2          -0.9316387           -0.9955481           -0.9810636
## 3          -0.9929172           -0.9907428           -0.9809556
## 4          -0.9784764           -0.9926974           -0.9875527
## 5          -0.9787449           -0.9964202           -0.9883587
## 6          -0.9973064           -0.9948136           -0.9887145
##   tBodyAccJerk-std()-Z tBodyGyro-std()-X tBodyGyro-std()-Y
## 1           -0.9935750        -0.9853103        -0.9766234
## 2           -0.9918457        -0.9831200        -0.9890458
## 3           -0.9896866        -0.9762921        -0.9935518
## 4           -0.9934976        -0.9913848        -0.9924073
## 5           -0.9924549        -0.9851836        -0.9923781
## 6           -0.9922663        -0.9851808        -0.9921175
##   tBodyGyro-std()-Z tBodyGyroJerk-std()-X tBodyGyroJerk-std()-Y
## 1        -0.9922053            -0.9921107            -0.9925193
## 2        -0.9891212            -0.9898726            -0.9972926
## 3        -0.9863787            -0.9884618            -0.9956321
## 4        -0.9875542            -0.9911194            -0.9966410
## 5        -0.9874019            -0.9913545            -0.9964730
## 6        -0.9830768            -0.9916216            -0.9960147
##   tBodyGyroJerk-std()-Z tBodyAccMag-std() tGravityAccMag-std()
## 1            -0.9920553        -0.9505515           -0.9505515
## 2            -0.9938510        -0.9760571           -0.9760571
## 3            -0.9915318        -0.9880196           -0.9880196
## 4            -0.9933289        -0.9864213           -0.9864213
## 5            -0.9945110        -0.9912754           -0.9912754
## 6            -0.9930906        -0.9952490           -0.9952490
##   tBodyAccJerkMag-std() tBodyGyroMag-std() tBodyGyroJerkMag-std()
## 1            -0.9943364         -0.9643352             -0.9913676
## 2            -0.9916944         -0.9837542             -0.9961016
## 3            -0.9903969         -0.9860515             -0.9950910
## 4            -0.9933808         -0.9873511             -0.9952666
## 5            -0.9958537         -0.9890626             -0.9952580
## 6            -0.9954243         -0.9864403             -0.9952050
##   fBodyAcc-std()-X fBodyAcc-std()-Y fBodyAcc-std()-Z fBodyAccJerk-std()-X
## 1       -0.9954217       -0.9831330       -0.9061650           -0.9958207
## 2       -0.9986803       -0.9749298       -0.9554381           -0.9966523
## 3       -0.9963128       -0.9655059       -0.9770493           -0.9912488
## 4       -0.9963121       -0.9832444       -0.9902291           -0.9913783
## 5       -0.9986065       -0.9801295       -0.9919150           -0.9969025
## 6       -0.9976438       -0.9922637       -0.9970459           -0.9952180
##   fBodyAccJerk-std()-Y fBodyAccJerk-std()-Z fBodyGyro-std()-X
## 1           -0.9909363           -0.9970517        -0.9850326
## 2           -0.9820839           -0.9926268        -0.9849043
## 3           -0.9814148           -0.9904159        -0.9766422
## 4           -0.9869269           -0.9943908        -0.9928104
## 5           -0.9886067           -0.9929065        -0.9859818
## 6           -0.9901788           -0.9930667        -0.9852871
##   fBodyGyro-std()-Y fBodyGyro-std()-Z fBodyAccMag-std()
## 1        -0.9738861        -0.9940349        -0.9561340
## 2        -0.9871681        -0.9897847        -0.9758658
## 3        -0.9933990        -0.9873282        -0.9890155
## 4        -0.9916460        -0.9886776        -0.9867420
## 5        -0.9919558        -0.9879443        -0.9900635
## 6        -0.9916595        -0.9853661        -0.9952833
##   fBodyBodyAccJerkMag-std() fBodyBodyGyroMag-std()
## 1                -0.9937550             -0.9613094
## 2                -0.9919603             -0.9833219
## 3                -0.9908667             -0.9860277
## 4                -0.9916998             -0.9878358
## 5                -0.9943890             -0.9890594
## 6                -0.9951562             -0.9858609
##   fBodyBodyGyroJerkMag-std() activity subject
## 1                 -0.9906975 STANDING       1
## 2                 -0.9963995 STANDING       1
## 3                 -0.9951274 STANDING       1
## 4                 -0.9952369 STANDING       1
## 5                 -0.9954648 STANDING       1
## 6                 -0.9952387 STANDING       1
```


## New data set based in this one created

The final task is to create a new dataset with means of all measurements grouped by subject and activity.


```r
newdataset<-dataset_sub %>%
  group_by(activity, subject) %>%
    summarise_all(mean)

str(newdataset)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	180 obs. of  68 variables:
##  $ activity                   : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ subject                    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ tBodyAcc-mean()-X          : num  0.222 0.281 0.276 0.264 0.278 ...
##  $ tBodyAcc-mean()-Y          : num  -0.0405 -0.0182 -0.019 -0.015 -0.0183 ...
##  $ tBodyAcc-mean()-Z          : num  -0.113 -0.107 -0.101 -0.111 -0.108 ...
##  $ tGravityAcc-mean()-X       : num  -0.249 -0.51 -0.242 -0.421 -0.483 ...
##  $ tGravityAcc-mean()-Y       : num  0.706 0.753 0.837 0.915 0.955 ...
##  $ tGravityAcc-mean()-Z       : num  0.446 0.647 0.489 0.342 0.264 ...
##  $ tBodyAccJerk-mean()-X      : num  0.0811 0.0826 0.077 0.0934 0.0848 ...
##  $ tBodyAccJerk-mean()-Y      : num  0.00384 0.01225 0.0138 0.00693 0.00747 ...
##  $ tBodyAccJerk-mean()-Z      : num  0.01083 -0.0018 -0.00436 -0.00641 -0.00304 ...
##  $ tBodyGyro-mean()-X         : num  -0.01655 -0.01848 -0.02082 -0.00923 -0.02189 ...
##  $ tBodyGyro-mean()-Y         : num  -0.0645 -0.1118 -0.0719 -0.093 -0.0799 ...
##  $ tBodyGyro-mean()-Z         : num  0.149 0.145 0.138 0.17 0.16 ...
##  $ tBodyGyroJerk-mean()-X     : num  -0.107 -0.102 -0.1 -0.105 -0.102 ...
##  $ tBodyGyroJerk-mean()-Y     : num  -0.0415 -0.0359 -0.039 -0.0381 -0.0404 ...
##  $ tBodyGyroJerk-mean()-Z     : num  -0.0741 -0.0702 -0.0687 -0.0712 -0.0708 ...
##  $ tBodyAccMag-mean()         : num  -0.842 -0.977 -0.973 -0.955 -0.967 ...
##  $ tGravityAccMag-mean()      : num  -0.842 -0.977 -0.973 -0.955 -0.967 ...
##  $ tBodyAccJerkMag-mean()     : num  -0.954 -0.988 -0.979 -0.97 -0.98 ...
##  $ tBodyGyroMag-mean()        : num  -0.875 -0.95 -0.952 -0.93 -0.947 ...
##  $ tBodyGyroJerkMag-mean()    : num  -0.963 -0.992 -0.987 -0.985 -0.986 ...
##  $ fBodyAcc-mean()-X          : num  -0.939 -0.977 -0.981 -0.959 -0.969 ...
##  $ fBodyAcc-mean()-Y          : num  -0.867 -0.98 -0.961 -0.939 -0.965 ...
##  $ fBodyAcc-mean()-Z          : num  -0.883 -0.984 -0.968 -0.968 -0.977 ...
##  $ fBodyAccJerk-mean()-X      : num  -0.957 -0.986 -0.981 -0.979 -0.983 ...
##  $ fBodyAccJerk-mean()-Y      : num  -0.922 -0.983 -0.969 -0.944 -0.965 ...
##  $ fBodyAccJerk-mean()-Z      : num  -0.948 -0.986 -0.979 -0.975 -0.983 ...
##  $ fBodyGyro-mean()-X         : num  -0.85 -0.986 -0.97 -0.967 -0.976 ...
##  $ fBodyGyro-mean()-Y         : num  -0.952 -0.983 -0.978 -0.972 -0.978 ...
##  $ fBodyGyro-mean()-Z         : num  -0.909 -0.963 -0.962 -0.961 -0.963 ...
##  $ fBodyAccMag-mean()         : num  -0.862 -0.975 -0.966 -0.939 -0.962 ...
##  $ fBodyBodyAccJerkMag-mean() : num  -0.933 -0.985 -0.976 -0.962 -0.977 ...
##  $ fBodyBodyGyroMag-mean()    : num  -0.862 -0.972 -0.965 -0.962 -0.968 ...
##  $ fBodyBodyGyroJerkMag-mean(): num  -0.942 -0.99 -0.984 -0.984 -0.985 ...
##  $ tBodyAcc-std()-X           : num  -0.928 -0.974 -0.983 -0.954 -0.966 ...
##  $ tBodyAcc-std()-Y           : num  -0.837 -0.98 -0.962 -0.942 -0.969 ...
##  $ tBodyAcc-std()-Z           : num  -0.826 -0.984 -0.964 -0.963 -0.969 ...
##  $ tGravityAcc-std()-X        : num  -0.897 -0.959 -0.983 -0.921 -0.946 ...
##  $ tGravityAcc-std()-Y        : num  -0.908 -0.988 -0.981 -0.97 -0.986 ...
##  $ tGravityAcc-std()-Z        : num  -0.852 -0.984 -0.965 -0.976 -0.977 ...
##  $ tBodyAccJerk-std()-X       : num  -0.958 -0.986 -0.981 -0.978 -0.983 ...
##  $ tBodyAccJerk-std()-Y       : num  -0.924 -0.983 -0.969 -0.942 -0.965 ...
##  $ tBodyAccJerk-std()-Z       : num  -0.955 -0.988 -0.982 -0.979 -0.985 ...
##  $ tBodyGyro-std()-X          : num  -0.874 -0.988 -0.975 -0.973 -0.979 ...
##  $ tBodyGyro-std()-Y          : num  -0.951 -0.982 -0.977 -0.961 -0.977 ...
##  $ tBodyGyro-std()-Z          : num  -0.908 -0.96 -0.964 -0.962 -0.961 ...
##  $ tBodyGyroJerk-std()-X      : num  -0.919 -0.993 -0.98 -0.975 -0.983 ...
##  $ tBodyGyroJerk-std()-Y      : num  -0.968 -0.99 -0.987 -0.987 -0.984 ...
##  $ tBodyGyroJerk-std()-Z      : num  -0.958 -0.988 -0.983 -0.984 -0.99 ...
##  $ tBodyAccMag-std()          : num  -0.795 -0.973 -0.964 -0.931 -0.959 ...
##  $ tGravityAccMag-std()       : num  -0.795 -0.973 -0.964 -0.931 -0.959 ...
##  $ tBodyAccJerkMag-std()      : num  -0.928 -0.986 -0.976 -0.961 -0.977 ...
##  $ tBodyGyroMag-std()         : num  -0.819 -0.961 -0.954 -0.947 -0.958 ...
##  $ tBodyGyroJerkMag-std()     : num  -0.936 -0.99 -0.983 -0.983 -0.984 ...
##  $ fBodyAcc-std()-X           : num  -0.924 -0.973 -0.984 -0.952 -0.965 ...
##  $ fBodyAcc-std()-Y           : num  -0.834 -0.981 -0.964 -0.946 -0.973 ...
##  $ fBodyAcc-std()-Z           : num  -0.813 -0.985 -0.963 -0.962 -0.966 ...
##  $ fBodyAccJerk-std()-X       : num  -0.964 -0.987 -0.983 -0.98 -0.986 ...
##  $ fBodyAccJerk-std()-Y       : num  -0.932 -0.985 -0.971 -0.944 -0.966 ...
##  $ fBodyAccJerk-std()-Z       : num  -0.961 -0.989 -0.984 -0.98 -0.986 ...
##  $ fBodyGyro-std()-X          : num  -0.882 -0.989 -0.976 -0.975 -0.981 ...
##  $ fBodyGyro-std()-Y          : num  -0.951 -0.982 -0.977 -0.956 -0.977 ...
##  $ fBodyGyro-std()-Z          : num  -0.917 -0.963 -0.967 -0.966 -0.963 ...
##  $ fBodyAccMag-std()          : num  -0.798 -0.975 -0.968 -0.937 -0.963 ...
##  $ fBodyBodyAccJerkMag-std()  : num  -0.922 -0.985 -0.975 -0.958 -0.976 ...
##  $ fBodyBodyGyroMag-std()     : num  -0.824 -0.961 -0.955 -0.947 -0.959 ...
##  $ fBodyBodyGyroJerkMag-std() : num  -0.933 -0.989 -0.983 -0.983 -0.983 ...
##  - attr(*, "vars")=List of 1
##   ..$ : symbol activity
##  - attr(*, "drop")= logi TRUE
```

```r
dim(newdataset)
```

```
## [1] 180  68
```

```r
## Write the final tidy data
write.table(newdataset, "tidydata.txt", row.name=FALSE)
```

