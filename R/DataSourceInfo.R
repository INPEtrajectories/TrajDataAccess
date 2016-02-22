DataSourceInfo <- setClass(
  # Set the name for the class
  "DataSourceInfo",

  # Define the slots
  slots = c(
    connInfo = "list",
    title = "character",
    accessDriver="character",
    type="character"
  )


)
