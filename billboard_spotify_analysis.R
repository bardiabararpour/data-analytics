#read data
df <- read.csv("data.csv")

##----------get artist popularity----------##
#make songid dataframe
songid <- data.frame(df$song_id)

#spotify
library(spotifyr)
#set access token
Sys.setenv(SPOTIFY_CLIENT_ID = '252389128d76435d9d29f188d553ce99')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '1099122b0d304b8a884b1ab4a0edec98')
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