# This script asssumes the data has been downloaded and the
# "UCI HAR Dataset" folder is in the working directory
# Run with source("run_analysis.R")

library(plyr)
library(reshape2)
nrows=-1

# Load the various datasets, and label columns
test.x          <- read.table("./UCI HAR Dataset/test/X_test.txt",   nrows=nrows)
train.x         <- read.table("./UCI HAR Dataset/train/X_train.txt", nrows=nrows)
data            <- rbind(test.x, train.x)
features        <- read.table("./UCI HAR Dataset/features.txt")[,2]
colnames(data)  <- features

test.y          <- read.table("./UCI HAR Dataset/test/y_test.txt",   nrows=nrows)
train.y         <- read.table("./UCI HAR Dataset/train/y_train.txt", nrows=nrows)
activity        <- rbind(test.y, train.y)

activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
test.subject    <- read.table("./UCI HAR Dataset/test/subject_test.txt", nrows=nrows)
train.subject   <- read.table("./UCI HAR Dataset/train/subject_train.txt", nrows=nrows)

#Keep only means and sd
data<-data[,grep("-mean\\(\\)|-std\\(\\)", colnames(data), ignore.case = TRUE)]

#Describe columns
descriptions <- colnames(data)
descriptions <- gsub("BodyBody", "Body", descriptions)
descriptions <- gsub("^t", "Time domain (captured at 50Hz)", descriptions)
descriptions <- gsub("^f", "Frequency domain", descriptions)
descriptions <- gsub("Gyro", "Gyroscope signal (units 'radians/second')", descriptions)
descriptions <- gsub("Acc", "Accelerometer signal (units 'g')", descriptions)
descriptions <- gsub("Body", ", (estimated) Body ", descriptions)
descriptions <- gsub("Gravity", ", (estimated) Gravity ", descriptions)
descriptions <- gsub("Jerk", ", (derived) Jerk signal", descriptions)
descriptions <- gsub("Mag", " Magnitude", descriptions)
descriptions <- gsub("-mean\\(\\)", ", Mean value", descriptions)
descriptions <- gsub("-std\\(\\)", ", Standard deviation", descriptions)
descriptions <- gsub("-([XYZ])$", ", \\1 direction", descriptions)

#Make colnames more descriptive
measurevars<-colnames(data)
measurevars<-gsub("Acc", "Accelerometer", measurevars)
measurevars<-gsub("Gyro", "Gyroscope", measurevars)
measurevars<-gsub("Mag", "Magnitude", measurevars)
measurevars<-gsub("^t", "time", measurevars)
measurevars<-gsub("^f", "frequency", measurevars)
measurevars<-gsub("BodyBody", "Body", measurevars)
measurevars<-gsub("-mean\\(\\)", "Mean", measurevars)
measurevars<-gsub("-std\\(\\)", "Stdev", measurevars)
measurevars<-gsub("-", "_", measurevars)
colnames(data)<-measurevars

#Write out part of codebook.md
codebook<-paste("* ",measurevars,"\n -",descriptions,"\n")
write.table(codebook, "codebook_basis.md", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Add subject to each observation/measurement
data$subject <- as.factor(rbind(test.subject, train.subject)[,1])

# Label with descriptive names
activity <- join(activity, activity.labels, by=1)[,3]
data$activity<-as.factor(activity)

#melt and dcast to get summary of mean's
melted<-melt(data, id=c("subject","activity"), measure.vars=measurevars)
tidied<-dcast(melted, subject + activity ~ variable, mean)

write.table(tidied, file="tidy.txt", row.name=FALSE)

#tidy2 <- aggregate(.~subject+activity, data, mean)

#Uncoment these to read back the file and view in Rstudio
#data_read <- read.table("tidy.txt", header=TRUE)
#View(data_read)