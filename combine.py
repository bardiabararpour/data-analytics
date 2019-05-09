import getPlayListInfo as get
import csv
import numpy as np


hot2018 = get.getPlayListInfo("stealthamo","6vuvT0baeMMJoTa8kVM7oY")
hot2017 = get.getPlayListInfo("whe1998","255aUSCuVTcdD5JTogG69d")
hot2016 = get.getPlayListInfo("hitsebeats","2LWafCgWzsXGWv7wJeePjA")
hot2015 = get.getPlayListInfo("hitsebeats","1xkuRzFhnX3hCWu6hLxJ0U")
# hot2014 = get.getPlayListInfo("stealthamo","6ZQ8a749r0qZwNeTvSv0k3")
# hot2013 = get.getPlayListInfo("stealthamo","6Moo4eDbKpDJivQlM1AceG")
# hot2012 = get.getPlayListInfo("brother__sport","13OvF9WXSfPMNcxpzcVB4t")
# hot2011 = get.getPlayListInfo("stealthamo","2tW9fbypCxOTCl3CP4FHHg")
# hot2010 = get.getPlayListInfo("stealthamo","2NqEUPYib1SnNxRcEQyKoi")

hot = hot2018.append([hot2017,hot2016,hot2015])
hot = hot.assign(onBillboard = 1)

allSong = get.getPlayListInfo("thedoctorkto","54nv8jbrm4JoHEZ49Qvjgl")
allSong = allSong.assign(onBillboard = allSong.song_id.isin(hot.song_id).astype(int))

data = allSong.append(hot).drop_duplicates(subset = ['song_id'],keep = "last")
data = data.drop_duplicates(subset = ['titles','artists'],keep = "last")

data.to_csv("data.csv")

