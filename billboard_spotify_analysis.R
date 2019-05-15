#read data
df <- read.csv("data.csv")

##----------get artist popularity----------##
#make songid dataframe
songid <- data.frame(df$song_id)

#spotify
library(spotifyr)
#set access token
Sys.setenv(SPOTIFY_CLIENT_ID = 'HIDDEN')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'HIDDEN')
access_token <- get_spotify_access_token()

#get artist IDs
artistid <- data.frame(matrix(ncol = 1, nrow = 5479))
for (i in (1:5479)) {
  artistid[i,] = get_track(songid[i,], market = NULL,
                           authorization = get_spotify_access_token())$artist[[2]][1]
}
colnames(artistid) <- "artist.id"

#get artist popularity
artist_pop <- data.frame(matrix(ncol = 1, nrow = 5479))
for (i in (1:5479)) {
  artist_pop[i,] = get_artist (artistid[i,], authorization = get_spotify_access_token())$popularity
}
colnames(artist_pop) <- "artist.popularity"

df_artist.pop <- data.frame(artistid, artist_pop)
df <- data.frame(df, df_artist.pop)

#write csv
write.csv(df_artist.pop, "data_artist_pop.csv")
##----------get artist popularity----------##

##----------creating data frames----------##
#dataset with just billboard songs
df_b1 <- df[df$onBillboard==1,]

#dataset with no billboard songs
df_b0 <- df[df$onBillboard==0,]
##----------creating data frames----------##

##----------creating radar charts----------##
#on Billboard averages
acousticness1 <- mean(df_b1$acousticness)
danceability1 <- mean(df_b1$danceability)
energy1 <- mean(df_b1$energy)
valence1 <- mean(df_b1$valence)
speechiness1 <- mean(df_b1$speechiness)
liveness1 <- mean(df_b1$liveness)
artist_pop1 <- (mean(df_b1$artist.popularity))/100
#not on Billboard averages
acousticness0 <- mean(df_b0$acousticness)
danceability0 <- mean(df_b0$danceability)
energy0 <- mean(df_b0$energy)
valence0 <- mean(df_b0$valence)
speechiness0 <- mean(df_b0$speechiness)
liveness0 <- mean(df_b0$liveness)
artist_pop0 <- (mean(df_b0$artist.popularity))/100

#radar chart for on Billboard
library(plotly)

p1 <- plot_ly(
  type = 'scatterpolar',
  r = c(acousticness1, danceability1, energy1, valence1, speechiness1, liveness1, artist_pop1, acousticness1),
  theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
  fill = 'toself'
) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(-1,1)
      )
    ),
    showlegend = F
  )
p1

#radar chart for not on Billboard
p0 <- plot_ly(
  type = 'scatterpolar',
  r = c(acousticness0, danceability0, energy0, valence0, speechiness0, liveness0, artist_pop0,acousticness0),
  theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
  fill = 'toself'
) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(-1,1)
      )
    ),
    showlegend = F
  )
p0

#combined radar chart
p <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) %>%
  add_trace(
    r = c(acousticness0, danceability0, energy0, valence0, speechiness0, liveness0, artist_pop0,acousticness0),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'Not on Billboard'
  ) %>%
  add_trace(
    r = c(acousticness1, danceability1, energy1, valence1, speechiness1, liveness1, artist_pop1, acousticness1),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'On Billboard'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,1)
      )
    )
  )
p
##----------creating radar charts----------##

