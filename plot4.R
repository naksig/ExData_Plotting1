# plot4.R
# Nakazawa Shigeki
# 12 Sep 2015
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
# The script reads the household_power_consumption.txt, and make 4 plots in 2x2 matrix.
# It is divided in 2 parts: 1. read file, 2. make plot:
#  1.read file: First, checks if the txt file exists, if not downloads the zip file 
# and extract the txt file from it. Then, read the data of only two days, to save 
# time (much shorter than read the entire file). Thereafter, add variable names 
# (underscores removed). Finally, the script change the format of Date (character 
# to date) and Time (character to POSIXlt, combined with the Date).
#  2.make plot: Make 4 matrixes, make 4 plots, and save the output as a PNG file 
# plot4.png in the working directory.

# ////////////////////////////////////////////////////////

# 1. read the file
# --------------------------------------------------------
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
#
#   1a2. add variable names
     names(consumption) <- c("Date", "Time", "GlobalActivePower", "GlobalReactivePower", 
                        "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", 
                        "SubMetering3")
#
#   1a3. change formats of Date and Time
#        Date as date format
     consumption$Date     <- as.Date (consumption$Date,     "%d/%m/%Y")
#        Time to DateTime as POSIXlt format (Make a new variable and replace)
     consumption$DateTime <- paste(consumption$Date, " ", consumption$Time)
     consumption$DateTime <- strptime(consumption$DateTime, "%Y-%m-%d %H:%M:%S")
     consumption <- consumption[ , c(1, 10, 3:9)]
# ////////////////////////////////////////////////////////

# 2. Plot the graph
#--------------------------------------------
# 2a. preparation
#  2a1. save the image as png (open the graphic device)
#       png, 480x480px, transparent background
     png("plot4.png", width = 480, height = 480, bg = "transparent")

#  2a2. change locale (as my locale is non-English) 
#      for English description of days of week
     Sys.setlocale("LC_TIME","C")

#  2a3. make 4 matrixes, set margins
     par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(1, 1, 1, 1))

# 2b. Make plots
#  2b1. plot1
#---------------------------------------------
     with(consumption, {
          plot(DateTime, GlobalActivePower, type="l",  #line graph
               xlab="",                                #no x label
               ylab="Gobal Active Power",              #with y label
               main = ""                               #no title
          )
     })

     
     
#  2b2. plot2: DateTime-Voltage
#----------------------------------------------
     with(consumption, {
          plot(DateTime, Voltage, type="l",            #line graph
               xlab="datetime",                        #with x label
               ylab="Voltage",                         #with y label
               main = ""                               #no title
          )
     })
     
     
     
#  2b3. plot3: DateTime-SubMetering1,2,3
#----------------------------------------------
     with(consumption, 
          plot(DateTime, SubMetering1, typ="l",                #SubMetering1, black 
               xlab="", ylab="Energy sub metering",            #wo x label, with y label
               main = ""                                       #wo title
          )
     )
     with(consumption, lines(DateTime, SubMetering2, col="red"))    #SubMetering2, red
     with(consumption, lines(DateTime, SubMetering3, col="blue"))   #SubMetering3, blue
     legend("topright", lwd = 1, bty="n",  col = c("black", "red", "blue"),   #add legend
     legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
     
     
     
#  2b4  plot4: DateTIme-GlobalReactivePower
#----------------------------------------------
     with(consumption, {
          plot(DateTime, GlobalReactivePower, type="l", #line graph
               xlab="datetime",                         #with x label
               ylab="Global Reactive Power",            #with y label
               main = ""                                #no title
          )
     })
     
     

     
#  2c. final stage
#----------------------------------------------
     dev.off()             #close the graphic device
     
#//////////////// END OF SCRIPT ////////////////////////
