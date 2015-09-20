---
title: "Tidy Data Assignment"
author: "Vijayvithal"
date: "20 September 2015"
output: html_document
---

# Functionality of the analysis script.

The code is well commented with the actions that are taking place.

Our First step is to read the training and test data, Features and labels 

in the next stage the training and test data is merged.
From the merged data for X we extract only those columns which correspond to mean or SD using select and grep. And apply column variables names to this set

For the y Dataset we use merge to get descriptive names for the activities.

# Creation of Tidy Data.

* We use mutate to merge the Y label's with the X Data thus combining observations split across two tables in a single table.
* We transform the data from wide to long format using gather.
* The measurement column now has data for 3 separate variables,Measurement type, The Stat collected and the Axis along which the stat was collected.
 * We use separate to separate the measurement in 3 diferent columns. Note some of the measurements do not have the Axis parameters and these show up as Na in teh Axis column.
* The Stat column contains Non alpha numeric characters.. use mutate with gsub to remove them.

Finally the resultant tidy data set is written out to the file


# Codebook

The dataset is derived from the Sansung dataset.
The filtered dataset contains the following fields

* Activity : This is Walking, Laying, Sitting etc.
* Subject : This is the code assigned to each of the person who took part in the experiment
* Type : This is the measurement type
* Stat : This is the Stat on the measurement, could be either mean or sd
* Axis : the Axis on which the measurement was taken. Note some of the measurements types are independent of axis These are marked as NA
* Value : the value of the measurement.
