#Various functions for moving qatsp with shiny

#Convert to vector
as.vec <- function(x){return(as.vector(as.matrix(x)))}


#Convert vector containing comma to numeric value
as.num <- function(x){
  x <- as.vec(x)
  x <- as.numeric(gsub(",", "", x))
  return(x)
}


#Get item name of numeric value
get.numeric.name <- function(df){
  df.name <- colnames(df)
  n <- length(df[1, ])
  ret <- NULL
  for(i in 1:n){
    chk <- tryCatch({as.num(df[, i])}, warning = function(e){}, silent = TRUE)
    if(is.numeric(chk) && !is.na(chk)){ret <- c(ret, df.name[i])}
  }
  return(ret)
}






