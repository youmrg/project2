## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 1:
##  Have total emissions from PM2.5 decreased in the United States from 1999 to
##      2008? Using the base plotting system, make a plot showing the total
##      PM2.5 emission from all sources for each of the years 1999, 2002, 2005,
##      and 2008.
## José Mª Sebastián Carrillo

##########
## Step 0A.- Check libraries in the current system.
##########

if (!require('dplyr')) {
    stop('The package dplyr was not installed!')
}

##########
## Step 1.- Read the data from file.
##########

# Author <- "José Mª Sebastián Carrillo"

# Variable that contains the name of the file
dataFileSummary <- "summarySCC_PM25.rds"

# Check if the variable already exists (so we don't need to reload it!)
if(!exists("summarySCC")){
    summarySCC <- readRDS(dataFileSummary)
}

##########
## Step 2.- Process the data.
##########

# Aggregate the values by year
groupEmissionsByYear <- summarise(group_by(summarySCC, year),
                                  Total=sum(Emissions))

# Obtain the max value for the y axis limit (in MegaTons).
yAxisLimit <- ceiling(max(groupEmissionsByYear$Total)/1000000)

# Obtain the number of distinct years
numDistinctYears <- length(sapply(groupEmissionsByYear$year,
                                  function(x) unique(x)))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (base plotting system)...
plot1 <- barplot(height = groupEmissionsByYear$Total/1000000,
                 names.arg = groupEmissionsByYear$year,
                 xlab = "Year",
                 ylab = "Total emissions from PM2.5 [MegaTons]",
                 ylim=c(0,yAxisLimit),
                 main = "Total emissions from PM2.5 [MegaTons] by year",
                 col = heat.colors(numDistinctYears))

# ... and enhances the barplot
box()
text(x = plot1,
     y = (groupEmissionsByYear$Total/1000000),
     pos = 3,
     label = round(groupEmissionsByYear$Total/1000000,2))

# Copy the result to file (png format, dimensions 640x480)
dev.copy(png, filename="plot1.png", width=640, height=480)

# Close the device
dev.off ()
