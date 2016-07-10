data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "data.zip"
data_folder <- "raw_data"

## Download and unzip the original datasource if we haven't already.
if (!file.exists(data_folder)) {
    download.file(data_url, zip_file)
    unzip(zip_file, exdir=data_folder)
    file.remove(zip_file)
}

################################################################################
## 1. Merge the training and test sets to create one data set.
################################################################################

## Read all of the tables we need and assign column names.
activity_labels <- read.table(
    paste(data_folder, "UCI HAR DataSet/activity_labels.txt", sep="/"),
    col.names = c("activity.id", "activity.name")
)
features <- read.table(
    paste(data_folder, "UCI HAR DataSet/features.txt", sep="/"),
    col.names = c("feature.id", "feature.name")
)
subject_test <- read.table(
    paste(data_folder, "UCI HAR DataSet/test/subject_test.txt", sep="/"),
    col.names = c("subject.id")
)
subject_train <- read.table(
    paste(data_folder, "UCI HAR DataSet/train/subject_train.txt", sep="/"),
    col.names = c("subject.id")
)
Y_test <- read.table(
    paste(data_folder, "UCI HAR DataSet/test/Y_test.txt", sep="/"),
    col.names = c("activity.id")
)
Y_train <- read.table(
    paste(data_folder, "UCI HAR DataSet/train/Y_train.txt", sep="/"),
    col.names = c("activity.id")
)
X_test <- read.table(
    paste(data_folder, "UCI HAR DataSet/test/X_test.txt", sep="/"),
    col.names = features[,c("feature.name")]
)
X_train <- read.table(
    paste(data_folder, "UCI HAR DataSet/train/X_train.txt", sep="/"),
    col.names = features[,c("feature.name")]
)

## Combine the test and train data tables.
test <- cbind(subject_test, Y_test, X_test)
train <- cbind(subject_train, Y_train, X_train)
df <- rbind(test, train)


################################################################################
## 2. Extract only the measurements on the mean and standard deviation for each
##    measurement.
################################################################################
df <- df[, grepl("subject.id|activity.id|[Mm]ean|[Ss]td", colnames(df))]


################################################################################
## 3. Use descriptive activity names to name the activities in the data set.
################################################################################
df <- merge(df, activity_labels, by='activity.id')
df$activity.id <- NULL


################################################################################
## 4. Appropriately label the data set with descriptive variable names
################################################################################
colnames(df) <- lapply(colnames(df), function(x) gsub("\\.+", ".", x))
colnames(df) <- lapply(colnames(df), function(x) gsub("\\.$", "", x))

################################################################################
## 5. From the data set in step 4, create a second, independent tidy data set
##    with the average of each variable for each activity and each subject.
################################################################################
tidy <- aggregate(. ~activity.name + subject.id, df, mean)
write.table(tidy, "tidy.txt", quote = FALSE)