##----------t-test between the on billboard vs. not----------##
#acousticness
t.test(df_b0$acousticness,df_b1$acousticness, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#danceability
t.test(df_b0$danceability,df_b1$danceability, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#energy
t.test(df_b0$energy,df_b1$energy, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#valence
t.test(df_b0$valence,df_b1$valence, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#speechiness
t.test(df_b0$speechiness,df_b1$speechiness, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#liveness
t.test(df_b0$liveness,df_b1$liveness, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
#artist popularity
t.test(df_b0$artist.popularity, df_b1$artist.popularity, paired=FALSE,var.equal=FALSE, conf.level = 0.99)
##----------t-test between the on billboard vs. not----------##

##----------creating radar charts by year----------##
#acousticness means by year - on billboard
acousticness1_2015 <- mean(df_b1[df_b1$release_year==2015,]$acousticness)
acousticness1_2016 <- mean(df_b1[df_b1$release_year==2016,]$acousticness)
acousticness1_2017 <- mean(df_b1[df_b1$release_year==2017,]$acousticness)
acousticness1_2018<- mean(df_b1[df_b1$release_year==2018,]$acousticness)
#acousticness means by year - not on billboard
acousticness0_2015 <- mean(df_b0[df_b0$release_year==2015,]$acousticness)
acousticness0_2016 <- mean(df_b0[df_b0$release_year==2016,]$acousticness)
acousticness0_2017 <- mean(df_b0[df_b0$release_year==2017,]$acousticness)
acousticness0_2018<- mean(df_b0[df_b0$release_year==2018,]$acousticness)
#danceability means by year - on billboard
danceability1_2015 <- mean(df_b1[df_b1$release_year==2015,]$danceability)
danceability1_2016 <- mean(df_b1[df_b1$release_year==2016,]$danceability)
danceability1_2017 <- mean(df_b1[df_b1$release_year==2017,]$danceability)
danceability1_2018<- mean(df_b1[df_b1$release_year==2018,]$danceability)
#danceability means by year - not on billboard
danceability0_2015 <- mean(df_b0[df_b0$release_year==2015,]$danceability)
danceability0_2016 <- mean(df_b0[df_b0$release_year==2016,]$danceability)
danceability0_2017 <- mean(df_b0[df_b0$release_year==2017,]$danceability)
danceability0_2018<- mean(df_b0[df_b0$release_year==2018,]$danceability)
#energy means by year - on billboard
energy1_2015 <- mean(df_b1[df_b1$release_year==2015,]$energy)
energy1_2016 <- mean(df_b1[df_b1$release_year==2016,]$energy)
energy1_2017 <- mean(df_b1[df_b1$release_year==2017,]$energy)
energy1_2018<- mean(df_b1[df_b1$release_year==2018,]$energy)
#energy means by year - not on billboard
energy0_2015 <- mean(df_b0[df_b0$release_year==2015,]$energy)
energy0_2016 <- mean(df_b0[df_b0$release_year==2016,]$energy)
energy0_2017 <- mean(df_b0[df_b0$release_year==2017,]$energy)
energy0_2018<- mean(df_b0[df_b0$release_year==2018,]$energy)
#valence means by year - on billboard
valence1_2015 <- mean(df_b1[df_b1$release_year==2015,]$valence)
valence1_2016 <- mean(df_b1[df_b1$release_year==2016,]$valence)
valence1_2017 <- mean(df_b1[df_b1$release_year==2017,]$valence)
valence1_2018<- mean(df_b1[df_b1$release_year==2018,]$valence)
#valence means by year - not on billboard
valence0_2015 <- mean(df_b0[df_b0$release_year==2015,]$valence)
valence0_2016 <- mean(df_b0[df_b0$release_year==2016,]$valence)
valence0_2017 <- mean(df_b0[df_b0$release_year==2017,]$valence)
valence0_2018<- mean(df_b0[df_b0$release_year==2018,]$valence)
#speechiness means by year - on billboard
speechiness1_2015 <- mean(df_b1[df_b1$release_year==2015,]$speechiness)
speechiness1_2016 <- mean(df_b1[df_b1$release_year==2016,]$speechiness)
speechiness1_2017 <- mean(df_b1[df_b1$release_year==2017,]$speechiness)
speechiness1_2018<- mean(df_b1[df_b1$release_year==2018,]$speechiness)
#speechiness means by year - not on billboard
speechiness0_2015 <- mean(df_b0[df_b0$release_year==2015,]$speechiness)
speechiness0_2016 <- mean(df_b0[df_b0$release_year==2016,]$speechiness)
speechiness0_2017 <- mean(df_b0[df_b0$release_year==2017,]$speechiness)
speechiness0_2018<- mean(df_b0[df_b0$release_year==2018,]$speechiness)
#liveness means by year - on billboard
liveness1_2015 <- mean(df_b1[df_b1$release_year==2015,]$liveness)
liveness1_2016 <- mean(df_b1[df_b1$release_year==2016,]$liveness)
liveness1_2017 <- mean(df_b1[df_b1$release_year==2017,]$liveness)
liveness1_2018<- mean(df_b1[df_b1$release_year==2018,]$liveness)
#liveness means by year - not on billboard
liveness0_2015 <- mean(df_b0[df_b0$release_year==2015,]$liveness)
liveness0_2016 <- mean(df_b0[df_b0$release_year==2016,]$liveness)
liveness0_2017 <- mean(df_b0[df_b0$release_year==2017,]$liveness)
liveness0_2018<- mean(df_b0[df_b0$release_year==2018,]$liveness)
#artist_pop means by year - on billboard
artist_pop1_2015 <- mean(df_b1[df_b1$release_year==2015,]$artist.popularity)/100
artist_pop1_2016 <- mean(df_b1[df_b1$release_year==2016,]$artist.popularity)/100
artist_pop1_2017 <- mean(df_b1[df_b1$release_year==2017,]$artist.popularity)/100
artist_pop1_2018<- mean(df_b1[df_b1$release_year==2018,]$artist.popularity)/100
#artist_pop means by year - not on billboard
artist_pop0_2015 <- mean(df_b0[df_b0$release_year==2015,]$artist.popularity)/100
artist_pop0_2016 <- mean(df_b0[df_b0$release_year==2016,]$artist.popularity)/100
artist_pop0_2017 <- mean(df_b0[df_b0$release_year==2017,]$artist.popularity)/100
artist_pop0_2018<- mean(df_b0[df_b0$release_year==2018,]$artist.popularity)/100
#2015 combined radar chart
p2015 <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) %>%
  add_trace(
    r = c(acousticness0_2015, danceability0_2015, energy0_2015, valence0_2015, speechiness0_2015, 
          liveness0_2015, artist_pop0_2015,acousticness0_2015),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'Not on Billboard'
  ) %>%
  add_trace(
    r = c(acousticness1_2015, danceability1_2015, energy1_2015, valence1_2015, speechiness1_2015, 
          liveness1_2015, artist_pop1_2015, acousticness1_2015),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'On Billboard'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,1)
      )
    )
  )
p2015
#2016 combined radar chart
p2016 <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) %>%
  add_trace(
    r = c(acousticness0_2016, danceability0_2016, energy0_2016, valence0_2016, speechiness0_2016, 
          liveness0_2016, artist_pop0_2016,acousticness0_2016),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'Not on Billboard'
  ) %>%
  add_trace(
    r = c(acousticness1_2016, danceability1_2016, energy1_2016, valence1_2016, speechiness1_2016, 
          liveness1_2016, artist_pop1_2016, acousticness1_2016),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'On Billboard'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,1)
      )
    )
  )
