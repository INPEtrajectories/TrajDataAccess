DataSourceInfoTLReady <- setClass(
  # Set the name for the class
  "DataSourceInfoTLReady",

  # Define the slots
  slots = c(
    connInfo = "list",
    title = "character",
    accessDriver="character",
    type="character"
    ),

  prototype=list(
    connInfo = list(),
    title = "",
    accessDriver="",
    type=""

  )

)
