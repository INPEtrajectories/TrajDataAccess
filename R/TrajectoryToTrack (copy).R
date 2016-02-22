TerraLibTrajToTrack <- function(dado) {
  loadPackages()
  Sys.setlocale("LC_TIME", "en_US.UTF-8")

  dat <- data.frame(x=dado$x,y=dado$y)
  xy <- coordinates(dat)

  #crs = CRS("+proj=longlat +ellps=WGS84") # longlat
  crs = CRS(paste("+init=epsg:",as.character(dado$srid[1]),sep="")) # longlat

  testnovo <- as.POSIXct(dado$time,format="%Y-%b-%d %H:%M:%S")
  sti = STI(SpatialPoints(xy,crs),testnovo,testnovo)
  A1 = Track(sti)
  return(A1)
}

