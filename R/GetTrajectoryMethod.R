setGeneric(
  name = "LoadTrajectory",
  def = function(datasource, dataset)
  {
    loadPackages()
    standardGeneric("LoadTrajectory")

  }

)

setGeneric(
  name = "getTrajectory",
  def = function(datasource, dataset)
  {
    loadPackages()
    standardGeneric("getTrajectory")

  }

)

setGeneric(
  name = "getSubTrajectory",
  def = function(datasource, dataset)
  {
    loadPackages()
    standardGeneric("getSubTrajectory")

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
##testing method to verfiy if trajectories are loadable
setMethod(
  f = "LoadTrajectory",
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
                 "objId"=dataset@objId)
    LoadTrajectoryDataSetFromPostGIS2(dsource,dset)
    return (TRUE)
  }
)

##Given a datasource and a dataset brings a track.
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
    return (TerraLibTrajToTrack(traj1))
  }
)

##Given a datasource and a dataset brings all tracks.
setMethod(
  f = "getSubTrajectory",
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
                 "objId"=dataset@objId)
    traj1 <- getSubTrajectoryByTerralibTraj(dsource,dset)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
    return(TracksCollection(trackslist))
    }
    return("Invalid")
    #return (traj1)
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


##Given lists for an envelope, a period ,a Datasource and a Dataset it brings back all tracks that intersect
##the given STBOX.
setMethod(
  f = "getTrajectoryByStBox",
  signature = c("DataSourceInfo","DataSetInfo","list","list"),
  definition = function(datasource, dataset,envelope,period)
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
                 "objId"=dataset@objId)
    traj1 <- getTrajectoryByTerralibStBox(dsource,dset,envelope,period)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(TracksCollection(trackslist))
    }
    return("Invalid")
    #return (traj1)
  }
)



##Given a Track ,a list for the Datasource and a list for the Dataset it brings back all tracks that intersect
##the given Track.
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
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(TracksCollection(trackslist))
    }
    return("Invalid")
  }
)

##Given a Track ,a Datasource and a Dataset it brings back all tracks that intersect
##the given Track.
setMethod(
  f = "getTrajectoryByTrack",
  signature = c("DataSourceInfo","DataSetInfo","Track"),
  definition = function(datasource, dataset,trackReference)
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
                 "objId"=dataset@objId)
    bbox <- trackReference@sp@bbox
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=as.character(stbox["min","time"]),"end"=as.character(stbox["max","time"]))

    traj1 <- getTrajectoryByTerralibStBox(dsource,dset,envelope,period)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(TracksCollection(trackslist))
    }
    return("Invalid")
  }
)



