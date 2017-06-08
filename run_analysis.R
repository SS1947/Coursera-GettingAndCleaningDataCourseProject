# Create one R script called run_analysis.R that creates tidy data set and saves it as tidy_data.txt

library(data.table)
library(plyr)

# Download and unzip dataset to /Project directory

if(!file.exists("./Project")){
  dir.create("./Project")
  }

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url,destfile="./Dataset.zip")

unzip(zipfile="./Dataset.zip",exdir="./Project")


# 1. Merge the training and the test sets to create one data set

# Read training and and test data files
features_train <- read.table("./Project/UCI HAR Dataset/train/X_train.txt", header = FALSE)
activity_train <- read.table("./Project/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

features_test <- read.table("./Project/UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_test <- read.table("./Project/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Read features and activity labels
features_names <- read.table("./Project/UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("./Project/UCI HAR Dataset/activity_labels.txt",  header = FALSE)


# Merge data and assign column names
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
features <- rbind(features_train, features_test)

colnames(subject) <- "Subject"
colnames(activity) <- "Activity"
colnames(features) <- t(features_names[2])

merge_data <- cbind(features,activity,subject)


# 2. Extract only the measurements on the mean and standard deviation for each measurement

col_mean_and_std <- grep(".*Mean.*|.*Std.*", names(merge_data), ignore.case=TRUE)
req_col <- c(col_mean_and_std, 562, 563)
subset_merge_data <- merge_data[,req_col]


# 3. Use descriptive activity names to name the activities in the data set

subset_merge_data$Activity <- as.character(subset_merge_data$Activity)
for (i in 1:6){
              subset_merge_data$Activity[subset_merge_data$Activity == i] <- as.character(activity_labels[i,2])
              }


# 4. Appropriately label the data set with descriptive variable names.

names(subset_merge_data)<-gsub("-mean()", "Mean", names(subset_merge_data), ignore.case = TRUE)
names(subset_merge_data)<-gsub("-std()", "STD", names(subset_merge_data), ignore.case = TRUE)
names(subset_merge_data)<-gsub("^t", "Time", names(subset_merge_data),ignore.case = TRUE)
names(subset_merge_data)<-gsub("^f", "Frequency", names(subset_merge_data),ignore.case = TRUE)


# 5. From the dataset in step#4 create a second, independent tidy data set with the average of each variable for each activity and each subject and write in a txt file

subset_merge_data$Activity <- as.factor(subset_merge_data$Activity)
subset_merge_data$Subject <- as.factor(subset_merge_data$Subject)
subset_merge_data <- data.table(subset_merge_data)

tidy_data <- aggregate(. ~Subject + Activity, subset_merge_data, mean)
tidy_data <- tidy_data[order(tidy_data$Subject,tidy_data$Activity),]
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE, quote = FALSE)
