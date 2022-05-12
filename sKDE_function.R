sKDE <- function(U, polygon, optimal = TRUE, h = .1, parallel = FALSE, n_clusters = 4){
  if(!"POLYGON" %in% class(polygon)) stop("Please provide a polygon created with sf::sf_polygon")
  if("data.frame" %in% class(U)) U <- as.matrix(U)
  IND <- which(is.na(U[, 1]) == FALSE)
  U <- U[IND,]
  n <- nrow(U)
  if(optimal){
    H <- Hpi(U, binned = FALSE)
    H <- matrix(c(sqrt(H[1, 1] * H[2, 2]), 0, 0, sqrt(H[1, 1] * H[2, 2])), 2, 2)
  }else{
    H <- matrix(c(h, 0, 0, h), 2, 2)
  }
  
  # Help function to compute weights
  poidsU <- function(i, U, h, POL){
    x <- as.numeric(U[i,])
    sWeights(x, h, POL)
  }
  # Use parallel methods to compute if the number of observation is a bit high
  # Change the number of slaves according to the number of cores your processor has
  # It is recommended to use a maximum of the number of cores minus one.
  if(parallel){
    if(is.null(n_clusters)) n_clusters <- parallel::detectCores()-1
    cl <- makeCluster(n_clusters)
    clusterEvalQ(cl, library(dplyr))
    clusterEvalQ(cl, library(sf))
    clusterExport(cl, c("sCircle", "sWeights"))
    OMEGA <- pblapply(1:n, poidsU, U = U, h = sqrt(H[1, 1]), POL = polygon, cl = cl)
    OMEGA <- do.call("c", OMEGA)
    stopCluster(cl)
  }else{
    OMEGA <- NULL
    for(i in 1:n){
      OMEGA <- c(OMEGA, poidsU(i, U, h = sqrt(H[1, 1]), POL = polygon))
    }
  }
  # Kernel Density Estimator
  fhat <- kde(U, H, w = 1/OMEGA,
              xmin = c(sf::st_bbox(polygon)["xmin"], sf::st_bbox(polygon)["ymin"]),
              xmax = c(sf::st_bbox(polygon)["xmax"], sf::st_bbox(polygon)["ymax"]))
  fhat$estimate <- fhat$estimate * sum(1/OMEGA) / n
  
  vx <- unlist(fhat$eval.points[1])
  vy <- unlist(fhat$eval.points[2])
  VX <- cbind(rep(vx, each = length(vy)))
  VY <- cbind(rep(vy, length(vx)))
  VXY <- cbind(VX, VY)
  
  ind_points_in_poly <-
    sf::st_as_sf(data.frame(x = VX, y = VY), coords = c("x", "y")) %>%
    sf::st_intersects(polygon, sparse = FALSE) %>%
    matrix(length(vy), length(vx))
  
  f0 <- fhat
  f0$estimate[t(ind_points_in_poly) == 0] <- NA
  
  list(
    X = fhat$eval.points[[1]],
    Y = fhat$eval.points[[2]],
    Z = fhat$estimate,
    ZNA = f0$estimate,
    H = fhat$H,
    W = fhat$w)
}# End of sKDE()