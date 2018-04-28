#qatspをshinyで動かすための各種関数

#ベクトルに変換
as.vec <- function(x){return(as.vector(as.matrix(x)))}


#コンマが入ったベクトルを数値に変換
as.num <- function(x){
  x <- as.vec(x)
  x <- as.numeric(gsub(",", "", x))
  return(x)
}


#数値の項目名を取得
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






