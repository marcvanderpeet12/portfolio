
#Connectin to twitter
connect_twittR_api <- function() {
  
  library(twitteR)
  
  consumer_key <- "Qgzz3HsGh8Ea5RnIkokoo9TjF"
  consumer_secret <- "zx7X0mP0K3sjpI2gZf3afokSmrPJ79oI8650abhEdDMHSCfLdg"
  access_token <-  "926479201414385668-GIpDcplzHxMxt0lP9TbXbv43e3O6bpK"
  access_secret <-  "STofoN1UtqpGy1zvtiJ5SMB5129FNRwgzwwJHvDSwnuUP"
  
  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  
}


#Add a sentiment column on a dataframe
create_sentiment <- function(a_dataframe){
  
  sentiment <- c()
  tweets <- a_dataframe$tweet
  
  for(tweet in tweets){
    
    #Remove punctuation, control characters and digits 
    tweet = gsub("[[:punct:]]", "", tweet)
    tweet = gsub("[[:cntrl:]]", "", tweet)
    tweet = gsub('\\d+', '', tweet)  
    
    word_list = str_split(tweet, "\\s+")
    words = unlist(word_list)
    
    positives= readLines("positive-words.txt")
    negatives = readLines("negative-words.txt")
    
    positive_matches = match(words, positives)
    negative_matches = match(words, negatives)
    
    positive_matches = !is.na(positive_matches)
    negative_matches = !is.na(negative_matches)
    
    score = sum(positive_matches) - sum(negative_matches)
    sentiment<-c(sentiment,score)

    }
}
  
  #This fetches the longitude and latitude value based on a list of cities
  
  setwd("~/portfolio2/data")
  
  #Only run once at beginninng
  fetch_lng_lat_values <- function(){
    library("googleway")
    my_api_key = "AIzaSyBrCfDN2RYdUIsDXoe9Ojkywe_GBuLdnfo"
    
    countries <- read.csv("countries.csv")
    states <- read.csv("states.csv")
    
    df_total_EUR <- data.frame(countries = character(), lon = character(), lat = character())
    df_total_US <- data.frame(state = character(), lon = character(), lat = character())
    
    countries <- as.character(countries$Countries)
    states <- as.character(states$States)
    
    for(state in states){
      df_temp <- google_geocode(address = state, key = my_api_key)
      df_add <- data.frame(state = state, lon = df_temp$results$geometry$location$lng, lat = df_temp$results$geometry$location$lat)
      df_total_US <- rbind(df_add, df_total_US)
    }
    
    for(country in countries){
      df_temp <- google_geocode(address = country, key = my_api_key)
      df_add <- data.frame(state = country, lon = df_temp$results$geometry$viewport$northeast$lng, lat = df_temp$results$geometry$viewport$northeast$lat)
      df_total_EUR <- rbind(df_add, df_total_EUR)
    }
    
    write.csv(df_total_EUR, "final_states_EUR.csv")
    write.csv(df_total_US, "final_states_US.csv")
    
  }  
  