### -----------------------------
## r refresher - solutions
## simon munzert
### -----------------------------


## peparations -------------------

source("packages.r")
source("functions.r")


# ************************************************
# EXERCISE: MANIPULATING DATA FRAMES -------------

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




# ************************************************
# EXERCISE: VECTORS ------------------------------

# create vectors
# simplify vector creation
# vector combination

# 1. Create a vector x with elements [0,4,8,12,16,20].
x <- seq(0, 20, 4)
x

# 2. Create a vector y with elements [3,3,3,4,4,4,4,5,5,5,5,5].
y <- c(3,3,3,4,4,4,4,5,5,5,5,5)
rep(c(3, 4, 5), c(3, 4, 5))

# 3. Combine the first five elements of x with elements 2 to 12 of vector y to create a new vector z.
z <- c(x[1:5], y[2:12])

# 4. What's the sum of all numbers between 1 and 100?
seq(1, 100) %>% sum()
sum(1:100)

# 5. What's the sum of all odd numbers between 1 and 100 squared?
seq(1, 100, 2)^2 %>% sum



# ************************************************
# EXERCISE: FILE MANAGEMENT ----------------------

# go to the following webpage.
url <- "http://www.cses.org/datacenter/module4/module4.htm"
browseURL(url)

# the following piece of code identifies all links to resources on the webpage and selects the subset of links that refers to the survey questionnaire PDFs.
library(rvest)
page_links <- read_html(url) %>% html_nodes("a") %>% html_attr("href")
survey_pdfs <- str_subset(page_links, "/survey")

# set up folder data/cses-pdfs.
dir.create("data/cses-pdfs", recursive = TRUE)

# download a sample of 10 of the survey questionnaire PDFs into that folder using a for loop and the download.file() function.
baseurl <- "http://www.cses.org"
for (i in 1:10) {
  filename <- basename(survey_pdfs[i])
  if(!file.exists(paste0("data/cses-pdfs/", filename))){
    download.file(paste0(baseurl, survey_pdfs[i]), destfile = paste0("data/cses-pdfs/", filename))
    Sys.sleep(runif(1, 0, 1))
  }
}

# check if the number of files in the folder corresponds with the number of downloads and list the names of the files.
length(list.files("data/cses-pdfs"))
list.files("data/cses-pdfs")

# inspect the files. which is the largest one?
file.info(dir("data/cses-pdfs", full.names = TRUE)) %>% View()

# zip all files into one zip file.
zip("data/cses-pdfs/cses-mod4-questionnaires.zip", dir("data/cses-pdfs", full.names = TRUE))

