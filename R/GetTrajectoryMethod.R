setGeneric(
  name = "LoadTrajectory",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("LoadTrajectory")

  }

)

setGeneric(
  name = "getTrajectory",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("getTrajectory")

  }

)

setGeneric(
  name = "getSubTrajectory",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("getSubTrajectory")

  }

)

setGeneric(
  name = "getTrajectoryByStBox",
  def = function(datasource, trajectorydataset, envelope, period)
  {
    loadPackages()
    standardGeneric("getTrajectoryByStBox")

  }

)

setGeneric(
  name = "getTrajectoryByTrack",
  def = function(datasource, trajectorydataset, trackReference)
  {
    loadPackages()
    standardGeneric("getTrajectoryByTrack")

  }

)
##testing method to verfiy if trajectories are loadable
setMethod(
  f = "LoadTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@tableName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
    LoadTrajectoryDataSetFromPostGIS2(dsource,dset)
    return (TRUE)
  }
)

##Given a datasource and a trajectorydataset brings a track.
setMethod(
  f = "getTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@tableName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@trajName)
    traj1 <- getTrajectoryByTerralib(dsource,dset)
    return (TerraLibTrajToTrack(traj1))
  }
)

##Given a datasource and a dataset brings all tracks.
setMethod(
  f = "getSubTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@tableName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
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
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    traj1 <- getTrajectoryByTerralib(datasource,trajectorydataset)
    return (TerraLibTrajToTrack(traj1))
  }
)


##Given lists for an envelope, a period ,a Datasource and a trajectorydataset it brings back all tracks that intersect
##the given STBOX.
setMethod(
  f = "getTrajectoryByStBox",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","list","list"),
  definition = function(datasource, trajectorydataset,envelope,period)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@tableName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
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
  definition = function(datasource, trajectorydataset,trackReference)
  {
    loadPackages()

    bbox <- trackReference@sp@bbox
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=stbox["min","time"],"end"=stbox["max","time"])

    traj1 <- getTrajectoryByTerralibStBox(datasource,trajectorydataset,envelope,period)
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
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","Track"),
  definition = function(datasource, trajectorydataset,trackReference)
  {
    loadPackages()
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@tableName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
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



