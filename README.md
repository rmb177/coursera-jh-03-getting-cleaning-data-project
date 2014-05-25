README
============================================

#### Course project for the John Hopkins _Getting and Cleaning Data_ course.

This repository contains the files needed to fulfill the requirements for the
_Getting and Cleaning Data_ course.

The goal of the project was to take the following data set provided at this link:
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

and manipulate the data into a tidy data set. The requirements for the project are
implemented through a single R script, run_anlysis.R. The script works as follows:

1. Verifies the data is present in the current working directory
	* The script will check for the zipped version of the data and unzip it into the current working directory.
	* The script will exit if the (un)zipped data is not present in the current working directory.
2. Reads in activity factors from _activity_labels.txt_.
3. Reads in the observation labels from _features.txt_
	* Extracts the observation labels that deal with the mean and standard deviation of the measurement.
	* These labels are defined as labels that contain either the string "-mean()" or the string "-std()".
	* This results in a subset of 66 labels.
4. Updates the labels to conform to naming guidelines
	* Removes dashes and "()" pairs.
	* Replaces abbreviations with full words (e.g. t=time, acc=Acceleration).
    * Prepends the string "mean" to each column name to signify final output is the average of the measurement for each subject/activity pair.
	* Because of the length of the variable names, camel case naming style is used to make the names more readable.
5. Reads in both the test and training data sets:
	* Filters out the data that does not deal with the mean and standard deviation of the measurements.
	* Replaces activity ids with activity factor labels.
6. Combines the two sets of data into a single data frame.
7. Calculates a new data set that corresponds to the average for all measurements for each subject/activity pair.
	* This data set is written to a file named _tidy_data.csv_.
	* The data set is also the final return value of the script.

See code_book.txt for details about the final output file.

