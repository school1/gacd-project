# Clean the global environment
rm( list=ls() )

# note about working directory:
#   - it has to be changed to your local folder which contains the following:
#       a) it contains run_analysis.R
#       b) it contains the uncompressed rawdata folder called "UCI HAR Dataset"
setwd("C:\\Users\\Curtis\\Downloads\\Coursera\\Data Science Specialization\\3 - Getting and Cleaning Data\\Project\\")

# Loading the packages I need
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# ---------------------------------------------------------
#   Part 1: Creating the data set (P1 requirements 1-4)  
# ---------------------------------------------------------

# Data Directories
dataBaseDirectory <-  "./UCI HAR Dataset/"
dataTestDirectory <-  "./UCI HAR Dataset/test/"
dataTrainDirectory <- "./UCI HAR Dataset/train/"

# ---------------------------------------------------------
# Read in the metadata
# ---------------------------------------------------------
activities <- paste0(dataBaseDirectory"activity_labels.txt"), header=FALSE, stringsAsFactors=FALSE)
features   <- paste0(dataBaseDirectory"features.txt"), header=FALSE, stringsAsFactors=FALSE)

# ---------------------------------------------------------
# Read in the Test Data (all related data) and prepare it
# ---------------------------------------------------------
subject_test <- read.table(paste0(dataTestDirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDirectory, "y_test.txt"), header=FALSE)
 # This next line makes a data frame that matches the V1 column of y_test to the activity names
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
 # Combine the activity names, the subject ID, and the information
testData <- cbind(tmp, subject_test, x_test)
rm(subject_test,x_test,y_test,tmp)

# ---------------------------------------------------------
# Read in the Train Data (all related data) and prepare it
# ---------------------------------------------------------
subject_train <- read.table(paste0(dataTestDirectory, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDirectory, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDirectory, "y_train.txt"), header=FALSE)
 # This next line makes a data frame that matches the V1 column of y_test to the activity names
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
 # Combine the activity names, the subject ID, and the information
trainData <- cbind(tmp, subject_train, x_train)
rm(subject_train,x_train,y_train,tmp)

# ---------------------------------------------------------
# Tidy the data up and write to disk
# ---------------------------------------------------------
 # Combine the two data sets into a temporary table
tmpTidyData <- rbind(testData, trainData)
rm(testData, trainData)
 # Set the column names of the temporary data table
names(tmpTidyData) <- c("Activity", "Subject", features[,2])
 # Only select the names from the features file that contain mean() or std()
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
 # Now I only want these columns in my data set
tidyData <- tmpTidyData[c("Activity", "Subject", select)]
rm(tmpTidyData)
 # Write this data to disk
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)

# ---------------------------------------------------------
# Now we're going to reshape the data to narrow,long format
# ---------------------------------------------------------
tidyData <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)

# ---------------------------------------------------------
# Now we're going to get the average of each variable, for
# each activity, for each subject. Then, we'll write it to
# disk.
# ---------------------------------------------------------
tidyDataMean <- dcast(tidyData,Activity + Subject ~variable, mean)
write.table(tidyDataMean, file="./tidyDataAverage.txt", row.names=FALSE)
