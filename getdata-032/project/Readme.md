We will be using the following libraries


```r
library(dplyr)
library(tidyr)
```

## Read Data
Read the X & Y training data.


```r
train_X<-read.table("UCI HAR Dataset/train/X_train.txt",header = F)
train_Y<-read.table("UCI HAR Dataset/train/Y_train.txt",header = F)
```

Read the X & Y test data.


```r
test_X<-read.table("UCI HAR Dataset/test/X_test.txt",header = F)
test_Y<-read.table("UCI HAR Dataset/test/y_test.txt",header = F)
```

Read features, These are the column names of the X Data


```r
features<-read.table("UCI HAR Dataset/features.txt",header=F)
```

Read labels for the Y table


```r
labels<-read.table("UCI HAR Dataset/activity_labels.txt",header = F)
```

Read Subjects who performed the act.


```r
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
```

##   Merge Training and Test Data
Merge Subject


```r
one_subject<-rbind(train_subject,test_subject)
```

Merges X & Y  sets


```r
one_X<-rbind(train_X,test_X)
one_Y<-rbind(train_Y,test_Y)
```

##  Extracts only the measurements on the mean and standard deviation for each measurement. 
I believe that fields containing "MeanFreq" should not be a part of this list, as per the instructions we are supposed to extract only mean and standard deviation fields.


```r
sub_x<-select(one_X,grep("(-mean[(][)])|(-std[(][)])",features$V2))
```

Uses descriptive activity names to name the activities in the data set


```r
new_Y<-merge(one_Y,labels,by="V1")
names(new_Y)<-c("Code","Activity")
```

## Appropriately labels the data set with descriptive variable names. 


```r
names(sub_x)<-features$V2[grep("(-mean[(][)])|(-std[(][)])",features$V2)]
```

## At this point we have the merged, cleaned and labelled X & Y Datasets.
## The next step is to 
1. merge the Subject, X & Y Data.
2. Ensure Measurement Values are in a single column.
3. The measurement name's contain 3 separate variable information <Feature, Orientation(X,Y or Z axis), Statistics(Mean or SD)>. As per the principle of Tidy data we will split this into 3 separate columns
4. In accordance to the tidy data principle we will not bind both Code and Activity field from the Y Table. one field should suffice.
Note:There are some data fields which do not have orientation, We are ok with them having a value of Na in the Axis column
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


```r
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
```
The above operation will result in following warnings for those measurements which do not have Axis Information.

```
## Warning: Too few values at 185382 locations: 308971, 308972, 308973,
## 308974, 308975, 308976, 308977, 308978, 308979, 308980, 308981, 308982,
## 308983, 308984, 308985, 308986, 308987, 308988, 308989, 308990, ...
```

```r
  #' Print the computed value
```



```r
  print(tidy_data)
```

```
## Source: local data frame [2,310 x 6]
## Groups: Subject, Activity, Type, Stat [?]
## 
##    Subject Activity         Type  Stat  Axis    Average
##      (int)   (fctr)        (chr) (chr) (chr)      (dbl)
## 1        1  WALKING     fBodyAcc  mean     X -0.5318952
## 2        1  WALKING     fBodyAcc  mean     Y -0.4064354
## 3        1  WALKING     fBodyAcc  mean     Z -0.5964112
## 4        1  WALKING     fBodyAcc   std     X -0.5530606
## 5        1  WALKING     fBodyAcc   std     Y -0.3901509
## 6        1  WALKING     fBodyAcc   std     Z -0.4985831
## 7        1  WALKING fBodyAccJerk  mean     X -0.5473489
## 8        1  WALKING fBodyAccJerk  mean     Y -0.5073436
## 9        1  WALKING fBodyAccJerk  mean     Z -0.6953051
## 10       1  WALKING fBodyAccJerk   std     X -0.5439798
## ..     ...      ...          ...   ...   ...        ...
```

```r
str(tidy_data)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	2310 obs. of  6 variables:
##  $ Subject : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activity: Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ Type    : chr  "fBodyAcc" "fBodyAcc" "fBodyAcc" "fBodyAcc" ...
##  $ Stat    : chr  "mean" "mean" "mean" "std" ...
##  $ Axis    : chr  "X" "Y" "Z" "X" ...
##  $ Average : num  -0.532 -0.406 -0.596 -0.553 -0.39 ...
##  - attr(*, "vars")=List of 4
##   ..$ : symbol Subject
##   ..$ : symbol Activity
##   ..$ : symbol Type
##   ..$ : symbol Stat
##  - attr(*, "drop")= logi TRUE
```

```r
  #' ## Write out the final Tidy Data
write.table(tidy_data,file = "tidy_data.txt",row.names = F)
```

