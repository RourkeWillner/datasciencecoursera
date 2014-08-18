# Getting and Cleaning Data - run_analysis.R

# Read data
featList <- read.table("features.txt")[,2]
activityList <- read.table("activity_labels.txt")[,2]
x_data_test <- read.table("X_test.txt")
subject_list_test <- read.table("subject_test.txt")
y_data_test <- read.table("y_test.txt")
x_data_train <- read.table("X_train.txt")
subject_list_train <- read.table("subject_train.txt")
y_data_train <- read.table("y_train.txt")

# Merge data
x_data_full <- rbind(x_data_train, x_data_test)
y_data <- rbind(y_data_train, y_data_test)
subject_list <- rbind(subject_list_train, subject_list_test)

# Determine which columns are "mean" columns
meanColNums <- which(sapply(featList, function(x) grepl("-mean()", x, ignore.case=TRUE)))
stdColNums <- which(sapply(featList, function(x) grepl("-std()", x, ignore.case=TRUE)))
whichCols <- sort(c(as.numeric(meanColNums), as.numeric(stdColNums)))

# Extract only "mean" columns
x_data <- x_data_full[,whichCols]

# Assign activity names to activity IDs
activity <- data.frame(activityList[y_data[,]])

# Create dataframe 1
colnames(x_data) <- featList[whichCols]
colnames(activity) <- "activity"
colnames(subject_list) <- "subject"
df1 <- cbind(subject_list, activity, x_data) ## this is the first dataset
write.table(df1, "DataSet1.txt", sep="\t", row.name=FALSE)

# Create dataframe 2
df2 <- aggregate(. ~ activity+subject, data = df1, FUN=mean) 
df2 <- df2[c(2,1,3:81)] ## this is the second dataset
write.table(df2, "DataSet2.txt", sep="\t", row.name=FALSE)
df2