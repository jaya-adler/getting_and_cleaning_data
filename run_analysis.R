library(dplyr)
library(reshape2)
 filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  

if(!file.exists("UCI HAR Dataset"))
{
  unzip(filename)
}
 #loading the activities and features
 activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
 activityLabels[,2] <- as.character(activityLabels[,2])
 features <- read.table("UCI HAR Dataset/features.txt")
 features[,2] <- as.character(features[,2])
 
 #getting mean and standard deviation measurements
 featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
 featuresWanted.names <- features[featuresWanted,2]
 featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
 featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
 featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
 
 #loading the test and train dataset
 trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
 trainx <- trainx[,featuresWanted]
 trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
 trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
 train <- cbind(trainSubjects, trainy, trainx)

 
 testx <- read.table("UCI HAR Dataset/test/X_test.txt")
 testx <- testx[,featuresWanted]
 testy <- read.table("UCI HAR Dataset/test/y_test.txt")
 testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
 test <- cbind(testSubjects, testy, testx)

 
 #merging datasets
 mergeddata <- rbind(train, test)
 colnames(mergeddata) <- c("subject", "activity", featuresWanted.names)
 #Adding labels
 mergeddata$activity <- factor(mergeddata$activity, levels = activityLabels[,1], labels = activityLabels[,2])
 mergeddata$subject <- as.factor(mergeddata$subject)
 
 
 meltdata <- melt(mergeddata, id = c("subject", "activity"))
 meandata <- dcast(meltdata, subject + activity ~ variable, mean)
 
 write.table(meandata, "tidy.txt", row.names = FALSE, quote = FALSE)
 
 