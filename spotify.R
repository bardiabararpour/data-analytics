library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '252389128d76435d9d29f188d553ce99')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '1099122b0d304b8a884b1ab4a0edec98')

access_token <- get_spotify_access_token()

#get playlist tracks
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


#for loop to get artist name (only first listed)
track.artist.temp <- get_playlist_tracks("37i9dQZEVXbMDoHDwVN2tF",
                                    authorization = get_spotify_access_token())$track.album.artists
track.artist <- data.frame(matrix(ncol = 1, nrow = 50))
for (i in (1:50)) {
  track.artist[i,] = track.artist.temp[[i]][["name"]][1]
}
colnames(track.artist) <- "artist"

#combine
df = data.frame(track.name, track.album, track.artist, track.type, track.release, track.popularity)
