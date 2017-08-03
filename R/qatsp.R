#量子アニーリングの練習
#http://qiita.com/ab_t/items/8d52096ad0f578aa2224

qatsp <- function(x = NULL, y = NULL,
                  trace = TRUE,
                  beta  = 37,
                  trotter = 10,
                  ann_para = 1,
                  ann_step = 330,
                  mc_step = 6660,
                  reduc = 0.99){

  #初期チェック
  if(is.null(x) || is.null(y)){stop("Please enter the position in x and y.")}
  if(!length(x) == length(y)){stop("Make the vector length of x and y the same.")}
  ncity <- length(x)

  #2都市間の距離をmatrixに変換
  city_distance <- matrix(rep(0, times = ncity * ncity), ncol = ncity)
  for(i in 1:ncity){
    for(j in (i + 1):ncity){
      if(!i + 1 > ncity){
        city_distance[i, j] <- sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2 )
        city_distance[j, i] <- city_distance[i, j]
      }
    }
  }


  #spinの初期値を作成する。
  #次元はncity * ncity * torotter
  #spinそのものでなく、まず関数を作成。
  make_spin <- function(ncity, trotter){
    #まず、ncity x ncityのspinの行列を作る。
    spin0 <- diag(1, ncol = ncity, nrow = ncity)
    spin0 <- 2*spin0 - 1

    #行でシャッフル
    mat_shaffle <- function(spin0){
      num_shaffle <- c(1, sample(c(2: length(spin0[,1]))))
      ret <- spin0[num_shaffle, ]
      return(ret)
    }

    #spin用に空のテンソル
    #ncity, ncity, trotter_dimの次元
    spin <- array(
      c(0, times = ncity*ncity*trotter),
      dim = c(ncity, ncity, trotter)
    )

    #ランダムにシャッフルしたスピンを各トロッタに入れる
    for(tr in 1:trotter){
      spin[,,tr] <- mat_shaffle(spin0)
    }
    return(spin)
  }

  #spinの初期値を作成
  spin <- make_spin(ncity, trotter)

  #指定したトロッタの距離計算
  tr_distance <- function(spin, city_distance ,tr){
    L <- 0
    spin_tr <- spin[, , tr]
    for(i in 1:ncity){
      spin_i1 <- which(spin_tr[i, ] == 1)[1]
      spin_i2 <- which(spin_tr[(i%%ncity + 1), ] == 1)[1]
      L <- L + city_distance[spin_i1, spin_i2]
    }
    return(L)
  }

  #全てのトロッタの距離計算
  tr_all_distance <- function(spin, city_distance){
    L <- NULL
    for(tr in 1:trotter){
      L <- c(L, tr_distance(spin, city_distance, tr))
    }
    return(L)
  }
  spin_distance <- tr_all_distance(spin, city_distance)


  #量子モンテカルロ
  qmc <- function(spin, city_distance){
    #初期値を定義
    ncity <- length(spin[, 1, 1])
    max_distance <- max(city_distance)
    trotter <- length(spin[1, 1, ])

    #a,b,p,q,trを決める。
    ab <- sample(c(2:ncity), size = 2)
    a <- ab[1]
    b <- ab[2]
    tr <- round(runif(1) * (trotter -1 ) + 1.5)
    p <- which(spin[a, , tr] == 1)
    q <- which(spin[b, , tr] == 1)

    cost_c <- 0

    #古典的コスト
    for(j in 1:ncity){
      lpj <- city_distance[p, j]/max_distance
      lqj <- city_distance[q, j]/max_distance

      cost_c1 <- 2 * (-lpj * spin[a, p, tr] - lqj * spin[a, q, tr])
      cost_c2 <- (spin[(a - 1), j, tr] + spin[a%%ncity + 1, j, tr])
      cost_c3 <- 2 * (-lpj * spin[b, p, tr] - lqj * spin[b, q, tr])
      cost_c4 <- (spin[(b - 1), j, tr] + spin[b%%ncity + 1, j, tr])

      cost_c <- cost_c + (cost_c1 * cost_c2 + cost_c3 * cost_c4)
    }

    #量子的コスト
    cost_q1 <- spin[a, p, tr] * (spin[a, p, (tr - 2)%%trotter + 1] + spin[a, p, (tr)%%trotter + 1])
    cost_q2 <- spin[a, q, tr] * (spin[a, q, (tr - 2)%%trotter + 1] + spin[a, q, (tr)%%trotter + 1])
    cost_q3 <- spin[b, p, tr] * (spin[b, p, (tr - 2)%%trotter + 1] + spin[b, p, (tr)%%trotter + 1])
    cost_q4 <- spin[b, q, tr] * (spin[b, q, (tr - 2)%%trotter + 1] + spin[b, q, (tr)%%trotter + 1])
    cost_qr <- (1/beta) * log(cosh(beta * ann_para/trotter) / sinh(beta * ann_para / trotter))
    cost_q <- cost_qr * (cost_q1 + cost_q2 + cost_q3 + cost_q4)

    #合計のコスト
    cost <- cost_c/trotter + cost_q

    #flip
    if(cost <= 0 || runif(1) < exp(-beta * cost)){
      spin[a, p, tr] <- (spin[a, p, tr] * (-1))
      spin[a, q, tr] <- (spin[a, q, tr] * (-1))
      spin[b, p, tr] <- (spin[b, p, tr] * (-1))
      spin[b, q, tr] <- (spin[b, q, tr] * (-1))
    }

    #戻り値
    return(spin)
  }


  #量子アニーリング(本体)
  min_tsp <- NULL
  distance_tsp <- NULL

  for(astep in 1:ann_step){
    for(mstep in 1:mc_step){
      spin <- qmc(spin, city_distance)
    }
    ann_para <- ann_para * reduc

    spin_distance <- tr_all_distance(spin, city_distance)


    distance_tsp <- c(distance_tsp, min(spin_distance))
    min_tsp <- c(min_tsp, min(distance_tsp))

    if(trace){
      plot(distance_tsp, type = "l")
    }
  }

  #戻り値
  ret <- list(distance = distance_tsp)


}


#データを開く
#http://www.math.uwaterloo.ca/tsp/world/countries.html
data <- read.table("dj38.tsp",
                   skip = 10, sep = " ", header = FALSE)


set.seed(108)
test <- qatsp(x = data[,2], y= data[,3])



