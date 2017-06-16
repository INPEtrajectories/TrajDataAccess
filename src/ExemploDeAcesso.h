
#ifndef __TERRALIB_EXAMPLES_STEXAMPLES_INTERNAL_STEXAMPLES_H
#define __TERRALIB_EXAMPLES_STEXAMPLES_INTERNAL_STEXAMPLES_H


/*// TerraLib
#include <terralib/common_fw.h>
#include <terralib/dataaccess_fw.h>
#include <terralib/geometry_fw.h>
#include <terralib/st_fw.h>
*/
// TerraLib
#include <terralib/common.h>
#include <terralib/dataaccess.h>
#include <terralib/geometry.h>
#include <terralib/st.h>

// STL
#include <vector>
#include <string>

// Boost
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/shared_ptr.hpp>


//ST examples
#include "Config.h"

/*!
 \brief It loads the TerraLib modules.
 */
void LoadModules();


/*!
 \brief It creates a new DataSource and put it into the DataSource manager, using a random id.
 */
void CreateDataSourceAndUpdateManager(te::da::DataSourceInfo& dsinfo);
void CreateDataSourceAndUpdateManager2(te::da::DataSourceInfo& dsinfo);
/*!
 \brief It groups the examples with trajectories (TrajectoryExamples.cpp).
 */
void TrajectoryExamples();

/*!
 \brief It loads trajectory data set from KML file
 */
void LoadTrajectoryDataSetFromKML(boost::ptr_vector<te::st::TrajectoryDataSet>& output);

void LoadTrajectoryDataSetFromPostGIS();

#endif  // __TERRALIB_EXAMPLES_STEXAMPLES_INTERNAL_STEXAMPLES_H
