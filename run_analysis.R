library(data.table)
filefile<- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "~/DataScience/dataset.zip", method = "curl")
unzip(zipfile = "~/DataScience/dataset.zip", exdir = "~/DataScience")

#read train data
x_train <- read.table("~/DataScience/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/DataScience/UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("~/DataScience/UCI HAR Dataset/train/subject_train.txt")

#read test data
x_test <- read.table("~/DataScience/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/DataScience/UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("~/DataScience/UCI HAR Dataset/test/subject_test.txt")

#read data description and activity labels
features<- read.table("~/DataScience/UCI HAR Dataset/features.txt")
activitylabels<- read.table ("~/DataScience/UCI HAR Dataset/activity_labels.txt")

#assigning column names
colnames(x_train)<- features[,2]
colnames(y_train)<- "activity_id"
colnames(subject_train)<- "subject_id"

colnames(x_test)<- features[,2]
colnames(y_test)<- "activity_id"
colnames(subject_test)<- "subject_id"

colnames(activitylabels)<- c("activity_id", "activity_type")

#merging data
mrg_train<- cbind(y_train, subject_train, x_train)
mrg_test<- cbind(y_test, subject_test, x_test)
mergeddata<- rbind(mrg_train, mrg_test)


#Extracting measurements
colNames <- colnames(mergeddata)

mean_std<- (grepl("activity_id", colNames) | grepl ("subject_id", colNames) | grepl ("mean..", colNames) | grepl("std..", colNames))

mean_stdset<- mergeddata[,mean_std == TRUE]

#Descriptive variable names
activitynamesset<- merge(mean_stdset, activitylabels, by = "activity_id", all.x = TRUE)

#Second independent tidy set
tidyset<- aggregate(. ~subject_id + activity_id, activitynamesset, mean)
tidyset<- tidyset[order(tidyset$subject_id, tidyset$activity_id),]

write.table(tidyset, "tidyset.txt", row.name = FALSE)

