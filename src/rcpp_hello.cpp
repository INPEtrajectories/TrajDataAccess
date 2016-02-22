
// TerraLib
#include <terralib/common.h>
#include <terralib/dataaccess.h>
#include <terralib/st.h>
#include <terralib/plugin.h>
#include <terralib/stmemory.h>
#include <terralib/datatype.h>


// STL
#include <cassert>
#include <cstdlib>
#include <exception>
#include <iostream>

// Boost
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/shared_ptr.hpp>

//Rcpp Para Tipos proprios
#include<RcppCommon.h>

//Meu Header
#include "ExemploDeAcesso.h"

//Definir os membros da classe serão tratados
namespace Rcpp{
template<> SEXP wrap (const te::st::Trajectory &tj);
}

//Rcpp
#include <Rcpp.h>

namespace Rcpp{
//defino como o R tratara uma geometria
template<> SEXP wrap(const te::st::TrajectoryDataSet &tj){
  double x;
  double y;
  std::string tempo;
  int srid;
  Rcpp::List listaDePontos;


    std::auto_ptr<te::dt::DateTime> time = tj.getTime();
    std::auto_ptr<te::gm::Geometry> geom = tj.getGeometry();

    if(geom->getGeometryType()=="Point"){

      te::gm::Point* coordenadas = (dynamic_cast<te::gm::Point*> (geom.get()));

      x = (coordenadas->getX());
      y = (coordenadas->getY());
      srid = (coordenadas->getSRID());

    }
  else{
    return Rcpp::wrap("Not a Point");
  }
    tempo = (time->toString());



  listaDePontos.push_back(tempo,"time");
  listaDePontos.push_back(x,"x");
  listaDePontos.push_back(y,"y");
  listaDePontos.push_back(srid,"srid");
return Rcpp::wrap(listaDePontos);
}
}

using namespace Rcpp;


