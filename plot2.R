# setting the constats
file_name <- "household_power_consumption.txt"
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# getting the file if it doesn't exist in working directory
if(!file.exists(file_name)){
    download.file(URL, destfile = "data.zip", method="curl")
    unzip("data.zip", exdir = ".")
}

# loading the libraries
library(readr)
library(stringr)
library(dplyr)

# getting the vector for column names
headers <- str_split(read_lines(file = file_name, n_max = 1), ";")[[1]]
# calculating the number of rows to skip up to the first occurrence of the "1-st of february, 2007"
n_skip <- grep("1/2/2007", readLines(file_name))[1] - 1
# calculating the number of rows basing on a frase that we have
# "Measurements of electric power consumption in one household with a one-minute sampling"
# that means that we have a row for each minute
n_rows = 24 * 60 * 2
# reading of the data of needed rows
plot_data <- read.table(file = file_name, header = FALSE, sep = ";", na.strings = "?", nrows = n_rows, skip = n_skip)
# setting the names of the variables of dataframe
colnames(plot_data) <- headers
# adding columns for date in time in appropriate fromats
plot_data <- mutate(plot_data, d_Date = as.Date(Date, format = "%d/%m/%Y"), d_Date_Time = as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")))

# plotting on png-device
png("plot2.png")
with(plot_data, plot(d_Date_Time, Global_active_power, type = "l", ylab = "Global active power (kilowatts)", xlab=""))
dev.off()
