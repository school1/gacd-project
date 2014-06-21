gacd-project
============

To use this script, download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and extract it to the same location as run_analysis.R

Change the line setwd("C:\\Users....") to the directory that your copy of the script and dataset folder reside in.

Run the script and two files should be written to the working directory, tidyData.txt and tidyDataAverage.txt.

The former is the first tidy dataset, which contains the information of each type of reading for each subject, for each requested variable.

The latter is the average the previous dataset for each reading, for each activity, for each subject.
