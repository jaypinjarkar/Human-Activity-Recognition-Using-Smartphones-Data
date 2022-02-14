library(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
#Merges the training and the test sets
dataActivityTest <- read.table( file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","y_test.txt")  ,header = FALSE)
dataActivitytrain <- read.table( file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","y_train.txt")  ,header = FALSE)

dataSubjectTest <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","subject_train.txt"), header = FALSE)

datafeaturesTest <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","X_test.txt"), header = FALSE)
datafeaturesTrain <-read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","X_train.txt"), header = FALSE)

dataActivity <- rbind(dataActivityTest,dataActivitytrain)
datasubject <- rbind(dataSubjectTest,dataSubjectTrain)
datafeatures <- rbind(datafeaturesTest,datafeaturesTrain)

#Extracts only the measurements on the mean and standard deviation
names(dataActivity)<- c("Activity")
names(datasubject)<- c("subject")
datafeaturesNames<- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset","features.txt"),header = FALSE)
names(datafeatures)<- datafeaturesNames$V2

tempData  <- cbind(dataActivity,datasubject)
allData <- cbind(datafeatures,tempData) 

meanAndStd<-  as.data.frame( select(allData,contains("mean()"),contains("std()"),matches("Activity"),matches("subject")))

#descriptive activity names to name the activities in the data set
ActivityNames <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset","activity_labels.txt"),header = FALSE)

meanAndStd$Activity <- ActivityNames[meanAndStd$Activity, 2]

#Appropriately labels the data set
names(meanAndStd) <- gsub("^t","time",names(meanAndStd))
names(meanAndStd) <- gsub("Acc","accelerometer",names(meanAndStd))
names(meanAndStd) <- gsub("^f","freaquency",names(meanAndStd))
names(meanAndStd) <- gsub("BodyBody","Body",names(meanAndStd))
names(meanAndStd) <- gsub("Gyro","Gyroscope",names(meanAndStd))
names(meanAndStd) <- gsub("Mag","magnitude",names(meanAndStd))

#, independent tidy data set with the average of each variable for each activity and each subject.
finalData <- meanAndStd %>% group_by(meanAndStd$Activity,meanAndStd$subject)%>% 
  summarise_all(funs(mean))
write.table(finalData,file = "finalData.txt",row.names = FALSE)
