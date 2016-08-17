Envelope <- setClass(
  # Set the name for the class
  "Envelope",

  # Define the slots
  slots = c(
    xMax = "numeric",
    yMax = "numeric",
    xMin = "numeric",
    yMin = "numeric" ,
    srid = "character"
  ),

  prototype=list(
    xMax = 0,
    yMax = 0,
    xMin = 0,
    yMin = 0 ,
    srid = ""
  )

)
