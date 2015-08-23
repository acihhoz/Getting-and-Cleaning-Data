=============================================================================
CodeBook for run_analysis.R 
=============================================================================

The data this script is written for is motion data recorded by Samsung Galaxy
5 cell phones to improve user activity recognition. Thirty subjects, 21 in
the training group and 9 in the test group, performed six activities as the
accelerometers and gyroscopes in each phone recorded measurements:

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

of the variables:

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

Where XYZ refers to measurements in each cartesian direction or in the direction of the three dimensional vector, variables differentiate between acceleration of the Body and acceleration due to Gravity, whether the reading is from the accelerometer or gyroscope (Acc or Gyro), and readings of the the body linear acceleration and angular velocity were used to measure the Jerk of the motion.

In both the test and training groups there were also two files of vector data 
that identified the subject from whom the measurement was taken and the activity they were doing at the time of the measurement.The complete list of individual variables can be found in the “features.txt” file in the folder containing the original dataset.

Subjects were numbered 1-30 and no differentiation was made in the final analysis between the training subjects and the test subjects as they could be individually tracked with ease through their numbers in the data. 

The Activity labels were as follows:

1 - Walking
2 - Walking Upstairs
3 - Walking Downstairs
4 - Sitting
5 - Standing
6 - Laying Down

Though the numerical values are replaced by these strings by the script. 

===========
The Script
===========

The script first reads in the data from the files in the original dataset to be used.

=== Step 1

The subject and activity vectors are read in to R as the vectors “trainWho” and “trainY” and are combined into the data frame “trainframe” with “trainX” with the cbind() function. The same process builds the data frame “testframe”. Data frames “trainframe” and “testframe” are combined using rbind() to create the dataset containing all the relevant data: “masterframe”.

=== Step 2

The column numbers and names of the variables in the features vector that were means or standard deviation measurements were found using the grep() function. A new data frame containing  “extracteddata” was created by subsetting the “masterframe” using the column numbers found with grep().

=== Step 4

The variables were given names that were simple adjustments to their names in the feature vector to increase consistency and readability. I used the sub() function to make the following changes to all of the names of the features:

* All parentheses and dashes removed
* The abbreviation “meanFreq” was expanded to “Mean Frequency”
* The measurement identifiers “mean” and “std” were changed to “Mean” and “StDev”
* ”Mag” was expanded to “Magnitude”
* The vector direction identifiers were placed immediately after the portion of the name identifying which sensor was taking the measurement and the source of the measured quantity (So that it followed the tBodyAcc, etc.) to make it easier to search for measurements along certain cartesian vector directions and the magnitude values.

=== Step 3

Once these changes were made to the vector containing the variable names the vector was stored as the column names for the data frame “extracteddata”. The data was then sorted according to the subject and activity numbers in increasing order and stored under the new name “sorteddata”. I used bracket subsetting to store the names of the activities in place of their numbers in “sorteddata”.


*** Steps 3 and 4 were done out of order only so that the activities column could be used for easy subsetting in step 5, without having to reapply changes made earlier.

=== Step 5

The dataset “largedata” was created with the same ordering function used to create “sorteddata”, however since it used “extracteddata” the activity column had not been replaced with the names of the activities. 

A vector “dummyvector” was created with length equal to the total number of columns in the extracted dataset. This vector was simply an anchor to rowbind the rows of column averages calculated to form the tidy dataset.

I used a set of two nested for() loops to fill the new tidy dataset. The first for loop selects each subject by number, 1 to 30, and subsets the data frame “largedata” to only the measurements from that subject. For every subject, the second for loop calculates the average value for every variable for each activity, looping from 1 to 6. This is why it was important that the Activity column had not been replaced with a character vector yet. For every loop of the second for loop I used rbind() to attach the averages to the anchor vector and progressively fill the tidy dataset. The for loops also programmatically filled out the “Subject” and “Activity” columns with the appropriate values as they would be a simple pattern in the tidy data frame.

The data frame “tidydata” was created by subsetting the first row, the anchor vector, out of the newly filled out “dummyvector” data frame. Finally, I reapplied the names of the “Subject” and “Activity” columns (they had to be taken out for the calculation of the column means). 