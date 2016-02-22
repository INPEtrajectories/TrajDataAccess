setGeneric(
  name = "getTrajectory",
  def = function(datasource, dataset)
  {
    loadPackages()
    standardGeneric("getTrajectory")

  }

)

setGeneric(
  name = "getTrajectoryByStBox",
  def = function(datasource, dataset, envelope, period)
  {
    loadPackages()
    standardGeneric("getTrajectoryByStBox")

  }

)

setGeneric(
  name = "getTrajectoryByTrack",
  def = function(datasource, dataset, trackReference)
  {
    loadPackages()
    standardGeneric("getTrajectoryByTrack")

  }

)

setMethod(
  f = "getTrajectory",
  signature = c("DataSourceInfo","DataSetInfo"),
  definition = function(datasource, dataset)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=dataset@tableName,
                 "phTimeName"=dataset@phTimeName,
                 "geomName"=dataset@geomName,
                 "trajId"=dataset@trajId,
                 "trajName"=dataset@trajName,
                 "objId"=dataset@trajName)
    traj1 <- getTrajectoryByTerralib(dsource,dset)
    return (traj1)
  }
)


setMethod(
  f = "getTrajectory",
  signature = c("list","list"),
  definition = function(datasource, dataset)
  {
    loadPackages()
    traj1 <- getTrajectoryByTerralib(datasource,dataset)
    return (TerraLibTrajToTrack(traj1))
  }
)

setMethod(
  f = "getTrajectoryByStBox",
  signature = c("list","list","list","list"),
  definition = function(datasource, dataset,envelope,period)
  {
    loadPackages()
    traj1 <- getTrajectoryByTerralibStBox(datasource,dataset,envelope,period)
    return (TerraLibTrajToTrack(traj1))
  }
)

setMethod(
  f = "getTrajectoryByTrack",
  signature = c("list","list","Track"),
  definition = function(datasource, dataset,trackReference)
  {
    loadPackages()

    bbox <- trackReference@sp@bbox
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=stbox["min","time"],"end"=stbox["max","time"])

    traj1 <- getTrajectoryByTerralibStBox(datasource,dataset,envelope,period)
    return (TerraLibTrajToTrack(traj1))
  }
)

setMethod(
  f = "getTrajectoryByTrack",
  signature = c("DataSourceInfo","DataSetInfo","Track"),
  definition = function(datasource, dataset,trackReference)
  {
    loadPackages()
    dsource <-toList(datasource)
    dset <-toList(dset)
    bbox <- trackReference@sp@bbox
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=stbox["min","time"],"end"=stbox["max","time"])

    traj1 <- getTrajectoryByTerralibStBox(dsource,dset,envelope,period)
    return (TerraLibTrajToTrack(traj1))
  }
)



