library(TMDb)

#set API key
api_key <- "b5938e1567468184456894fec22b777a"

##POPULAR
#get movie id, title, and release date for popular movies
movie_id_pop <- data.frame(matrix(ncol = 990, nrow = 20))
movie_title_pop <- data.frame(matrix(ncol = 990, nrow = 20))
rel_date_pop <- data.frame(matrix(ncol = 990, nrow = 20))
for (i in 1:991) {
  movie<-movie_popular(api_key, page = i, language = NA)
  movie_id_pop[,i] <- movie$results[2]
  movie_title_pop[,i] <- movie$results[5]
  rel_date_pop[,i] <- movie$results[14]
  Sys.sleep(2)
}

#combine into one column
movie_id_pop <- data.frame(unlist(movie_id_pop, use.names=FALSE)); colnames(movie_id_pop) <- "ID"
movie_title_pop <- data.frame(unlist(movie_title_pop, use.names=FALSE)); colnames(movie_title_pop) <- "Title"
rel_date_pop <- data.frame(unlist(rel_date_pop, use.names=FALSE)); colnames(rel_date_pop) <- "Rel_Date"

#combine and filter out movies with release date before 2010
df_pop <- data.frame(movie_id_pop, movie_title_pop, rel_date_pop)
df_pop$Rel_Date <- as.Date(df_pop$Rel_Date, format= "%Y-%m-%d")
df_pop <- subset(df_pop, df_pop$Rel_Date > "2009-12-31" )

#get budget for popular movies
budget_pop <- data.frame(matrix(ncol = 1, nrow = dim(df_pop)[1])); colnames(budget) <- "Budget"

for (i in 1:dim(df_pop)[1]) {
  budget_pop[i,1] <- movie(api_key, id=df_pop[i,1], language = NA, append_to_response = NA)$budget
  Sys.sleep(1)
}

colnames(budget_pop) <- "Budget"

#combine and filter out movies with budget set to 0
df_pop <- data.frame(df_pop, budget_pop)
df_pop <- subset(df_pop, df_pop$Budget > 1)

#save file
write.csv(df_pop, "popular.csv")
