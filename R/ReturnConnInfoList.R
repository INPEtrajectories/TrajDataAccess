setGeneric(name="returnConnInfoList",
           def=function(dsoi)
           {
             standardGeneric("returnConnInfoList")
           }
)

setMethod(f="returnConnInfoList",
          signature="DataSourceInfo",
          definition=function(dsoi)
          {
            if(dsoi@path==""&&dsoi@db!=""){
              connInfo = list("PG_HOST"=dsoi@host,"PG_PORT"=dsoi@port,"PG_USER"=dsoi@user,
                              "PG_PASSWORD"=dsoi@password,"PG_DB_NAME"=dsoi@db,
                              "PG_CONNECT_TIMEOUT"=dsoi@timeout,"PG_CLIENT_ENCODING"=dsoi@encoding)

            }else{
                connInfo = list("URI"=dsoi@path)
              }
            return(connInfo)
          }
)
