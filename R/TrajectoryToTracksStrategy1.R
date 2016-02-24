TerraLibTrajToTracks <- function(dado) {
  loadPackages()
  Sys.setlocale("LC_TIME", "en_US.UTF-8")
  trackList <- list()
  tracksList <- list()

  obj_id = dado[[1]]$obj_id[1]
  counter = 1;
  for (i in 1:length(dado)) {
    if (length(dado[[i]]$x) > 1) {
      dat <- data.frame(x = dado[[i]]$x,y = dado[[i]]$y)
      xy <- coordinates(dat)

      print(i)
      #crs = CRS("+proj=longlat +ellps=WGS84") # longlat
      crs = CRS(paste("+init=epsg:",as.character(dado[[i]]$srid[1]),sep = "")) # longlat

      testnovo <-
        as.POSIXct(dado[[i]]$time,format = "%Y-%b-%d %H:%M:%S")
      sti = STI(SpatialPoints(xy,crs),testnovo,testnovo)
      A1 = Track(sti)
      if (obj_id != dado[[i]]$obj_id[1]) {
        tracksList <- c(tracksList,Tracks(trackList))
        for (j in counter:1) {
          trackList[[j]] = NULL
        }
        counter = 1
        obj_id = dado[[i]]$obj_id[1]
      }
      trackList[counter] <- A1
      counter = counter + 1
    }
  }

  return(tracksList)
}
