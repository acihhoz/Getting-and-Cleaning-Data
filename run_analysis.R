setwd("Documents/Getting and Cleaning Data/UCI HAR Dataset")


### Notes

## Activity Labels:

#1 - Walking
#2 - Walking Upstairs
#3 - Walking Downstairs
#4 - Sitting
#5 - Standing
#6 - Laying Down

## Sizes:

#trainX dimensions 7352x561
#trainY dimensions 7352x1
#trainWho dimensions 7352x1

#trainX dimensions 2947x561
#trainY dimensions 2947x1
#trainWho dimensions 2947x1

### Code

## Reshaping and Merging the data sets

trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainWho <- read.table("train/subject_train.txt")

trainframe <- cbind(trainWho,trainY,trainX)

testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testWho <- read.table("test/subject_test.txt")

testframe <- cbind(testWho,testY,testX)

masterframe <- rbind(trainframe,testframe)

## Consolidating and Simplifying

# mention in codebook that the grep function found all the mean values
# that were not involved in the calculation of something else

meancolnumbers <- grep("mean",features$V2)
stdcolnumbers <- grep("std",features$V2)
extractedcolumns <- sort(c(1,2,meancolnumbers+2,stdcolnumbers+2))

extracteddata <- masterframe[,extractedcolumns]

## Tidying the Data

# Applying Variable Labels

features <- read.table("features.txt")
featurenames <- as.character(features[sort(c(meancolnumbers,stdcolnumbers)),2])
featurenames <- sub("\\()-\\b"," ",featurenames)
featurenames <- sub("\\()\\b","",featurenames)
featurenames <- sub("\\-\\b"," ",featurenames)
featurenames <- sub("\\meanFreq\\b","Mean Frequency",featurenames)
featurenames <- sub("\\mean\\b","Mean",featurenames)
featurenames <- sub("std","StDev",featurenames)
featurenames <- sub("Mag"," Magnitude",featurenames)
featurenames <- sub("Mean X","X Mean",featurenames)
featurenames <- sub("Mean Y","Y Mean",featurenames)
featurenames <- sub("Mean Z","Z Mean",featurenames)
featurenames <- sub("StDev X","X StDev",featurenames)
featurenames <- sub("StDev Y","Y StDev",featurenames)
featurenames <- sub("StDev Z","Z StDev",featurenames)
featurenames <- sub("Mean Frequency X","X Mean Frequency",featurenames)
featurenames <- sub("Mean Frequency Y","Y Mean Frequency",featurenames)
featurenames <- sub("Mean Frequency Z","Z Mean Frequency",featurenames)

colnames(extracteddata) <- c("Subject","Activity",featurenames)

sorteddata <- extracteddata[order(extracteddata$Subject,extracteddata$Activity),]

# Applying Activity Labels

sorteddata[sorteddata$Activity == 1,][2] <- "Walking"
sorteddata[sorteddata$Activity == 2,][2] <- "Walking Upstairs"
sorteddata[sorteddata$Activity == 3,][2] <- "Walking Downstairs"
sorteddata[sorteddata$Activity == 4,][2] <- "Sitting"
sorteddata[sorteddata$Activity == 5,][2] <- "Standing"
sorteddata[sorteddata$Activity == 6,][2] <- "Laying Down"

# Step 4 dataset (sorteddata)

View(sorteddata)

# Independent Dataset (tidydata)

largedata <- extracteddata[order(extracteddata$Subject,extracteddata$Activity),]

dummyvector <- numeric(length = 81)

for(i in 1:30){
  
  subjectdata <- largedata[largedata$Subject == i,]
  
  for(j in 1:6){
    
    activitymeans <- colMeans(subjectdata[subjectdata$Activity == j,3:81])
    dummyvector <- rbind(dummyvector,c(i,j,activitymeans))
  }
}

dim(dummyvector)

tidydata <- as.data.frame(dummyvector[2:180,])
colnames(tidydata)[1:2] <- c("Subject","Activity")

View(tidydata)

tidydata
