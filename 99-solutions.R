### -----------------------------
## r refresher - solutions
## simon munzert
### -----------------------------


## peparations -------------------

source("packages.r")
source("functions.r")


## Manipulating data frames ---------------------------


# 1. Install and load the package "nycflights13"!
install.packages("nycflights13")
library(nycflights13)

# 2. How many variables and observations does the data.frame "flights" from the nycflights13 package contain?
names(flights)
View(flights)
dim(flights)
nrow(flights)
ncol(flights)

# 3. Select the flights that started from NYC at the first day of each month!
head(flights)
table(flights$origin)
flights_day1 <- filter(flights, day == 1)

# 4. Sort flights by time of arrival!
flights_sorted <- arrange(flights, arr_time)

# 5. Generate a sub data frame that contains only the department and arrival delay as well as the carrier!
flights3 <- select(flights, dep_delay, arr_delay, carrier)


# 6. Which carrier had the biggest department delay on average, which the lowest?
mean_delay <- tapply(flights$dep_delay, flights$carrier, mean, na.rm = TRUE)
mean_delay_sorted <- sort(mean_delay, decreasing = TRUE)


