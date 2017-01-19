setGeneric(
  name = "getIdealBoxes",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("getIdealBoxes")

  })
##Given a datasource and a trajectorydataset tells the ideal number of
##divisions so the data won't crash the system.
setMethod(
  f = "getIdealBoxes",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
  definition = function(datasource, trajectorydataset)
  {
    loadPackages()
    dsource<-returnDSOITLReady(datasource);

    os <- Sys.info()['sysname'][1]
    if(dsource@type=="OGR"){

    }
    else{
      divisions = getNeededDivisions(datasource,trajectorydataset)
      query <- paste("SELECT ST_AsText(ST_SetSRID(ST_Extent(",trajectorydataset@geomName,"),4326)) as table_extent, max(",trajectorydataset@phTimeName,"), min(",trajectorydataset@phTimeName,") FROM ", trajectorydataset@tableName,";",sep="" )
      drv <- dbDriver("PostgreSQL")
      con <- dbConnect(drv, dbname = datasource@db,
                       host = datasource@host, port = datasource@port,
                       user = datasource@user, password = datasource@password)
      print( dbExistsTable(con, trajectorydataset@tableName) )
      print(query)
      df_postgres <- dbGetQuery(con, query)
      tmax <- as.character(df_postgres[[2]])
      tmin <- as.character(df_postgres[[3]])
      tablesizechar <- unlist(strsplit(df_postgres[[1]], " ", fixed = TRUE))
      tablesizechar <- unlist(strsplit(tablesizechar, ",", fixed = TRUE))
      tablesizechar <- unlist(strsplit(tablesizechar, " ", fixed = TRUE))
      xmin <- tablesizechar[[3]]
      ymin <- tablesizechar[[2]]
      xmax <- tablesizechar[[5]]
      ymax <- tablesizechar[[4]]

      print(ymax)
      dy<- abs((as.numeric(ymax)-as.numeric(ymin))/divisions)
      query <- paste("SELECT count(*)
FROM ",trajectorydataset@tableName,"
WHERE
",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
ST_MakeEnvelope(",xmin,",",ymin,",",xmax,",", ymax,");",sep="" )
      print(query)
      df_postgres <- dbGetQuery(con, query)

      totalRegister <- as.numeric(df_postgres[[1]])
      minSearchedRegister<-((totalRegister/divisions)*0.9)
      maxSearchedRegister<-((totalRegister/divisions)*1.1)
      generalymax<- ymax
      listofextremes <-list()
      for (m in 1:divisions){
        if(m==1){
          finalymin <- ymin}
        ymin<-finalymin
        topymax <- generalymax
        finalymax <- generalymax
        previousRegister <- 0
        foundBBox=FALSE
        ig = 1
        ymax<- as.character(as.numeric(ymin)+dy)
        while(foundBBox==FALSE&&ig<25){
          il = 1


          query <- paste("SELECT count(*)
FROM ",trajectorydataset@tableName,"
WHERE
",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
        ST_MakeEnvelope(",xmin,",",ymin,",",xmax,",", ymax,");",sep="" )
          df_postgres <- dbGetQuery(con, query)
          presentRegister <- as.numeric(df_postgres[[1]])
          if(m==divisions){
            foundBBox = TRUE
            finalymax=generalymax

          }
          else if((presentRegister+previousRegister)>minSearchedRegister && (presentRegister+previousRegister)<maxSearchedRegister){
            foundBBox = TRUE
            finalymax=ymax
          }
          else if ((presentRegister+previousRegister)<minSearchedRegister){
            ymin <- ymax
            ymax <- as.numeric(ymax)+dy
            if(ymax>as.numeric(topymax))
            {
              ymax <- as.numeric(topymax)
            }
            ymax <- as.character(ymax)
            previousRegister <- presentRegister+previousRegister
            print("new ymin")
            print(ymin)

          }
          else if((presentRegister+previousRegister)>maxSearchedRegister){
            topymax<-ymax
            ymax<-as.character((as.numeric(ymax)+as.numeric(ymin))/2)
            print("new ymax")
            print(ymax)
          }

          print("Iteração")
          print(ig)
          ig<-ig+1
        }
        print(m)
        stBox <- STBox(tMax=tmax,tMin=tmin,yMax=as.numeric(finalymax),yMin=as.numeric(finalymin),
                       xMax=as.numeric(xmax),xMin=as.numeric(xmin),srid="4326")
        listofextremes<-c(listofextremes,stBox)
        finalymin<-finalymax


      }
      return (listofextremes)
    }
  }

)
