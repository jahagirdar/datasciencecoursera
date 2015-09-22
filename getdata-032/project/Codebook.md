---
title: "Codebook"
author: "Vijayvithal"
date: "22 September 2015"
output: html_document
---
The file tidy_data.txt contains the data generated after processing the data from UCI-HAR-Dataset (
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )
as per the following steps.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This processed dataset contains the following fields.

* Subject : This is an integer field which identifies each of the participants in this experiment
* Activity: This is a string, This field represents the 6 different activities that the subjects performed
* Type    : This is a string field, This field captures the Type of Measurement.
* Stat    : This is a string field that takes one of the following two values <mean/std>. This field captures the type statistical computation that is being recorded for that subject performing that activity.
* Axis    : This is a single character string. This captures the vector direction of the measurement along the X,Y or Z axis. Some of the measurements do not have vector information. These are represented by NA in this column.
* Average : This is a numeric field. This field captures the Average of the Given measurement. For a given combination of <Subject,Activity,Type,Stat,Axis> we have approx 300+ measurements for mean and sd. This field captures the average of all those records.

