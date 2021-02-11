## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 3:
##  Of the four types of sources indicated by the type (point, nonpoint, onroad,
##      nonroad) variable, which of these four sources have seen decreases in
##      emissions from 1999–2008 for Baltimore City? Which have seen increases
##      in emissions from 1999–2008? Use the ggplot2 plotting system to make a
##      plot answer this question.
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
emissionsBaltimoreByYearType <- summarise(group_by(filter(summarySCC,
                                                               fips == "24510"),
                                                        year, type),
                                               Total=sum(Emissions))

# Obtain the number of distinct years
numDistinctYears <- length(unique(sapply(emissionsBaltimoreByYearType$year,
                                  function(x) x)))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (ggplot2)...
ggplot(emissionsBaltimoreByYearType,
       aes(x=factor(year), y=Total/1000, label = round(Total/1000,2), fill=type)) +
    geom_bar(stat="identity") +
    facet_grid(. ~ type) +
    xlab("Year") +
    ylab("Total emissions from PM2.5 [KiloTons]") +
    ggtitle("Total emissions from PM2.5 [KiloTons] by year and type in Baltimore City") +
    geom_text(aes(label=round(Total/1000,2)), vjust=-0.3)

# Copy the result to file (png format, dimensions 800x600)
dev.copy(png, filename="plot3.png", width=800, height=600)

# Close the device
dev.off ()

