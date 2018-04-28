#量子アニーリング

#以下のサイトを参考。
#http://qiita.com/ab_t/items/8d52096ad0f578aa2224


qatsp <- function(x = NULL, y = NULL,
                  beta  = 50,
                  trotter = 10,
                  ann_para = 1,
                  ann_step = 500,
                  mc_step = 5000,
                  reduc = 0.99,
                  trace = TRUE,
                  route = FALSE
                  ){
  #起動時間記録
  t0 <- proc.time()

  #アニーリングパラメータを記録
  ann_para0 <- ann_para

  #初期チェック
  if(is.null(x) || is.null(y)){stop("Please enter the position in x and y.")}
  if(!length(x) == length(y)){stop("Make the vector length of x and y the same.")}
  ncity <- length(x)


  #2都市間の距離をmatrixに変換
  city_distance <- matrix(rep(0, times = ncity * ncity), ncol = ncity)
  for(i in 1:(ncity -1)){
    for(j in (i + 1):ncity){
      city_distance[i, j] <- sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2 )
      city_distance[j, i] <- city_distance[i, j]
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


  #trotterを1加えたときの値
  #ただし、trotterを超えれば1に戻る
  #tr_p1[1] で2を返す。
  tr_p1 <- c(c(2: trotter), 1)

  #trotterを1減じたときの値
  #ただし、0になればtrotterになる。
  tr_m1 <- c(trotter, c(1: (trotter - 1)))

  #a,bに1を加えた時の値。
  #ただし、ncityを超えれば1に戻る。
  ab_p1 <- c(c(2: ncity), 1)

  #余接関数
  coth <- function(x){return(1/tanh(x))}

  #量子モンテカルロ
  qmc <- function(spin, city_distance, ncity, max_distance, trotter, cost_qr){
    #a,b,p,q,trを決める。
    ab <- sample(c(2:ncity), size = 2)
    a <- ab[1]
    b <- ab[2]
    tr <- round(runif(1) * (trotter -1 ) + 1.5)
    p <- which(spin[a, , tr] == 1)
    q <- which(spin[b, , tr] == 1)

    #古典的コスト
    lpj <- city_distance[p, ]
    lqj <- city_distance[q, ]
    cost_c1 <- (spin[(a - 1), , tr] + spin[ab_p1[a], , tr])
    cost_c2 <- (spin[(b - 1), , tr] + spin[ab_p1[b], , tr])
    cost_c <- 2*sum((-lpj + lqj)*(cost_c1 - cost_c2))/ max_distance

    #量子的コスト
    cost_q1 <- (spin[a, p, tr_m1[tr]] + spin[a, p, tr_p1[tr]])
    cost_q2 <- -(spin[a, q, tr_m1[tr]] + spin[a, q, tr_p1[tr]])
    cost_q3 <- -(spin[b, p, tr_m1[tr]] + spin[b, p, tr_p1[tr]])
    cost_q4 <- (spin[b, q, tr_m1[tr]] + spin[b, q, tr_p1[tr]])
    cost_q <- cost_qr * (cost_q1 + cost_q2 + cost_q3 + cost_q4)

    #合計のコスト
    cost <- cost_c/trotter + cost_q

    #flip
    if(cost <= 0 || runif(1) < exp(-beta * cost)){
      spin[c(a, b), c(p, q), tr] <- spin[c(b, a), c(p, q), tr] #flip
    }

    #戻り値
    return(spin)
  }

  #量子アニーリング(本体)
  distance_tsp <- NULL
  best_distance <- Inf
  best_tsp <- NULL
  best_spin <- NULL
  best_astep <- NULL
  plot_matrix <- NULL
  max_distance <- max(city_distance)

  for(astep in 1:ann_step){
    #mstepによらず変わらない定数を計算しておく。
    cost_qr <- (1/beta) * log(coth(beta * ann_para / trotter))

    for(mstep in 1:mc_step){
      spin <- qmc(spin, city_distance, ncity, max_distance, trotter, cost_qr)
    }
    ann_para <- ann_para * reduc

    spin_distance <- tr_all_distance(spin, city_distance)
    min_spin_distance <- min(spin_distance)
    distance_tsp <- c(distance_tsp, min_spin_distance)

    #もし、最小値があった場合、spinを保存
    if(min_spin_distance < best_distance){
      best_distance <- min_spin_distance
      best_tr <- which(spin_distance == min_spin_distance)
      best_spin <- spin[, , best_tr]
      best_astep <- astep
      route_flg <- TRUE
    }

    #現時点での最良値
    best_tsp <- c(best_tsp, best_distance)

    #最良値の経路表示
    if(route && route_flg){
      route_res <- list()
      route_res$best$spin <- best_spin
      route_res$best$tsp <- best_tsp
      route_res$position$x <- x
      route_res$position$y <- y
      route(route_res)
      route_flg <- FALSE
    }

    #経過表示
    if(trace && !route){
      plot_matrix <- rbind(plot_matrix, matrix(c(min_spin_distance, best_distance), 1 , 2))
      matplot(c(1:astep), plot_matrix, type = "l",
              xlab = "Annealing step", ylab = "Total distance")
      legend("bottomleft", legend = round(best_distance, 2), bty  = "n")
    }
  }

  #戻り値
  ret <- list()

  ret$distance <- distance_tsp
  ret$best$tsp <- best_tsp
  ret$best$spin <- best_spin
  ret$best$astep <- best_astep

  ret$para$beta <- beta
  ret$para$trotter <- trotter
  ret$para$ann_para <- ann_para0
  ret$para$ann_step <- ann_step
  ret$para$mc_step <- mc_step
  ret$para$reduc <- reduc
  ret$para$time <- (proc.time() - t0)[3]

  ret$position$x <- x
  ret$position$y <- y

  ret$city_distance <- city_distance

  class(ret) <- "qatsp"

  return(ret)
}

#アニーリングステップと総距離の推移グラフ
plot.qatsp <- function(result){
  min_distance_tsp <- result$distance
  for(a in 2:length(result$distance)){
    if(min_distance_tsp[a] > min_distance_tsp[a - 1]){
      min_distance_tsp[a] <- min_distance_tsp[a - 1]
    }
  }
  plot_matrix <- matrix(c(result$distance, min_distance_tsp),result$para$ann_step, 2)
  matplot(c(1:result$para$ann_step), plot_matrix, type = "l",
          xlab = "Annealing step", ylab = "Total distance")
}

#経路を表示
route <- function(result, graph = TRUE){
  best_spin <- as.matrix(result$best$spin)
  ret <- NULL
  ncity <- length(best_spin[, 1])
  for(t in 1:ncity){
    ret <- c(ret, which(best_spin[t, ] == 1))
  }
  #graph = TRUEで経路をグラフ表示。FALSEで経路の番号を返す。
  if(graph){
    x <- result$position$x
    y <- result$position$y
    xplot <- x[c(ret, ret[1])]
    yplot <- y[c(ret, ret[1])]
    plot(xplot, yplot, type = "o", asp = 1, xlab = "x", ylab = "y")
    legend("topright", legend = round(min(result$best$tsp), 2) , bty = "n")
  }else{
    return(ret)
  }
}

#結果一覧表示
summary.qatsp <- function(result){
  ret <- route(result, graph = FALSE)
  cat("Quantum annealing for traveling salesman problem.\n\n")
  cat("This is the shortest path obtained by this quantum annealing.\n")
  cat(ret)
  cat("\n\n")

  cat("The length of this route is ")
  cat(min(result$best$tsp))
  cat("\n(The annealing step where the optimum result was obtained is ")
  cat(result$best$astep)
  cat(")\n\n")

  cat("Inverse Temperature : ")
  cat(result$para$beta)
  cat("\nTrotter Dimension : ")
  cat(result$para$trotter)
  cat("\nInitial annealing parameter : ")
  cat(result$para$ann_para)
  cat("\nAnnealing step : ")
  cat(result$para$ann_step)
  cat("\nMonte Carlo step : ")
  cat(result$para$mc_step)
  cat("\nAn attenuation factor of the annealing parameter : ")
  cat(result$para$reduc)

  cat("\n\nCalculation time : ")
  cat(result$para$time)
  cat(" sec.")
}




