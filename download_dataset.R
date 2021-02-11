## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Check and download "Data for Peer Assessment"
## José Mª Sebastián Carrillo

##########
## Step 1.- Check if the downloaded data already exists.
##########

# Author <- "José Mª Sebastián Carrillo"

currentFolder <- getwd()
dataFileZip <- "exdata_data_NEI_data.zip"

# Verify the file downloaded
if (!file.exists(dataFileZip)){
    dataFileZipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(dataFileZipUrl, dataFileZip, method="curl")
}

# Verify the files with the data uncompressed
dataSetName <- "summarySCC_PM25.rds"
dataSet <- file.path(currentFolder, dataSetName)
if (!dir.exists(dataSet)) {
    unzip(dataFileZip)
}
