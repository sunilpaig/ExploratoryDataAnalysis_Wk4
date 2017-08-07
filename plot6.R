library(ggplot2)



## Following function loads the required data sets NEI and SCC

loadFiles <- function() {

    ## If the rds input files are not present, download them

    if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) {

        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

        download.file(fileUrl, method="curl", destfile="NEI_data.zip")

        unzip("NEI_data.zip")

    }

    ## if NEI data frame is not already loaded, load it

    if(!exists("NEI")) {

        assign("NEI", readRDS("summarySCC_PM25.rds"), envir = .GlobalEnv)

    }

    ## if SCC data frame is not already loaded, load it

    if(!exists("SCC")) {

        assign("SCC", readRDS("Source_Classification_Code.rds"), envir = .GlobalEnv)

    }

}

loadFiles()



## Normalization function to scale the Emission values

## This helps in comparing the emissions from Baltimore and Los Angeles

norm <- function(x) {

    return ((x-min(x))/(max(x)-min(x)))

}



## This function returns the subset of NEI for Motor Vehicles

## It takes the county name as input

getMotorVehicleNEIsubset <- function(county) {

    

    ## Check county to get zip code

    if(county == "Baltimore") {

        zip <- "24510" 

    } else if(county == "LosAngeles") {

        zip <- "06037"

    } else {

        stop("Incorrect county provided")

    }

    

    ## Get the SCC code corresponding to Motor Vehicle Emissions in EI.Sector 

    sccs <- SCC[grep("mobile - on-road", SCC$EI.Sector, ignore.case=TRUE), 1]

    ## Get subset of NEI based on zipcode 

    NEIsubset <- subset(NEI, NEI$fips == zip)

    ## Get indices of NEIsubset corresponding to the SCC codes for Motor Vehicle Emissions

    scci <- NEIsubset$SCC %in% sccs

    ## Aggregate based on year and use only indices for which the SCC code matches for this zipcode

    q <- aggregate(Emissions ~ year, data=NEIsubset[scci, c("Emissions", "year")], sum)

    ## Scale the emission values so that they can be compared easily

    q$Emissions <- norm(q$Emissions)

    ## add new column called "county" and factorize it

    q$county <- factor(county, levels=c("Baltimore", "LosAngeles"))

    q

}



## Get NEI subset for Baltimore

qba <- getMotorVehicleNEIsubset("Baltimore")

## Get NEI subset for LosAngeles

qla <- getMotorVehicleNEIsubset("LosAngeles")



## Combine Baltimore and LosAngeles data

q6 <- rbind(qba, qla)



## Generate a ggplot for Emissions comparison

plot6 <- qplot(year, Emissions, data=q6, color=county, geom="path", 

               xlab="Year", ylab="Emissions (scaled)", 

               main="Motor Vehicle Emissions Comparison (Scaled)")



ggsave(plot6, file="plot6.png")
