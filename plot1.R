#### if packages are missing then install using these commands ####
#install.packages("sqldf")
#install.packages("curl")
#install.packages("RCurl")
#install.packages("lubridate")

####Attach libraries to R####
library(sqldf)
library(curl)
library(RCurl)
library(lubridate)

if(!file.exists("household_power_consumption.txt")){
 
 fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
 download.file(fileurl,destfile="./Electric_Power_Consumption.zip")
 dateDownloaded<-date()
 dateDownloaded
 unzip("Electric_Power_Consumption.zip")
 
}
## tried using SQLDF to extract data
#df_123<-read.csv.sql(file = "household_power_consumption.txt",
#                     sql = "select * from file where Date between '01/02/2007' and '02/02/2007' ",
#                     header = TRUE, 
#                     sep = ";",
#                     #nrows = 3
#)

#### loading data into a data-frame ####
loadElectricData<-read.table("household_power_consumption.txt",
                             header = TRUE,
                             sep = ";",
                             colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),na.strings = "?")

#### subset and extract data between 01/02/2007 and 02/02/2007 ####

loadElectricData_01_02022007<-loadElectricData[which(loadElectricData$Date=="1/2/2007" | loadElectricData$Date=="2/2/2007"),]

#### change Date and time to date and time formats using lubridate ####
#loadElectricData_01_02022007$Date<-dmy(loadElectricData_01_02022007$Date)
#loadElectricData_01_02022007$Time<-hms(loadElectricData_01_02022007$Time)

#### Adding additional column to join Date and Time column and create a timestamp ####
loadElectricData_01_02022007$Date_Time<-dmy_hms(paste(loadElectricData_01_02022007[,c("Date")] , loadElectricData_01_02022007[,c("Time")]))

#### Create a histogram on Global_active_power ####
# set current axis resolution to 0.75 so all the ticks are expanded
par(cex.axis=0.75)
# write histogram to png screen and close it at the end
png("plot1.png", width = 480, height = 480,type="cairo")
hist(loadElectricData_01_02022007$Global_active_power,main="Global Active Power",xlab = "Global Active Power (kiloWatts)",ylim = c(0,1200),col="red")
dev.off()
