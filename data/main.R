
#Check if file exists / Else run function to scrape lat/long values


setwd("~/portfolio2/data/")
df <- read.csv("final_states_US.csv")

N=10  # tweets to request from each query
S=200  # radius in miles

print(paste0("Scraping tweets for: ", df$state[1]))
donald_temp <- searchTwitter('Donald+Trump',
                             lang="en",n=N,resultType="recent",
                             geocode=paste(df$lat[1], df$lon[1],paste0(S,"mi"),sep=","))

df_total <- create_dataset(donald_temp, cities[1])

for(i in 2:nrow(df)){
  
  print(paste0("Scraping tweets for: ", df$state[i]))
  donald_temp <- searchTwitter('Donald+Trump',
                               lang="en",n=N,resultType="recent",
                               geocode=paste(df$lat[i], df$lon[i],paste0(S,"mi"),sep=","))
  
  
  
  df_temp <- create_dataset(donald_temp, cities[i])
  df_total <- rbind(df_total, df_temp)  
  
}

  for(i in 2:length(lons)){
    
    print(paste0("Scraping tweets for: ", cities[i]))
    donald_temp <- searchTwitter('Donald+Trump',
                                 lang="en",n=N,resultType="recent",
                                 geocode=paste(lats[i],lons[i],paste0(S,"mi"),sep=","))
    
    df_temp <- create_dataset(donald_temp, cities[i])
    df_total <- rbind(df_total, df_temp)
  }
  
  df_total <- create_sentiment(df_total)
  return(df_total)
  
}
