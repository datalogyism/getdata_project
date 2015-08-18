# Getting and Cleaning Data Course Project
## Problem statement
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called `run_analysis.R` that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Instructions
This project contains one R script, `run_analysis.R`, which will calculate means per activity, per subject of the mean and Standard deviation of the Human Activity Recognition Using Smartphones Dataset. The extracted dataset should be placed at `./UCI HAR Dataset/`. Run this script with:
```{r}
source("run_analysis.R")
```
Once executed, the resulting cleaned dataset may be found at `./tidy.txt`. You can view the dataset with the following in RStudio
```{r}
data_read <- read.table("tidy.txt", header=TRUE)
View(data_read)
```

For futher details on the cleaned dataset, refer to [CodeBook.md](CodeBook.md)

## Processing steps
The raw data is cleaned with the following steps:
* Load the `X_test.txt` and `X_train.txt` files (combining them), and label the data columns using the names listed in `features.txt`
 - Measurements not matching either `-std()` or `-mean()` are removed
 - The column names are renamed to make them more descriptive (using information found in the documentation for original dataset), and at the same time, they are used to generate the descriptions (complete with units) found in [CodeBook.md](CodeBook.md)
* Load `y_test.txt` and `y_train.txt` files (combining them), and map them to the descriptive names listed in `activity_labels.txt`
* Load the `subject_test.txt` and `subject_train.txt` files (combining them)
* The above 3 pieces of data are then used to create a data frame `data`
* Finally, the melt and dcast functions are used to create the tidy data, which is then written to "tidy.txt"

## Required R Packages
The R package `reshape2` is required to run this script. This maybe installed with
```{r}
install.package("reshape2")
```
