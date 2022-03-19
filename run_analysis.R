##Coursera assingment for the course "Obtaining and Cleaning Data"

##directory of assignment
setwd("D:/Coursera/Obtaining and cleaning data/Assignment/UCI HAR Dataset")
library(dplyr)

##loading files
features <- read.table("features.txt", col.names = c("id_function", "functions"))
activities <- read.table("activity_labels.txt", col.names = c("id_activ","activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

##Exercise 1: Merges the training and the test sets to create one data set
merge_subject <- rbind(subject_test,subject_train)
merge_x <- rbind(x_test, x_train)
merge_y <- rbind(y_test, y_train)
merge_data <- cbind(merge_subject, merge_y, merge_x)

##Exercise 2: Extracts only the measurements on the mean and standard deviations for each measurement
Dataset1 <- select(merge_data, subject, code, contains("mean") | contains("std"))

##Exercise 3: Use descriptive activity names to name the activities in the data set
Dataset1$code <- activities[Dataset1$code, 2]
Dataset1 <- rename(Dataset1, Activity = code)

##Exercise 4: Appropriately labels the data set with descriptive variable names
colnames(Dataset1) <- gsub("Acc", "Accelerometer", colnames(Dataset1))
colnames(Dataset1) <- gsub("Gyro", "Gyroscope", colnames(Dataset1))
colnames(Dataset1) <- gsub("^t", "Time", colnames(Dataset1))
colnames(Dataset1) <- gsub("^f", "Frequency", colnames(Dataset1))
colnames(Dataset1) <- gsub("Mag", "Magnitude", colnames(Dataset1))
colnames(Dataset1) <- gsub("BodyBody", "Body", colnames(Dataset1))

#Exercise 5: From the data in step 4, creates a second, independent tidy data set with the average of each activity and each subject
Dataset2 <- Dataset1 %>% group_by(subject, Activity) %>% summarize_all(mean)


#Export data sets
write.table(Dataset2, file = "Dataset2.txt", row.names = FALSE)



