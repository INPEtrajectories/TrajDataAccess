TerraLibTrajToTracks <- function(dado) {
  loadPackages()
  Sys.setlocale("LC_TIME", "en_US.UTF-8")
  trackList <- list()
  tracksList <- list()
if (length(dado)>1&&dado!="Fail"){
  obj_id = dado[[1]]$obj_id[1]
  counter = 1;
  for (i in 1:length(dado)) {
    if (length(dado[[i]]$x) > 1) {
      dat <- data.frame(x = dado[[i]]$x,y = dado[[i]]$y)
      xy <- coordinates(dat)

      obj_id_dat <- data.frame(name = dado[[i]]$obj_id, traj = dado[[i]]$uni_traj_id)

      print(i)
      #crs = CRS("+proj=longlat +ellps=WGS84") # longlat
      crs = CRS(paste("+init=epsg:",as.character(dado[[i]]$srid[1]),sep = "")) # longlat

      testnovo <-
        as.POSIXct(dado[[i]]$time,format = "%Y-%b-%d %H:%M:%S")
      #sti = STI(SpatialPoints(xy,crs),testnovo,testnovo)
      sti = STIDF(SpatialPoints(xy,crs),testnovo,obj_id_dat,testnovo)
      print(dado[[i]]$uni_traj_id)
      print("dei erro aqui?")
      A1 = Track(sti)
      if (obj_id != dado[[i]]$obj_id[1]) {
        print(length(trackList))
        if(length(trackList)>0){
        tracksList <- c(tracksList,Tracks(trackList))}
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
  tracksList <- c(tracksList,Tracks(trackList))
}
  return(tracksList)
}
