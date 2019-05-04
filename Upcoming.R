library(TMDb)

#set API key
api_key <- "b5938e1567468184456894fec22b777a"

##UPCOMING
#get movie id, title, and release date for upcoming movies
movie_id <- data.frame(matrix(ncol = 13, nrow = 20))
movie_title <- data.frame(matrix(ncol = 13, nrow = 20))
rel_date <- data.frame(matrix(ncol = 13, nrow = 20))
for (i in 1:13) {
  movie_id[,i] <- movie_upcoming(api_key, page = i, language = NA)$results[2]
  movie_title[,i] <- movie_upcoming(api_key, page = i, language = NA)$results[5]
  rel_date[,i] <- movie_upcoming(api_key, page = i, language = NA)$results[14]
  Sys.sleep(2)
}

#combine info one column
movie_id <- data.frame(unlist(movie_id, use.names=FALSE)); colnames(movie_id) <- "ID"
movie_title <- data.frame(unlist(movie_title, use.names=FALSE)); colnames(movie_title) <- "Title"
rel_date <- data.frame(unlist(rel_date, use.names=FALSE)); colnames(rel_date) <- "Rel_Date"

#get budget for upcoming movies
budget <- data.frame(matrix(ncol = 1, nrow = dim(movie_id)[1])); colnames(budget) <- "Budget"

for (i in 1:dim(movie_id)[1]) {
  budget[i,1] <- movie(api_key, id=movie_id[i,1], language = NA, append_to_response = NA)$budget
  Sys.sleep(1)
}

#combine and filter out movies with no budget listed
df <- data.frame(movie_id, movie_title, rel_date, budget)
df <- subset(df, df$Budget > 1)
