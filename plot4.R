#
# PLOT 4
#

library(dplyr)
library(lubridate)

# Load the data from the file
# Filter out all rows except those that were collected on
#       Feb 1st and 2nd, 2007
# Combine the Date and Time character columns into the
#       Date column
# Convert the Date column's type to POSIXct using the lubridate package
# Delete the Time column, since it is no longer necessary

df <- as_data_frame(
        read.table(file = 'household_power_consumption.txt',
                   header = TRUE,
                   sep = ';',
                   na.strings = '?',
                   colClasses = c('character', 'character', 'numeric', 'numeric', 'numeric',
                                  'numeric', 'numeric', 'numeric', 'numeric'),
                   nrows = 2075259,
                   check.names = FALSE,
                   stringsAsFactors = FALSE)) %>%
        filter(Date %in% c('1/2/2007', '2/2/2007')) %>%
        mutate(Date = paste(Date, Time, sep = ' '),
               Date = dmy_hms(Date),
               Time = NULL)

# Create plot on screen device
par(mar = c(4,4,4,4))
par(mfrow=c(2,2))

# row1, col1 plot
with(df, plot(Date, Global_active_power,
              type = 'l',
              xlab = NA,
              ylab = 'Global Active Power'))

# row1, col2 plot
with(df, plot(Date, Voltage,
              type = 'l',
              col = 'black',
              xlab = 'datetime',
              ylab = 'Voltage'))

# row2, col1 plot
with(df, plot(Date, Sub_metering_1,
              type = 'l',
              col = 'black',
              xlab = NA,
              ylab = 'Energy sub metering'))
with(df, lines(Date, df$Sub_metering_2, col = 'red'))
with(df, lines(Date, df$Sub_metering_3, col = 'blue'))

legend('topright',
       legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       lty = c(1, 1, 1),
       col = c('black', 'red', 'blue'),
       bty = 'n',
       cex = 0.6)

# row2, col2 plot
with(df, plot(Date, Global_reactive_power,
              type = 'l',
              col = 'black',
              xlab = 'datetime',
              ylab = 'Global_reactive_power'))



# Copy plot to a PNG file
dev.copy(png, file = "plot4.png", width = 480, height = 480, units = 'px')

## Don't forget to close the PNG device!
dev.off()
