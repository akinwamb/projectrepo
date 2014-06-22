
## Get table of activity codes and description, and set new column names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="",
                              colClasses=c("numeric","character"))
names(activity_labels) <- c("activity.code","activity.description")

## Get table of feature codes and description, and set new column names
## Change feature description so that it can be use as R name
features <- read.table("UCI HAR Dataset/features.txt",quote="",
                       colClasses=c("numeric","character"))
names(features) <- c("feature.code","feature.description")
features$feature.description <- gsub("-",".",
                                     gsub("[()]","",
                                          features$feature.description))

## Get a vector with the column numbers of the columns we want
column.selector <- features[grepl("mean|std",
                                  features$feature.description),]$feature.code


## First, we obtained a single dataset for test directory

# Get test subjects (only a single code number)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",quote="",
                           colClasses=c("numeric"))
names(subject_test) <- c("subject.code")

## Get test activities (only a single code number)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",quote="",
                      colClasses=c("numeric"))
names(y_test) <- c("activity.code")

## Get test data, set new column names, keep only the columns we want
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",quote="",
                     colClasses=c("numeric"))
names(x_test) <- features$feature.description
x_data <- x_test[,column.selector]

## put selected test together with the other information

test_data <- merge(cbind(subject_test,y_test,x_data),activity_labels,
                   by="activity.code")


## Second, we obtained a single dataset for train directory

# Get train subjects (only a single code number)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",quote="",
                           colClasses=c("numeric"))
names(subject_train) <- c("subject.code")

## Get train activities (only a single code number)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",quote="",
                      colClasses=c("numeric"))
names(y_train) <- c("activity.code")

## Get train data, set new column names, keep only the columns we want
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",quote="",
                     colClasses=c("numeric"))
names(x_train) <- features$feature.description
x_data <- x_train[,column.selector]

## put selected train together with the other information
train_data <- merge(cbind(subject_train,y_train,x_data),activity_labels,
                   by="activity.code")

## Combine two datasets where each dataset from test and train directories
## to obtain the first tidy data set
fdat <- rbind(test_data, train_data)

## The first tidy dataset is 
dim(fdat)
fdat

## Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject 
by1 <- as.factor(fdat$activity.code)
by2 <- as.factor(fdat$subject.code)
sdat <- aggregate(fdat, list(by1, by2), FUN = "mean")

## The second, independent tidy dataset is
dim(sdat)
sdat[,-c(1,2,84)]