// [[Rcpp::export]]
SEXP getTrajectoryFromKML(){

  TerraLib::getInstance().initialize();

  //Load Modules and Plugins
  LoadModules();

  //Initialize STDataLoader support
  te::st::STDataLoader::initialize();

  //Examples of trajectories
  //TrajectoryExamples();
  ////////////////////COMEÇO DO CODIGO
     try
    {
      //Indicates the data source
      te::da::DataSourceInfo dsinfo;

      std::map<std::string, std::string> connInfo;
       connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
      //connInfo["URI"] = URI;
      dsinfo.setConnInfo(connInfo);
      dsinfo.setType("OGR");

      //It creates a new Data Source and put it into the manager
      CreateDataSourceAndUpdateManager(dsinfo);

      //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
      //int phTimeIdx = 3;  /* property name: timestamp */
      std::string phTimeName = "timestamp";
      //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
      std::string geomName = "OGR_GEOMETRY";

      te::st::TrajectoryDataSetInfo tjinfo(dsinfo, "40: locations", phTimeName, geomName, "", "40");
      te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
      dataset->moveBeforeFirst();

      Rcpp::XPtr<te::st::TrajectoryDataSet> dsPtr(dataset);
      return dsPtr;
    }
    catch(const std::exception& e)
    {
      std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
    }
    catch(...)
    {
      std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
    }
    /////////////////////FIM


  //Finalize STDataLoader support
  te::st::STDataLoader::finalize();

  te::plugin::PluginManager::getInstance().unloadAll();

  TerraLib::getInstance().finalize();
return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryFromDB(const std::string& tableName){

  TerraLib::getInstance().initialize();

  //Load Modules and Plugins
  LoadModules();

  //Initialize STDataLoader support
  te::st::STDataLoader::initialize();

  //Examples of trajectories
  //TrajectoryExamples();
  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["PG_CLIENT_ENCODING"] = "CP1252";
    connInfo["PG_CONNECT_TIMEOUT"] = "5";
    connInfo["PG_DB_NAME"] = "vessel_trajectory";
    connInfo["PG_HOST"] = "localhost" ;
    connInfo["PG_PORT"] = "5432" ;
    connInfo["PG_USER"] = "postgres";
    connInfo["PG_PASSWORD"] = "teste2ou3";

    dsinfo.setConnInfo(connInfo);
    dsinfo.setTitle("Barcos");
    dsinfo.setAccessDriver("POSTGIS");
    dsinfo.setType("POSTGIS");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp */
    std::string phTimeName = "datahora";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "ponto";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, tableName, phTimeName, geomName, "id", "664");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    Rcpp::XPtr<te::st::TrajectoryDataSet> dsPtr(dataset);
    return dsPtr;
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM


  //Finalize STDataLoader support
  te::st::STDataLoader::finalize();

  te::plugin::PluginManager::getInstance().unloadAll();

  TerraLib::getInstance().finalize();
  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryKMLAsText(){

   TerraLib::getInstance().initialize();

  //Load Modules and Plugins
  LoadModules();

  //Initialize STDataLoader support
  te::st::STDataLoader::initialize();

  //Examples of trajectories
  //TrajectoryExamples();
  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
    //connInfo["URI"] = URI;
    dsinfo.setConnInfo(connInfo);
    dsinfo.setType("OGR");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp
    std::string phTimeName = "timestamp";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "OGR_GEOMETRY";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, "40: locations", phTimeName, geomName, "", "40");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::map<std::string, std::string> pontos;
    Rcpp::List listaDePontos;


    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();
      pontos["Coords"] = geom->toString();
      pontos["Time"] = time->toString();
      //listaDeTempos.push_back(time->toString());
      listaDePontos.push_back(pontos["Coords"]+" . "+pontos["Time"]);

      // std::cout << "Date and Time: " <<  time->toString() << std::endl;
    //  std::cout << "Geometry: " <<  geom->toString()  << std::endl << std::endl;
    }

      // Rcpp::XPtr<te::st::TrajectoryDataSet> dsPtr(dataset);
  return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM


  //Finalize STDataLoader support
  te::st::STDataLoader::finalize();

  te::plugin::PluginManager::getInstance().unloadAll();

  TerraLib::getInstance().finalize();
  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryKMLAsText2(const std::string& dataset,const std::string& id){

  TerraLib::getInstance().initialize();

  //Load Modules and Plugins
  LoadModules();

  //Initialize STDataLoader support
  te::st::STDataLoader::initialize();
  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
    //connInfo["URI"] = URI;
    dsinfo.setConnInfo(connInfo);
    dsinfo.setType("OGR");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp
    std::string phTimeName = "timestamp";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "OGR_GEOMETRY";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, dataset, phTimeName, geomName, "", id);
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::map<std::string, std::string> pontos;
    Rcpp::List listaDePontos;


    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();
      pontos["Coords"] = geom->toString();
      pontos["Time"] = time->toString();
      listaDePontos.push_back(pontos["Coords"]+" . "+pontos["Time"]);
    }
    return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM


  //Finalize STDataLoader support
  te::st::STDataLoader::finalize();

  te::plugin::PluginManager::getInstance().unloadAll();

  TerraLib::getInstance().finalize();
  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryDBAsText(const std::string& tableName){

  TerraLib::getInstance().initialize();

  //Load Modules and Plugins
  LoadModules();

  //Initialize STDataLoader support
  te::st::STDataLoader::initialize();

  //Examples of trajectories
  //TrajectoryExamples();
  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["PG_CLIENT_ENCODING"] = "CP1252";
    connInfo["PG_CONNECT_TIMEOUT"] = "5";
    connInfo["PG_DB_NAME"] = "vessel_trajectory";
    connInfo["PG_HOST"] = "localhost" ;
    connInfo["PG_PORT"] = "5432" ;
    connInfo["PG_USER"] = "postgres";
    connInfo["PG_PASSWORD"] = "teste2ou3";

    dsinfo.setConnInfo(connInfo);
    dsinfo.setTitle("Barcos");
    dsinfo.setAccessDriver("POSTGIS");
    dsinfo.setType("POSTGIS");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp */
    std::string phTimeName = "datahora";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "ponto";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, tableName, phTimeName, geomName, "id", "664");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::map<std::string, std::string> pontos;
    Rcpp::List listaDePontos;
    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();
      pontos["Coords"] = geom->toString();
      pontos["Time"] = time->toString();
     // listaDePontos.push_back(time->toString(),geom->toString());
      listaDePontos.push_back(pontos["Coords"]+" . "+pontos["Time"]);
      // std::cout << "Date and Time: " <<  time->toString() << std::endl;
      //  std::cout << "Geometry: " <<  geom->toString()  << std::endl << std::endl;
    }
    ///////////////

    // Rcpp::XPtr<te::st::TrajectoryDataSet> dsPtr(dataset);
    return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM


  //Finalize STDataLoader support
  te::st::STDataLoader::finalize();

  te::plugin::PluginManager::getInstance().unloadAll();

  TerraLib::getInstance().finalize();
  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryKMLAsVectorList(){

  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
    dsinfo.setConnInfo(connInfo);
    dsinfo.setType("OGR");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp
    std::string phTimeName = "timestamp";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "OGR_GEOMETRY";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, "40: locations", phTimeName, geomName, "", "40");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::vector<double> x;
    std::vector<double> y;
    std::vector<std::string> tempo;
    std::vector<int> srid;
    Rcpp::List listaDePontos;


    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();

      if(geom->getGeometryType()=="Point"){

        te::gm::Point* coordenadas = (dynamic_cast<te::gm::Point*> (geom.get()));

        x.push_back(coordenadas->getX());
        y.push_back(coordenadas->getY());
        srid.push_back(coordenadas->getSRID());

      }

      tempo.push_back(time->toString());

    }

    listaDePontos.push_back(tempo,"time");
    listaDePontos.push_back(x,"x");
    listaDePontos.push_back(y,"y");
    listaDePontos.push_back(srid,"srid");

    return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM

  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryGivenKMLAsVectorList(const std::string& selected, const std::string& name){

  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
    dsinfo.setConnInfo(connInfo);
    dsinfo.setType("OGR");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp
    std::string phTimeName = "timestamp";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "OGR_GEOMETRY";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, selected, phTimeName, geomName, "", name);
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::vector<double> x;
    std::vector<double> y;
    std::vector<std::string> tempo;
    std::vector<int> srid;
    Rcpp::List listaDePontos;


    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();

      if(geom->getGeometryType()=="Point"){

        te::gm::Point* coordenadas = (dynamic_cast<te::gm::Point*> (geom.get()));

        x.push_back(coordenadas->getX());
        y.push_back(coordenadas->getY());
        srid.push_back(coordenadas->getSRID());

      }

      tempo.push_back(time->toString());

    }

    listaDePontos.push_back(tempo,"time");
    listaDePontos.push_back(x,"x");
    listaDePontos.push_back(y,"y");
    listaDePontos.push_back(srid,"srid");

    return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM

  return Rcpp::wrap("Fail");
}

