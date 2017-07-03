### -----------------------------
### simon munzert
### social media data
### -----------------------------

## peparations -------------------

source("packages.r")
source("functions.r")



## mining Twitter with R ----------------

## about the Twitter APIs

  # two APIs types of interest:
  # REST APIs --> reading/writing/following/etc., "Twitter remote control"
  # Streaming APIs --> low latency access to 1% of global stream - public, user and site streams
  # authentication via OAuth
  # documentation at https://dev.twitter.com/overview/documentation

## how to get started

  # 1. register as a developer at https://dev.twitter.com/ - it's free
  # 2. create a new app at https://apps.twitter.com/ - choose a random name
  # 3. go to "Keys and Access Tokens" and keep the displayed information ready
  
  # again: how to register at Twitter as developer, obtain and use access tokens
  browseURL("https://mkearney.github.io/rtweet/articles/auth.html")

## R packages that connect to Twitter API

  # twitteR: connects to REST API; weird design decisions regarding data format
  # streamR: connects to Streaming API; works very reliably, connection setup a bit difficult
  # rtweet: connects to both REST and Streaming API, nice data formats, still under active development


library(rtweet)
## name assigned to created app
appname <- "TwitterToR"
## api key (example below is not a real key)
load("/Users/munzerts/rkeys.RDa")
key <- TwitterToR_twitterkey
## api secret (example below is not a real key)
secret <- TwitterToR_twittersecret
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

rt <- search_tweets("merkel", n = 200, token = twitter_token)
View(rt)



## streaming Tweets with the rtweet package -----------------

# set keywords used to filter tweets
q <- paste0("clinton,trump,hillaryclinton,imwithher,realdonaldtrump,maga,electionday")
q <- paste0("schulz,merkel,btw17,btw2017")

# parse directly into data frame
twitter_stream_ger <- stream_tweets(q = q, timeout = 30, token = twitter_token)

# set up directory and JSON dump
rtweet.folder <- "data/rtweet-data"
dir.create(rtweet.folder)
streamname <- "btw17"
filename <- file.path(rtweet.folder, paste0(streamname, "_", format(Sys.time(), "%F-%H-%M-%S"), ".json"))

# create file with stream's meta data
streamtime <- format(Sys.time(), "%F-%H-%M-%S")
metadata <- paste0(
  "q = ", q, "\n",
  "streamtime = ", streamtime, "\n",
  "filename = ", filename)
metafile <- gsub(".json$", ".txt", filename)
cat(metadata, file = metafile)

# sink stream into JSON file
stream_tweets(q = q, parse = FALSE,
              timeout = 3600,
              file_name = filename,
              language = "de",
              token = twitter_token)

# parse from json file
rt <- parse_stream(filename)

# inspect tweets data
names(rt)
head(rt)

# inspect users data
users_data(rt) %>% head()
users_data(rt) %>% names()


## mining tweets with the rtweet package ------

rt <- parse_stream("data/rtweet-data/clintontrump_2017-05-19-16-27-32.json")
clinton <- str_detect(rt$text, regex("hillary|clinton", ignore_case = TRUE))
trump <- str_detect(rt$text, regex("donald|trump", ignore_case = TRUE))
mentions_df <- data.frame(clinton,trump)
colMeans(mentions_df, na.rm = TRUE)


## mining twitter accounts with the rtweet package ------

user_df <- lookup_users("RDataCollection")
names(user_df)
user_timeline_df <- get_timeline("RDataCollection")
names(user_timeline_df)
user_favorites_df <- get_favorites("RDataCollection")
names(user_favorites_df)


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




