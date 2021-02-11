## Coursera - Data Science - Universidad Johns Hopkins
## Exploratory Data Analysis - Week 4
## Question 6:
##  Compare emissions from motor vehicle sources in Baltimore City with emissions
##    from motor vehicle sources in Los Angeles County, California (fips == "06037").
##    Which city has seen greater changes over time in motor vehicle emissions?
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

# Aggregate the values by year - Baltimore...
motorEmissionsBaltimoreByYear <- summarise(group_by(
  filter(summarySCC, fips == "24510" & type == "ON-ROAD"), year),
  Total=sum(Emissions))
# ... and assign the correct name
motorEmissionsBaltimoreByYear$County <- "Baltimore"

# Aggregate the values by year - Los Angeles
motorEmissionsLosAngelesByYear <- summarise(group_by(
  filter(summarySCC, fips == "06037" & type == "ON-ROAD"), year),
  Total=sum(Emissions))
# ... and assign the correct name
motorEmissionsLosAngelesByYear$County <- "Los Angeles"

motorEmissionsByYear <- rbind(motorEmissionsBaltimoreByYear,
                              motorEmissionsLosAngelesByYear)

# Obtain the number of distinct years
numDistinctYears <- length(unique(sapply(motorEmissionsByYear$year,
                                         function(x) x)))

##########
## Step 3.- Generate the plot.
##########

# Create the barplot (ggplot2)...
ggplot(motorEmissionsByYear,
       aes(x=factor(year), y=Total/1000, label = round(Total/1000,2), fill=County)) +
  geom_bar(stat="identity") +
  facet_grid(. ~ County) +
  xlab("Year") +
  ylab("Motor emissions from PM2.5 [KiloTons]") +
  ggtitle("Motor emissions from PM2.5 [KiloTons] by year and County") +
  geom_text(aes(label=round(Total/1000,2)), vjust=-0.3)

# Copy the result to file (png format, dimensions 800x600)
dev.copy(png, filename="plot6.png", width=800, height=600)

# Close the device
dev.off ()

