### -----------------------------
## simon munzert
## scraping static webpages
## solutions
### -----------------------------


source("packages.r")
source("functions.r")



## 1. repeat playing CSS diner and complete all levels!

---

## 2. go to the following website
browseURL("https://www.jstatsoft.org/about/editorialTeam")
# a) which CSS identifiers can be used to describe all names of the editorial team?
# b) write a corresponding CSS selector that targets them!

".member a"
"#group a"



## 3. revisit the jstatsoft.org website from above and use rvest to extract the names! Bonus: try and extract the full lines including the affiliation, and count how many of the editors are at a statistics or mathematics department or institution!

url <- "https://www.jstatsoft.org/about/editorialTeam"
url_parsed <- read_html(url)
names <- html_nodes(url_parsed, css = ".member a") %>% html_text()
names <- html_nodes(url_parsed, css = ".member") %>% html_text()
names <- html_nodes(url_parsed, "#group a") %>% html_text()

xpath <- '//div[@id="content"]//li/a'
html_nodes(url_parsed, xpath = xpath) %>% html_text()

affiliations <- html_nodes(url_parsed, ".member li") %>% html_text()
str_detect(affiliations, "tatisti|athemati") %>% table



## 4. scrape the table tall buildings (300m+) currently under construction from the following page. How many of those buildings are currently built in China? and in which city are most of the tallest buildings currently built?
browseURL("https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world")

url <- "https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world"
url_parsed <- read_html(url)
tables <- html_table(url_parsed, fill = TRUE)
buildings <- tables[[6]]

table(buildings$`Country`) %>% sort
table(buildings$City) %>% sort

buildings$height <- str_extract(buildings$height, "[[:digit:],.]+") %>% str_replace(",", "") %>% as.numeric()



## 5. Go to http://en.wikipedia.org/wiki/List_of_MPs_elected_in_the_United_Kingdom_general_election,_1992 and extract the table containing the elected MPs int the United Kingdom general election of 1992. Which party has most Sirs?

url <- "http://en.wikipedia.org/wiki/List_of_MPs_elected_in_the_United_Kingdom_general_election,_1992"

url_parsed <- read_html(url)
tables <- html_table(url_parsed, fill = TRUE)
names(tables)
mps <- tables[[4]]
head(mps)

# clean up
head(mps)
names(mps) <- c("con", "name", "party")
mps <- mps[!str_detect(mps$con, "\\[edit"),]
mps <- mps[-1,]
nrow(mps)

# look for Sirs
mps$name <- as.character(mps$name)
mps$sir <- str_detect(mps$name, "^Sir ")
table(mps$party, mps$sir)
prop.table(table(mps$party, mps$sir), 1)


## 6. Create code that scrapes and cleans all headlines from the main pages of sueddeutsche.de and spiegel.de!




## 7. use SelectorGadget to identify a CSS selector that helps extract all article author names from Buzzfeed's main page! Next, use rvest to scrape these names!

url <- "https://www.buzzfeed.com/?country=us"
url_parsed <- read_html(url)
authors <- html_nodes(url_parsed, css = ".link-gray-lighter .xs-text-6") %>% html_text() %>% str_replace_all("\\n", "") %>% str_trim()
table(authors) %>% sort



## 8. Go to http://earthquaketrack.com/ and make a request for data on earthquakes in "Florence, Italy". Try to parse the results into one character vector! Hint: After filling out a form, you might have to look for a follow-up URL and parse it in a second step to arrive at the data you need.

url <- "http://earthquaketrack.com/"
url_parsed <- read_html(url)
html_form(url_parsed)
earthquake <- html_form(url_parsed)[[1]]

earthquake_form <- set_values(earthquake, q = "Florence, Italy")
uastring <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
session <- html_session(url, user_agent(uastring))
earthquake_search <- submit_form(session, earthquake_form)
url_parsed <- read_html(earthquake_search)
url_link <- url_parsed %>% html_nodes(".url a") %>% html_attr("href")
url_parsed <- read_html(url_link) %>% html_nodes(".col-sm-4 li") %>% html_text()



## 9. The English Wikipedia features an entry with a list of political scientists around the world: https://en.wikipedia.org/wiki/List_of_political_scientists. Make use of this list to (1) download all articles of the listed scientists to your hard drive, (2) gather the network structure behind these articles and visualize it, and (3) identify the top 10 of political scientists that have the most links from other political scientists pointing to their page!




