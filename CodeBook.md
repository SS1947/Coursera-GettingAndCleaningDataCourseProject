# CodeBook

In this repository, I have included a R script called run\_analysis.R that after following transformations, saves tidy data as tidy\_data.txt file.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The details about the input,features,features\_info and activity\_labels, test and train data are available in the downloaded "UCI HAR Dataset" folder.

The output is in the form of a table in which each row represents subject/activity and each column represents a single variable (measurement). Column names are slightly modified using "features.txt" file  and quotes removed to improve readability.