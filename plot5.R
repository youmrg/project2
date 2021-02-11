## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 5:
##  How have emissions from motor vehicle sources changed from 1999–2008
##      in Baltimore City?
## José Mª Sebastián Carrillo

##########
## Step 0A.- Check libraries in the current system.
##########

if (!require('dplyr')) {
  stop('The package dplyr was not installed!')
}

if (!require('ggplot2')) {
  stop('The package ggplot2 was not installed!')
}

##########
## Step 1.- Read the data from files.
##########

# Author <- "José Mª Sebastián Carrillo"

# Variable that contains the name of the file
dataFileSummary <- "summarySCC_PM25.rds"

# Check if the variable already exists (so we don't need to reload it!)
if(!exists("summarySCC")){
  summarySCC <- readRDS(dataFileSummary)
}

# Variable that contains the name of the file
dataFileSource <- "Source_Classification_Code.rds"

# Check if the variable already exists (so we don't need to reload it!)
if(!exists("sourceClassification")){
  sourceClassification <- readRDS(dataFileSource)
}

##########
## Step 2.- Process the data.
##########

# Merge the data and the source classification DataSets.
if(!exists("dataSCCBySource")){
  dataSCCBySource <- merge(sourceClassification, summarySCC, by="SCC")
}

# Aggregate the values by year
motorEmissionsBaltimoreByYear <- summarise(group_by(
  filter(summarySCC, fips == "24510" & type == "ON-ROAD"), year),
  Total=sum(Emissions))

# Obtain the max value for the y axis limit (in MegaTons).
yAxisLimit <- ceiling(max(motorEmissionsBaltimoreByYear$Total))*1.1

# Obtain the number of distinct years
numDistinctYears <- length(sapply(motorEmissionsBaltimoreByYear$year,
                                  function(x) unique(x)))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (base plotting system)...
plot5 <- barplot(height = motorEmissionsBaltimoreByYear$Total,
                 names.arg = motorEmissionsBaltimoreByYear$year,
                 xlab = "Year",
                 ylab = "Motor emissions from PM2.5 [Tons]",
                 ylim=c(0,yAxisLimit),
                 main = "Motor emissions from PM2.5 [Tons] by year in Baltimore City",
                 col = heat.colors(numDistinctYears))

# ... and enhances the barplot
box()
text(x = plot5,
     y = (motorEmissionsBaltimoreByYear$Total),
     pos = 3,
     label = round(motorEmissionsBaltimoreByYear$Total,2))

# Copy the result to file (png format, dimensions 640x480)
dev.copy(png, filename="plot5.png", width=640, height=480)

# Close the device
dev.off ()