setGeneric(
  name = "plotTracks",
  def = function(list,color,addonmap)
  {
    loadPackages()
    standardGeneric("plotTracks")

  }

)


setMethod(
  f = "plotTracks",
  signature = c("list","character","logical"),
  definition = function(list,color,addonmap)
  {
    loadPackages()
    lleng <- length(list)
    if(lleng>=1){
      if(addonmap){
    for(i in 1:lleng){
      plot(list[[i]],col=color,add=T)
    }}
      else{
        plot(list[[1]],col=color)
        if(lleng>=2){
        for(i in 2:lleng){
          plot(list[[i]],col=color,add=T)
        }

        }
      }

      }
    return (TRUE)
  }
)
