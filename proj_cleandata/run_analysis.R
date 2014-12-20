library(data.table)
library(sqldf)

## function to read a set of data files (test or train) and consolidate everyting in to a single data table containing
## activity, subject and the sensor reading
preparedata <- function(datafile, featuresfile, subjectdatafile, activityfile) {
  
  data <- read.table(datafile)
  fields <- read.table(featuresfile)
  
  ## get rid of columns which do not have text 'mean' or 'std' in them
  toMatch <- c("mean", "std")
  matches <- unique (grep(paste(toMatch,collapse="|"), 
                          fields[,2], value=FALSE))
  data1 <- data[ ,fields[matches,][,1] ]
  
  ## append subject and activty columns
  s <- read.table( subjectdatafile)
  a <- read.table(activityfile)
  data2 <- cbind(cbind(s, a), data1)

  ##add descrptive name to all columns based on variable name in features.txt file
  setnames(data2,  c("subject", "activity", as.character(fields[matches,][,2]) ))
  
  # return the data table
  data2
}  

# consolidates and returns "clean" data
analyse <- function() {

## get consolidated training and test data with all the necessary columns
traindata <- preparedata("./UCI HAR Dataset/train/X_train.txt", "./UCI HAR Dataset/features.txt", './UCI HAR Dataset/train/subject_train.txt', './UCI HAR Dataset/train/y_train.txt')
testdata <- preparedata("./UCI HAR Dataset/test/X_test.txt", "./UCI HAR Dataset/features.txt", './UCI HAR Dataset/test/subject_test.txt', './UCI HAR Dataset/test/y_test.txt')

## merge test and training data
dt <-rbind(traindata, testdata)

## calculate the means by activity and subject
dt <- data.table(dt)
dt<-dt[,lapply(.SD, mean, na.rm=TRUE), by=list(activity, subject)]

activity_lables <- read.table( "./UCI HAR Dataset/activity_labels.txt")

#bring in descriptive activity names from activty labels daga and ORDER data by subject and activity
tmp <- sqldf("select * from dt, activity_lables where dt.activity=activity_lables.V1 order by subject, activity")

dt <- data.table(tmp)

# remove unwanted columns and name the activity column
dt[, activity:=NULL]
dt[, V1:=NULL]
names(dt)[names(dt) == "V2"] = "activity"

## read the descriptive variable names once again and arrange the columns accordingly in the right sequence
fields <- read.table("./UCI HAR Dataset/features.txt")
toMatch <- c("mean", "std")
matches <- unique (grep(paste(toMatch,collapse="|"), 
                        fields[,2], value=FALSE))

setcolorder(dt, c("subject", "activity", as.character(fields[matches,][,2]) ) )

## finally save the clean data
write.table(dt, "./UCI HAR Dataset/cleandata.txt", row.name=FALSE)

dt 
}
