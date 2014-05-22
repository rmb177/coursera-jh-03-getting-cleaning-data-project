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
    
    # Read in test data
    test_subjects <- scan(paste(DATA_FOLDER, "test", "subject_test.txt", sep="/"))
    test_activities <- read_activities_file("test", activity_factors)
    #test_obs <- read.table(paste(DATA_FOLDER, "test", "X_test.txt", sep="/"), 
    #                        comment.char="", 
    #                        colClasses="numeric", 
    #                        nrows=NUM_TEST_OBS)
    
    # Read in training data
    train_subjects <- scan(paste(DATA_FOLDER, "train", "subject_train.txt", sep="/"))
    train_activities <- read_activities_file("train", activity_factors)
    #train_obs <- read.table(paste(DATA_FOLDER, "train", "X_train.txt", sep="/"), 
    #                        comment.char="", 
    #                        colClasses="numeric", 
    #                        nrows=NUM_TRAIN_OBS)}

    tidy_data_frame <- data.frame(matrix(vector(), NUM_TEST_OBS + NUM_TRAIN_OBS, 2, dimnames=list(c(), c("subject", "activity"))), 
                                   stringsAsFactors=FALSE)
    tidy_data_frame[, 1] <- c(test_subjects, train_subjects)
    tidy_data_frame[, 2] <- c(test_activities, train_activities)
    
    print(tidy_data_frame)

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
    activity_data <- sapply(activity_data, function(x) factors[x, 2])
}
    