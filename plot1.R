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

png(file="plot1.png")

par(mfcol=c(1,1))

q1 <- aggregate(Emissions ~ year, data=NEI, sum)

plot(q1$year, q1$Emissions, type="l", main="Total Emissions in United States", xlab="Year", ylab="Emissions (in tons)")

dev.off()
