### -----------------------------
### simon munzert
### tapping wikipedia
### -----------------------------

## peparations -------------------

source("packages.r")
source("functions.r")


## getting pageviews from Wikipedia ---------------------------

## IMPORTANT: If you want to gather pageviews data before July 2015, you need the statsgrokse package. Check it out here:
browseURL("https://github.com/cran/statsgrokse")

ls("package:pageviews")

trump_views <- article_pageviews(project = "en.wikipedia", article = "Donald Trump", user_type = "user", start = "2015070100", end = "2017040100")
head(trump_views)
clinton_views <- article_pageviews(project = "en.wikipedia", article = "Hillary Clinton", user_type = "user", start = "2015070100", end = "2017040100")

plot(ymd(trump_views$date), trump_views$views, col = "red", type = "l")
lines(ymd(clinton_views$date), clinton_views$views, col = "blue")

german_parties_views <- article_pageviews(
  project = "de.wikipedia", 
  article = c("Christlich Demokratische Union Deutschlands", "Christlich-Soziale Union in Bayern", "Sozialdemokratische Partei Deutschlands", "Freie Demokratische Partei", "Bündnis 90/Die Grünen", "Die Linke", "Alternative für Deutschland"),
  user_type = "user", 
  start = "2015090100", 
  end = "2017040100"
)
table(german_parties_views$article)

parties <- unique(german_parties_views$article)
dat <- filter(german_parties_views, article == parties[1])
plot(ymd(dat$date), dat$views, col = "black", type = "l")
dat <- filter(german_parties_views, article == parties[2])
lines(ymd(dat$date), dat$views, col = "blue")
dat <- filter(german_parties_views, article == parties[3])
lines(ymd(dat$date), dat$views, col = "red")
dat <- filter(german_parties_views, article == parties[7])
lines(ymd(dat$date), dat$views, col = "brown")


## getting data from Google Trends ---------------------------

# IMPORTANT: The current gtrendsR version that is available on CRAN does not work. Install the developer version from GitHub by uncommenting the following line and running it (you might have to install the devtools package before that)
#devtools::install_github('PMassicotte/gtrendsR')
library(gtrendsR)
gtrends_merkel <- gtrends("Merkel", geo = c("DE"), time = "2017-01-01 2017-05-15")
gtrends_schulz <- gtrends("Schulz", geo = c("DE"), time = "2017-01-01 2017-05-15")

plot(gtrends_merkel)
plot(gtrends_schulz)




