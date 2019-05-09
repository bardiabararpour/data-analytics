def getPlayListInfo(userID, playlistID):

    import spotipy
    from spotipy.oauth2 import SpotifyClientCredentials
    import spotipy.util as util
    import pandas as pd
    import numpy as np

    #Connect to Spotify
    cid ="ecbf15054a944d8ba32d1a9df418a93c"
    secret = "1841761a9dc4430180bd22796e3731fd"

    client_credentials_manager = SpotifyClientCredentials(client_id=cid, client_secret=secret)
    sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)


    billboard_list = sp.user_playlist(userID,playlistID)

    billboard_tracks = billboard_list["tracks"]
    billboard_songs = billboard_tracks["items"]

    while billboard_tracks["next"]:
        billboard_tracks = sp.next(billboard_tracks)
        for item in billboard_tracks["items"]:
            billboard_songs.append(item)

    #Get ids, artists, titles, release date of songs
    billboard_ids = []
    artists = []
    titles = []
    release_year = []
    release_date = []

    for i in range(len(billboard_songs)):

    # check if release year is after 2015
        if billboard_songs[i]["track"] is not None:
            date = billboard_songs[i]["track"]["album"]["release_date"]
            if date is None:
                continue
            elif int(date[0:4]) < 2015:
                continue
            elif len(date) == 4:
                release_year.append(date)
            else:
                release_year.append(date[0:4])

            billboard_ids.append(billboard_songs[i]["track"]["id"])
            artists.append(billboard_songs[i]["track"]["artists"][0]["name"])
            titles.append(billboard_songs[i]["track"]["name"])
            release_date.append(billboard_songs[i]["track"]["album"]["release_date"])
        else:
            continue

    #Get features
    features = []
    for i in range(0,len(billboard_ids),50):
        audio_features = sp.audio_features(billboard_ids[i:i+50])
        for track in audio_features:
            features.append(track)
            features[-1]['target'] = 1

    data = pd.DataFrame(features)
    data.insert(0, "artists",artists)
    data.insert(0, "titles",titles)
    data.insert(2, "song_id",billboard_ids)
    data.insert(3, "release_year",release_year)
    data.insert(4, "release_date",release_date)

    #Drop unuseful columns
    data = data.drop(columns =["analysis_url","type","track_href","uri","id","target"])

    return data
