run_analysis
============

Instructions for project
------------------------

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 
> 
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
> 
> Here are the data for the project: 
> 
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
> 
> Good luck!


Preliminaries
-------------

Clear the environment, set the directory, and load packages.


```r
rm( list=ls() )

setwd("C:\\Users\\Curtis\\Downloads\\Coursera\\Data Science Specialization\\3 - Getting and Cleaning Data\\Project\\")

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

```

Get the data
------------

It is assumed, from the readme, that the users downloads the zip and modifies the setwd("C:\\....") line to point to their directory, so that the code functions properly.

Read the files
--------------

Set the directories in variables
```r
dataBaseDirectory <-  "./UCI HAR Dataset/"
dataTestDirectory <-  "./UCI HAR Dataset/test/"
dataTrainDirectory <- "./UCI HAR Dataset/train/"
```


Read in the metadata
```r
activities <- paste0(dataBaseDirectory"activity_labels.txt"), header=FALSE, stringsAsFactors=FALSE)
features   <- paste0(dataBaseDirectory"features.txt"), header=FALSE, stringsAsFactors=FALSE)
```


Read in the data, test first, trial second, combine the data


Test data, tmp applies activity labels to approriate observations
```r
subject_test <- read.table(paste0(dataTestDirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDirectory, "y_test.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
testData <- cbind(tmp, subject_test, x_test)
```

Clear up, users RAM may be limited
```r
rm(subject_test,x_test,y_test,tmp)
```

Duplicate the same data, but swap the words test for train aquired data
```r
subject_train <- read.table(paste0(dataTestDirectory, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDirectory, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDirectory, "y_train.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
trainData <- cbind(tmp, subject_train, x_train)
rm(subject_train,x_train,y_train,tmp)
```



Tidy the data and write to disk
------------------------------------

Concatenate the data tables.
```r
tmpTidyData <- rbind(testData, trainData)
rm(testData, trainData)
```


Set the column names
```r
names(tmpTidyData) <- c("Activity", "Subject", features[,2])
```


Get the feature names we care about, i.e. mean() and std() as suffix
```r
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
```

Seperate these values from the data and write to file
```r
tidyData <- tmpTidyData[c("Activity", "Subject", select)]
rm(tmpTidyData)
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)
```


Create a tidy data set
----------------------

Reshape the data
```r
tidyData <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)
```

Get average each variable for each event, for each subject. Write to file.
```r
tidyDataMean <- dcast(tidyData,Activity + Subject ~variable, mean)
write.table(tidyDataMean, file="./tidyDataAverage.txt", row.names=FALSE)
```

