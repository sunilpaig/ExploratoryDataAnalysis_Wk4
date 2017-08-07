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



## Initialize plot

png(file="plot5.png")

par(mfcol=c(1,1))

## Find indices which match Motor Vehicle Emissions in SCC 

pattern = "mobile - on-road"

ind <- grep(pattern, SCC$EI.Sector, ignore.case=TRUE) 

## Get the SCC codes for Motor Vehicle

sccs <- SCC[ind, 1]

## Get NEI subset for Baltimore city fips

NEIsubset <- NEI[NEI$fips == "24510",]

## Get indices in NEI which match the SCC codes for Motor Vehicle Emissions

scci <- NEIsubset$SCC %in% sccs

## Get subset and do calculate sum of Emissions by year

NEIsubset <- NEIsubset[scci, c("Emissions", "year")]

q5 <- aggregate(Emissions ~ year, data=NEIsubset, sum)

## Plot data

plot(q5$year, q5$Emissions, type="l", main="Motor Vehicle Emissions in Baltimore City", xlab="Year", ylab="Emissions (in tons)")

dev.off()
