library(spotifyr)

#set access token
Sys.setenv(SPOTIFY_CLIENT_ID = 'HIDDEN')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'HIDDEN')
access_token <- get_spotify_access_token()

#get playlist track name, album, track type, release date, and popularity
track.name <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF", 
                                  authorization = get_spotify_access_token())$track.name)
colnames(track.name) <- "track_name"

track.album <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                   authorization = get_spotify_access_token())$track.album.name)
colnames(track.album) <- "album"

track.type <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                  authorization = get_spotify_access_token())$track.album.album_type)
colnames(track.type) <- "track_type"

track.release <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                     authorization = get_spotify_access_token())$track.album.release_date)
colnames(track.release) <- "release_date"

track.popularity <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                                   authorization = get_spotify_access_token())$track.popularity)
colnames(track.popularity) <- "popularity"

#get artist name (only the first listed)
track.artist.temp <- get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                    authorization = get_spotify_access_token())$track.album.artists
track.artist <- data.frame(matrix(ncol = 1, nrow = 50))
for (i in (1:50)) {
  track.artist[i,] = track.artist.temp[[i]][["name"]][1]
}
colnames(track.artist) <- "artist"

#get track id
d <- get_track_audio_features("2Fxmhks0bxGSBdJ92vM42m", get_spotify_access_token())
track.id <- data.frame(get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                           authorization = get_spotify_access_token())$track.id, stringsAsFactors = FALSE)
colnames(track.id) <- "track.id"

#get features
track.features <- data.frame(matrix(ncol = 18, nrow = 50))
for (i in (1:50)) {
  track.features[i,] <- get_track_audio_features(track.id[i,], get_spotify_access_token())
}
colnames(track.features) <- colnames(d)

#combine
df = data.frame(track.name, track.album, track.artist, track.type, track.release, track.popularity,track.features)
df$release_date <- as.Date(df$release_date, format= "%Y-%m-%d")

#save file
write.csv(df, "spotify_top50_V2.csv")
