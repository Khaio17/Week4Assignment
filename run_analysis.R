# load library

library(dplyr)

# read training files

X_train <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("~/Desktop/UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt")

# read test files
X_test <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("~/Desktop/UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt")

# read features file
features <- read.table("~/Desktop/UCI HAR Dataset/features.txt")

# read activity labels file 
activity_labels <- read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt")

# 1.Merge the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
sub <- rbind(sub_train,sub_test)

# 2.Extract only the measurements on the mean and standard deviation for each measurement.
features_only <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X <- X[,features[,1]]

# 3.Use descriptive activity names to name the activities in the data set.
# 4.Appropriately labels the data set with descriptive variable names.
colnames(Y) <- "activity"
Y$activity <- factor(Y$activity, labels = as.character(activity_labels[,2]))
colnames(X) <- features[features_only[,1],2]
colnames(sub) <- "subject"
names(X)<-gsub("Acc", "Accelerometer", names(X),ignore.case = TRUE)
names(X)<-gsub("Gyro", "Gyroscope", names(X),ignore.case = TRUE)
names(X)<-gsub("BodyBody", "Body", names(X),ignore.case = TRUE)
names(X)<-gsub("Mag", "Magnitude", names(X),ignore.case = TRUE)
names(X)<-gsub("^t", "Time", names(X),ignore.case = TRUE)
names(X)<-gsub("^f", "Frequency", names(X),ignore.case = TRUE)
names(X)<-gsub("tBody", "TimeBody", names(X),ignore.case = TRUE)
names(X)<-gsub("-mean()", "Mean", names(X), ignore.case = TRUE)
names(X)<-gsub("-std()", "STD", names(X), ignore.case = TRUE)
names(X)<-gsub("-freq()", "Frequency", names(X), ignore.case = TRUE)
names(X)<-gsub("angle", "Angle", names(X),ignore.case = TRUE)
names(X)<-gsub("gravity", "Gravity", names(X),ignore.case = TRUE)

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data <- cbind(sub,Y,X)
second_data <- data %>% group_by(activity, subject) %>% summarize_each(list(mean))
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
