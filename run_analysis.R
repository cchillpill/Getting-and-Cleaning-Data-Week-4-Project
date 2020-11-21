library(dplyr)

#Download and unzip data

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url, './getdata_projectfiles_UCI HAR Dataset.zip')
unzip('./getdata_projectfiles_UCI HAR Dataset.zip')

#---------------#

#read data files

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt")

#---------------#

# 1. Merges the training and the test sets to create one data set.

X_merge <- rbind(X_train, X_test)
Y_merge <- rbind(Y_train, Y_test)
subject_merge <- rbind(subject_train, subject_test)

#---------------#

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
X_merge_extract <- X_merge[,grep("mean\\(\\)|std\\(\\)", features[,2])]
extract_variable_names <- features[grep("mean\\(\\)|std\\(\\)", features[,2]),2]

#---------------#

# 3. Uses descriptive activity names to name the activities in the data set

Activity <- activity_labels[Y_merge[,1],2]

#---------------#

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_merge_extract) <- extract_variable_names

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

colnames(subject_merge) <- "Subject"
total <- cbind(X_merge_extract, Activity, subject_merge)
total_mean <- total %>% group_by(Activity, Subject) %>% summarise_all(.funs = c(mean="mean"))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
tidy <- read.table("./UCI HAR Dataset/tidydata.txt", header = TRUE)
View(tidy)