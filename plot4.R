## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 4:
##  Across the United States, how have emissions from coal combustion-related
##      sources changed from 1999–2008?
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

# Filter records to those which contains the word 'coal' in Short.Name
coalDataMatch <- grepl("Coal", dataSCCBySource$EI.Sector, ignore.case=TRUE)
coalSCC <- dataSCCBySource[coalDataMatch, ]

# Aggregate the values by year
coalEmissionsByYear <- summarise(group_by(coalSCC, year),
                                          Total=sum(Emissions))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (ggplot2)...
ggplot(coalEmissionsByYear, aes(x=factor(year), y=Total/1000, label = round(Total/1000,2), fill=year)) +
    geom_bar(stat="identity") +
    xlab("Year") +
    ylab("Total emissions from coal [KiloTons]") +
    ggtitle("Total emissions from coal [KiloTons] by year") +
    geom_text(aes(label=round(Total/1000,2)), vjust=-0.3)

# Copy the result to file (png format, dimensions 800x600)
dev.copy(png, filename="plot4.png", width=800, height=600)

# Close the device
dev.off ()
