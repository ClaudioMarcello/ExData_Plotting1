## Reading household_power_consumption.txt
## Required data: 2007-02-01 and 2007-02-02
## one-minute sampling rate: 24 hrs x 60 min = 1,440 lines/day
## Data file starts on 2006/12/16 17:24:00
## Read first few lines to get names and classes
## Read again 
## 	skip first 45 days of data: ~ 64,800 lines
##    read next 4 days of data ~ 5,000 lines

x0 <- read.table("household_power_consumption.txt", 
			header = TRUE, sep = ";", nrows = 5)
classes <- sapply(x0, class)
classes[1:2] <- c("character", "character")
x0 <- read.table("household_power_consumption.txt", 
			header = TRUE, sep = ";", na.strings = "?",
			col.names = names(classes), colClasses = classes, 
			nrows = 5000, skip = 65000)

## Filter required data: 2007-02-01 and 2007-02-02
x1 <- x0[x0$Date == "1/2/2007" | x0$Date == "2/2/2007", ]

## Make time stamp from Date and Time
x1$Time_stamp <- strptime(paste(x1$Date, x1$Time), "%d/%m/%Y %H:%M:%S")

## Set the C locale
lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")

## Open a png graphics device
png(file = "plot4.png", width = 480, height = 480, units = "px") 

## Set a 2 x 2 layout 
par(mfrow = c(2, 2))

## Plot (1, 1)
## Plot Global Active Power vs. time stamp
plot(x1$Time_stamp, x1$Global_active_power, type = "l",
	xlab = "", ylab =  "Global Active Power")

## Plot (1, 2)
## Plot Voltage vs. time stamp
plot(x1$Time_stamp, x1$Voltage, type = "l",
	xlab = "Datetime", ylab =  "Voltage")

## Plot (2, 1)
## Plot Sub_metering vs. time stamp
plot(x1$Time_stamp, x1$Sub_metering_1, type = "l", ylim=c(0, 40),col="green",
	xlab = "", ylab =  "Energy sub metering")
lines(x1$Time_stamp, x1$Sub_metering_2,col="blue")
lines(x1$Time_stamp, x1$Sub_metering_3,col="red")
legend("topright", lty = 1, col = c("green", "blue", "red"),cex=0.8, 
	legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
	bty = "n")

## Plot (2, 2)
## Plot Global Reactive Power vs. time stamp
plot(x1$Time_stamp, x1$Global_reactive_power, type = "l",
	xlab = "Datetime", ylab =  "Global Reactive Power")

## Close the png graphics device
dev.off()

## reset the C locale
Sys.setlocale("LC_TIME", lct)