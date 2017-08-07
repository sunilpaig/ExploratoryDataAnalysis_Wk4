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



## Plot data

q3 <- aggregate(Emissions ~ year + type, data=NEI[NEI$fips=="24510",], sum)

plot3 <- qplot(year, Emissions, data=q3, color=type, geom="path", xlab="Year", ylab="Emissions (in tons)", main="Emissions by type in Baltimore City")

ggsave(plot3, file="plot3.png", width=4, height=4)
