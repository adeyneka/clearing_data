require("data.table")
require("plyr")

# 1. Merges the training and the test sets to create one data set.
dataSet<-rbind(cbind(read.table("UCI HAR Dataset/train/subject_train.txt"), 
                     read.table("UCI HAR Dataset/train/y_train.txt"), 
                     read.table("UCI HAR Dataset/train/X_train.txt")), 
               cbind(read.table("UCI HAR Dataset/test/subject_test.txt"),
                     read.table("UCI HAR Dataset/test/y_test.txt"), 
                     read.table("UCI HAR Dataset/test/X_test.txt")))

features<-read.table("UCI HAR Dataset/features.txt", colClasses = c("character"))

names(dataSet)<-rbind(c("Subject", "Id", features[,2]))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

dataSetMeanStd <- dataSet[,grepl("mean\\(\\)|std\\(\\)|Subject|Id", names(dataSet))]

# 3. Uses descriptive activity names to name the activities in the data set.

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Id", "Activity"))

dataSetMeanStd <- join(dataSetMeanStd, activities, by = "Id", match = "first")
dataSetMeanStd <- dataSetMeanStd[,-1]

# 4. Appropriately labels the data set with descriptive activity names.

names(dataSetMeanStd) <- gsub("([()])","",names(dataSetMeanStd))
names(dataSetMeanStd) <- make.names(names(dataSetMeanStd))

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

finalData<-ddply(dataSetMeanStd, c("Subject","Activity"), numcolwise(mean))
write.table(finalData, file = "average_by_activity_and_subject.txt", row.name=FALSE)