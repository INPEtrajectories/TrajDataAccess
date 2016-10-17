setGeneric(name="returnDSOITLReady",
           def=function(dsoi)
           {
             standardGeneric("returnDSOITLReady")
           }
)

setMethod(f="returnDSOITLReady",
          signature="DataSourceInfo",
          definition=function(dsoi)
          {
            if(dsoi@path==""&&dsoi@db!=""){
             if(dsoi@dbtype=="POSTGIS"||dsoi@dbtype==""){
               conninfo = list("PG_HOST"=dsoi@host,"PG_PORT"=dsoi@port,"PG_USER"=dsoi@user,
                              "PG_PASSWORD"=dsoi@password,"PG_DB_NAME"=dsoi@db,
                              "PG_CONNECT_TIMEOUT"=dsoi@timeout,"PG_CLIENT_ENCODING"=dsoi@encoding)
             dsoitlr = DataSourceInfoTLReady(connInfo=conninfo,type="POSTGIS",accessDriver=dsoi@accessDriver,title=dsoi@title)
             }
              ####Add other Data sources
             else if(dsoi@dbtype!="POSTGIS"){
                conninfo = list("PG_HOST"=dsoi@host,"PG_PORT"=dsoi@port,"PG_USER"=dsoi@user,
                                "PG_PASSWORD"=dsoi@password,"PG_DB_NAME"=dsoi@db,
                                "PG_CONNECT_TIMEOUT"=dsoi@timeout,"PG_CLIENT_ENCODING"=dsoi@encoding)
                dsoitlr = DataSourceInfoTLReady(connInfo=conninfo,type="POSTGIS",accessDriver=dsoi@accessDriver,title=dsoi@title)
              }


             }else{
              conninfo = list("URI"=dsoi@path)
              dsoitlr = DataSourceInfoTLReady(connInfo=conninfo,type="OGR",accessDriver=dsoi@accessDriver,title=dsoi@title)

            }
            return(dsoitlr)
          }
)
