TrajectoryDataSetInfo <- setClass(
  # Set the name for the class
  "TrajectoryDataSetInfo",

  # Define the slots
  slots = c(
    tableName = "character",
    phTimeName = "character",
    geomName = "character",
    trajId = "character" ,
    trajName = "character",
    objId = "character"
  ),

  prototype=list(
    tableName = "",
    phTimeName = "",
    geomName = "",
    trajId = "" ,
    trajName = "",
    objId = ""
  )


)
