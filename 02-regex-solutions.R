### -----------------------------
## simon munzert
## regular expressions and
## string manipulation
## solutions
### -----------------------------


source("packages.r")
source("functions.r")


## 1. describe the types of strings that conform to the following regular expressions and construct an example that is matched by the regular expression.
str_extract_all("Phone 150$, PC 690$", "[0-9]+\\$") # example
str_extract_all("Just any sentence, I don't know. Today is a nice day.", "\\b[a-z]{1,4}\\b")
str_extract_all(c("log.txt", "example.html", "bla.txt2"), ".*?\\.txt$")
str_extract_all("log.txt, example.html, bla.txt2", ".*?\\.txt$")
str_extract_all(c("01/01/2000", "1/1/00", "01.01.2000"), "\\d{2}/\\d{2}/\\d{4}")
str_extract_all(c("<br>laufen</br>", "<title>Cameron wins election</title>"), "<(.+?)>.+?</\\1>")

## 2. consider the mail address  chunkylover53[at]aol[dot]com.
# a) transform the string to a standard mail format using regular expressions.
# b) imagine we are trying to extract the digits in the mail address using [:digit:]. explain why this fails and correct the expression.
email <- "chunkylover53[at]aol[dot]com"
email_new <- email %>% str_replace("\\[at\\]", "@") %>% str_replace("\\[dot\\]", ".")
str_extract(email_new, "[:digit:]+") # note: in an updated version of stringr, [:digit:] works, too. In an earlier version, one had to write [[:digit:]] (see book!)



# ADCR, Chapter 8, Problems 2, 3, 7, 8, and 9

### 2. Find a regular expression that matches any text!

regex <- ".*"
string <- c("1. This is an example string by", "2. Eddie (born 1961 in München)", "!§%$&/)(}")
str_extract_all(string, regex)

### 3. Copy the introductory example. The vector 'name' stores the extracted names.

raw.data <- "555-1239Moe Szyslak(636) 555-0113Burns, C. Montgomery555-6542Rev. Timothy Lovejoy555 8904Ned Flanders636-555-3226Simpson, Homer5553642Dr. Julius Hibbert"
(name <- unlist(str_extract_all(raw.data, "[[:alpha:]., ]{2,}")))

# (a) Use the tools of this chapter to rearrange the vector so that all elements conform to the standard first_name last_name.
(name_sorted <-  str_replace(name, "(.+), (.+)", "\\2 \\1"))

# (b) Construct a logical vector indicating whether a character has a title (i.e., Rev. and Dr. ).
has_title <- str_detect(name, pattern="Dr\\. |Rev\\.")

# (c) Construct a logical vector indicating whether a character has a second name.
name_elements <- str_count(name_sorted, "\\w+")
has_second_name <- ifelse(has_title == FALSE & name_elements > 2, TRUE,
                          ifelse(has_title == TRUE & name_elements > 3, TRUE, FALSE))


### 7. Consider the string <title>+++BREAKING NEWS+++</title> . We would like to extract the first HTML tag. To do so we write the regular expression <.+> . Explain why this fails and correct the expression.
string <- "<title>+++BREAKING NEWS+++</title>"
str_extract(string, "<.+>") # greedy quantification!
str_extract(string, "<.+?>")


### 8. Consider the string '(5-3)^2=5^2-2*5*3+3^2 conforms to the binomial theorem'. We would like to extract the formula in the string. To do so we write the regular expression [^0-9=+*()]+ . Explain why this fails and correct the expression.

string <- "(5-3)^2=5^2-2*5*3+3^2 conforms to the binomial theorem"
regex <- "[^0-9=+*()]+"
str_extract_all(string, regex)
regex_correct <- "[[:digit:]()=*-^]+"

str_extract_all(string, regex_correct)


### 9.  The following code hides a secret message. Crack it with R and regular expressions. Hint: Some of the characters are more revealing than others! The code snippet is also available in the materials at www.r-datacollection.com.

secret <- "clcopCow1zmstc0d87wnkig7OvdicpNuggvhryn92Gjuwczi8hqrfpRxs5Aj5dwpn0TanwoUwisdij7Lj8kpf03AT5Idr3coc0bt7yczjatOaootj55t3Nj3ne6c4Sfek.r1w1YwwojigOd6vrfUrbz2.2bkAnbhzgv4R9i05zEcrop.wAgnb.SqoU65fPa1otfb7wEm24k6t3sR9zqe5fy89n6Nd5t9kc4fE905gmc4Rgxo5nhDk!gr"

(solved <- unlist(str_extract_all(secret, "[[:upper:][:punct:]]")))
str_c(solved, collapse="")
