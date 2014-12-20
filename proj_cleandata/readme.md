*How to run analysis
1. Download and unzip data from  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
into your R working directory. 
2. Now you must have a subdirectory 'UCI HAR Dataset' under the working directory. Copy run_analysis.R to your working directory as well.
3. Run following statements in R console
 source("run_analysis.R")
 d <- analyse()

After that you will have clean data as cleandata.txt under 'UCI HAR Dataset'

*How it works
For details refer to comments in the R coding. In summary raw data files are processed in the following way:
1. Files are read separately from test and training folders. From each folder
	* read data file('X...text') get rid of columns which do not represent mean and standard deviation.
	* add columns related to activity and subject to this data based on the data in other subject and activity files
	* assign descriptive names to variables based on contents of features.txt.
2. Merge pre-processed data from test and train folders
	* calculate the mean of variables by activity and subject
	* replace activity integer codes with descriptive text
3. Write the processed data to disk as 'cleandata.txt' under 'UCI HAR Dataset'  folder

Codebook is uploaded to GITHUB
Since the focus of the exercise is the content and meaning of data itself, I merely uploaded an automatically generated version of the codebook(or else I will be spending hours with a Copy paste job of no value whatsoever). 
In other circumstances, I would add more details for each variable when I have understanding of of what they mean.