// [[Rcpp::export]]
SEXP getTrajectoryDBAsVectorList(const std::string& tableName){

  //Examples of trajectories
  //TrajectoryExamples();
  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["PG_CLIENT_ENCODING"] = "CP1252";
    connInfo["PG_CONNECT_TIMEOUT"] = "5";
    connInfo["PG_DB_NAME"] = "RTestDB";
    connInfo["PG_HOST"] = "localhost" ;
    connInfo["PG_PORT"] = "5432" ;
    connInfo["PG_USER"] = "postgres";
    connInfo["PG_PASSWORD"] = "teste2ou3";

    dsinfo.setConnInfo(connInfo);
    dsinfo.setTitle("Barcos");
    dsinfo.setAccessDriver("POSTGIS");
    dsinfo.setType("POSTGIS");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp */
    std::string phTimeName = "datahora";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "ponto";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, tableName, phTimeName, geomName, "id", "664");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }
    std::vector<double> x;
    std::vector<double> y;
    std::vector<std::string> tempo;
    std::vector<int> srid;
    Rcpp::List listaDePontos;


    while(dataset->moveNext())
    {
      std::auto_ptr<te::dt::DateTime> time = dataset->getTime();
      std::auto_ptr<te::gm::Geometry> geom = dataset->getGeometry();

      if(geom->getGeometryType()=="Point"){

        te::gm::Point* coordenadas = (dynamic_cast<te::gm::Point*> (geom.get()));

        x.push_back(coordenadas->getX());
        y.push_back(coordenadas->getY());
        srid.push_back(coordenadas->getSRID());

      }

      tempo.push_back(time->toString());

    }

    listaDePontos.push_back(tempo,"time");
    listaDePontos.push_back(x,"x");
    listaDePontos.push_back(y,"y");
    listaDePontos.push_back(srid,"srid");

    return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM


 }

////Não funciona
// [[Rcpp::export]]
SEXP getTrajectoryKMLAsListOfLists(){

  ////////////////////COMEÇO DO CODIGO
  try
  {
    //Indicates the data source
    te::da::DataSourceInfo dsinfo;

    std::map<std::string, std::string> connInfo;
    connInfo["URI"] = "/home/diego/Documents/data/st/trajectory/t_40_41.kml" ;
    dsinfo.setConnInfo(connInfo);
    dsinfo.setType("OGR");

    //It creates a new Data Source and put it into the manager
    CreateDataSourceAndUpdateManager(dsinfo);

    //Indicates how the trajectories are stored in the data source -> This structure is fixed for OGR driver
    //int phTimeIdx = 3;  /* property name: timestamp
    std::string phTimeName = "timestamp";
    //int geomIdx = 12;    /* property name: OGR_GEOMETRY */
    std::string geomName = "OGR_GEOMETRY";

    te::st::TrajectoryDataSetInfo tjinfo(dsinfo, "40: locations", phTimeName, geomName, "", "40");
    te::st::TrajectoryDataSet* dataset = te::st::STDataLoader::getDataSet(tjinfo).release();
    dataset->moveBeforeFirst();

    ////////Codigo para mandar como Lista
    if(dataset == 0)
    {
      std::cout << "Trajectory Data Set is NULL!" << std::endl;
      return Rcpp::wrap("DataSet Vazio");
    }

    Rcpp::List listaDePontos;

int i=0;
    while(dataset->moveNext())
    {
    // listaDePontos.push_back(Rcpp::wrap(dataset[i]),"Trajectory");

      i++;
    }

       return (listaDePontos);
  }
  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurried in TrajectoryExamplesFromKML: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurried in TrajectoryExamplesFromKML!" << std::endl;
  }
  /////////////////////FIM

  return Rcpp::wrap("Fail");
}

