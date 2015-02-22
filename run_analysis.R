library(dplyr)
##Step1 Merges the training and the test sets to create one data set.
##merge data of train folder
data_train <- read.csv(
    "~/UCI HAR Dataset/train/subject_train.txt",
    header = FALSE,
    stringsAsFactors = FALSE)
new_var <- read.csv(
    "~/UCI HAR Dataset/train/y_train.txt",
    header = FALSE,
    stringsAsFactors = FALSE)
data_train <- cbind(data_train, new_var)
new_var <- read.csv(
    "~/UCI HAR Dataset/train/X_train.txt",
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE)
data_train <- cbind(data_train, new_var)
##merge data of test folder
data_test <- read.csv(
    "~/UCI HAR Dataset/test/subject_test.txt",
    header = FALSE,
    stringsAsFactors = FALSE)
new_var <- read.csv(
    "~/UCI HAR Dataset/test/y_test.txt",
    header = FALSE,
    stringsAsFactors = FALSE)
data_test <- cbind(data_test, new_var)
new_var <- read.csv(
    "~/UCI HAR Dataset/test/X_test.txt",
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE)
data_test <- cbind(data_test, new_var)

##combine two data sets
data_all <- rbind(data_train, data_test)

##Step2 Extracts only the measurements on the mean and standard deviation for each measurement.
##names the col
features <- read.csv(
    "~/UCI HAR Dataset/features.txt",
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE)
names(data_all) <- c("subjectID", "ActivityID", features[,2])
##select the cols whose names contain 'mean()' or 'std()'
data_all <- data_all[, !duplicated(names(data_all))]
data_target <- select(data_all, contains("mean()"))
data_target <- cbind(data_target, select(data_all, contains("std()")))
data_target <- cbind(select(data_all, one_of("subjectID", "ActivityID")), data_target)

##Step3 Uses descriptive activity names to name the activities in the data set.
activity <- read.csv(
    "~/UCI HAR Dataset/activity_labels.txt",
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE,
    col.names = c("ActivityID", "Activity"))
data_target <- merge(activity, data_target, by = "ActivityID")
data_target <- select(data_target, -one_of("ActivityID"))

##Step4 Appropriately labels the data set with descriptive variable names.
names_list <- names(data_target)
names_list <- gsub("-", ".", names_list)
names_list <- gsub("\\()", "", names_list)
names(data_target) <- names_list

##Step5 creates a data set with the average of each variable for each activity and each subject.
data_split <- split(data_target, data_target$subjectID)
for(i in 1:length(data_split)){
    for(j in 3:68){
        data_mean <- tapply(data_split[[i]][[j]], data_split[[i]][[1]], mean)
        ##data_mean <- round(data_mean, digit = 10)
        if((j-2) == 1){
            data_mean_subject <- data_mean
            data_mean_subject <- cbind(subjectID=rep(i,nrow(data_mean)), data_mean_subject)
        }else{
            data_mean_subject <- cbind(data_mean_subject, data_mean)
        }
        
    }
    if(i == 1){
        data_new <- data_mean_subject
    }else{
        data_new <- rbind(data_new, data_mean_subject)
    }
}
data_new <- as.data.frame(cbind(row.names(data_new), data_new))
options(digits = 10)
suffix <- c("", "", rep(".mean", ncol(data_new) - 2))
names_list <- paste(names_list, suffix, sep="")
colnames(data_new) <- names_list

write.table(data_new, file = "UCI-HAR-Dateset-tidy-version.txt", row.names = FALSE)