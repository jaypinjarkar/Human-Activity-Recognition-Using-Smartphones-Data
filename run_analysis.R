dataActivityTest <- read.table( file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","y_test.txt")  ,header = FALSE)
dataActivitytrain <- read.table( file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","y_train.txt")  ,header = FALSE)

dataSubjectTest <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","subject_train.txt"), header = FALSE)

datafeaturesTest <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test","X_test.txt"), header = FALSE)
datafeaturesTrain <-read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train","X_train.txt"), header = FALSE)

dataActivity <- rbind(dataActivityTest,dataActivitytrain)
datasubject <- rbind(dataSubjectTest,dataSubjectTrain)
datafeatures <- rbind(datafeaturesTest,datafeaturesTrain)

names(dataActivity)<- c("Activity")
names(datasubject)<- c("subject")
datafeaturesNames<- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset","features.txt"),header = FALSE)
names(datafeatures)<- datafeaturesNames$V2

tempData  <- cbind(dataActivity,datasubject)
allData <- cbind(datafeatures,tempData) 

meanAndStd<-  as.data.frame( select(allData,contains("mean()"),contains("std()"),matches("Activity"),matches("subject")))
library(dplyr)

ActivityNames <- read.table(file.path("~/Rproject problem/getting and cleaning data project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset","activity_labels.txt"),header = FALSE)

meanAndStd$Activity <- ActivityNames[meanAndStd$Activity, 2]

names(meanAndStd) <- gsub("^t","time",names(meanAndStd))
names(meanAndStd) <- gsub("Acc","accelerometer",names(meanAndStd))
names(meanAndStd) <- gsub("^f","freaquency",names(meanAndStd))
names(meanAndStd) <- gsub("BodyBody","Body",names(meanAndStd))
names(meanAndStd) <- gsub("Gyro","Gyroscope",names(meanAndStd))
names(meanAndStd) <- gsub("Mag","magnitude",names(meanAndStd))

finalData <- meanAndStd %>% group_by(meanAndStd$Activity,meanAndStd$subject)%>% 
  summarise_all(funs(mean))
write.table(finalData,file = "finalData.txt",row.names = FALSE)
