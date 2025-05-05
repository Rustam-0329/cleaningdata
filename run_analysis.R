# install and load required packages and libraries
install.packages("dplyr", "data.table")
library(dplyr)
library(data.table)

# read supporting data
features <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# read train data
x_train <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_train <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#read test data
x_test <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_test <- read.table("C:/Users/Rustam/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# 1.Merges the training and the test sets to create one data set 
subject <- rbind(subject_train, subject_test)
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
alldata <- cbind(subject, Y, X)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement
Data <- alldata %>% 
  select(subject, 
         code, 
         contains("mean"), 
         contains("std"))

# 3.Uses descriptive activity names to name the activities in the data set
Data$code <- activities[Data$code, 2]

# 4.Appropriately labels the data set with descriptive variable names
names(Data)[2] = "activity"
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("^t", "Time", names(Data))
names(Data) <- gsub("^f", "Frequency", names(Data))
names(Data) <- gsub("tBody", "TimeBody", names(Data))
names(Data) <- gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data) <- gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data) <- gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data) <- gsub("angle", "Angle", names(Data))
names(Data) <- gsub("gravity", "Gravity", names(Data))

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject

tidy_Data <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(tidy_Data, "TidyData.txt", row.name=FALSE)

# checking variable names
str(tidy_Data)
