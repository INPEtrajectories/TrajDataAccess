setGeneric(
  name = "getIdealGroupsInSTBox",
  def = function(datasource, trajectorydataset,stbox)
  {
    loadPackages()
    standardGeneric("getIdealGroupsInSTBox")

  })

##Given a datasource and a trajectorydataset tells the ideal number of
##divisions so the data won't crash the system.
setMethod(
  f = "getIdealGroupsInSTBox",
  signature = c("DataSourceInfo","TrajectoryDataSetInfo","STBox"),
  definition = function(datasource, trajectorydataset,stbox)
  {
    loadPackages()
    dsource<-returnDSOITLReady(datasource);

    os <- Sys.info()['sysname'][1]
    if(dsource@type=="OGR"){

    }
    else{
      divisions = getNeededDivisions(datasource,trajectorydataset)
      drv <- dbDriver("PostgreSQL")
      con <- dbConnect(drv, dbname = datasource@db,
                       host = datasource@host, port = datasource@port,
                       user = datasource@user, password = datasource@password)
      on.exit(dbDisconnect(con))

      print( dbExistsTable(con, trajectorydataset@tableName) )
      query <- paste("SELECT count(*) FROM ",trajectorydataset@tableName," WHERE ",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
        ST_MakeEnvelope(",stbox@xMin,",",stbox@yMin,",",stbox@xMax,",", stbox@yMax,")",";",sep="" )
      print(query)

      df_postgres <- dbGetQuery(con, query)
      totalRegister <- as.numeric(df_postgres[[1]])
      idealentries<- as.numeric(df_postgres[[1]])/divisions


      minSearchedRegister<-((idealentries)*0.9)
      maxSearchedRegister<-((idealentries)*1.1)

      query <- paste("select ",trajectorydataset@objId,",count(*) as total from ",trajectorydataset@tableName,"
WHERE
",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
        ST_MakeEnvelope(",stbox@xMin,",",stbox@yMin,",",stbox@xMax,",", stbox@yMax,")"," group by ",trajectorydataset@objId," order by total",sep="" )
      df_postgres <- dbGetQuery(con, query)
      dividedlistofobjs <-list()
      bi <-nrow(df_postgres)
      si <- 1
      for (m in 1:divisions){

        bigside = FALSE
        previousRegister <- 0
        foundBBox=FALSE
        ig = 1
        listofobjs <-list()
        while(foundBBox==FALSE){
          il = 1
          if(bi<si){
            stop("some error in the indexes")
          }

          presentId<-as.character(df_postgres[si,1])
          presentRegister <- as.numeric(df_postgres[si,2])

          if(bigside==TRUE){
            presentId<-as.character(df_postgres[bi,1])
            presentRegister <- as.numeric(df_postgres[bi,2])
          }

          if(m==divisions){
            foundBBox = TRUE
            presentRegister = 0
            for(i in si:bi){
              listofobjs<-c(listofobjs,as.character(df_postgres[i,1]))

            }

          }
          else if((presentRegister+previousRegister)>minSearchedRegister && (presentRegister+previousRegister)<maxSearchedRegister){
            foundBBox = TRUE
            listofobjs<-c(listofobjs,presentId)
          }
          else if ((presentRegister+previousRegister)<minSearchedRegister){
            listofobjs<-c(listofobjs,presentId)
            previousRegister= presentRegister+previousRegister

          }
          else if((presentRegister+previousRegister)>maxSearchedRegister){
            if(bigside==TRUE){
              bi=bi+1
            }
            else{
              si=si-1
              foundBBox = TRUE
            }

          }
          if(bigside==TRUE){
            bi = bi - 1
            bigside=FALSE
          }
          else{
            si = si +1
            bigside=TRUE
          }
          print("Iteração")
          print(ig)
          ig<-ig+1
        }
        print(m)
        dividedlistofobjs<-c(dividedlistofobjs,list(listofobjs))


      }
      ##dbDisconnect(con)

      return (dividedlistofobjs)
    }
  }

)


setMethod(
  f = "getIdealGroupsInSTBox",
  signature = c("PostgreSQLConnection", "TrajectoryDataSetInfo", "STBox"),
  definition = function(datasource, trajectorydataset,stbox)
  {
    loadPackages()

      con <- datasource
      divisions = getNeededDivisions(con,trajectorydataset)



      print( dbExistsTable(con, trajectorydataset@tableName) )
      query <- paste("SELECT count(*) FROM ",trajectorydataset@tableName," WHERE ",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
                     ST_MakeEnvelope(",stbox@xMin,",",stbox@yMin,",",stbox@xMax,",", stbox@yMax,")",";",sep="" )
      print(query)

      df_postgres <- dbGetQuery(con, query)
      totalRegister <- as.numeric(df_postgres[[1]])
      idealentries<- as.numeric(df_postgres[[1]])/divisions


      minSearchedRegister<-((idealentries)*0.9)
      maxSearchedRegister<-((idealentries)*1.1)

      query <- paste("select ",trajectorydataset@objId,",count(*) as total from ",trajectorydataset@tableName,"
                     WHERE
                     ",trajectorydataset@tableName,".",trajectorydataset@geomName," &&
                     ST_MakeEnvelope(",stbox@xMin,",",stbox@yMin,",",stbox@xMax,",", stbox@yMax,")"," group by ",trajectorydataset@objId," order by total",sep="" )
      df_postgres <- dbGetQuery(con, query)
      dividedlistofobjs <-list()
      bi <-nrow(df_postgres)
      si <- 1
      for (m in 1:divisions){

        bigside = FALSE
        previousRegister <- 0
        foundBBox=FALSE
        ig = 1
        listofobjs <-list()
        while(foundBBox==FALSE){
          il = 1
          if(bi<si){
            stop("some error in the indexes")
          }

          presentId<-as.character(df_postgres[si,1])
          presentRegister <- as.numeric(df_postgres[si,2])

          if(bigside==TRUE){
            presentId<-as.character(df_postgres[bi,1])
            presentRegister <- as.numeric(df_postgres[bi,2])
          }

          if(m==divisions){
            foundBBox = TRUE
            presentRegister = 0
            for(i in si:bi){
              listofobjs<-c(listofobjs,as.character(df_postgres[i,1]))

            }

          }
          else if((presentRegister+previousRegister)>minSearchedRegister && (presentRegister+previousRegister)<maxSearchedRegister){
            foundBBox = TRUE
            listofobjs<-c(listofobjs,presentId)
          }
          else if ((presentRegister+previousRegister)<minSearchedRegister){
            listofobjs<-c(listofobjs,presentId)
            previousRegister= presentRegister+previousRegister

          }
          else if((presentRegister+previousRegister)>maxSearchedRegister){
            if(bigside==TRUE){
              bi=bi+1
            }
            else{
              si=si-1
              foundBBox = TRUE
            }

          }
          if(bigside==TRUE){
            bi = bi - 1
            bigside=FALSE
          }
          else{
            si = si +1
            bigside=TRUE
          }
          print("Iteração")
          print(ig)
          ig<-ig+1
        }
        print(m)
        dividedlistofobjs<-c(dividedlistofobjs,list(listofobjs))


      }
      ##dbDisconnect(con)

      return (dividedlistofobjs)

  }

      )
