library(dplyr)
library(tidyr)

#Read the training data.
train_X<-read.table("UCI HAR Dataset/train/X_train.txt",header = F)
train_Y<-read.table("UCI HAR Dataset/train/Y_train.txt",header = F)


#Read the test data.
test_X<-read.table("UCI HAR Dataset/test/X_test.txt",header = F)
test_Y<-read.table("UCI HAR Dataset/test/y_test.txt",header = F)

# Read features
features<-read.table("UCI HAR Dataset/features.txt",header=F)

#Read labels for the Y table
labels<-read.table("UCI HAR Dataset/activity_labels.txt",header = F)

#Merges the training and the test sets to create one data set.
one_X<-rbind(train_X,test_X)
one_Y<-rbind(train_Y,test_Y)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
sub_x<-select(one_X,grep("(-mean)|(-std)",features$V2))

#Uses descriptive activity names to name the activities in the data set
new_Y<-merge(one_Y,labels,by="V1")
names(new_Y)<-c("Code","Activity")
#Appropriately labels the data set with descriptive variable names. 
names(sub_x)<-features$V2[grep("(-mean)|(-std)",features$V2)]
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#There are some data fields which do not have orientation, We are ok with them having a value of Na in the Axis column
tidy_data<-sub_x %>%
  mutate(Activity=new_Y$Activity)%>%
  gather(key="Measurements",value="Value",-Activity) %>%
separate(Measurements,c("Type","Stat","Axis"),sep="-") %>%
  mutate(Stat=gsub("[()]","",Stat)) %>%
  print

# We have a question on whether the Activity of Walking,Walking_<Direction> should also be split. While it can be looked as two groups of stationary vs motion with a vector. I do not think these are two spearate items. 
# The data format used for Value is base+Exponent, it is not clear whether we should convert this to numeric type. leaving it as it is.
write.table(tidy_data,file = "tidy_data.txt",row.names = F)
