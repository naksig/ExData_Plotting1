# plot1.R
# Nakazawa Shigeki
# 11 Sep 2015
# -------------------------------------------------------
#////////////////////////////////////////////////////////
# I. Note
# It is suggested to save the downloaded Zip file in the working directory.
# Otherwise, the script attempts to download the file from the internet,
# which may take time.
#
# II. Data
# consumption: the original data, modified to a tidy dataset.
#
# III. Variable
# 1. Date: Date vector, converted wth as.Date function         
# 2. DateTime: POSIXlt vector, combined with Date and converted with strptime function
# 3-8. The below are directly acquired from the original txt file. All numerical vectors.
#      Checked that no NA values (When read the necessary data only from the txt file, 
#      no NA values are included. )
# 3. GlobalActivePower, 4. GlobalReactivePower, 5. Voltage, GlobalIntensity, 
# 6. SubMetering1, 7. SubMetering2  , 8. SubMetering3 
#
# IV. SCRIPT FUNCTION
# The script reads the household_power_consumption.txt and 
# plots the Global Active Power as a histogram. 
# It is divided in 2 parts: 1. read file, 2. make plot:
#  1.read file: First, checks if the txt file exists, if not downloads the zip file 
# and extract the txt file from it. Then, read the data of only two days, to save 
# time (much shorter than read the entire file). Thereafter, add variable names 
# (underscores removed). Finally, the script change the format of Date (character 
# to date) and Time (character to POSIXlt, combined with the Date).
#  2.make plot: Plot the data as histogram. Save the output as a PNG file plot1.png 
# in the working directory.

# ////////////////////////////////////////////////////////

# 1. read file
# -------------------------------------------------------
#  1a. read and tidy the data 
#   1a0. check the file. If not, download and unzip the file
          if(file.exists("household_power_consumption.txt")==FALSE) {
               download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
               unzip("exdata-data-household_power_consumption.zip")  
          }
#   1a1. read data between 2007-02-01 and 2007-02-02, 
#        make consumption data frame.
          consumption <- as.data.frame(
               read.table("household_power_consumption.txt", sep=";", 
                           skip = 66637, nrows = 2880)
          )

#   1a2. add variable names
     names(consumption) <- c("Date", "Time", "GlobalActivePower", "GlobalReactivePower", 
                    "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", 
                    "SubMetering3")

#   1a3. change formats of Date and Time
#        Date as date format
          consumption$Date     <- as.Date (consumption$Date,     "%d/%m/%Y")
#        make DateTime variable as POSIXlt format, replace with Time variable
          consumption$DateTime <- paste(consumption$Date, " ", consumption$Time)
          consumption$DateTime <- strptime(consumption$DateTime, "%Y-%m-%d %H:%M:%S")
          consumption <- consumption[ , c(1, 10, 3:9)]
#///////////////////////////////////////////////////////

# 2. Make plot
#-------------------------------------------------------
#  2a. save the image as png (open graphic device)
#      png, 480x480px, transparent background
          png("plot1.png", width = 480, height = 480, bg = "transparent")

#  2b. plot the histogram
     par(oma = c(1, 1, 1, 1))                       #add margins
     hist(consumption$GlobalActivePower, 
          main= "Global Active Power",              #add main title
          xlab = "Global Active Power (kilowatts)", #add x label
          col = "red"                               #bar color in red
     )

#  2c close the graphic device
     dev.off() 

#//////////////// END OF SCRIPT ////////////////////////
          
          
          