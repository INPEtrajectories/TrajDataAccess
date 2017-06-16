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
  name = "getTrajectoryBySTBox",
  def = function(datasource, trajectorydataset, envelope, period)
  {
    loadPackages()
    standardGeneric("getTrajectoryBySTBox")

  }

)

#setGeneric(
#  name = "getTrajectoryBySTBox",
#  def = function(datasource, trajectorydataset, stbox)
#  {
 #   loadPackages()
 #   standardGeneric("getTrajectoryBySTBox")
#
#  }
#
#)

setGeneric(
  name = "getTrajectoryByTrack",
  def = function(datasource, trajectorydataset, trackReference,extraspace)
  {
    loadPackages()
    standardGeneric("getTrajectoryByTrack")

  }

)

setGeneric(
  name = "getBigTrajectory",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("getBigTrajectory")

  }

)


setGeneric(
  name = "getBigTrajectoryPart",
  def = function(xptr)
  {
    loadPackages()
    standardGeneric("getBigTrajectoryPart")

  }

)

setGeneric(
  name = "getBigTrajectoryPartDB",
  def = function(datasource, trajectorydataset,part,divisions)
  {
    loadPackages()
    standardGeneric("getBigTrajectoryPartDB")

  }

)
setGeneric(
  name = "getTrajectoryByIDList",
  def = function(datasource, trajectorydataset, id)
  {
    loadPackages()
    standardGeneric("getTrajectoryByIDList")

  }

)

setGeneric(
  name = "getTrajectoryByTrajectoryID",
  def = function(datasource, trajectorydataset, id)
  {
    loadPackages()
    standardGeneric("getTrajectoryByTrajectoryID")

  }

)

##testing method to verfiy if trajectories are loadable
setMethod(
  f = "LoadTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);
    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
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
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
    if(datasource@type=="OGR"){
      traj1 <- getTrajectoryByTerralib(dsource,dset)
      return (TerraLibTrajToTracks(traj1))
    }
    else{
      traj1 <- getSubTrajectoryByTerralibTraj(dsource,dset)
      trackslist <- TerraLibTrajToTracks(traj1)
      #if(length(trackslist)>0){
      return(trackslist)
    }
  }
)

##Given a datasource and a dataset brings all tracks.
setMethod(
  f = "getSubTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
    traj1 <- getSubTrajectoryByTerralibTraj(dsource,dset)
    trackslist <- TerraLibTrajToTracks(traj1)
    #if(length(trackslist)>0){
    return(trackslist)
    #}
    #return("Invalid")
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
  f = "getTrajectoryBySTBox",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","list","list"),
  definition = function(datasource, trajectorydataset,envelope,period)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
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
      return(trackslist)
    }
    return("Invalid")
  }
)

##Given a Track ,a list for the Datasource and a list for the Dataset it brings back all tracks that intersect
##the given Track plus an extra space.
setMethod(
  f = "getTrajectoryByTrack",
  signature = c("list","list","Track","numeric"),
  definition = function(datasource, trajectorydataset,trackReference,extraspace)
  {
    loadPackages()

    bbox <- trackReference@sp@bbox + extraspace
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=stbox["min","time"],"end"=stbox["max","time"])

    traj1 <- getTrajectoryByTerralibStBox(datasource,trajectorydataset,envelope,period)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(trackslist)
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
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
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
      return(trackslist)
    }
    return("Invalid")
  }
)

##Given a Track ,a Datasource and a Dataset it brings back all tracks that intersect
##the given Track plus an extra space.
setMethod(
  f = "getTrajectoryByTrack",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","Track","numeric"),
  definition = function(datasource, trajectorydataset,trackReference,extraspace)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)
    bbox <- trackReference@sp@bbox
    #Adjust so points outside stbox but relevant will be caught
    bbox[[1,1]]<-bbox[[1,1]]-extraspace
    bbox[[2,1]]<-bbox[[2,1]]-extraspace
    bbox[[1,2]]<-bbox[[1,2]]+extraspace
    bbox[[2,2]]<-bbox[[2,2]]+extraspace
    envelope <- list("min"=list("x"=bbox[1,1],"y"=bbox[2,1]),"max"=list("x"=bbox[1,2],"y"=bbox[2,2]))
    stbox <- stbox(trackReference)
    period <-list("begin"=as.character(stbox["min","time"]),"end"=as.character(stbox["max","time"]))

    traj1 <- getTrajectoryByTerralibStBox(dsource,dset,envelope,period)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(trackslist)
    }
    return("Invalid")
  }
)

