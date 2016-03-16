
setwd("E:/Subhendu/Coursera-master/Coursera-master/Getting_Cleaning_data/Week4")
setwd("./get~")
getwd()
library(data.table)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features <- as.character(features[,2])


featuresAll <- grep(".*mean.*|.*std.*", features)
featuresAll.names <- features[featuresAll]
featuresAll.names = gsub('-mean', 'mean', featuresAll.names)
featuresAll.names = gsub('-std', 'std', featuresAll.names)
featuresAll.names <- gsub('[-()]', '', featuresAll.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresAll]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresAll]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresAll.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = 1:length(activity_labels), labels = activity_labels)
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

tidy_data <- read.table("tidy.txt")
