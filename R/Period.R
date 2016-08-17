Period <- setClass(
  # Set the name for the class
  "Period",

  # Define the slots
  slots = c(
    tMin = "character",
    tMax = "character",
    tZone = "character"
  ),

  prototype=list(
    tMin = "1900-01-01 00:00:01",
    tMax = "1900-01-01 00:00:02",
    tZone = "BRST"
  )

)
