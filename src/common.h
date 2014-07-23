//
//  common.h
//  
//
//  Created by Matanya Horowitz on 7/18/14.
//
//

#ifndef _common_h
#define _common_h
#include <Eigen/Dense>
#include <Eigen/Core>
#include <Eigen/SparseCore>
#include <Eigen/Sparse>

#include "pcl/kdtree/impl/kdtree_flann.hpp" 

#include <pcl/point_cloud.h>
#include <pcl/point_types.h>

typedef Eigen::Matrix<float,3,Eigen::Dynamic> DMat;
typedef pcl::PointXYZ PointT;

struct SolverSettings {
    int metric; //P2P Analytic, P2P CVX, P2Plane CVX
    bool outlierRejection;
    float tolerance;
    int parallelSolvers;
    //Todo: Pass a function for evaluating correspondence metric (for keypoints).
    int options; //For analytic solution: 0 - ADMM, 1 - dual decomposition
                 //For Cvx solution:
};

#endif
