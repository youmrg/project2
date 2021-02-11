## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 2:
##  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
##      (fips = "24510") from 1999 to 2008? Use the base plotting system to make
##      a plot answering this question.
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
groupEmissionsBaltimoreByYear <- summarise(group_by(filter(summarySCC,
                                                           fips == "24510"),
                                                    year),
                                           Total=sum(Emissions))

# Obtain the max value for the y axis limit (in MegaTons).
yAxisLimit <- ceiling(max(groupEmissionsBaltimoreByYear$Total)/1000)

# Obtain the number of distinct years
numDistinctYears <- length(sapply(groupEmissionsBaltimoreByYear$year,
                                  function(x) unique(x)))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (base plotting system)...
plot2 <- barplot(height = groupEmissionsBaltimoreByYear$Total/1000,
                 names.arg = groupEmissionsBaltimoreByYear$year,
                 xlab = "Year",
                 ylab = "Total emissions from PM2.5 [KiloTons]",
                 ylim=c(0,yAxisLimit),
                 main = "Total emissions from PM2.5 [KiloTons] by year in Baltimore City",
                 col = heat.colors(numDistinctYears))

# ... and enhances the barplot
box()
text(x = plot2,
     y = (groupEmissionsBaltimoreByYear$Total/1000),
     pos = 3,
     label = round(groupEmissionsBaltimoreByYear$Total/1000,2))

# Copy the result to file (png format, dimensions 640x480)
dev.copy(png, filename="plot2.png", width=640, height=480)

# Close the device
dev.off ()