#
# Libraries
#
library(reshape2)
library(plyr)
library(dplyr)

#
# Constants
#
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
outputDir <- "./output"
fileName <- "tidyData.txt"

# 1. download and unpack data
download.file(fileUrl, destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# 2. Read files and create main data frame
# read column headings
colHeads <- read.delim("UCI HAR Dataset/features.txt", header=FALSE,
                     sep=" "
        )

# Appropriately label the data set with descriptive variable names. 
## I am choosing to do it up front rather than at the end
## Make a new column in colHeads with human-readable names
## Time or Frequency-Body or Gravity-Accelerometer or Gyroscope-X Y or Z
colHeads<-transform(colHeads, C=gsub("BodyBody", "Body", colHeads$V2)) #looks like some kind of labelling error
colHeads<-transform(colHeads, C=gsub("tBody", "TimeBody", colHeads$C))
colHeads<-transform(colHeads, C=gsub("tGravity", "TimeGravity", colHeads$C))
colHeads<-transform(colHeads, C=gsub("fBody", "FreqBody", colHeads$C))
colHeads<-transform(colHeads, C=gsub("fGravity", "FreqGravity", colHeads$C))
colHeads<-transform(colHeads, C=gsub("Acc", "Acc", colHeads$C))
colHeads<-transform(colHeads, C=gsub("Gyro", "Gyro", colHeads$C))
colHeads<-transform(colHeads, C=gsub('\\(\\)', "", colHeads$C))
colHeads<-transform(colHeads, C=gsub('\\(', "_", colHeads$C))
colHeads<-transform(colHeads, C=gsub('\\)', "", colHeads$C))
colHeads<-transform(colHeads, C=gsub("\\,", "_", colHeads$C))

# read Test
testData <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, 
                     # widths=rep.int(16,561), # widths=c(16,-16) Width of the columns. -2 means drop those columns
                     col.names=colHeads[,3]
                     )
# Add labels and subjects
testData$Label<-as.numeric(readLines("UCI HAR Dataset/test/y_test.txt"))
testData$Subject<-as.numeric(readLines("UCI HAR Dataset/test/subject_test.txt"))

# read Training
trainData <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, 
                       col.names=colHeads[,3]
)
# Add labels and subjects
trainData$Label<-as.numeric(readLines("UCI HAR Dataset/train/y_train.txt"))
trainData$Subject<-as.numeric(readLines("UCI HAR Dataset/train/subject_train.txt"))

#summary(testData)
#str(testData)
#sapply(testData, class)

# Merge the training and the test sets to create one data set.
mergedData<-rbind(testData,trainData)

#clean up
rm(testData)
rm(trainData)

# Extract only the measurements on the mean and standard deviation for each measurement. 
shortData<-select(mergedData, contains("mean"), contains("std"), contains("Label"), contains("Subject"))

# Notes for later ref
# select(flights, Year:DayofMonth, contains("Taxi"), contains("Delay")) A nice example - A:C is a range
# write.csv(shortData, file="out.csv")

# Use descriptive activity names to name the activities in the data set
activityNames <- read.delim("UCI HAR Dataset/activity_labels.txt", header=FALSE,
                          sep=" ",
                          col.names=c("Label","ActivityName"),
                          colClasses=c("numeric","factor")
)

shortData <- join(shortData,activityNames,by="Label")


# From the data set in step 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

tidySummary<-ddply(shortData[,1:88], .(Label,Subject), colMeans)
tidySummary <- join(tidySummary,activityNames,by="Label")
# reorder so nicer to look at
tidySummary<-tidySummary[,c(88,89,87,1:86)]
# write the file as tab delim 
if(!file.exists(outputDir)) { dir.create(outputDir) }
write.table(tidySummary, file=(paste(outputDir, fileName, sep="/")), sep = "\t", row.names=FALSE) 


# did not use below, but interesting
# shortDataSummary <- t( summarise_each_(shortData, funs(mean), list(quote(ActivityName), quote(Subject)) )
# x<-melt(shortData, id=c("Subject","ActivityName"))
# tidyX<-dcast(x,Subject~ActivityName,mean)


