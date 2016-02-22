// Examples
#include "ExemploDeAcesso.h"

// TerraLib
#include <terralib/common.h>
#include <terralib/dataaccess.h>
//#include <terralib/geometry.h>
#include <terralib/st.h>

// STL
#include <iostream>

void TrajectoryExamples()
{
  try
  {
    //Output container
    boost::ptr_vector<te::st::TrajectoryDataSet> output;

    //Load the trajectories from a KML Data Source
    LoadTrajectoryDataSetFromKML(output);

    //Get the trajectories from the trajectory data sets to execute other operations
    boost::ptr_vector<te::st::Trajectory> trajectories;
    for(std::size_t i=0; i<output.size(); ++i)
    {
      te::st::TrajectoryDataSet& ds = output[i];
      ds.moveBeforeFirst();
      std::auto_ptr<te::st::Trajectory> tj = ds.getTrajectory();
      trajectories.push_back(tj);
    }


  }

  catch(const std::exception& e)
  {
    std::cout << std::endl << "An exception has occurred in TrajectoryExamples: " << e.what() << std::endl;
  }
  catch(...)
  {
    std::cout << std::endl << "An unexpected exception has occurred in TrajectoryExamples!" << std::endl;
  }
}

