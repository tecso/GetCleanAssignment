# README for Human Activity Recognition Using Smartphones Data Set 
_Assignment from Getting and Cleaning Data (Coursera)_
_This repo: `GetCleanAssignment`_

## Summary of procedures

This project contains one script, `run_analysis.R`, which contains all functions and code to do the following:

1. Download UCI HAR Dataset zipped file to `data` dir and unpack
2. Read files and create main data frame
* Read column headings
* Appropriately label the data set with descriptive variable names
* Read test and train data, labels, and subjects and merge into one data frame
3. Create data frame that is a subset having only measurements on mean and standard deviation for each measurement
* Add descriptive activity names 
4. Create a second, independent tidy data frame with the average of each variable for each activity and each subject
5. Write this to a tab-delimted file inside `output` dir


## How to run this program

1. Clone this repo
2. Run the script:

       $ Rscript run_analysis.R (shell only - to run from within RStudio use Source)

3. Final data file is `output/tidyData.txt`

	   $ head -5 output/tidyData.txt
	   
## Open project with RStudio

This repo also contains the a codebook `CodeBook.md`.


