#' We will be using the following libraries

library(dplyr)
library(tidyr)

#'## Read Data

#' Read the X & Y training data.
train_X<-read.table("UCI HAR Dataset/train/X_train.txt",header = F)
train_Y<-read.table("UCI HAR Dataset/train/Y_train.txt",header = F)

#' Read the X & Y test data.
test_X<-read.table("UCI HAR Dataset/test/X_test.txt",header = F)
test_Y<-read.table("UCI HAR Dataset/test/y_test.txt",header = F)

#' Read features, These are the column names of the X Data
features<-read.table("UCI HAR Dataset/features.txt",header=F)

#' Read labels for the Y table
labels<-read.table("UCI HAR Dataset/activity_labels.txt",header = F)

#' Read Subjects who performed the act.
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")

#'##   Merge Training and Test Data

#' Merge Subject
one_subject<-rbind(train_subject,test_subject)

#' Merges X & Y  sets
one_X<-rbind(train_X,test_X)
one_Y<-rbind(train_Y,test_Y)

#' ##  Extracts only the measurements on the mean and standard deviation for each measurement. 

#' I believe that fields containing "MeanFreq" should not be a part of this list, as per the instructions we are supposed to extract only mean and standard deviation fields.
sub_x<-select(one_X,grep("(-mean[(][)])|(-std[(][)])",features$V2))

#' Uses descriptive activity names to name the activities in the data set
 
new_Y<-merge(one_Y,labels,by="V1")
names(new_Y)<-c("Code","Activity")


#' ## Appropriately labels the data set with descriptive variable names. 
 
 
names(sub_x)<-features$V2[grep("(-mean[(][)])|(-std[(][)])",features$V2)]

#' ## At this point we have the merged, cleaned and labelled X & Y Datasets.
#' ## The next step is to 
#' 1. merge the Subject, X & Y Data.
#' 2. Ensure Measurement Values are in a single column.
#' 3. The measurement name's contain 3 separate variable information <Feature, Orientation(X,Y or Z axis), Statistics(Mean or SD)>. As per the principle of Tidy data we will split this into 3 separate columns
#' 4. In accordance to the tidy data principle we will not bind both Code and Activity field from the Y Table. one field should suffice.
#' Note:There are some data fields which do not have orientation, We are ok with them having a value of Na in the Axis column

#' ## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


tidy_data<-sub_x %>%
  #' Add Activity from Y table and Subject from the subject Table
  mutate(Activity=new_Y$Activity,Subject=one_subject$V1)%>% 
  #' Combine all columns other than Activity and Subject in <key,value> pairs of <Measurement, Value>
  gather(key="Measurements",value="Value",-Activity,-Subject) %>% 
 #' Separate Measurement into 3 different columns. 
  separate(Measurements,c("Type","Stat","Axis"),sep="-") %>% 
  #' clean up the column names by removing non alpha numeric characters
  mutate(Stat=gsub("[()]","",Stat)) %>% 
  #' Group the Table according to the required criteria of Subject, Activity and Measurement
  group_by(Subject,Activity,Type,Stat,Axis) %>% 
  #' Compute Average
  summarise(Average=mean(Value))  
  #' Print the computed value

#' The above operation will result in warnings for those measurements which do not have Axis Information.

  print(tidy_data)
str(tidy_data)
  #' ## Write out the final Tidy Data
write.table(tidy_data,file = "tidy_data.txt",row.names = F)
