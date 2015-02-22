The process to collect, work with, and clean a data set
=======================================================
* ### Original dataset  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* ### The requirements to prepare tidy data:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set 
     with the average of each variable for each activity and each subject.
* ### Merge the data from _train_ and _test_ folders  
  ```javescript  
  colnames:     ActivityID,       subjectID,          V1-V66 
  observation:  y_train.txt,      subject_train.txt,  X_train.txt
                y_test.txt,       subject_test.txt,   X_test.txt
  ```
  + 7352 obs. of train group, 2947 obs. of test group  
  + 10299 obs. of combined dataset
* ### Name ActivityID with descriptive activity names, then remove ActivityID column
  merge(combined dataset, activity_labels.txt, by = activityID)  
  ```javescript  
  colnames:     Activity,               subjectID,          V1-V66 
  observation:  activity_labels.txt,    subject_train.txt,  X_train.txt
                activity_labels.txt,    subject_test.txt,   X_test.txt
  ```
* ### Label the data set with descriptive variable names
  get the variable names from feature.txt
  ```javescript
  colnames:     Activity,               subjectID,          feature.txt 
  observation:  activity_labels.txt,    subject_train.txt,  X_train.txt
                activity_labels.txt,    subject_test.txt,   X_test.txt
  ```
* ### Calculate average of each variable in the feature.txt for each activity and each subject
  + split the dataset by activities(6) and subjects(30) 
  + calculate the mean value of features(66)
  + the output is 180 obs. × 68 var. (Activity, subjectID, features(66))
* ### write average value table to file  
> UCI-HAR-Dateset-tidy-version.txt