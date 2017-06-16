TrajectoryDataSetInfo <- setClass(
  # Set the name for the class
  "TrajectoryDataSetInfo",

  # Define the slots
  slots = c(
    dataSetName = "character",
    phTimeName = "character",
    geomName = "character",
    trajId = "character" ,
    trajName = "character",
    objId = "character"
  ),

  prototype=list(
    dataSetName = "",
    phTimeName = "",
    geomName = "",
    trajId = "" ,
    trajName = "",
    objId = ""
  )


)