##Given an envelope, a period ,a Datasource and a trajectorydataset it brings back all tracks that intersect
##the given STBOX.
setMethod(
  f = "getTrajectoryBySTBox",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","Envelope","Period"),
  definition = function(datasource, trajectorydataset,envelope,period)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    env <- list("min"=list("x"=envelope@xMin,"y"=envelope@yMin),"max"=list("x"=envelope@xMax,"y"=envelope@yMax))
    per <-list("begin"=period@tMin,"end"=period@tMax)

    if(datasource@type=="OGR"){
      traj1 <- getTrajectoryByTerralibStBox(dsource,dset,env,per)
      return (TerraLibTrajToTracks(traj1))
    }
    else{
      traj1 <- getTrajectoryByTerralibStBox(dsource,dset,env,per)
      trackslist <- TerraLibTrajToTracks(traj1)
      #if(length(trackslist)>0){
      return(trackslist)
    }
    return("Invalid")
    #return (traj1)
  }
)


##Given a STBox ,a Datasource and a trajectorydataset it brings back all tracks that intersect
##the given STBOX.
setMethod(
  f = "getTrajectoryBySTBox",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","STBox","missing"),
  definition = function(datasource, trajectorydataset,envelope,period)
  {
    stbox<-envelope
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    env <- list("min"=list("x"=stbox@xMin,"y"=stbox@yMin),"max"=list("x"=stbox@xMax,"y"=stbox@yMax))
    per <-list("begin"=stbox@tMin,"end"=stbox@tMax)

    if(datasource@type=="OGR"){
      traj1 <- getTrajectoryByTerralibStBox(dsource,dset,env,per)
      return (TerraLibTrajToTracks(traj1))
    }
    else{
      traj1 <- getTrajectoryByTerralibStBox(dsource,dset,env,per)
      trackslist <- TerraLibTrajToTracks(traj1)
      #if(length(trackslist)>0){
      return(trackslist)
    }
    return("Invalid")
    #return (traj1)
  }
)

##Given a datasource and a trajectorydataset brings a XPTR.
setMethod(
  f = "getBigTrajectory",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    traj1 <- getTrajectoryByTerralibXPtr(dsource,dset)
    return (traj1)

  }
)

##Given a datasource and a trajectorydataset brings a XPTR.
setMethod(
  f = "getBigTrajectoryPart",
  signature = c("externalptr"),
  definition = function(xptr)
  {
    loadPackages()

    traj1 <- getPartsXPTR(xptr,2)
    return (TerraLibTrajToTracks(traj1))

  }
)

##Given a datasource and a trajectorydataset brings a XPTR.
setMethod(
  f = "getBigTrajectoryPartDB",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","numeric","numeric"),
  definition = function(datasource, trajectorydataset,part,divisions)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    traj1 <- getSpecificPartsDB(dsource,dset,part,divisions)
    return (traj1)

  }
)

##Given a datasource and brings the ID Trajectory.
setMethod(
  f = "getTrajectoryByIDList",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","list"),
  definition = function(datasource, trajectorydataset,id)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    traj1 <- getTrajectoryByObjIDList(dsource,dset,id)
    trackslist <- TerraLibTrajToTracks(traj1)
    if(length(trackslist)>0){
      return(trackslist)
    }
    return("Invalid")

  }
)

##Given a datasource and brings the ID Trajectory.
setMethod(
  f = "getTrajectoryByTrajectoryID",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","character"),
  definition = function(datasource, trajectorydataset,id)
  {
    loadPackages()
    datasource<-returnDSOITLReady(datasource);

    dsource <- list("connInfo"=datasource@connInfo,
                    "title"=datasource@title,
                    "accessDriver"=datasource@accessDriver,
                    "type"=datasource@type)


    dset <- list("tableName"=trajectorydataset@dataSetName,
                 "phTimeName"=trajectorydataset@phTimeName,
                 "geomName"=trajectorydataset@geomName,
                 "trajId"=trajectorydataset@trajId,
                 "trajName"=trajectorydataset@trajName,
                 "objId"=trajectorydataset@objId)

    traj1 <- getTrajectoryByTrajID(dsource,dset,id)
    trackslist <- TerraLibTrajToTracks(traj1)

    if(length(trackslist)>0){
      return(trackslist)
    }
    return("Invalid")

  }
)
