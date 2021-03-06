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

### line plot to png screen and close
png("plot4.png", width = 480, height = 480,type="cairo")

par(cex.lab=0.75) # reduce lables size by 75pc
# 2X2 grid layout with borders and space at the top for plot title
par(mfrow = c(2,2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))





# plot for global active power vs date_time
plot(loadElectricData_01_02022007$Date_Time,
     loadElectricData_01_02022007$Global_active_power,
     type="l",
     #main="Plot 2",
     ylab = "Global Active Power",
     #xaxt = "n",
     xlab = NA)


# plot of vooltage vs datetime
plot(loadElectricData_01_02022007$Date_Time,
     loadElectricData_01_02022007$Voltage,
     type="l",
     #main="Plot 2",
     ylab = "Voltage",
     #xaxt = "n",
     xlab = "datetime")


# plot for submetering 1,2,3 vs datetime

# create an empty plot
plot(loadElectricData_01_02022007$Date_Time,
     loadElectricData_01_02022007$Sub_metering_1,
     type="n",
     #main="Plot 3",
     ylab = "Energy sub metering",
     #xaxt = "n",
     xlab = NA
)
#add respective lines for each column measurement
lines(loadElectricData_01_02022007$Date_Time,
      loadElectricData_01_02022007$Sub_metering_1,type="l",col="black")
lines(loadElectricData_01_02022007$Date_Time,
      loadElectricData_01_02022007$Sub_metering_2,type="l",col="red")
lines(loadElectricData_01_02022007$Date_Time,
      loadElectricData_01_02022007$Sub_metering_3,type="l",col="blue")
# add legend, cex to reduced legend by 75pc
legend("topright",lty=c(1,1,1),col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex = 0.75,bty = "n")


# plot of vooltage vs datetime
plot(loadElectricData_01_02022007$Date_Time,
     loadElectricData_01_02022007$Global_reactive_power,
     type="l",
     #main="Plot 2",
     ylab = "Global_reactive_power",
     #xaxt = "n",
     xlab = "datetime")

mtext("Plot 4",outer = TRUE)

dev.off()
