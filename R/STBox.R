STBox <- setClass(
  # Set the name for the class
  "STBox",

  # Define the slots
  slots = c(
    tMin = "character",
    tMax = "character",
    tZone = "character",
    xMax = "numeric",
    yMax = "numeric",
    xMin = "numeric",
    yMin = "numeric" ,
    srid = "character"
  ),

  prototype=list(
    tMin = "1900-01-01 00:00:01",
    tMax = "1900-01-01 00:00:02",
    tZone = "BRST",
    xMax = 0,
    yMax = 0,
    xMin = 0,
    yMin = 0 ,
    srid = ""
  )

)