p2016
#2017 combined radar chart
p2017 <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) %>%
  add_trace(
    r = c(acousticness0_2017, danceability0_2017, energy0_2017, valence0_2017, speechiness0_2017, 
          liveness0_2017, artist_pop0_2017,acousticness0_2017),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'Not on Billboard'
  ) %>%
  add_trace(
    r = c(acousticness1_2017, danceability1_2017, energy1_2017, valence1_2017, speechiness1_2017, 
          liveness1_2017, artist_pop1_2017, acousticness1_2017),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'On Billboard'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,1)
      )
    )
  )
p2017
#2018 combined radar chart
p2018 <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) %>%
  add_trace(
    r = c(acousticness0_2018, danceability0_2018, energy0_2018, valence0_2018, speechiness0_2018, 
          liveness0_2018, artist_pop0_2018,acousticness0_2018),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'Not on Billboard'
  ) %>%
  add_trace(
    r = c(acousticness1_2018, danceability1_2018, energy1_2018, valence1_2018, speechiness1_2018, 
          liveness1_2018, artist_pop1_2018, acousticness1_2018),
    theta = c('acousticness','danceability','energy', 'valence', 'speechiness', 'liveness', 'artist popularity', 'acousticness'),
    name = 'On Billboard'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,1)
      )
    )
  )
p2018
##----------creating radar charts by year----------##
