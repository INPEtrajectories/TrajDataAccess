setGeneric(
  name = "makeSTBox",
  def = function(envelope, period)
  {
    loadPackages()
    standardGeneric("makeSTBox")

  }

)

##converts Envelope and Period into an STBOX
setMethod(
  f = "makeSTBox",
  signature = c("Envelope","Period"),
  definition = function(envelope, period)
  {
    loadPackages()
    stbox <- STBox( tMin = period@tMin,
                    tMax = period@tMax,
                    tZone = period@tZone,
                    xMax = envelope@xMax,
                    yMax = envelope@yMax,
                    xMin = envelope@xMin,
                    yMin = envelope@yMin,
                    srid = envelope@srid)


       return (stbox)
  }
)
