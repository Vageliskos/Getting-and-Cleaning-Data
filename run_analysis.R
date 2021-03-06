 setwd("C:/Users/Pitas/Documents/R Working Directory/Getting and Cleaning Data/UCI HAR Dataset")
 
 # reading
 features <- read.table("features.txt")
 al <- read.table("activity_labels.txt")
 
 xtest <- read.table("./test/X_test.txt")
 ytest <- read.table("./test/y_test.txt")
 sbtest <- read.table("./test/subject_test.txt")
 
 xtrain <- read.table("./train/X_train.txt")
 ytrain <- read.table("./train/y_train.txt") 
 sbtrain <- read.table("./train/subject_train.txt")
 
 # part 1
 dataset <- rbind(xtrain,xtest)
 
 # part 2
 index <- grep("mean|std",features$V2)
 dataset <- dataset[,index]
 
 # part 4
 var_names<- sapply(features[, 2], function(x) { gsub("[()]", "",x)})
 var_names <- sapply(var_names, function(x) { gsub("-",".",x)})
 names(dataset) <- var_names[index]
 
 # part 3
 subject <- rbind(sbtrain, sbtest)
 names(subject) <- "subject"
 activity <- rbind(ytrain, ytest)
 names(activity) <- "activity"
 
 dataSet <- cbind(subject,activity, dataset)
 
 act_names <- factor(dataSet$activity)
 levels(act_names) <- al[,2]
 dataSet$activity <- act_names
 
 # part 5
 library(reshape2)
 meltData <- melt(dataSet,(id.vars=c("subject","activity")))
 tidySet <- dcast(meltData, subject + activity ~ variable, mean)
 write.table(tidySet, "tidy_dataSet.txt", sep = ",",row.name=FALSE)
 