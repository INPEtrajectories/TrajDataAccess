setGeneric(
  name = "getNeededDivisions",
  def = function(datasource, trajectorydataset)
  {
    loadPackages()
    standardGeneric("getNeededDivisions")

  })
  ##Given a datasource and a trajectorydataset tells the ideal number of
  ##divisions so the data won't crash the system.
  setMethod(
    f = "getNeededDivisions",
    signature = c("DataSourceInfo","TrajectoryDataSetInfo"),
    definition = function(datasource, trajectorydataset)
    {
      loadPackages()
      dsource<-returnDSOITLReady(datasource);

      os <- Sys.info()['sysname'][1]
      if(dsource@type=="OGR"){

      }
      else{
      if(os=="Linux"){
        mem <- system("awk '/MemTotal/ {print $2}' /proc/meminfo", intern = TRUE )
      }
        else{
          mem <- memory.size()
        }
        query <- paste("SELECT pg_size_pretty(pg_relation_size(relid)) FROM pg_catalog.pg_statio_user_tables Where relname = '", trajectorydataset@tableName,"' ;",sep="" )
        drv <- dbDriver("PostgreSQL")
        con <- dbConnect(drv, dbname = datasource@db,
        host = datasource@host, port = datasource@port,
        user = datasource@user, password = datasource@password)
        dbExistsTable(con, trajectorydataset@tableName)
        df_postgres <- dbGetQuery(con, query)
        tablesizechar <- unlist(strsplit(df_postgres[[1]], " ", fixed = TRUE))
        tablesize <- as.numeric(tablesizechar[[1]])
        if(tablesizechar[[2]]=="MB"){
          tablesize <- tablesize*1000;
        }
        if(tablesizechar[[2]]=="GB"){
          tablesize <- tablesize*1000*1000;
        }

        freeram <- as.numeric(mem)
        idealSize <- (tablesize*5)/(freeram*0.18)
        return(ceiling(idealSize))
      }
      }

  )
