## The following commands were used to create the summary statistics uploaded in the
##TidyData2.txt file.

## Read X feature vector into R
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
## Join train & test X feature vectors and store in data.frame
X <- rbind(xtrain, xtest)

## Read activity labels into R
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
## Join train & test activity labels and store in a data.frame
y <- rbind(ytrain, ytest)

## Read subject labels into R
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## Join train & test subject labels and store in a data.frame
subject <- rbind(subjtrain, subjtest)

## Extract mean and std dev readings and store in separate data frames
mean_xyz <- X[,1:3]
stdev_xyz <- X[, 4:6]

## Get activity names from activity_labels.txt
actlabl <- read.table("./UCI HAR Dataset/activity_labels.txt")
## Create a new y data frame to store y data with descriptive labels
ynew <-data.frame()
for(i in 1: length(y[[1]])) { ynew[i,1] <- actlabl[y[i,1],2]}

## Get header names from features.txt
hdrnames <- read.table("./UCI HAR Dataset/features.txt")

## Apply header names to all data frames
names(X) <- hdrnames[,2]
names(mean_xyz) <- hdrnames[1:3, 2]
names(stdev_xyz) <- hdrnames[4:6,2]
names(ynew) <- "Activity"
names(subject) <- "Subject"

## Combine all data into one data frame
TotData <- cbind(subject, ynew, X)
Totmean <- cbind(subject, ynew, mean_xyz)
Totstdev <- cbind(subject, ynew, stdev_xyz)

## Using the reshape2 package, the Totmean and Totstdev data frames are melted
meanmelt <- melt(Totmean, id=c("Subject", "Activity"), measure.vars=c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-mean()-Z"))
stdevmelt <- melt(Totstdev, id=c("Subject", "Activity"), measure.vars=c("tBodyAcc-std()-X", "tBodyAcc-std()-Y", "tBodyAcc-std()-Z"))
## Create summary stats using mean function by Subject and Activity in meanmelt and stdevmelt
subjMeanSmry <- dcast(meanmelt, Subject ~ variable, mean)
actMeanSmry <- dcast(meanmelt, Activity ~ variable, mean)
subjStdSmry <- dcast(stdevmelt, Subject ~ variable, mean)
actStdSmry <- dcast(stdevmelt, Activity ~ variable, mean)

## write final data sets to text file for upload.
write.table(subjMeanSmry, "TidyData2.txt", sep="/t", row.names=FALSE)
write.table(actMeanSmry, "TidyData2.txt", append=TRUE, sep="/t", row.names=FALSE)
write.table(subjStdSmry, "TidyData2.txt", append=TRUE, sep="\t", row.names=FALSE)
write.table(actStdSmry, "TidyData2.txt", append=TRUE, sep="\t", row.names=FALSE)

