### -----------------------------
### simon munzert
### scraping dynamic webpages
### -----------------------------

## peparations -------------------

source("packages.r")
source("functions.r")



## setup R + RSelenium -------------------------

# install current version of Java SE Runtime Environment
browseURL("http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html")

# install current version of Firefox browser
browseURL("https://www.mozilla.org/en-US/firefox/new/") # might not always work, probably go with version 48 instead?

# install dev version of RSelenium
devtools::install_github("ropensci/RSelenium")

# set up connection via RSelenium package
# documentation: http://cran.r-project.org/web/packages/RSelenium/RSelenium.pdf

# check currently installed version of Java
system("java -version")
#system("java -jar selenium-server-standalone-3.4.0.jar")


## example --------------------------

# initiate Selenium driver
rD <- rsDriver()
remDr <- rD[["client"]]

# start browser, navigate to page
url <- "http://www.iea.org/policiesandmeasures/renewableenergy/"
remDr$navigate(url)

# open regions menu
css <- 'div.form-container:nth-child(2) > ul:nth-child(2) > li:nth-child(1) > span:nth-child(1)'
regionsElem <- remDr$findElement(using = 'css', value = css)
openRegions <- regionsElem$clickElement() # click on button



# selection "European Union"
css <- 'div.form-container:nth-child(2) > ul:nth-child(2) > li:nth-child(1) > ul:nth-child(3) > li:nth-child(5) > label:nth-child(1) > input:nth-child(1)'
euElem <- remDr$findElement(using = 'css', value = css)
selectEU <- euElem$clickElement() # click on button

# set time frame
css <- 'div.form-container:nth-child(6) > select:nth-child(2)'
fromDrop <- remDr$findElement(using = 'css', value = css) 
clickFrom <- fromDrop$clickElement() # click on drop-down menu
writeFrom <- fromDrop$sendKeysToElement(list("2000")) # enter start year


css <- 'div.form-container:nth-child(6) > select:nth-child(3)'
toDrop <- remDr$findElement(using = 'css', value = css) 
clickTo <- toDrop$clickElement() # click on drop-down menu
writeTo <- toDrop$sendKeysToElement(list("2010")) # enter end year

# click on search button
css <- '#main > div:nth-child(1) > form:nth-child(4) > button:nth-child(14)'
searchElem <- remDr$findElement(using = 'css', value = css)
resultsPage <- searchElem$clickElement() # click on button

# store index page
output <- remDr$getPageSource(header = TRUE)
write(output[[1]], file = "iea-renewables.html")

# close connection
remDr$closeServer()

# parse index table
content <- read_html("iea-renewables.html", encoding = "utf8") 
tabs <- html_table(content, fill = TRUE)
tab <- tabs[[1]]

# add names
names(tab) <- c("title", "country", "year", "status", "type", "target")
head(tab)
