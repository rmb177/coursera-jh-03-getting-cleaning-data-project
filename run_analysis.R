library(reshape2)

DATA_FOLDER <- "./UCI HAR Dataset"
NUM_TEST_OBS <- 2947
NUM_TRAIN_OBS <- 7352

# "main" method to create the tidy data set
create_data_set <- function()
{
    if (!validate_files_present())
    {
        print("The data set is not available. Program will exit.")
        return
    }

    # Read in general data
    activity_factors <- read.table(paste(DATA_FOLDER, "activity_labels.txt", sep="/"))
    features <- read.table(paste(DATA_FOLDER, "features.txt", sep="/"))    
    filtered_features <- features[grepl("-mean\\(\\)", features[,2]) | grepl("-std\\(\\)", features[,2]),]    
    filtered_features_char <- standardize_column_names(sapply(filtered_features[,2], function(x) as.character(x)))

    # Read in test data
    test_subjects <- scan(paste(DATA_FOLDER, "test", "subject_test.txt", sep="/"))
    test_activities <- read_activities_file("test", activity_factors)
    test_obs <- read.table(paste(DATA_FOLDER, "test", "X_test.txt", sep="/"), 
                            comment.char="", 
                            colClasses="numeric", 
                            nrows=NUM_TEST_OBS)
    
    filtered_test_obs <- test_obs[, filtered_features[,1]]
        
    # Read in training data
    train_subjects <- scan(paste(DATA_FOLDER, "train", "subject_train.txt", sep="/"))
    train_activities <- read_activities_file("train", activity_factors)
    train_obs <- read.table(paste(DATA_FOLDER, "train", "X_train.txt", sep="/"), 
                            comment.char="", 
                            colClasses="numeric", 
                            nrows=NUM_TRAIN_OBS)

    filtered_train_obs <- train_obs[, filtered_features[,1]]

    tidy_data_frame <- rbind(filtered_test_obs, filtered_train_obs)
    tidy_data_frame <- cbind(c(test_subjects, train_subjects), c(test_activities, train_activities), tidy_data_frame)
    colnames(tidy_data_frame) <- c("subject", "activity", filtered_features_char)

    
    tidy_data_frame_melted <- melt(tidy_data_frame, 
                                   id=c("subject", "activity"),
                                   measure.vars=filtered_features_char)
    
    tidy_data_frame_casted <- dcast(tidy_data_frame_melted,
                                    subject + activity ~ variable, mean)
    
    
    write.csv(tidy_data_frame_casted, file = "tidy_data.csv", row.names=FALSE)
    return(tidy_data_frame_casted)
}


# Checks for the presence of the data folder or the zipped version of
# the data. If the zip file exists, we'll unzip it. If neither the data
# nor the zipped file are there we exit
validate_files_present <- function()
{
    present = T
    if (!file.exists("./UCI HAR Dataset"))
    {
        if (file.exists("./getdata-projectfiles-UCI HAR Dataset.zip"))
        {
            print("unzipping data file")
            unzip("./getdata-projectfiles-UCI HAR Dataset.zip")
        }
        else
        {
            present = F
        }
    }
    return (present) 
}


# Read in an activites file replacing numeric values with factors
read_activities_file <- function(base_dir, factors)
{
    file_name = paste("y_", base_dir, ".txt", sep="")
    activity_data <- scan(paste(DATA_FOLDER, base_dir, file_name, sep="/"))
    activity_data <- sapply(activity_data, function(x) as.character(factors[x, 2]))
}


# Standardize column names to conform to some of the suggestions
# made in class
standardize_column_names <- function(col_names)
{
    # replace starting t's with time
    # replace starting f's with frequencey
    col_names <- sub("^t", "time", col_names)
    col_names <- sub("^f", "frequency", col_names)
    
    # remove "()" and "-"
    col_names <- gsub("\\(\\)", "", col_names)
    col_names <- gsub("-", "", col_names)
    
    # replace "mean" with "mean"
    # replace "std" with "Std"
    col_names <- gsub("mean", "Mean", col_names)
    col_names <- gsub("std", "Std", col_names)
    
    # other substitutions
    col_names <- gsub("Acc", "Acceleration", col_names)
    col_names <- gsub("Freq", "Frequency", col_names)
    col_names <- gsub("BodyBody", "Body", col_names)
    col_names <- gsub("Mag", "Magnitude", col_names)
    
    return (col_names)
}
    